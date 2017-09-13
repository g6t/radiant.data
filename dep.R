# deplyoyment
library(rsconnect)
rsconnect::setAccountInfo(
  name='marcinkosinski',
  token='88CE927C2782C4935720D16C46D3A2A9',
  secret='U7ToUMat1T2pg/xy2kB82tmZMWWMWb3yvCrkGwFe'
)
setwd('inst/app')
deployApp(appName = 'radiant_data_test', appDir = 'inst/app')
setq('../../')
