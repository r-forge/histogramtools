% Copyright 2011 Google Inc. All Rights Reserved.
% Author: mstokely@google.com (Murray Stokely)
\name{histogramtools-package}
\alias{histogramtools-package}
\alias{histogram}
\alias{histogramtools}
\docType{package}
\title{HistogramTools package}

\description{This package provides a number of utility functions for
  manipulating R's native histogram objects.  The functions are focused
  on operations that are particularly useful when dealing with large
  numbers of histograms with identical buckets, such as those produced
  from distributed MapReduce computations.  This package also provides a
  \file{HistogramTools.HistogramState} protocol buffer representation of
  the default R histogram class to allow histograms to be very concisely
  serialized and shared with other systems.
}
\details{
See \code{library(help=HistogramTools)} for version number, dates,
dependencies, and a complete list of functions.

Index (possibly out of date):
\preformatted{
AddHistograms         Aggregate histogram objects that have identical breaks.
MergeBuckets          Merge adjacent buckets of a histogram.
ApproxQuantile        Approximate the quantiles of the underlying distribution.
ApproxMean            Approximate the mean of the underlying distribution.
Count                 Count of all samples in a histogram.
HistToEcdf            Approximate the ECDF of the underlying distribution.
SubsetHistogram       Subset a histogram by removing some of the buckets.
TrimHistogram         Remove empty buckets from the tails of a histogram.
ScaleHistogram        Scale histogram bucket counts by a numeric value.
AshFromHist           Compute Average Shifted Histogram from a histogram.
KSDCC                 Compute maximal KS-statistic of CDFs constructed from histogram.
EMDCC                 Compute maximal Earth Mover's Distance of CDFs constructed from histogram.
PlotKSDCC             Plot the KSDCC metric and a CDF from the histogram.
PlotEMDCC             Plot the EMDCC metric and a CDF from the histogram.
PlotLog2ByteEcdf      Plot the CDF from a histogram with log2 scaled byte boundaries.
PlotLogTimeDurationEcdf Plot the CDF from a histogram with log scaled time duration boundaries.
PlotRelativeFrequency Plot a relative frequency histogram.
ReadHistogramsFromDtraceOutputFile  Read a list of Histograms from the output of the DTrace tool.
}
}
\author{
Murray Stokely <mstokely@google.com>
}
\keyword{ package }
\seealso{
\code{\link[graphics]{hist}}
}
\examples{
  if(require(RProtoBuf)) {
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
}
