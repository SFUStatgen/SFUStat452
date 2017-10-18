#Read data from a website
uu <- url("http://www-bcf.usc.edu/~gareth/ISL/Credit.csv")
Credit <- read.csv(uu,row.names=1)
head(Credit,n=3)

#Do all subsets regression
library(leaps) # contains regsubsets()
cfits <- regsubsets(Balance ~ ., data=Credit,nvmax=11)
cfits.sum <- summary(cfits)

#Construct the model matrix
Xfull <- model.matrix(Balance ~ .,data=Credit)
head(Xfull)
ncol(Xfull)

######################################################
### Fit all models that contain a single predictor ###
######################################################
#Container for rss of each model
RSSs = rep(0, times=11)
names(RSSs) = colnames(Xfull)[-1] #Remove the intercept
for(i in 2:12){
  #Extract relevant data
  dat <- data.frame(Balance=Credit$Balance,X=Xfull[,i])
  #Fit model
  fit = lm(Balance ~ X, data=dat)
  #Extract rss
  resid = fit$residuals
  rss = sum(resid^2)
  RSSs[i-1] = rss
}


#Find the single-predictor model with lowest RSS
which.min(RSSs)

#Check that this is consistent with all subsets
cfits.sum


###################################################
### Estimate test-set error of the Rating model ###
###      using 10-fold cross validation         ###
###################################################

# Pull the response, Balance, out of the Credit data set
Y <- Credit$Balance

# Pull the intercept and Rating predictor out of Xfull.
# Use the logical vector in cfits.sum$which[1,]
X <- Xfull[,cfits.sum$which[1,]]

# Create folds
k <- 10
set.seed(1)
folds <- sample(1:k,size=nrow(Credit),replace=TRUE)
head(folds)
table(folds) # Not of equal size, but close enough

#Container for Test Set Error (TSE)
TSEs = rep(0, times=k)

for(i in 1:k){
  # Validation on ith fold:
  testY <- Y[folds==i]
  trainY <- Y[folds!=i]
  testX <- X[folds==i,] 
  trainX <- X[folds!=i,]

  # Use lm.fit(), the "worker" function behind lm()
  # to fit the model with response trainY and 
  # design matrix trainX
  fit <- lm.fit(trainX,trainY) 
  
  # There is no predict() for the output of fit so 
  # we use matrix multiplication to obtain
  # the fitted values on the test X's
  testPreds <- testX%*%fit$coefficients
  validErr <- sum((testPreds - testY)^2)
  TSEs[i] = validErr
}

#Average test-set error across folds
TSE = mean(TSEs)


#Write a function that does what we just did
cv = function(X, Y, k, seed){
  set.seed(seed)
  folds <- sample(1:k,size=nrow(X),replace=TRUE)
  head(folds)
  table(folds) # Not of equal size, but close enough
  
  #Container for Test Set Error (TSE)
  TSEs = rep(0, times=k)
  
  for(i in 1:k){
    # Validation on ith fold:
    testY <- Y[folds==i]
    trainY <- Y[folds!=i]
    testX <- X[folds==i,] 
    trainX <- X[folds!=i,]
    
    # Use lm.fit(), the "worker" function behind lm()
    # to fit the model with response trainY and 
    # design matrix trainX
    fit <- lm.fit(trainX,trainY) 
    
    # There is no predict() for the output of fit so 
    # we use matrix multiplication to obtain
    # the fitted values on the test X's
    testPreds <- testX%*%fit$coefficients
    validErr <- sum((testPreds - testY)^2)
    TSEs[i] = validErr
  }
  
  #Average test-set error across folds
  TSE = mean(TSEs)
  return(TSE)
}


##################################################################
### Run cv on each of the 11 best models from subset selection ###
##################################################################
#Container for storing test-set error rates
subsets.TSEs = rep(0, times=11)

#Extract Y
Y <- Credit$Balance

#Iterate through models
for(i in 1:11){
  #Extract X
  vars = cfits.sum$which[i,]
  X = Xfull[,vars]
  
  #Run cv
  TSE = cv(X,Y, 10, 1)
  subsets.TSEs[i] = TSE
}

#Get the best model and report its variables
ind = which.min(subsets.TSEs)
cfits.sum$which[ind,]

#Check Cp values
cfits.sum$cp
which.min(cfits.sum$cp)
