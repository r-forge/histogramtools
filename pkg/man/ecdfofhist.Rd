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

\name{HistToEcdf}
\alias{HistToEcdf}
\title{Empirical Cumulative Distribution Function From a Histogram.}
\description{
Computes an approximate empirical cumulative distribution function of a
data set given a binned histogram representation of that dataset.
}
\usage{
HistToEcdf(h, method="constant", f=0)
}
\arguments{
  \item{h}{A histogram object (created by \code{\link[graphics]{hist}}) representing a pre-binned dataset
    on which we'd like to calculate an ECDF.}
  \item{method}{specifies the interpolation method to be used in call to
    \code{\link[stats]{approxfun}()}.  Choices are \code{"linear"} or \code{"constant"}.}
  \item{f}{if \code{method="constant"} a number between 0 and 1 inclusive,
    indicating a compromise between left- and right-continuous
     step functions.  See \code{?approxfun}}
}
\details{
  This function approximates the e.c.d.f. (empirical cumulative
  distribution function) of a data set given a binned
  histogram representation of that data set.
}
\author{Murray Stokely \email{mstokely@google.com}}
\seealso{
\code{\link{histogramtools-package}},
\code{\link{ecdf}},
\code{\link[stats]{approxfun}}, and
\code{\link[graphics]{hist}}.
}
\examples{
h <- hist(runif(100), plot=FALSE)
plot(HistToEcdf(h))
}
\keyword{manip}
\keyword{utilities}
