#6.1
#b
# install.packages('factoextra')
library(caret) # load caret
library(ggplot2) # load ggplot2
library(factoextra) # load factoextra
data(tecator) # use ?tecator to see more details
absorp <- as.data.frame(absorp, row.names = NULL, optional = FALSE) # turn predictors into a data set
endpoints <- as.data.frame(endpoints, row.names = NULL, optional = FALSE) # turn responses into a data set
endpoints_fat <- endpoints[,2, drop = F] # df for fat response
pcaObject <- prcomp(absorp, center = TRUE, scale. = TRUE) # center, scale, and perform PCA
var_explained = pcaObject$sdev^2 / sum(pcaObject$sdev^2) #calculate total variance explained by each principal component
#create scree plot
qplot(c(1:100), var_explained) + 
  geom_line() + 
  xlab("Principal Component") + 
  ylab("Variance Explained") +
  ggtitle("Scree Plot") +
  ylim(0, 1)
fviz_eig(pcaObject) #create another scree plot
trans <- preProcess(absorp, method = c("center", "scale", "pca"), thresh = 0.95) # perform center, scale, and PCA transformations
transformed <- predict(trans, absorp) # apply the transformations
one_pca <- transformed[,1, drop = F] # select 1 PC
#c
smp_size <- floor(0.8 * nrow(endpoints_fat)) ## 80% of the sample size
set.seed(123) # set the seed to make your partition reproducible
train_ind <- sample(seq_len(nrow(endpoints_fat)), size = smp_size, replace = FALSE, prob = NULL) # choose indices for training
xtrain <- one_pca[train_ind, , drop = F] # select PC predictors for the training set
ytrain <- endpoints_fat[train_ind, ] # select responses for the training set
xtest <- one_pca[-train_ind, , drop = F] # select PC predictors for the test set
ytest <- endpoints_fat[-train_ind, ] # select responses for the test set
ctrl <- trainControl(method = "cv", number = 3) # 3-fold CV
set.seed(100) # set the seed
lmFit <- train(x = xtrain, y = ytrain, method = "lm", trControl = ctrl) # fit a linear model
lmFit # see the model
# d
lmPred <- predict(lmFit, xtest) # predict on the testing set
lmValues <- data.frame(obs =  ytest, pred = lmPred) # compare test observations and lm predictions on the test set
defaultSummary(lmValues) # find RMSE and R^2
#6.2
#b
# install.packages("pls") # install the package
library(pls) # load the package
library(AppliedPredictiveModeling) # load the package
data(permeability) # load the data
ncol(fingerprints) # original number of predictors
zero_var <- nearZeroVar(fingerprints) # return indices for near-zero variance categorical predictors
length(zero_var) # number of categorical predictors to be removed
predictors <- fingerprints[, -zero_var]
ncol(predictors) # number of predictors after removing near-zero variance categorical predictors
#c
smp_size <- floor(0.8 * nrow(permeability)) ## 80% of the sample size
set.seed(123) # set the seed to make your partition reproducible
train_ind <- sample(seq_len(nrow(permeability)), size = smp_size, replace = FALSE, prob = NULL) # choose indices for training
xtrain <- predictors[train_ind, , drop = F] # select predictors for the training set
ytrain <- permeability[train_ind, ] # select responses for the training set
xtest <- predictors[-train_ind, , drop = F] # select predictors for the test set
ytest <- permeability[-train_ind, ] # select responses for the test set
set.seed(100) # set the seed
ctrl <- trainControl(method = "cv", number = 3) # 3-fold CV
plsTune <- train(xtrain, ytrain, method = "pls", tuneLength = 30, 
                 trControl = ctrl, preProc = c("center", "scale")) # train PLS
