## The following two functions work together to calculate, cache, and retrieve
## the inverse of a matrix. Caching matrices and their inverses for lookup
## reduces calculation expense and time.

## makeCacheMatrix: This function creates a special "matrix" object 
## that can cache its inverse. The function caches the matrix and 
## returns a list of functions for setting and getting the matrix and 
## and its inverse.

makeCacheMatrix <- function(x = matrix()) {
    i <- NULL
    
    ## *set: caches the value of the matrix
    set <- function(y) {
        x <<- y
        i <<- NULL
    }
    
    ## *get: returns the value of the matrix
    get <- function() x
    
    ## *setinverse: caches the value of the inverse
    setinv <- function(solve) i <<- solve
    
    ## *getinverse: returns the value of the inverse
    getinv <- function() i
    
    ## returns a list of the setter and getter functions
    list(set = set, get = get,
         setinv = setinv,
         getinv = getinv)
}

## cacheSolve: This function computes the inverse of the special 
## "matrix" returned by makeCacheMatrix above with data <- x$get(). 
## If the inverse has already been calculated for the given matrix, 
## cacheSolve retrieves and returns the inverse from the cache

cacheSolve <- function(x, ...) {
    ## Return a matrix that is the inverse of 'x'
    
    ## Attempt to retrieve the inverse
    ## Return the inverse if it has been cached
    i <- x$getinv()
    if(!is.null(i)) {
        message("getting cached data")
        return(i)
    }
    
    ## If the inverse has not been cached...
    ## Calculate and cache the inverse
    data <- x$get()
    i <- solve(data, ...)
    x$setinv(i)
    i
    }

# matX<-matrix(c(rep(1, 3),5,7,2,9,4,3,rep(3, 3)), nrow=3, ncol=3)
# x <- makeCacheMatrix(matX)
# cacheSolve(x)
# cacheSolve(x) %*% x$get()