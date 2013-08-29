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

.BuildHistogram <- function(breaks, counts, xname="") {
  stopifnot(is.numeric(breaks), is.numeric(counts))
  stopifnot(length(breaks) > 1)
  stopifnot(length(breaks) == (length(counts) + 1))
  hist <- list(breaks = breaks,
               counts = counts,
               density = counts / (sum(counts) * diff(breaks)),
               mids = (head(breaks, -1) + tail(breaks, -1)) / 2,
               xname = xname,
               equidist = .BreaksAreEquidistant(breaks))
  class(hist) <- "histogram"
  return(hist)
}

.NewHistogramName <- function(x) {
  if(length(x) == 2) {
    return(paste("Merge of", x[[1]]$xname, "and", x[[2]]$xname))
  } else {
    paste("Merge of", length(x), "histograms")
  }
}

.AddManyHistograms <- function(x, main=paste("Merge of", length(x),
                                   "histograms")) {
  # Adds many histogram objects together that have the same bins.
  #
  # Args:
  #   x: A list of S3 histogram objects
  #   main:  The name to set for the merged histogram (e.g. used in plots).
  #
  # Returns:
  #   An S3 histogram class suitable for plotting.
  stopifnot(all(sapply(x, inherits, "histogram")))
  br <- unname(lapply(x, function(y) y$breaks))
  stopifnot(all(sapply(br, identical, y = br[[1]])))
  # Now we know that all histograms have identical breaks.
  cnts <- unname(lapply(x, function(y) y$counts))
  sum.cnts <- Reduce("+", cnts)
  hist <- list(breaks = x[[1]]$breaks,
               counts = sum.cnts,
               mids = x[[1]]$mids,
               xname = main,
               equidist = x[[1]]$equidist)
  hist$density <- hist$counts / (sum(hist$counts) * diff(hist$breaks))

  class(hist) <- "histogram"
  return(hist)
}

AddHistograms <- function(..., x=list(...), main=.NewHistogramName(x)) {
  # Adds two histogram objects that have the same bins.
  #
  # Args:
  #   ...: S3 histogram objects.
  #   x:   A list of S3 histogram objects.
  #   main:  The name to set for the merged histogram (e.g. used in plots).
  #
  # Returns:
  #   An S3 histogram class suitable for plotting.

  stopifnot(length(x) > 1)
  if (length(x) > 2) {
    return(.AddManyHistograms(x))
  }
  stopifnot(inherits(x[[1]], "histogram"), inherits(x[[2]], "histogram"))

  # Must have the same breakpoints
  stopifnot(identical(x[[1]]$breaks, x[[2]]$breaks))
  hist <- list(breaks=x[[1]]$breaks,
               counts=(x[[1]]$counts + x[[2]]$counts),
               mids=x[[1]]$mids,
               xname=main,
               equidist=x[[1]]$equidist)
  hist$density <- hist$counts / (sum(hist$counts) * diff(hist$breaks))

  class(hist) <- "histogram"
  return(hist)
}

# S3 Generics

as.histogram <- function(x, ...) {
  UseMethod("as.histogram")
}

# TODO(mstokely): RProtoBuf confusingly uses asMessage instead of as.Message
as.Message <- function(x) {
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
  hist <- .BuildHistogram(breaks = x$breaks, counts = x$counts)
  if (x$has("name")) {
    hist$xname <- x$name
  } else {
    hist$xname <- "HistogramTools.HistogramState"
  }
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

# NB(mstokely): This causes an R CMD check warning about
# the histogram class being undocumented, so commented out.
#
# This would let us do :
#   as(hist(runif(100), plot=F), "Message")
#
# But we can already accomplish that with :
#   as.Message(hist(runif(100), plot=F))
#
# so it is not a big loss.
#setOldClass("histogram")
#setAs("histogram", "Message", as.Message.histogram)
