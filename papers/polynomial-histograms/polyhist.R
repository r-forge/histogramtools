library(rbigtable)
library(HistogramTools)
library(ghistogram)
InitGoogle()

kStorageMetricsBigtable <- "/bigtable/mix-ag/storage-analytics.polyhist"
file.sizes<-ReadBigtablePrefix(kStorageMetricsBigtable,
                       "polyfileage:ob-d",
                       "col(polyhist:.*)")

hist.class <- P("stats.PolynomialHistogramState")

file.size.protos <- lapply(file.sizes, function(x) stats.PolynomialHistogramState$read(x$value))

basic.hists <- lapply(file.size.protos, function(x) as.histogram(x$histogram))

# What is dist of number of files stored?
# hist(sapply(basic.hists, function(x) sum(x$counts))

big.indices <- which(sapply(basic.hists, function(x) sum(x$counts)) > 500)
big.protos <- file.size.protos[big.indices]
big.hists <- basic.hists[big.indices]

big.means <- lapply(file.size.protos[big.indices], function(x) x$polynomials$means)
big.sums.of.squares <- lapply(file.size.protos[big.indices], function(x) x$polynomials$sums_of_squares)
# annotate our histograms with the means.
for (i in seq_along(big.hists)) {
  big.hists[[i]]$means <- big.means[[i]]
  big.hists[[i]]$sums.of.squares <- big.sums.of.squares[[i]]
  class(big.hists[[i]]) <- c("histogram", "polynomial.histogram")
}

big.hists.2 <- lapply(big.hists, MergeBuckets.polyhist, adj.buckets=2)

###############################################################################

emdcc.normal <- sapply(big.hists, EMDCC)
emdcc.poly <- sapply(big.hists.2, EMDCC.polyhist)
diff.of.emdcc <- emdcc.normal - emdcc.poly
range(diff.of.emdcc)
mean(emdcc.normal)
mean(emdcc.poly)

### New plot to replace table 1
plot(emdcc.poly, emdcc.normal, log="xy")
 grid()
 abline(b=1)
 abline(b=1,a=0)
###

# Still slightly better with polynomial histograms, yay!

set.seed(0)  # Chosen so that the average is better with polynomial hists
samples <- unique(c(which(diff.of.emdcc == max(diff.of.emdcc)),
                    which(diff.of.emdcc == min(diff.of.emdcc)),
                    sample(1:length(reg.hists), 100)))

hists.1 <- big.hists[samples]
hists.2 <- big.hists.2[samples]
#
emdcc.normal <- sapply(hists.1, EMDCC)
emdcc.poly <- sapply(hists.2, EMDCC.polyhist)
diff.of.emdcc <- emdcc.normal - emdcc.poly
range(diff.of.emdcc)
mean(emdcc.normal)
mean(emdcc.poly)

hist(diff.of.emdcc)

###


# Now what is the sum of these hists
# sum(sapply(hists.1, function(x) sum(x$means * x$counts, na.rm=TRUE)))
# [1] 7.768857e+15

# Just a few PB, so probably ok from disclosure perspective.

