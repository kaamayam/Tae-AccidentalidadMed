#library(shiny)

library(shinydashboard)
library(shinythemes)
library(shinydashboard)
library(leaflet)
library(DT)
library(rgdal)
library(mapview)
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

  
  
  # reactive event for map ****************** 1
  dataInput1 <- eventReactive(input$api,{  
    source('Modelo_funciones.R')
    f1 <- input$rango_de_fechas[1]
    f2 <- input$rango_de_fechas[2]
    m1 <- mapview(prediccion_semana(f1, f2)[[2]], zcol=c("Total"))
    m1 #**** (1)
  })
  
  output$mi_grafico_1 <- renderLeaflet({ # **** (2)
    dataInput1()@map
  })
  
  
  # reactive event for map ***************** 2
  dataInput2 <- eventReactive(input$api,{  
    source('Modelo_funciones.R')
    f1 <- input$fecha
    m2 <- mapview(prediccion_dia(f1)[[3]], zcol=c("Total"))
    m2 #**** (1)
  })
  
  output$mi_grafico_2 <- renderLeaflet({ # **** (2)
    dataInput2()@map
  })
  
  
  # reactive event for map ******************* 3
  dataInput3 <- eventReactive(input$api,{   
    source('Modelo_funciones.R')
    ano <- input$ano
    mes <- input$mes
    m3 <- mapview(prediccion_mes(ano,mes)[[2]], zcol=c("Total"))
    m3 <- mapview(prediccion_dia(f1)[[3]], zcol=c("Total"))
    m3 #**** (1)
  })
  
  output$mi_grafico_3 <- renderLeaflet({ # **** (2)
    dataInput3()@map
  })
  
  
  
  
  
  # reactive event for map ****************** 1
  dataInput1.1 <- eventReactive(input$api,{  
    source('Modelo_funciones.R')
    f1 <- input$rango_de_fechas[1]
    f2 <- input$rango_de_fechas[2]
    p1 <- prediccion_semana(f1, f2)[[1]]
    p1 #**** (1)
  })
  
  output$table1 <- DT::renderDataTable(DT::datatable({
    dataInput1.1()
  }))


  
  # reactive event for map ****************** 2
  dataInput1.2 <- eventReactive(input$api,{  
    source('Modelo_funciones.R')
    f1 <- input$fecha
    p2 <- prediccion_dia(f1)[[1]]
    p2 #**** (1)
  })
  
  output$table2 <- DT::renderDataTable(DT::datatable({
    dataInput1.2()
  }))
  
  
  # reactive event for map ****************** 3
  dataInput1.3 <- eventReactive(input$api,{  
    source('Modelo_funciones.R')
    ano <- input$ano
    mes <- input$mes
    p3 <- prediccion_mes(f1, f2)[[1]]
    p3 #**** (1)
  })
  
  output$table3 <- DT::renderDataTable(DT::datatable({
    dataInput1.3()
  }))
  

})
