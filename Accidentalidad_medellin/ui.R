
library(shinydashboard)
library(leaflet)
library(DT)
library(rgdal)
library(mapview)
library(dplyr)
library(stringr)
library(shinythemes)
shinyUI(fluidPage(theme = shinytheme("flatly"),
  dashboardPage(
    dashboardHeader(title = 'Accidentalidad Medellín'),
    # menu
    dashboardSidebar(
      sidebarMenu(
        menuItem("Modelo Predictivo", tabName = "p1", icon=icon("brain")),
        menuItem("Base de datos", tabName = "p2", icon=icon("database")),
        menuItem("Video presentación", tabName = "p3", icon=icon("play-circle")),
        menuItem("Anexos", tabName = "p4", icon=icon("github")),
        hr(),
        # botton para graficar los mapas
        actionButton(inputId = "api",label = "Continuar y graficar",icon=icon("brain"))
      )
    ),
    
    # cuerpo del dash board
    dashboardBody(
      tabItems(
        
        # Seccion Modelo Predictivo
        tabItem(tabName = "p1",
                fluidPage(
                    sidebarPanel(width = 12,
                                
                                 h3('Podras elegir entres formas de predicción posible a continuación: ', style="color:gray;"),
                                 h4('1. Intervalod de tiempo: Podrás elegir una semana especifica. '),
                                 h4('2. Por fecha especifica: Podrás elegir un dia especifico. '),
                                 h4('3. Por mes espeficico: Podrás elegir un mes y un año especifico. '),
                                 hr(),
                                 tabsetPanel(id="tabset",
                                             hr(),
                                             
                                             
                                             tabPanel("Por intervalo de tiempo",icon=icon("calendar"),
                                                      hr(),
                                                      dateRangeInput("rango_de_fechas",label = "Elegir semana", width = 500,
                                                                     start = "2018-01-01",
                                                                     end   = "2018-01-08"),
                                                      leafletOutput("mi_grafico_1", width = 600),
                                                      h4('Accidentes por tipo'),
                                                      DT::dataTableOutput("table1", width = 600),
                                             ),
                                             tabPanel("Por fecha especifica", icon=icon("clock"), 
                                                      hr(),
                                                      dateInput("fecha", "Selecciona el día:", value = "2018-02-29", width = 200),
                                                      leafletOutput("mi_grafico_2", width = 600),
                                                      h4('Accidentes por tipo'),
                                                      DT::dataTableOutput("table2", width = 600),
                                                      
                                                      
                                                      
                                                      
                                             ),
                                             tabPanel("Por mes especifico", icon=icon("car"), 
                                                      hr(),
                                                      textInput("ano","Digite un año", value = "2018", width = 100),
                                                      textInput("mes","Digite un mes", value = "08", width = 100),
                                                      leafletOutput("mi_grafico_3", width = 600),
                                                      h4('Accidentes por tipo'),
                                                      DT::dataTableOutput("table3", width = 600),
                                             ),
                                             #
                                               
                                 ),
                                 
                               
                    ),
                    mainPanel(
                      textOutput("Informacion"),
                      width = 4,
                      
                    ),
                ), #end fluid

        ),
        
        tabItem(tabName = "p2",
                h2("modelo de entrenamiento Base de datos"),
                DT::dataTableOutput("mytable")
        ),
        tabItem(tabName = "p3",
                fluidPage(
                  br(h1("Video promocional explicativo")),
                  HTML('<iframe width="560" height="315" src="https://www.youtube.com/embed/RLC3cpiYOKE" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>')
                ),
        ),
        tabItem(tabName = "p4",
                fluidPage(
                  
                  
                  br(h2("Reporte técnico")),
                  tags$a(href="https://rpubs.com/kaamayam/Accidentalidadtae", br(h3("https://rpubs.com/kaamayam/Accidentalidadtae"))),
                  
                  
                  br(h2("Repositorio GitHub")),
                  tags$a(href="https://github.com/kaamayam/Tae-AccidentalidadMed", br(h3("https://github.com/kaamayam/Tae-AccidentalidadMed"))),
                  
                )
        )
      ),
    ),

  )
))