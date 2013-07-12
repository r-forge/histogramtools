# Copyright 2012 Google Inc. All Rights Reserved.
# Author: mstokely@google.com (Murray Stokely)

Count <- function(data.hist) {
  stopifnot(inherits(data.hist, "histogram"))
  return (sum(data.hist$counts))
}

ApproxMean <- function(data.hist) {
  stopifnot(inherits(data.hist, "histogram"))
  return (weighted.mean(data.hist$mids, data.hist$counts))
}

# TODO(mstokely): Using only the midpoints and counts throws away the
# information about the breakpoints, which could potentially be used
# to provide more accurate approximations.  An alternative slower
# implementation based on cumsum may be added back here.

# Use wtd.quantile is from Hmisc package.
ApproxQuantile <- function(data.hist, probs) {
  if (length(data.hist$mids) < 100) {
    warning("Quantiles computed for histograms with fewer than 100 buckets ",
            "may be inaccurate. Consider using histograms with more granular ",
            "buckets.")
  }
  stopifnot(inherits(data.hist, "histogram"))
  return (wtd.quantile(data.hist$mids, weights=data.hist$counts, probs=probs))
}
