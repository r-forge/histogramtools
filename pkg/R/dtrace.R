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

#foo <- ReadHistogramsFromDtraceOutputFile("~/dtrace-read-hist-outs")
ReadHistogramsFromDtraceOutputFile <- function(filename) {
  stopifnot(is.character(filename), length(filename) == 1)
  stopifnot(file.exists(filename))
  dtrace.text <- readLines(filename)
  dividers <- grepl("--- Distribution ---", dtrace.text)

  # lengths for each
  lengths <- diff(c(which(dividers), length(dtrace.text)))

  # Subtract one so we pick up the binary label before the
  hist.indices <- data.frame(start=(which(dividers)-1), length=(lengths-1))

  myh <- sapply(1:nrow(hist.indices), function(x) {
    dtrace.text[hist.indices[x,]$start:(hist.indices[x,]$start +
                                        hist.indices[x,]$length)] })

  myhists <- lapply(myh, BuildSingleHistogramFromDtraceOutput)
  return(myhists)
}

BuildSingleHistogramFromDtraceOutput <- function(textlines) {
  stopifnot(is.character(textlines), length(textlines) > 3)
  stopifnot(grepl("-- Distribution --", textlines[2]))
  textlines <- textlines[textlines != ""]
  title <- textlines[1]
  headerline <- textlines[2]
  value.rightoffset <- regexpr("value", headerline, fixed=T)[1] + nchar("value")
  count.leftoffset <- regexpr("count", headerline, fixed=T)[1]
  bins <- unname(sapply(textlines[3:length(textlines)], function(x) as.numeric(sub("(^.*)\\|.*", "\\1", x))))
  counts <- unname(sapply(textlines[3:length(textlines)], function(x) as.numeric(sub("^.{59}(.*)", "\\1", x))))

  hist <- list()
  hist$breaks <- bins
  hist$counts <- head(counts, -1)  # remove the last bin, always 0.
  hist$density <- hist$counts / (sum(hist$counts) * diff(hist$breaks))
  hist$mids <- (head(hist$breaks, -1) + tail(hist$breaks, -1)) / 2
  hist$xname <- title
  hist$equidist <- all.equal(diff(hist$breaks),
                             rep(diff(hist$breaks)[1],
                                 length(hist$breaks) - 1))
  class(hist) <- "histogram"
  return(hist)
}
