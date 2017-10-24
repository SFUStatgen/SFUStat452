#Read data from a website
uu <- url("http://www-bcf.usc.edu/~gareth/ISL/Credit.csv")
Credit.raw <- read.csv(uu,row.names=1)
n = nrow(Credit.raw)

#Split the data into a training and validation set


#From Exercises 6, we know that all subsets with cross validation
#chooses a model with 7 predictors. Let's fit this model


#Get the validation set error rate


######################################################
### Fit Ridge Regression using CV to choose lambda ###
######################################################
library(glmnet)

#Construct the model matrix and extract Y

#Xfull[,-1] = scale(Xfull[,-1])


#Fit models with many different lambda values


#Examine the error plot


#Get the 1se lambda and fit the corresponding model


#Compute the validation-set error rate



###########################################
### Fit LASSO using CV to choose lambda ###
###########################################
#Fit models with many different lambda values


#Examine the error plot


#Get the 1se lambda and fit the corresponding model


#Compute the validation-set error rate
