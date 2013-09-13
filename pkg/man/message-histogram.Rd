% Copyright 2011 Google Inc. All Rights Reserved.
% Author: mstokely@google.com (Murray Stokely)
\name{as.Message}
\alias{as.Message}
\alias{as.Message.histogram}
\title{Convert R histograms to Protocol Buffer representation}
\description{This package provides a number of utility functions
useful for manipulating large histograms.  It provides a
\file{HistogramTools.HistogramState} protocol buffer representation of
the default R histogram class to allow histograms to be very concisely
serialized and shared with other systems in a distributed MapReduce
environment.  It also includes a number of utility functions for
manipulating large histograms.}

\usage{
  \method{as.Message}{histogram}(x)
}
\arguments{
  \item{x}{A histogram object (created by \code{\link[graphics]{hist}}).}
}
\details{
  \code{as.Message} converts the provided histogram object into a
  protocol buffer representation that can be compactly serialized and
  shared with tools written in other languages.
}
\author{Murray Stokely \email{mstokely@google.com}}
\seealso{
  \code{\link{histogramtools-package}},
  \code{\link{as.histogram}}, and
\code{\link[RProtoBuf]{RProtoBuf}}.
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
  new.hist.proto <- P("HistogramTools.HistogramState")$read(raw.bytes)
  new.hist.proto

  # Then convert back to a native R histogram.
  new.hist <- as.histogram(new.hist.proto)

  # The new histogram and the old are identical except for xname
}
\keyword{manip}
\keyword{utilities}
