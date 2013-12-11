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

\name{PreBinnedHistogram}
\alias{PreBinnedHistogram}
\title{PreBinnedHistogram}
\description{
Takes a set of already binned data represented by a vector of $n+1$
breaks and a vector of $n$ counts and returns a normal R histogram
object.
}
\usage{
PreBinnedHistogram(breaks, counts, xname="")
}
\arguments{
  \item{breaks}{A numeric vector of n+1 breakpoints for the histogram.}
  \item{counts}{A numeric vector of n counts for each bucket of the
    histogram.}
  \item{xname}{A character string with the name for this histogram.}
}
\author{Murray Stokely \email{mstokely@google.com}}
\seealso{
\code{\link{histogramtools-package}},
\code{\link[graphics]{hist}}.
}