save(hists.1, hists.2, file="/home/mstokely/filesize-polyhists.Rdata"

par(mfrow=c(2,2))
par(mar=c(3,4,1,1))

PlotLog2ByteEcdf(hists.1[[which(diff.of.emdcc == max(diff.of.emdcc))]])
PlotLog2ByteEcdf(hists.2[[which(diff.of.emdcc == max(diff.of.emdcc))]])
PlotLog2ByteEcdf(hists.1[[which(diff.of.emdcc == min(diff.of.emdcc))]])
PlotLog2ByteEcdf(hists.2[[which(diff.of.emdcc == min(diff.of.emdcc))]])

pdf("figures/extreme-emdcc-hists.pdf", width=5, height=3.5)
par(mfrow=c(2,2))
par(mar=c(3,4,1,1))
myplot(hists.1[[which(diff.of.emdcc == max(diff.of.emdcc))]], standard="bin", main="User 1 Reg Hist")
myplot(hists.2[[which(diff.of.emdcc == max(diff.of.emdcc))]], standard="bin", main="User 1 Poly Hist")
myplot(hists.1[[which(diff.of.emdcc == min(diff.of.emdcc))]], standard="bin", main="User 2 Reg Hist")
myplot(hists.2[[which(diff.of.emdcc == min(diff.of.emdcc))]], standard="bin", main="User 2 Poly Hist")
dev.off()
system("pdfcrop extreme-emdcc-hists.pdf")

x<-hists.1[[which(diff.of.emdcc == max(diff.of.emdcc))]]

x<-hists.2[[which(diff.of.emdcc == max(diff.of.emdcc))]]

myplot <- function(x, xlab = "Bytes (log)", ylab = "Cumulative Fraction",
    with.grid = TRUE, standard="SI", ...)
{
    if (inherits(x, "histogram")) {
        x <- HistToEcdf(x)
    }
    stopifnot(inherits(x, "ecdf"))
    power.of.two.breaks <- intersect(knots(x), 2^(0:53))
    full.power.of.two.breaks <- power.of.two.breaks
    if (length(power.of.two.breaks) < 3) {
        stop("Insufficient powers of 2 in knots() of ecdf")
    }
    plot(knots(x), x(knots(x)), type = "l", lwd = 2, log = "x",
        xaxt = "n", las = 1, xlab = xlab, ylab = ylab, ...)

    if (length(power.of.two.breaks) > 10) {
      if (sum(2^(10*(0:5)) %in% power.of.two.breaks) >= 5) {
        power.of.two.breaks <- power.of.two.breaks[power.of.two.breaks %in% 2^(10*(0:5))]
      } else if (sum(2^(5+(10*(0:5))) %in% power.of.two.breaks) >= 5) {
        power.of.two.breaks <- power.of.two.breaks[power.of.two.breaks %in% 2^(5+(10*(0:5)))]
      }
    }
    if (require(gdata)) {
        labs <- humanReadable(power.of.two.breaks, standard)
    }
    else {
        labs <- power.of.two.breaks
    }
    axis(1, at = power.of.two.breaks, labels = labs)
    if (with.grid) {
        abline(h = seq(0.2, 0.8, by = 0.2), lty = "dotted", col = "lightgray")
        abline(v = full.power.of.two.breaks, lty = "dotted", col = "lightgray")
    }
}

#
# Lets largest from big.hists and big.hists.2
#
#

max(sapply(big.hists, function(x) attr(x, "sumofsquares")))
which(sapply(big.hists, function(x) attr(x, "sumofsquares")) >1.6 * 10^27)

reg.hists <- big.hists[sapply(big.hists, function(x) attr(x, "sumofsquares")) != max(sapply(big.hists, function(x) attr(x, "sumofsquares")))]

poly.hists <- big.hists.2[sapply(big.hists, function(x) attr(x, "sumofsquares")) != max(sapply(big.hists, function(x) attr(x, "sumofsquares")))]

emdcc.normal <- sapply(reg.hists, EMDCC)
emdcc.poly <- sapply(poly.hists, EMDCC.polyhist)
diff.of.emdcc <- emdcc.normal - emdcc.poly
range(diff.of.emdcc)
mean(emdcc.normal)
mean(emdcc.poly)

#
set.seed(0)
samples <- unique(c(which(diff.of.emdcc == max(diff.of.emdcc)),
                    which(diff.of.emdcc == min(diff.of.emdcc)),
                    sample(1:length(reg.hists), 100)))

hists.1 <- big.hists[samples]
hists.2 <- poly.hists[samples]
#
emdcc.normal <- sapply(hists.1, EMDCC)
emdcc.poly <- sapply(hists.2, EMDCC.polyhist)
diff.of.emdcc <- emdcc.normal - emdcc.poly
range(diff.of.emdcc)
mean(emdcc.normal)
mean(emdcc.poly)

####


# Still too much data, lets sample to just 100 histograms.
# But make sure we keep the interesting indices!



# For production code, consider rglib and ReadProtoFilesFromResources instead
hist.class <- P("stats.PolynomialHistogramState")

file.sizes.proto <- stats.PolynomialHistogramState$read(file.sizes[[1]]$value)

# Now just get a normal histogram out of it.

basic.hist <- as.histogram(file.sizes.proto$histogram)
PlotLog2ByteEcdf(HistToEcdf(basic.hist))

# Now, make sure we have as many means as we have buckets in our hist.

length(basic.hist$counts)

# What about the means of the values in each of those buckets?

basic.means <- file.sizes.proto$polynomials$means




emdcc

# Make a simple polynommial histogram, or "annotated histogram" as we
# called them back in december.
library(HistogramTools)
breaks <- c(0,1,2)
counts <- c(10,5)
means <- c(0.5,1.1)
h<-PreBinnedHistogram(breaks, counts)
h$means <- means

# (sum(diff(h$breaks) * h$counts)/sum(h$counts)/diff(range(h$breaks)))

MergeBuckets.polyhist <- function(x, adj.buckets=NULL, breaks=NULL, FUN=sum) {
  # Merge adjacent buckets of a Histogram.
  #
  # This only makes sense where the new bucket boundaries are a subset
  # of the previous bucket boundaries.  Only one of adj.buckets or
  # breaks should be specified.
  #
  # Args:
  #   x: An S3 polynomial histogram object
  #   adj.buckets: The number of adjacent buckets to merge.
  #   breaks: a vector giving the breakpoints between cells, or a
  #     single number giving number of cells.  Must have same range
  #     as x$breaks.
  #   FUN: The function used to merge buckets.  Using anything other than
  #     sum here would break the density so use with care.
  #
  # Returns:
  #   An S3 histogram class suitable for plotting.
  stopifnot(inherits(x, "polynomial.histogram"))
  stopifnot(inherits(x, "histogram"))
  if (is.null(adj.buckets)) {
    stopifnot(is.numeric(breaks), length(breaks) > 0)
    if (length(breaks) > 1) {
      return(.MergeBucketsToBreakList(x, breaks, FUN))
    }
    stopifnot(breaks < length(x$breaks))
    # How many new buckets will we have.
    new.bucket.count <- breaks
    adj.buckets <- ceiling(length(x$counts) / new.bucket.count)
  } else {
    stopifnot(is.numeric(adj.buckets), length(adj.buckets) == 1,
              adj.buckets > 1)
    if (!is.null(breaks)) {
      stop("Only one of adj.buckets and breaks should be specified.")
    }
    new.bucket.count <- ceiling(length(x$counts) / adj.buckets)
  }

  # The last bucket may not be full, hence the length.out
  # TODO(mstokely): Consider bucket.grouping <- x$breaks[
  #                             ceiling(seq_along(x$counts) / adj.buckets)]
  # or: seq(from = 1, by = adj.buckets, length = new.bucket.count + 1)
  bucket.grouping <- rep(x$breaks[1+(0:new.bucket.count)*adj.buckets],
                         each=adj.buckets, length.out=length(x$counts))

  tmp.df <- aggregate(x$counts, by=list(breaks=bucket.grouping), FUN)
  # Not this simple, because where counts is 0 set the sum to 0.
  x$sums <- x$means * x$counts
  x$sums[which(x$counts == 0)] <- 0
  sums.df <- aggregate(x$sums, by=list(breaks=bucket.grouping), FUN)
# todo(mstokely): check for existence of sums of squares first.
#  sums.of.squares.df <- aggregate(x$sums.of.squares, by=list(breaks=bucket.grouping), FUN)

  x$counts <- tmp.df$x
  x$sums <- sums.df$x
# todo(mstokely) do this if we have it.
#  x$sums.of.squares <- sums.of.squares.df$x
  x$means <- sums.df$x / tmp.df$x
  x$breaks <- c(tmp.df$breaks, tail(x$breaks, 1))

  # Updated the other named list elements of the histogram class and return.
  return(HistogramTools:::.UpdateHistogram(x))
}

EMDCC.polyhist <- function(h) {
  stopifnot(inherits(h, "polynomial.histogram"))
  alpha <- (h$means - head(h$breaks, -1)) /
    (tail(h$breaks, -1) - head(h$breaks, -1))
  # Where we don't have a mean it will be 0 anyway since counts will be 0.
  alpha[is.nan(alpha)]<-0
  reduction <- alpha * log(1 / alpha) + (1-alpha) * log(1/ (1 - alpha))
  # Where we had alpha of 0, this creates NaN in reduciton since 0 * ln(1/0)
  # but alpha 0 reduces information loss absolutely. as does alpha 1.
  reduction[alpha == 0] <- 0
  reduction[alpha == 1] <- 0
  return(sum(diff(h$breaks) * as.numeric(h$counts) * reduction, na.rm=TRUE) /
         sum(h$counts) / # normalize by y-range
         diff(range(h$breaks)))  # normalize by x-range
}

poly.hist.2 <- MergeBuckets.polyhist(poly.hist, adj.buckets=2)
poly.hist.4 <- MergeBuckets.polyhist(poly.hist, adj.buckets=4)
poly.hist.8 <- MergeBuckets.polyhist(poly.hist, adj.buckets=8)
EMDCC.polyhist(poly.hist.2)
EMDCC.polyhist(poly.hist)
EMDCC(poly.hist)

EMDCC.polyhist(poly.hist.4)
EMDCC(poly.hist.2)

EMDCC.polyhist(poly.hist.8)
EMDCC(poly.hist.4)

library(HistogramTools)
breaks <- c(0,1,2)
counts <- c(10,5)
means <- c(0.5,1.1)
h<-PreBinnedHistogram(breaks, counts)
h$means <- means


plot(h)
# Looks basic, yeah
MinEcdf <- HistToEcdf(h, f=0)
MaxEcdf <- HistToEcdf(h, f=1)
a <- head(knots(MaxEcdf), -1)
b <- tail(knots(MaxEcdf), -1)
mu <- h$means
for (i in 1:length(a)) {

}

    x <- c(a[i], mu[i], b[i], b[i], mu[i], a[i], a[i])
    y <- c(MinEcdf(a[i]) + c.many[i]/h.sum,
           MinEcdf(b[i]),
           MinEcdf(b[i]),
           MinEcdf(a[i]) + c.many[i]/h.sum,
           MinEcdf(a[i]),
           MinEcdf(a[i]),
           MinEcdf(a[i]) + c.many[i]/h.sum
           )
    polygon(x, y, col="yellow")
  }

