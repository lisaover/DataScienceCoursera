setwd("~/Google Drive/_Data Science Johns Hopkins/Getting and Cleaning Data/Course Project")

#### 1. Download and unzip files
fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileURL, destfile="./Dataset.zip")
unzip(zipfile="./Dataset.zip", exdir=".")

#### 2. Merge training and test sets to create one dataset
library(dplyr)

## Read activity labels containing activity id and activity name pairs
activity_labels <- tbl_df(read.table("./UCI HAR Dataset/activity_labels.txt"))

## Read feature vector containing column names for data
features <- read.table("./UCI HAR Dataset/features.txt")

## Read training files: subjects, labels, and data
subject_train <- tbl_df(read.table("./UCI HAR Dataset/train/subject_train.txt"))
y_train <- tbl_df(read.table("./UCI HAR Dataset/train/y_train.txt"))
x_train <- tbl_df(read.table("./UCI HAR Dataset/train/X_train.txt"))

## Read testing files: subjects, labels, and data
subject_test <- tbl_df(read.table("./UCI HAR Dataset/test/subject_test.txt"))
y_test <- tbl_df(read.table("./UCI HAR Dataset/test/y_test.txt"))
x_test <- tbl_df(read.table("./UCI HAR Dataset/test/X_test.txt"))

## Assign column names
colnames(subject_test) <- "subjectID"
colnames(y_test) <- "activityID"
colnames(x_test) <- features[,2]

colnames(subject_train) <- "subjectID"
colnames(y_train) <- "activityID"
colnames(x_train) <- features[,2]

colnames(activity_labels) <- c("activityID", "activityType")

## Merge training data and add column for dataset "train"
all_train <- bind_cols(subject_train, y_train, x_train)
all_train <- mutate(all_train, dataset = "train")

## Merge testing data and add column for dataset "test"
all_test <- bind_cols(subject_test, y_test, x_test)
all_test <- mutate(all_test, dataset = "test")

## Merge training and testing data
all_data <- bind_rows(all_train, all_test)

#### 3. Extract only the measurements on the mean and standard deviation
## Read column names
data_columns <- colnames(all_data)

## Create a vector to define mean and standard deviation
## Keep subjectID and activityID
ids_mean_std <- (grepl("subjectID", data_columns) | grepl("activityID", data_columns) | grepl("mean..", data_columns) | grepl("std..", data_columns))

## Use above vector to extract desired measurements from all_data
mean_std_dataset <- all_data[ , ids_mean_std == TRUE]

#### 4. Use descriptive activity names to name the activities in the dataset
mean_std_dataset <- left_join(mean_std_dataset, activity_labels)
mean_std_dataset <- select(mean_std_dataset, subjectID, activityType, "tBodyAcc-mean()-X":"fBodyBodyGyroJerkMag-meanFreq()")

#### 5. Confirm dataset uses descriptive variable names 
mean_std_dataset

#### 6. Create a second, independent tidy data set with the average 
#### of each variable for each activity and each subject
## Check for NA values
sum(is.na(mean_std_dataset))

## Group by activityType and subjectID
grp_mean_std_dataset <- mean_std_dataset %>% 
    group_by(activityType, subjectID) %>%
    summarise_all(funs(mean = mean(., na.rm = TRUE)))

#### 7. Make Codebook for the datasets
#### mean_std_dataset and grp_mean_std_dataset
library(dataMaid)
makeCodebook(mean_std_dataset)
makeCodebook(grp_mean_std_dataset)
