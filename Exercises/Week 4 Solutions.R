library(gapminder)
library(tidyverse)
library(car)

#Use the pipe to transform gdpPercap and pop into their base-10 logarithms
#and remove all but Asia, Europe and Africa and keep only 1952 data and delete year
gap = gapminder %>%
  filter(year==1952) %>%
  filter(continent %in% c("Africa", "Asia", "Europe")) %>%
  mutate(lgdp = log10(gdpPercap), lpop = log10(pop)) %>%
  select(-year, -gdpPercap, -pop)

#Fit a model using log(gdpPercap), log(pop) and their interactions with continent
#Note: must include a main effect for continent by principle of hierarchy
fit.full = lm(lifeExp ~ continent*(lgdp + lpop), data=gap)

#Print out information about coefficients in the full model
round(summary(fit.full)$coefficients, 4)

#Fit a model without log(pop) or its interactions with continent
fit.red = lm(lifeExp ~ continent*lgdp, data=gap)

#Print out coefficient information in the reduced model
round(summary(fit.red)$coefficients, 4)

#Test whether we can safely use the reduced model
anova(fit.full, fit.red)

#Our p-value is >0.05, so we cannot reject the null hypothesis that 
#both models are equivalent in the population.
#Parsimony says we should therefore use the smaller model

#Write out the expression for f_hat(x) in Europe based on the reduced model
#Interpret the slope (remember lgdpPercap is on log_10 scale)


#Plot residuals vs fitted values
gap$fitted = fitted(fit.red)
gap$resid = residuals(fit.red)
ggplot(gap, aes(x = fitted, y=resid))+
  geom_point() + geom_smooth() +
  geom_abline(colour="red", slope=0, intercept=0)

#Aside: What would happen if we instead use aes(colour = "red") in geom_abline?

#Generate a qq-plot of the studentized residuals
#Note qqPlot() does this automatically
#Comment on the plot
library(car)
qqPlot(gap$resid)

#Calculate studentized residuals, Leverages and Cook's D
gap$studRes = rstudent(fit.red)
gap$hats = hatvalues(fit.red)
gap$cook = cooks.distance(fit.red)

#Use filter() to extract extreme values of these variables
#Residuals larger than 3 in absolute value are considered large
filter(gap, abs(studRes)>3)
#The average hat value is (p+1)/n. 
#Anything more than triple the average is considered large
filter(gap, hats>3*6/115)
#Cooks D larger than 1 is considered large
filter(gap, cook>1)
