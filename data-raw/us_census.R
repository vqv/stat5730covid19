library(tidyverse)
library(tidycensus)
library(stringr)

census_state_pop <- get_estimates(geography = "state", product = "population")
census_county_pop <- get_estimates(geography = "county", product = "population")

census_state_pop <- census_state_pop %>%
  pivot_wider(names_from = "variable", values_from = "value") %>%
  rename(state = NAME)

census_county_pop <- census_county_pop %>% 
  mutate(
    county = str_split_fixed(NAME, ", ", 2)[, 1],
    state = str_split_fixed(NAME, ", ", 2)[, 2]) %>%
  pivot_wider(names_from = "variable", values_from = "value")

census_county_income <- get_acs(geography = "county", 
                  variables = c(medincome = "B19013_001"),
                  year = 2018) %>%
  mutate(
    county = str_split_fixed(NAME, ", ", 2)[, 1],
    state = str_split_fixed(NAME, ", ", 2)[, 2]) %>%
  pivot_wider(names_from = "variable", values_from = "estimate")

usethis::use_data(
  census_state_pop,
  census_county_pop,
  census_county_income,
  overwrite = "TRUE"
)