#Read data from a website
uu <- url("http://www-bcf.usc.edu/~gareth/ISL/Credit.csv")
Credit.raw <- read.csv(uu,row.names=1)
n = nrow(Credit.raw)

#Split the data into a training and validation set
set.seed(1)
indices = rep(c(1,1,1,2), times=n/4)
indices = sample(indices, size=n, replace=FALSE)
Credit = Credit.raw[indices==1,]
Credit.valid = Credit.raw[indices!=1,]

#From Exercises 6, we know that all subsets with cross validation
#chooses a model with 7 predictors. Let's fit this model
fit.sub = lm(Balance ~ . -Education -Married -Ethnicity, data=Credit)

#Get the validation set error rate
Y.valid = Credit.valid$Balance
Y.hat.sub = predict(fit.sub, Credit.valid)
err.valid.sub = sum((Y.valid - Y.hat.sub)^2)

######################################################
### Fit Ridge Regression using CV to choose lambda ###
######################################################
library(glmnet)

#Construct the model matrix and extract Y
Xfull = model.matrix(Balance ~ ., data=Credit)
Y = Credit$Balance

#Fit models with many different lambda values
lambdas = 10^seq(-2, 5, length=100)
fit.ridge.raw = cv.glmnet(Xfull, Y, alpha=0, lambda=lambdas)

#Examine the error plot
plot(fit.ridge.raw)

#Get the 1se lambda and fit the corresponding model
l.ridge = fit.ridge.raw$lambda.1se
fit.ridge = glmnet(Xfull, Y, alpha=0, lambda=l.ridge)

#Compute the validation-set error rate
Xfull.valid = model.matrix(Balance~., data=Credit.valid)
Y.hat.ridge = predict(fit.ridge, Xfull.valid)
err.valid.ridge = sum((Y.valid - Y.hat.ridge)^2)

###########################################
### Fit LASSO using CV to choose lambda ###
###########################################
#Fit models with many different lambda values
fit.lasso.raw = cv.glmnet(Xfull, Y, alpha=1, lambda=lambdas)

#Examine the error plot
plot(fit.lasso.raw)

#Get the 1se lambda and fit the corresponding model
l.lasso=fit.lasso.raw$lambda.1se
fit.lasso = glmnet(Xfull, Y, alpha=1, lambda=l.lasso)

#Compute the validation-set error rate
Y.hat.lasso = predict(fit.lasso, Xfull.valid)
err.valid.lasso = sum((Y.valid - Y.hat.lasso)^2)
