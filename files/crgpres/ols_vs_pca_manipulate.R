library(MASS)
library(mixtools)
library(manipulate)
par(mfrow=c(1,1))
set.seed(12345)

p<-mvrnorm(1000,c(0,0),Sigma=matrix(c(1,.3,.3,1),2,2))
X<-p[,1];Y<-p[,2];
ypred <- predict(lm(Y~X))
xpred <- predict(lm(X~Y))

# Calculate PCA regression line
v <- prcomp(cbind(X,Y))$rotation
beta.p <- v[2,1]/v[1,1]
int.p <- mean(Y)-mean(X)*beta.p

manipulate(
{
  plot(x=X,y=Y,xlim=c(min(p),max(p)),ylim=c(min(p),max(p)), pch=20, xlab="X", ylab="Y")
ellipse(mu=c(0,0), sigma=matrix(c(1,.3,.3,1),2,2), alpha = .05, npoints = 250, col="red") 
legend(x="bottomright",lty=c(1,1),lwd=c(2,2),col=c("purple","orange"),
       legend=c(expression(paste(hat(Y),"= b0+ b1*X")),expression(paste(hat(X),"= a0 + a1*Y"))))

if(predict=="y~x"){
abline(lm(Y~X), col="purple",lwd=2)
  if(residual=="TRUE"){
    segments(X,Y,X,ypred)
    }
  }
if(predict=="x~y"){
points(x=xpred,y=Y,type="l",col="orange",lwd=2)
  if(residual=="TRUE"){
    segments(X,Y,xpred,Y)}
  }
if(predict=="both"){
  abline(lm(Y~X), col="purple",lwd=2)
  points(x=xpred,y=Y,type="l",col="orange",lwd=2)}

if(pcaline=="TRUE"){
  abline(a=int.p,b=beta.p,col="green",lwd=2)
}
},
predict=picker("y~x","x~y","both","neither",initial="neither"),
residual=picker("TRUE","FALSE",initial="FALSE"),
pcaline=picker("TRUE","FALSE",initial="FALSE")
)


