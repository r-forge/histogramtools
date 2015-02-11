library(HistogramTools)
InitGoogle()
set.seed(0)

# This code generates the example histogram plots showing information
# loss with our EMDCC metric.

x <- rexp(100)
h1 <- hist(x, plot=FALSE)
h2 <- hist(x, breaks=seq(0,round(max(x) + 1),by=0.1), plot=FALSE)

#plot(sort(x), main="sort(x)")
#pdf("figures/exhists.pdf", width=5, height=2.8)
pdf("figures/exhists.pdf", width=5, height=1.8)
par("las"=0)
par(mfrow=c(1,2))
#par(mfrow=c(2,2))
# bottom left top right
#par(mar=c(3,4,1,1))
#par(mar=c(2,4,2,1))
par(oma=c(0,0,0,0))
par(mar=c(3,3,1,0.2))
par(mgp=c(2,0.7,0))
#plot(h1, main="", xlim=c(0,6), xaxt="n", las=1)
plot(h1, main="", xlim=c(0,6), las=1, xlab="")
#axis(1, at=0:6, labels=FALSE)
#mtext("Histogram", font=par("font.main"), las=0)
#PlotKSDCC(h1, 0.2, main="CDF with KSDCC")
#par(mar=c(1,3,1,0.2))
PE(h1, main="", xlim=c(0,6), xlab="", las=1)
#mtext("CDF with EMDCC", font=par("font.main"), las=0)
axis(1, at=0:6, labels=FALSE)
legend("bottomright", paste("EMDCC =", format(EMDCC(h1), digits=2)), box.lty=0)
dev.off()
system("pdfcrop exhists.pdf")


#pdf("figures/exhists2.pdf", width=5, height=1.25)
#par(mfrow=c(1,2))
#par(oma=c(0,0,0,0))
par(mar=c(3,3,1,0.2))
#plot(sort(x), main="sort(x)")
plot(h2, main="Histogram 2", xlab="", las=1)
#PlotKSDCC(h2, 0.2, main="CDF with KSDCC")
PE(h2, main="CDF with EMDCC", xlab="", las=1)
legend("bottomright", paste("EMDCC =", format(EMDCC(h2), digits=2)), box.lty=0)
dev.off()
system("pdfcrop exhists.pdf")

#system("pdfcrop exhists2.pdf")

PE <- function (h, main = paste("EMDCC =", EMDCC(h)), ...)
{
    stopifnot(inherits(h, "histogram"))
    stopifnot(is.character(main), length(main) == 1)
    MinEcdf <- HistToEcdf(h, f = 0)
    MaxEcdf <- HistToEcdf(h, f = 1)
    plot(MaxEcdf, main = main, ...)
    rect(head(knots(MinEcdf), -1), MinEcdf(head(knots(MinEcdf),
        -1)), tail(knots(MinEcdf), -1), MaxEcdf(tail(knots(MinEcdf),
        -1)), col = "yellow")
             #        -1)), col = "yellow", border=NA)
}
