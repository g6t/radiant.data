#### libraries ####
library(dplyr)
library(ggplot2)
library(stringr)
#### load necessary test data ####
load('data/spt_d_tidy.rda')
load('spt_d_tidy_answers_dict.rda')
lookup_table <- spt_d_tidy_answers_dict
colnames(lookup_table) <-
  c('variable',  'client_name', 'syntactically_valid_name')
tab <- spt_d_tidy %>%
  count(descriptions)

#### plot parameters ####
cvars <- 'descriptions'
nvar <- 'n'
##### plot himself ####
p <- ggplot(na.omit(tab), aes_string(x = cvars, y = nvar)) +
  geom_bar(stat = "identity", position = "dodge", alpha = .7)+
  scale_x_discrete(
    labels = function(x) {
      sapply(x, function(y){
      lookup_table %>%
        filter(variable == !! cvars) %>%
        filter(syntactically_valid_name == !! y) %>%
        magrittr::use_series(client_name) %>%
        str_wrap(35)
      })
    })
p
