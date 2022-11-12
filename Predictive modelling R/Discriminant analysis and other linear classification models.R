# 12.1
# c
# install.packages(c("glmnet","pamr","rms","sparseLDA","subselect","pROC"))
library(caret)
library(AppliedPredictiveModeling)
library(pROC)
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
# train logistic regression
# using LGOCV - repeated training/test splits (25 reps, 75%)
logitGrid <- expand.grid(.decay = 0)
set.seed(476)
ctrl <- trainControl(method = "LGOCV",
                     summaryFunction = defaultSummary,
                     classProbs = TRUE,
                     savePredictions = TRUE)
Logit <- train(xtrain,
               ytrain,
               method = "multinom",
               metric = "Kappa",
               tuneGrid = logitGrid,
               trControl = ctrl,
               preProc = c("zv","center","scale"))
# the trained model's summary
Logit
summary(Logit)
head(Logit$pred)
length(Logit$pred[,1]) # all predicted classes among 25 reps:4200 = 168*25
# 225*.25*25, total # in confusion matrix
confusionMatrix(data = Logit$pred$pred,
                reference = Logit$pred$obs) # average over 4200 observations
plot(Logit)
# predict
predicted_logit <- predict(Logit, xtest)
logitValues <- data.frame(obs = ytest, pred = predicted_logit)
defaultSummary(logitValues)
# train linear discriminant analysis
ldaGrid <- expand.grid(.dimen = c(1,2,3))
set.seed(476)
ctrl <- trainControl(method = "LGOCV",
                     summaryFunction = defaultSummary,
                     classProbs = TRUE,
                     savePredictions = TRUE)
LDAFull <- train(xtrain,
                 ytrain,
                 method = "lda2",
                 metric = "Kappa",
                 tuneGrid = ldaGrid,
                 trControl = ctrl,
                 preProc = c("zv","corr","center","scale"))
# the trained model's summary
LDAFull
summary(LDAFull)
head(LDAFull$pred)
confusionMatrix(data = LDAFull$pred$pred,
                reference = LDAFull$pred$obs)
plot(LDAFull)
# predict
predicted_lda <- predict(LDAFull, xtest)
ldaValues <- data.frame(obs = ytest, pred = predicted_lda)
defaultSummary(ldaValues)
# train PLSDA
set.seed(476)
ctrl <- trainControl(method = "LGOCV",
                     summaryFunction = defaultSummary,
                     classProbs = TRUE,
                     savePredictions = TRUE)
plsFit <- train(xtrain,
                ytrain,
                method = "pls",
                tuneGrid = expand.grid(.ncomp = 1:10),
                preProc = c("zv","center","scale"),
                metric = "Kappa",
                trControl = ctrl)
# the trained model's summary
plsFit
confusionMatrix(data = plsFit$pred$pred,
                reference = plsFit$pred$obs)
plot(plsFit)
# predict
predicted_pls <- predict(plsFit, xtest)
plsValues <- data.frame(obs = ytest, pred = predicted_pls)
defaultSummary(plsValues)
# predictors' importance
plsImpSim <- varImp(plsFit, scale = FALSE)
plsImpSim
plot(plsImpSim, top = 20, scales = list(y = list(cex = .95)))
# train penalized logistic regression
logitGrid_p <- expand.grid(.decay = seq(0, 0.4, length = 41))
set.seed(476)
ctrl <- trainControl(method = "LGOCV",
                     summaryFunction = defaultSummary,
                     classProbs = TRUE,
                     savePredictions = TRUE)
Logit_p <- train(xtrain,
               ytrain,
               method = "multinom",
               metric = "Kappa",
               tuneGrid = logitGrid_p,
               trControl = ctrl,
               preProc = c("zv","center","scale"))
# the trained model's summary
Logit_p
confusionMatrix(data = Logit_p$pred$pred,
                reference = Logit_p$pred$obs)
plot(Logit_p)
# predict
predicted_logit_p <- predict(Logit_p, xtest)
logitValues_p <- data.frame(obs = ytest, pred = predicted_logit_p)
defaultSummary(logitValues_p)
# d
# predictors' importance
Logit_p_imp <- varImp(Logit_p, scale = FALSE)
Logit_p_imp
plot(Logit_p_imp, top = 5, scales = list(y = list(cex = .95)))
# 12.3
# a
# install.packages("modeldata")
# install.packages("reshape2")
# install.packages("glmnet")
library(modeldata)
library(reshape2)
library(glmnet)
library(PerformanceAnalytics)
library(ggplot2)
library(caret)
data("mlc_churn")
# separate the predictors and the response
predictors = mlc_churn[,1:19]
response = mlc_churn[,20,drop=T]
# plot parallel box plots for each numeric predictor divided by levels of the response 
str(predictors)
par(mfrow = c(4,4))
for(i in c(2,6:19))
{
  Sys.sleep(0.1);
  boxplot(unlist(predictors[,i])~response, main = names(predictors)[i])
}
# plot parallel bar plots for each categorical predictor divided by levels of the response
par(mfrow = c(4,1))
for(i in c(1,3,4,5))
{
  Sys.sleep(0.1);
  counts <- table(unlist(predictors[,i]), response)
  barplot(counts, main=names(predictors)[i],
        legend = rownames(counts), beside=TRUE)
}
# correlation plot for the predictors
# creating correlation matrix
corr_mat <- round(cor(predictors[,c(2,6:19)]),2)
# reduce the size of correlation matrix
melted_corr_mat <- melt(corr_mat)
head(melted_corr_mat)
# plotting the correlation heatmap
g <- ggplot(data = melted_corr_mat, aes(x=Var1, y=Var2,
      fill=value)) + geom_tile() +
      geom_text(aes(Var2, Var1, label = value),
            color = "black", size = 3)
