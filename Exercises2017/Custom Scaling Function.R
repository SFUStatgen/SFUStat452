library(plyr)
#Standardizes the columns of X2 using the values in X1
#E.g. Use training data as X1 and test data as X2 to scale
#the test data correctly for Ridge regression or LASSO
#If int=T then don't standardize the first column (the intercept)
my.scale = function(X1, X2, int=T){
  means = aaply(X1, 2, mean)
  if(int==T){
    means[1] = 0
  }
  sds = aaply(X1, 2, sd)
  if(int==T){
    sds[1] = 1
  }
  output = (X2 - means)/sds
  return(output)
}

