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

# Integrated maximum Kolmogorov-Smirnov distance between worst-case
# empirical cumulative distribution functions that could be
# represented by the binned data in the provided histogram.
#
# Return value between 0 (no information loss) and 1 (total information loss).
WorstCaseCDFInformationLoss <- function(h) {
# TODO(mstokely): Better name for this.
#
# Another thing people do with histograms is the Maximum Displacement
# of the Cumulative Curves (e.g. in
# http://research.microsoft.com/pubs/72885/fiveyearstudy.pdf )
# but I like this metric better and the vignette will compare them.
  min.ecdf <- EcdfOfHist(h, f=0)
  max.ecdf <- EcdfOfHist(h, f=1)
  total.width <- max(knots(max.ecdf)) - min(knots(min.ecdf))
  total.height <- 1
  total.area <- total.width * total.height

  areas.of.cdf.uncertainty <- (tail(knots(min.ecdf), -1) - head(knots(min.ecdf), -1)) *
    (sapply(tail(knots(min.ecdf), -1), max.ecdf) - sapply(head(knots(min.ecdf), -1), min.ecdf))

  return(sum(areas.of.cdf.uncertainty) / total.area)
}

# Visual representation of the uncertainty of CDFs generated from
# binned histogram datasets.
PlotEcdfInformationLossOfHist <- function(h) {
  min.ecdf <- EcdfOfHist(h, f=0)
  max.ecdf <- EcdfOfHist(h, f=1)
  plot(max.ecdf)
  rect(head(knots(min.ecdf), -1),
       sapply(head(knots(min.ecdf), -1), min.ecdf),
       tail(knots(min.ecdf), -1),
       sapply(tail(knots(min.ecdf), -1), max.ecdf),
       col="yellow")
}


# TODO(mstokely): Implement MDCC metric also
