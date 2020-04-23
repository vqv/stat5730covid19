################################################################################
# data-import.R
#
# Vincent Q. Vu
# 2020-04-22
#
# Functions for importing COVID-19 data from JHU CSSE, COVID Tracking Project,
# New York Times, and the STAT 5730 shared Google sheet. There is also a
# function for importing the Google Mobility report which gives estimates of
# change in mobility from baseline by date and region and type of location.
#
# The main functions for users are:
#
# get_csse_global_data()
# get_csse_usa_data()
# get_covidtracking_data()
# get_nyt_data()
# get_google_mobility_data()
#
# All of these functions return tibbles. The format of the tibbles varies
# between the data sources, but we have standardized all of the COVID-19
# count data to include at least:
#
# - date    The date of the record
# - cases   Cumulative number of confirmed COVID-19 cases
# - deaths  Cumulative number of confirmed COVID-19 deaths
#
# The data sets on the U.S. also include
#
# - fips    FIPS code of the geographical area -- U.S. States have a 2 digit
#           code; counties have a 5 digit code.
#
################################################################################

###############################################################################
# Johns Hopkins CSSE
# https://github.com/CSSEGISandData/COVID-19
###############################################################################

# The CSSE data puts dates in the column names and uses separate tables for
# confirmed cases, deaths, and recovered. We need to pivot longer, then
# bind the separate tables, then pivot wider again to get the counts into
# separate columns.

#' Get JHU CSSE look up data
#'
#' @return
#' @export
get_csse_lookup_data <- function() {
  # Table with additional information (population, identification codes)
  # on the regions in the CSSE data
  csse_uid_lookup_url <- "https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/UID_ISO_FIPS_LookUp_Table.csv"
  readr::read_csv(csse_uid_lookup_url,
                  col_types = readr::cols(UID = "c", code3 = "c", FIPS = "c"))
}

#' Get JHU CSSE global data
#'
#' @return
#' @export
get_csse_global_data <- function() {
  csse_global_url <- list(
    confirmed =  "https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_confirmed_global.csv",
    deaths = "https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_deaths_global.csv",
    recovered = "https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_recovered_global.csv"
  )
  csse_global_url %>%
    purrr::map(readr::read_csv) %>%
    purrr::map(tidyr::pivot_longer,
        cols = matches("[0-9]+/[0-9]+/[0-9]+"),
        names_to = "date") %>%
    # Combine different variables
    dplyr::bind_rows(.id = "variable") %>%
    tidyr::pivot_wider(names_from = "variable") %>%
    dplyr::mutate(date = lubridate::mdy(date)) %>%
    dplyr::rename(cases = confirmed,
                  province_state = `Province/State`,
                  country_region = `Country/Region`) %>%
    dplyr::select(date, province_state, country_region, cases, deaths, dplyr::everything())
}

#' Get JHU CSSE U.S. data
#'
#' @return
#' @export
get_csse_usa_data <- function() {
  csse_usa_url <- list(
    confirmed = "https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_confirmed_US.csv",
    deaths = "https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_deaths_US.csv"
  )
  csse_usa_url %>%
    purrr::map(readr::read_csv, col_types = readr::cols(UID = "c", code3 = "c", FIPS = "c")) %>%
    purrr::map(tidyr::pivot_longer,
        cols = matches("[0-9]+/[0-9]+/[0-9]+"),
        names_to = "date") %>%
    # Combine different variables
    dplyr::bind_rows(.id = "variable") %>%
    dplyr::select(-Population, -FIPS) %>%
    tidyr::pivot_wider(names_from = "variable") %>%
    dplyr::mutate(date = lubridate::mdy(date)) %>%
    # Fix the poorly formatted FIPS field by replacing it with the one from
    # the lookup table
    dplyr::left_join(dplyr::select(get_csse_lookup_data(), UID, fips = FIPS),
                     by = "UID") %>%
    dplyr::rename(cases = confirmed, state = "Province_State")  %>%
    dplyr::select(date, state, fips, cases, deaths, dplyr::everything())
}