f <- function(a) a*log(1/a) + (1-a)*log(1/(1-a))

poly.hist <- basic.hist
poly.hist$means <- basic.means
class(poly.hist) <- c("histogram", "polynomial.histogram")



PlotEMDCCUsingAnnotations <- function(h, main=paste("EMDCC =", EMDCC(h)), ...) {
  # Plot a CDF from the given histogram with a yellow boxes
  # covering all possible ranges for the e.c.d.f of the underlying
  # distribution from which the binned histogram was created.
  #
  # Args:
  #   h: An S3 histogram object.
  #   main: A title for the plot.
  #   ...: Additional arguments to pass to plot().

  stopifnot(inherits(h, "histogram"))
  h$sums <- h$counts * h$means
  h$sums[h$counts == 0] <- 0
  stopifnot(is.character(main), length(main) == 1)
  MinEcdf <- HistToEcdf(h, f=0)
  MaxEcdf <- HistToEcdf(h, f=1)
  plot(MaxEcdf, main=main, ...)
  # For each bin, we know the sum/mean and count, and bucket boundaries.
  # Use that to identify range of possible ECDF.
  #
  # If mean of bucket boundary is m, count is c, and boudaries are a,b.
  # what is range of ecdf for that range?
  #
  # Consider the case where all data points are on the boundaries a,b.
  # then some number are on a, and some number on b to get us to a mean of m.

  a <- head(knots(MaxEcdf), -1)
  b <- tail(knots(MaxEcdf), -1)
  mu <- h$means
  c.many <- h$counts * (mu - b) / (a - b)
  c.many[is.nan(c.many)]<-0
  mu[is.nan(mu)]<-0
  for (i in 1:length(a)) {
    x <- c(a[i], mu[i], b[i], b[i], mu[i], a[i], a[i])
    y <- c(MinEcdf(a[i]) + c.many[i]/h.sum,
           MinEcdf(b[i]),
           MinEcdf(b[i]),
           MinEcdf(a[i]) + c.many[i]/h.sum,
           MinEcdf(a[i]),
           MinEcdf(a[i]),
           MinEcdf(a[i]) + c.many[i]/h.sum
           )
    polygon(x, y, col="yellow")
  }
}


