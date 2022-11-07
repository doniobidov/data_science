# a
install.packages("mlbench")
install.packages("PerformanceAnalytics")
install.packages("caret")
library(mlbench)
library(PerformanceAnalytics)
library(caret)
data(Glass)
str(Glass)
attach(Glass) # attach Glass data frame
Glass_predictors = Glass[,1:9] # select all the predictors
chart.Correlation(Glass_predictors, histogram = TRUE, method = "pearson") # correlation chart of all the predictors
mtext("Correlation chart of all the predictors: scatter plots, histograms, and Pearson correlation coefficients", side=3, line=3) # add the title
par(mfrow = c(1,3)) # plot in a 1x3 grid
bp1 = boxplot(Glass_predictors[c("RI", "Mg", "Al", "K", "Ba", "Fe")], xlab="Predictors", ylab="Refractive index and percentages of elements", main="Boxplots of the predictors") # box plot
bp2 = boxplot(Glass_predictors[c("Na", "Ca")], xlab="Predictors", ylab="Refractive index and percentages of elements", main="Boxplots of the predictors") # box plot
bp3 = boxplot(Glass_predictors[c("Si")], xlab="Predictors", ylab="Refractive index and percentages of elements", main="Boxplots of the predictors") # box plot
skew = skewness(Glass_predictors) # calculate coefficients of skewness
# transform_Ca = BoxCoxTrans(Glass_predictors$Ca) # Box and Cox transformation
# new_Ca = predict(transform_Ca, Glass_predictors$Ca) # apply the transformation to Ca
# skewness(Ca) # skewness coefficient of Ca before Box and Cox transformation
# skewness(new_Ca) # skewness coefficient of Ca before Box and Cox transformation
# new_Ca = scale(new_Ca, center = TRUE, scale = TRUE) # center and scale Ca after Box and Cox
# new_Ca = spatialSign(new_Ca) # Apply spatial sign transformation to normalized Ca
# par(mfrow = c(1,2)) # plot in a 1x2 grid
# hist(Glass_predictors$Ca, xlab = "Ca content in the glass (%)", main = "Histogram of Ca before any transformation", col = "LightBlue") # histogram of Ca before any transformation
# hist(new_Ca, xlab = "Ca content in the glass", main = "Histogram of Ca after all the transformation", col = "Red") # histogram of Ca after 3 transformations
new_Glass_0 = Glass_predictors + 1 # move values away from zero
transform_1 = preProcess(new_Glass_0, method=c("BoxCox")) # BoxCox transform
new_Glass_1 = predict(transform_1, new_Glass_0) # apply transformations
transform_2 = preProcess(new_Glass_1, method=c("center","scale","knnImpute")) # center, scale, and kNN impute
new_Glass_2 = predict(transform_2, new_Glass_1) # apply transformations
transform_3 = preProcess(new_Glass_2, method=c("spatialSign")) # spatial sign transform
new_Glass_3 = predict(transform_3, new_Glass_2) # apply transformations
par(mfrow = c(3,4)) # plot in a 3x4 grid
# RI
hist(Glass_predictors$RI, xlab = paste0("RI, skewness: ", skewness(Glass_predictors$RI)), main = "Histogram of RI before BoxCox", col = "Red")
hist(new_Glass_1$RI, xlab = paste0("RI, skewness: ", skewness(new_Glass_1$RI)), main = "Histogram of RI after BoxCox", col = "Green")
boxplot(new_Glass_1$RI, xlab = "RI", main = "Boxplot of RI before center, scale, kNN impute, and spatial sign", col = "Red")
boxplot(new_Glass_3$RI, xlab = "RI", main = "Boxplot of RI after center, scale, kNN impute, and spatial sign", col = "Green")
# Na
hist(Glass_predictors$Na, xlab = paste0("Na, skewness: ", skewness(Glass_predictors$Na)), main = "Histogram of Na before BoxCox", col = "Red")
hist(new_Glass_1$Na, xlab = paste0("Na, skewness: ", skewness(new_Glass_1$Na)), main = "Histogram of Na after BoxCox", col = "Green")
boxplot(new_Glass_1$Na, xlab = "Na", main = "Boxplot of Na before center, scale, kNN impute, and spatial sign", col = "Red")
boxplot(new_Glass_3$Na, xlab = "Na", main = "Boxplot of Na after center, scale, kNN impute, and spatial sign", col = "Green")
# Mg
hist(Glass_predictors$Mg, xlab = paste0("Mg, skewness: ", skewness(Glass_predictors$Mg)), main = "Histogram of Mg before BoxCox", col = "Red")
hist(new_Glass_1$Mg, xlab = paste0("Mg, skewness: ", skewness(new_Glass_1$Mg)), main = "Histogram of Mg after BoxCox", col = "Green")
boxplot(new_Glass_1$Mg, xlab = "Mg", main = "Boxplot of Mg before center, scale, kNN impute, and spatial sign", col = "Red")
boxplot(new_Glass_3$Mg, xlab = "Mg", main = "Boxplot of Mg after center, scale, kNN impute, and spatial sign", col = "Green")
par(mfrow = c(3,4)) # plot in a 3x4 grid
# Al
hist(Glass_predictors$Al, xlab = paste0("Al, skewness: ", skewness(Glass_predictors$Al)), main = "Histogram of Al before BoxCox", col = "Red")
hist(new_Glass_1$Al, xlab = paste0("Al, skewness: ", skewness(new_Glass_1$Al)), main = "Histogram of Al after BoxCox", col = "Green")
boxplot(new_Glass_1$Al, xlab = "Al", main = "Boxplot of Al before center, scale, kNN impute, and spatial sign", col = "Red")
boxplot(new_Glass_3$Al, xlab = "Al", main = "Boxplot of Al after center, scale, kNN impute, and spatial sign", col = "Green")
# Si
hist(Glass_predictors$Si, xlab = paste0("Si, skewness: ", skewness(Glass_predictors$Si)), main = "Histogram of Si before BoxCox", col = "Red")
hist(new_Glass_1$Si, xlab = paste0("Si, skewness: ", skewness(new_Glass_1$Si)), main = "Histogram of Si after BoxCox", col = "Green")
boxplot(new_Glass_1$Si, xlab = "Si", main = "Boxplot of Si before center, scale, kNN impute, and spatial sign", col = "Red")
boxplot(new_Glass_3$Si, xlab = "Si", main = "Boxplot of Si after center, scale, kNN impute, and spatial sign", col = "Green")
# K
hist(Glass_predictors$K, xlab = paste0("K, skewness: ", skewness(Glass_predictors$K)), main = "Histogram of K before BoxCox", col = "Red")
hist(new_Glass_1$K, xlab = paste0("K, skewness: ", skewness(new_Glass_1$K)), main = "Histogram of K after BoxCox", col = "Green")
boxplot(new_Glass_1$K, xlab = "K", main = "Boxplot of K before center, scale, kNN impute, and spatial sign", col = "Red")
boxplot(new_Glass_3$K, xlab = "K", main = "Boxplot of K after center, scale, kNN impute, and spatial sign", col = "Green")
par(mfrow = c(3,4)) # plot in a 3x4 grid
# Ca
hist(Glass_predictors$Ca, xlab = paste0("Ca, skewness: ", skewness(Glass_predictors$Ca)), main = "Histogram of Ca before BoxCox", col = "Red")
hist(new_Glass_1$Ca, xlab = paste0("Ca, skewness: ", skewness(new_Glass_1$Ca)), main = "Histogram of Ca after BoxCox", col = "Green")
boxplot(new_Glass_1$Ca, xlab = "Ca", main = "Boxplot of Ca before center, scale, kNN impute, and spatial sign", col = "Red")
boxplot(new_Glass_3$Ca, xlab = "Ca", main = "Boxplot of Ca after center, scale, kNN impute, and spatial sign", col = "Green")
# Ba
hist(Glass_predictors$Ba, xlab = paste0("Ba, skewness: ", skewness(Glass_predictors$Ba)), main = "Histogram of Ba before BoxCox", col = "Red")
hist(new_Glass_1$Ba, xlab = paste0("Ba, skewness: ", skewness(new_Glass_1$Ba)), main = "Histogram of Ba after BoxCox", col = "Green")
boxplot(new_Glass_1$Ba, xlab = "Ba", main = "Boxplot of Ba before center, scale, kNN impute, and spatial sign", col = "Red")
boxplot(new_Glass_3$Ba, xlab = "Ba", main = "Boxplot of Ba after center, scale, kNN impute, and spatial sign", col = "Green")
# Fe
hist(Glass_predictors$Fe, xlab = paste0("Fe, skewness: ", skewness(Glass_predictors$Fe)), main = "Histogram of Fe before BoxCox", col = "Red")
hist(new_Glass_1$Fe, xlab = paste0("Fe, skewness: ", skewness(new_Glass_1$Fe)), main = "Histogram of Fe after BoxCox", col = "Green")
boxplot(new_Glass_1$Fe, xlab = "Fe", main = "Boxplot of Fe before center, scale, kNN impute, and spatial sign", col = "Red")
boxplot(new_Glass_3$Fe, xlab = "Fe", main = "Boxplot of Fe after center, scale, kNN impute, and spatial sign", col = "Green")
# b
library(mlbench)
data("Soybean")
attach(Soybean) # attach Soybean data frame
par(mfrow = c(5,4)) # plot in a 5x4 grid
for (i in colnames(Soybean[,0:20])) {
  barplot(100*prop.table(table(Soybean[[i]])), main=paste0("Barplot of relative frequencies of a predictor ", i), xlab="Predictor levels", ylab="Frequency (%)", ylim = c(0, 100), yaxt="n")
  axis(2, at = seq(0, 100, 10))
} # plot relative bar plot of each predictor
par(mfrow = c(4,4)) # plot in a 4x4 grid
for (i in colnames(Soybean[,21:36])) {
  barplot(100*prop.table(table(Soybean[[i]])), main=paste0("Barplot of relative frequencies of a predictor ", i), xlab="Predictor levels", ylab="Frequency (%)", ylim = c(0, 100), yaxt="n")
  axis(2, at = seq(0, 100, 10))
} # plot relative bar plot of each predictor
100*prop.table(table(leaf.malf)) # relative frequencies of levels of leaf.malf
100*prop.table(table(leaf.mild)) # relative frequencies of levels of leaf.mild  
100*prop.table(table(mycelium)) # relative frequencies of levels of mycelium
100*prop.table(table(sclerotia)) # relative frequencies of levels of sclerotia
sapply(Soybean, function(x) sum(is.na(x))) # count missing values for each predictor
sum(sapply(Soybean[Soybean$Class=='phytophthora-rot'], function(x) sum(is.na(x))))
for (class in unique(Class)) {
  count = sum(sapply(Soybean[Soybean$Class==class], function(x) sum(is.na(x))))
  print(paste0("Number of missing values in Class ", class, ": ", count))
} # count the number of missing values for each unique value of the variable Class
nearZeroVar(Soybean)
Soybean[,19]
# c
library(caret)
library(corrplot)
data(BloodBrain)
correlations <- cor(bbbDescr) # calculate the correlations between predictor variables
corrplot(correlations, order = "hclust", tl.cex = 0.5) # correlation plot
highCorr <- findCorrelation(correlations, cutoff = .85) # for a given threshold of pairwise correlations, returns column numbers (predictors) that are recommended for deletion
length(highCorr) # number of predictors for deletion
highCorr # predictors recommended for deletion
filteredData <- bbbDescr[, -highCorr] # delete the predictors
length(filteredData) # number of remaining predictors