g+theme(axis.text=element_text(size=8))
# near-zero predictors
nearZeroVar(predictors)
# b
# get count for each level of the response variable.
summary(response)
# c
# get the columns with factor type data and find all the unique values
unique(predictors[sapply(predictors,class)=='factor'])
# create dummy variables for the categorical predictors
dmy<-dummyVars('~ .', data=predictors, fullRank=TRUE)
# dmy<-dummyVars('~state+area_code+international_plan+voice_mail_plan', data=predictors, fullRank=TRUE)
preproc_pred <- data.frame(predict(dmy, newdata = predictors))
str(preproc_pred)
# split into train/validation and test sets (80/20) using stratified random sampling
set.seed(123)
train_ind <- createDataPartition(response, p = .80, list= FALSE)
xtrain <- preproc_pred[train_ind, , drop = F]
ytrain <- response[train_ind]
xtest <- preproc_pred[-train_ind, , drop = F]
ytest <- response[-train_ind]
# bar plots of the full response, train response, and test response
par(mfrow = c(1,3))
barplot(table(response))
barplot(table(ytrain))
barplot(table(ytest))
# train logistic regression
# using LGOCV - repeated training/test splits (25 reps, 75%)
set.seed(476)
ctrl <- trainControl(method = "LGOCV",
                     summaryFunction = twoClassSummary,
                     classProbs = TRUE,
                     savePredictions = TRUE)
lrFull <- train(xtrain,
               ytrain,
               method = "glm",
               metric = "Kappa",
               trControl = ctrl,
               preProc = c("nzv","corr","center","scale"))
# the trained model's summary
lrFull
summary(lrFull)
confusionMatrix(data = lrFull$pred$pred,
                reference = lrFull$pred$obs)
plot(lrFull)
# predict
predicted_logist <- predict(lrFull, xtest)
logistValues <- data.frame(obs = ytest, pred = predicted_logist)
defaultSummary(logistValues)
# train linear discriminant analysis
set.seed(476)
ctrl <- trainControl(method = "LGOCV",
                     summaryFunction = twoClassSummary,
                     classProbs = TRUE,
                     savePredictions = TRUE)
LDAFull_binary <- train(xtrain,
                 ytrain,
                 method = "lda",
                 metric = "Kappa",
                 trControl = ctrl,
                 preProc = c("nzv","corr","center","scale"))
# the trained model's summary
LDAFull_binary
confusionMatrix(data = LDAFull_binary$pred$pred,
                reference = LDAFull_binary$pred$obs)
plot(LDAFull_binary)
# predict
predicted_lda_b <- predict(LDAFull_binary, xtest)
ldaValues_b <- data.frame(obs = ytest, pred = predicted_lda_b)
defaultSummary(ldaValues_b)
# train PLSDA
set.seed(476)
ctrl <- trainControl(method = "LGOCV",
                     summaryFunction = twoClassSummary,
                     classProbs = TRUE,
                     savePredictions = TRUE)
pls <- train(xtrain,
             ytrain,
             method = "pls",
             tuneGrid = expand.grid(.ncomp = 1:25),
             preProc = c("center","scale"),
             metric = "Kappa",
             trControl = ctrl)
# the trained model's summary
pls
confusionMatrix(data = pls$pred$pred,
                reference = pls$pred$obs)
plot(pls)
# predict
predicted_pls_b <- predict(pls, xtest)
plsValues_b <- data.frame(obs = ytest, pred = predicted_pls_b)
defaultSummary(plsValues_b)
# train penalized logistic regression
glmnGrid <- expand.grid(.alpha = c(0, .1, .2, .4, .6, .8, 1),
                        .lambda = seq(.01, .2, length = 10))
ctrl <- trainControl(method = "LGOCV",
                     summaryFunction = twoClassSummary,
                     classProbs = TRUE,
                     savePredictions = TRUE)
set.seed(476)
Logit_b <- train(xtrain,
                 ytrain,
                 metric = "Kappa",
                 method = "glmnet",
                 tuneGrid = glmnGrid,
                 trControl = ctrl,
                 preProc = c("center","scale"))
# the trained model's summary
Logit_b
confusionMatrix(data = Logit_b$pred$pred,
                reference = Logit_b$pred$obs)
plot(Logit_b, plotType = "level")
plot(Logit_b)
# predict
predicted_logit_b <- predict(Logit_b, xtest)
logitValues_b <- data.frame(obs = ytest, pred = predicted_logit_b)
defaultSummary(logitValues_b)
