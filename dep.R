# deplyoyment
library(rsconnect)
# tokens from here https://www.shinyapps.io/admin/#/tokens
rsconnect::setAccountInfo(
  name='marcinkosinski',
  token='',
  secret=''
)

library(devtools)
# auth_token can be gained from https://github.com/settings/tokens/new
install_github("g6t/radiant.data", auth_token = '', ref = 'reduced')

setwd('inst/app')
deployApp(appName = 'radiant_data_test')
#setwd('../../')
