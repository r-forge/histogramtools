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

\name{InformationLoss}
\alias{KSDCC}
\alias{EMDCC}
\alias{PlotKSDCC}
\alias{PlotEMDCC}
\title{Information Loss Metrics for Histograms}
\description{
Computes a metric between 0 and 1 of the amount of information lost
about the underlying distribution of data for a given histogram.
}
\usage{
KSDCC(h)
EMDCC(h)
PlotKSDCC(h, arrow.size.scale=1, main=NULL)
PlotEMDCC(h, main=NULL)
}
\arguments{
  \item{h}{A histogram object (created by \code{\link[graphics]{hist}}) representing a pre-binned dataset
    on which we'd like to calculate the information loss due to binning.}
  \item{arrow.size.scale}{specifies a size scaling factor for the arrow
    illustrating the point of Kolmogorov-Smirnov distance between the
    two e.c.d.fs}
  \item{main}{if 'method="constant"' a number between 0 and 1 inclusive,
    indicating a compromise between left- and right-continuous
     step functions.  See ?approxfun}
}
\details{
The \code{KSDCC} (Kolmogorov-Smirnov Distance of the Cumulative Curves)
function provides the Kolmogorov-Smirnov distance between the empirical
distribution functions of the smallest and largest datasets that could
be represented by the binned data in the provided histogram.

The \code{EMDCC} (Earth Mover's Distance of the Cumulative Curves)
function is like the Kolmogorov-Smirnov statistic, but uses an integral
to capture the difference across all points of the curve rather than
just the maximum difference.  This is also known as Mallows distance, or
Wasserstein distance with $p=1$.

The \code{PlotKSDCC} and \code{PlotEMDCC} functions take a histogram and
generate a plot showing a geometric representation of the information
loss metrics for the provided histogram.
}
\author{Murray Stokely \email{mstokely@google.com}}
\seealso{
\code{\link{histogramtools-package}},
\code{\link{ecdf}}, and
\code{\link{hist}}.
}
\examples{
x <- rexp(1000)
h <- hist(x, breaks=c(0,1,2,3,4,8,16,32), plot=FALSE)
KSDCC(h)

# For small enough data sets we can construct the two extreme data sets
# that can be constructed from a histogram.  One assuming every data point
# is on the left boundary of its bucket, and another assuming every data
# point is on the right boundary of its bucket.  Our KSDCC metric for
# histograms is equivalent to the ks.test statistics for these two
# extreme data sets.

x.min <- rep(head(h$breaks, -1), h$counts)
x.max <- rep(tail(h$breaks, -1), h$counts)
ks.test(x.min, x.max, exact=FALSE)

\dontrun{
PlotKSDCC(h)
}

EMDCC(h)
\dontrun{
PlotEMDCC(h)
}
}
