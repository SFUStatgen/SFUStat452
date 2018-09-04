#Runs cross validation for a model from all subsets
#Removed seed setting from Exercises 6
cv.sub = function(X, Y, k){
  folds = sample(1:k, size=nrow(X), replace=T)
  #Container for Test Set Error (TSE)
  TSEs = 1:k
  
  for(i in 1:k){
    # Validation on ith fold:
    testY = Y[folds==i]
    trainY = Y[folds!=i]
    testX = X[folds==i,]
    trainX = X[folds!=i,]
    
    # Use lm.fit(), the "worker" function behind lm()
    # to fit the model with response trainY and 
    # design matrix trainX
    fit = lm.fit(trainX, trainY)
    
    # There is no predict() for the output of fit so 
    # we use matrix multiplication to obtain
    # the fitted values on the test X's
    testPreds = testX %*% fit$coefficients
    validErr = sum((testPreds - testY)^2)
    TSEs[i] = validErr
  }
  
  #Average test-set error across folds
  TSE = mean(TSEs)
  return(TSE)
}