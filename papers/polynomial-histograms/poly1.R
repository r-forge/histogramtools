# This file defines functions:
#   SingleBinXDensity
#   plot.SingleBinXDensity
#   print.SingleBinXDensity
#   SingleBinBounds
#   EMD1
# and creates two figures:
#   densities.pdf  (worst-case distributions for various mu and mu2)
#   bounds.pdf     (upper and lower bounds vs x, for four mu & mu2 combos)

SingleBinXDensity <- function(x, mu, mu2 = NULL) {
  # Calculate optimum (maximum EMD) distribution for one bin, at a single x
  # Args:
  #   x: value between 0 and 1
  #   mu: value between 0 and 1, mean for this bin
  #   mu2: value between mu^2 and mu, second moment for this bin
  # Returns:
  #   list with class "SingleBinXDensity", with components:
  #     x: values
  #     y: probabilities
  #     names: names, a subset of "0", "x", "mu", "1"
  #     ... (other components like mu, mu2)
  stopifnot(length(x) == 1, length(mu) == 1, length(mu2) <= 1,
            x >= 0, x <= 1, mu >= 0, mu <= 1)
  if(!is.null(mu2))
    stopifnot(mu2 >= mu^2, mu2 <= mu)
  lambda <- NULL

  if(is.null(mu2)) {
    if(x == mu) {
      ret <- list(x = x, y = 1, names = "x")
    } else if(x <= mu) { # Case 1
      p1 <- (1-mu) / (1-x)
      ret <- list(x = c(x, 1), y = c(p1, 1-p1),
                  names <- c("x", "1"))
      mu2 <- p1 * x^2 + 1 - p1
    } else { # Case 2
      p2 <- mu / x
      ret <- list(x = c(0, x), y = c(1 - p2, p2), names = c("0", "x"))
      mu2 <- p2 * x^2
    }
  } else {
    sigma2 <- mu2 - mu^2
    c1 <- mu - sigma2 / (1-mu)
    c2 <- mu + sigma2 / mu
    if(x < c1 || x > c2) { # Case 3, sigma2 < sigma^2*
      a <- mu + sigma2 / (mu - x)
      p3 <- sigma2 / (sigma2 + (x - mu)^2)
      ret <- list(x = c(a, x), y = c(1-p3, p3), names = c("a", "x"))
    } else { # Case 4, sigma2 >= sigma^2*
      p4 <- (mu - mu2) / (x - x^2)
      f1 <- mu - x * p4
      ret <- list(x = c(0, x, 1),
                  y = c(1 - p4 - f1, p4, f1),
                  names = c("0", "x", "1"))
    }
  }
  if(any(ret$y == 0)) {
    warning("unexpected y = 0")
    k <- which(ret$y == 0)
    ret <- lapply(ret, function(x) x[-k])
  }
  ret <- c(ret,
           list(mu = mu,
                mu2 = mu2))
  class(ret) <- "SingleBinXDensity"
  return(ret)
}


plot.SingleBinXDensity <-
  function(x, ..., xlim = c(0, 1), ylim = c(0, 1),
           xlab = "Values", ylab = "Probability") {
  plot(x$x, x$y, ..., xlim = xlim, ylim = ylim, xlab = xlab, ylab = ylab)
  segments(x$x, x$y, y1 = 0 * x$y)
  invisible(NULL)
}

print.SingleBinXDensity <- function(x, ...) {
  cat("Values:\n")
  print(data.frame(x = x$x, p = x$y, row.names = x$names))
  cat("mu:", x$mu, "  mu2:", x$mu2, "\n")
  invisible(x)
}


if(FALSE) {
  moments <- function(x) {
    # Use this function to check correctness
    with(x, c(mu = sum(x * y), mu2 = sum(x^2 * y)))
  }

  temp <- SingleBinXDensity(.4, .7)
  plot(temp)
  temp # mu2 = .58
  moments(temp)
  temp <- SingleBinXDensity(.2, .7)
  plot(temp)
  temp
  # mu2 = .64

  # small-variance case
  temp <- SingleBinXDensity(.2, .7, .54)
  plot(temp)
  temp
  moments(temp)

  # large-variance case
  temp <- SingleBinXDensity(.2, .7, .67)
  plot(temp)
  temp
  moments(temp)
}

