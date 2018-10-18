## R Programming course files

### Global Warming
* climate-data.R
* climate-data.csv <br/><br/>
Extracts information from the climate-data.csv file containing average daily climate-related measures for unknown year. File has the following columns: Ozone, Solar.R, Wind, Temp, Month, Day.

### Air Quality
* pollutantmean.R
* complete.R
* corr.R
* specdata.zip <br/><br/>
The specdata.zip file contains 332 .csv files, one for each monitor location in the United States, which contain pollution monitoring data for fine particulate matter (PM) air pollution. Each location has a monitor id number, and this id number cooresponds to the filename of the .csv file containing the location's pollution data.  <br/><br/>
The variables include: 
* Date: the date of the observation in YYYY-MM-DD format (year-month-day)
* sulfate: the level of sulfate PM in the air on that date (measured in micrograms per cubic meter)
* nitrate: the level of nitrate PM in the air on that date (measured in micrograms per cubic meter) <br/><br/>
The pollutantmean.R file contains a function that returns the mean of the pollutant (sulfate or nitrate) across all monitors listed in the 'id' vector (ignoring NA values). <br/><br/>
The complete.R file contains a function that returns a data frame with a row for each monitor and two columns, the monitor id number and the number of complete cases for the respective monitor. <br/><br/>
The corr.R file contains a function that returns a numeric vector of sulfate and nitrate correlations for the mointors listed in the 'id' vector.

### Cache Matrix
* cachematrix.R
* cachematrix.md <br/><br/>
The cachematrix.R file contains functions makeCacheMatrix and cacheSolve, which work together to solve for the inverse of a matix and to cache the matrix and its inverse. Instructions for this programming assignment are in the cachematrix.md file.

### Loop Functions
* wk3_quiz_loop_funcs.R <br/><br/>
Uses the loop functions apply, sapply, and tapply to work with the Iris dataset in R.

### Hospital Care
* best.R
* rankhospital.R
* rankall.R
* outcome-of-care-measures.csv <br/><br/>
The outcome-of-care-measures.csv file contains care data on hosptials in the United States. The measures of interest for this project include: <br/><br/>
* State
* Hospital Name
* 30-day mortality rate for heart attacks
* 30-day mortality rate for heart failure
* 30-day mortality rate for pneumonia <br/><br/>
The best.R file contains a function that returns the name of the hospital with the lowest 30-day mortality for the specified state and outcome (heart attack, heart failure, pneumonia). <br/><br/>
The rankhospital.R file contains a function that returns the name of the hospital whose 30-day mortality rate equals the rate specified by 'num' for the specified state and outcome. <br/><br/>
The rankall.R file contains a function that returns returns a two-column data frame with the name of the hospital in each state that has the ranking specified by 'num.'
