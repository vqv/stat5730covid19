library(readr)
library(dplyr)
library(lubridate)
library(snakecase)

odh_url <- "https://coronavirus.ohio.gov/static/COVIDSummaryData.csv"
ohio_coronavirus <- read_csv(odh_url,
  col_types = cols(
    County = "c",
    Sex = "c",
    `Age Range` = "c",
    `Onset Date` = col_date(format = "%m/%d/%Y"),
    `Date Of Death` = col_date(format = "%m/%d/%Y"),
    `Admission Date` = col_date(format = "%m/%d/%Y"),
    `Case Count` = "i",
    `Death Count` = "i",
    `Hospitalized Count` = "i"
  ), na = c("", "Unknown"), n_max = nrow(read_csv(odh_url)) - 1) %>%
  rename(county = `County`,
         sex = `Sex`,
         age = `Age Range`,
         onset_date = `Onset Date`,
         death_date = `Date Of Death`,
         admission_date = `Admission Date`,
         new_cases = `Case Count`,
         new_deaths = `Death Count`,
         new_hospitalizations = `Hospitalized Count`) %>%
  arrange(onset_date)

usethis::use_data(ohio_coronavirus, overwrite = TRUE)
