# set up working directory

# import and read csv file
stores  <- read.csv('C:\\Users\\Doniyor\\Desktop\\Stores_Meters.csv', stringsAsFactors = TRUE) # change the directory to your own
# checking the file
str(stores)
summary(stores)
head(stores)
# work with stores data
attach(stores)

# Histogram of numerical data
hist(Store_Area, xlab = "Store Area (sq yd)", main = "Histogram of Store Area", labels = TRUE, col = "LightBlue")
hist(Items_Available, xlab = "Items Available", main = "Histogram of Items Available", labels = TRUE, col = "LightBlue")
hist(Daily_Customer_Count, xlab = "Daily Customer Count", main = "Histogram of Daily Customer Count", labels = TRUE, col = "LightBlue")
hist(Store_Sales, xlab = "Store Sales (US dollars)", main = "Histogram of Store Sales in US Dollars", labels = TRUE, col = "LightBlue")

# Data devided into store size
small = stores[stores$Store_Size == "Small",]; small
medium = stores[stores$Store_Size == "Medium",]; medium
large = stores[stores$Store_Size == "Large",]; large

# Min & Max Value of different store sizes
min_sma = min(small$Store_Sales)
max_sma = max(small$Store_Sales)
min_med = min(medium$Store_Sales)
max_med = max(medium$Store_Sales)
min_lar = min(large$Store_Sales)
max_lar = max(large$Store_Sales)

# Histogram of large, medium, and small stores
options(scipen = 999)
hist(small$Store_Sales, xlab = "Store Sales (US dollars)", main = "Histogram of Sales of Small Stores in US Dollars", labels = TRUE, col = "LightBlue")
hist(medium$Store_Sales, xlab = "Store Sales (US dollars)", main = "Histogram of Sales of Medium Stores in US Dollars", labels = TRUE, col = "LightBlue", ylim = c(0,100))
hist(large$Store_Sales, xlab = "Store Sales (US dollars)", main = "Histogram of Sales of Large Stores in US Dollars", labels = TRUE, col = "LightBlue", ylim = c(0,100))

# Summary Statistic: Store Sales
table(Store_Size)
aggregate(Store_Sales~Store_Size, FUN = mean)
aggregate(Store_Sales~Store_Size, FUN = median)
aggregate(Store_Sales~Store_Size, FUN = sd)

# Summary Statistic: Daily Customer Count
table(Store_Size)
aggregate(Daily_Customer_Count~Store_Size, FUN = mean)
aggregate(Daily_Customer_Count~Store_Size, FUN = median)
aggregate(Daily_Customer_Count~Store_Size, FUN = sd)

# Skewness
install.packages("moments")
library("moments")
skewness(Daily_Customer_Count)
skewness(Store_Sales)
skewness(medium$Store_Sales)
skewness(large$Store_Sales)


# Boxplot of Store Sales According to Store Size
boxplot(Store_Sales~Store_Size, xlab = "Store Size", ylab = "Store Sale (US Dollars)",
         main = "Store Sales According to Store Size",
         col = c("Orchid", "LightBlue", "LightGreen"))
boxplot(Daily_Customer_Count~Store_Size, xlab = "Store Size", ylab = "Daily Customer",
        main = "Daily Customers According to Store Size",
        col = c("Orchid", "LightBlue", "LightGreen"))

# Scatter Plots
# Store Sales vs Items Available
plot(Items_Available, Store_Sales, xlab = "Items Available", ylab = "Store Sales (US Dollars)",
      main = "Store Sales vs Items Available", col = "Blue")
# Daily Customers vs Items Available
plot(Items_Available, Daily_Customer_Count, xlab = "Items Available", ylab = "Daily Customer",
     main = "Daily Customer vs Items Available", col = "Orchid")
#Store Sales vs Daily Customer
plot(Daily_Customer_Count, Store_Sales,  xlab = "Daily Customer", ylab = "Store Sales (US Dollars)",
     main = "Store Sales vs Daily Customer", col = "Orange")

#Bar Plots
stores.tab <- sort(table(Store_Size))
stores.tab
barplot(stores.tab, legend.text = TRUE, xlab = "Store Size", ylab = "Number of Stores",
         main = "Bar Plot of Store Size", ylim = c(0,500), col = c("LightGreen", "Orchid", "LightBlue"))


## One-Way ANOVA 

