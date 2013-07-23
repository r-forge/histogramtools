# Copyright 2013 Google Inc. All Rights Reserved.
# Author: mstokely@google.com (Murray Stokely)

# Subset histogram should return the parts of the histogram between the
# specified breakpoints minbreak and maxbreak.
SubsetHistogram <- function(x, minbreak=NULL, maxbreak=NULL) {
  stopifnot(inherits(x, "histogram"))
  if (is.null(minbreak) && is.null(maxbreak)) {
    warning("No new breakpoints specified, returning original histogram.")
    return(x)
  }
  if (!is.null(minbreak)) {
    stopifnot(is.numeric(minbreak), length(minbreak) == 1)
    stopifnot(minbreak %in% x$breaks)
    # How many bins to cut from left side of histogram?
    num.to.cut <- length(which(x$breaks < minbreak))
    x$breaks <- tail(x$breaks, -num.to.cut)
    x$counts <- tail(x$counts, -num.to.cut)
  }
  if (!is.null(maxbreak)) {
    stopifnot(is.numeric(maxbreak), length(maxbreak) == 1)
    stopifnot(maxbreak %in% x$breaks)
    # How many bins to cut from right side of histogram?
    num.to.cut <- length(which(x$breaks > maxbreak))
    x$breaks <- head(x$breaks, -num.to.cut)
    x$counts <- head(x$counts, -num.to.cut)
  }
  x$density <- x$counts / (sum(x$counts) * diff(x$breaks))
  x$mids <- (head(x$breaks, -1) + tail(x$breaks, -1)) / 2
  x$equidist <- all.equal(diff(x$breaks),
                          rep(diff(x$breaks)[1],
                              length(x$breaks) - 1))
  return(x)
}
