
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


prediccion_dia <- function(f1){
  f1 <- as.Date(f1)
  dia_n <-  as.integer(format(f1, "%d"))
  dia <- as.factor(wday(f1, label = TRUE))
  mes <- as.factor(format(f1, "%b")) 
  ano <- as.integer(format(f1, "%Y"))
  holi_bin <- ifelse(f1 %in% holidays_fecha$holidays_fecha , 1, 0) %>% factor()
  BARRIOS <- readRDS('bases_datos/nombres_barrios.rds')
  CLASE_ACCIDENTE <- c('volcamiento','otro',
                       'atropello','choque',
                       'caida ocupante','incendio')
  new_dat <- data.frame(dia_n=rep(dia_n, each=length(BARRIOS)),
                        dia=rep(dia, each=length(BARRIOS)),
                        mes=rep(mes, each=length(BARRIOS)),
                        ano=rep(ano, each=length(BARRIOS)),
                        holi_bin=rep(holi_bin, each=length(BARRIOS)),
                        CLASE_ACCIDENTE = rep(CLASE_ACCIDENTE, each=length(BARRIOS)),
                        BARRIO=BARRIOS) #aqui deberian ir todos los barrios
  new_dat$choque <- as.integer(predict(modelo, new_dat,type = "response"))
  predicciones<-spread(new_dat, key = CLASE_ACCIDENTE, value = choque,fill = 0)
  predicciones<-predicciones %>% mutate("Total"=rowSums(predicciones[ , 7:12]))
  predicciones$escala<- ifelse(predicciones$Total<=3,"moderado","grave")
  #necesitamos 332 datos de barrios
  dia1<-left_join(barrios_med@data, predicciones, by= c("NOMBRE" = "BARRIO"))
  barrios_med@data<- dia1
  totalizados_med <-  apply(predicciones[,7:13], MARGIN = 2, sum)
  return(list(totalizados_med,predicciones))
}
prediccion_dia(f1)[[1]]

#MAPA
mapview(barrios_med, zcol=c("Total"))
mapview(barrios_med, zcol=c("escala"))


# Semanal ----input: f1="2014-03-25"; f2 = "2014-04-03"
f1="2014-03-25"; f2 = "2014-04-26"
prediccion_semana <- function(f1, f2){
  f1 <- f1 %>% as.Date()
  f2 <- f2 %>% as.Date()
  secuencia <- seq(f1, f2, 1)
  mi_lista <- list()
  for (i in secuencia) {
    mi_lista <- append(mi_lista, prediccion_dia(as.Date(i))[2])
  }
  a<-as.data.frame(bind_rows(mi_lista) %>%  group_by(BARRIO) %>% 
                     summarise_at(vars("atropello", "caida ocupante","choque", 
                                       "incendio","otro", "volcamiento"), sum))
  return(a)
}
prediccion_semana(f1, f2)




# Mensual ---- input: 01 or 02 .... or 12

prediccion_mes <- function(ano,mes){
  f1 <- as.Date(paste(ano, mes, 01, sep = "-")) %>%  as.Date()
  f2 <- bsts::LastDayInMonth(f1) %>%  as.Date()
  secuencia <- seq(f1, f2, 1)
  mi_lista <- list()
  for (i in secuencia) {
    mi_lista <- append(mi_lista, prediccion_dia(as.Date(i))[2])
  }
  a<-as.data.frame(bind_rows(mi_lista) %>%  group_by(BARRIO) %>% 
                     summarise_at(vars("atropello", "caida ocupante","choque", 
                                       "incendio","otro", "volcamiento"), sum))
  return(a)
}
ano <- 2014 ; mes <- 02
prediccion_mes(ano,mes)


