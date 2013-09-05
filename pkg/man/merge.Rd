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
\title{Aggregate histograms that have identical breaks.}
\description{
Aggregate histogram objects that have identical breaks.
}
\usage{
  AddHistograms(\dots{}, x=list(\dots{}), main=.NewHistogramName(x))
}
\arguments{
  \item{\dots{}}{Histogram objects (created by \code{\link[graphics]{hist}}).}
  \item{x}{A list of histogram objects. If \code{x} is supplied then the
  \ldots are ignored.}
  \item{main}{A title to add to the aggregated/merged histogram.  By default, if
    two histograms are provided a title will be created that includes
    the names of the original histograms.  If more histograms are
    provided the title will simply include the number of aggregated histograms.
  }
}
\details{
This function adds the buckets of the provided histograms to return a single
aggregated histogram.
}
\author{Murray Stokely \email{mstokely@google.com}}
\seealso{
\code{\link{histogramtools-package}} and
\code{\link[graphics]{hist}}.
}
\examples{
hist.1 <- hist(c(1,2,3,4), plot=FALSE)
hist.2 <- hist(c(1,2,2,4), plot=FALSE)
hist.sum <- AddHistograms(hist.1, hist.2)
hist.3 <- hist(c(1,2,2,4), plot=FALSE)
hist.sum <- AddHistograms(hist.1, hist.2, hist.3)
}
\keyword{manip}
\keyword{utilities}
