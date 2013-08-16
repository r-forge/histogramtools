% Copyright 2011 Google Inc. All Rights Reserved.
% Author: mstokely@google.com (Murray Stokely)
\name{as.histogram}
\alias{as.histogram}
\alias{as.histogram.default}
\alias{as.histogram.Message}
\title{Convert histogram protocol buffers to S3 histogram objects}
\description{This package provides a number of utility functions
useful for manipulating large histograms.  It provides a
\file{HistogramTools.HistogramState} protocol buffer representation of
the default R histogram class to allow histograms to be very concisely
serialized and shared with other systems in a distributed MapReduce
environment.  It also includes a number of utility functions for
manipulating large histograms.}

\usage{
  \method{as.histogram}{default}(x, \dots)
  \method{as.histogram}{Message}(x, main="HistogramTools.HistogramState", \dots)
}
\arguments{
  \item{x}{An RProtoBuf Message of type "HistogramTools.HistogramState" to convert to an S3 histogram class.}
  \item{main}{The title to use for the histogram.}
  \item{\dots}{Not used.}
}
\details{
  \code{as.histogram} reads the provided Protocol Buffer
  message and extracts the buckets and counts to populate into the
  standard R histogram class which can be plotted.
}
\author{Murray Stokely \email{mstokely@google.com}}
\seealso{
\code{\link{histogramtools-package}}
\code{\link{as.Message}}
\code{\link{RProtoBuf}}
}
\examples{
  library(HistogramTools)

  tmp.hist <- hist(c(1,2,4,43,20,33,1,1,3), plot=FALSE)
  # The default R serialization takes a fair number of bytes
  length(serialize(tmp.hist, NULL))

  # Convert to a protocol buffer representation.
  hist.msg <- as.Message(tmp.hist)

  # Which has an ASCII representation like this:
  cat(as.character(hist.msg))

  # Or can be serialized and shared with other tools much more
  # succinctly than R's built-in serialization format.
  length(hist.msg$serialize(NULL))

  # And since this isn't even compressed, we can reduce it further
  # with in-memory compression:
  length(memCompress(hist.msg$serialize(NULL)))

  # If we read in the raw.bytes from another tool
  raw.bytes <- hist.msg$serialize(NULL)

  # We can parse the raw bytes as a protocol buffer
  new.hist.proto <- HistogramTools.HistogramState$read(raw.bytes)
  new.hist.proto
  
  # Then convert back to a native R histogram.
  new.hist <- as.histogram(new.hist.proto)

  # The new histogram and the old are identical except for xname
}
