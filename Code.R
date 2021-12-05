library(ggplot2)
library(tidyverse)
library(lubridate)
library(bsts)
library(mapview)#mapa


# datos
datos<- readRDS("bases_datos/datos.rds")
holidays_fecha <- readRDS("bases_datos/Holidays.rds")%>% as.data.frame()
barrios_med <- readRDS("bases_datos/barrios_Medellin.rds") # Objeto espacial
#conteos<- readRDS("bases_datos/conteos_sin.rds")
conteos<- readRDS("bases_datos/conteos_con.rds")


#conteos <- datos %>% group_by(FECHA_ACCIDENTE, CLASE_ACCIDENTE=as.factor(CLASE_ACCIDENTE),
#                              BARRIO,COMUNA=as.factor(COMUNA)) %>% count() %>% data.frame()


# Arreglando variables predictivas
conteos$dia_n <-  as.integer(format(conteos$FECHA_ACCIDENTE, "%d"))
conteos$dia <- as.factor(wday(conteos$FECHA_ACCIDENTE, label = TRUE))
conteos$mes <- as.factor(format(conteos$FECHA_ACCIDENTE, "%b")) 
conteos$ano <- as.integer(format(conteos$FECHA_ACCIDENTE, "%Y"))
conteos$holi_bin <- ifelse(conteos$FECHA_ACCIDENTE %in% holidays_fecha$. , 1, 0) %>% factor()
conteos$BARRIO<- as.factor(conteos$BARRIO)

#saveRDS(conteos,"conteos_con.rds")

# particion de la base de datos
train <- conteos %>% filter(ano <= 2017)
validation <- conteos %>% filter(ano >= 2018 | ano <= 2019)
test <- conteos  %>% filter(ano >= 2020)

#clases_accidente <- levels(conteos$CLASE_ACCIDENTE)
#BARRIOS <- unique(left_join(barrios_med@data, conteos, by= c("NOMBRE" = "BARRIO"))$NOMBRE)
#BARRIOS <- 3
#length(BARRIOS)

#### modelo de prueba *************************************************************

#modelo <- lm(n ~ ano + mes + dia_n + dia + holi_bin + CLASE_ACCIDENTE + BARRIO, data = conteos)
#saveRDS(modelo, "modelo.rds")
modelo <- readRDS("modelo_glm.rds")

# DIARIO ********************************************

f1 <- as.Date('2014-03-25')

# Diario ----- input: 2014-03-25  (ano, mes, dia)
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
  return(mi_lista)
}
prediccion_semana(f1, f2)


# Mensual ---- input: 01 or 02 .... or 12
#ano <- 2014
#mes <- 02
prediccion_mes <- function(ano,mes, claseaccidente){
  f1 <- as.Date(paste(ano, mes, 01, sep = "-")) %>%  as.Date()
  f2 <- bsts::LastDayInMonth(f1) %>%  as.Date()
  secuencia <- seq(f1, f2, 1)
  return(sum(prediccion_dia(secuencia, claseaccidente)))
}






#ggplot(data=conteos,mapping = aes(x = FECHA_ACCIDENTE , y = n)) +
#  geom_point(aes(color = CLASE_ACCIDENTE)) + facet_grid(CLASE_ACCIDENTE~.)
# se observa que las variciones en los conteos de accidentes por tipo de accidente 
# son constantes a exepcion del ano 2020 donde los conteos bajaron

#ggplot(data=conteos,mapping = aes(x = FECHA_ACCIDENTE , y = n)) +
#  geom_point(aes(color = CLASE_ACCIDENTE))






