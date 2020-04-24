JHU_CSSE = data/csse_global.rda data/csse_us.rda data/csse_lookup.rda

all: covidtracking google_mobility jhu_csse nyt_county ohio state_orders

readme: README.md
README.md: README.Rmd
	Rscript -e "rmarkdown::render('$<')"

jhu_csse: $(JHU_CSSE)
$(JHU_CSSE):
	Rscript data-raw/jhu_csse.R

covidtracking: data/covidtracking.rda
data/covidtracking.rda:
	Rscript data-raw/covidtracking.R

google_mobility: data/google_mobility.rda
data/google_mobility.rda:
	Rscript data-raw/google_mobility.R

nyt_county: data/nyt_county.rda
data/nyt_county.rda:
	Rscript data-raw/nyt_county.R

ohio: data/ohio_coronavirus.rda
data/ohio_coronavirus.rda:
	Rscript data-raw/ohio.R

state_orders: data/state_orders.rda
data/state_orders.rda:
	Rscript data-raw/state_orders.R
