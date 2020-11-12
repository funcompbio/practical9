## read COVID19 data
dat <- read.csv("catalunya_setmanal.csv", sep=";", stringsAsFactors=TRUE)

m <- months(startdate, abbreviate=TRUE)
mf <- factor(m)