#### Area of uncertainty of true ECDF with mean and hist. ####
#
# Tim's unshaded version:
# plot(function(x, mu = .9) ifelse(x < mu, (1-mu) / (1-x), 1 - mu/x), ylim=0:1)
#

# Now lets make a bunch of polygons filling in this area.

upperLimit <- function(x, mu=.9) ifelse(x < mu, (1-mu) / (1-x), 1)
lowerLimit <- function(x, mu=.9) ifelse(x < mu, 0, 1 - mu/x)

DrawBox <- function(x1, x2) {
  x <- c(x1, x1, x2, x2)
  y <- c(lowerLimit(x1), upperLimit(x1), upperLimit(x2), lowerLimit(x2))
  polygon(x, y, border=NA, col="yellow")
}

par(mfrow=c(1,1))
# png("polyhistemdcc.png")

PlotPolyEMDCCBucket <- function(mu, step=0.05) {
  # mu here is between 0 and 1, so its alpha in the formula.
  poly.EMDCC <- mu * log(1/mu) + (1-mu)*log(1/(1-mu))
  plot(function(x, mu = .9) ifelse(x < mu, (1-mu) / (1-x), 1 - mu/x), ylim=0:1,
       main=paste("Bucket with mean"),
       ylab="Fn(x)")
  steps <- seq(0,1,by=step)
  invisible(lapply(seq(length(steps)-1), function(x) DrawBox(steps[x], steps[x+1])))
  # Make it look like PlotEMDCC
  abline(h=1, lty=2, col="grey")
  abline(h=0, lty=2, col="grey")
}

