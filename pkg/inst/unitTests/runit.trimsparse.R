# Copyright 2012 Google Inc. All Rights Reserved.
# Author: mstokely@google.com (Murray Stokely)

TestTrimHistogram <- function() {
  hist.1 <- hist(c(1,2,3), breaks=c(0,1,2,3,4,5,6,7,8,9), plot=FALSE)
  hist.trimmed <- TrimHistogram(hist.1)
  # All non-zero elements still accounted for.
  checkTrue(sum(hist.1$counts) == sum(hist.trimmed$counts))
  # But fewer buckets:
  checkTrue(length(hist.1$counts) > length(hist.trimmed$counts))

  # Now try with a bigger histogram proto with the RLE sparse buckets at end.
  example.file <- file(GetResourceFilename(
      "google3/analysis/common/r/ghistogram/test/examplemessage2.ascii"))
  file.age.proto <- readASCII(stats.HistogramState, example.file)
  age.hist <- as.histogram(file.age.proto)
  checkEquals(length(age.hist$counts), 4381)
  checkEquals(length(TrimHistogram(age.hist, right=FALSE)$counts), 4381)
  checkEquals(length(TrimHistogram(age.hist)$counts), 308)

  zero.hist <- hist(numeric(), breaks=c(0,1,2,3,4,5,6,7,8,9), plot=FALSE)
  zero.trimmed <- TrimHistogram(zero.hist)
  # Don't do anything when all the buckets are empty.
  checkEquals(length(zero.hist$counts), length(zero.trimmed$counts))
}
