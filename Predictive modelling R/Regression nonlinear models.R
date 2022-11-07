# 7.1
set.seed(100)
x <- runif(100, min = 2, max = 10)
y <- sin(x) + rnorm(length(x)) * .25
sinData <- data.frame(x = x, y = y)
plot(x, y)
## Create a grid of x values to use for prediction
dataGrid <- data.frame(x = seq(2, 10, length = 100))
# a
# install.packages('kernlab')
library(kernlab)
# C = 1, epsilon = 0.01
rbfSVM <- ksvm(x = x, y = y, data = sinData, kernel ="rbfdot", kpar = "automatic", C = 1, epsilon = 0.01)
modelPrediction <- predict(rbfSVM, newdata = dataGrid)
## This is a matrix with one column. We can plot the
## model predictions by adding points to the previous plot
points(x = dataGrid$x, y = modelPrediction[,1], type = "l", col = "red")
## Try other parameters
# C = 1, epsilon = 0.1
rbfSVM <- ksvm(x = x, y = y, data = sinData, kernel ="rbfdot", kpar = "automatic", C = 1, epsilon = 0.1)
modelPrediction <- predict(rbfSVM, newdata = dataGrid)
points(x = dataGrid$x, y = modelPrediction[,1], type = "l", col = "green")
# C = 1, epsilon = 1
rbfSVM <- ksvm(x = x, y = y, data = sinData, kernel ="rbfdot", kpar = "automatic", C = 1, epsilon = 1)
modelPrediction <- predict(rbfSVM, newdata = dataGrid)
points(x = dataGrid$x, y = modelPrediction[,1], type = "l", col = "blue")
legend(x = "bottomright", legend = c("C=1, e=0.01", "C=1, e=0.1", "C=1, e=1"), lty = c(1, 1, 1), col = c(2, 3, 4), lwd = 1) # add a legend
# plot the function
plot(x, y)
dataGrid <- data.frame(x = seq(2, 10, length = 100))
# C = 2^-2, epsilon = 0.01
rbfSVM <- ksvm(x = x, y = y, data = sinData, kernel ="rbfdot", kpar = "automatic", C = 2^-2, epsilon = 0.01)
modelPrediction <- predict(rbfSVM, newdata = dataGrid)
points(x = dataGrid$x, y = modelPrediction[,1], type = "l", col = 2)
# C = 2^-1, epsilon = 0.01
rbfSVM <- ksvm(x = x, y = y, data = sinData, kernel ="rbfdot", kpar = "automatic", C = 2^-1, epsilon = 0.01)
modelPrediction <- predict(rbfSVM, newdata = dataGrid)
points(x = dataGrid$x, y = modelPrediction[,1], type = "l", col = 3)
# C = 2^0, epsilon = 0.01
rbfSVM <- ksvm(x = x, y = y, data = sinData, kernel ="rbfdot", kpar = "automatic", C = 2^0, epsilon = 0.01)
modelPrediction <- predict(rbfSVM, newdata = dataGrid)
points(x = dataGrid$x, y = modelPrediction[,1], type = "l", col = 4)
# C = 2^1, epsilon = 0.01
rbfSVM <- ksvm(x = x, y = y, data = sinData, kernel ="rbfdot", kpar = "automatic", C = 2^1, epsilon = 0.01)
modelPrediction <- predict(rbfSVM, newdata = dataGrid)
points(x = dataGrid$x, y = modelPrediction[,1], type = "l", col = 5)
# C = 2^2, epsilon = 0.01
rbfSVM <- ksvm(x = x, y = y, data = sinData, kernel ="rbfdot", kpar = "automatic", C = 2^2, epsilon = 0.01)
modelPrediction <- predict(rbfSVM, newdata = dataGrid)
points(x = dataGrid$x, y = modelPrediction[,1], type = "l", col = 6)
# C = 2^3, epsilon = 0.01
rbfSVM <- ksvm(x = x, y = y, data = sinData, kernel ="rbfdot", kpar = "automatic", C = 2^3, epsilon = 0.01)
modelPrediction <- predict(rbfSVM, newdata = dataGrid)
points(x = dataGrid$x, y = modelPrediction[,1], type = "l", col = 7)
# C = 2^4, epsilon = 0.01
rbfSVM <- ksvm(x = x, y = y, data = sinData, kernel ="rbfdot", kpar = "automatic", C = 2^4, epsilon = 0.01)
modelPrediction <- predict(rbfSVM, newdata = dataGrid)
points(x = dataGrid$x, y = modelPrediction[,1], type = "l", col = 8)
# C = 2^5, epsilon = 0.01
rbfSVM <- ksvm(x = x, y = y, data = sinData, kernel ="rbfdot", kpar = "automatic", C = 2^5, epsilon = 0.01)
modelPrediction <- predict(rbfSVM, newdata = dataGrid)
points(x = dataGrid$x, y = modelPrediction[,1], type = "l", col = 9)
legend(x = "bottomright", inset = 0, legend = c("C=2^-2, e=0.01","C=2^-1, e=0.01","C=2^0, e=0.01","C=2^1, e=0.01","C=2^2, e=0.01","C=2^3, e=0.01","C=2^4, e=0.01","C=2^5, e=0.01"),
       lty = c(1,1,1,1,1,1,1,1), col = c(2,3,4,5,6,7,8,9), lwd = 1) # add a legend
