# load the dataset
library(TSA)
data(tempdub)

# ex 1.4
# plot 3 plots
par(mfrow = c(3, 1)) 
# simulate a chi-square distribution
samples = ts(rchisq(n=48,df=2))
plot(samples,type='o',xlab="Time",ylab="",main="Random Chi-Square Distribution",
     ylim=c(mean(samples)-3.8*sd(samples),mean(samples)+3.8*sd(samples)))
# add mean line
abline(h=mean(samples),lty=3,col=2)
# add lines 3 sd away from the mean
abline(h=mean(samples)+3*sd(samples),lty=4,col=3)
abline(h=mean(samples)-3*sd(samples),lty=4,col=3)

# ex 1.5
# plot 3 plots
par(mfrow = c(3, 1)) 
# simulate a t distribution
samples = ts(rt(n=48,df=5))
plot(samples,type='o',xlab="Time",ylab="",main="Random t Distribution",
     ylim=c(mean(samples)-3.8*sd(samples),mean(samples)+3.8*sd(samples)))
# add mean line
abline(h=mean(samples),lty=3,col=2)
# add lines 3 sd away from the mean
abline(h=mean(samples)+3*sd(samples),lty=4,col=3)
abline(h=mean(samples)-3*sd(samples),lty=4,col=3)

# ex 1.6
# plot 2 plots
par(mfrow = c(2, 1)) 
plot(tempdub, type = "l", xlab = "Time", ylab = "Temperature (F)", main = "Average Monthly Temperatures, Dubuque, Iowa")
points(y=tempdub, x=time(tempdub), pch=as.vector(season(tempdub)))
plot(tempdub, xlab = "Time", ylab="Temperature (F)", type = "o", main = "Average Monthly Temperatures, Dubuque, Iowa")
