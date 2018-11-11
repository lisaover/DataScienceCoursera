# setwd("~/Google Drive/_Data Science Johns Hopkins/R Programming/wk2_pgm_air_pollution")
# source('pollutantmean.R')

## R Programming PART 1 ##

pollutantmean <- function(directory, pollutant, id = 1:332) {
    ## 'directory' is a character vector of length 1 indicating
    ## the location of the CSV files
    
    ## 'pollutant' is a character vector of length 1 indicating
    ## the name of the pollutant for which we will calculate the
    ## mean; eiher "sulfate" or "nitrate".
    
    ## 'id' is an integer vector indicating the monitor ID numbers
    ## to be used
    
    ## Return the mean of the pollutant across all monitors listed
    ## in the 'id' vector (ignoring NA values)
    ## NOTE: Do not round the result!
    
    for(i in id) {
        
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
        
        ## if the data frame 'dat' exists, read the current file; bind the rows to dat
        if(exists("dat")) {
            temp <- read.csv(filename, stringsAsFactors=FALSE)
            dat <- rbind(dat, temp)
        } 
        ## if dat does not exist, create it and place in it data from the first file
        else {
            dat <- data.frame(read.csv(filename, header = TRUE, stringsAsFactors=FALSE))
        }
    }
    ## return the mean of the specified pollutant after omitting NAs
    mean(na.omit(dat[[pollutant]]))
}

## Test ##
# avgSulfate <- pollutantmean("specdata", "sulfate")
# avgNitrate <- pollutantmean("specdata", "nitrate")
# pollutantmean("specdata", "sulfate", 1:10) ## [1] 4.064128
# pollutantmean("specdata", "nitrate", 70:72) ## [1] 1.706047
# pollutantmean("specdata", "nitrate", 23) ## [1] 1.280833

## Added "stringsAsFactors=FALSE" to address the following warning
## Warning message:
## In `[<-.factor`(`*tmp*`, ri, value = 3.18936865762216) :
##    invalid factor level, NA generated