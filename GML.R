# datos
datos<- read.csv("incidentes_viales.csv", sep = ";",quote = "")
holidays_fecha <- readRDS("bases_datos/Holidays.rds")%>% as.data.frame()
barrios_med=readRDS("bases_datos/barrios_Medellin.rds")
conteos<- readRDS("bases_datos/conteos_con.rds")
#conteos<- readRDS("bases_datos/conteos_con.rds")

# particion de la base de datos
train <- conteos %>% filter(ano <= 2017)
validation <- conteos %>% filter(ano >= 2018 | ano <= 2019)
test <- conteos  %>% filter(ano >= 2020)

#### modelo de prueba *************************************************************
#modelo <- lm(n ~ ano + mes + dia_n + dia + holi_bin + CLASE_ACCIDENTE+BARRIO, data = conteos)

fit.1 <- glm (n ~ ano + mes + dia_n + dia + holi_bin + CLASE_ACCIDENTE + BARRIO, 
              family=poisson(link = log),data = train)
summary(fit.1)

predict.glm(object = fit.1, newdata = test, type = "response")
saveRDS(fit.1, "modelo_glm.rds")
