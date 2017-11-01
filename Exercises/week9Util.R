# Generalization of the cv() function used in the 
# ch07part2 notes (page 16) to perform cross-validation 
# for a least-squares regression.
cv.lm <- function(form,data,k,seed) {
  # form is the formula for the regression
  # data is a data frame of data
  # k is the number of folds
  # seed is the random seed to use to break the data into folds
  set.seed(seed)
  folds <- sample(1:k,size=nrow(data),replace=TRUE) 
  validErr <- rep(NA,k)
  for(i in 1:k) {
    testdat <- data[folds==i,]
    traindat <- data[folds!=i,]
    fit <- lm(form,data=traindat) 
    testPreds <- predict(fit,testdat)
    testY <- model.response((model.frame(form,testdat)))
    validErr[i] <- mean((testPreds - testY)^2) 
  }
  out <- list(meanErr = mean(validErr),
              sdErr = sd(validErr)/sqrt(k)) 
}

plot.cv.lm <- function(cvDat) {
  if(!is.data.frame(cvDat)) cvDat <- data.frame(cvDat)
  # Find the df with min MSE and the 1-SE df
  cvDat[which.min(cvDat$meanErr),]
  df.min <- cvDat[which.min(cvDat$meanErr),"df"]
  df.min.upr <- cvDat[which.min(cvDat$meanErr),"upr"]
  df.1se <- with(cvDat,min(df[meanErr<df.min.upr]))
  p <- ggplot(cvDat,aes(x=df,y=meanErr)) + 
    geom_errorbar(aes(ymin=lwr,ymax=upr),color="grey") +
    geom_point(color="red") +
    geom_vline(xintercept=c(df.min,df.1se),linetype=3)
  print(p)
  return(list(df.min=df.min,df.1se=df.1se))
}
#

# The plotfit() function from the ch07part3 notes,
plotfitWage <- function(fit,dat,newdat){
  preds <- data.frame(newdat,
                      predict(fit,newdata=newdat,se=TRUE))
  preds$lwr <- preds$fit-2*preds$se
  preds$upr <- preds$fit+2*preds$se
  ggplot(dat,aes(x=age)) + geom_point(aes(y=wage),alpha=0.1) +
    geom_ribbon(aes(x=age,ymin=lwr,ymax=upr),
                data=preds,fill="blue",alpha=.2) + 
    geom_line(aes(y=fit),data=preds,color="blue")
}

# The plotfit() function from the ch07part3 notes,
# modified to use the dis and nox variables from the 
# Boston data set.
plotfitBoston <- function(fit,dat,newdat){
  preds <- data.frame(newdat,
                      predict(fit,newdata=newdat,se=TRUE))
  preds$lwr <- preds$fit-2*preds$se
  preds$upr <- preds$fit+2*preds$se
  ggplot(dat,aes(x=nox)) + geom_point(aes(y=dis)) +
    geom_ribbon(aes(x=nox,ymin=lwr,ymax=upr),
                data=preds,fill="blue",alpha=.2) + 
    geom_line(aes(y=fit),data=preds,color="blue")
}