# plot the function
plot(x, y)
dataGrid <- data.frame(x = seq(2, 10, length = 100))
# C = 2^-1, epsilon = 0.01, kpar = list(sigma = 0)
rbfSVM <- ksvm(x = x, y = y, data = sinData, kernel ="rbfdot", kpar = list(sigma = 0), C = 2^-2, epsilon = 0.01)
modelPrediction <- predict(rbfSVM, newdata = dataGrid)
points(x = dataGrid$x, y = modelPrediction[,1], type = "l", col = 2)
# C = 2^-1, epsilon = 0.01, kpar = list(sigma = 1)
rbfSVM <- ksvm(x = x, y = y, data = sinData, kernel ="rbfdot", kpar = list(sigma = 1), C = 2^-2, epsilon = 0.01)
modelPrediction <- predict(rbfSVM, newdata = dataGrid)
points(x = dataGrid$x, y = modelPrediction[,1], type = "l", col = 3)
# C = 2^-1, epsilon = 0.01, kpar = list(sigma = 2)
rbfSVM <- ksvm(x = x, y = y, data = sinData, kernel ="rbfdot", kpar = list(sigma = 2), C = 2^-2, epsilon = 0.01)
modelPrediction <- predict(rbfSVM, newdata = dataGrid)
points(x = dataGrid$x, y = modelPrediction[,1], type = "l", col = 4)
# C = 2^-1, epsilon = 0.01, kpar = list(sigma = 3)
rbfSVM <- ksvm(x = x, y = y, data = sinData, kernel ="rbfdot", kpar = list(sigma = 15), C = 2^-2, epsilon = 0.01)
modelPrediction <- predict(rbfSVM, newdata = dataGrid)
points(x = dataGrid$x, y = modelPrediction[,1], type = "l", col = 5)
legend(x = "bottomright", inset = 0, legend = c("C=2^-1, e=0.01, sigma = 0","C=2^-1, e=0.01, sigma = 1","C=2^-1, e=0.01, sigma = 2","C=2^-1, e=0.01, sigma = 15"),
       lty = c(1,1,1,1), col = c(2,3,4,5), lwd = 1) # add a legend
# 7.2
# install.packages('earth')
library(earth)
library(mlbench)
library(ggplot2)
library(lattice)
set.seed(200)
trainingData <- mlbench.friedman1(200, sd = 1)
## We convert the 'x' data from a matrix to a data frame
## One reason is that this will give the columns names.
trainingData$x <- data.frame(trainingData$x)
## Look at the data using
featurePlot(trainingData$x, trainingData$y)
## or other methods.
## This creates a list with a vector 'y' and a matrix
## of predictors 'x'. Also simulate a large test set to
## estimate the true error rate with good precision:
testData <- mlbench.friedman1(5000, sd = 1)
testData$x <- data.frame(testData$x)
## Tune several models on these data. For example:
## Fit KNN
library(caret)
knnModel <- train(x = trainingData$x, y = trainingData$y, method = "knn", preProc = c("center", "scale"), tuneLength = 10)
knnModel
plot(knnModel) # plot tuned parameter
knnPred <- predict(knnModel, newdata = testData$x)
## The function 'postResample' can be used to get the test set
## perforamnce values
postResample(pred = knnPred, obs = testData$y)
# a
# MARS model
marsGrid <- expand.grid(.degree = 1:2, .nprune = 2:50) # set tuning parameters
set.seed(100) # Fix the seed so that the results can be reproduced
marsTuned <- train(x = trainingData$x,  y = trainingData$y, method = "earth", 
                   tuneGrid = marsGrid) # train MARS model
