# setwd("~/Google Drive/_Data Science Johns Hopkins/Getting and Cleaning Data/wk1_quiz")
library(dplyr)
library(tidyr)
library(readr)
library(readxl)
library(XML)
library(data.table)
library(tictoc)

# download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv", "ACS_Idaho_Microdata.csv")
# download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FPUMSDataDict06.pdf", "ACS_Idaho_Code_book.pdf")

df <- read.csv("ACS_Idaho_Microdata.csv")
idaho <- tbl_df(df)
idaho
value <- select(idaho, VAL)
value
million <- filter(idaho, VAL == 24)
million

# download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FDATA.gov_NGAP.xlsx", "ngap.xlsx")
df <- read_excel("ngap.xlsx", range = "G18:O23")
dat <- tbl_df(df)

# download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Frestaurants.xml", "balt.xml")
## use 'http' instead of 'https' with xmlTreeParse
balt <- xmlTreeParse("http://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Frestaurants.xml", useInternalNodes = TRUE)
rows <- getNodeSet(balt, "//row[zipcode=21231]")
z <- xmlToDataFrame(nodes = rows)
nrow(z)

download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06pid.csv", "Idaho_2006.csv")
DT <- fread("Idaho_2006.csv")
system.time(mean(DT$pwgtp15,by=DT$SEX))
system.time(DT[,mean(pwgtp15),by=SEX]) ## FASTEST
system.time({rowMeans(DT)[DT$SEX==1]; rowMeans(DT)[DT$SEX==2]})
system.time({mean(DT[DT$SEX==1,]$pwgtp15); mean(DT[DT$SEX==2,]$pwgtp15)})
system.time(tapply(DT$pwgtp15,DT$SEX,mean))
system.time(sapply(split(DT$pwgtp15,DT$SEX),mean))

