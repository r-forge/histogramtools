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

PlotLog2ByteEcdf <- function(x, main="", xlab="Bytes (log)",
                             ylab="Cumulative Fraction",
                             ...) {
  if (inherits(x, "histogram")) {
    x <- HistToEcdf(x)
  }
  stopifnot(inherits(x, "ecdf"))
  if (sum(knots(x) %in% 2^(0:50)) < 3) {
    stop("Insufficient powers of 2 in knots() of ecdf")
  }
  plot(knots(x), x(knots(x)),
       type="l",
       lwd=2,
       log="x",
       main=main,
       xaxt="n",
       las=1,
       xlab=xlab,
       ylab=ylab,
       ...
       )
  
  if (sum(knots(x) %in% 2^(0:50)) < 3) {
    stop("Insufficient powers of 2 in knots() of ecdf")
  }
  axt.marks <- knots(x)[knots(x) %in% 2^(0:50)]
  if (require(gdata)) {
    labs <- humanReadable(knots(x)[knots(x) %in% 2^(0:50)], standard="")
  } else {
    labs <- knots(x)[knots(x) %in% 2^(0:50)]
  }
  axis(1, at=axt.marks, lab=labs)
}

PlotLogTimeDurationEcdf <- function(myhist, main="") {
# Plots weighted ECDF of our storage histograms using human-readable
# log-scaled x-axis labels from 1 minute to 1 year.
#
# Args:
#   myhist: A histogram objects.

  stopifnot(inherits(myhist, "histogram"))
  f <- HistToEcdf(myhist)

  plot(knots(f), f(knots(f)),
       type="l",
       lwd=2,
       log="x",
       main=main,
       xaxt="n",
#       xlim=c(60, 86400 * 365 * 4),
       las=1,
       cex.lab=1.6,
       cex.axis=1.6,
       xlab="Age (log)",
       ylab="Cumulative fraction",
       yaxt="n")

  xticks <- list("1m" = 60,
                 "10m" = 60 * 10,
                 "1h" = 3600,
                 "6h" = 3600 * 6,
                 "1d" = 86400,
                 "3d" = 86400 * 3,
                 "7d" =  86400 * 7,
                 "30d" = 86400 * 30,
                 "4m" = 86400 * 30 * 4,
                 "1y" = 86400 * 365)

  axis(1, at=unlist(xticks), labels=names(xticks), cex.axis=1.6)
  axis(2, at=seq(0,1,by=.2), las=1, cex.axis=1.6)

  abline(h=seq(.2,.8, by=.2), lty="dotted", col="lightgray")
  abline(v=xticks, lty="dotted", col="lightgray")

  legend(myhist$xname, x="topleft", lty=1, bty="n", cex=1.6)
}

# This isn't very useful, just a better axis label for what you
# get with freq=TRUE with log buckets with plot.default (which rightly gives a warning)

PlotLog2Log10Histogram <- function(h, trim=TRUE, density=TRUE) {
  # Plot a histogram where the breakpoints include the powers of 2
  # such that the x-axis should be plotted log2 and the y-axis should
  # be plotted log10.
  #
  # Args:
  #   h:  A histogram object with breaks that include the powers of 2.
  #   trim:  If TRUE, trim empty buckets before plotting.

  stopifnot(inherits(h, "histogram"))
  if (sum(2^(1:50) %in% h$breaks) < 3) {
    stop("In sufficient powers of 2 in breaks of histogram.")
  }
  if (diff(range(h$counts)) < 100) {
    stop("In sufficient range of y-axis for log10 plot.")
  }

  if (trim) {
    # TODO(mstokely): This likely only makes sense for the right tail.
    h <- TrimHistogram(h)
  }

  # Looks kind of nice but axis label offsets are all messed up /
  # difficult to place
  
  # +1 because log of 0 is -infinity.  Adjust y-axis scale appropriately.
  barplot(log10(h$counts+1), width=diff(h$breaks), space=0, yaxt="n", xaxt="n",
          col=heat.colors(length(h$counts)))

  if (require(gdata)) {
    axis(1, at=2^(1:50), lab=humanReadable(2^(1:50), standard=""))
  } else {
    axis(1, at=2^(1:50))
  }
  axis(2, at=(0:as.integer(max(log10(h$counts))+1)),
       labels=10^(0:as.integer(max(log10(h$counts))+1)))
}
