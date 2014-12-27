# Synthetic data set
# Logistic map corrupted with observational noise
# Exercise fo the student: why is this "logistic"?

logistic.iteration <- function(n,x.init,r=4){
    logistic.map <- function(x,r=4) { r*x*(1-x) }
    x <- vector(length=n)
    x[1] <- x.init
    for (i in 1:(n-1)) {
        x[i+1] <- logistic.map(x[i],r=r)
    }
    return(x)
}


