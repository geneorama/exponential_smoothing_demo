
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)


shinyServer(function(input, output) {
	if(FALSE){
		input = list(mu=4, sigma=sqrt(2), 
								 root1 = 1.2, root2=-.4,
								 start1 = 7, start2 = 10)
		rm(input)
	}
	
	ar_data <- reactive({
		set.seed(input$randomseed)
		
		ret <- filter(rnorm(1000, 
												mean = input$mu, 
												sd = input$sigma), 
									filter = c(input$root1, input$root2), 
									method = "recursive", 
									init = c(input$start1, input$start2))
		return(ret)
	})
	
	output$caption <- renderText({
		input$caption
	})
	
	output$ts_plot <- renderPlot({
		plot(ar_data(), xlab="t", ylab=expression(y[t]), pch=16)
	})
	
	output$acf_plot <- renderPlot({
		acf(ar_data())
	})
	
})
