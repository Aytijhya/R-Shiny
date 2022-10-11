library(shiny)

shinyUI(fluidPage(
  titlePanel("Proj"),
  sidebarLayout(
    sidebarPanel(
    textInput(inputId = "user_keyword", label = "Enter path",  width = "100%"),textOutput("text")),
    mainPanel( plotOutput("test_out",click = "boxPlot_click"))
)))
