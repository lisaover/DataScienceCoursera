# setwd("~/Google Drive/_Data Science Johns Hopkins/R Programming/wk2_pgm_air_pollution")
# source('corr.R')
# source('complete.R')

## R Programming PART 3 ##

corr <- function(directory, threshold = 0) {
    ## 'directory' is a character vector of length 1 indicating 
    ## the location of the CSV files
    
    ## 'threshold' is a numeric vector of length 1 indicating the
    ## number of completely observed observations (on all
    ## variables) required to compute the correlation between
    ## nitrate and sulfate; the default is 0
    
    ## Return a numeric vector of correlations
    ## NOTE: Do not round the result!
    
    ## create an empty vector for result
    corr.vect <- c()
    
    ## create directory path to read in all .csv filenames
    # path <- paste(directory, "/*.csv", sep = "")
    # files <- (Sys.glob(path))
    
    ## use complete function result to create table of monitors the meet 
    ## threshold requirment
    cases <- complete(directory)
    thresh.cases <- cases[cases$nobs >= threshold,]
    
    ## if thresh.cases has rows
    ## calculate the correlation between nitrate and sulfate for each monitor
    if(nrow(thresh.cases) > 0) {
        for(i in thresh.cases$id) {
            
            ## use the value of the iteration number i to create a string
            if(i < 10) {
                monitor <- paste("00", toString(i), sep = "")
            }
            else if(i < 100) {
                monitor <- paste("0", toString(i), sep = "")
            }
            else {
                monitor <- toString(i)
            }
            
            ## create the path to the filename based on the iteration number
            filename <- paste(directory, "/", monitor, ".csv", sep = "")
            
            ## read in the file; calculate correlation and add to result
            temp <- read.csv(filename, stringsAsFactors=FALSE)
            temp.c <- temp[complete.cases(temp),]
            if(nrow(temp.c) > 0) {
                corr.vect <- c(corr.vect, cor(temp.c[["sulfate"]], temp.c[["nitrate"]]))
            }
        }
    }
    corr.vect
}

## Test ##
cr <- corr("specdata", 150)
cr <- corr("specdata", 400)
cr <- corr("specdata", 5000)
cr <- corr("specdata")
head(cr)
summary(cr)
length(cr)
