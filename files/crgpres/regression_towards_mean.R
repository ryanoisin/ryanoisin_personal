library(MASS)
library(mixtools)
library(manipulate)

set.seed(12345)
x<-mvrnorm(20000,c(0,0),Sigma=matrix(c(1,0,0,1),2,2))

par(mfrow=c(1,1))
plot(x,xlim=c(-3,3),ylim=c(-3,3), pch=20, xlab="X", ylab="Y",main="Bivariate distribution for uncorrelated variables")
ellipse(mu=colMeans(x), sigma=cov(x), alpha = .05, npoints = 250, col="red") 

par(mfrow=c(2,2))
manipulate(
{plot(x,xlim=c(-3,3),ylim=c(-3,3), pch=20, xlab="X", ylab="Y")
abline(v=cutoff,col="blue")
ellipse(mu=colMeans(x), sigma=cov(x), alpha = .05, npoints = 250, col="red") 
hist(x[,1],main=expression(paste("p(X)")),xlab="X",xlim=c(-3.5,3.5))
abline(v=cutoff,col="blue")
hist(x[,2],main=expression(paste("p(Y)")),xlab="Y",xlim=c(-3.5,3.5))
hist(subset(x,x[,1]> cutoff)[,2],main=paste("p(Y | X >", cutoff,")"),xlim=c(-3.5,3.5),xlab="Y")
abline(v=cutoff,col="blue")},
cutoff=slider(0,2.5,step=0.1,initial=0))

