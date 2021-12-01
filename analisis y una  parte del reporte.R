#Introducción

El presente trabajo es un reporte tecnico sobre la predicción de incidentes viales en la Ciudad de Medellin a partir de datos historicos de accidentes reportados por la Sectretaria de Movilidad. De acuerdo a la Organización Mundial de la Salud, al año se presenta la pérdida de más de 1,5 millones de vidas en siniestros viales, estos se han convertido en una problemática social por el daño que producen no solo en las familias sino también en la comunidad. En el caso de la ciudad de Medellín, según cifras de la Alcaldía de Medellín y la Secretaria de Movilidad, entre los años 2014 y 2020 se presentaron aproximadamente más de 200.000 incidentes viales.Ahora bien, las principales causas de estos incidentes se deben a no mantener una distancia prudente, no respetar las señales de tránsito y en especial por la imprudencia de los conductores. 

El análisis predictivo agrupa una variedad de técnicas estadísticas de modelización, aprendizaje automático y minería de datos que analiza los datos actuales e históricos reales para hacer predicciones acerca del futuro o acontecimientos no conocidos, con este trabajo pretendemos aportar  a la prevención de accidentes dre tránsito en la Ciudad,implementado un modelo que permitan predecir los incidentes viales  en la Ciudad de Medellín que puedan ocurrir en determinado día, semana o mes, el cual puede ser utilizado por los organismos encargados de desarrollar planes y estrategias para prevenir acidentes, para el caso de Medellin la Secretaria de Movilidad .

Para llevar a cabo nuestro trabajo nos apoyamos  en la información contenida en la base de datos abierta de incidentes viales publicada por la Secretaria de Movilidad de la Alcaldía de Medellín, donde se tienen registrados 270765  accidentes de tránsito  desde el mes de julio de 2014 hasta el mes de agosto de 2020 ocurridos en la ciudad de Medellín, la fecha de publicación fue el 2020-12-28 y su última modificación 2021-03-06.También, se creó una aplicación shiny con el propósito de que una persona pueda hacer uso del modelo predictivo ingresando una serie de datos y con ello obtener predicciones futuras de accidentes de tránsito, en el siguiente enlace - - - - - se encuentra disponible un video explicativo sobre cómo usar dicha información aplicación.

Ahora bien, las base de datos inicial y  la base con los datos limpios y las nuevas variables que se consideraron se encuentran en el siguiente repositorio al igual que el código desarrollado para la realización del trabajo.





library(readr)
datos <- readRDS("~/tae/datos.rds")

df <- readRDS("~/tae/df.rds")
df1<- readRDS("~/tae/df1.rds")


install.packages("ggplot2")
library(ggplot2)
install.packages("plotrix")
library(plotrix)


summary(df)



# Exploración base de datos

En primer lugar, preparamos la base de datos para obtener buenos resultados a la hora de implementar los modelos. Al explorar la base de datos se encontraron algunos errores de digitación los cuales fueron debidamente corregidos, también se creó una nueva base de datos a partir de la publicada en MEdata con las variables que consideramos más pertinentes para el desarrollo del modelo. 
Encontramos en las observaciones de la variable Barrio que 18395 accidentes registrados   se ubican en el municipio de Heliconia y por ende no corresponden a la ciudad de Medellín, debido a esto decidimos eliminar esos datos y también aquellos registros faltantes de información en las variables Barrio, Comuna y Localización.Preguntar a Karen que más se elimino y por qué???
  
  
 
##Encontramos en las observaciones de la variable Barrio que 18395 accidentes registrados   se ubican en el municipio de Heliconia y por ende no corresponden a la ciudad de Medellín, debido a esto decidimos eliminar esos datos y también aquellos registros faltantes de información en las variables Barrio, Comuna y Localización.Preguntar a Karen que más se elimino y por qué???
install.packages("plotrix")
library(plotrix)



