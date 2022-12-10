# install.packages(c("kernlab", "nnet", "mice")) # install packages
# install.packages(c("kernlab", "nnet")) # install packages
library(nnet) # load the package
library(kernlab) # load the package
library(RANN) # load the package
library(AppliedPredictiveModeling) # load the package
library(caret) # load the package
library(nnet) # load the package
library(kernlab) # load the package
library(RANN) # load the package
library(AppliedPredictiveModeling) # load the package
library(caret) # load the package
library(mice)
library(tidyr)
library(caret)
library(psych)
library(DescTools)
library(corrplot)
crime <- read.csv("C:\\Users\\Doniyor\\Desktop\\CommViolPredUnnormalizedDataHeaders.txt", na = '?')
set.seed(100)
# remove the non-predictive variables (state code etc)
crimePred = subset(crime, select = -c(1:5))
# removing response variables
crimePred = subset(crimePred, select = -c(nonViolPerPop, 
                                          ViolentCrimesPerPop, 
                                          arsonsPerPop, 
                                          arsons, 
                                          autoTheftPerPop, 
                                          autoTheft, 
                                          larcPerPop, 
                                          larcenies, 
                                          burglPerPop, 
                                          burglaries, 
                                          assaultPerPop, 
                                          assaults, 
                                          robbbPerPop, 
                                          robberies, 
                                          rapesPerPop, 
                                          rapes,
                                          murders, 
                                          murdPerPop))
# choose predictors with less than 1100 NA values
crimePred = crimePred[colSums(is.na(crimePred)) < 1100]
crime = crime[colSums(is.na(crime)) < 1100]
# response variables
crimeResponse = subset(crime, select = c(nonViolPerPop, 
                                         ViolentCrimesPerPop, 
                                         arsonsPerPop, 
                                         arsons, 
                                         autoTheftPerPop, 
                                         autoTheft, 
                                         larcPerPop, 
                                         larcenies, 
                                         burglPerPop, 
                                         burglaries, 
                                         assaultPerPop, 
                                         assaults, 
                                         robbbPerPop, 
                                         robberies, 
                                         rapesPerPop, 
                                         rapes,
                                         murders,
                                         murdPerPop))
# mice imputation
imputedResponse <- mice(crimeResponse,m=5,maxit=50,meth='pmm',seed=50)
completeResponse <- complete(imputedResponse, include = F)
# create a data set
df <- cbind(completeResponse[,c(1,2)],crimePred)
# Drop all NA
sum(is.na(df))
df <- drop_na(df)
sum(is.na(df))
# use df to train models
# train nonlinear models
imputed_predictors <- df[,3:ncol(df)] # get the predictors
response <- df[, 2, drop = F] # get the response variable
smp_size <- floor(0.8 * nrow(df)) # 80% of the sample size
set.seed(100) # set the seed to make your partition reproducible
train_ind <- sample(seq_len(nrow(df)), size = smp_size, replace = FALSE, prob = NULL) # choose indices for training
xtrain <- imputed_predictors[train_ind, , drop = F] # select predictors for the training set
ytrain <- response[train_ind, ] # select responses for the training set
xtest <- imputed_predictors[-train_ind, , drop = F] # select predictors for the test set
ytest <- response[-train_ind, ] # select responses for the test set
# Neural network
# remove highly correlated predictors
tooHigh <- findCorrelation(cor(xtrain), cutoff = .90)
xtrainNN <- xtrain[, -tooHigh]
xtestNN <- xtest[, -tooHigh]
nnetGrid <- expand.grid(.decay = c(0, 0.01, .1), .size = c(1:15), .bag = FALSE) # set ranges for tuning parameters
set.seed(100) # set seed
ctrl <- trainControl(method = "cv", number = 5) # 5-fold CV
nnetTune <- train(xtrainNN, ytrain, method = "avNNet", tuneGrid = nnetGrid, trControl = ctrl, 
                  preProc = c("center", "scale"), linout = TRUE, trace = FALSE, 
                  MaxNWts = 15 * (ncol(xtrainNN) + 1) + 15 + 1, maxit = 500) # train NN model
nnetTune # view trained model
plot(nnetTune) # plot tuned parameters
# Neural net prediction
predicted_nn <- predict(nnetTune, xtestNN) # predict
nnValues <- data.frame(obs = ytest, pred = predicted_nn) # compare test predicted and observed
defaultSummary(nnValues) # summary test
# MARS model
marsGrid <- expand.grid(.degree = 1:2, .nprune = 2:20) # set the range of tuning parameters
ctrl <- trainControl(method = "cv", number = 5) # 5-fold CV
set.seed(100) # fix the seed so that the results can be reproduced
marsTuned <- train(xtrain, ytrain, method = "earth",
                   tuneGrid = marsGrid, trControl = ctrl,
                   preProc = c("center", "scale")) # train MARS model
marsTuned # view trained model
summary(marsTuned) # summary of the trained model
plotmo(marsTuned) # plot the trained model
plot(marsTuned) # plot the parameters tuning
# MARS prediction
predicted_mars <- predict(marsTuned, xtest) # predict
predicted_mars <- as.numeric(predicted_mars) # change to numeric
MARS_values <- data.frame(obs = ytest, pred = predicted_mars) # compare test predicted and observed
defaultSummary(MARS_values) # summary test
# support vector regression
ctrl <- trainControl(method = "cv", number = 5) # 5-fold CV
svmRTuned <- train(xtrain, ytrain, method = "svmRadial", preProc = c("center", "scale"),
                   tuneLength = 14, trControl = ctrl) # train SVM model
svmRTuned # view the trained model
plot(svmRTuned) # plot parameter tuning
ggplot(svmRTuned)+coord_trans(x='log2') # use log2 scale
svmRTuned$finalModel # see the model
# SVM prediction
predicted_svm <- predict(svmRTuned, xtest) # predict
svm_values <- data.frame(obs = ytest, pred = predicted_svm) # compare test predicted and observed
defaultSummary(svm_values) # summary test
# KNN model
ctrl <- trainControl(method = "cv", number = 5) # 5-fold CV
set.seed(100) # set seed
knnTune <- train(xtrain, ytrain, method = "knn", preProc = c("center", "scale"),
                 tuneGrid = data.frame(.k = 1:20), trControl = ctrl) # train KNN model
knnTune # view the trained model
plot(knnTune) # plot tuning parameters
# KNN prediction
predicted_knn <- predict(knnTune, xtest) # predict
knn_values <- data.frame(obs = ytest, pred = predicted_knn) # compare test predicted and observed
defaultSummary(knn_values) # summary test
# variable importance
aa=varImp(svmRTuned) # variable importance object
plot(aa, top = 25, scales = list(y = list(cex = .95))) # variable importance plot
# XGBoost tree model
ctrl <- trainControl(method = "cv", number = 5) # 5-fold CV
set.seed(100) # set seed
XGBTune <- train(xtrain, ytrain, method = "xgbTree", 
                 preProc = c("center", "scale"), trControl = ctrl) # train XGBoost model
XGBTune # view the trained model
plot(XGBTune) # plot tuning parameters
# XGBoost prediction
predicted_XGB <- predict(XGBTune, xtest) # predict
XGB_values <- data.frame(obs = ytest, pred = predicted_XGB) # compare test predicted and observed
defaultSummary(XGB_values) # summary test
