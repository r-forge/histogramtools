if(require("RUnit", quietly = TRUE)) {
  pkg <- "HistogramTools"
  require( pkg, character.only=TRUE)
  path <- system.file("unitTests", package = pkg)
  stopifnot(file.exists(path), file.info(path.expand(path))$isdir)
  source(file.path(path, "runTests.R"), echo = TRUE)
}
