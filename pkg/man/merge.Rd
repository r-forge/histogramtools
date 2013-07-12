% Copyright 2011 Google Inc. All Rights Reserved.
% Author: mstokely@google.com (Murray Stokely)

\name{merge-methods}
\docType{methods}
\alias{merge-methods}
\alias{merge,histogram,histogram-method,merge.histogram}
\title{Merge two histograms that have identical breaks}
\description{
Merge two histogram objects that have identical breaks.
}
\section{Methods}{
\describe{
\item{\code{signature(x = "histogram", y = "histogram")}}{
Merge two histograms that have the same breaks into a combined histogram.
}
}}
\keyword{methods}
\author{Murray Stokely \email{mstokely@google.com}}
\seealso{
\code{\link{histogram-package}}
\code{\link{hist}}
}
\examples{
hist.1 <- hist(c(1,2,3,4), plot=FALSE)
hist.2 <- hist(c(1,2,2,4), plot=FALSE)
hist.merged <- merge(hist.1, hist.2)
}
