#' Johns Hopkins CSSE COVID-19 international data, current as of `r format(Sys.Date())`
#' 
#' @source \url{github.com/CSSEGISandData/COVID-19}
#' 
"csse_global"

#' Johns Hopkins CSSE COVID-19 U.S. county-level data, current as of `r format(Sys.Date())`
#' 
#' @source \url{github.com/CSSEGISandData/COVID-19}
#' 
"csse_us"
"csse_lookup"

#' COVID-19 data from COVID Tracking Project, current as of `r format(Sys.Date())`
#' 
#' @source \url{covidtracking.com}
#' 
"covidtracking"

#' New York Times COVID-19 U.S. county-level data, current as of `r format(Sys.Date())`
#' 
#' @source \url{github.com/nytimes/covid-19-data}
#' 
"nyt_county"

#' Ohio Department of Health COVID-19 data, current as of `r format(Sys.Date())`
#' 
#' The data is provided by the Ohio Department of Health COVID-19 Dashboard 
#' (\url{coronavirus.ohio.gov})
#' 
#' \describe{
#'   \item{county}{county where the case was recorded}
#'   \item{sex}{sex, Female or Male}
#'   \item{age}{age range of the individual as a string}
#'   \item{onset_date}{date of onset of infect}
#'   \item{death_date}{date of death}
#'   \item{admission_date}{date the individual was admitted to hospital}
#'   \item{new_cases}{new cases on this date}
#'   \item{new_deaths}{new deaths on this date}
#'   \item{new_hospitalizations}{new hospitalizations on this date}
#' }
#' @source \url{coronavirus.ohio.gov/static/COVIDSummaryData.csv}
#' 
"ohio_coronavirus"

#' U.S. state executive orders data from STAT 5730, current as of `r format(Sys.Date())`
"state_orders"

#' Google Mobility Reports
#' 2018 population, density, and median income estimates from U.S. Census
"census_state_pop"
"census_county_pop"
"census_county_income"
