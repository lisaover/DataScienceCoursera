# setwd("~/Google Drive/_Data Science Johns Hopkins/Getting and Cleaning Data/wk2_quiz")

### Quiz #4
## How many characters are in the 10th, 20th, 30th and 100th lines of HTML from this page:
## http://biostat.jhsph.edu/~jleek/contact.html
## (Hint: the nchar() function in R may be helpful)

con = url("http://biostat.jhsph.edu/~jleek/contact.html")
htmlCode = readLines(con)
close(con)
htmlCode
nchar(htmlCode[10])
nchar(htmlCode[20])
nchar(htmlCode[30])
nchar(htmlCode[100])