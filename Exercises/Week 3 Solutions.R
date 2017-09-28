library(MASS)
library(tidyverse)

#Activate our dataset and examine it
data(Boston)
head(Boston)
help(Boston)

### Question 1 ###

#Fit a model to predict medv
bfit = lm(medv ~ ., data=Boston)

#Print information about our model
summary(bfit)

#Clean-up and print information about the coefficients
round(summary(bfit)$coefficients,4)

#Remove one variable and re-fit
bfit2 = lm(medv ~ . - age, data=Boston)

#Display cleaned coefficients
round(summary(bfit2)$coefficients,4)

#Remove another variable and re-fit
bfit3 = lm(medv ~ . - age -indus, data=Boston)
round(summary(bfit3)$coefficients,4)

#Stop here, because all p-values are >0.05


### Question 2 ###

#Fit a model using all pair-wise interactions
bfit.int = lm(medv ~ .*., data=Boston)
(coeffs.int = round(summary(bfit.int)$coefficients, 4))
colnames(coeffs.int)[4] = "p.value"

#Extract the factor names
vars = rownames(coeffs.int)

#Convert our matrix to a tibble
coeffs.int = as.tibble(coeffs.int)

#Add factor names back in as a new variable
coeffs.int$vars = vars

#Sort our list by p.value
arrange(coeffs.int, desc(p.value))

#Remove the interaction of zn with age
bfit.int2 = lm(medv ~ .*. -zn:age, data=Boston)
round(summary(bfit.int2)$coefficients, 4)


### Question 3 ###

#Fit a model without using zn at all
bfit.nozn = lm(medv ~ .*. -zn:., data=Boston)
round(summary(bfit.nozn)$coefficients, 4)

#Compare models with and without zn using a multiple-partial F-test
anova(bfit.nozn, bfit.int)

#We get a p-value >0.05, so we cannot conclude that any zn coefficients are not zero


### Question 4 ###

#Fit a model without using zn or indus
bfit.less2 = lm(medv ~ .*. - zn:. - indus:., data=Boston)
round(summary(bfit.less2)$coefficients, 4)

#Can we also remove indus?
anova(bfit.nozn, bfit.less2)

#Our p-value is <0.05, so we cannot remove indus after removing zn