Accidentes_viales= c("Localizados","no localizados por falta de información","localizados fuera de Medellin")
porcentaje= c(216500,21000, 18805)
dw=data.frame(Accidentes_viales,porcentaje)

pie3D(porcentaje,labes=Accidentes_viales, explode=0.06,height = 0.1,fill=dw$Accidentes_viales)










##tabla base de datos limpios
head(df)

##Explicación variales de la base de datos

##1) FECHA_ACCIDENTE: Fecha en la que ocurrió el accidente , el formato es AÑO-MES-DI2) MES: Mes en que se presentó el accidente , la variable está enumerada del 1 al 12, comenzando desde enero3) AÑO: Año en el que se registró el accidente4) BARRIO:Lugar de Medellin donde se presentó el accidente5)CLASE_ACCIDENTE: Los accidentes se clasifican  en  atropello, choque,incendio,volcamiento,caída de ocupante y otros.6)GRAVEDAD: Gavedad del acidente(Solo daños, con heridos, con muertos)7)holi_bin: Días festivos en Colombia preguntar a karen si desde el 2014 8) preguntar si separaron las coordenadas9) Fechas especiales: Semana en la que se realiza la Feria de flores en Medellin (consultar fechas)

##preguntar que más cambios o variables hay


z=data.frame(table(df$AÑO))

z



table(df$GRAVEDAD, df$AÑO)## eso está como raro


gr2 <- ggplot(z, aes(x=Var1, y=Freq, fill=Var1)) + geom_bar(stat="identity",position = "dodge")+ labs(title="Accidentes por año")+
  theme (plot.title = element_text(family="Comic Sans MS",
                                   size=rel(1.5),  
                                   vjust=2,  
                                   face="bold", 
                                   color="black", 
                                   lineheight=1.0)) + 
  theme(plot.title = element_text(hjust = 0.5))+
  scale_fill_brewer(palette = "Set3")+
  theme(axis.ticks = element_blank(),axis.title = element_blank(),legend.position="none") 

gr2



##Según la base de datos el año donde se  presentaron  más accidentes fue el 2019 en comparación con los demás años, a pesar de que solo tenemos datos para el 2020 hasta el mes de junio se puede plantear que los accidentes en ese año hasta junio disminuyeron con respecto a los demás años esto puede ser a raíz del confinamiento por la pandemia.




mes=data.frame(table(df$MES))
mes

ggplot(df, aes(x = MES)) + 
  geom_histogram(color = "white", fill = "coral",binwidth=1)+
  scale_x_continuous(breaks = seq(1,12,1))+
  theme (plot.title = element_text(family="Comic Sans MS",
                                   size=rel(1.5),  
                                   vjust=1,  
                                   face="bold", 
                                   color="black", 
                                   lineheight=1)) + 
  labs(title="Frecuencia de accidentes por mes")+
  theme(plot.title = element_text(hjust = 0.5))

## Con respecto a la frecuencia de accidentes registrados por mes entre 2014 y 2020 se puede observar que en el mes en que más se presentan incidentes viales es en Agosto, esto puede ser explicado porque en ese mes se lleva a cabo la Feria de Flores en la Ciudad de Medellin y por ende circulan más vehículos y peatones de lo normal. Asi mismo, podemos notar que el mes de abril es donde se han presentado menores accidentes.




dias=format(df$FECHA_ACCIDENTE,"%A")
s=table(dias)

tu=as.data.frame(s)



gr5 <- ggplot(tu, aes(x=dias, y=Freq, fill=dias)) + geom_bar(stat="identity",position = "dodge")+ labs(title="Accidentes por dia de la semana")+coord_flip()+
  theme (plot.title = element_text(family="Comic Sans MS",
                                   size=rel(1.5),  
                                   vjust=2,  
                                   face="bold", 
                                   color="black", 
                                   lineheight=1.0)) + 
  theme(plot.title = element_text(hjust = 0.5))+
  scale_fill_brewer(palette = "Set3")+
  theme(axis.text.x = element_blank(), axis.ticks = element_blank(),axis.title = element_blank(),legend.position="none") 

