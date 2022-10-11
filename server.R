library(shiny)
library(jpeg)

shinyServer(function(input,output,session){

  user_url <- reactive({input$user_keyword})
  
  output$test_out <- renderPlot({
    plot(1:2,ty='n') 
    rasterImage(as.raster(readJPEG(user_url())),1,1,2,2)
  })
  
  vals <- reactiveValues(x=NA,y=NA)
  
  observeEvent(input$boxPlot_click, {
    vals$x <- c(vals$x,input$boxPlot_click$x)
    vals$y <- c(vals$y,input$boxPlot_click$y)
  })
  
  output$boxPlot <- renderPlot({
    input$boxPlot_click
    par(mai=c(0,0,0,0))
    plot(1,ylim=c(2,15),xlim=c(2,15),type='n',yaxs='i',xaxs='i',ylab='',xlab='',axes=F)
    for (i in 2:15) {
      abline(v=i)
      abline(h=i)
    }
    for (i in seq_along(length(vals$x))) {
      rect(floor(vals$x),floor(vals$y),ceiling(vals$x),ceiling(vals$y),col='blue')
    }
  })
  
  output$text <- renderText(paste0(vals$x, ', ' , vals$y, '\n'))
  
}
)