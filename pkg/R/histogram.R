# Copyright 2011 Google Inc. All Rights Reserved.
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

# Private functions

.is.wholenumber <-
  function(x, tol = .Machine$double.eps^0.5) return (abs(x - round(x)) < tol)

.positive.rle <- function(x) {
  # Implement the special RLE used by stats::HistogramState.
  # Specifically, find runs of N zeros and replace them with
  # -N in the list of bucket counts.  Based on base::rle
  #
  # Args:
  #   x:  A numeric vector of integral bucket counts.
  # Returns:
  #   A numeric vector with runs of N zeros represented by -N.

  stopifnot(!is.null(x))
  stopifnot(is.numeric(x))
  stopifnot(all(.is.wholenumber(x)))
  if (!is.vector(x) && !is.list(x))
    stop("'x' must be an atomic vector")
  n <- length(x)
  if (n == 0L)
    return(x)
  is.run <- !(x[-1L] == x[-n] & x[-1L] == 0)
  indices <- c(which(is.run | is.na(is.run)), n)
  values <- x[indices]
  lengths = diff(c(0L, indices))
  values[which(lengths > 1)] = -1 * lengths[which(lengths > 1)]
  return(values)
}

# S3 Generics

as.histogram <- function(x, ...) {
  UseMethod("as.histogram")
}

# TODO(mstokely): RProtoBuf confusingly uses asMessage instead of as.Message
as.Message <- function(x, ...) {
  UseMethod("as.Message")
}

as.histogram.Message <- function(x,
                                 ...) {
  # Converts a Protocol Buffer into an R Histogram.
  #
  # Args:
  #   x: An RProtoBuf Message of type HistogramTools.HistogramState.
  #
  # Returns:
  #   An S3 histogram class suitable for plotting.
  stopifnot(inherits(x, "Message"))

  if (x@type == "HistogramTools.HistogramState") {
    hist <- list()
    hist$breaks <- x$breaks
    ## Don't count the RLE.
    hist$counts <- x$counts
    hist$density <- hist$counts / (sum(hist$counts) * diff(hist$breaks))
    hist$mids <- (head(hist$breaks, -1) + tail(hist$breaks, -1)) / 2
    if (x$has("name")) {
      hist$xname <- x$name
    } else {
      hist$xname <- "HistogramTools.HistogramState"
    }
    # If we had integer breakpoints we could just use
    # hist$equidist <- length(unique(diff(hist$breaks))) == 1
    hist$equidist <- all.equal(diff(hist$breaks),
                               rep(diff(hist$breaks)[1],
                                   length(hist$breaks) - 1))
    class(hist) <- "histogram"
    return(hist)
  } else {
    stop(paste("Unknown protocol message type", x@type, "only",
               "HistogramTools.HistogramState supported"))
  }
}

as.Message.histogram <- function(x) {
  # Converts an R S3 histogram class into a HistogramTools.hist ProtoBuf.
  #
  # Args:
  #   x: An S3 histogram object.
  #
  # Returns:
  #   An RProtoBuf message of type HistogramTools.HistogramState
  stopifnot(inherits(x, "histogram"))
  # This catches NAs
  stopifnot(!is.null(x$breaks))
  stopifnot(is.numeric(x$breaks))
  hist.class <- P("HistogramTools.HistogramState")
  hist.msg <- new(hist.class)

  hist.msg$counts <- x$counts
  # Use the optional RLE scheme. Just setting x$counts also work but results in
  # a larger protocol message.
  #  hist.msg$buckets <- .positive.rle(x$counts)
  #  hist.msg$sum <- sum(x$counts)

  hist.msg$breaks <- x$breaks
  hist.msg$name <- x$xname
  return(hist.msg)
}

## It's not actually compressed in any way, just encoded, so the
## protocol buffer data can be gzipped smaller.
## foo 
## length(bar$serialize(NULL))
## length(memCompress(bar$serialize(NULL)))

setOldClass("histogram")
setAs("histogram", "Message", as.Message.histogram)

# Merge is S3 generic in base R, but made S4 generic in RProtoBuf.

merge.histogram <- function(x, y, main=paste("Merge of", x$xname,
                                             "and", y$xname), ...) {
  # Merges two histogram objects that have the same bins.
  #
  # Args:
  #   x: An S3 histogram object
  #   y: An S3 histogram object with the same bins as x.
  #   main:  The name to set for the merged histogram (e.g. used in plots).
  #
  # Returns:
  #   An S3 histogram class suitable for plotting.
  stopifnot(inherits(x, "histogram"), inherits(y, "histogram"))
  # Must have the same breakpoints
  stopifnot(identical(x$breaks, y$breaks))
  hist <- list(breaks=x$breaks,
               counts=(x$counts + y$counts),
               mids=x$mids,
               xname=main,
               equidist=x$equidist)
  hist$density <- hist$counts / (sum(hist$counts) * diff(hist$breaks))

  class(hist) <- "histogram"
  return(hist)
}

setMethod("merge", c( x = "histogram", y = "histogram"),
          merge.histogram)
