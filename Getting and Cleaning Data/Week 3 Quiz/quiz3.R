# setwd("~/Google Drive/_Data Science Johns Hopkins/Getting and Cleaning Data/wk3_quiz")

### Number 1

# download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv", "idaho.csv")
# download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FPUMSDataDict06.pdf", "idaho.pdf")

## Create a logical vector that identifies the households on 
## greater than 10 acres who sold more than $10,000 worth of  
## agriculture products. Assign that logical vector to the 
## variable agricultureLogical. Apply the which() function like 
## this - which(agricultureLogical) - to identify the rows of 
## the data frame where the logical vector is TRUE.

## What are the first 3 values that result?

# ACR == 3 ## House on ten or more acres
# AGS == 6 ## $10000+

idaho <- read.csv("idaho.csv")
agricultureLogical <- idaho$ACR == 3 & idaho$AGS == 6
which(agricultureLogical)

### Number 2

## Using the jpeg package read in the following picture 
## of your instructor into R. Use the parameter native=TRUE.

## What are the 30th and 80th quantiles of the resulting data?

# download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fjeff.jpg", "img.jpeg")
image <- readJPEG("img.jpeg", native = TRUE)
quantile(image, probs = c(0.3, 0.8))

### Number 3

## Load the Gross Domestic Product data for the 190 ranked countries.
## Load the educational data.

# download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv", "gdp.csv")
# download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv", "edu.csv")

gdp <- read.csv("gdp.csv", skip = 5, nrows = 215, header = FALSE)
head(gdp) ## V1 is country shortcode
tail(gdp)
edu <- read.csv("edu.csv")
head(edu) ## CountryCode is country shortcode

## Match the data based on the country shortcode. How many of the IDs match? 
## Sort the data frame in descending order by GDP rank (so United States is last). 
## What is the 13th country in the resulting data frame?

library(dplyr)
gdp <- gdp %>%
    rename(CountryCode = V1, Ranking = V2, Economy = V4, MillionsOfUSDollars = V5) %>%
    select(CountryCode, Ranking, Economy, MillionsOfUSDollars) %>%
    print

mergedData <- merge(gdp, edu, by.x = "CountryCode", by.y = "CountryCode")
head(mergedData)
mergedData <- arrange(mergedData, desc(Ranking))
head(mergedData, 13)
dim(mergedData)
tail(mergedData, 22) ## USA is ranked 1 and at spot 189
mergedData <- filter(mergedData, !is.na(Ranking))
dim(mergedData)

### Number 4
## What is the average GDP ranking for the "High income: OECD" 
## and "High income: nonOECD" group? 
mergedData <- group_by(mergedData, Income.Group)
mergedData
summarize(mergedData, mean(Ranking))

### Number 5
## Cut the GDP ranking into 5 separate quantile groups. 
## Make a table versus Income.Group. How many countries
## are Lower middle income but among the 38 nations with 
## highest GDP?
mergedData <- ungroup(mergedData)
quant <- quantile(mergedData$Ranking, probs = c(0, 0.2, 0.4, 0.6, 0.8, 1))
quantRank <- cut(mergedData$Ranking, quant, incude.lowest = TRUE)
mergedData <- mutate(mergedData, Rank.Quant = quantRank)

table(mergedData$Income.Group, mergedData$Rank.Quant)

## Original data sources:
## http://data.worldbank.org/data-catalog/GDP-ranking-table
## http://data.worldbank.org/data-catalog/ed-stats