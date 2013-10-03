\name{NEWS}
\title{News for Package \pkg{HistogramTools}}
\newcommand{\cpkg}{\href{http://CRAN.R-project.org/package=#1}{\pkg{#1}}}

\section{Changes in HistogramTools version 0.2 (2013-10-02)}{
  \itemize{
    \item Moved 'RProtoBuf' from Suggests to Enhances and made all uses
     conditional so that this package can be built and checked without
     it.
     \item Improved plot titles for PlotKSDCC and PlotEMDCC.
     \item Added a quick reference vignette.
     \item Implemented support for smoothing out a histogram with
     Average Shifted Histograms from the ash package.
     \item Added \code{PlotLog2ByteEcdf} and
       \code{PlotLogTimeDurationEcdf} function for creating better
       looking Ecdfs of data binned on power of 2 byte boundaries and
       log-scale time duration boundaries.
     \item Remove unused methods dependency and tighten up what we
       import and export in the NAMESPACE file.
  }
}
\section{Changes in HistogramTools version 0.1 (2013-09-13)}{
  \itemize{
    \item Initial CRAN release
  }
}
