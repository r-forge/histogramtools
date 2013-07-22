% Copyright 2013 Google Inc. All Rights Reserved.
% Author: mstokely@google.com (Murray Stokely)
\name{dtracehistograms}
\alias{dtrace}
\alias{ReadHistogramsFromDtraceOutputFile}
\title{Read Histograms from text DTrace output file.}
\description{
Parses the text output of the DTrace command to convert the ASCII
representation of aggregate distributions into R histogram objects.
}
\usage{
ReadHistogramsFromDtraceOutputFile(filename)
}
\arguments{
  \item{filename}{A character vector naming a file that is the output of
    dtrace with aggregate distribution statistics in it.}
}
\details{
  The DTrace dynamic tracing framework allows users to trace
  applications and computer operating systems.  One of its common
  outputs is aggregates of a distribution (for example, read request
  sizes) that are output as a histogram.  This function takes the text
  output from a dtrace command and looks for text distribution
  representations that can be parsed into R histogram objects.
}
\author{Murray Stokely \email{mstokely@google.com}}
\seealso{
\code{\link{histogram-package}}
\code{\link{hist}}
}
\examples{
\dontrun{
system("dtrace -n 'syscall::read:return { @[execname] = quantize(arg0);} > /tmp/dtraceoutput'", intern=TRUE)
system.readsize.hists <- ReadHistogramsFromDtraceOutputFile("/tmp/dtraceoutput")
plot(system.readsize.hists[[1]])
}
}
