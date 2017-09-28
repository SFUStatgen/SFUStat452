library(gapminder)
library(tidyverse)
library(car)

#Use the pipe to transform gdpPercap and pop into their base-10 logarithms
#and remove all but Asia, Europe and Africa and keep only 1952 data and delete year


#Fit a model using log(gdpPercap), log(pop) and their interactions with continent
#Note: must include a main effect for continent by principle of hierarchy


#Print out information about coefficients in the full model


#Fit a model without log(pop) or its interactions with continent


#Print out coefficient information in the reduced model


#Test whether we can safely use the reduced model


#Our p-value is >0.05, so we cannot reject the null hypothesis that 
#both models are equivalent in the population.
#Parsimony says we should therefore use the smaller model

#Write out the expression for f_hat(x) in Europe based on the reduced model
#Interpret the slope (remember lgdpPercap is on log_10 scale)


#Plot residuals vs fitted values


#Aside: What would happen if we instead use aes(colour = "red") in geom_abline?

#Generate a qq-plot of the studentized residuals
#Note qqPlot() does this automatically
#Comment on the plot


#Calculate studentized residuals, Leverages and Cook's D


#Use filter() to extract extreme values of these variables
#Residuals larger than 3 in absolute value are considered large

#The average hat value is (p+1)/n. 
#Anything more than triple the average is considered large

#Cooks D larger than 1 is considered large