###############################################################################
# The COVID Tracking Project
# https://covidtracking.com
###############################################################################
#' Get COVID Tracking Project data
#'
#' @return
#' @export
get_covidtracking_data <- function() {
  covidtracking_states_url <- "https://covidtracking.com/api/v1/states/daily.csv"
  covidtracking_states_info_url <- "https://covidtracking.com/api/v1/states/info.csv"

  states_info <- readr::read_csv(covidtracking_states_info_url)

  covidtracking_states_url %>%
    readr::read_csv(col_types = readr::cols(date = readr::col_date(format = "%Y%m%d"))) %>%
    dplyr::rename(iso2 = state) %>%
    dplyr::left_join(dplyr::select(states_info, state = name, fips), by = "fips") %>%
    dplyr::rename(cases = positive, deaths = death) %>%
    dplyr::select(date, iso2, state, fips, cases, deaths, dplyr::everything())
}

###############################################################################
# New York Times
# https://github.com/nytimes/covid-19-data
###############################################################################
#' Get New York Times COVID-19 U.S. County level data
#'
#' @return
#' @export
get_nyt_data <- function() {
  nyt_counties_url <- "https://raw.githubusercontent.com/nytimes/covid-19-data/master/us-counties.csv"
  readr::read_csv(nyt_counties_url) %>%
    dplyr::select(date, state, county, fips, cases, deaths, dplyr::everything())
}

###############################################################################
# STAT 5730
###############################################################################
#' Get STAT 5730 state executive orders data
#'
#' @return
#' @export
get_stat5730_data <- function() {
  stat5730_url <- "https://docs.google.com/spreadsheets/d/1sbr0vrx6j28v7K9FX3wQPIQSOfRMiMEJ9kkAjTkfQ_s/edit?usp=sharing"

  googlesheets4::sheets_deauth()
  stat5730_raw <- googlesheets4::read_sheet(stat5730_url)

  stat5730_raw %>%
    # Convert the date-time to date
    dplyr::mutate_at(dplyr::vars(stay_at_home:travel_restriction), as.Date) %>%
    dplyr::left_join(dplyr::select(usmap::statepop, full, fips),
              by = c("state" = "full")) %>%
    tidyr::pivot_longer(cols = stay_at_home:travel_restriction,
                        names_to = "order_type",
                        values_to = "date") %>%
    dplyr::mutate(order_type = stringr::str_replace(order_type, "_", " ")) %>%
    dplyr::select(date, state, fips, order_type) %>%
    dplyr::arrange(date)
}

################################################################################
# Google Mobility Data
# https://www.google.com/covid19/mobility/index.html?hl=en
################################################################################
#' Get Google Mobility Report
#'
#' @return
#' @export
get_google_mobility_data <- function() {
  google_mobility_url <- "https://www.gstatic.com/covid19/mobility/Global_Mobility_Report.csv"
  google_mobility_raw <- readr::read_csv(google_mobility_url,
                                         col_types = readr::cols(sub_region_2 = "c"))

  # Composite table of FIPS codes for both states and counties
  fips_county <- usmap::countypop %>%
    dplyr::left_join(dplyr::select(usmap::statepop, abbr, state = full),
                     by = "abbr") %>%
    dplyr::select(fips, state, county)
  fips_state <- usmap::statepop %>%
    dplyr::transmute(fips = fips, state = full, county = as.character(NA))
  fips_codes <- dplyr::bind_rows(fips_state, fips_county) %>%
    dplyr::mutate(country = "United States")

  google_mobility_raw %>%
    dplyr::left_join(fips_codes, by = c("country_region" = "country",
                                        "sub_region_1" = "state",
                                        "sub_region_2" = "county")) %>%
    tidyr::pivot_longer(cols = dplyr::ends_with("percent_change_from_baseline"),
                        names_to = "type",
                        values_to = "percent_change") %>%
    dplyr::mutate(type = stringr::str_remove(type, "_.*"))
}
