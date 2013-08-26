% Copyright 2012 Google Inc. All Rights Reserved.
% Author: mstokely@google.com (Murray Stokely)

\name{trimsparse}
\alias{trimsparse}
\alias{trimhistogram}
\alias{TrimHistogram}
\title{Trim the tails of a sparse histogram.}
\description{
Removes empty consecutive buckets at the tails of a histogram.
}
\usage{
TrimHistogram(x, left=TRUE, right=TRUE)
}
\arguments{
  \item{x}{A histogram object (created by \code{\link[graphics]{hist}}).}
  \item{left}{If true, consecutive buckets in the left tail of the
    histogram without any elements will
    be removed from the returned histogram.}
  \item{right}{If true, consecutive buckets in the right tail of the
    histogram without any elements will
    be removed from the returned histogram.}
}
\details{
Many data analysis pipelines write out histogram protocol buffers with
thousands of buckets so as to be applicable in a wide range of
contexts.  This function provides a way to transform the histogram into
one with fewer buckets by removing sparseness in the tails.
}
\keyword{methods}
\author{Murray Stokely \email{mstokely@google.com}}
\seealso{
\code{\link{histogramtools-package}} and
\code{\link{hist}}.
}
\examples{
hist.1 <- hist(c(1,2,3), breaks=c(0,1,2,3,4,5,6,7,8,9), plot=FALSE)
length(hist.1$counts)
sum(hist.1$counts)
hist.trimmed <- TrimHistogram(hist.1)
length(hist.trimmed$counts)
sum(hist.trimmed$counts)
}
\keyword{manip}
\keyword{utilities}
