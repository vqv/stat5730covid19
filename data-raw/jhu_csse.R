library(readr)
library(tidyr)
library(dplyr)
library(purrr)
library(snakecase)

get_csse_lookup_data <- function() {
  # Table with additional information (population, identification codes)
  # on the regions in the CSSE data
  csse_uid_lookup_url <- "https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/UID_ISO_FIPS_LookUp_Table.csv"
  read_csv(csse_uid_lookup_url,
                  col_types = cols(UID = "c", code3 = "c", FIPS = "c")) %>%
    rename(long = Long_) %>%
    rename_all(snakecase::to_snake_case, numerals = "asis")
}

get_csse_global_data <- function() {
  csse_global_url <- list(
    confirmed =  "https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_confirmed_global.csv",
    deaths = "https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_deaths_global.csv",
    recovered = "https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_recovered_global.csv"
  )
  # The CSSE data puts dates in the column names and uses separate tables for
  # confirmed cases, deaths, and recovered. We need to pivot longer, then
  # bind the separate tables, then pivot wider again to get the counts into
  # separate columns.
  csse_global_url %>%
    map(read_csv) %>%
    map(pivot_longer,
               cols = matches("[0-9]+/[0-9]+/[0-9]+"),
               names_to = "date") %>%
    # Combine different variables
    bind_rows(.id = "variable") %>%
    pivot_wider(names_from = "variable") %>%
    mutate(date = lubridate::mdy(date)) %>%
    rename(cases = confirmed,
                  province_state = `Province/State`,
                  country_region = `Country/Region`) %>%
    rename_all(snakecase::to_snake_case, numerals = "asis") %>%
    select(date, province_state, country_region, cases, deaths, everything())
}

get_csse_us_data <- function() {
  csse_us_url <- list(
    confirmed = "https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_confirmed_US.csv",
    deaths = "https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_deaths_US.csv"
  )
  csse_us_url %>%
    map(read_csv, col_types = cols(UID = "c", code3 = "c", FIPS = "c")) %>%
    map(pivot_longer,
               cols = matches("[0-9]+/[0-9]+/[0-9]+"),
               names_to = "date") %>%
    # Combine different variables
    bind_rows(.id = "variable") %>%
    select(-Population, -FIPS) %>%
    pivot_wider(names_from = "variable") %>%
    mutate(date = lubridate::mdy(date)) %>%
    # Fix the poorly formatted FIPS field by replacing it with the one from
    # the lookup table
    rename(cases = confirmed, state = "Province_State",
                  lat = Lat, long = Long_)  %>%
    rename_all(snakecase::to_snake_case, numerals = "asis") %>%
    # Add fips
    left_join(select(get_csse_lookup_data(), uid, fips),
                     by = "uid") %>%
    select(date, state, fips, cases, deaths, everything())
}

csse_global <- get_csse_global_data()
csse_us <- get_csse_us_data()
csse_lookup <- get_csse_lookup_data()

usethis::use_data(csse_global, csse_us, csse_lookup, overwrite = TRUE)
