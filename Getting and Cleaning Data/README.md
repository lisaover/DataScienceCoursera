Human Activity Recognition Using Smartphones Dataset
----------------------------------------------------

#### **Study Citation**

Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L.
Reyes-Ortiz. Human Activity Recognition on Smartphones using a
Multiclass Hardware-Friendly Support Vector Machine. International
Workshop of Ambient Assisted Living (IWAAL 2012). Vitoria-Gasteiz,
Spain. Dec 2012

#### **Study Information**

The Human Activity Recognition Using Smartphones study involved 30
subjects each performing six activities (WALKING, WALKING\_UPSTAIRS,
WALKING\_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone
(Samsung Galaxy S II) on the waist. Measurements of 3-axial linear
acceleration and 3-axial angular velocity were recorded from the phone's
embedded accelerometer and gyroscope. The dataset was split into a
training set (70%) and a testing set (30%). The study data contains
files with derived or calculated data, and these files are the relevant
files for this project:

-   The *UCI HAR Dataset* folder contains the following files

    -   **features.txt** contains a 561 element vector of features for
        the derived or calculated data

    -   **features\_info.txt** contains information about the 561
        features for the derived or calculated data

    -   **activity\_labels.txt** contains two columns to match activity
        identifiers with activity types

-   The *train* and *test* folders within the *UCI HAR Dataset* folder
    contain the training and testing data files, respectively

    -   **X\_train.txt** and **X\_test.txt** contain the derived or
        calculated data

    -   **subject\_train** and **subject\_test** contain subject
        identifiers where each row corresponds to a row in the
        aggragated data file

    -   **y\_train.txt** and **y\_test** contain activity identifiers
        where each row corresponds to the aggragated data file

For more information about the study, please see the study README.txt
file located in the *UCI HAR Dataset* folder. You may also visit UCI's
Machine Learning Repository:
<http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones>

#### Raw Data Files

The raw values for this study are located in the *Inertial Signals*
folders within the *train* and *test* folders. These files were not used
for this project.

#### **run\_analysis.R**

This R script uses the subject, labels, features, and calculated data
files to create two data frames. The **mean\_std\_dataset** consists of
the subjectID, activityType, and features that are measures of the mean
or standard deviation. The **grp\_mean\_std\_dataset** consists of the
mean of the same variables grouped by activity type and subject id.

This script performs the following tasks:

1.  Download and unzip files

2.  Merge training and test sets to create one dataset

3.  Extract only the measurements on the mean and standard deviation

4.  Uses descriptive activity names to name the activities in the data
    set

5.  Confrm dataset uses descriptive variable names

6.  Use descriptive activity names to name the activities in the dataset

##### 1. Download and unzip files.

    fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
    download.file(fileURL, destfile="./Dataset.zip")
    unzip(zipfile="./Dataset.zip", exdir=".") 

##### 2. Merge training and test sets to create one dataset.

    library(dplyr)

    ## 
    ## Attaching package: 'dplyr'

    ## The following objects are masked from 'package:stats':
    ## 
    ##     filter, lag

    ## The following objects are masked from 'package:base':
    ## 
    ##     intersect, setdiff, setequal, union

###### 2.1 Read activity labels containing activity id and activity name pairs.

    activity_labels <- tbl_df(read.table("./UCI HAR Dataset/activity_labels.txt"))

###### 2.2 Read feature vector containing column names for data.

    features <- read.table("./UCI HAR Dataset/features.txt")

###### 2.3 Read training files: subjects, labels, and data.

    subject_train <- tbl_df(read.table("./UCI HAR Dataset/train/subject_train.txt"))
    y_train <- tbl_df(read.table("./UCI HAR Dataset/train/y_train.txt"))
    x_train <- tbl_df(read.table("./UCI HAR Dataset/train/X_train.txt"))

###### 2.4 Read testing files: subjects, labels, and data.

    subject_test <- tbl_df(read.table("./UCI HAR Dataset/test/subject_test.txt"))
    y_test <- tbl_df(read.table("./UCI HAR Dataset/test/y_test.txt"))
    x_test <- tbl_df(read.table("./UCI HAR Dataset/test/X_test.txt"))

###### 2.5 Assign column names.

    colnames(subject_test) <- "subjectID"
    colnames(y_test) <- "activityID"
    colnames(x_test) <- features[,2]

    colnames(subject_train) <- "subjectID"
    colnames(y_train) <- "activityID"
    colnames(x_train) <- features[,2]

    colnames(activity_labels) <- c("activityID", "activityType")

###### 2.6 Merge training data and add column for "train"" dataset.

    all_train <- bind_cols(subject_train, y_train, x_train)
    all_train <- mutate(all_train, dataset = "train")

###### 2.7 Merge testing data and add column for "test" dataset.

    all_test <- bind_cols(subject_test, y_test, x_test)
    all_test <- mutate(all_test, dataset = "test")

###### 2.8 Merge training and testing data.

    all_data <- bind_rows(all_train, all_test)

##### 3. Extract only the measurements on the mean and standard deviation.

###### 3.1 Read column names.

    data_columns <- colnames(all_data)

###### 3.2 Create a vector to define mean and standard deviation keep subjectID and activityID.

    ids_mean_std <- (grepl("subjectID", data_columns) | grepl("activityID", data_columns) | grepl("mean..", data_columns) | grepl("std..", data_columns))

###### 3.3 Use above vector to extract desired measurements from all\_data.

    mean_std_dataset <- all_data[ , ids_mean_std == TRUE]

##### 4. Use descriptive activity names to name the activities in the dataset.

    mean_std_dataset <- left_join(mean_std_dataset, activity_labels)

    ## Joining, by = "activityID"

    mean_std_dataset <- select(mean_std_dataset, subjectID, activityType, "tBodyAcc-mean()-X":"fBodyBodyGyroJerkMag-meanFreq()")

##### 5. Confirm dataset uses descriptive variable names.

    mean_std_dataset

##### 6. Create a second, independent tidy data set with the average of each variable for each activity and each subject.

###### 6.1 Check for NA values.

    sum(is.na(mean_std_dataset))

###### 6.2 Group by activityType and subjectID.

    grp_mean_std_dataset <- mean_std_dataset %>% 
        group_by(activityType, subjectID) %>%
        summarise_all(funs(mean = mean(., na.rm = TRUE)))

Codebooks
---------

A codebook was created for each of the resulting datasets:

-   codebook\_mean\_std\_dataset.md

-   codebook\_grp\_mean\_std\_dataset.md
