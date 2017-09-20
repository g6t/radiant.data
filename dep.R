# deplyoyment
library(rsconnect)
# tokens from here https://www.shinyapps.io/admin/#/tokens
rsconnect::setAccountInfo(
  name='gradient',
  token='6848CD5B22C319CBBDC7FAEE09CED52F',
  secret='kFgob14TRbsbzQHjtSpcx64uQg3n+WaFcLFyh3b6'
)

library(devtools)
# auth_token can be gained from https://github.com/settings/tokens/new
install_github("g6t/radiant.data", auth_token = 'b1c7066d2ced650e99c9fddf1389c85511739c3e', ref = 'plotly')

setwd('inst/app')
deployApp(appName = 'radiant_data_test')
#setwd('../../')