if(FALSE) { # Do a grid of plots. single x = .6, columns mu, rows mu2
pdf("figures/densities.pdf")
par(mfcol = c(6, 3), mar = c(2.6, 2.6, .1, .1), mex = .5, cex = .5)
x <- .6
for(mu in c(0, 2, 4, 6, 8, 10)/10) {
  plot(SingleBinXDensity(x, mu), axes = FALSE, xlab = "", ylab = "")
  box()
  axis(side = 2)
  axis(side = 1, at = c(mu, x), c(expression(mu), expression(x)))
  if(mu == 0)
    legend("topright", c("x = .6",
                        expression(paste(mu, " increasing ")),
                         expression(paste(mu[2], " unknown "))))
}
# x = .6, mu = .80, mu2 from min to mu2star
mu <- .8
temp <- SingleBinXDensity(x, mu)$mu2
for(mu2 in seq(from = mu^2, to = temp, length = 6)) {
  plot(SingleBinXDensity(x, mu, mu2), axes = FALSE, xlab = "", ylab = "")
  box()
  axis(side = 1, at = c(mu, x), c(expression(mu), expression(x)))
  if(mu2 == mu^2)
    legend("topleft", c("x = .6",
                        expression(paste(mu, " = .8")),
                        expression(paste(mu[2], " increasing"))))
}
# mu2 from mu2star to max
for(mu2 in seq(from = temp, to = mu, length = 6)) {
  plot(SingleBinXDensity(x, mu, mu2), axes = FALSE, xlab = "", ylab = "")
  box()
  axis(side = 1, at = c(mu, x), c(expression(mu), expression(x)))
  if(mu2 == temp)
    legend("topleft", c("x = .6",
                        expression(paste(mu, " = .8")),
                        expression(paste(mu[2], " increasing"))))
}
dev.off()
}




if(FALSE) { # Do a grid of plots (I don't like this one as well)
  # In each column, x varies
par(mfcol = c(6, 3), mar = c(2.6, 2.6, .1, .1), mex = .5, cex = .5)
for(x in c(0, 2, 4, 6, 8, 10)/10) {
  plot(SingleBinXDensity(x, .6), axes = FALSE, xlab = "", ylab = "")
  box()
  axis(side = 2)
  axis(side = 1, at = c(.6, x), c(expression(mu), expression(x)))
  if(x == 0)
    legend("topleft", expression(paste(mu, " = .6")))
}
# mu = .40, relatively small, all but mu=.6 are in the small var case
for(x in c(0, 2, 4, 6, 8, 10)/10) {
  plot(SingleBinXDensity(x, .6, .40), axes = FALSE, xlab = "", ylab = "")
  box()
  axis(side = 1, at = c(.6, x), c(expression(mu), expression(x)))
  if(x == 0)
    legend("topleft", c(expression(paste(mu, " = .6")),
                        expression(paste(mu[2], " = .4"))))
}
# mu = .58, relatively large, only the two extreme are in the small var case
for(x in c(0, 2, 4, 6, 8, 10)/10) {
  plot(SingleBinXDensity(x, .6, .58), axes = FALSE, xlab = "", ylab = "")
  box()
  axis(side = 1, at = c(.6, x), c(expression(mu), expression(x)))
  if(x == 0)
    legend("topleft", c(expression(paste(mu, " = .6")),
                        expression(paste(mu[2], " = .58"))))
}
}

SingleBinBounds <- function(x, mu, mu2 = NULL) {
  # Calculate upper and lower bound curves for one bin
  # Args:
  #   x: vector, values between 0 and 1
  #   mu: value between 0 and 1, mean for this bin
  #   mu2: value between mu^2 and mu, second moment for this bin
  # Returns:
  #   dataframe with columns
  #     x: values
  #     px: f(x) at x (difference between lower and upper)
  #     lower: lower bound
  #     upper: upper bound
  stopifnot(length(mu) == 1, length(mu2) <= 1,
            min(x) >= 0, max(x) <= 1, mu >= 0, mu <= 1)
  if(!is.null(mu2))
    stopifnot(mu2 >= mu^2, mu2 <= mu)

  # Values below, for the four cases

  if(is.null(mu2)) {
    case1 <- (x <= mu)
    p1 <- (1-mu) / (1-x)
    p2 <- mu / x
    px <- ifelse(case1, p1, p2)
    lower <- ifelse(case1, 0, 1 - p2)
    upper <- ifelse(case1, p1, 1)
    px <- ifelse(case1, p1, p2)
  } else {
    sigma2 <- mu2 - mu^2
    c1 <- mu - sigma2 / (1-mu)
    c2 <- mu + sigma2 / mu
    case3 <- (x < c1 | x > c2)
    p3 <- sigma2 / (sigma2 + (x - mu)^2)
    p4 <- (mu - mu2) / (x - x^2)
    f1 <- mu - x * p4
    lower <- ifelse(case3,
                    (x > mu) * (1-p3),
                    1 - p4 - f1)
    upper <- lower + ifelse(case3, p3, p4)
    px <- ifelse(case3, p3, p4)
  }
  return(data.frame(x, px, lower, upper))
}

