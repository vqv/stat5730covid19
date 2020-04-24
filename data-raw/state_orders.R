library(googlesheets4)
library(tidyr)
library(dplyr)
library(stringr)

load("data/fips_codes.rda")

stat5730_url <- "https://docs.google.com/spreadsheets/d/1sbr0vrx6j28v7K9FX3wQPIQSOfRMiMEJ9kkAjTkfQ_s/edit?usp=sharing"

gs4_deauth()
stat5730_raw <- read_sheet(stat5730_url)

state_orders <- stat5730_raw %>%
  # Convert the date-time to date
  mutate_at(vars(stay_at_home:travel_restriction), as.Date) %>%
  # Add fips
  left_join(filter(fips_codes, is.na(county)), by = "state") %>%
  pivot_longer(cols = stay_at_home:travel_restriction,
                      names_to = "order_type",
                      values_to = "date") %>%
  mutate(order_type = str_replace_all(order_type, "_", " ")) %>%
  select(date, state, fips, order_type) %>%
  arrange(date)

usethis::use_data(state_orders, overwrite = TRUE)