library(shiny)
library(jpeg)

responses=data.frame()
coordiante.res=data.frame()

saveData <- function(data) {
  data <- as.data.frame(t(data))
  if (exists("responses")) {
    print('new')
    print(responses)
    print('a')
    print(data)
    responses <<- rbind(responses, data)
  } 
  else {
    responses <<- data
  }
}

loadData <- function() {
  if (exists("responses")) {
    responses
  }
}

my_plot<-function(clicks)
{
  fitx = lm(x~place+ss-1, clicks)
  fity = lm(y~place+ss-1, clicks)
  m = length(unique(clicks$place))
  n = length(unique(clicks$ss))
  x_ordinate = fitx$coef[1:m]
  xerr = summary(fitx)$coef[1:m,2]
  y_ordinate = fity$coef[1:m]
  yerr = summary(fity)$coef[1:m,2]
  plot(y_ordinate, x_ordinate, xlab="y", ylab="x", col="blue", asp=1)
  text(y_ordinate, x_ordinate, sort(unique(clicks$place)), cex=0.35, pos=1, col="red")
  rect(y_ordinate-yerr,x_ordinate-xerr,y_ordinate+yerr,x_ordinate+xerr)
  u = abs((fitx$res)/as.numeric(clicks$xlim))
  v = abs((fity$res)/as.numeric(clicks$ylim))
  if(fitx$rank < (m+n-1)) print("Error:the sreenshots don't make a connected map.")
  if(max(u)>0.05 | max(v)>0.05) print(paste("Warning:the fiited map is no reliable"))
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
                 DT::dataTableOutput("responses", width = 300), verbatimTextOutput("info"),
                 tags$hr())
    )
  ),
  
  server = function(input, output) {
    
    user_url <- reactive({input$path})
    
    output$plot <- renderPlot({
      plot(1:2,ty='n')
      rasterImage(as.raster(readJPEG(user_url())),1,1,2,2)
    })
    
    vals <- reactiveValues(x=NA,y=NA)
    
    #Whenever a field is filled, aggregate all form data
    formData <- reactive({
      x <- round(input$Plot_click$x, 2)
      y <- round(input$Plot_click$y, 2)
      data <- c(input[["ss no."]],input[["place"]],x,y)
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
    
    output$info <- renderPrint({
      req(input$Plot_click)
      x <- round(input$Plot_click$x, 2)
      y <- round(input$Plot_click$y, 2)
      cat("[", x, ", ", y, "]", sep = "")
    })
  }
)