if(FALSE) {
temp1 <- SingleBinBounds(0:100/100, mu = .7)
with(temp1, all.equal(upper - lower, px))
with(temp1, plot(x, px, type = "l"))
with(temp1, plot(x, lower, type = "l", ylim = 0:1))
with(temp1, lines(x, upper))

# with mu = .7, bounds for mu2 are .49 <= mu2 <= .7

# Moderate mu2
temp2 <- SingleBinBounds(0:100/100, mu = .7, mu2 = .56)
with(temp2, all.equal(upper - lower, px)) # no
with(temp2, plot(x, px, type = "l"))
with(temp2, plot(x, lower, type = "l", ylim = 0:1))
with(temp2, lines(x, upper))

# mu2 near lower bound; mass must be near the mean
temp3 <- SingleBinBounds(0:100/100, mu = .7, mu2 = .50)
with(temp3, all.equal(upper - lower, px)) # no
with(temp3, plot(x, px, type = "l"))
with(temp3, plot(x, lower, type = "l", ylim = 0:1))
with(temp3, lines(x, upper))

# mu2 near upper bound; mass must be near 0 and 1
temp4 <- SingleBinBounds(0:100/100, mu = .7, mu2 = .69)
with(temp4, all.equal(upper - lower, px)) # no
with(temp4, plot(x, px, type = "l"))
with(temp4, plot(x, lower, type = "l", ylim = 0:1))
with(temp4, lines(x, upper))


# A figure that combines all of those.
# (Though we may want to do a 2x2 grid of figures instead)
with(temp1, plot(x, lower, type = "l", ylim = 0:1,
                 main = "Lower and Upper Bounds for F"))
with(temp1, lines(x, upper))
with(temp2, lines(x, lower, col=2))
with(temp2, lines(x, upper, col=2))
with(temp3, lines(x, lower, col=3))
with(temp3, lines(x, upper, col=3))
with(temp4, lines(x, lower, col=4))
with(temp4, lines(x, upper, col=4))
legend("topleft", lty = 1, col = 1:4,
       c("var unknown",
         "moderate var",
         "small var",
         "large var"))
}


if(FALSE) { # Do Figure
# Repeat, but make sure that x includes bends,
# and a bit farther from min and max mu2
pdf("figures/bounds.pdf")
mu <- .7
mu2 <- c(.51, .59, .68)
tempSigma2 <- mu2 - mu^2
temp <- list(0:100/100, # that includes mu
             # .7, # mu for sigma unknown
             c1 = mu - tempSigma2 / (1 - mu),
             c2 = mu + tempSigma2 / mu)
xx <- sort(unique(unlist(temp)))
temp1 <- SingleBinBounds(xx, mu = mu)
temp2 <- SingleBinBounds(xx, mu = mu, mu2 = mu2[1])
temp3 <- SingleBinBounds(xx, mu = mu, mu2 = mu2[2])
temp4 <- SingleBinBounds(xx, mu = mu, mu2 = mu2[3])
with(temp1, plot(x, lower, type = "l", ylim = 0:1,
                 main = "Lower and Upper Bounds for F"))
with(temp1, lines(x, upper))
with(temp2, lines(x, lower, col=2))
with(temp2, lines(x, upper, col=2))
with(temp3, lines(x, lower, col=3))
with(temp3, lines(x, upper, col=3))
with(temp4, lines(x, lower, col=4))
with(temp4, lines(x, upper, col=4))
legend("topleft", lty = 1, col = 1:4,
       c("var unknown",
         "small var",
         "moderate var",
         "large var"))
dev.off()
}


EMD1 <- function(mu, mu2 = NA) {
  # Earth Mover's Distance for one bin, for scalar mu and mu2
  # Args:
  #   mu: scalar
  #   mu2: either NULL, or scalar with mu^ <= mu2 <= mu
  if(is.na(mu2)) {
    # int_0^mu (1 - mu) / (1 - x) -> -(1-mu) log(1-x) |_0^mu
    # int_mu^1 mu / x             -> mu log(x)        |_mu^1
    return(-(1 - mu) * log(1 - mu) + - mu * log(mu))
  }
  sigma2 <- mu2 - mu^2
  sigma <- sqrt(sigma2)
  c1 <- mu - sigma2 / (1-mu)
  c2 <- mu + sigma2 / mu
  case3 <- (x < c1 | x > c2)
  # p3 <- sigma2 / (sigma2 + (x - mu)^2)
  # p4 <- (mu - mu2) / (x - x^2)
  P3 <- function(x) sigma * atan((x-mu)/sigma)
  P4 <- function(x) (mu - mu2) * log(x/(1-x))
  return(P3(c1) - P3(0) + P4(c2) - P4(c1) + P3(1) - P3(c2))
}


EMD1(.7)
mean(SingleBinBounds(ppoints(200), mu = .7)$px)
# close

# .49 <= mu2 <= .7
EMD1(.7, .50)
mean(SingleBinBounds(ppoints(200), mu = .7, mu2 = .50)$px)

EMD1(.7, .6)
mean(SingleBinBounds(ppoints(200), mu = .7, mu2 = .6)$px)

EMD1(.7, .69)
mean(SingleBinBounds(ppoints(200), mu = .7, mu2 = .69)$px)
# close
