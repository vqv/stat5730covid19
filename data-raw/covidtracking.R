library(dplyr)
library(readr)
library(snakecase)

covidtracking_states_url <- "https://covidtracking.com/api/v1/states/daily.csv"
covidtracking_states_info_url <- "https://covidtracking.com/api/v1/states/info.csv"

states_info <- read_csv(covidtracking_states_info_url)

covidtracking <- covidtracking_states_url %>%
  read_csv(col_types = cols(date = col_date(format = "%Y%m%d"))) %>%
  rename(iso2 = state) %>%
  left_join(select(states_info, state = name, fips), by = "fips") %>%
  rename(cases = positive, deaths = death) %>%
  rename_all(snakecase::to_snake_case, numerals = "asis") %>%
  select(date, iso2, state, fips, cases, deaths, everything())

usethis::use_data(covidtracking, overwrite = TRUE)

