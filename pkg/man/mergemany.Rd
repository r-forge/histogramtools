% Copyright 2013 Google Inc. All Rights Reserved.
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

\name{MergeManyHistograms}
\alias{MergeManyHistograms}
\title{Merge many histograms by summing the buckets.}
\description{
MergeManyHistogram provides an efficient way to aggregate a large number
of histograms with identical bucket boundaries.
}
\usage{
 MergeManyHistograms(x, main=paste("Merge of", length(x), "histograms"))
}
\arguments{
  \item{x}{A list of S3 histogram objects.}
  \item{main}{A title to add to the merged histogram.}
}
\details{
This function provides a way to efficiently aggregate large numbers of histograms.
}
\keyword{methods}
\author{Murray Stokely \email{mstokely@google.com}}
\seealso{
\code{\link{histogram-package}}
\code{\link{hist}}
}
\examples{
  hist.1 <- hist(c(1,2,3), breaks=0:9, plot=FALSE)
  hist.2 <- hist(c(1,2,3), breaks=0:9, plot=FALSE)
  hist.3 <- hist(c(4,5,6), breaks=0:9, plot=FALSE)
  hist.merged <- MergeManyHistograms(list(hist.1, hist.2, hist.3))
  hist.merged
}
