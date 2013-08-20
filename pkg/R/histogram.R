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

.BreaksAreEquidistant <- function(breaks) {
  # Check if breaks are equally spaced.
  # If we had integer breakpoints we could just use
  # hist$equidist <- length(unique(diff(hist$breaks))) == 1
  diffs <- diff(breaks)
  all(abs(diffs - diffs[1]) < .Machine$double.eps^0.5 * max(diffs))
}

# S3 Generics

as.histogram <- function(x, ...) {
  UseMethod("as.histogram")
}

# TODO(mstokely): RProtoBuf confusingly uses asMessage instead of as.Message
as.Message <- function(x, ...) {
  UseMethod("as.Message")
}

as.histogram.Message <- function(x, ...) {
  # Converts a Protocol Buffer into an R Histogram.
  #
  # Args:
  #   x: An RProtoBuf Message of type HistogramTools.HistogramState.
  #
  # Returns:
  #   An S3 histogram class suitable for plotting.
  stopifnot(inherits(x, "Message"))

  if (x@type != "HistogramTools.HistogramState") {
    stop(paste("Unknown protocol message type", x@type, "only",
               "HistogramTools.HistogramState supported"))
  }
  hist <- list()
  hist <- x[c("breaks", "counts")]
  # TODO(mstokely): consider
  # hist$density <- with(hist, counts / (sum(counts) * diff(breaks)))
  hist$density <- hist$counts / (sum(hist$counts) * diff(hist$breaks))
  hist$mids <- (head(hist$breaks, -1) + tail(hist$breaks, -1)) / 2
  if (x$has("name")) {
    hist$xname <- x$name
  } else {
    hist$xname <- "HistogramTools.HistogramState"
  }
  hist$equidist <- .BreaksAreEquidistant(hist$breaks)
  class(hist) <- "histogram"
  return(hist)
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
  hist.msg$breaks <- x$breaks
  hist.msg$name <- x$xname
  return(hist.msg)
}

setOldClass("histogram")
setAs("histogram", "Message", as.Message.histogram)

# 'merge' is S3 generic in base R, but made S4 generic in RProtoBuf.

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
