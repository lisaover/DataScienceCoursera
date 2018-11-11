# setwd("~/Google Drive/_Data Science Johns Hopkins/R Programming/wk2_pgm_air_pollution")
# source('complete.R')

## R Programming PART 2 ##

complete <- function(directory, id = 1:332) {
    ## 'directory' is a character vector of length 1 indicating
    ## the location of the CSV files
    
    ## 'id' is an integer vector indicating the monitor ID numbers 
    ## to be used
    
    ## Return a data frame of the form:
    ## id   nobs
    ## 1    117
    ## 2    1041
    ## ...
    ## where 'id' is the monitor ID number and 'nobs' is the 
    ## number of complete cases
    
    ## create an empty vector for result
    nrow.vect <- c()
    
    ## use the value of the iteration number i to create a string
    for(i in id) {
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
        
        ## read in the current file; create a vector of the monitor number and 
        ## number of complete cases
        temp <- read.csv(filename, stringsAsFactors=FALSE)
        temp.c <- temp[complete.cases(temp),]
        nrow.vect <- c(nrow.vect, nrow(temp.c))
    }
    ## create a data frame with the two vectors - monitor 'id' and number of rows 'nrow.vect'
    summ <- data.frame(id, nrow.vect)
    ## assign column names and return
    colnames(summ) <- c("id", "nobs")
    summ
}

## Test ##
# cases.df <- complete("specdata", 1)
# cases.df <- complete("specdata", c(2, 4, 8, 10, 12))
# cases.df <- complete("specdata", 30:25)
# cases.df <- complete("specdata", 3)
# print(cases.df)