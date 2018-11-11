# setwd("~/Google Drive/_Data Science Johns Hopkins/R Programming/wk4_pgm_hospital_care/rprog_data_ProgAssignment3-data")

rankall <- function(outcome, num = "best") {
    ## outcome: name of outcome "heart attack", "heart failure",
    ## "pneumonia"
    ## num: the rank of the hospital
    
    ## Return: returns a two-column data frame with the name 
    ## of the hospital in each state that has the ranking
    ## specified by num 
    
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
    data <- subset(data, select=c(7,2,c.num))
    
    ## coerce 30-day mortality column for given outcome to numeric
    ## extract only complete cases
    data[ ,3] <- as.numeric(data[ ,3])
    data <- na.omit(data)
    
    ## sort by  1) state 2) 30-day death rate for specified outcome 3) hospital name
    data <- data[order(data$State, data[3], data$Hospital.Name), ]
    
    ## create empty vector for result
    hospital.vect <- c()
    
    ## get list of states and iterate through the data frame
    states <- sort(unique(data$State))
    for(state in states) {
        out <- filter(data, State == state)
        
        if(num == "best") {
            ## add hospital name with the lowest 30-day
            ## mortality rate in the specified state
            hospital.vect <- c(hospital.vect, out$Hospital.Name[1])
        }
        else if(num == "worst") {
            ## add hospital name with the highest 30-day
            ## mortality rate in the specified state
            hospital.vect <- c(hospital.vect, out$Hospital.Name[nrow(out)])
        }
        else if(num > nrow(out)) {
            hospital.vect <- c(hospital.vect, NA)
        }
        else {
            ## add hospital name with the rank 'num' for 30-day
            ## mortality rate in the specified state
            hospital.vect <- c(hospital.vect, out$Hospital.Name[num])
        }
    }
    result <- as.data.frame(cbind(hospital.vect, states))
    colnames(result) <- c("hospital", "state")
    result
}

r <- rankall("heart attack", 5)


head(rankall("heart attack", 20), 10)
tail(rankall("pneumonia", "worst"), 3)
tail(rankall("heart attack", "best"), 10)

r <- rankall("heart attack", 4)
as.character(subset(r, state == "HI")$hospital)

r <- rankall("pneumonia", "worst")
as.character(subset(r, state == "NJ")$hospital)

r <- rankall("heart failure", 10)
as.character(subset(r, state == "NV")$hospital)

## get index of State and Hospital.Name columns
# grep("State", colnames(data))
# grep("Hospital.Name", colnames(data))