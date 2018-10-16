setwd("~/Google Drive/_Data Science Johns Hopkins/R Programming/wk4_pgm_global_warming")
x <- read.csv("climate-data.csv")

# Extract the first 2 rows of the data frame and print them to the console. What does the output look like?
x[1:2,]

# How many observations (i.e. rows) are in this data frame?
nrow(x)

# Extract the last 2 rows of the data frame and print them to the console. What does the output look like?
x[152:153,]

# What is the value of Ozone in the 47th row?
x[47,]

# How many missing values are in the Ozone column of this data frame?
sum(is.na(x$Ozone))

# What is the mean of the Ozone column in this dataset? Exclude missing values (coded as NA) from this calculation.
Subs1 <- na.omit(x$Ozone)
mean(Subs1)

# Extract the subset of rows of the data frame where Ozone values are above 31 and Temp values are above 90. What is the mean of Solar.R in this subset?
s <- subset(x, Ozone > 31 & Temp > 90)
mean(s$Solar.R)

# What is the mean of "Temp" when "Month" is equal to 6? 
t <- subset(x, Month == 6)
mean(t$Temp)

# What was the maximum ozone value in the month of May (i.e. Month is equal to 5)?
m <- na.omit(m$Ozone)
max(m)