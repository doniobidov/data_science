# 13.1
# a
# install.packages(c("glmnet","pamr","rms","sparseLDA","subselect","pROC","klaR"))
library(caret)
library(AppliedPredictiveModeling)
library(pROC)
library(kernlab)
library(klaR)
data(hepatic)
# use ?hepatic to see more details
# get count of each level of the response variable
summary(injury)
# str(bio)
# split into train/validation and test sets (80/20) using stratified random sampling
set.seed(123)
train_ind <- createDataPartition(injury, p = .80, list= FALSE)
xtrain <- bio[train_ind, , drop = F]
ytrain <- injury[train_ind]
xtest <- bio[-train_ind, , drop = F]
ytest <- injury[-train_ind]
# bar plots of the full response, train response, and test response
barplot(table(injury))
barplot(table(ytrain))
barplot(table(ytest))
# train quadratic discriminant analysis
ctrl <- trainControl(method = "LGOCV",
                     summaryFunction = defaultSummary,
                     classProbs = TRUE,
                     savePredictions = TRUE)
set.seed(476)
qdaFit <- train(xtrain, 
                ytrain,
                method = "qda",
                metric = "Kappa",
                trControl = ctrl,
                preProc = c("zv","corr","center","scale"))
# the trained model's summary
qdaFit
plot(qdaFit)
# predict
predicted_qda <- predict(qdaFit, xtest)
q <- data.frame(obs = ytest, pred = predicted_qda)
defaultSummary(qdaValues)
confusionMatrix(data = predicted_qda, reference = ytest)
# train regularized discriminant analysis
ctrl <- trainControl(method = "LGOCV",
                     summaryFunction = defaultSummary,
                     classProbs = TRUE,
                     savePredictions = TRUE)
set.seed(476)
rdaGrid = expand.grid(.gamma = c(0, .001, .002, .004, .006, .008, .01),
                      .lambda = c(0, .001, .002, .004, .006, .008, .01))
rdaFit <- train(xtrain, 
                ytrain,
                method = "rda",
                metric = "Kappa",
                tuneGrid = rdaGrid,
                trControl = ctrl,
                preProc = c("zv","corr","center","scale"))
# the trained model's summary
rdaFit
confusionMatrix(data = rdaFit$pred$pred,
                reference = rdaFit$pred$obs)
plot(rdaFit)
# predict
predicted_rda <- predict(rdaFit, xtest)
rdaValues <- data.frame(obs = ytest, pred = predicted_rda)
defaultSummary(rdaValues)
confusionMatrix(data = predicted_rda, reference = ytest)
# train mixture discriminant analysis
ctrl <- trainControl(method = "LGOCV",
                     summaryFunction = defaultSummary,
                     classProbs = TRUE,
                     savePredictions = TRUE)
set.seed(476)
mdaGrid = expand.grid(.subclasses = 1:3)
mdaFit <- train(xtrain, 
                ytrain,
                method = "mda",
                metric = "Kappa",
                tuneGrid = mdaGrid,
                trControl = ctrl,
                preProc = c("zv","corr","center","scale"))
# the trained model's summary
mdaFit
confusionMatrix(data = mdaFit$pred$pred,
                reference = mdaFit$pred$obs)
plot(mdaFit)
# predict
predicted_mda <- predict(mdaFit, xtest)
mdaValues <- data.frame(obs = ytest, pred = predicted_mda)
defaultSummary(mdaValues)
confusionMatrix(data = predicted_mda, reference = ytest)
# train neural network
nnetGrid <- expand.grid(.size = 1:10, .decay = c(0, .1, 1, 2))
maxSize <- max(nnetGrid$.size)
numWts <- (maxSize * (184 + 1) + (maxSize+1)*2) #184 is the number of predictors
set.seed(476)
ctrl <- trainControl(method = "LGOCV",
                     summaryFunction = defaultSummary,
                     classProbs = TRUE,
                     savePredictions = TRUE)
