# Copyright 2011 Google Inc. All Rights Reserved.
# Author: mstokely@google.com (Murray Stokely)

.onLoad <- function(lib, pkg) {
  ## Automatically load shared libraries
  if (require(RProtoBuf)) {
    readProtoFiles(package="HistogramTools")
  }
}