gr5

##Los dias que con mayor frecuencia se presentaron accidentes fueron los martes y los viernes, seguido de los jueves.


g = ggplot(df, aes(AÑO, fill=GRAVEDAD) ) +
  labs(title = "Gravedad de los accidentes por año")+ylab("") +
  theme(plot.title = element_text(size = rel(2), colour = "black", family = "Comic Sans MS"))

g+geom_bar(position="dodge") + scale_fill_manual(values = alpha(c("coral", "darkcyan","gray"), 1)) +
  theme(axis.title.x = element_text(face="bold", size=10))   

##Este gráfico presenta la gravedad de los accidentes registrados entre el 2014 y el 2020, se puede deducir que en todos los años los accidentes registrados en su mayoria presentan heridos,falta mirar bien lo de los muertos???



aa=table(df$CLASE_ACCIDENTE,df$AÑO)
aa

ggplot(data = df,
       mapping = aes(x =CLASE_ACCIDENTE, fill = CLASE_ACCIDENTE)) +
  geom_bar(bins = 7)+
  facet_wrap(~AÑO)+
  theme (plot.title = element_text(family="Comic Sans MS",
                                   size=rel(2),  
                                   vjust=2,  
                                   face="bold", 
                                   color="black", 
                                   lineheight=1.5)) + 
  labs(title="Accidentes por clase")+
  theme(plot.title = element_text(hjust = 0.5))+
  theme(axis.text.x = element_blank(), axis.ticks = element_blank(),axis.title = element_blank())

r=table(df$CLASE_ACCIDENTE,df$GRAVEDAD)
r


## Entre el año 2014 y 2020 la clase de accidente que más se registro fue el choque,se puede ver que las clases  caida y atropello tienen en promedio un  comportamiento similar en cada uno de los años, ahora bien la clase incendio no es una variabale muy representativa ya que solo el 0.013% de los accidentes registrados pertenecen a la clase de incendio.También, en cuanto a la relación entre accidente por clase y gravedad del accidente la mayoria de accidentes de la clase atropello presentan heridos al igual que la clase caida ocupante. Asi mismo, el 63.3% de choques en la mayoria de los casos registrados ocasiona solo daños y el 37.8% con heridos. Finalmente, la clase de acccidente que más muertes provocó en ese periodo fue el choque.




Barrio= c("La Candelaria","Campo Amor","Caribe","Perpetuo Socorro","Colon","Santa fe", "Cabecera San Antonio de Prado","Conquistadores","Villa Nueva")
Cantidad_accidentes= c(3707,3479,3434,3425,3034,3001,2987,2921,2789)
db=data.frame(Barrio,Cantidad_accidentes)
db

gr4 <- ggplot(db, aes(x=Barrio, y=Cantidad_accidentes, fill=Barrio)) + geom_bar(stat="identity")+ labs(title="Barrios donde se presentaron más accidentes")+
  theme (plot.title = element_text(family="Comic Sans MS",
                                   size=rel(1.5),  
                                   vjust=2,  
                                   face="bold", 
                                   color="black", 
                                   lineheight=1.0)) + 
  theme(plot.title = element_text(hjust = 0.5))+
  scale_fill_brewer(palette = "Set3")+
  theme(axis.text.x = element_blank(), axis.ticks = element_blank(),axis.title = element_blank()) 
gr4

##En este gráfico se pueden observar los 9 barrios donde más han ocurrido accidentes,La Candelaria es el sector que encabeza la lista,cabe reslatar que  dicho lugar está ubicado en el centro de la Ciudad y allí hay un alto flujo de vehículos y peatones, esto puede explicar la cantidad de accidentes registrados en la zona. En cuanto a los lugares donde se presentaron menos accidentes estos son los corregimientos ya que están en con flujos de tráfico,esto  exceptuando San Antonio de Prado. 


##Metodología para el modelo

##Agrupamiento

##Resultados

##Conclusiones
