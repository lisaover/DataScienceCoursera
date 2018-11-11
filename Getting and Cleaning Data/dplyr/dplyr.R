setwd("~/Google Drive/_Data Science Johns Hopkins/Getting and Cleaning Data/tidyr swirl code")

## One unique aspect of dplyr is that the same set of tools allow you to
## work with tabular data from a variety of sources, including data
## frames, data tables, databases and multidimensional arrays. In this
## lesson, we'll focus on data frames, but everything you learn will
## apply equally to other formats.

## As you may know, "CRAN is a network of ftp and web servers around the
## world that store identical, up-to-date, versions of code and
## documentation for R" (http://cran.rstudio.com/). RStudio maintains
## one of these so-called 'CRAN mirrors' and they generously make their
## download logs publicly available (http://cran-logs.rstudio.com/).
## We'll be working with the log from July 8, 2014, which contains
## information on roughly 225,000 package downloads.

mydf <- read.csv("cran.csv", stringsAsFactors = FALSE)

library(dplyr)

cran <- tbl_df(mydf)
rm("mydf")

## Type "cran": First, we are shown the class and dimensions of the dataset. Just
## below that, we get a preview of the data. Instead of attempting to
## print the entire dataset, dplyr just shows us the first 10 rows of
## data and only as many columns as fit neatly in our console. At the
## bottom, we see the names and classes for any variables that didn't
## fit on our screen.
cran

## According to the "Introduction to dplyr" vignette written by the
## package authors, "The dplyr philosophy is to have small functions
## that each do one thing well." Specifically, dplyr supplies five
## 'verbs' that cover most fundamental data manipulation tasks:
## select(), filter(), arrange(), mutate(), and summarize().

select(cran, ip_id, package, country)
select(cran, r_arch:country)
select(cran, country:r_arch)
select(cran, -time)
select(cran, -(X:size))

filter(cran, package == "swirl")
filter(cran, r_version == "3.1.1", country == "US")
filter(cran, r_version <= "3.0.2", country == "IN")
filter(cran, country == "US" | country == "IN")
filter(cran, size > 100500, r_os == "linux-gnu")
filter(cran, !is.na(r_version))

cran2 <- select(cran, size:ip_id)
arrange(cran2, ip_id)
arrange(cran2, desc(ip_id))
arrange(cran2, package, ip_id)
arrange(cran2, country, desc(r_version), ip_id)

cran3 <- select(cran, ip_id, package, size)
# convert bytes to megabytes
mutate(cran3, size_mb = size / 2^20)
mutate(cran3, size_mb = size / 2^20, size_gb = size_mb / 2^10)
mutate(cran3, correct_size = size + 1000)

summarize(cran, avg_bytes = mean(size))

## summarize grouped data
by_package <- group_by(cran, package)
summarize(by_package, mean(size))
## The 'count' column, created with n(), contains the total number of
## rows (i.e. downloads) for each package. The 'unique' column, created
## with n_distinct(ip_id), gives the total number of unique downloads
## for each package, as measured by the number of distinct ip_id's. The
## 'countries' column, created with n_distinct(country), provides the
## number of countries in which each package was downloaded. And
## finally, the 'avg_bytes' column, created with mean(size), contains
## the mean download size (in bytes) for each package.
pack_sum <- summarize(by_package,
                      count = n(),
                      unique = n_distinct(ip_id),
                      countries = n_distinct(country),
                      avg_bytes = mean(size))
## Isolate the top 1% of packages, based on the total number of
## downloads as measured by the 'count' column. We need to know the value of 'count' that splits the data into the
## top 1% and bottom 99% of packages based on total downloads. In
## statistics, this is called the 0.99, or 99%, sample quantile. Use
## quantile(pack_sum$count, probs = 0.99) to determine this number.
quantile(pack_sum$count, probs = 0.99) ## 679.56
## Select all rows frompack_sum for which 'count' is strictly greater
## that 679
top_counts <- filter(pack_sum, count > 679)
## View all 61 rows
View(top_counts)
top_counts_sorted <- arrange(top_counts, desc(count))
View(top_counts_sorted)
## If we use total number of downloads as our metric for popularity,
## then the above output shows us the most popular packages downloaded
## from the RStudio CRAN mirror on July 8, 2014.

