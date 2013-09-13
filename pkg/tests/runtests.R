# Simplest possible RUnit boilerplate for now.

library(c("RUnit", "HistogramTools"))

# Make the test deterministic - we use a lot of randomly created histograms.
set.seed(0)
path <- system.file("unitTests", package = "HistogramTools")

# Define tests
testSuite <- defineTestSuite(
  name="HistogramTools Unit Tests",
  dirs=system.file("unitTests", package = "HistogramTools"),
  testFuncRegexp = "^[Tt]est.+")

tests <- runTestSuite(testSuite)

# Print results
printTextProtocol(tests)

if(getErrors(tests)$nFail > 0) {
  stop("one of the unit tests failed")
}
