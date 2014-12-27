
# http://www-wiwi-cms.uni-regensburg.de/images/institute/vwl/tschernig/lehre/Simulation_and_Estimation_of_an_AR_process.R


# Simulating and Estimating an Autoregressive Process

# The DataGeneratingProcess (DGP) we want to simulate is 
# y_t = 4 + 1.2 y_{t-1} - 0.4 y_{t-2} + u_t,
# where u_t is normally distributed with expected value 0 and variance 2, i.e. u_t~N(0,2) for all t.

# The task is to simulate a realization of this process with 1000 simulated observations and 
# starting values y_{-1} = 10 and y_{0} = 7.

# First initialize a vector, which will contain the time series data:

( y <- numeric(1000+2) )

# Input the initial values

y[1] <- 10
y[2] <- 7

# We could generate our first value (which is the 3rd element of 'y') by using

u <- rnorm(1, mean = 0, sd = sqrt(2))
y[3] <- 4 + 1.2 * y[2] - 0.4 * y[1] + u

# where the first line generates a (pseudo-)random number from the normal distribution with mean 0 
# and standard deviation of square root of 2; type '?rnorm' for more details. The same procedure 
# could be done for the second value

u <- rnorm(1, mean = 0, sd = sqrt(2))
y[4] <- 4 + 1.2 * y[3] - 0.4 * y[2] + u

# We could proceed with this type of simulation up to the 1000th value, but this seems unefficient. 
# In fact, most programming languages provide a construction that prevents the programmer from 
# performing the same procedure over and over again. The tool used here will be a 'for' loop. 
# The syntax is 'for (i in vector){commands}'. The commands are somewhat dependent on i, where i 
# takes the values of the vector one after another. Example:

b <- c(1,8,9)  
for( i in b){ print(i + 100) }

# (the print command is necessary here to tell R explicitly that you want to see the output, 
# otherwise the outputs are suppressed in a loop)
# We will use this construction for an index vector from 3 to 1002
# (to make sure you get the same results, we set the random seed)

set.seed(101010)
for(i in 3:1002){
    u <- rnorm(1, mean = 0, sd = sqrt(2))
    y[i] <- 4 + 1.2 * y[i-1] - 0.4 * y[i-2] + u
}

# This saved a lot of time! Let us look at the result

y
plot.ts(y)

# Now we want to get rid of the starting values by

y <- y[3:1002]

# and transform the vector into a time series object that starts at period 1 (have look at the help 
# page of 'ts()' on how to specify quarterly or monthly data)

y <- ts(y, start = 1)

# Since now R knows that 'y' is a time series, the generic function 'plot()' yields a nice graph

plot(y)

# Having transformed 'y' into a time series object, we can extract subvectors by using time indices.
# Let 'x' denote the time series from t=501 to the end

x <- window(y, start = 501)

# Now we want to estimate the parameters of an autoregressive model of length 6 using data in 'x'. 
# We will use 'ar()' and 'dynlm()' for this exercise.

?ar

# The help page tells us that we need to set aic to FALSE and order.max to 6 to get an AR(6) model. 
# If aic is set to TRUE, which is the default value, the function would choose the best lag length 
# up to 6 using the AIC. Furthermore, the function provides different methods to estimate the parameters.
# We will choose OLS. Hence,

(ar.est <- ar(x, aic = FALSE, order.max = 6, method = "ols"))
# y[i] <- 4 + 1.2 * y[i-1] - 0.4 * y[i-2] + u
ar(x)

# The coefficients can be accessed by 

ar.est$ar[,,1]

# Another interesting function is provided in the package 'dynlm'. It is a convenient interface for 
# estimating dynamic linear models. If you never used this package before you need to install it first:

install.packages("dynlm")

# Then, in every session, you need to load the package

library(dynlm)

# 'dynlm()' allows you to specify differences and lags directly in the regression formula. A 
# difference is specified by d(, k) and a lag by L(, k), where k can be vector-valued to easily include
# more lags. For our AR(6) model, the command is

(dynlm.est <- dynlm(x ~0 + L(x, 1:6))) 
# (dynlm.est <- dynlm(x ~ L(x, 1:2))) 

# The big advantage of 'dynlm()' is that residuals, test statistics etc. can be accessed the same way 
# as for 'lm()'. A summary is printed with

summary(dynlm.est)

# We see that point estimates are exactly the same for 'ar.est' and 'dynlm.est'. Also, we see that 
# only the first two lags are significant at the 1% level of significance.


##########
# Addendum
##########

# Setting the random seed to a specified value allows reproducibility of your random experiments.
# Compare

rnorm(1, 0 ,1)
rnorm(1, 0 ,1)
set.seed(123456)
rnorm(1, 0 ,1)
set.seed(123456)
rnorm(1, 0 ,1)

# The first two random numbers are different almost surely, but the last two are the same: 0.8337332


# Although using a loop for simulating AR processes is very intuitive, it is not the fastest way to
# create these processes (in terms of computing time). For simulation studies, where you actually 
# perform a large number of time series, you should use function 'filter()' (or 'arima.sim()')

?filter
set.seed(101010)
z <- filter(rnorm(1000, 4, sqrt(2)), 
            c(1.2, -0.4), 
            method = "recursive", 
            init = c(7, 10))
plot(z)
set.seed(101010)
plot(rnorm(1000, 4, sqrt(2)), type='o')
# Try to understand the code, especially:
# why do we draw random numbers with mean 4?
# how to specifiy the initial values?


# For a simulation study, you often want not only to create a single time series, but a whole bunch,
# say 5000. You could use a loop for this, but there is function created for this kind of replication,
# 'replicate()'.

?replicate

# For our DGP the code would look like

Z <- replicate(50, filter(rnorm(1000, 4, sqrt(2)), c(1.2, -0.4), 
                            method = "recursive", init = c(7, 10)), 
               simplify = TRUE)
dim(Z)

# As you see, 'Z' is a matrix of dimension 1000 x 5000. If you wanted to draw all 5000 realizations
# into a single graph you could use (this takes some time!)

ts.plot(Z)

# END
