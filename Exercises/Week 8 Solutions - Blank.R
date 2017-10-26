#Import Data
Diab <- read.csv("Data/pima-diabetes.csv")
head(Diab,n=3)
summary(Diab)

#Remove "missing" values


#Remove Outcome

#Extract predictors and response

#Compute the mean and variance of each predictor

#Compute principal components of the predictors

#Compute principal components of the standardized predictors

#Plot both PCAs

#Center and scale the predictors

#Comfirm that we standardized correctly


##########################################
### Fit a PCR model to predict Glucose ###
##########################################
library(pls)