# Question 1: Do large stores have more sales than medium or small stores?

    ## Assessing Normality
        # normal q-q plots of all of the residuals together
        Store_Size.res = residuals(aov(Store_Sales~Store_Size))
        Store_Size.res
        qqnorm(Store_Size.res)
        qqline(Store_Size.res)
        
        # Shapiro-Wilk test: p-value
        shapiro.test(Store_Size.res)
        # small p-value - reject H_0 of Shapiro-wilk test: not normal population of residuals 
    
    ## Assessing Homoscedasticity Assumption
        # Hypothesis test for Homogeneity of Variance
        # Levene's Test
        anova(aov(Store_Size.res^2~Store_Size))
        # p-value large => retain H_0 => does not verify homoscedasticity yet
        
        # Recommendation: perform Levene's test along with a visual inspection of a boxplot of residuals
        boxplot(Store_Size.res~Store_Size, xlab = "Store Size", ylab = "Store Size Residuals", main = "Store Size Residuals According to Store Size",
                col = c("Orchid", "LightBlue", "LightGreen"))
        
        # Graphical Displays
        # scatter plot of residuals plotted against the fitted values from the model
        Store_Size.fit = fitted.values(aov(Store_Sales~Store_Size))
        Store_Size.fit
        plot(x = Store_Size.fit, y = Store_Size.res, xlab="Store Sales ~ Store Size Fitted Values", ylab="Store sales ~ Store Size Residuals", main="Scatter Plot of Residuals Plotted against the Fitted Values", ylim = c(-50000, 55000), xlim = c(57000, 64000), axes = FALSE) # plot residuals always along y-axis
        axis(1, at = seq(57000, 64000, 1000))
        axis(2, at = seq(-50000, 55000, 5000))
        
        # scatter plot with studentized residuals: residuals devided by their root mean square 
        aov(Store_Sales~Store_Size)   # to get root mean square = residual std error
        root.MSE = 17180.96
        Store_Size.studres = Store_Size.res/root.MSE
        plot(x = Store_Size.fit, y = Store_Size.studres, xlab="Store Sales ~ Store Size Fitted Values", ylab="Store Sales ~ Store Size Studentized Residuals", main="Scatter Plot of Studentized Residuals Plotted against the Fitted Values", ylim = c(-3, 4), xlim = c(57000, 64000), axes = FALSE)
        axis(1, at = seq(57000, 64000, 1000))
        axis(2, at = seq(-3, 4, 1))
        
    ## Performing One-Way ANOVA
        anova(aov(Store_Sales~Store_Size))
        
    ## Post Hoc Multiple Comparison
        TukeyHSD(aov(Store_Sales~Store_Size))
   
             
  # Question 2: Do large stores have more customers than medium or small stores?
        
     ## Assessing Normality
        # normal q-q plots of all of the residuals together
        Store_Size.res2 = residuals(aov(Daily_Customer_Count~Store_Size))
        Store_Size.res2
        qqnorm(Store_Size.res2)
        qqline(Store_Size.res2)
        
        # Shapiro-Wilk test: p-value
        shapiro.test(Store_Size.res2)
        # small p-value - reject H_0 of Shapiro-wilk test: not normal population of residuals  
        
     ## Assessing Homoscedasticity
        # Hypothesis test for Homogeneity of Variance
        # Levene's Test
        anova(aov(Store_Size.res2^2~Store_Size))
        # p-value large => retain H_0 => does not verify homoscedasticity yet
        
        # Recommendation: perform Levene's test along with a visual inspection of a boxplot of residuals
        boxplot(Store_Size.res2~Store_Size, xlab = "Store Size", ylab = "Store Size Residuals", main = "Store Size Residuals According to Store Size",
                col = c("Orchid", "LightBlue", "LightGreen"))
        
        # Graphical Displays
        # scatter plot of residuals plotted against the fitted values from the model
        Store_Size.fit2 = fitted.values(aov(Daily_Customer_Count~Store_Size))
        Store_Size.fit2
        plot(x = Store_Size.fit2, y = Store_Size.res2, xlab="Daily Customer Count ~ Store Size Fitted Values", ylab="Daily Customer Count ~ Store Size Residuals", main="Scatter Plot of Residuals Plotted against the Fitted Values", ylim = c(-800, 800), xlim = c(780, 815), axes = FALSE)    # plot residuals always along y-axis
        axis(1, at = seq(780, 815, 5))
        axis(2, at = seq(-800, 800, 100))
        
        # scatter plot with studentized residuals: residuals devided by their root mean square 
        aov(Daily_Customer_Count~Store_Size)   # to get root mean square = residual std error
        root.MSE2 = 265.4382
        Store_Size.studres2 = Store_Size.res2/root.MSE2
        plot(x = Store_Size.fit2, y = Store_Size.studres2, xlab="Daily Customer Count ~ Store Size Fitted Values", ylab="Daily Customer Count ~ Store Size Residuals", main="Scatter Plot of Studentized Residuals Plotted against the Fitted Values", ylim = c(-3, 3), xlim = c(780, 815), axes = FALSE)    # plot residuals always along y-axis
        axis(1, at = seq(780, 815, 5))
        axis(2, at = seq(-3, 3, 1))
        
      ## Performing One-Way ANOVA
        anova(aov(Daily_Customer_Count~Store_Size))
        
      ## Post Hoc Multiple Comparison
        TukeyHSD(aov(Daily_Customer_Count~Store_Size))
 