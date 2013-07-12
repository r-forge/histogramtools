% Copyright 2012 Google Inc. All Rights Reserved.
% Author: mstokely@google.com (Murray Stokely)

\name{downsample}
\alias{downsample}
\title{Downsample a histogram by combining adjacent buckets.}
\description{
Downsample a histogram by combining adjacent buckets.
}
\usage{
  downsample(x, adj.buckets=NULL, breaks=NULL, FUN=sum)
}
\arguments{
  \item{x}{An S3 histogram object.}
  \item{adj.buckets}{The number of adjacent buckets to merge together.}
  \item{breaks}{The total number of desired breaks in the new
    histogram.  Must be less than \code{length(x$breaks)} and only used if
    adj.buckets is equal to \code{NULL}}
  \item{FUN}{The user defined function that should be run to merge the
    counts of adjacent buckets in the histogram.}
}
\details{
Many data analysis pipelines write out histogram protocol buffers with
thousands of buckets so as to be applicable in a wide range of
contexts.  This function provides a way to transform the histogram into
one with fewer buckets.
}
\keyword{methods}
\author{Murray Stokely \email{mstokely@google.com}}
\seealso{
\code{\link{histogram-package}}
\code{\link{hist}}
}
\examples{
hist.1 <- hist(c(1,2,3), breaks=c(0,1,2,3,4,5,6,7,8,9), plot=FALSE)
hist.2 <- downsample(hist.1, adj.buckets=2)

hist.1
hist.2
}
