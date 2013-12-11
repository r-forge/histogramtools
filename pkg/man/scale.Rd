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

\name{ScaleHistogram}
\alias{ScaleHistogram}
\title{Scale Histogram Counts}
\description{
Scales the counts of the provided histograms by the provided factor and
returns a new histogram.
}
\usage{
ScaleHistogram(x, factor)
}
\arguments{
  \item{x}{A \code{"histogram"} object (created by
    \code{\link[graphics]{hist}}) representing a dataset summarized by binning.}
  \item{factor}{A number value to scale the bucket counts by.  Defaults
    to 1/Count(x) to normalize the sum of counts of the histogram to 1.}
}
\author{Murray Stokely \email{mstokely@google.com}}
\seealso{
\code{\link{histogramtools-package}},
\code{\link[graphics]{hist}}.
}
\examples{
x <- runif(100)
h <- hist(x, plot=FALSE)
plot(ScaleHistogram(h, 10))
}
