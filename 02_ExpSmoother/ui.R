
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
    	numericInput("randomseed", "Random Seed:", 101010),
    	sliderInput("bump_start", "Starting Time of Outage:", value = 400, 
    							min = 0, max = 1000),
    	sliderInput("bump_duration", "Outage Duration:", value = 200, 
    							min = 0, max = 500, step=1),
    	sliderInput("smoothing_period", "Smoothing Period:", value = 10, 
    							min = 2, max = 50, step=1),
    	sliderInput("rate_of_decay", "Rate of decay:", value = .1, 
    							min = .0001, max = .5, step=.01)
    ),

    # Show a plot of the generated distribution
    mainPanel(
    	# h3(textOutput("caption", container = span)),
    	plotOutput("ts_plot"),
    	plotOutput("decay_pattern_plot")
    )
  )
))
