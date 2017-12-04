source("Exercises/week9Util.R")

##################
### Question 1 ###
##################

library(ISLR)
data(Wage)
library(splines)

#Initialize parameters
k<-10; nDf <- 10; seed <- 1; cvErrs <- rep(NA,nDf) 

#Compute CV error for each degree of spline
for(df in 1:nDf){ # loop over df
  cvErrs[df] <- cv.lm(wage ~ ns(age,df),Wage,k,seed)$meanErr
}

#Plot errors
plot(1:nDf,cvErrs,type="b",ylab="MSE",xlab="DF for natural spline") 

##################
### Question 2 ###
##################

#Compute errors and uncertainty
cvDat <- matrix(NA,nrow=nDf,ncol=4)
for(df in 1:nDf) {
  res <- cv.lm(wage ~ ns(age,df),Wage,k,seed)
  merr <- res$meanErr; serr <- res$sdErr
  cvDat[df,] <- c(df,merr,merr-serr,merr+serr)
}
colnames(cvDat) <- c("df","meanErr","lwr","upr")

#Plot errors with uncertainty
library(ggplot2)
dfs <- plot.cv.lm(cvDat)

#Fit the best model and plot predictions (with uncertainty)
fit <- lm(wage ~ ns(age,dfs$df.1se),data=Wage)
newdat <- data.frame(age=seq(from=min(Wage$age),to=max(Wage$age),length=100))
plotfitWage(fit,Wage,newdat)

##################
### Question 3 ###
##################

#Predict nox using dis

### Part a ###

#Run cv to choose the 'best' polynomial degree
cvDat.lm <- matrix(NA,nrow=nDf,ncol=4)
for(df in 1:nDf) {
  res <- cv.lm(dis ~ poly(nox,df),Boston,k,seed)
  merr <- res$meanErr; serr <- res$sdErr
  cvDat.lm[df,] <- c(df,merr,merr-serr,merr+serr)
}
colnames(cvDat.lm) <- c("df","meanErr","lwr","upr")

#Plot results
dfs.lm <- plot.cv.lm(cvDat.lm)

#Fit and plot the best model
fit.lm <- lm(dis ~ poly(nox,dfs.lm$df.1se),data=Boston)
newdat <- data.frame(nox=seq(from=min(Boston$nox),to=max(Boston$nox),length=100))
plotfitBoston(fit.lm,Boston,newdat)

### Part b ###

#Run cv to choose the 'best' spline degree
cvDat.spl <- matrix(NA,nrow=nDf,ncol=4)
for(df in 1:nDf) {
  res <- cv.lm(dis ~ ns(nox,df),Boston,k,seed)
  merr <- res$meanErr; serr <- res$sdErr
  cvDat.spl[df,] <- c(df,merr,merr-serr,merr+serr)
}
colnames(cvDat.spl) <- c("df","meanErr","lwr","upr")

#Plot results
dfs.spl <- plot.cv.lm(cvDat.spl)

#Fit and plot the best model
fit.spl <- lm(dis ~ ns(nox,dfs.spl$df.1se),data=Boston)
newdat <- data.frame(nox=seq(from=min(Boston$nox),to=max(Boston$nox),length=100))
plotfitBoston(fit.spl,Boston,newdat)

### Part c ###

#Fit and plot a smoothing spline
ss <- smooth.spline(Boston$nox,Boston$dis,cv=TRUE)
ssdat <- data.frame(nox=ss$x,dis=ss$y)
ggplot(Boston,aes(x=nox,y=dis)) + geom_point() +
  geom_line(data=ssdat,col="blue")


### Part d ###

