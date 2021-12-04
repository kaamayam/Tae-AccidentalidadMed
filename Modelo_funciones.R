
library(tidyverse)
library(lubridate)
library(bsts)


# Cargando el modelo -------
modelo <- readRDS("modelo.rds")

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


# Prediccion por dia *****************************************************
# input f1: "2014-01-10"  {Una fecha cualquiera como a?o, mes, dia}
# input claseaccidente: {un tipo de accidente como: 
# "atropello", "caida ocupante", "choque", "incendio", "otro", "volcamiento"}

prediccion_dia <- function(f1, claseaccidente){
  f1 <- as.Date(f1)
  dia_n <-  as.integer(format(f1, "%d"))
  dia <- as.factor(wday(f1, label = TRUE))
  mes <- as.factor(format(f1, "%b")) 
  ano <- as.integer(format(f1, "%Y"))
  holi_bin <- ifelse(f1 %in% holidays_fecha$. , 1, 0) %>% factor()
  new_dat <- data.frame(dia_n, dia, mes, ano, holi_bin, CLASE_ACCIDENTE = claseaccidente)
  return(predict(modelo, new_dat, type="response") %>% as.integer())
}
prediccion_dia("2014-01-10", "choque")

# Prediccion por semana *****************************************************
# input f1: "2014-01-10"  {Una fecha cualquiera como a?o, mes, dia}
# input f2: "2014-01-18"  {Una fecha cualquiera como a?o, mes, dia}
# input claseaccidente: {un tipo de accidente como: 
# "atropello", "caida ocupante", "choque", "incendio", "otro", "volcamiento"}
prediccion_semana <- function(f1, f2, claseaccidente){
  f1 <- f1 %>% as.Date()
  f2 <- f2 %>% as.Date()
  secuencia <- seq(f1, f2, 1)
  return(sum(prediccion_dia(secuencia, claseaccidente)))
}



# Prediccion por mes *****************************************************
# input ano: "2014"  {un a?o}
# input mes: "01"  {un mes}
prediccion_mes <- function(ano, mes, claseaccidente){
  f1 <- as.Date(paste(ano, mes, 01, sep = "-")) %>%  as.Date()
  f2 <- bsts::LastDayInMonth(f1) %>%  as.Date()
  secuencia <- seq(f1, f2, 1)
  return(sum(prediccion_dia(secuencia, claseaccidente)))
}