# png("polyhistemdcc.png", width=800, height=400)
pdf("figures/polyhistemdcc.pdf", width=7, height=2.2)
par(mar=c(3,4,1,0.5))
par(mfrow=c(1,2))
PE(h, main=paste("Bisected Bucket"))
legend(-.1, 0.8, paste("EMDCC =", EMDCC(h)), box.lty=0)
# text(0,.8, paste("EMDCC =", EMDCC(h)))

PlotPolyEMDCCBucket(x.mean, step=.01)
mu <- x.mean
poly.EMDCC <- mu * log(1/mu) + (1-mu)*log(1/(1-mu))
legend(-.1, 0.8, paste("EMDCC =", format(poly.EMDCC, digits=2)), box.lty=0)
dev.off()
system("pdfcrop polyhistemdcc.pdf")


# Make our

#####################

# Now lets make it side by side though with bisected bin plot showing EMDCC.
set.seed(0)
x<-rbeta(10^4, 0.5, 0.05)
range(x)
x.mean <- mean(x)
h <- hist(x, breaks=c(0,0.5,1))


PE(h)

PE <- function (h, main = paste("EMDCC =", EMDCC(h)), limit.range=TRUE, ...)
{
    stopifnot(inherits(h, "histogram"))
    stopifnot(is.character(main), length(main) == 1)
    MinEcdf <- HistToEcdf(h, f = 0)
    MaxEcdf <- HistToEcdf(h, f = 1)
    if (limit.range) {
      plot(MaxEcdf, main = main, xlim=range(knots(MinEcdf)), ...)
    } else {
      plot(MaxEcdf, main = main, ...)
    }
    rect(head(knots(MinEcdf), -1), MinEcdf(head(knots(MinEcdf),
        -1)), tail(knots(MinEcdf), -1), MaxEcdf(tail(knots(MinEcdf),
        -1)), col = "yellow")
}
###

select size,count,cell from storageanalytics.cfsfilesizesbyowner2.20130114  order by count desc limit 10;
