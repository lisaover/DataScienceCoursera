# setwd("~/Google Drive/_Data Science Johns Hopkins/Getting and Cleaning Data/wk4_quiz")


### Number 1

# download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv", "idaho.csv")
# download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FPUMSDataDict06.pdf", "idaho.pdf")

## Apply strsplit() to split all the names of the data frame on the characters 
## "wgtp". What is the value of the 123 element of the resulting list?

idaho <- read.csv("idaho.csv")
splitNames <- strsplit(names(idaho), "wgtp")
splitNames[[123]]

### Number 2

# download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv", "gdp.csv")
## Original Source: http://data.worldbank.org/data-catalog/GDP-ranking-table

## Remove the commas from the GDP numbers in millions of dollars and average them. What is the average?
gdp <- read.csv("gdp.csv", skip = 5, nrows = 215, header = FALSE)
head(gdp)
library(dplyr)
gdp <- gdp %>%
    rename(CountryCode = V1, Ranking = V2, Economy = V4, MillionsOfUSDollars = V5) %>%
    select(CountryCode, Ranking, Economy, MillionsOfUSDollars) %>%
    print
removeCommas <- function(x) {as.numeric(gsub(",", "", x))}
gdp$MillionsOfUSDollars <- sapply(gdp$MillionsOfUSDollars, removeCommas)
head(gdp)
tail(gdp)
mean(gdp$MillionsOfUSDollars, na.rm = TRUE)

### Number 3

grep("^United",gdp$Economy) ## gives indices for 3 obs that match

### Number 4

## Load the Gross Domestic Product data for the 190 ranked countries.
## Load the educational data.

# download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv", "gdp.csv")
# download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv", "edu.csv")

gdp <- read.csv("gdp.csv", skip = 5, nrows = 215, header = FALSE)
head(gdp) ## V1 is country shortcode
tail(gdp)
edu <- read.csv("edu.csv")
head(edu) ## CountryCode is country shortcode

## Match the data based on the country shortcode. Of the countries for 
## which the end of the fiscal year is available, how many end in June?

library(dplyr)
gdp <- gdp %>%
    rename(CountryCode = V1, Ranking = V2, Economy = V4, MillionsOfUSDollars = V5) %>%
    select(CountryCode, Ranking, Economy, MillionsOfUSDollars) %>%
    print

mergedData <- merge(gdp, edu, by.x = "CountryCode", by.y = "CountryCode")
head(mergedData)

## Special.Notes contains fiscal year end information
specialNotes <- mergedData$Special.Notes
specialNotes
grep("^Fiscal year end: June", specialNotes) ## gives indices for 13 obs that match

### Number 5

## You can use the quantmod (http://www.quantmod.com/) package to get 
## historical stock prices for publicly traded companies on the NASDAQ 
## and NYSE. Use the following code to download data on Amazon's stock 
## price and get the times the data was sampled.
library(quantmod)
amzn = getSymbols("AMZN",auto.assign=FALSE)
sampleTimes = index(amzn)

## How many values were collected in 2012? How many values were 
## collected on Mondays in 2012?
sampleTimes
library(lubridate)
sampleTimes <- ymd(sampleTimes)
head(sampleTimes)
class(sampleTimes[1])

library(dplyr)
data2012 <- (sampleTimes >= mdy("01/01/2012") & sampleTimes <= mdy("12/31/2012"))
sum(data2012)
data2012 <- sampleTimes[data2012]
data2012
weekdays <- wday(data2012)
weekdays
mondays2012 <- data2012[wday(data2012) == 2]
mondays2012
length(mondays2012)
