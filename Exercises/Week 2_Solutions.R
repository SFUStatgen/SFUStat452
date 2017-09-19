library(tidyverse)
library(gapminder)

#Get information about the gapminder dataset
help(gapminder)

#View the variable names and get a summary of each variable
head(gapminder)
summary(gapminder)

#Add natural log of gdpPercap to our dataset
(gapminder.new = mutate(gapminder, lgdpPercap = log(gdpPercap)))
select(gapminder.new, contains("gdpPercap"))

#Create a new dataset from year 1952 in Africa, Europe and Asia
(gm1952 = filter(gapminder.new, year==1952,
                continent %in% c("Africa", "Europe", "Asia")))

#Create a matching dataset for 2007
(gm2007 = filter(gapminder.new, year==2007,
                continent %in% c("Africa", "Europe", "Asia")))

#Plot life expectency vs log gdp per capita for the 3 continents on 1 axis in 1952
ggplot(gm1952, aes(x=lifeExp, y=lgdpPercap)) +
  geom_point(aes(color=continent)) + 
  geom_smooth(method="lm", se=F, aes(colour=continent))

#The country with lgdpPercap>11 is definitely an outlier. Let's find this country
#First, using filter()
filter(gm1952, lgdpPercap>10)
#Next, using View(). Sorting the data by lgdpPercap first will help
View(gm1952)
gm1952.sorted = arrange(gm1952, desc(lgdpPercap))
View(gm1952.sorted)

#Now plot the 2007 data
ggplot(gm2007, aes(x=lifeExp, y=lgdpPercap, colour=continent)) +
  geom_point() + 
  geom_smooth(method="lm", se=F)

#Extract countries with life expectancy below 45 and lgdpPercap>8
#Using filter
filter(gm2007, lifeExp<45 & lgdpPercap>8)
#Using View. Sort the data first by lifeExp
View(gm2007)

#Re-plot both dataset for easier comparing


#######################################
### Display both plots side-by-side ###
#######################################

(gmboth = bind_rows(gm1952, gm2007))

ggplot(gmboth, aes(x=lifeExp, y=lgdpPercap, colour = continent))+
  geom_point() +  geom_smooth(method="lm", se=F)+
  facet_wrap(~year)
