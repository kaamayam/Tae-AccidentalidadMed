library(shinydashboard)
library(shinydashboardPlus)
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
        menuItem("Sobre nosotros", tabName = "widgets4", icon = icon("info-circle")),
        menuItem("Ayuda y Dudas", tabName = "p6", icon = icon("question-circle")),
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
                  div(align="center",
                    h3('Informacion App',style="color:gray;"),
                    h4('la presente App se basa en predecir incidentes viales en la Ciudad de Medellin a partir de
                   datos históricos de accidentes reportados por la Sectretaría de Movilidad. De acuerdo a la 
                   Organización Mundial de la Salud, al año se presenta la pérdida de más de 1,5 millones de vidas
                   en siniestros viales, estos se han convertido en una problemática social por el daño que producen
                   no solo en las familias sino también en la comunidad. En el caso de la ciudad de Medellín, según cifras
                   de la Alcaldía de Medellín y la Secretaría de Movilidad, entre los años 2014 y 2020 se presentaron 
                   aproximadamente más de 200.000 incidentes viales, en la parte inferior podras buscar y predecir fechas, solo decide'),
                    tags$img(src = "logo.png", 
                             width = "500px", height = "150px"),
                  ),
                    sidebarPanel(width = 12,
                                 h3('Podrás elegir entres formas de predicción posible a continuación: ', style="color:gray;"),
                                 h4('1. Intervalo de tiempo: Podrás elegir una semana específica. '),
                                 h4('2. Por fecha específica: Podrás elegir un día específico. '),
                                 h4('3. Por mes espeficico: Podrás elegir un mes y un año específico. '),
                                 hr(),
                                 tabsetPanel(id="tabset",
                                             hr(),
                                             
                                             
                                             tabPanel("Por intervalo de tiempo",icon=icon("calendar"),
                                                      hr(),
                                                      dateRangeInput("rango_de_fechas",label = "Elegir semana", width = 500,
                                                                     start = "2018-01-01",
                                                                     end   = "2018-01-08"),
                                                      leafletOutput("mi_grafico_1", width = 600),
                                                      DT::dataTableOutput("table1", width = 600),
                                             ),
                                             tabPanel("Por fecha especifica", icon=icon("clock"), 
                                                      hr(),
                                                      dateInput("fecha", "Selecciona el día:", value = "2018-02-29", width = 200),
                                                      leafletOutput("mi_grafico_2", width = 600),
                                                      DT::dataTableOutput("table2", width = 600),
                                                      
                                                      
                                                      
                                                      
                                             ),
                                             tabPanel("Por mes especifico", icon=icon("car"), 
                                                      hr(),
                                                      actionButton("ano","Digíte un año", value = "2018", width = "200px", height = "100px"),
                                                      actionButton("mes","Digíte un mes", value = "08", width = "200px", height = "100px"),
                                                      leafletOutput("mi_grafico_3", width = 600),
                                                      DT::dataTableOutput("table3", width = 600),
                                             ),
                                             #
                                               
                                 ),
                                 
                               
                    ),
                    mainPanel(
                      textOutput("Información"),
                      width = 4
                    ),
                    
                ), #end fluid
                fluidPage(
                  div(align="center",
                  h4('Si no entiendes el funcionamiento de la app te invitamos a darle click en el boton de ayuda o de ilustracion(video) que aparecen en el menu de items de
                     de la zona superior izquierda',style="color:gray;"),
                  h3("Fechas especiales"),
                  DT::dataTableOutput("holidays")
                  )
                ),

        ),
        
        tabItem(tabName = "p2",
                h2("modelo de entrenamiento Base de datos"),
                DT::dataTableOutput("mytable")
        ),
        tabItem(tabName = "p3",
                fluidPage(
                  div(align = "center",
                  br(h1("Video promocional explicativo")),
                  HTML('<iframe width="560" height="315" src="https://www.youtube.com/embed/RLC3cpiYOKE" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>')
                  ),
                ),
        ),
        tabItem(tabName = "p4",
                fluidPage(
                  
                  
                  br(h2("Reporte técnico")),
                  tags$a(href="https://rpubs.com/kaamayam/Accidentalidadtae", br(h3("https://rpubs.com/kaamayam/Accidentalidadtae"))),
                  
                  
                  br(h2("Repositorio GitHub")),
                  tags$a(href="https://github.com/kaamayam/Tae-AccidentalidadMed", br(h3("https://github.com/kaamayam/Tae-AccidentalidadMed"))),
                  
                )
        ),
        # 4 informacion
        tabItem(tabName = "widgets4",
                #Titulo
                shiny::HTML("<br><br><center> 
                         <h1>Sobre nosotros</h1> 
                        </center>"),
                tags$div( align = "center",
                          icon("users", class = "fa-4x")
                ),
                
                fluidRow(
                  column(2),
                  column(8,
                         # Panel for Background on Data
                         div(class="panel panel-default",
                             div(class="panel-body",  
                                 
                                 img(src='stat.jpg',height="40%", width="40%", align = "left"),
                                 tags$p(h6("Somos un grupo de estudiantes de la Universidad 
                                                 Nacional de Colombia sede Medellín cuyo objetivo es la
                                                 resolución de problemas mediante análisis estadístico,
                                                 implementando técnicas de programación y machine learning.
                                                 Así mismo implememtmos desarrollo de sus respectivas
                                                 aplicaciones iteractivas")),
                             )
                         ) # Closes div panel
                  ), # Closes column
                  column(2)
                ),
                
                # TEAM BIO
                
                fluidRow(
                  
                  style = "height:50px;"),
                
                fluidRow(
                  column(2),
                  
                  # Andre
                  column(2,
                         div(class="panel panel-default", 
                             div(class="panel-body",  width = "600px",
                                 align = "center",
                                 div(
                                   tags$img(src = "team.jpg", 
                                            width = "50px", height = "50px")
                                 ),
                                 div(
                                   tags$h5("Andrea"),
                                   tags$h6( tags$i("Estadística"))
                                 )
                             )
                         )
                  ),
                  # Sebas
                  column(2,
                         div(class="panel panel-default",
                             div(class="panel-body",  width = "600px", 
                                 align = "center",
                                 div(
                                   tags$img(src = "team.jpg", 
                                            width = "50px", height = "50px")
                                 ),
                                 div(
                                   tags$h5("Sebastián"),
                                   tags$h6( tags$i("Estadístico"))
                                 )
                             )
                         )
                  ),
                  # Pili
                  column(2,
                         div(class="panel panel-default",
                             div(class="panel-body",  width = "600px", 
                                 align = "center",
                                 div(
                                   tags$img(src = "team.jpg", 
                                            width = "50px", height = "50px")),
                                 div(
                                   tags$h5("Pilar"),
                                   tags$h6( tags$i("Estadística"))
                                 )
                             )
                         )
                  ),
                  # Isa
                  column(2,
                         div(class="panel panel-default",
                             div(class="panel-body",  width = "600px", 
                                 align = "center",
                                 div(
                                   tags$img(src = "team.jpg", 
                                            width = "50px", height = "50px")),
                                 div(
                                   tags$h5("Isabel"),
                                   tags$h6( tags$i("Estadística"))
                                 )
                                 
                             )
                         )
                  ),
                  column(2)
                  
                ),
                fluidRow(style = "height:150px;")
                
        ),
        tabItem(tabName = "p6",
                fluidPage(
                  div(align="center",
                      h1("¿Como empezar a predecir accidentes?"),
                      h2("PASOS: ",style="color:red;"),
                      h3("1. elige las fechas que consideres mas prudentes, puedes elegir entre semanas, bucando a traves de intervalos de tiempo: "),
                      hr(),
                      tags$img(src = "imagen1.png", 
                               width = "500px", height = "150px"),
                      hr(),
                      h3("1. Tambien puedes buscar alguna fecha que te llame la atencion: "),
                      hr(),
                  tags$img(src = "imagen2.png", 
                           width = "500px", height = "150px"),
                  hr(),
                  h3("1. de igual manera busca el año y mes: "),
                  hr(),
                tags$img(src = "imagen3.png", 
                         width = "500px", height = "150px"),
                hr(),
                h3("2. Por ultimo ya elegido el momento de tu agrada dale en el boton Continuar y graficar, este aparece en la esquina superior izquierda junto al panel de seleccion : "),
                hr(),
                tags$img(src = "imagen4.png", 
                         width = "300px", height = "150px"),
                hr(),
                h3("3. Dando a conocerse un mapa y una tabla la cual contiene la cantidad de accidentes por tipo y buscando en el mapa donde posiblemente podran ocurriran: "),
                hr(),
                tags$img(src = "imagen5.png", 
                         width = "500px", height = "300px"),
                hr(),
                tags$img(src = "imagen6.png", 
                 width = "400px", height = "300px")
                )
        )
      )
    ),

  )
)))