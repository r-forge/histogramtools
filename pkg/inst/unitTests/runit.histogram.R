# Copyright 2011 Google Inc. All Rights Reserved.
# Author: mstokely@google.com (Murray Stokely)

TestAdsHistogramProto <- function() {
  two.histogram <- new(P("ads_branding.HistogramProto"),
                       entry = list(
                         new(P("ads_branding.HistogramProto.Entry"),
                             limit = 0.0,
                             value = 7.77841e+06),
                         new(P("ads_branding.HistogramProto.Entry"),
                             limit = 1.0,
                             value = 1.3809e+07)),
                       total_activity = 21587410)
  hist.from.proto <- as.histogram(two.histogram)
  checkEquals(sum(hist.from.proto$counts), 21587410)
  checkEquals(sum(hist.from.proto$counts), two.histogram$total_activity)

  zero.histogram <- new(P("ads_branding.HistogramProto"))
  checkException(as.histogram(zero.histogram))
  one.histogram <- new(P("ads_branding.HistogramProto"),
                       entry = list(
                         new(P("ads_branding.HistogramProto.Entry"),
                             limit = 10.0,
                             value = 13.4)),
                       total_activity = 21587412)
  checkEquals(sum(as.histogram(one.histogram)$counts), 13.4)
}

TextExampleTextDistributionProto <- function() {
  proto.text <- c(" count: 35487 ",
                  " mean: 28440.076192833087 ",
                  " sum_of_squared_deviation: 1.3259264452959058e+17 ",
                  " bucket: -4 ",
                  " bucket: 1 ",
                  " bucket: 4307 ",
                  " bucket: 8911 ",
                  " bucket: 17101 ",
                  " bucket: 4620 ",
                  " bucket: 531 ",
                  " bucket: 10 ",
                  " bucket: 1 ",
                  " bucket: 1 ",
                  " bucket: 1 ",
                  " bucket: 2 ",
                  " bucket: 1 ",
                  " max_buckets: 17 ",
                  " growth_factor: 4 ")
  proto.text <- paste(proto.text, collapse="\n")
  example.proto <- readASCII(monitoring.streamz.DistributionProto, proto.text)

  hist.from.proto <- as.histogram(example.proto)

  rawdata <- rep(c(160, 640, 2560, 10240, 40960, 163840,
                   655360, 2621440, 10485760, 41943040, 167772160, 671088640,
                   2684354560),
                 c(1, 4307, 8911, 17101, 4620, 531, 10, 1, 1, 1, 2, 1, 0))

  thebreaks <- c(0, 1, 4, 16, 64, 256, 1024, 4096, 16384, 65536, 262144,
                 1048576, 4194304, 16777216, 67108864, 268435456, 1073741824,
                 4294967296)

  hist.from.r <- hist(rawdata, breaks=thebreaks, plot=FALSE)

  # Should be the same.
  checkTrue(all(hist.from.proto$breaks == hist.from.r$breaks))
  checkTrue(all(hist.from.proto$counts == hist.from.r$counts))
  checkTrue(all(hist.from.proto$density == hist.from.r$density))
}

TestExampleTextHistogramProto <- function() {
  example.file <- file(GetResourceFilename(
    "google3/analysis/common/r/ghistogram/test/examplemessage.ascii"))
  file.age.proto <- readASCII(stats.HistogramState, example.file)

  age.hist <- as.histogram(file.age.proto)
  # Each break is 14400 seconds apart
  checkEquals(diff(age.hist$breaks)[1], 14400)
  # All except the last break should be equidistant.
  # Since last break has to include max value because it is +Inf in histogram
  # protos, but must be set explicitly for histogram S3 objects.
  checkTrue(length(unique(diff(head(age.hist$breaks, -1)))) == 1)
  checkTrue("breaks" %in% names(age.hist))
  checkTrue("counts" %in% names(age.hist))
  checkTrue("mids" %in% names(age.hist))
  checkTrue("xname" %in% names(age.hist))
}

TestMergeHistograms <- function() {
  hist.1 <- hist(c(1, 2, 3, 4), plot=FALSE)
  hist.2 <- hist(c(1, 2, 2, 4), plot=FALSE)
  hist.merged <- merge(hist.1, hist.2)
  checkEquals(hist.merged$breaks, c(1, 2, 3, 4))
  checkEquals(hist.merged$counts, c(5, 1, 2))
}

TestDownsampleHistograms <- function() {
  hist.1 <- hist(c(1,2,3), breaks=c(0,1,2,3,4,5,6,7,8,9), plot=FALSE)
  hist.2 <- downsample(hist.1, adj=2)
  checkEquals(hist.2$breaks, c(0,2,4,6,8,9))
  checkEquals(hist.2$counts, c(2,1,0,0,0))

  hist.3 <- downsample(hist.1, breaks=3)
  checkEquals(hist.3$breaks, c(0,3,6,9))
  checkEquals(hist.3$counts, c(3,0,0))
}

TestIndempotence <- function() {
  .helperFromHist <- function(original) {
    roundtrip <- as.histogram(as.Message(original))
    checkEquals(original$breaks, roundtrip$breaks)
    checkEquals(original$counts, roundtrip$counts)
    checkEquals(original$mids, roundtrip$mids)
    checkEquals(original$density, roundtrip$density)
    # Name may change.
  }

  .helperFromMessage <- function(original) {
    roundtrip <- as.Message(as.histogram(original))
    checkEquals(original$buckets, roundtrip$buckets)
    checkEquals(original$max, roundtrip$max)
    checkEquals(original$min, roundtrip$min)
    # Name may change.
  }

  .helperFromHist(hist(c(1, 2, 3, 4), plot=FALSE))
  # Test negative boundaries, utilizing separate proto fields.
  .helperFromHist(hist(c(-200, 0, 100), plot=FALSE))
  .helperFromHist(hist(c(-200, 0, 0, 473773), plot=FALSE))
  .helperFromHist(hist(c(rep(48, 200), rep(500000, 200)), plot=FALSE))
  example.file <- file(GetResourceFilename(
      "google3/analysis/common/r/ghistogram/test/examplemessage.ascii"))
  file.age.proto <- readASCII(stats.HistogramState, example.file)

  .helperFromMessage(file.age.proto)
}
