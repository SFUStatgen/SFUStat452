#Read data from a website
uu <- url("http://www-bcf.usc.edu/~gareth/ISL/Credit.csv")
Credit <- read.csv(uu,row.names=1)
head(Credit,n=3)

#Do all subsets regression
library(leaps)


#Construct the model matrix


######################################################
### Fit all models that contain a single predictor ###
######################################################
#Container for rss of each model

for(i in 2:12){
  #Extract relevant data
  
  #Fit model
  
  #Extract rss
  
}


#Find the single-predictor model with lowest RSS


#Check that this is consistent with all subsets



###################################################
### Estimate test-set error of the Rating model ###
###      using 10-fold cross validation         ###
###################################################

# Pull the response, Balance, out of the Credit data set


# Pull the intercept and Rating predictor out of Xfull.
# Use the logical vector in cfits.sum$which[1,]


# Create folds
k <- 10
set.seed(1)


#Container for Test Set Error (TSE)


for(i in 1:k){
  # Validation on ith fold:
  

  # Use lm.fit(), the "worker" function behind lm()
  # to fit the model with response trainY and 
  # design matrix trainX
  
  
  # There is no predict() for the output of fit so 
  # we use matrix multiplication to obtain
  # the fitted values on the test X's
  
}

#Average test-set error across folds



#Write a function that does what we just did
cv = function(X, Y, k, seed){
  
  
  #Container for Test Set Error (TSE)
  
  
  for(i in 1:k){
    # Validation on ith fold:
    
    
    # Use lm.fit(), the "worker" function behind lm()
    # to fit the model with response trainY and 
    # design matrix trainX
     
    
    # There is no predict() for the output of fit so 
    # we use matrix multiplication to obtain
    # the fitted values on the test X's
    
  }
  
  #Average test-set error across folds
  
}


##################################################################
### Run cv on each of the 11 best models from subset selection ###
##################################################################
#Container for storing test-set error rates


#Extract Y


#Iterate through models
for(i in 1:11){
  #Extract X
  
  
  #Run cv
  
}

#Get the best model and report its variables


#Check Cp values

#Check BIC values