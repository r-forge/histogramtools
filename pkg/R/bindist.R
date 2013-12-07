# Copyright 2013 Google Inc. All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# Author: mstokely@google.com (Murray Stokely)

# Defined in Color Indexing, by Swain and Ballard.
intersect.hist <- function(h1, h2) {
  stopifnot(inherits(h1, "histogram"), inherits(h2, "histogram"))
  stopifnot(all(h1$breaks == h2$breaks))
  intersect.counts <- pmin(h1$counts, h2$counts)
  return(HistogramTools:::.BuildHistogram(h1$breaks, intersect.counts))
}

# Minkowski-form distance described in section 2.1 of
# "The Earth Mover's Distance as a Metric for Image Retrieval"
minkowski.dist <- function(h1, h2, p) {
  stopifnot(inherits(h1, "histogram"), inherits(h2, "histogram"))
  stopifnot(all(h1$breaks == h2$breaks))
  stopifnot(is.numeric(p), length(p) == 1, p > 0)
  return((sum(abs(h1$counts - h2$counts)^p))^(1/p))
}

intersect.dist <- function(h1, h2) {
  stopifnot(inherits(h1, "histogram"), inherits(h2, "histogram"))
  stopifnot(all(h1$breaks == h2$breaks))
  h3 <- intersect.hist(h1, h2)
  return(1 - (sum(h3$counts) / sum(h2$counts)))
}

# Described in EMD paper above, which references
# S. Kullback.  Information Theory and Statistics, Dover, 1968.
kl.divergence <- function(h1, h2) {
  stopifnot(inherits(h1, "histogram"), inherits(h2, "histogram"))
  stopifnot(all(h1$breaks == h2$breaks))
  return(sum(h1$counts * log(h1$counts / h2$counts)))
}


# In EMD paper aboce, which references
# Puzicha, Non-parametric similarity measures for unsupervised texture segmentationFr
jeffrey.divergence <- function(h1, h2) {
  stopifnot(inherits(h1, "histogram"), inherits(h2, "histogram"))
  stopifnot(all(h1$breaks == h2$breaks))
  m <- HistogramTools:::.BuildHistogram(h1$breaks,
                                        (h1$counts + h2$counts) / 2)
  return(sum(h1$counts * log(h1$counts / m$counts) +
             h2$counts * log(h2$counts / m$counts)))
}
