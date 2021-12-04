library(rgdal)
library(leaflet)
library(tidyverse)

# datos
datos<- read.csv("incidentes_viales.csv", sep = ";",quote = "")
holidays_fecha <- readRDS("bases_datos/Holidays.rds")%>% as.data.frame()
barrios_med=readRDS("bases_datos/barrios_Medellin.rds")
conteos<- readRDS("bases_datos/conteos_sin.rds")
#conteos<- readRDS("bases_datos/conteos_con.rds")

# particion de la base de datos
train <- conteos %>% filter(ano <= 2017)
validation <- conteos %>% filter(ano >= 2018 && ano <= 2019)
test <- conteos  %>% filter(ano >= 2020)


library(stringi)
barrios_med@data$NOMBRE<-tolower(barrios_med@data$NOMBRE)
barrios_med@data$NOMBRE<-stri_trans_general(barrios_med@data$NOMBRE,"Latin-ASCII")
barrios_med@data$NOMBRE<-gsub(x = barrios_med@data$NOMBRE,pattern = "ñ",replacement = "n")
nombres_barrios<-barrios_med@data$NOMBRE %>% as.data.frame()
colnames(nombres_barrios)<-"NOMBRE"

#saveRDS(barrios_med, "barrios_Medellin.rds")
barrios_med<-readRDS("barrios_Medellin.rds")


library(mapview)
#necesitamos 331 datos de barrios
c1<-conteos %>% filter(FECHA_ACCIDENTE=="2014-12-05") 
dia1<-left_join(barrios_med@data, c1, by= c("NOMBRE" = "BARRIO"))
#dia1[332,]<- c(rep(NA,15))
barrios_med@data<- dia1
mapview(barrios_med, zcol=c("n"))



