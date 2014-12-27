# Generate formula for an autoregressive GAM of a specified order
# Input: order (integer)
# Output: a formula which looks like
# "lag0 ~ s(lag1) + s(lag2) + ... + s(lagorder)"
auto.formula <- function(order) {
    inputs <- paste("s(lag",1:order,")",sep="",collapse="+")
    form <- paste("lag0 ~ ",inputs)
    return(form)
}