## Perhaps we're more interested in the number of *unique* downloads on
## this particular day. In other words, if a package is downloaded ten
## times in one day from the same computer, we may wish to count that as
## only one download.
quantile(pack_sum$unique, probs = 0.99) ## 465
top_unique <- filter(pack_sum, unique > 465)
View(top_unique)
top_unique_sorted <- arrange(top_unique, desc(unique))
View(top_unique_sorted)

## Chaining allows you to string together multiple function calls in a
## way that is compact and readable, while still accomplishing the
## desired result.
result2 <-
    arrange(
        filter(
            summarize(
                group_by(cran,
                         package
                ),
                count = n(),
                unique = n_distinct(ip_id),
                countries = n_distinct(country),
                avg_bytes = mean(size)
            ),
            countries > 60
        ),
        desc(countries),
        avg_bytes
    )

print(result2)

## Use the special chaining operator, %>%, which
## was originally introduced in the magrittr R package and has now
## become a key component of dplyr.
result3 <-
    cran %>%
    group_by(package) %>%
    summarize(count = n(),
              unique = n_distinct(ip_id),
              countries = n_distinct(country),
              avg_bytes = mean(size)
    ) %>%
    filter(countries > 60) %>%
    arrange(desc(countries), avg_bytes)

# Print result to console
print(result3)

## More chaining examples
cran %>%
    select(ip_id, country, package, size) %>%
    print

cran %>%
    # select specified columns
    select(ip_id, country, package, size) %>%
    # add calculated column size_mb
    mutate(size_mb = size / 2^20) %>%
    # filter rows with size_mb greater than or equal to 0.5
    filter(size_mb <= 0.5) %>%
    # arrange by size_mb in descending order
    arrange(desc(size_mb)) %>%
    print

library(tidyr)
library(readr)
df <- read.csv("students.csv")
students <- tbl_df(df)
df <- read.csv("students2.csv")
students2 <- tbl_df(df)
df <- read.csv("students3.csv")
students3 <- tbl_df(df)
df <- read.csv("students4.csv")
students4 <- tbl_df(df)
df <- read.csv("passed.csv")
passed <- tbl_df(df)
df <- read.csv("failed.csv")
failed <- tbl_df(df)
df <- read.csv("sat.csv")
sat <- tbl_df(df)

gather(students, sex, count, -grade)

res <- gather(students2, key = sex_class, value = count, -grade)
separate(data = res, col = sex_class, into = c("sex", "class"))
## OR
students2 %>%
    gather(key = sex_class, value = count, -grade) %>%
    separate(col = sex_class , c("sex", "class")) %>%
    print

students3 %>%
    ## gather the columns class1 through class5 into a new variable called class
    ## each student is enrolled in only 2 of the 5 class - remove NA
    gather(class, grade, class1:class5, na.rm = TRUE) %>%
    ## turn the values of the test column, midterm and final, into
    ## column headers (i.e. variables)
    spread(test, grade) %>%
    ## change the values in the class columns to be
    ## 1, 2, ..., 5 instead of class1, class2, ..., class5
    mutate(class = parse_number(class)) %>%
    print

student_info <- students4 %>%
    ## select the id, name, and sex column from students4
    ## and store the result in student_info - keep unique
    select(id, name, sex) %>%
    unique %>%
    print

gradebook <- students4 %>%
    ## select() the id, class, midterm, and final columns
    ## (in that order) and store the result in gradebook
    select(id, class, midterm, final) %>%
    unique %>%
    print

passed <- passed %>% mutate(status = "passed")
failed <- failed %>% mutate(status = "failed")
bind_rows(passed, failed)

