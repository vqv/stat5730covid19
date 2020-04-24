all: covidtracking google_mobility jhu_csse nyt_county ohio state_orders census

readme: README.md
README.md: README.Rmd
	Rscript -e "rmarkdown::render('$<')"

jhu_csse:
	Rscript data-raw/jhu_csse.R

covidtracking:
	Rscript data-raw/covidtracking.R

google_mobility:
	Rscript data-raw/google_mobility.R

nyt_county: 
	Rscript data-raw/nyt_county.R

ohio: 
	Rscript data-raw/ohio.R

state_orders: 
	Rscript data-raw/state_orders.R

census:
	Rscript data-raw/us_census.R