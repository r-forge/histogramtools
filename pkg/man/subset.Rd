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

\name{SubsetHistogram}
\alias{SubsetHistogram}
\title{Subset a histogram by removing some of the buckets.}
\description{
SubsetHistogram creates a histogram by zooming in on a portion of a
larger histogram and discarding tail buckets.
}
\usage{
  SubsetHistogram(x, minbreak=NULL, maxbreak=NULL)
}
\arguments{
  \item{x}{A histogram object (created by \code{\link[graphics]{hist}}).}
  \item{minbreak}{If non-\code{NULL}, specifies a new minimum breakpoint
for the returned histogram.  Must be one of the existing breakpoints of \code{x}.}
  \item{maxbreak}{If non-\code{NULL}, specifies a new maximum breakpoint
for the returned histogram.  Must be one of the existing breakpoints of \code{x}.}
}
\details{
This function provides a way to "zoom-in" on a histogram by setting new
minimum and maximum breakpoints and returning a histogram of only the
interior part of the distribution.  At least one of \code{minbreak} or
\code{maxbreak} should be set, otherwise the original histogram is
returned unmodified.
}
\keyword{methods}
\author{Murray Stokely \email{mstokely@google.com}}
\seealso{
\code{\link{histogramtools-package}} and
\code{\link[graphics]{hist}}.
}
\examples{
hist.1 <- hist(c(1,2,3), breaks=c(0,1,2,3,4,5,6,7,8,9), plot=FALSE)
hist.2 <- SubsetHistogram(hist.1, maxbreak=6)

hist.1
hist.2
}
\keyword{manip}
\keyword{utilities}
