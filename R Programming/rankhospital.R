# setwd("~/Google Drive/_Data Science Johns Hopkins/R Programming/wk4_pgm_hospital_care/rprog_data_ProgAssignment3-data")

rankhospital <- function(state, outcome, num = "best") {
    ## state: two-character abbreviated name of a state
    ## outcome: name of outcome "heart attack", "heart failure",
    ## "pneumonia"
    ## num: the rank of the hospital in the specified state
    
    ## Return: returns returns the name of the hospital whose 30-day mortality rate 
    ## equals the rate specified by 'num' for the specified state and outcome
    ## returns NA if num is greater than max number of hospitals for which data
    ## is available
    
    ## load libraries
    library(dplyr)
    library(tidyr)
    
    ## assign column number based on outcome value
    ## return error message if outcome is invalid
    if (outcome == "heart attack") {
        c.num <- 11
    }
    else if (outcome == "heart failure") {
        c.num <- 17
    }
    else if (outcome == "pneumonia") {
        c.num <- 23
    }
    else {
        return("Invalid outcome. Please specify heart attack, heart failure, or pneumonia.")
    }
    
    ## read and sort data by 1) state 2) rate 3) hospital name
    data <- read.csv("outcome-of-care-measures.csv", colClasses = "character")
    # data <- arrange_(data, c('State', 'Hospital.Name'))
    
    ## coerce 30-day mortality column for given outcome to numeric
    data[ ,c.num] <- as.numeric(data[ ,c.num])
    
    ## sort by  1) state 2) 30-day death rate for specified outcome 3) hospital name
    data <- data[order(data$State, data[c.num], data$Hospital.Name), ]
    
    ## check if state is valid and return error message if not
    if(!is.element(state, data$State)){
        return("Invalid state. Please provide the two-character abbreviation for the state.")
    }
    
    ## select rows for given state
    d <- data[,c.num][data$State==state]
    
    if(num == "best") {
        ## return hospital name with the lowest 30-day
        ## mortality rate in the specified state
        m <- min(na.omit(d))
        out <- filter(data, State == state, data[,c.num] == m)
        return(out$Hospital.Name[1])
    }
    else if(num == "worst") {
        ## return hospital name with the highest 30-day
        ## mortality rate in the specified state
        m <- max(na.omit(d))
        out <- filter(data, State == state, data[,c.num] == m)
        return(out$Hospital.Name[1])
    }
    else if(num > length(filter(data, State == state))) {
        return(NA)
    }
    else {
        m <- na.omit(d)
        out <- filter(data, State == state)
        return(out$Hospital.Name[num])
    }
}

rankhospital("TX", "heart failure", 4) ## DETAR HOSPITAL NAVARRO
rankhospital("MD", 'heart attack', 'worst') ## HARFORD MEMORIAL HOSPITAL
rankhospital("MN", "heart attack", 5000) ## NA
