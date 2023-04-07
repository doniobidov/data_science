# HW4
# 5.1
# a
f=c(1,-1,0.25)
polyroot(f)
# b
f=c(1,-2,1)
polyroot(f)
# c
f1=c(1,-0.5,0.5)
polyroot(f1)
f2=c(1,-0.5,0.25)
polyroot(f2)

# 5.12
library(TSA)
library(tseries)
data(SP)
# a
# time plot
plot(SP, xlab="Time", ylab="Price ($)", main = "SP’s stock price from 1936 to 1977")
# b
plot(log(SP), type="l", xlab="Time", ylab="log(Price in $)", 
     main = "Log of SP’s stock price from 1936 to 1977")
# c
par(mfrow=c(1,2))
pc = na.omit((SP/zlag(SP)-1))*100
plot(pc, type="l", xlab="Time", ylab="Percentage change",
     main = "Percentage changes in SP’s stock price from 1936 to 1977")
plot(diff(log(SP)), type="l", xlab="Time", ylab="Log difference",
     main = "Log difference of SP’s stock price from 1936 to 1977")
# d(a)
# ACF plot
acf(SP)
# unit root tests
adf.test(SP)
pp.test(SP)
# d(b)
# ACF plot
acf(log(SP))
# unit root tests
adf.test(log(SP))
pp.test(log(SP))
# d(c)
# ACF plots
acf(pc)
acf(diff(log(SP)))
# unit root tests
adf.test(pc)
pp.test(pc)
adf.test(diff(log(SP)))
pp.test(diff(log(SP)))

# 6.26
# a
par(mfrow=c(1,2))
# population ACF for an MA(1) model with theta=0.5
y = ARMAacf(ma = -0.5, lag.max = 48)	
plot(y, x = 0:48, type = "h", ylim = c(-1,1), xlab = "k", 
     ylab = "Autocorrelation", main = "Population ACF of an MA(1) model with coefficient 0.5")
abline(h=0)
# c
# population PACF for an MA(1) model with theta=0.5
y = ARMAacf(ma = -0.5, lag.max = 48, pacf = TRUE)	
plot(y, type = "h", ylim = c(-1,1), xlab = "k", 
     ylab = "PAC", main = "Population PACF of an MA(1) model with coefficient 0.5")
abline(h=0)
# b, d
# two simulated MA(1) series with MA coefficient 0.5
par(mfcol=c(2,2))
for (i in 1:2){ 
  x=arima.sim(n=48,list(order=c(0,0,1),ma=-0.5))
  acf(x,main="sample ACF")
  pacf(x,main="sample PACF")
}

# 6.27
# a
par(mfrow=c(1,2))
# population ACF for an AR(2) model with phi_1=0.7, phi_2=-0.4
y = ARMAacf(ar = c(0.7,-0.4), lag.max = 20)	
plot(y, x = 0:20, type = "h", ylim = c(-1,1), xlab = "k", ylab = "Autocorrelation", 
     main = "Population ACF of an AR(2) model with coefficients 0.7 and -0.4")
abline(h=0)
# c
# population PACF for an AR(2) model with phi_1=0.7, phi_2=-0.4
y = ARMAacf(ar = c(0.7,-0.4), lag.max = 20, pacf = TRUE)	
plot(y, type = "h", ylim = c(-1,1), xlab = "k", ylab = "Autocorrelation", 
     main = "Population PACF of an AR(2) model with coefficients 0.7 and -0.4")
abline(h=0)
# b, e
# two simulated AR(2) series with AR coefficient 0.7 and -0.4
par(mfcol=c(2,2))
for (i in 1:2){ 
  x=arima.sim(n=72,list(order=c(2,0,0),ar=c(0.7,-0.4)))
  acf(x,main="sample ACF")
  pacf(x,main="sample PACF")
}

# 6.31
# ARIMA(0,1,1) with θ = 0.8
y=arima.sim(n=60,list(order=c(0,1,1),ar=1, ma=-0.8))
# a
# Dickey-Fuller test
adf.test(y, k = 0)
# b
# augmented Dickey-Fuller test
adf.test(y)
# c
# Dickey-Fuller test
adf.test(diff(y), k = 0)
# augmented Dickey-Fuller test
adf.test(diff(y))

# 6.36
install.packages("forecast")
library(forecast)
data(robot)
# a
# time plot
plot(robot, xlab="Time", ylab="Distance (inch)", main = "Robot's distances from a desired ending point")
# augmented Dickey-Fuller test
adf.test(robot)
# b
par(mfcol=c(1,2))
# ACF plot
acf(robot, main="sample ACF")
# PACF plot
pacf(robot, main="sample PACF")
# c
# EACF plot
eacf(robot)
# d
# armasubsets function in TSA package
plot(armasubsets(y=robot,nar=5,nma=5,y.name='test',ar.method='ols'),scale="BIC")
# compare AIC, corrected AIC, and BICs of the candidate models
Arima(robot,method="ML",c(2,0,0))
Arima(robot,method="ML",c(6,0,0))
Arima(robot,method="ML",c(1,0,1))
# Automatically select the orders
auto.arima(robot)