plsTune # view the PLS model summary
plot(plsTune) # plot of number of components vs RMSE
#d
predicted<-predict(plsTune, xtest) # predict using test set predictor values
lmValues <- data.frame(obs = ytest, pred = predicted) # compare test set predicted and observed values
defaultSummary(lmValues) # model performance summary on the test set
#6.3
#b
# install.packages('RANN') # install the package
library(RANN) # load the package
library(AppliedPredictiveModeling) # load the package
library(caret) # load the package
data(ChemicalManufacturingProcess) # get the data
predictors <- ChemicalManufacturingProcess[,2:ncol(ChemicalManufacturingProcess)] # get the predictors
Im <- preProcess(predictors, method=c("knnImpute")) # KNN imputation
imputed_predictors <- predict(Im, predictors) # apply imputation
sum(is.na(predictors)) # number if missing values before imputation
sum(is.na(imputed_predictors)) # number if missing values after imputation
#c
# install.packages(c("elasticnet", "lars")) # install packages
library("elasticnet") # load package
library("lars") # load package
response <- ChemicalManufacturingProcess[, 1, drop = F] # get the response variable
smp_size <- floor(0.8 * nrow(ChemicalManufacturingProcess)) ## 80% of the sample size
set.seed(123) # set the seed to make your partition reproducible
train_ind <- sample(seq_len(nrow(ChemicalManufacturingProcess)), size = smp_size, replace = FALSE, prob = NULL) # choose indices for training
xtrain <- imputed_predictors[train_ind, , drop = F] # select predictors for the training set
ytrain <- response[train_ind, ] # select responses for the training set
xtest <- imputed_predictors[-train_ind, , drop = F] # select predictors for the test set
ytest <- response[-train_ind, ] # select responses for the test set
# linear model
ctrl <- trainControl(method = "cv", number = 3) # 3-fold CV
set.seed(100) # set the seed
lmFit <- train(x = xtrain, y = ytrain, method = "lm", trControl = ctrl) # fit linear regression
lmFit # linear model summary
# ridge model
ridgeGrid <- data.frame(.lambda = seq(0, .30, length = 31)) # set values for lambda
set.seed(100) # set the seed
ctrl <- trainControl(method = "cv", number = 3) # 3-fold CV
ridgeRegFit <- train(xtrain, ytrain, method = "ridge", 
                     tuneGrid = ridgeGrid, trControl = ctrl,
                     preProc = c("center", "scale")) # fit ridge linear regression
ridgeRegFit # ridge model summary
plot(ridgeRegFit) # plot of tuned parameters
# lasso model
ctrl <- trainControl(method = "cv", number = 3) # 3-fold CV
enetGrid <- expand.grid(.lambda = 0, .fraction = seq(.05, 1, length = 20)) # lasso grid
set.seed(100) # set the seed
lassoTune <- train(xtrain, ytrain, method = "enet", 
                  tuneGrid = enetGrid, trControl = ctrl,
                  preProc = c("center", "scale")) # fit lasso linear regression
lassoTune # view model summary
plot(lassoTune) # plot of tuned parameters
# elastic net
enetGrid <- expand.grid(.lambda = c(0, 0.01, .1), .fraction = seq(.05, 1, length = 20)) # set e-net grid
set.seed(100) # set the seed
enetTune <- train(xtrain, ytrain, method = "enet", 
                  tuneGrid = enetGrid, trControl = ctrl,
                  preProc = c("center", "scale"))
enetTune # view model summary
plot(enetTune) # plot of tuned parameters
#d
# Linear model
predicted_linear <- predict(lmFit, xtest) # predict
lmValues <- data.frame(obs = ytest, pred = predicted_linear) # compare test predicted and observed
defaultSummary(lmValues) # summary test
# Ridge
predicted_ridge <- predict(ridgeRegFit, xtest) # predict
ridgeValues <- data.frame(obs = ytest, pred = predicted_ridge) # compare test predicted and observed
defaultSummary(ridgeValues) # summary test
# Lasso
predicted_lasso <- predict(lassoTune, xtest) # predict
lassoValues <- data.frame(obs = ytest, pred = predicted_lasso) # compare test predicted and observed
defaultSummary(lassoValues) # summary test
# E-Net
predicted_elastic <- predict(enetTune, xtest) # predict
enetValues <- data.frame(obs = ytest, pred = predicted_elastic) # compare test predicted and observed
defaultSummary(enetValues) # summary test
#f
plot(varImp(enetTune), top=15) # variable importance plot for the elastic net model