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

# TODO(mstokely): Add documentation and examples in the vignette.

WorstCaseCDFInformationLoss <- function(h) {
  # Integrated maximum Kolmogorov-Smirnov distance between the largest
  # and smallest empirical cumulative distribution functions that
  # could be represented by the binned data in the provided histogram.
  #
  # TODO(mstokely): Better name for this.

  MinEcdf <- HistToEcdf(h, f=0)
  MaxEcdf <- HistToEcdf(h, f=1)
  total.width <- max(knots(MaxEcdf)) - min(knots(MinEcdf))
  total.height <- 1
  total.area <- total.width * total.height

  areas.of.cdf.uncertainty <- (tail(knots(MinEcdf), -1) -
                               head(knots(MinEcdf), -1)) *
                                 (MaxEcdf(tail(knots(MinEcdf), -1)) -
                                  MinEcdf(head(knots(MinEcdf), -1)))

  return(sum(areas.of.cdf.uncertainty) / total.area)
}

MDCC <- function(h) {
  # Maximum Displacement of the Cumulative Curves
  #
  # Kolmogorov-Smirnov distance between the largest and smallest
  # empirical cumulative distribution functions that could be
  # represented by the binned data in the provided histogram.
  #
  # See e.g. http://research.microsoft.com/pubs/72885/fiveyearstudy.pdf
  #
  # Args:
  #   h:  An R histogram object.
  # Return Value:
  #   A number between 0 and 1 giving the MDCC.

  MinEcdf <- HistToEcdf(h, f=0)
  MaxEcdf <- HistToEcdf(h, f=1)

  # The knots() of these ECDFs are our histogram break points.
  # So we evaluate the differences at the histogram mid points.
  return(max(MaxEcdf(h$mids) - MinEcdf(h$mids)))
}

PlotMDCC <- function(h) {
  # Plot a CDF from the given histogram along with a yellow box
  # indicating the area of the CDF with the greatest amount of
  # uncertainty representing the part of the distribution
  # corresponding to the MDCC.
  #
  # Args:
  #   h: An S3 histogram object.

  MinEcdf <- HistToEcdf(h, f=0)
  MaxEcdf <- HistToEcdf(h, f=1)
  plot(MaxEcdf)

  diffs <- MaxEcdf(h$mids) - MinEcdf(h$mids)
  mdcc <- max(diffs)
  index.of.max <- min(which(diffs == mdcc))
  rect(knots(MinEcdf)[index.of.max - 1],
       MinEcdf(knots(MinEcdf)[index.of.max - 1]),
       knots(MinEcdf)[index.of.max],
       MaxEcdf(knots(MinEcdf)[index.of.max]),
       col="yellow")
}

PlotEcdfInformationLossOfHist <- function(h) {
  # Plot a CDF from the given histogram with a yellow boxes
  # covering all possible ranges for the e.c.d.f of the underlying
  # distribution from which the binned histogram was created.
  #
  # Args:
  #   h: An S3 histogram object.

  MinEcdf <- HistToEcdf(h, f=0)
  MaxEcdf <- HistToEcdf(h, f=1)
  plot(MaxEcdf)
  rect(head(knots(MinEcdf), -1),
       MinEcdf(head(knots(MinEcdf), -1)),
       tail(knots(MinEcdf), -1),
       MaxEcdf(tail(knots(MinEcdf), -1)),
       col="yellow")
}
