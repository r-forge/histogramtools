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

# TODO(mstokely): Support breaks as a vector of new breaks to be used.
downsample <- function(x, adj.buckets=NULL, breaks=NULL, FUN=sum) {
  # Downsamples a histogram by merging adjacent buckets.
  #
  # This only makes sense where the new bucket boundaries are a subset
  # of the previous bucket boundaries.  Only one of adj.buckets or
  # breaks should be specified.
  #
  # Args:
  #   x: An S3 histogram object
  #   adj.buckets: The number of adjacent buckets to merge.
  #   breaks: The total number of breaks to downsample to.
  #   FUN: The function used to merge buckets.
  #
  # Returns:
  #   An S3 histogram class suitable for plotting.
  stopifnot(inherits(x, "histogram"))
  if (is.null(adj.buckets)) {
    stopifnot(is.numeric(breaks), length(breaks) == 1)
    stopifnot(breaks < length(x$breaks))
    # How many new buckets will we have.
    new.bucket.count <- breaks
    adj.buckets <- ceiling(length(x$counts) / new.bucket.count)
  } else {
    stopifnot(is.numeric(adj.buckets), length(adj.buckets) == 1,
              adj.buckets > 1)
    if (!is.null(breaks)) {
      stop("Only one of adj.buckets and breaks should be specified.")
    }
    new.bucket.count <- ceiling(length(x$counts) / adj.buckets)
  }

  # The last bucket may not be full, hence the length.out
  # TODO(mstokely): Consider bucket.grouping <- x$breaks[
  #                             ceiling(seq_along(x$counts) / adj.buckets)]
  bucket.grouping <- rep(x$breaks[1+(0:new.bucket.count)*adj.buckets],
                         each=adj.buckets, length.out=length(x$counts))

  tmp.df <- aggregate(x$counts, by=list(breaks=bucket.grouping), FUN)

  x$counts <- tmp.df$x
  x$breaks <- c(tmp.df$breaks, tail(x$breaks, 1))
  # The other named list elements of the histogram class :
  x$density <- x$counts / (sum(x$counts) * diff(x$breaks))
  x$intensities <- x$density
  x$mids <- (head(x$breaks, -1) + tail(x$breaks, -1)) / 2
  x$equidist <- length(unique(diff(x$breaks))) == 1
  return(x)
}
