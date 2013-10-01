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
\alias{PlotLogTimeDurationEcdf}
\title{Plot Binned Histogram and ECDF Data.}
\description{
Produces aesthetically pleasing ECDF plots for two common classes of
non-equiwidth histograms.  Specifically, (1) histograms with power of two
bucket boundaries commonly used in computer science for measuring
resource usage, and (2) histograms with log-scaled time duration buckets
with a range from 1 second to 10 years.
}
\usage{
PlotLog2ByteEcdf(x, main="", xlab="Bytes (log)",
                 ylab="Cumulative Fraction", with.grid=TRUE, ...)
PlotLogTimeDurationEcdf(x, with.grid=TRUE,
                        xlab="Age (log)",
                        ylab="Cumulative Fraction",
                        cex.lab=1.6,
                        cex.axis=1.6, ...)
}
\arguments{
  \item{x}{A histogram object (created by \code{\link[graphics]{hist}})
    representing a pre-binned dataset or an ecdf object (created by
    \code{\link[stats]{ecdf}} or \code{\link[HistogramTools]{HistToEcdf}}).}
  \item{main}{Optional title for the figure.}
  \item{xlab}{x-axis label for the Ecdf plot.}
  \item{ylab}{y-axis label for the Ecdf plot.}
  \item{with.grid}{Logical.  If true, draw faint grid lines on the ECDF
    plot.}
  \item{cex.lab}{Graphical parameters for plot and axes.}
  \item{cex.axis}{Graphical parameters for plot and axes.}
  \item{...}{Additional parameters are passed to \code{plot()}.}
}
\details{
The \code{PlotLog2ByteEcdf} function takes a histogram or ecdf which
has power of 2 bucket boundaries representing bytes and creates an
Ecdf plot.

The \code{PlotLogTimeDurationEcdf} function takes a histogram or ecdf
which has exponential bucket boundaries representing seconds of age or
duration and creates an Ecdf plot.
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

x <- rexp(100000)
x <- x*(86400*300)/diff(range(x))

n <- as.integer(1+log2(max(x)))

h <- hist(x, breaks=c(0, unique(as.integer(2^seq(from=0, to=n, by=.25)))))
PlotLogTimeDurationEcdf(h)
}
