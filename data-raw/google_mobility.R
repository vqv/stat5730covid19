library(readr)
library(tidyr)
library(dplyr)
library(stringr)

google_mobility_url <- "https://www.gstatic.com/covid19/mobility/Global_Mobility_Report.csv"
google_mobility_raw <- read_csv(google_mobility_url,
                                col_types = cols(sub_region_2 = "c"))

load("data/fips_codes.rda")

google_mobility <- google_mobility_raw %>%
  # Composite table of FIPS codes for both states and counties
  left_join(mutate(fips_codes, country = "United States"),
                   by = c("country_region" = "country",
                          "sub_region_1" = "state",
                          "sub_region_2" = "county")) %>%
  pivot_longer(cols = ends_with("percent_change_from_baseline"),
                      names_to = "type",
                      values_to = "percent_change") %>%
  mutate(type = str_remove(type, "_.*"))

usethis::use_data(google_mobility, overwrite = TRUE)
