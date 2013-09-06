% Copyright 2013 Google Inc. All Rights Reserved.
%
% Licensed under the Apache License, Version 2.0 (the "License");
% you may not use this file except in compliance with the License.
% You may obtain a copy of the License at
%
%     http://www.apache.org/licenses/LICENSE-2.0
%
% Unless required by applicable law or agreed to in writing, software
% distributed under the License is distributed on an "AS IS" BASIS,
% WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
% See the License for the specific language governing permissions and
% limitations under the License.
%
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
\value{
A list of histogram objects representing the histograms present in the
Dtrace output file.
}
\author{Murray Stokely \email{mstokely@google.com}}
\seealso{
\code{\link{histogramtools-package}},
\code{\link[graphics]{hist}}.
}
\examples{
\dontrun{
system("dtrace -n 'syscall::read:return { @[execname] = quantize(arg0);}> /tmp/dtraceoutput'",
  intern=TRUE)
system.readsize.hists <- ReadHistogramsFromDtraceOutputFile("/tmp/dtraceoutput")
plot(system.readsize.hists[[1]])
}
}
\keyword{manip}
\keyword{utilities}
\keyword{datagen}
