library(shiny)
library(shinydashboard)
library(leaflet)
library(DT)

if (interactive()) {
ui = dashboardPage(
    dashboardHeader(title="Predicción Medellin"),
    dashboardSidebar(
        sidebarMenu(
            menuItem("Modelo de predicción", tabName = "p1", icon=icon("users")),
            menuItem("Mapa de casos", tabName = "p2", icon=icon("globe-americas")),
            menuItem("Base de datos", tabName = "p3", icon=icon("database"))
        )
    ),
    dashboardBody(
        tabItems(
            tabItem(tabName = "p1",
                    h1("Modelo de predicción"),
                    h2("Modelo numero 1"),
                    fluidPage(
                        dateRangeInput("daterange1", "Date range:",
                                       start = "2013-01-01",
                                       end   = "2022-12-31")
                    ),
                    h2("Modelo numero 2"),
                    fluidPage(
                        dateInput("date1", "Date:", value = "2012-02-29"),
                    ),
                    h2("Modelo numero 3"),
                    fluidPage(
                        checkboxInput("somevalue", "Some value", FALSE),
                        verbatimTextOutput("value")
                    ),
            ),
            tabItem(tabName = "p2",
                    h2("hola mundo2"),
                    m
            ),
            tabItem(tabName = "p3",
                    h2("modelo de entrenamiento Base de datos"),
                    DT::dataTableOutput("mytable")
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

server = function(input, output) {
    output$mytable = DT::renderDataTable({datos_final})
}
shinyApp(ui, server)
}