## There will be an object called 'iris' in your workspace. In this dataset, what is the mean of 'Sepal.Length' for the species virginica? Please round your answer to the nearest whole number.
tapply(iris$Sepal.Length, iris$Species, summary)

## Continuing with the 'iris' dataset from the previous Question, what R code returns a vector of the means of the variables 'Sepal.Length', 'Sepal.Width', 'Petal.Length', and 'Petal.Width'?
apply(iris[, 1:4], 2, mean)

## How can one calculate the average miles per gallon (mpg) by number of cylinders in the car (cyl)? Select all that apply.
with(mtcars, tapply(mpg, cyl, mean))
sapply(split(mtcars$mpg, mtcars$cyl), mean)
tapply(mtcars$mpg, mtcars$cyl, mean)

## Continuing with the 'mtcars' dataset from the previous Question, what is the absolute difference between the average horsepower of 4-cylinder cars and the average horsepower of 8-cylinder cars?
avg.hp <- tapply(mtcars$hp, mtcars$cyl, mean)
abs(avg.hp[["8"]] - avg.hp[["4"]])
