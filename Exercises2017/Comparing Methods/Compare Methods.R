#Read-in the data
data.raw <- read.csv("Data/Abalone.csv")
head(data.raw,n=3)
summary(data.raw)
n = nrow(data.raw) #Sample size
p = ncol(data.raw) - 1 #Number of predictors
m = 10 #Number of times to split

#Create a container for test-set errors
all.errors = array(0, dim=c(m,2))
colnames(all.errors) = c("Least Squares", "All Subsets")

#Run service scripts
source("Exercises/Comparing Methods/CV Subsets.R")

set.seed(1)

for(l in 1:m){
  #Split the data
  indices = c(rep(2, times=1000), rep(1, times=n-1000))
  indices = sample(indices, n, replace=F)
  data.train = data.raw[indices==1,]
  data.test = data.raw[indices==2,]
  X.train = data.train[,-(p+1)]
  Y.train = data.train[,p+1]
  Xfull.train = model.matrix(Rings ~ ., data=data.train)
  X.test = data.test[,-(p+1)]
  Y.test = data.test[,p+1]
  Xfull.test = model.matrix(Rings ~ ., data=data.test)

  #Fit linear regression
  fit.lm = lm(Rings ~ ., data=data.train)
  pred.lm = predict(fit.lm, X.test)
  err.lm = sum((Y.test - pred.lm)^2)
  all.errors[l,1] = err.lm

  #Fit all subsets regression with CV selection
  library(leaps)
  all.sub = regsubsets(Rings ~ ., data=data.train, nvmax=p)
  all.sub.sum = summary(all.sub)
  all.sub.errs = rep(0, times=p)
  for(i in 1:p){
    this.X = Xfull.train[,all.sub.sum$which[i,]]
    this.err = cv.sub(this.X, Y.train, 10)
    all.sub.errs[i] = this.err
  }
  j = which.min(all.sub.errs)
  X.sub = Xfull.train[,all.sub.sum$which[j,]]
  fit.sub = lm.fit(X.sub, Y.train)
  X.test.sub = Xfull.test[,all.sub.sum$which[j,]]
  pred.sub = X.test.sub %*% fit.sub$coefficients
  err.sub = sum((Y.test - pred.sub)^2)
  all.errors[l,2] = err.sub
}


#Compare error rates
summary(all.errors)
boxplot(all.errors)
plot(all.errors)
abline(a=0, b=1)
