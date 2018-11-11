# setwd("~/Google Drive/_Data Science Johns Hopkins/R Programming/wk4_pgm_hospital_care/rprog_data_ProgAssignment3-data")

best <- function(state, outcome) {
    ## state: two-character abbreviated name of a state
    ## outcome: name of outcome "heart attack", "heart failure",
    ## "pneumonia"
    
    ## Return: returns the name of the hospital with the lowest
    ## 30-day mortality for the specified state and outcome
    ## if there are more than 1 quaifying hospitals,
    ## returns the first one when sorted alphabetically
    
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
    
    ## read and sort data by state and then hospital name
    data <- read.csv("outcome-of-care-measures.csv", colClasses = "character")
    data <- data[order(data$State, data$Hospital.Name), ]
    
    ## coerce 30-day mortality column for given outcome to numeric
    data[ ,c.num] <- as.numeric(data[ ,c.num])
    
    ## check if state is valid and return error message if not
    if(!is.element(state, data$State)){
        return("Invalid state. Please provide the two-character abbreviation for the state.")
    }
    
    ## return hospital name with the lowest 30-day
    ## mortality rate in the specified state
    o <- data[,c.num][data$State==state]
    m <- min(na.omit(o))
    out <- filter(data, State == state, data[,c.num] == m)
    return(out$Hospital.Name[1])
}

best("TX", "heart attack") ##CYPRESS FAIRBANKS MEDICAL CENTER
best("TX", "heart failure") ##FORT DUNCAN MEDICAL CENTER
best("MD", "heart attack") ##JOHNS HOPKINS HOSPITAL, THE
best("MD", "pneumonia") ##GREATER BALTIMORE MEDICAL CENTER

r <- rankall("heart attack", 4)
as.character(subset(r, states == "HI")[1]) ## CASTLE MEDICAL CENTER

r <- rankall("pneumonia", "worst")
as.character(subset(r, states == "NJ")[1]) ## BERGEN REGIONAL MEDICAL CENTER

r <- rankall("heart failure", 10)
as.character(subset(r, states == "NV")[1])

# states <- sort(unique(data$State))
# outcome <- "pneumonia"
# for(s in states){
#     best(s, outcome)
# }
