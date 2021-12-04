#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(ggplot2)
library(tidyverse)
library(lubridate)
library(bsts)

# bases de datos
datos<- readRDS(file = "datos.rds")
holidays_fecha<-readRDS(file = "Holidays.rds") %>% data.frame()


conteos <- datos %>% group_by(FECHA_ACCIDENTE, CLASE_ACCIDENTE=as.factor(CLASE_ACCIDENTE)) %>%
    count() %>% data.frame()




# Define UI for application that draws a histogram ********************
ui <- fluidPage(

    # Application title
    titlePanel("Accidentes por tipo"),

   
    sidebarLayout(
        sidebarPanel(
            
            # Este es un input ***
            selectInput(inputId = "selector", 
                        label = "Escoja el tipo de accidente",
                                                          
                        choices = c("atropello", 
                                    "caida ocupante",
                                    "choque", 
                                    "incendio",
                                    "otro",
                                    "volcamiento"),
                        selected = "choque"),
            
            sliderInput(inputId = "bins",
                        label = "Number of bins:",
                        min = 1,
                        max = 50,
                        value = 30),
            
            
        ), # aqui cierra el panel
        
            

        # panel del grafico
        mainPanel(
           plotOutput("mi_grafico_1")
        )
        
        
        
        
        
        
    )
)



server <- function(input, output) { #******************************************
    output$mi_grafico_1 <- renderPlot({
        ggplot(data = conteos[conteos$CLASE_ACCIDENTE==input$selector,], aes(x = FECHA_ACCIDENTE, y =n)) + geom_point(alpha = 1/2) +
            geom_smooth(method = lm, col="blue")
        
    })
}




# Run the application 
shinyApp(ui = ui, server = server)