nnetFit <- train(xtrain, 
                 ytrain,
                 method = "nnet",
                 metric = "Kappa",
                 preProc = c("zv","corr","center","scale"),
                 tuneGrid = nnetGrid,
                 trace = FALSE,
                 maxit = 2000,
                 MaxNWts = numWts,
                 trControl = ctrl)
# the trained model's summary
nnetFit
plot(nnetFit)
# predict
predicted_nnet <- predict(nnetFit, xtest)
nnetValues <- data.frame(obs = ytest, pred = predicted_nnet)
defaultSummary(nnetValues)
confusionMatrix(data = predicted_nnet, reference = ytest)
# train flexible discriminant analysis
marsGrid <- expand.grid(.degree = 1:2, .nprune = 2:20)
set.seed(476)
ctrl <- trainControl(method = "LGOCV",
                     summaryFunction = defaultSummary,
                     classProbs = TRUE,
                     savePredictions = TRUE)
fdaTuned <- train(xtrain, 
                  ytrain,
                  metric = "Kappa",
                  method = "fda",
                  tuneGrid = marsGrid,
                  trControl = ctrl,
                  preProc = c("zv","center","scale"))
# the trained model's summary
fdaTuned
plot(fdaTuned)
# predict
predicted_fda <- predict(fdaTuned, xtest)
fdaValues <- data.frame(obs = ytest, pred = predicted_fda)
defaultSummary(fdaValues)
confusionMatrix(data = predicted_fda, reference = ytest)
# train support vector machine
ctrl <- trainControl(method = "LGOCV",
                     summaryFunction = defaultSummary,
                     classProbs = TRUE,
                     savePredictions = TRUE)
sigmaRangeReduced <- sigest(as.matrix(xtrain))
svmRGridReduced <- expand.grid(.sigma = sigmaRangeReduced[1],
                               .C = 2^(seq(-4, 6)))
set.seed(476)
svmRModel <- train(xtrain, 
                   ytrain,
                   method = "svmRadial",
                   metric = "Kappa",
                   preProc = c("zv","center","scale"),
                   tuneGrid = svmRGridReduced,
                   fit = FALSE,
                   trControl = ctrl)
# the trained model's summary
svmRModel
plot(svmRModel)
# predict
predicted_svm <- predict(svmRModel, xtest)
svmValues <- data.frame(obs = ytest, pred = predicted_svm)
defaultSummary(svmValues)
confusionMatrix(data = predicted_svm, reference = ytest)
# train KNN
ctrl <- trainControl(method = "LGOCV",
                     summaryFunction = defaultSummary,
                     classProbs = TRUE,
                     savePredictions = TRUE)
set.seed(476)
knnFit <- train(xtrain, 
                ytrain,
                method = "knn",
                metric = "Kappa",
                preProc = c("zv","center","scale"),
                tuneGrid = data.frame(.k = 1:30),
                trControl = ctrl)
# the trained model's summary
knnFit
plot(knnFit)
# predict
predicted_knn <- predict(knnFit, xtest)
knnValues <- data.frame(obs = ytest, pred = predicted_knn)
defaultSummary(knnValues)
confusionMatrix(data = predicted_knn, reference = ytest)
# train naive Bayes
ctrl <- trainControl(method = "LGOCV",
                     summaryFunction = defaultSummary,
                     classProbs = TRUE,
                     savePredictions = TRUE)
set.seed(476)
nbFit <- train(xtrain, 
               ytrain,
               method = "nb",
               metric = "Kappa",
               preProc = c("zv","center","scale"),
               tuneGrid = data.frame(.fL = 2,.usekernel = TRUE,.adjust = TRUE),
               trControl = ctrl)
# the trained model's summary
nbFit
plot(nbFit)
# predict
predicted_nb <- predict(nbFit, xtest)
nbValues <- data.frame(obs = ytest, pred = predicted_nb)
defaultSummary(nbValues)
confusionMatrix(data = predicted_nb, reference = ytest)
# c
# predictors' importance
rda_p_imp <- varImp(rdaFit, scale = FALSE)
rda_p_imp
plot(rda_p_imp, top = 5, scales = list(y = list(cex = .95)))
