
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)

shinyUI(fluidPage(

  # Application title
  titlePanel("Exponential Smoothing Example"),

  # Sidebar with a slider input for number of bins
  sidebarLayout(
    sidebarPanel(
    	textInput("caption", "Caption:", "special"),
    	sliderInput("mu", "Mean for rnorm:", value = 4, 
    							min = -50, max = 50),
    	sliderInput("sigma", "Sigma for rnorm:", value = sqrt(2), 
    							min = 0, max = 50),
    	sliderInput("root1", "First root:", value = 1.2, 
    							min = -5, max = 5, step=.025),
    	sliderInput("root2", "Second root:", value = -.4,
    							min = -5, max = 5, step=.025),
    	sliderInput("start1", "Init1:", value = 7, 
    							min = -50, max = 50, step=1),
    	sliderInput("start2", "Init2:", value = 10,
    							min = -50, max = 50, step=1)
    ),

    # Show a plot of the generated distribution
    mainPanel(
    	# verbatimTextOutput("ar_data_str"), 
    	textOutput("ar_data_str", container = span), 
    	h3(textOutput("caption", container = span)),
    	plotOutput("ts_plot"),
    	plotOutput("acf_plot")
    )
  )
))
