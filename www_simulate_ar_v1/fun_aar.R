# Fit an additive autoregressive model
# additive model fitting is outsourced to mgcv::gam, with splines
# Inputs: time series (x), order of autoregression (order)
# Output: fitted GAM object
aar <- function(ts,order) {
    stopifnot(require(mgcv))
    # Automatically generate a suitable data frame from the time series
    # and a formula to go along with it
    fit <- gam(as.formula(auto.formula(order)),
               data=design.matrix.from.ts(ts,order))
    return(fit)
}
