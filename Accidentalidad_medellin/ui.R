library(shiny)
library(shinydashboard)
library(leaflet)
library(DT)
library(rgdal)
library(mapview)
library(dplyr)
library(stringr)


shinyUI(fluidPage(
    if (interactive()) {
        dashboardPage(
            dashboardHeader(title="Predicción Medellin"),
            dashboardSidebar(
                sidebarMenu(
                    menuItem("Modelo de predicción", tabName = "p1", icon=icon("users")),
                    menuItem("Mapa de casos", tabName = "p2", icon=icon("globe-americas")),
                    menuItem("Base de datos", tabName = "p3", icon=icon("database")),
                    menuItem("Video presentación", tabName = "p4", icon=icon("play-circle")),
                    menuItem("Anexos", tabName = "p5", icon=icon("github"))
                )
            ),
            dashboardBody(
                tabItems(
                    tabItem(tabName = "p1",
                            fluidPage(
                                br(
                                    h1("Modelo de predicción"),
                                    h3("los siguientes funciones que tienen la finalidad de que el usuario utilice el modelo para predecir algun tipo de accidente bajo 3 supuestos,
                                       ya sea intervalos de tiempo, fechas en especifico, o por meses; en la parte de mapa de casos esta la interaccion con este"),
                                ),
                                sidebarLayout(
                                    sidebarPanel(width = 8,
                                                 tabsetPanel(id="tabset",
                                                             tabPanel("Por intervalo de tiempo (semana)",
                                                                      dateRangeInput("rango_de_fechas", "fecha de accion:",
                                                                                     start = "2014-01-01",
                                                                                     end   = "2014-01-08"),
                                                                      leafletOutput("mi_grafico_1"),
                                                             ),
                                                             tabPanel("Por fecha especifica",
                                                                      dateInput("fecha", "dia:", value = "2012-02-29"),
                                                                      leafletOutput("mi_grafico_2"),
                                                                      
                                                                      
                                                                      
                                                             ),
                                                             tabPanel("Por mes especifico",
                                                                      textInput("ano","digite fecha:(año,mes)", value = "2014"),
                                                                      textInput("mes","digite fecha:(año,mes)", value = "08"),
                                                                      leafletOutput("mi_grafico_3"),
                                                             ),
                                                             #
                                                             
                                                 ),
                                                 actionButton("api","Continuar y graficar",icon=icon("brain"))
                                    ),
                                    mainPanel(
                                        textOutput("Informacion"),
                                        width = 4,
                                        
                                    ),
                                ),
                            ),
                            
                            br(
                                fluidPage(
                                    
                                    # grafico aqui
                                ),
                            ),
                            br(
                                fluidPage(
                                    uiOutput("tab")
                                ),
                            ),
                    ),
                    tabItem(tabName = "p2",
                            fluidPage(
                                br(
                                    fluidPage(
                                        h1("Mapa de casos ciudad de medellín"),
                                        h3("Aqui esta vizualizado los accidentes y donde se predice que van a suceder, se grafica despues de darle confirmar en la parte inicial de la platataforma, en caso de que estes seguro de tu busqueda dar actualizar."),
                                    ),
                                ),
                                br(
                                    actionButton("Actualizar","Actualizar",icon=icon("map")),
                                ),
                                leafletOutput("mapplot")
                            )
                    ),
                    tabItem(tabName = "p3",
                            h2("modelo de entrenamiento Base de datos"),
                            DT::dataTableOutput("mytable")
                    ),
                    tabItem(tabName = "p4",
                            fluidPage(
                                br(h1("Video promocional explicativo")),
                            ),
                    ),
                    tabItem(tabName = "p5",
                            fluidPage(
                                
                                
                                br(h2("Reporte técnico")),
                                tags$a(href="https://rpubs.com/kaamayam/Accidentalidadtae", br(h3("https://rpubs.com/kaamayam/Accidentalidadtae"))),
                                
                                
                                br(h2("Repositorio GitHub")),
                                tags$a(href="https://github.com/kaamayam/Tae-AccidentalidadMed", br(h3("https://github.com/kaamayam/Tae-AccidentalidadMed"))),
                                
                            )
                    )
                ),
            ),
            tags$head(
                tags$style(HTML('
.skin-blue .main-header .logo{
background-color: #fff;
color: #201545;
}
.skin-blue .main-header .navbar {
background-color: #201545;
}
.skin-blue .main-sidebar{
background-color: #201545;
}
.skin-blue .sidebar-menu>li.active>a{
background: #201545;
}
'))
            )
        )
    }))