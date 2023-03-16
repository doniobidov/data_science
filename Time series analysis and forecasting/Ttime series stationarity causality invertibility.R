# 4.2
# load packages
library(TSA)
data(tempdub)
# a
# ACF plot
y = ARMAacf(ma = c(-0.5,-0.4), lag.max = 20)	
plot(y, x = 0:20, type = "h", ylim = c(-1,1), xlab = "k", ylab = "Autocorrelation",
     main = "ACF plot for MA(2) with θ1 = 0.5 and θ2 = 0.4")
abline(h=0)
# b
# ACF plot
y = ARMAacf(ma = c(-1.2,0.7), lag.max = 20)	
plot(y, x = 0:20, type = "h", ylim = c(-1,1), xlab = "k", ylab = "Autocorrelation",
     main = "ACF plot for MA(2) with θ1 = 1.2 and θ2 = -0.7")
abline(h=0)
# c
# ACF plot
y = ARMAacf(ma = c(1.0,0.6), lag.max = 20)	
plot(y, x = 0:20, type = "h", ylim = c(-1,1), xlab = "k", ylab = "Autocorrelation",
     main = "ACF plot for MA(2) with θ1 = -1 and θ2 = -0.6")
abline(h=0)

# 4.5
# a
# ACF plot
y = ARMAacf(ar = 0.6, lag.max = 20)	
plot(y, x = 0:20, type = "h", ylim = c(-1,1), xlab = "k", ylab = "Autocorrelation",
     main = "ACF plot for AR(1) with phi = 0.6")
abline(h=0)
# b
# ACF plot
y = ARMAacf(ar = -0.6, lag.max = 20)	
plot(y, x = 0:20, type = "h", ylim = c(-1,1), xlab = "k", ylab = "Autocorrelation",
     main = "ACF plot for AR(1) with phi = -0.6")
abline(h=0)
# c
# ACF plot
y = ARMAacf(ar = 0.95, lag.max = 20)	
plot(y, x = 0:20, type = "h", ylim = c(-1,1), xlab = "k", ylab = "Autocorrelation",
     main = "ACF plot for AR(1) with phi = 0.95")
abline(h=0)
# d
# ACF plot
y = ARMAacf(ar = 0.3, lag.max = 20)	
plot(y, x = 0:20, type = "h", ylim = c(-1,1), xlab = "k", ylab = "Autocorrelation",
     main = "ACF plot for AR(1) with phi = 0.3")
abline(h=0)

# 4.9
# a_1
# Find roots of the characteristic equation
round((0.6+sqrt(0.6**2+4*0.3))/(-2*0.3), 1) # root 1
round((0.6-sqrt(0.6**2+4*0.3))/(-2*0.3), 1) # root 2
# a_2
# ACF plot
y = ARMAacf(ar = c(0.6,0.3), lag.max = 20)	
plot(y, x = 0:20, type = "h", ylim = c(-1,1), xlab = "k", ylab = "Autocorrelation",
     main = "ACF plot for AR(2) with phi_1 = 0.6 and phi_2 = 0.3")
abline(h=0)
# b_1
# The characteristic equation
phi_1 = -0.4
phi_2 = 0.5
Y_t <- c(1, -phi_1, -phi_2)
# Find roots of the characteristic equation
polyroot(Y_t)
# b_2
# ACF plot
y = ARMAacf(ar = c(phi_1,phi_2), lag.max = 20)	
plot(y, x = 0:20, type = "h", ylim = c(-1,1), xlab = "k", ylab = "Autocorrelation",
     main = "ACF plot for AR(2) with phi_1 = -0.4 and phi_2 = 0.5")
abline(h=0)
# c_1
# The characteristic equation
phi_1 = 1.2
phi_2 = -0.7
Y_t <- c(1, -phi_1, -phi_2)
# Find roots of the characteristic equation
polyroot(Y_t)
# Find the magnitudes of the roots 
(0.8571429^2+0.8329931^2)^0.5 # root 1 and root 2
# c_2
# ACF plot
y = ARMAacf(ar = c(phi_1,phi_2), lag.max = 20)	
plot(y, x = 0:20, type = "h", ylim = c(-1,1), xlab = "k", ylab = "Autocorrelation",
     main = "ACF plot for AR(2) with phi_1 = 1.2 and phi_2 = -0.7")
abline(h=0)
# d_1
# The characteristic equation
phi_1 = -1
phi_2 = -0.6
Y_t <- c(1, -phi_1, -phi_2)
# Find roots of the characteristic equation
polyroot(Y_t)
# Find the magnitudes of the roots 
(0.8333333^2+0.9860133^2)^0.5 # root 1 and root 2
# d_2
# ACF plot
y = ARMAacf(ar = c(phi_1,phi_2), lag.max = 20)	
plot(y, x = 0:20, type = "h", ylim = c(-1,1), xlab = "k", ylab = "Autocorrelation",
     main = "ACF plot for AR(2) with phi_1 = -1 and phi_2 = -0.6")
abline(h=0)
# e_1
# The characteristic equation
phi_1 = 0.5
phi_2 = -0.9
Y_t <- c(1, -phi_1, -phi_2)
# Find roots of the characteristic equation
polyroot(Y_t)
# Find the magnitudes of the roots 
(0.277778^2+1.016834^2)^0.5 # root 1 and root 2
# e_2
# ACF plot
y = ARMAacf(ar = c(phi_1,phi_2), lag.max = 20)	
plot(y, x = 0:20, type = "h", ylim = c(-1,1), xlab = "k", ylab = "Autocorrelation",
     main = "ACF plot for AR(2) with phi_1 = 0.5 and phi_2 = -0.9")
abline(h=0)
# f_1
# The characteristic equation
phi_1 = -0.5
phi_2 = -0.6
Y_t <- c(1, -phi_1, -phi_2)
# Find roots of the characteristic equation
polyroot(Y_t)
# Find the magnitudes of the roots 
(0.416667^2+1.221907^2)^0.5 # root 1 and root 2
# f_2
# ACF plot
y = ARMAacf(ar = c(phi_1,phi_2), lag.max = 20)	
plot(y, x = 0:20, type = "h", ylim = c(-1,1), xlab = "k", ylab = "Autocorrelation",
     main = "ACF plot for AR(2) with phi_1 = -0.5 and phi_2 = -0.6")
abline(h=0)