marsTuned # see the trained model
summary(marsTuned) # summary of the model
head(predict(marsTuned, testData$x)) # predict test predictors
plotmo(marsTuned) # plot MARS
plot(marsTuned) # plot MARS
# 7.5
# a
# install.packages(c("kernlab", "nnet")) # install packages
library(nnet) # load the package
library(kernlab) # load the package
library(RANN) # load the package
library(AppliedPredictiveModeling) # load the package
library(caret) # load the package
data(ChemicalManufacturingProcess) # get the data
predictors <- ChemicalManufacturingProcess[,2:ncol(ChemicalManufacturingProcess)] # get the predictors
Im <- preProcess(predictors, method=c("knnImpute")) # KNN imputation
imputed_predictors <- predict(Im, predictors) # apply imputation
sum(is.na(predictors)) # number if missing values before imputation
sum(is.na(imputed_predictors)) # number if missing values after imputation
response <- ChemicalManufacturingProcess[, 1, drop = F] # get the response variable
smp_size <- floor(0.8 * nrow(ChemicalManufacturingProcess)) # 80% of the sample size
set.seed(123) # set the seed to make your partition reproducible
train_ind <- sample(seq_len(nrow(ChemicalManufacturingProcess)), size = smp_size, replace = FALSE, prob = NULL) # choose indices for training
xtrain <- imputed_predictors[train_ind, , drop = F] # select predictors for the training set
ytrain <- response[train_ind, ] # select responses for the training set
xtest <- imputed_predictors[-train_ind, , drop = F] # select predictors for the test set
ytest <- response[-train_ind, ] # select responses for the test set
# Neural network
# remove highly correlated predictors
tooHigh <- findCorrelation(cor(xtrain), cutoff = .75)
xtrainNN <- xtrain[, -tooHigh]
xtestNN <- xtest[, -tooHigh]
nnetGrid <- expand.grid(.decay = c(0, 0.01, .1), .size = c(1:10), .bag = FALSE) # set ranges for tuning parameters
set.seed(100) # set seed
ctrl <- trainControl(method = "cv", number = 3) # 3-fold CV
nnetTune <- train(xtrainNN, ytrain, method = "avNNet", tuneGrid = nnetGrid, trControl = ctrl, 
                  preProc = c("center", "scale"), linout = TRUE, trace = FALSE, 
                  MaxNWts = 10 * (ncol(xtrainNN) + 1) + 10 + 1, maxit = 500) # train NN model
nnetTune # view trained model
plot(nnetTune) # plot tuned parameters
# MARS model
marsGrid <- expand.grid(.degree = 1:2, .nprune = 2:50) # set the range of tuning parameters
ctrl <- trainControl(method = "cv", number = 3) # 3-fold CV
set.seed(100) # fix the seed so that the results can be reproduced
marsTuned <- train(xtrain, ytrain, method = "earth",
                   tuneGrid = marsGrid, trControl = ctrl) # train MARS model
marsTuned # view trained model
summary(marsTuned) # summary of the trained model
plotmo(marsTuned) # plot the trained model
plot(marsTuned) # plot the parameters tuning
# support vector regression
ctrl <- trainControl(method = "cv", number = 3) # 3-fold CV
svmRTuned <- train(xtrain, ytrain, method = "svmRadial", preProc = c("center", "scale"),
                   tuneLength = 14, trControl = ctrl) # train SVM model
svmRTuned # view the trained model
plot(svmRTuned) # plot parameter tuning
ggplot(svmRTuned)+coord_trans(x='log2') # use log2 scale
svmRTuned$finalModel # see the model
# KNN model
ctrl <- trainControl(method = "cv", number = 3) # 3-fold CV
set.seed(100) # set seed
knnTune <- train(xtrain, ytrain, method = "knn", preProc = c("center", "scale"),
                 tuneGrid = data.frame(.k = 1:20), trControl = ctrl) # train KNN model
knnTune # view the trained model
plot(knnTune) # plot tuning parameters
# Neural net prediction
predicted_nn <- predict(nnetTune, xtestNN) # predict
nnValues <- data.frame(obs = ytest, pred = predicted_nn) # compare test predicted and observed
defaultSummary(nnValues) # summary test
# MARS prediction
predicted_mars <- predict(marsTuned, xtest) # predict
predicted_mars <- as.numeric(predicted_mars) # change to numeric
MARS_values <- data.frame(obs = ytest, pred = predicted_mars) # compare test predicted and observed
defaultSummary(MARS_values) # summary test
# SVM prediction
predicted_svm <- predict(svmRTuned, xtest) # predict
svm_values <- data.frame(obs = ytest, pred = predicted_svm) # compare test predicted and observed
defaultSummary(svm_values) # summary test
# KNN prediction
predicted_knn <- predict(knnTune, xtest) # predict
knn_values <- data.frame(obs = ytest, pred = predicted_knn) # compare test predicted and observed
defaultSummary(knn_values) # summary test
# b
aa=varImp(svmRTuned) # variable importance object
plot(aa, top = 25, scales = list(y = list(cex = .95))) # variable importance plot

