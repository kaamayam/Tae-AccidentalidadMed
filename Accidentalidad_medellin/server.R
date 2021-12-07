
library(shiny)


shinyServer(function(input, output) {
    output$mytable = DT::renderDataTable({train})
    output$intervalo=renderText({
        as.character(input$`rango de fechas`)
    })
    output$holiday = DT::renderDataTable({holyday})
    output$tab <- renderUI({
        url <- a("fECHAS ESPECIALES", href="https://www.agendaculturalmedellin.com/")
        tagList("fechas especiales medellin:", url)
    })
    v<- reactiveValues(doText=FALSE)
    observeEvent(input$api,{
     v$doText<- input$api   
    })
    observeEvent(input$tabset, {
        v$doText <- FALSE
    }) 
    output$Informacion<- renderText({
        if (v$doText == FALSE)return()
        isolate({
        data <- if (input$tabset == "Intervalos de tiempo") {
            datos<-as.character(input$`rango de fechas`)
            division<-str_split(datos, " ")
            tala<-data.frame(unlist(division))
            paste(tala[1,1],"el numero 2:",tala[2,1])
        }else if (input$tabset == "Fechas especiales") {
            fecha<-as.character(input$fecha)
            paste(fecha)
        }
        else {
            año=as.character(input$texto)
            division<-str_split(año, ",")
            talal<-data.frame(unlist(division))
            paste(talal[1,1],"el numero 2:",talal[2,1])
        }
        data
        })
        })
    output$mapplot= renderLeaflet({mapi@map})
    output$Link= renderUI({
        url <- a("fECHAS ESPECIALES", href="https://www.agendaculturalmedellin.com/")
        tagList("fechas especiales medellin:", url)
    })
    z <- reactiveValues(datos = NULL)
    observeEvent(input$Actualizar, {
        z$datos <-mapi@map 
    })
    output$mapplot= renderLeaflet({
        if (is.null(z$data)) return()
        z$data
        })
})
