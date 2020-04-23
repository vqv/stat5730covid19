
<!-- README.md is generated from README.Rmd. Please edit that file -->

# stat5730covid19

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
<!-- badges: end -->

This is an rough and unpolished R package for the students of STAT 5730.
It contains functions for importing COVID-19 data from the Johns Hopkins
CSSE group, The COVID Tracking Project, the New York Times, the state
executive orders shared Google sheet collected by the Spring 2020 STAT
5730 class, and the Google Mobility Report. The functions do not take
any arguments. They are meant to encapsulate the data import and
cleaning, and should only be called whenever the data source is updated
— generally once a day.

Where possible, I have included FIPS codes for the geographic regions of
the United States. This is a standardized code used by the U.S. federal
government to identify states (with 2 digits) and counties (with 5
digits). In many cases, you can use the FIPS code as a key for joining
tables.

Also included with the package are county- and state-level estimates of
population, density, and median income from the U.S. Census Bureau for
2018. The `GEOID` variable in the data can be treated as a FIPS code.

## Installation

You can install stat5730covid19 from [Github](https://github.com) with:

``` r
remotes::install_github("vqv/stat5730covid19")
```

## Examples

``` r
library(stat5730covid19)
```

### JHU CSSE

Source: <https://github.com/CSSEGISandData/COVID-19>

The CSSE group at Johns Hopkins has been collecting data on the global
COVID-19 pandemic. Their data includes number of cases and deaths in
different regions globally.

``` r
(csse_global <- get_csse_global_data())
#> # A tibble: 25,760 x 8
#>    date       province_state country_region cases deaths   Lat  Long recovered
#>    <date>     <chr>          <chr>          <dbl>  <dbl> <dbl> <dbl>     <dbl>
#>  1 2020-01-22 <NA>           Afghanistan        0      0    33    65         0
#>  2 2020-01-23 <NA>           Afghanistan        0      0    33    65         0
#>  3 2020-01-24 <NA>           Afghanistan        0      0    33    65         0
#>  4 2020-01-25 <NA>           Afghanistan        0      0    33    65         0
#>  5 2020-01-26 <NA>           Afghanistan        0      0    33    65         0
#>  6 2020-01-27 <NA>           Afghanistan        0      0    33    65         0
#>  7 2020-01-28 <NA>           Afghanistan        0      0    33    65         0
#>  8 2020-01-29 <NA>           Afghanistan        0      0    33    65         0
#>  9 2020-01-30 <NA>           Afghanistan        0      0    33    65         0
#> 10 2020-01-31 <NA>           Afghanistan        0      0    33    65         0
#> # … with 25,750 more rows
(csse_usa <- get_csse_usa_data())
#> # A tibble: 300,012 x 14
#>    date       state fips  cases deaths UID   iso2  iso3  code3 Admin2
#>    <date>     <chr> <chr> <dbl>  <dbl> <chr> <chr> <chr> <chr> <chr> 
#>  1 2020-01-22 Amer… 60        0      0 16    AS    ASM   16    <NA>  
#>  2 2020-01-23 Amer… 60        0      0 16    AS    ASM   16    <NA>  
#>  3 2020-01-24 Amer… 60        0      0 16    AS    ASM   16    <NA>  
#>  4 2020-01-25 Amer… 60        0      0 16    AS    ASM   16    <NA>  
#>  5 2020-01-26 Amer… 60        0      0 16    AS    ASM   16    <NA>  
#>  6 2020-01-27 Amer… 60        0      0 16    AS    ASM   16    <NA>  
#>  7 2020-01-28 Amer… 60        0      0 16    AS    ASM   16    <NA>  
#>  8 2020-01-29 Amer… 60        0      0 16    AS    ASM   16    <NA>  
#>  9 2020-01-30 Amer… 60        0      0 16    AS    ASM   16    <NA>  
#> 10 2020-01-31 Amer… 60        0      0 16    AS    ASM   16    <NA>  
#> # … with 300,002 more rows, and 4 more variables: Country_Region <chr>,
#> #   Lat <dbl>, Long_ <dbl>, Combined_Key <chr>
(csse_lookup <- get_csse_lookup_data())
#> # A tibble: 3,590 x 12
#>    UID   iso2  iso3  code3 FIPS  Admin2 Province_State Country_Region   Lat
#>    <chr> <chr> <chr> <chr> <chr> <chr>  <chr>          <chr>          <dbl>
#>  1 4     AF    AFG   4     <NA>  <NA>   <NA>           Afghanistan     33.9
#>  2 8     AL    ALB   8     <NA>  <NA>   <NA>           Albania         41.2
#>  3 12    DZ    DZA   12    <NA>  <NA>   <NA>           Algeria         28.0
#>  4 20    AD    AND   20    <NA>  <NA>   <NA>           Andorra         42.5
#>  5 24    AO    AGO   24    <NA>  <NA>   <NA>           Angola         -11.2
#>  6 28    AG    ATG   28    <NA>  <NA>   <NA>           Antigua and B…  17.1
#>  7 32    AR    ARG   32    <NA>  <NA>   <NA>           Argentina      -38.4
#>  8 51    AM    ARM   51    <NA>  <NA>   <NA>           Armenia         40.1
#>  9 40    AT    AUT   40    <NA>  <NA>   <NA>           Austria         47.5
#> 10 31    AZ    AZE   31    <NA>  <NA>   <NA>           Azerbaijan      40.1
#> # … with 3,580 more rows, and 3 more variables: Long_ <dbl>,
#> #   Combined_Key <chr>, Population <dbl>
```

### COVID Tracking Project

Source: <https://covidtracking.com>

The COVID Tracking Project was initiated by journalists at The Atlantic
magazine. The data is mostly based on scraping state government websites
and provides daily case and death counts at the state level, as well as
numbers of tests and negative results.

``` r
(covidtracking <- get_covidtracking_data())
#> # A tibble: 2,676 x 26
#>    date       iso2  state fips  cases deaths negative pending hospitalizedCur…
#>    <date>     <chr> <chr> <chr> <dbl>  <dbl>    <dbl>   <dbl>            <dbl>
#>  1 2020-04-22 AK    Alas… 02      335      9    11824      NA               39
#>  2 2020-04-22 AL    Alab… 01     5465    194    43295      NA               NA
#>  3 2020-04-22 AR    Arka… 05     2276     42    27437      NA               97
#>  4 2020-04-22 AS    Amer… 60        0     NA        3      17               NA
#>  5 2020-04-22 AZ    Ariz… 04     5459    229    51142      NA              664
#>  6 2020-04-22 CA    Cali… 06    35396   1354   429931      NA             4984
#>  7 2020-04-22 CO    Colo… 08    10447    486    38257      NA              851
#>  8 2020-04-22 CT    Conn… 09    22469   1544    47449      NA             1972
#>  9 2020-04-22 DC    Dist… 11     3206    127    12296      NA              402
#> 10 2020-04-22 DE    Dela… 10     3200     89    13353      NA              269
#> # … with 2,666 more rows, and 17 more variables: hospitalizedCumulative <dbl>,
#> #   inIcuCurrently <dbl>, inIcuCumulative <dbl>, onVentilatorCurrently <dbl>,
#> #   onVentilatorCumulative <dbl>, recovered <dbl>, hash <chr>,
#> #   dateChecked <dttm>, hospitalized <dbl>, total <dbl>,
#> #   totalTestResults <dbl>, posNeg <dbl>, deathIncrease <dbl>,
#> #   hospitalizedIncrease <dbl>, negativeIncrease <dbl>, positiveIncrease <dbl>,
#> #   totalTestResultsIncrease <dbl>
```

### New York Times

Source: <https://github.com/nytimes/covid-19-data>

Journalists and data scientists at the New York Times have been working
on collecting daily case and death counts at the U.S. county level.

``` r
(nyt <- get_nyt_data())
#> # A tibble: 78,548 x 6
#>    date       state      county      fips  cases deaths
#>    <date>     <chr>      <chr>       <chr> <dbl>  <dbl>
#>  1 2020-01-21 Washington Snohomish   53061     1      0
#>  2 2020-01-22 Washington Snohomish   53061     1      0
#>  3 2020-01-23 Washington Snohomish   53061     1      0
#>  4 2020-01-24 Illinois   Cook        17031     1      0
#>  5 2020-01-24 Washington Snohomish   53061     1      0
#>  6 2020-01-25 California Orange      06059     1      0
#>  7 2020-01-25 Illinois   Cook        17031     1      0
#>  8 2020-01-25 Washington Snohomish   53061     1      0
#>  9 2020-01-26 Arizona    Maricopa    04013     1      0
#> 10 2020-01-26 California Los Angeles 06037     1      0
#> # … with 78,538 more rows
```

### STAT 5730

The students of Spring 2020 STAT 5730 collected data on the executive
orders made by U.S. state governments mandating school closures, shelter
in place (stay at home), and travel restrictions.

``` r
(stat5730 <- get_stat5730_data())
#> # A tibble: 220 x 4
#>    date       state         fips  order_type        
#>    <date>     <chr>         <chr> <chr>             
#>  1 2020-03-12 Indiana       18    schools closed    
#>  2 2020-03-12 Maryland      24    schools closed    
#>  3 2020-03-13 Louisiana     22    schools closed    
#>  4 2020-03-13 Rhode Island  44    schools closed    
#>  5 2020-03-13 Rhode Island  44    travel restriction
#>  6 2020-03-13 South Dakota  46    schools closed    
#>  7 2020-03-13 Utah          49    schools closed    
#>  8 2020-03-13 Washington    53    schools closed    
#>  9 2020-03-13 West Virginia 54    schools closed    
#> 10 2020-03-15 Iowa          19    schools closed    
#> # … with 210 more rows
```

### Google Mobility

Source: <https://www.google.com/covid19/mobility/index.html?hl=en>

Google is temporarily providing estimates of mobility in different
locations that are based on anonymized data collected from users who
have enabled location history. The values are percent change from a
baseline median value on the same day of the week during a 5 week period
from the beginning of the year.

Notes from Google:

> Location accuracy and the understanding of categorized places varies
> from region to region, so we don’t recommend using this data to
> compare changes between countries, or between regions with different
> characteristics (e.g.  rural versus urban areas).

``` r
(google_mobility <- get_google_mobility_data())
#> # A tibble: 1,344,882 x 8
#>    country_region_… country_region sub_region_1 sub_region_2 date       fips 
#>    <chr>            <chr>          <chr>        <chr>        <date>     <chr>
#>  1 AE               United Arab E… <NA>         <NA>         2020-02-15 <NA> 
#>  2 AE               United Arab E… <NA>         <NA>         2020-02-15 <NA> 
#>  3 AE               United Arab E… <NA>         <NA>         2020-02-15 <NA> 
#>  4 AE               United Arab E… <NA>         <NA>         2020-02-15 <NA> 
#>  5 AE               United Arab E… <NA>         <NA>         2020-02-15 <NA> 
#>  6 AE               United Arab E… <NA>         <NA>         2020-02-15 <NA> 
#>  7 AE               United Arab E… <NA>         <NA>         2020-02-16 <NA> 
#>  8 AE               United Arab E… <NA>         <NA>         2020-02-16 <NA> 
#>  9 AE               United Arab E… <NA>         <NA>         2020-02-16 <NA> 
#> 10 AE               United Arab E… <NA>         <NA>         2020-02-16 <NA> 
#> # … with 1,344,872 more rows, and 2 more variables: type <chr>,
#> #   percent_change <dbl>
```

### U.S. Census data

``` r
census_state_pop
#> # A tibble: 52 x 4
#>    state                GEOID      POP  DENSITY
#>    <chr>                <chr>    <dbl>    <dbl>
#>  1 Alabama              01     4887871    96.5 
#>  2 Alaska               02      737438     1.29
#>  3 Arizona              04     7171646    63.1 
#>  4 Arkansas             05     3013825    57.9 
#>  5 California           06    39557045   254.  
#>  6 Colorado             08     5695564    55.0 
#>  7 Connecticut          09     3572665   738.  
#>  8 Delaware             10      967171   496.  
#>  9 District of Columbia 11      702455 11490.  
#> 10 Florida              12    21299325   397.  
#> # … with 42 more rows
census_county_pop
#> # A tibble: 3,220 x 6
#>    NAME                     GEOID county   state      POP DENSITY
#>    <chr>                    <chr> <chr>    <chr>    <dbl>   <dbl>
#>  1 Autauga County, Alabama  01001 Autauga  Alabama  55601    93.5
#>  2 Baldwin County, Alabama  01003 Baldwin  Alabama 218022   137. 
#>  3 Barbour County, Alabama  01005 Barbour  Alabama  24881    28.1
#>  4 Bibb County, Alabama     01007 Bibb     Alabama  22400    36.0
#>  5 Blount County, Alabama   01009 Blount   Alabama  57840    89.7
#>  6 Bullock County, Alabama  01011 Bullock  Alabama  10138    16.3
#>  7 Butler County, Alabama   01013 Butler   Alabama  19680    25.3
#>  8 Calhoun County, Alabama  01015 Calhoun  Alabama 114277   189. 
#>  9 Chambers County, Alabama 01017 Chambers Alabama  33615    56.3
#> 10 Cherokee County, Alabama 01019 Cherokee Alabama  26032    47.0
#> # … with 3,210 more rows
census_county_income
#> # A tibble: 3,220 x 6
#>    GEOID NAME                       moe county   state   medincome
#>    <chr> <chr>                    <dbl> <chr>    <chr>       <dbl>
#>  1 01001 Autauga County, Alabama   2972 Autauga  Alabama     58786
#>  2 01003 Baldwin County, Alabama   1204 Baldwin  Alabama     55962
#>  3 01005 Barbour County, Alabama   2552 Barbour  Alabama     34186
#>  4 01007 Bibb County, Alabama      5618 Bibb     Alabama     45340
#>  5 01009 Blount County, Alabama    2703 Blount   Alabama     48695
#>  6 01011 Bullock County, Alabama  10285 Bullock  Alabama     32152
#>  7 01013 Butler County, Alabama    2026 Butler   Alabama     39109
#>  8 01015 Calhoun County, Alabama   1578 Calhoun  Alabama     45197
#>  9 01017 Chambers County, Alabama  2347 Chambers Alabama     39872
#> 10 01019 Cherokee County, Alabama  1931 Cherokee Alabama     41014
#> # … with 3,210 more rows
```
