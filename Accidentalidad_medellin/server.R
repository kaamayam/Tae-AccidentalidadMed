library(shiny)
library(shinydashboard)
library(leaflet)
library(DT)
library(rgdal)
library(mapview)
#install.packages('mapview', dependencies = T)
library(dplyr)
library(stringr)
library(tidyverse)
library(lubridate)
library(bsts)


## LLamar las funciones y los datos
source('Modelo_funciones.R')



shinyServer(function(input, output) {
  output$mytable = DT::renderDataTable({train})
  output$intervalo=renderText({
    as.character(input$`rango de fechas`)
  })
  # output$holiday = DT::renderDataTable({holyday})
  # output$tab <- renderUI({
  #   url <- a("fECHAS ESPECIALES", href="https://www.agendaculturalmedellin.com/")
  #   tagList("fechas especiales medellin:", url)
  # })
  
  
  v<- reactiveValues(doText=FALSE)
  observeEvent(input$api,{
    
    
    # mapa rango fechas
    f1 <- input$rango_de_fechas[1]
    f2 <- input$rango_de_fechas[2]
    m1 <- mapview(prediccion_semana(f1, f2)[[2]], zcol=c("Total"))
    output$mi_grafico_1 <- renderLeaflet({
      m1@map
    })
    
    # mapa fecha especifica
    f1 <- input$fecha
    m2 <- mapview(prediccion_dia(f1)[3], zcol=c("Total"))
    output$mi_grafico_2 <- renderLeaflet({
      m2@map
    })
    
    
    # mapa rango fechas
    ano <- input$ano
    mes <- input$mes
    m3 <- mapview(prediccion_mes(ano,mes)[[2]], zcol=c("Total"))
    output$mi_grafico_3 <- renderLeaflet({
      m3@map
    })
    
    
    
  })
  
  
  #observeEvent(input$tabset, {
  #  v$doText <- FALSE
  #}) 
  
  
  # output$Informacion<- renderText({
  #   if (v$doText == FALSE)return()
  #   isolate({
  #     data <- if (input$tabset == "Intervalos de tiempo") {
  #       datos<-as.character(input$`rango de fechas`)
  #       division<-str_split(datos, " ")
  #       tala<-data.frame(unlist(division))
  #     }else if (input$tabset == "Fechas especiales") {
  #       fecha<-as.character(input$fecha)
  #       paste(fecha)
  #     }
  #     else {
  #       año=as.character(input$texto)
  #       division<-str_split(año, ",")
  #       talal<-data.frame(unlist(division))
  #       paste(talal[1,1],"el numero 2:",talal[2,1])
  #     }
  #     data
  #   })
  # })
  
  
  #output$mapplot= renderLeaflet({mapi@map})
  output$Link= renderUI({
    url <- a("fECHAS ESPECIALES", href="https://www.agendaculturalmedellin.com/")
    tagList("fechas especiales medellin:", url)
  })
  
  
  
  #z <- reactiveValues(datos = NULL)
  #observeEvent(input$Actualizar, {
  #  z$datos <-mapi@map 
  #})
  
  
  
  #output$mapplot= renderLeaflet({
  #  if (is.null(z$data)) return()
  #  z$data
  #})
})
