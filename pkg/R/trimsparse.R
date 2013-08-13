# Copyright 2012 Google Inc. All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# Author: mstokely@google.com (Murray Stokely)

.TrimRightZeroBuckets <- function(orig.hist) {
  # Trims the sparse buckets in the right-tail of a histogram.
  #
  # Args:
  #   orig.hist: An S3 histogram object.
  # Returns:
  #   A new S3 histogram object with any empty buckets in the
  #   right-tail removed.

  # Copy over max/min/sum of squares/class, etc.
  # Override breaks, counts, and midpoints to trim off the rightmost
  # zero buckets.

  if (all(orig.hist$counts == 0)) {
    warning("All buckets of histogram zero, returning unmodified.")
    return(orig.hist)
  }
  biggest.nonzero <- max(which(orig.hist$counts > 0))
  if (biggest.nonzero == length(orig.hist$counts)) {
    # Last bucket is non-zero.
    return(orig.hist)
  }
  # Since histogram objects are named lists, we can use within
  # to override the necessary elements.
  new.hist <- within(unclass(orig.hist), {
    breaks <- head(breaks, biggest.nonzero + 1)
    counts <- head(counts, biggest.nonzero)
    mids <- head(mids, biggest.nonzero)
    density <- head(density, biggest.nonzero)
  })
  attributes(new.hist) <- attributes(orig.hist)
  return(new.hist)
}

.TrimLeftZeroBuckets <- function(orig.hist) {
  # Trims the sparse buckets in the left-tail of a histogram.
  #
  # Args:
  #   orig.hist: An S3 histogram object.
  # Returns:
  #   A new S3 histogram object with any empty buckets in the
  #   left-tail removed.

  if (all(orig.hist$counts == 0)) {
    warning("All buckets of histogram zero, returning unmodified.")
    return(orig.hist)
  }
  smallest.nonzero <- min(which(orig.hist$counts > 0))
  if (smallest.nonzero == 1) {
    # First bucket is non-zero.
    return(orig.hist)
  }
  new.hist <- within(unclass(orig.hist), {
    breaks <- tail(breaks, length(breaks) - smallest.nonzero + 1)
    counts <- tail(counts, length(counts) - smallest.nonzero + 1)
    mids <- tail(mids, length(mids) - smallest.nonzero + 1)
    density <- tail(density, length(density) - smallest.nonzero + 1)
  })
  attributes(new.hist) <- attributes(orig.hist)
  return(new.hist)
}

TrimHistogram <- function(x, left=TRUE, right=TRUE) {
  stopifnot(inherits(x, "histogram"))
  tmp.hist <- x
  if (left) {
    tmp.hist <- .TrimLeftZeroBuckets(tmp.hist)
  }
  if (right) {
    tmp.hist <- .TrimRightZeroBuckets(tmp.hist)
  }
  return(tmp.hist)
}
