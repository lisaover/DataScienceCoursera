# setwd("~/Google Drive/_Data Science Johns Hopkins/Getting and Cleaning Data/wk2_quiz")

### Quiz #5
## Read this data set into R and report the sum of the numbers in the fourth of 
## the nine columns.
## https://d396qusza40orc.cloudfront.net/getdata%2Fwksst8110.for

## Original source of the data: http://www.cpc.ncep.noaa.gov/data/indices/wksst8110.for
## (Hint this is a fixed width file format)

library(read.table)

## flat file .for
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fwksst8110.for", "data.for")
data <- read.fwf(
    file=url("https://d396qusza40orc.cloudfront.net/getdata%2Fwksst8110.for"),
    skip=4,
    widths=c(11, 8, 4, 9, 4, 9, 4, 9, 4))
head(data)
data.df <- as.data.frame(data)
head(data.df)
sum(data.df[,4])
