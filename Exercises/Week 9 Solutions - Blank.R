source("week9Util.R")

#For questions 1 and 2 we will use the Wage dataset
#For question 3 we will use the Boston dataset

##################
### Question 1 ###
##################
library(ISLR)
data(Wage)
library(splines)

#Initialize parameters
k<-10; nDf <- 10; seed <- 1; cvErrs <- rep(NA,nDf) 

#Compute CV error for each degree of spline

#Plot errors


##################
### Question 2 ###
##################

#Compute errors and uncertainty

#Plot errors with uncertainty

#Fit the best model and plot predictions (with uncertainty)


##################
### Question 3 ###
##################

#Predict nox using dis

### Part a ###

#Run cv to choose the 'best' polynomial degree

#Plot results

#Fit and plot the best model

### Part b ###

#Run cv to choose the 'best' spline degree

#Plot results

#Fit and plot the best model

### Part c ###

#Fit and plot a smoothing spline

### Part d ###

