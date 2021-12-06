# datos
library(tidyverse)
#datos<- read.csv("bases_datos/incidentes_viales.csv", sep = ";",quote = "")
holidays_fecha <- readRDS("bases_datos/Holidays.rds")%>% as.data.frame()
barrios_med=readRDS("bases_datos/barrios_Medellin.rds")
conteos<- readRDS("bases_datos/conteos_con.rds")
str(conteos)
conteos<- readRDS("bases_datos/conteos_con.rds")
conteos$BARRIO<-as.factor(conteos$BARRIO)

# particion de la base de datos
#train <- conteos %>% filter(ano <= 2017)
#saveRDS(train, "train.rds")
#saveRDS(conteos, "conteos_con.rds")
train<- readRDS("bases_datos/train.rds")
validation <- conteos %>% filter(ano >= 2018 | ano <= 2019)
test <- conteos  %>% filter(ano >= 2020)

#### modelo de prueba *************************************************************
modelo <- lm(n ~ ano + mes + dia_n + dia + holi_bin + CLASE_ACCIDENTE+BARRIO, 
             data = conteos)
y_est1<- predict(object = modelo, newdata = train[,-5])
y_est2<-predict(object = modelo, newdata=test[,-5])
mean((train$n - y_est1)^2)
mean((test$n - y_est2)^2)



fit.1 <- glm (n ~ ano + mes + dia_n + dia + holi_bin + CLASE_ACCIDENTE + BARRIO, 
              family=poisson(link = log),data = train)

#summary(fit.1)
saveRDS(fit.1, "modelo_glm.rds")
fit.1<-readRDS("modelo_glm.rds")
y_est1<- predict.glm(object = fit.1, newdata = train[,-5], type = "response")
y_est2<-predict(object = fit.1, newdata=test[,-5])
mean((train$n - y_est1)^2)
mean((test$n - y_est2)^2)

mean((train$n - y_est)^2) #MSE
sqrt(mean(y_est^2))#RMSE


# Test (--ERROR---)
y_est <- predict.glm(object = fit.1, newdata = test[,-5], type = "response")
#MSE
mean((test$n - y_est)^2) 

#Arboles
library(rpart)
library(rpart.plot)
library(caret)
tree1 <- rpart(formula = n ~ ., data = train)
rpart.plot(tree1)
prp(tree1)
y_est<-predict(object=tree1, newdata=train[,-5])
mean((train$n - y_est)^2)
y_est<-predict(object=tree1, newdata=test[,-5])
mean((test$n - y_est)^2)

#random forest
library(caret)
library(randomForest)
bosque <- train(n ~ . ,data = train, method = 'rf', 
                trControl = trainControl(method='cv',number = 5))

#knn
library(kknn)
mod_knn<- train.kknn(n ~ ., data = train, kmax = 9)
y_est<-predict(object=mod_knn, newdata=train[,-5])
mean((train$n - y_est)^2)
y_est<-predict(object=mod_knn, newdata=test[,-5])
mean((test$n - y_est)^2)

