dict <- read.csv('name_dictionary.csv', stringsAsFactors = FALSE)
lookup_table <- dict %>% select(-class)
colnames(lookup_table) <-
  c('variable',  'client_name', 'syntactically_valid_name')

library(stringr)

## based on https://github.com/rstudio/shiny/issues/1237
suppressWarnings(
  try(
    rm("registerShinyDebugHook", envir = as.environment("tools:rstudio")),
    silent = TRUE
  )
)

## function to load/import required packages and functions
import_fs <- function(ns, libs = c(), incl = c(), excl = c()) {
  tmp <- sapply(libs, library, character.only = TRUE); rm(tmp)
  if (length(incl) != 0 || length(excl) != 0) {
    import_list <- getNamespaceImports(ns)
    if (length(incl) == 0)
      import_list[names(import_list) %in% c("base", "methods", "stats", "utils", libs, excl)] <- NULL
    else
      import_list <- import_list[names(import_list) %in% incl]
    import_names <- names(import_list)

    for (i in seq_len(length(import_list))) {
      fun <- import_list[[i]]
      lib <- import_names[[i]]
      ## replace with character.only option when new version of import is posted to CRAN
      ## https://github.com/smbache/import/issues/11
      eval(
        parse(text =
          paste0("import::from(", lib, ", '", paste0(fun, collapse = "', '"), "')")
        )
      )
    }
  }
  invisible()
}

import_fs("radiant.data", libs = "plotly", incl = "ggplotly")

init_data <- function() {

  ## Joe Cheng: "Datasets can change over time (i.e., the changedata function).
  ## Therefore, the data need to be a reactive value so the other reactive
  ## functions and outputs that depend on these datasets will know when they
  ## are changed."
  r_data <- reactiveValues()

  df_name <- getOption("radiant.init.data", default = "spt")
  if (file.exists(df_name)) {
    df <- load(df_name) %>% get
    df_name <- basename(df_name) %>% {gsub(paste0(".",tools::file_ext(.)),"",., fixed = TRUE)}
  } else {
    df <- data(list = df_name, package = "radiant.data", envir = environment()) %>% get
  }

  r_data[[df_name]] <- df
  r_data[[paste0(df_name, "_descr")]] <- attr(df, "description")
  r_data$datasetlist <- df_name
  r_data$url <- NULL
  r_data
}

## import required functions and packages
if (!"package:radiant.data" %in% search())
  import_fs("radiant.data", libs = c("magrittr","ggplot2","lubridate","tidyr","dplyr","broom","tibble"))

## running local or on a server
if (Sys.getenv('SHINY_PORT') == "") {
  options(radiant.local = TRUE)
  ## no limit to filesize locally
  options(shiny.maxRequestSize = -1)
} else {
  options(radiant.local = FALSE)
  ## limit upload filesize on server (10MB)
  options(shiny.maxRequestSize = 10 * 1024^2)
}

## encoding
options(radiant.encoding = "UTF-8")

## path to use for local or server use
ifelse (grepl("radiant.data", getwd()) && file.exists("../../inst") , "..", system.file(package = "radiant.data")) %>%
  options(radiant.path.data = .)

## print options
options(width = 250, scipen = 100)
options(max.print = max(getOption("max.print"), 5000))

## list of function arguments
list("n" = "length", "n_missing" = "n_missing", "n_distinct" = "n_distinct",
     "mean" = "mean_rm", "median" = "median_rm", "min" = "min_rm",
     "max" = "max_rm", "sum" = "sum_rm",
     "var" = "var_rm", "sd" = "sd_rm", "se" = "se", "cv" = "cv",
     "prop" = "prop", "varprop" = "varprop", "sdprop" = "sdprop", "seprop" = "seprop",
     "varpop" = "varpop", "sdpop" = "sdpop",
     "5%" = "p05", "10%" = "p10", "25%" = "p25", "75%" = "p75", "90%" = "p90",
     "95%" = "p95", "skew" = "skew","kurtosis" = "kurtosi") %>%
options(radiant.functions = .)

## for report and code in menu R
knitr::opts_knit$set(progress = TRUE)
knitr::opts_chunk$set(echo = FALSE, comment = NA, cache = FALSE,
  message = FALSE, warning = FALSE, error = TRUE, dpi = 96,
  # screenshot.force = FALSE,
  fig.path = normalizePath(tempdir(), winslash = "/"))

options(radiant.nav_ui =
  list(windowTitle = "Radiant", id = "nav_radiant", inverse = TRUE,
       collapsible = TRUE, tabPanel("Data", withMathJax(), uiOutput("ui_data"))))


## environment to hold session information
r_sessions <- new.env(parent = emptyenv())

## create directory to hold session files
file.path(normalizePath("~"),"radiant.sessions") %>% {if (!file.exists(.)) dir.create(.)}

## adding the figures path to avoid making a copy of all figures in www/figures
addResourcePath("figures", file.path(getOption("radiant.path.data"), "app/tools/help/figures/"))
addResourcePath("imgs", file.path(getOption("radiant.path.data"), "app/www/imgs/"))
addResourcePath("js", file.path(getOption("radiant.path.data"), "app/www/js/"))

options(radiant.mathjax.path = "https://cdn.mathjax.org/mathjax/latest")

#####################################
## url processing to share results
#####################################

## relevant links
# http://stackoverflow.com/questions/25306519/shiny-saving-url-state-subpages-and-tabs/25385474#25385474
# https://groups.google.com/forum/#!topic/shiny-discuss/Xgxq08N8HBE
# https://gist.github.com/jcheng5/5427d6f264408abf3049

## try http://127.0.0.1:3174/?url=multivariate/conjoint/plot/&SSUID=local
options(radiant.url.list =
  list("Data" = list("tabs_data" = list(#"Manage"    = "data/",
                                        #"View"      = "data/view/",
                                        "Visualize" = "data/visualize/",
                                        "Pivot"     = "data/pivot/"))
                                        #"Explore"   = "data/explore/",
                                        #"Transform" = "data/transform/",
                                        #"Combine"   = "data/combine/"))
  ))

make_url_patterns <- function(url_list = getOption("radiant.url.list"),
                              url_patterns = list()) {
  for (i in names(url_list)) {
    res <- url_list[[i]]
    if (!is.list(res)) {
      url_patterns[[res]] <- list("nav_radiant" = i)
    } else {
      tabs <- names(res)
      for (j in names(res[[tabs]])) {
        url <- res[[tabs]][[j]]
        url_patterns[[url]] <- setNames(list(i,j), c("nav_radiant",tabs))
      }
    }
  }
  url_patterns
}

## generate url patterns
options(radiant.url.patterns = make_url_patterns())

## installed packages versions
tmp <- grep("radiant.", installed.packages()[,"Package"], value = TRUE)
if ("radiant" %in% installed.packages()) tmp <- c("radiant" = "radiant", tmp)

radiant.versions <- "Unknown"
if (length(tmp) > 0)
  radiant.versions <- sapply(names(tmp), function(x) paste(x, paste(packageVersion(x), sep = ".")))

options(radiant.versions = paste(radiant.versions, collapse = ", "))
rm(tmp, radiant.versions)


