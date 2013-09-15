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

\name{ASH}
\alias{HistToASH}
\title{Average Shifted Histograms From a Histogram.}
\description{
Computes a univariate average shifted histogram (polynomial kernel)
given a single input histogram.
}
\usage{
HistToASH(h, m=5, kopt=c(2,2))
}
\arguments{
  \item{h}{A histogram object (created by \code{\link[graphics]{hist}}) representing a pre-binned dataset
    on which we'd like to calculate an Average Shifted Histogram.}
  \item{m}{optional integer smoothing parameter, passed to \code{\link[ash]{ash1}()}.}
  \item{kopt}{vector of length 2 specifying the kernel, passed to \code{\link[ash]{ash1}()}.}
}
\details{
  This function takes a histogram and uses the counts as the input to
  the \code{\link[ash]{ash1}()} function in the ash package to compute
  the average shifted histogram.
}
\references{Scott, David W. \emph{Multivariate density estimation: theory, practice, and visualization.} Vol. 383. Wiley. com, 2009.}
\author{Murray Stokely \email{mstokely@google.com}}
\seealso{
\code{\link{histogramtools-package}},
\code{\link[ash]{ash1}}, and
\code{\link[graphics]{hist}}.
}
\examples{
x <- runif(1000, min=0, max=100)
h <- hist(x, breaks=0:100, plot=F)
plot(h,freq=FALSE)

# Superimpose the Average Shifted Histogram on top of the original.
lines(HistToASH(h), col="red")
}
\keyword{nonparametric}
