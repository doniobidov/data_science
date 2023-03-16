# 3.7
# load packages
library(TSA)
data(winnebago)
# a
# plot the data
plot(winnebago, type = "l", xlab = "Time", ylab = "Units Sold", 
     main = "Sales of recreational vehicles from Winnebago Inc. (November 1966 - February 1972)")
# b
# fit a linear model and plot the line
winne_line = lm(winnebago ~ time(winnebago))
abline(winne_line)
# summary of the hypothesis test
summary(winne_line)
# residual plot
res = resid(winne_line)
plot(res,ylab="Residuals",xlab="Time",type="o",main="Residuals plot from the linear fit")
abline(h=0,lty=2)
# c
# plot the data
plot(log(winnebago), type = "l", xlab = "Time", ylab = "log(Units Sold)", 
     main = "Log of sales of recreational vehicles from Winnebago Inc. (November 1966 - February 1972)")
# log transform the data and fit a linear model
winne_line_log = lm(log(winnebago) ~ time(winnebago))
abline(winne_line_log)
# summary of the hypothesis test
summary(winne_line_log)
# d
# residual plot
res = resid(winne_line_log)
plot(res,ylab="Residuals",xlab="Time",type="o",main="Residuals plot from the linear fit after log transformation")
abline(h=0,lty=2)
# e
# plot the data
plot(log(winnebago), type="l", ylab="log(Units Sold)", xlab="Time", 
     main="Log of sales of recreational vehicles from Winnebago Inc. (November 1966 - February 1972)")
points(y=log(winnebago), x=time(winnebago), pch=as.vector(season(winnebago)) )
# fit a seasonal-means plus linear time trend to the logged sales
month = season(winnebago)
winne_log_seas =  lm(log(winnebago) ~ month + time(winnebago)) # fit with intercept
# summary of the hypothesis test
summary(winne_log_seas)
# f
# residual plot
res = resid(winne_log_seas)
plot(res,ylab="Residuals",xlab="Time",type="o",
     main="Residuals plot of seasonal-means plus linear time trend to the logged sales")
abline(h=0,lty=2)

# 3.8
data(retail)
# a
# plot the data
plot(retail, type="l", ylab="Sales (billions of pounds)", xlab="Time",
     main="UK retail sales from January 1986 through March 2007")
points(y=retail, x=time(retail), pch=as.vector(season(retail)))
# b
# fit a seasonal-means plus linear time trend to the sales
month = season(retail)
retail_seas =  lm(retail ~ month + time(retail)) # fit with intercept
# summary of the hypothesis test
summary(retail_seas)
# c
# residual plot
res = resid(retail_seas)
plot(res,ylab="Residuals",xlab="Time",type="l",
     main="Residuals plot of seasonal-means plus linear time trend to the sales")
points(res, pch=as.vector(season(retail)))
abline(h=0,lty=2)

# 3.9
data(prescrip)
# a
# plot the data
plot(prescrip, type = "l", xlab = "Time", ylab = "Prescription Costs ($)",
     main = "Monthly prescription costs from August 1986 to March 1992 in New Jersey")
points(prescrip, pch=as.vector(season(prescrip)))
# b
pcx = na.omit((prescrip/zlag(prescrip)-1))*100
plot(pcx, type = "l", xlab = "Time", ylab = "Percentage change",
     main = "Month-to-month percentage changes in the prescription costs")
points(pcx, pch=as.vector(season(pcx)))
# c
har = harmonic(pcx,1)
model = lm(pcx ~ har)
summary(model)
# d
# residual plot
res = resid(model)
plot(res,ylab="Residuals",xlab="Time",type="o",main="Residuals plot from the linear fit of a cosine model")
abline(h=0,lty=2)

# 3.13
# load packages
require(sandwich) # for consistent variance estimation: 'vcovHAC' function
require(lmtest) # for testing hypothesis for coefficients: 'coeftest' function
# a
# fit a seasonal-means plus linear time trend to the logged sales
month = season(winnebago)
winne_log_seas =  lm(log(winnebago) ~ month + time(winnebago)) # fit with intercept
# residual plot
res = resid(winne_log_seas)
plot(res,ylab="Residuals",xlab="Time",type="o",
     main="Residuals plot of seasonal-means plus linear time trend to the logged sales")
abline(h=0,lty=2)
# b
# runs test for independence (H_0: independent)
runs(res)
# c
# sample ACF plot
acf(res,main="Sample ACF plot for the residuals")
# d
# plot 2 plots
par(mfrow = c(1, 2))
# histogram of residuals
hist(res,main="Histogram of the residuals")
# QQ plot of residuals
qqnorm(res,main="QQ plot for the residuals")
qqline(res)
# Shapiro-Wilk test for normality (H_0: normal)
shapiro.test(res)
# e
# HAC test	
# the p-values are appropriate for our data
coeftest(winne_log_seas, vcov=vcovHAC(winne_log_seas), df=Inf)

# 3.14
# load packages
require(sandwich) # for consistent variance estimation: 'vcovHAC' function
require(lmtest) # for testing hypothesis for coefficients: 'coeftest' function
# a
# fit a seasonal-means plus linear time trend to the sales
month = season(retail)
retail_seas =  lm(retail ~ month + time(retail)) # fit with intercept
# residual plot
res = resid(retail_seas)
plot(res,ylab="Residuals",xlab="Time",type="l",
     main="Residuals plot of seasonal-means plus linear time trend to the sales")
points(res, pch=as.vector(season(retail)))
abline(h=0,lty=2)
# b
# runs test for independence (H_0: independent)
runs(res)
# c
# sample ACF plot
acf(res,main="Sample ACF plot for the residuals")
# d
# plot 2 plots
par(mfrow = c(1, 2))
# histogram of residuals
hist(res,main="Histogram of the residuals")
# QQ plot of residuals
qqnorm(res,main="QQ plot for the residuals")
qqline(res)
# Shapiro-Wilk test for normality (H_0: normal)
shapiro.test(res)
# e
# HAC test	
# the p-values are appropriate for our data
coeftest(retail_seas, vcov=vcovHAC(retail_seas), df=Inf)

# 3.15
# load packages
require(sandwich) # for consistent variance estimation: 'vcovHAC' function
require(lmtest) # for testing hypothesis for coefficients: 'coeftest' function
# a
pcx = na.omit((prescrip/zlag(prescrip)-1))*100
har = harmonic(pcx,1)
model = lm(pcx ~ har)
# residual plot
res = resid(model)
plot(res,ylab="Residuals",xlab="Time",type="o",main="Residuals plot from the linear fit of a cosine model")
abline(h=0,lty=2)
# b
# runs test for independence (H_0: independent)
runs(res)
# c
# sample ACF plot
acf(res,main="Sample ACF plot for the residuals")
# d
# plot 2 plots
par(mfrow = c(1, 2))
# histogram of residuals
hist(res,main="Histogram of the residuals")
# QQ plot of residuals
qqnorm(res,main="QQ plot for the residuals")
qqline(res)
# Shapiro-Wilk test for normality (H_0: normal)
shapiro.test(res)
# e
# HAC test	
# the p-values are appropriate for our data
coeftest(model, vcov=vcovHAC(model), df=Inf)