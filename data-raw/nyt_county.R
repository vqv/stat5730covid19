library(readr)
library(dplyr)

nyt_county_url <- "https://raw.githubusercontent.com/nytimes/covid-19-data/master/us-counties.csv"
nyt_county <- read_csv(nyt_county_url) %>%
  select(date, state, county, fips, cases, deaths, everything())

usethis::use_data(nyt_county, overwrite = TRUE)
