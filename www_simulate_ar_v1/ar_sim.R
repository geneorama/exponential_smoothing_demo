##==============================================================================
## INITIALIZE
##==============================================================================
## Remove all objects; perform garbage collection
rm(list=ls())
gc(reset=TRUE)
## Check for dependencies
if(!"geneorama" %in% rownames(installed.packages())){
    if(!"devtools" %in% rownames(installed.packages())){install.packages('devtools')}
    devtools::install_github('geneorama/geneorama')
}
## Load libraries
geneorama::detach_nonstandard_packages()
geneorama::loadinstall_libraries(c("geneorama"))
# geneorama::sourceDir("CODE/functions/")


##==============================================================================
# http://www.stat.cmu.edu/~cshalizi/uADA/12/lectures/time-series.R
##==============================================================================

# Examples for the lecture on time series

# Real-world data set
library(datasets)
data(lynx)

# Synthetic data set
# Logistic map corrupted with observational noise
source("www_simulate_ar_v1/fun_logistic.iteration.R")
logistic.iteration
    

x <- logistic.iteration(1000,x.init=runif(1))
y <- x+rnorm(1000,mean=0,sd=0.05)

# plot all of the lynx series
plot(lynx)
# Plot the first part of the synthetic time series
plot(y[1:100],xlab="t",ylab=expression(y[t]),type="l")

# autocorrelation functions
acf(lynx)
acf(y)

# Convert a time series into a data frame of lagged values
# Input: a time series, maximum lag to use, whether older values go on the right
# or the left
# Output: a data frame with (order+1) columns, named lag0, lag1, ... , and
# length(ts)-order rows
source("www_simulate_ar_v1/fun_design.matrix.from.ts.R")
design.matrix.from.ts

# Plot successive values of lynx against each other
plot(lag0 ~ lag1,
     data=design.matrix.from.ts(lynx,1),
     xlab=expression(lynx[t]),
     ylab=expression(lynx[t+1]),pch=16)
# Plot successive values of y against each other
plot(lag0 ~ lag1,
     data = design.matrix.from.ts(y,1),
     xlab = expression(y[t]),
     ylab = expression(y[t+1]),pch=16)

# Fit an additive autoregressive model
# additive model fitting is outsourced to mgcv::gam, with splines
# Inputs: time series (x), order of autoregression (order)
# Output: fitted GAM object
source('www_simulate_ar_v1/fun_aar.R')
aar

# Generate formula for an autoregressive GAM of a specified order
# Input: order (integer)
# Output: a formula which looks like
# "lag0 ~ s(lag1) + s(lag2) + ... + s(lagorder)"
source("www_simulate_ar_v1/fun_auto.formula.R")
auto.formula

# Plot successive values of y against each other
plot(lag0 ~ lag1,
     data=design.matrix.from.ts(y,1),
     xlab=expression(y[t]),
     ylab=expression(y[t+1]),pch=16)
# Add the linear regression (which would be the AR(1) model)
abline(lm(lag0~lag1,data=design.matrix.from.ts(y,1)),col="red")
# Fit an AR(8) and add its fitted values
yar8 <- arma(y,order=c(8,0))
points(y,fitted(yar8),col="red")
# Fit a first-order nonparametric autoregression, add fitted values
yaar1 <- aar(y,order=1)
points(y[-length(y)],fitted(yaar1),col="blue")


# simple block bootstrap
# inputs: time series (ts), block length, length of output
# presumes: ts is a univariate time series
# output: one resampled time series
source('www_simulate_ar_v1/fun_rblockboot.R')
rblockboot

###############################################################################
# Exercises for the reader:
# 1. Modify this to do the circular block bootstrap (hint: extend ts)
# 2. Modify this to do block bootstrapping of multiple time series, using the
# # SAME blocks for all series (to preserve dependencies across series)
##############################################################################


# GDP per capita time series
# Taken from the St. Louis Federal Reserve Bank's FRED data service
# GDP in billions of constant (2005) dollars
# http://research.stlouisfed.org/fred2/series/GDPCA?cid=106
# over population in thousands
# http://research.stlouisfed.org/fred2/series/POP?cid=104
# so the defualt units are millions of dollars per capita, which is needlessly
# hard to interpret
gdppc <- read.csv("gdp-pc.csv")
gdppc$y <- gdppc$y*1e6
plot(gdppc,log="y",type="l")