## SAT dataset
sat %>%
    ## select all columns that do NOT contain the word "total"
    select(-contains("total")) %>%
    ## gather all columns EXCEPT score_range, using
    ## key = part_sex and value = count
    gather(part_sex, count, -score_range) %>%
    ##separate part_sex into two separate variables (columns),
    ## called "part" and "sex"
    separate(part_sex, c("part", "sex")) %>%
    ## Use group_by to group the data by part and sex
    group_by(part, sex) %>%
    ## Use mutate to add two new columns, whose values will be
    ## automatically computed group-by-group
    mutate(total = sum(count),
           prop = count / total
    ) %>% print

## Dates and Times with Lubridate
## > Sys.getlocale("LC_TIME")
## [1] "en_US.UTF-8"
## Above must be "en_US.UTF-8"

library(lubridate)
help(package = lubridate)

this_day <- today()
year(this_day)
month(this_day)
day(this_day)
wday(this_day)
wday(this_day, label = TRUE)
this_moment <- now()
hour(this_moment)
minute(this_moment)
second(this_moment)

## ymd(), dmy(), hms(), ymd_hms(), etc.
my_date <- ymd("1989-05-17")
class(my_date)
ymd("1989 May 17")
mdy("March 12, 1975")
dmy(25081985)
ymd("1920/1/2")
dt1 <- ymd_hms("2014-08-23 17:23:02")
ymd_hms(dt1)
hms("03:22:14")
dt2 <- c("2014-05-14", "2014-09-22", "2014-07-11")
ymd(dt2)

update(this_moment, hours = 8, minutes = 34, seconds = 55)
this_moment
this_moment <- update(this_moment, hours = 11, minutes = 11, seconds = 45)
this_moment

## Now, pretend you are in New York City and you are planning to visit a friend in
## Hong Kong. You seem to have misplaced your itinerary, but you know that your
## flight departs New York at 17:34 (5:34pm) the day after tomorrow. You also know
## that your flight is scheduled to arrive in Hong Kong exactly 15 hours and 50
## minutes after departure.
## Let's reconstruct your itinerary from what you can remember, starting with the
## full date and time of your departure. We will approach this by finding the
## current date in New York, adding 2 full days, then setting the time to 17:34.
## LIST of time zones: http://en.wikipedia.org/wiki/List_of_tz_database_time_zones
nyc <- now(tzone = "America/New_York")
depart <- nyc + days(2)
depart <- update(depart, hours = 17, minutes = 34)

## Your friend wants to know what time she should pick you up from the airport in
## Hong Kong. Now that we have the exact date and time of your departure from New
## York, we can figure out the exact time of your arrival in Hong Kong.
## The first step is to add 15 hours and 50 minutes to your departure time. Recall
## that nyc + days(2) added two days to the current time in New York. Use the same
## approach to add 15 hours and 50 minutes to the date-time stored in depart. Store
## the result in a new variable called arrive.
arrive <- depart + hours(15) + minutes(50)

## The arrive variable contains the time that it will be in New York when you
## arrive in Hong Kong. What we really want to know is what time it will be in Hong
## Kong when you arrive, so that your friend knows when to meet you.
## Use with_tz() to convert arrive to the "Asia/Hong_Kong" time zone.
arrive <- with_tz(arrive, tzone = "Asia/Hong_Kong")

## Fast forward to your arrival in Hong Kong. You and your friend have just met at
## the airport and you realize that the last time you were together was in
## Singapore on June 17, 2008. Naturally, you'd like to know exactly how long it
## has been.
last_time <- mdy("June 17, 2008", tz = "Singapore")
how_long <- interval(last_time, arrive)
as.period(how_long)

## This is where things get a little tricky. Because of things like leap years,
## leap seconds, and daylight savings time, the length of any given minute, day,
## month, week, or year is relative to when it occurs. In contrast, the length of a
## second is always the same, regardless of when it occurs.

## To address these complexities, the authors of lubridate introduce four classes
## of time related objects: instants, intervals, durations, and periods. These
## topics are beyond the scope of this lesson, but you can find a complete
## discussion in the 2011 Journal of Statistical Software paper titled 'Dates and
## Times Made Easy with lubridate'.

stopwatch()
