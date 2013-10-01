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

\name{PlotLog2ByteEcdf}
\alias{PlotLog2ByteEcdf}
\title{Plot Binned Histogram and ECDF Data.}
\description{
Computes a univariate average shifted histogram (polynomial kernel)
given a single input histogram.
}
\usage{
PlotLog2ByteEcdf <- function(x, main="", xlab="Bytes (log)",
                             ylab="Cumulative Fraction", ...)
}
\arguments{
  \item{x}{A histogram object (created by \code{\link[graphics]{hist}})
    representing a pre-binned dataset or an ecdf object (created by
    \code{\link[stats]{ecdf}} or \code{\link[HistogramTools]{HistToEcdf}}).}
  \item{main}{Optional title for the figure.}
  \item{xlab}{x-axis label for the Ecdf plot.}
  \item{ylab}{y-axis label for the Ecdf plot.}
  \item{...}{Additional parameters are passed to \code{plot()}.}
}
\details{
  This function takes a histogram or ecdf which has power of 2 bucket
  boundaries representing bytes and creates an Ecdf plot.
}
\author{Murray Stokely \email{mstokely@google.com}}
\seealso{
\code{\link{histogramtools-package}},
\code{\link[graphics]{hist}}.
\code{\link[stats]{ecdf}}.
}
\examples{
filename<-system.file("unitTests/data/buildkernel-readsize-dtrace.txt",
                       package="HistogramTools")
dtrace.hists <- ReadHistogramsFromDtraceOutputFile(filename)
x<-SubsetHistogram(dtrace.hists[["TOTAL"]], minbreak=1)
PlotLog2ByteEcdf(x, cex.lab=1.4)
}
