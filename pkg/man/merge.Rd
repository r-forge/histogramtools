% Copyright 2011 Google Inc. All Rights Reserved.
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

\name{AddHistograms}
\alias{AddHistograms}
\title{Aggregate two histograms that have identical breaks.}
\description{
Aggregate two histogram objects that have identical breaks.
}
\usage{
  AddHistograms(x, y, main=paste("Merge of", x$xname, "and", y$xname))
}
\arguments{
  \item{x}{A histogram object (created by \code{\link[graphics]{hist}}).}
  \item{y}{A histogram object.  Must have the same breakpoints as \code{x}.}
  \item{main}{A title to add to the merged histogram.}
}
\details{
This function adds the buckets of two histogram to return a single
aggregated histogram.
}
\author{Murray Stokely \email{mstokely@google.com}}
\seealso{
\code{\link{AddManyHistograms}},
\code{\link{histogramtools-package}}, and
\code{\link{hist}}.
}
\examples{
hist.1 <- hist(c(1,2,3,4), plot=FALSE)
hist.2 <- hist(c(1,2,2,4), plot=FALSE)
hist.sum <- AddHistograms(hist.1, hist.2)
}
\keyword{manip}
\keyword{utilities}
