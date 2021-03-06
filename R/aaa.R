# to avoid 'no visible binding for global variable' NOTE
globalVariables(c("r_environment", "session", "r_data", "r_state", ".",
                  ".rs.restartR", "..density..", "Total", "tfoot", "thead",
                  "tr", "th", "variable", "y", "matches"))

#' radiant.data
#'
#' @name radiant.data
#' @docType package
#' @import ggplot2 shiny dplyr
#' @importFrom rlang parse_exprs
#' @importFrom car Recode
#' @importFrom rstudioapi insertText isAvailable
#' @importFrom knitr knit2html knit knit_print
#' @importFrom markdown markdownToHTML
#' @importFrom rmarkdown render html_dependency_bootstrap pdf_document html_document word_document
#' @importFrom pryr where object_size
#' @importFrom magrittr %<>% %T>% %$% set_rownames set_colnames set_names divide_by add extract2
#' @importFrom lubridate is.Date is.POSIXt now year month wday week hour minute second ymd mdy dmy ymd_hms hms hm as.duration parse_date_time
#' @importFrom tibble rownames_to_column
#' @importFrom tidyr gather spread separate
#' @importFrom grid textGrob gpar
#' @importFrom gridExtra grid.arrange
#' @importFrom shinyAce aceEditor updateAceEditor
#' @importFrom readr read_delim read_csv write_csv read_rds write_rds locale problems
#' @importFrom base64enc dataURI
#' @importFrom methods is
#' @importFrom stats as.formula chisq.test dbinom median na.omit quantile sd setNames var weighted.mean
#' @importFrom utils combn head install.packages read.table tail
#' @importFrom import from
#' @importFrom plotly ggplotly subplot
NULL

#' Exporting knit_print from knitr
#' @importFrom knitr knit_print
#' @name knit_print
#' @rdname knit_print
#' @export
NULL

#' Exporting rownames_to_column from tibble
#' @importFrom tibble rownames_to_column
#' @name rownames_to_column
#' @rdname rownames_to_column
#' @export
NULL

#' Exporting tibble
#' @importFrom tibble tibble
#' @name tibble
#' @rdname tibble
#' @export
NULL

#' Exporting as_tibble
#' @importFrom tibble as_tibble
#' @name as_tibble
#' @rdname as_tibble
#' @export
NULL

#' Exporting tidy from broom
#' @importFrom broom tidy
#' @name tidy
#' @rdname tidy
#' @export
NULL

#' Exporting glance from broom
#' @importFrom broom glance
#' @name glance
#' @rdname glance
#' @export
NULL

#' Exporting the kurtosi function from the psych package
#' @importFrom psych kurtosi
#' @name kurtosi
#' @rdname kurtosi.re
#' @export
NULL

#' Exporting the skew function from the psych package
#' @importFrom psych skew
#' @name skew
#' @rdname skew.re
#' @export
NULL

#' Exporting the ggplotly function from the plotly package
#' @importFrom plotly ggplotly
#' @name ggplotly
#' @rdname ggplotly
#' @export
NULL

#' Exporting the subplot function from the plotly package
#' @importFrom plotly subplot
#' @name subplot
#' @rdname subplot
#' @export
NULL

#' Diamond prices
#' @details A sample of 3,000 from the diamonds dataset bundeled with ggplot2. Description provided in attr(diamonds,"description")
#' @docType data
#' @keywords datasets
#' @name diamonds
#' @usage data(diamonds)
#' @format A data frame with 3000 rows and 10 variables
NULL

#' Survival data for the Titanic
#' @details Survival data for the Titanic. Description provided in attr(titanic,"description")
#' @docType data
#' @keywords datasets
#' @name titanic
#' @usage data(titanic)
#' @format A data frame with 1043 rows and 10 variables
NULL

#' spt_d_tidy
#' @details details
#' @docType data
#' @keywords datasets
#' @name spt_d_tidy
#' @usage data(spt_d_tidy)
#' @format A data frame with X rows and Y variables
NULL
