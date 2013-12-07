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

\name{HistogramDistance}
\alias{minkowski.dist}
\alias{intersect.dist}
\alias{kl.divergence}
\alias{jeffrey.divergence}
\title{Histogram Distance Measures}
\description{
The pairs of bins in two histograms with the same bucket boundaries are
compared to compute bin-by-bin dissimilarity measures.
}
\usage{
minkowski.dist(h1, h2, p)
intersect.dist(h1, h2)
kl.divergence(h1, h2)
jeffrey.divergence(h1, h2)
}
\arguments{
  \item{h1}{A \code{"histogram"} object (created by
    \code{\link[graphics]{hist}}) representing a binned dataset.}
  \item{h2}{A \code{"histogram"} object (created by
    \code{\link[graphics]{hist}}) representing a binned dataset.}
  \item{p}{Order of the minkowski distance between two histograms to
    compute.}
}
\details{
The \code{minkowski.dist} function computes the Minkowski distance of
order \code{p} between two histograms.  p=1 is the Manhattan distance
and p=2 is the Euclidean distance.

The \code{intersect.dist} function computes the intersection distance of
two histograms.

The \code{kl.divergence} function computes the Kullback-Leibler
divergence between two histograms.

The \code{jeffrey.divergence} function computes the Jeffrey
divergence between two histograms.
}
\references{
Rubner, Yossi, Carlo Tomasi, and Leonidas J. Guibas. "The earth mover's
distance as a metric for image retrieval." International Journal of
Computer Vision 40.2 (2000): 99-121.

Puzicha, Jan, Thomas Hofmann, and Joachim M. Buhmann. "Non-parametric
similarity measures for unsupervised texture segmentation and image
retrieval." Computer Vision and Pattern Recognition, 1997. Proceedings.,
1997 IEEE Computer Society Conference on. IEEE, 1997.

Swain, Michael J., and Dana H. Ballard. "Color indexing." International journal of computer vision 7.1 (1991): 11-32.
}
\author{Murray Stokely \email{mstokely@google.com}}
\seealso{
\code{\link{histogramtools-package}},
\code{\link{ecdf}}, and
\code{\link[graphics]{hist}}.
}
\examples{
h1 <- hist(runif(100), plot=FALSE)
h2 <- hist(runif(100), plot=FALSE)

minkowski.dist(h1, h2, 1)
minkowski.dist(h1, h2, 2)
minkowski.dist(h1, h2, 3)
intersect.dist(h1, h2)
kl.divergence(h1, h2)
jeffrey.divergence(h1, h2)
}
