# setwd("~/Google Drive/_Data Science Johns Hopkins/Getting and Cleaning Data/wk2_quiz")

### Quiz #2 and #3
## The sqldf package allows for execution of SQL commands on R data frames. 
## We will use the sqldf package to practice the queries we might send with 
## the dbSendQuery command in RMySQL.

## Download the American Community Survey data and load it into an R object 
## called acs

library(sqldf)
## download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06pid.csv", "acs.csv")
acs <- read.csv.sql("acs.csv")
# acs <- read.csv.sql(file, sql = "select pwgtp1 from acs", header = TRUE, sep = ",")

## Which of the following commands will select only the data for the probability weights 
## pwgtp1 with ages less than 50?
sqldf("select pwgtp1 from acs")
sqldf("select * from acs")
sqldf("select * from acs where AGEP < 50 and pwgtp1")
sqldf("select pwgtp1 from acs where AGEP < 50")

## Using the same data frame you created in the previous problem, what is the 
## equivalent function to unique(acs$AGEP)
sqldf("select distinct AGEP from acs")
sqldf("select unique AGEP from acs")
