# simple block bootstrap
# inputs: time series (ts), block length, length of output
# presumes: ts is a univariate time series
# output: one resampled time series
rblockboot <- function(ts,block.length,len.out=length(ts)) {
    # chop up ts into blocks
    the.blocks <- as.matrix(design.matrix.from.ts(ts,block.length-1,
                                                  right.older=FALSE))
    # look carefully at design.matrix.from.ts to see why we need the -1
    # How many blocks is that?
    blocks.in.ts <- nrow(the.blocks)
    # Sanity-check
    stopifnot(blocks.in.ts == length(ts) - block.length+1)
    # How many blocks will we need (round up)?
    blocks.needed <- ceiling(len.out/block.length)
    # Sample blocks with replacement
    picked.blocks <- sample(1:blocks.in.ts,size=blocks.needed,replace=TRUE)
    # put the blocks in the randomly-selected order
    x <- the.blocks[picked.blocks,]
    # convert from a matrix to a vector and return
    # need transpose because R goes from vectors to matrices and back column by
    # column, not row by row
    x.vec <- as.vector(t(x))
    # Discard uneeded extra observations at the end silently
    return(x[1:len.out])
}
