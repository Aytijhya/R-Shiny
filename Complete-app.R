library(shiny)
library(jpeg)



responses=data.frame()

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
  fitx = lm(clicks[,3]~clicks[,2]+clicks[,1]-1)
  fity = lm(clicks[,4]~clicks[,2]+clicks[,1]-1)
  m = length(unique(clicks[,2]))
  n = length(unique(clicks[,1]))
  x_ordinate = fitx$coef[1:m]
  xerr = summary(fitx)$coef[1:m,2]
  y_ordinate = fity$coef[1:m]
  yerr = summary(fity)$coef[1:m,2]
  plot(y_ordinate, x_ordinate, xlab="y", ylab="x", col="blue", asp=1)
  text(y_ordinate, x_ordinate, sort(unique(clicks[,2])), cex=0.35, pos=1, col="red")
  rect(y_ordinate-yerr,x_ordinate-xerr,y_ordinate+yerr,x_ordinate+xerr)
  u = abs((fitx$res)/as.numeric(clicks[,5]))
  v = abs((fity$res)/as.numeric(clicks[,6]))
  if(fitx$rank < (m+n-1)) print("Error:the sreecshots don't make a connected map.")
  if(max(u)>0.05 | max(v)>0.05) print(paste("Warning:the fiited map is no reliable"))
}


# Define the fields we want to save from the form
fields <- c("ss no.", "place")


shinyApp(
  ui = fluidPage(
    titlePanel("Project"),
    sidebarLayout(
      sidebarPanel(
        textInput(inputId = "path", 
                  label = "Enter path", 
                  width = "100%"),
        numericInput(inputId = "ss no.", 
                     label = "Sreenshot number", NA, 
                     min = 1, max = 100),
        # checkboxGroupInput(inputId = "flag", 
        #                    label = "Enter 1 if you want to see final output", "0", 
        #                    choices = c("0","1")),
        textInput("place", "Name of the place", ""),
        actionButton("submit", "Submit")
      ),
      mainPanel( plotOutput("plot", click = "Plot_click"),
                 DT::dataTableOutput("responses", width = 300), verbatimTextOutput("info"),
                 tags$hr(),
                 plotOutput("outplot"),
                 tags$hr())
    )
  ),
  
  
  server = function(input, output) {
    
    user_url <- reactive({input$path})
    d=reactive({dim(readJPEG(user_url()))})
    #print(d())
    output$plot <- renderPlot({
      plot(1:2,ty='n')
      rasterImage(as.raster(readJPEG(user_url())),1,1,2,2)
    })
    
    
    #Whenever a field is filled, aggregate all form data
    formData <- reactive({
      x <- round(input$Plot_click$x, 2)
      y <- round(input$Plot_click$y, 2)
      data <- c(input[["ss no."]],input[["place"]],x,y,d()[1:2])
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
    
    
      output$outplot<- renderPlot({
         my_plot(responses)
      })
    
  }
)




# /Users/aytijhyasaha/Downloads/BS1835_project2/frames/frame1.jpg


