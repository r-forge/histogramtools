# Copyright 2011 Google Inc. All Rights Reserved.
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

TestMergeHistograms <- function() {
  hist.1 <- hist(c(1, 2, 3, 4), plot=FALSE)
  hist.2 <- hist(c(1, 2, 2, 4), plot=FALSE)
  hist.merged <- merge(hist.1, hist.2)
  checkEquals(hist.merged$breaks, c(1, 2, 3, 4))
  checkEquals(hist.merged$counts, c(5, 1, 2))
}

TestMergeBucketsHistograms <- function() {
  hist.1 <- hist(c(1,2,3), breaks=0:9, plot=FALSE)
  hist.2 <- MergeBuckets(hist.1, adj=2)
  checkEquals(hist.2$breaks, c(0,2,4,6,8,9))
  checkEquals(hist.2$counts, c(2,1,0,0,0))

  hist.3 <- MergeBuckets(hist.1, breaks=3)
  checkEquals(hist.3$breaks, c(0,3,6,9))
  checkEquals(hist.3$counts, c(3,0,0))

  # Now specify explicit subset of bucket boundaries.
  hist.4 <- MergeBuckets(hist.1, breaks=c(0, 3, 6, 9))
  checkEquals(hist.4$breaks, c(0, 3, 6, 9))
  checkEquals(hist.4$counts, c(3, 0, 0))

  # Now specify a variant on hist.1
  hist.5 <- hist(c(1,2,3), breaks=0:10, plot=FALSE)
  hist.6 <- MergeBuckets(hist.5, adj=2)
  checkEquals(hist.6$breaks, c(0, 2, 4, 5, 8, 10))
  checkEquals(hist.6$counts, c(3, 1, 0, 0, 0))
}

TestMergeManyHistograms <- function() {
  hist.1 <- hist(c(1,2,3), breaks=0:9, plot=FALSE)
  hist.2 <- hist(c(1,2,3), breaks=0:9, plot=FALSE)
  hist.3 <- hist(c(4,5,6), breaks=0:9, plot=FALSE)
  hist.merged <- MergeManyHistograms(list(hist.1, hist.2, hist.3))
  checkEquals(hist.merged$breaks, 0:9)
  checkEquals(hist.merged$counts, c(2, 2, 2, 1, 1, 1, 0, 0, 0))
}
