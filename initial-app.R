library(shiny)
library(jpeg)



responses=data.frame()
saveData <- function(data) {
  data <- as.data.frame(t(data))
  if (exists("responses")) {
    responses <<- rbind(responses, data)
  } else {
    responses <<- data
  }
}

loadData <- function() {
  if (exists("responses")) {
    responses
  }
}


# Define the fields we want to save from the form
fields <- c("ss no.", "place")


shinyApp(
  ui = fluidPage(
    titlePanel("Project"),
    sidebarLayout(
      sidebarPanel(
        textInput(inputId = "path", label = "Enter path",  width = "100%"),
        numericInput(inputId = "ss no.", label = "Sreenshot number", NA, min = 1, max = 100),
        textInput("place", "Name of the place", ""),
        actionButton("submit", "Submit")
      ),
      mainPanel( plotOutput("plot",click = "Plot_click"),
               DT::dataTableOutput("responses", width = 300), 
               DT::dataTableOutput("table2", width = 300),tags$hr())
    )
  ),
  
  
  server = function(input, output, session) {
    
    user_url <- reactive({input$path})

    output$plot <- renderPlot({
      plot(1:2,ty='n')
      rasterImage(as.raster(readJPEG(user_url())),1,1,2,2)
    })

    vals <- reactiveValues(x=NA,y=NA)
    xval = reactiveValues(prev_bins = NULL)
    yval= reactiveValues(prev_bins = NULL)


    observeEvent(input$Plot_click,{
      vals$x <- c(vals$x,input$Plot_click$x)
      vals$y <- c(vals$y,input$Plot_click$y)
      xval$prev_bins= c(xval$prev_bins,vals$x)
      yval$prev_bins= c(yval$prev_bins,vals$y)
      }
    )
    
    observeEvent(input$submit,{
      output$table2<- DT::renderDataTable(cbind(xval$prev_bins,yval$prev_bins))
    })
    
    
    #Whenever a field is filled, aggregate all form data
    formData <- reactive({
      data <- sapply(fields, function(x) input[[x]])
      data
    })
    
    
    
    
    # When the Submit button is clicked, save the form data
    observeEvent(input$submit, {
      saveData(formData())
    })
    
    # Show the previous responses
    # (update with current response when Submit is clicked)
    output$responses <- DT::renderDataTable({
      input$submit
      loadData()
    })     
  }
)
