## RUN IN BASE R NOT RSTUDIO

# setwd("~/Google Drive/_Data Science Johns Hopkins/Getting and Cleaning Data/wk2_quiz")

### Quiz #1
## Register an application with the Github API here https://github.com/settings/applications. 
## Access the API to get information on your instructors repositories (hint: this is the url 
## you want "https://api.github.com/users/jtleek/repos"). Use this data to find the time that 
## the datasharing repo was created. What time was it created?

## This tutorial may be useful (https://github.com/hadley/httr/blob/master/demo/oauth2-github.r). 
## You may also need to run the code in the base R package and not R studio.


myapp <- oauth_app("github", key = "cbd57087ef6c7f1a4a6f", secret = "f14070756a5e52c13ca5940669295f3a3a4fdd73")
 
# Get OAuth credentials
github_token <- oauth2.0_token(oauth_endpoints("github"), myapp)

# Use API
gtoken <- config(token = github_token)
req <- GET("https://api.github.com/users/jtleek/repos", gtoken)
stop_for_status(req)
content(req)

# Put info into data frame
library(jsonlite)
json1 <- content(req)
json2 <- jsonlite::fromJSON(toJSON(json1))
json2[1, 1:4]
datasharing <- subset(json2, name == "datasharing")
datasharing[,"created_at"]
## [1] "2013-11-07T13:25:07Z"


#### Tutorial for number 1 ####
# https://github.com/r-lib/httr/blob/master/demo/oauth2-github.r
library(httr)

# 1. Find OAuth settings for github:
# http://developer.github.com/v3/oauth/
oauth_endpoints("github")
##
## <oauth_endpoint>
##  authorize: https://github.com/login/oauth/authorize
 ## access:    https://github.com/login/oauth/access_token
 ##
 
 # 2. To make your own application, register at 
# https://github.com/settings/developers. Use any URL for the homepage URL
# (http://github.com is fine) and http://localhost:1410 as the callback url
#
 myapp <- oauth_app("github", key = "cbd57087ef6c7f1a4a6f", secret = "f14070756a5e52c13ca5940669295f3a3a4fdd73")
 
 # 3. Get OAuth credentials
github_token <- oauth2.0_token(oauth_endpoints("github"), myapp)

# 4. Use API
gtoken <- config(token = github_token)
req <- GET("https://api.github.com/rate_limit", gtoken)
stop_for_status(req)
content(req)

# OR:
req <- with_config(gtoken, GET("https://api.github.com/rate_limit"))
stop_for_status(req)
content(req)
