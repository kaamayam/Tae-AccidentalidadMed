## codigo necesario
## objetos necesarios para la app
install.packages("shinywidgets")
barrios_med=readOGR("Barrios de Medellín/Barrio_Vereda.shp",layer="Barrio_Vereda")
nombres_barrios=iconv(barrios_med@data$NOMBRE,"UTF-8","ISO_8859-1")
colores=sample(x=c("red","blue","yellow"),size=length(nombres_barrios),replace=TRUE)
m=leaflet(barrios_med)
m=addTiles(m)
m=addPolygons(m,popup=nombres_barrios)
m=addTiles(m)
m=addPolygons(m,popup=nombres_barrios,color=colores)
m