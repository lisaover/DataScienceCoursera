# setwd("~/Google Drive/_Data Science Johns Hopkins/Getting and Cleaning Data")

library(RMySQL)

ucscDb <- dbConnect(MySQL(),user="genome", host="genome-mysql.cse.ucsc.edu")
## show all databases available at host
result <- dbGetQuery(ucscDb,"show databases;"); dbDisconnect(ucscDb)
result

## focus on particular build of human genome - hg19
hg19 <- dbConnect(MySQL(),user="genome", db="hg19", host="genome-mysql.cse.ucsc.edu")
allTables <- dbListTables(hg19)
length(allTables)
allTables[1:5]

## focus on table affyU133Plus2 - get column names and row count
dbListFields(hg19,"affyU133Plus2")
dbGetQuery(hg19, "select count(*) from affyU133Plus2")

## read table affyU133Plus2
affyData <- dbReadTable(hg19, "affyU133Plus2")
head(affyData)

## send and fetch query
query <- dbSendQuery(hg19, "select * from affyU133Plus2 where misMatches between 1 and 3")
affyMis <- fetch(query)
## verify data misMatches is between 1 and 3
quantile(affyMis$misMatches)

## only fetch first 10 records based on query
affyMisSmall <- fetch(query, n=10)
dim(affyMisSmall)

## clear query from server
dbClearResult(query)

## close the connection
dbDisconnect(hg19)
