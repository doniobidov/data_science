# load the package
library(dplyr)
# read the data set and attach
df <- read.csv('C:\Users\Doniyor\Desktop\international_debt.csv')
attach(df)
# summary statistics
summary(df)
sd(debt)
# find mode of the categorical variables
find_mode <- function(x) {
  u <- unique(x)
  tab <- tabulate(match(x, u))
  u[tab == max(tab)]
}
find_mode(country_name)
find_mode(country_code)
find_mode(indicator_name)
find_mode(indicator_code)
# plot histogram for debt
bin.endpoints <- seq(min(debt),max(debt),(max(debt)-min(debt))/ceiling(sqrt(length(debt))))
hist(debt, breaks=bin.endpoints, main="Figure 2. Histogram of debt", xlab="Countries' debt ($)", ylim=c(0,2500), xlim=c(0,2e+10))
# number of distinct countries
length(unique(country_code))
# number of distinct debt indicators
length(unique(indicator_code))
# total amount of debt owed by all the countries
sum(debt)
# country with the highest debt
country_name[which.max(debt)]
# average amount of debt across each indicator
aggregate(debt, list(indicator_code), FUN=mean) 
df %>%
  group_by(indicator_code) %>%
  summarise_at(vars(debt), list(name = mean))
# The highest amount of principal repayments
aggregate(debt, list(indicator_name), FUN=max)
# The most common debt indicators
table(indicator_code)
table(indicator_name)
