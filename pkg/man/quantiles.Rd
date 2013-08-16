% Copyright 2012 Google Inc. All Rights Reserved.
%
% Licensed under the Apache License, Version 2.0 (the "License");
% you may not use this file except in compliance with the License.
% You may obtain a copy of the License at
%
%     http://www.apache.org/licenses/LICENSE-2.0
%
% Unless required by applicable law or agreed to in writing, software
% distributed under the License is distributed on an "AS IS" BASIS,
% WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
% See the License for the specific language governing permissions and
% limitations under the License.
%
% Author: mstokely@google.com (Murray Stokely)

\name{quantile}
\alias{ApproxQuantile}
\alias{ApproxMean}
\alias{Count}
\title{Histogram Approximate Quantiles.}
\description{
Approximate the quantiles of the underlying distribution for which only
a histogram is available.
}
\usage{
ApproxQuantile(data.hist, probs)
ApproxMean(data.hist)
Count(data.hist)
}
\arguments{
  \item{data.hist}{An S3 histogram object created with the histogram package.}
  \item{probs}{Numeric vector of probabilities with values in [0,1].}
}
\details{
Many data analysis pipelines write out histogram protocol buffers with
thousands of buckets so as to be applicable in a wide range of
contexts.  This function provides a way to transform the histogram into
approximations of the quantile, median, mean, etc of the underlying
distribution.  \code{Count(data.hist)} returns the number of
observations in the histogram.
}
\keyword{methods}
\author{Murray Stokely \email{mstokely@google.com}}
\seealso{
\code{\link{histogramtools-package}}
\code{\link{hist}}
}
\examples{
hist <- hist(c(1,2,3), breaks=c(0,1,2,3,4,5,6,7,8,9), plot=FALSE)
Count(hist)
ApproxMean(hist)
ApproxQuantile(hist, .5)
ApproxQuantile(hist, c(.05, .95))
}
