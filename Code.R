library(ggplot2)
library(tidyverse)
library(lubridate)
library(bsts)


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

conteos <- datos %>% group_by(FECHA_ACCIDENTE, CLASE_ACCIDENTE=as.factor(CLASE_ACCIDENTE),
                              BARRIO,COMUNA=as.factor(COMUNA)) %>% count() %>% data.frame()


ggplot(data = conteos[conteos$CLASE_ACCIDENTE=='atropello',], aes(x = FECHA_ACCIDENTE, y =n)) + geom_point(alpha = 1/2) +
  geom_smooth(method = lm, col="blue")
#+ 
  #facet_grid(CLASE_ACCIDENTE~.)

# Arreglando variables predictivas
conteos$dia_n <-  as.integer(format(conteos$FECHA_ACCIDENTE, "%d"))
conteos$dia <- as.factor(wday(conteos$FECHA_ACCIDENTE, label = TRUE))
conteos$mes <- as.factor(format(conteos$FECHA_ACCIDENTE, "%b")) 
conteos$ano <- as.integer(format(conteos$FECHA_ACCIDENTE, "%Y"))
conteos$holi_bin <- ifelse(conteos$FECHA_ACCIDENTE %in% holidays_fecha$. , 1, 0) %>% factor()
conteos$BARRIO<- as.factor(conteos$BARRIO)

#saveRDS(conteos,"conteos.rds")

# particion de la base de datos
train <- conteos %>% filter(ano <= 2017)
validation <- conteos %>% filter(ano >= 2018 && ano <= 2019)
test <- conteos  %>% filter(ano >= 2020)

clases_accidente <- levels(conteos$CLASE_ACCIDENTE)
#BARRIOS <- unique(left_join(barrios_med@data, conteos, by= c("NOMBRE" = "BARRIO"))$NOMBRE)
BARRIOS <- 3
length(BARRIOS)

#### modelo de prueba *************************************************************

modelo <- lm(n ~ ano + mes + dia_n + dia + holi_bin + CLASE_ACCIDENTE + BARRIO, data = train)
#saveRDS(modelo, "modelo.rds")


f1 <- as.Date('2014-03-25')
dia_n <-  as.integer(format(f1, "%d"))
dia <- as.factor(wday(f1, label = TRUE))
mes <- as.factor(format(f1, "%b")) 
ano <- as.integer(format(f1, "%Y"))
holi_bin <- ifelse(f1 %in% holidays_fecha$. , 1, 0) %>% factor()

new_dat <- data.frame(dia_n=rep(dia_n, length(BARRIOS)),
                      dia=rep(dia,length(BARRIOS)),
                      mes=rep(mes,length(BARRIOS)),
                      ano=rep(ano,length(BARRIOS)),
                      holi_bin=rep(holi_bin,length(BARRIOS)),
                      CLASE_ACCIDENTE = rep('choque', length(BARRIOS)),
                      BARRIO=c('miranda', 'prado', 'boyaca'))
new_dat$choque <- as.integer(predict(modelo, new_dat))

c1<-conteos %>% filter(FECHA_ACCIDENTE=="2014-12-05") 
dia1<-left_join(barrios_med@data, new_dat, by= c("NOMBRE" = "BARRIO"))
barrios_med@data<- dia1
mapview(barrios_med, zcol=c("choque"))



# Diario ----- input: 2014-03-25  (ano, mes, dia)
prediccion_dia <- function(f1, claseaccidente){
  f1 <- as.Date(f1)
  dia_n <-  as.integer(format(f1, "%d"))
  dia <- as.factor(wday(f1, label = TRUE))
  mes <- as.factor(format(f1, "%b")) 
  ano <- as.integer(format(f1, "%Y"))
  holi_bin <- ifelse(f1 %in% holidays_fecha$. , 1, 0) %>% factor()
  BARRIO <- conteos$BARRIO
  new_dat <- data.frame(dia_n, dia, mes, ano, holi_bin, CLASE_ACCIDENTE = claseaccidente,BARRIO)
  return(predict(modelo, new_dat, type="response") %>% as.integer())
}


# Semanal ----input: f1=2014-03-25, f2 = 2014-04-03
prediccion_semana <- function(f1, f2, claseaccidente){
  f1 <- f1 %>% as.Date()
  f2 <- f2 %>% as.Date()
  secuencia <- seq(f1, f2, 1)
  return(sum(prediccion_dia(secuencia, claseaccidente)))
}



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






