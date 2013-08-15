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

MergeManyHistograms <- function(x, main=paste("Merge of", length(x), "histograms")) {
  # Merges many histogram objects that have the same bins.
  #
  # Args:
  #   x: A list of S3 histogram objects
  #   main:  The name to set for the merged histogram (e.g. used in plots).
  #
  # Returns:
  #   An S3 histogram class suitable for plotting.
  stopifnot(all(sapply(x, inherits, "histogram")))
  br <- unname(lapply(x, function(y) y$breaks))
  stopifnot(all(sapply(head(seq_along(br),-1), function(y) identical(br[y], br[y+1]))))
  # All have identical breaks.
  cnts <- unname(lapply(x, function(y) y$counts))
  sum.cnts <- Reduce("+", cnts)
  hist <- list(breaks=x[[1]]$breaks,
               counts=sum.cnts,
               mids=x[[1]]$mids,
               equidist=x[[1]]$equidist)
  hist$density <- hist$counts / (sum(hist$counts) * diff(hist$breaks))

  class(hist) <- "histogram"
  return(hist)
}
