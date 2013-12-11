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

\name{IntersectHistograms}
\alias{IntersectHistograms}
\title{Intersect Histograms}
\description{
Takes two histograms with identical bucket boundaries and returns a
histogram of the intersection of the two.  Each bucket of the returned
histogram contains the minimum of the equivalent buckets in the two
provided histograms.
}
\usage{
IntersectHistograms(h1, h2)
}
\arguments{
  \item{h1}{A \code{"histogram"} object (created by
    \code{\link[graphics]{hist}}) representing a pre-binned dataset.}
  \item{h2}{A \code{"histogram"} object (created by
    \code{\link[graphics]{hist}}) representing a pre-binned dataset.}
}
\references{
Swain, Michael J., and Dana H. Ballard. "Color indexing." International journal of computer vision 7.1 (1991): 11-32.
}
\author{Murray Stokely \email{mstokely@google.com}}
\seealso{
\code{\link{histogramtools-package}},
\code{\link[graphics]{hist}}.
}
\examples{
h1 <- hist(runif(100), plot=FALSE)
h2 <- hist(runif(100), plot=FALSE)
plot(IntersectHistograms(h1, h2))
}
