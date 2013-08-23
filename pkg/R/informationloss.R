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

IECC <- WorstCaseCDFIntegratedError <- function(h) {
  # Integrated maximum Kolmogorov-Smirnov distance between the largest
  # and smallest empirical cumulative distribution functions that
  # could be represented by the binned data in the provided histogram.
  #
  # TODO(mstokely): Better name for this?  IECC for consistency?

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

WADCC <- function(h) {
  # Weighted Average Displacement of the Cumulative Curves
  #
  # The weighted average displacement between the largest and smallest
  # empirical cumulative distribution functions that could be
  # represented by the binned data in the provided histogram.

  MinEcdf <- HistToEcdf(h, f=0)
  MaxEcdf <- HistToEcdf(h, f=1)

  # Equivalently, with Hmisc:
  # wtd.mean(abs(MaxEcdf(h$mids) - MinEcdf(h$mids)), h$counts)

  return(sum(abs(MaxEcdf(h$mids) - MinEcdf(h$mids)) * h$counts)/ sum(h$counts))
}

PlotMDCC <- function(h, arrow.size.scale=1, main=NULL) {
  # Plot a CDF from the given histogram along with a red arrow
  # indicating the point of maximum distance between the possible CDFs
  # of the underlying unbinned distribution corresponding to the MDCC.
  #
  # Args:
  #   h: An S3 histogram object.
  #   arrow.size.scale: An optional value to scale the size of the arrow head

  MinEcdf <- HistToEcdf(h, f=0)
  MaxEcdf <- HistToEcdf(h, f=1)
  if (!is.null(main)) {
    plot(MaxEcdf, main=main)
  } else {
    plot(MaxEcdf)
  }

  diffs <- MaxEcdf(h$mids) - MinEcdf(h$mids)
  mdcc <- max(diffs)
  index.of.max <- min(which(diffs == mdcc))
  height <- MaxEcdf(h$mids[index.of.max]) - MinEcdf(h$mids[index.of.max])
  arrows(knots(MinEcdf)[index.of.max], MinEcdf(h$mids[index.of.max]),
         knots(MinEcdf)[index.of.max], MaxEcdf(h$mids[index.of.max]),
         length=0.25*(4*height)*arrow.size.scale,     # (4*height) chosen on aesthetics
         code=3, col="red", lwd=3)
}

PlotWADCC <- function(h, arrow.size.scale=1, main=NULL) {
  # Plot a CDF from the given histogram along with red arrows
  # indicating the points of distance between the possible CDFs
  # of the underlying unbinned distribution corresponding that are used
  # in the WADCC.
  #
  # Args:
  #   h: An S3 histogram object.
  #   arrow.size.scale: An optional value to scale the size of the arrow head

  MinEcdf <- HistToEcdf(h, f=0)
  MaxEcdf <- HistToEcdf(h, f=1)
  if (!is.null(main)) {
    plot(MaxEcdf, main=main)
  } else {
    plot(MaxEcdf)
  }

  height <- max(MaxEcdf(h$mids) - MinEcdf(h$mids))
  arrows(h$mids, MinEcdf(h$mids), h$mids, MaxEcdf(h$mids),
         length=0.25*(4*height)*arrow.size.scale,     # (4*height) chosen on aesthetics
         code=3, col="red", lwd=3)
}

PlotWorstCaseCDFIntegratedError <- function(h, main=NULL) {
  # Plot a CDF from the given histogram with a yellow boxes
  # covering all possible ranges for the e.c.d.f of the underlying
  # distribution from which the binned histogram was created.
  #
  # Args:
  #   h: An S3 histogram object.

  MinEcdf <- HistToEcdf(h, f=0)
  MaxEcdf <- HistToEcdf(h, f=1)
  if (!is.null(main)) {
    plot(MaxEcdf, main=main)
  } else {
    plot(MaxEcdf)
  }
  rect(head(knots(MinEcdf), -1),
       MinEcdf(head(knots(MinEcdf), -1)),
       tail(knots(MinEcdf), -1),
       MaxEcdf(tail(knots(MinEcdf), -1)),
       col="yellow")
}
