
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)


shinyServer(function(input, output) {
	if(FALSE){
		## Make temp variables for manual debugging:
		input = list(randomseed=101010, 
								 bump_start = 400,
								 bump_duration = 200, smoothing_period = 10, 
								 rate_of_decay = .1)
		rm(input)
	}
	
	
	ar_data <- reactive({
		set.seed(input$randomseed)
		bump_start <- input$bump_start
		bump_duration <- input$bump_duration
		bump_duration <- min((1000-bump_start), bump_duration)
		
		
		geneorama::set_project_dir("exponential_smoothing_demo")
		source("02_ExpSmoother/param1.R")
		source("02_ExpSmoother/param2.R")
		# bump_start <- 50
		# bump_duration <- 500
		
		seq1 <- filter(rnorm(bump_start - 1, 
												 mean = input1$mu, 
												 sd = input1$sigma), 
									 filter = c(input1$root1, input1$root2), 
									 method = "recursive", 
									 init = c(input1$start1, input1$start2))
		seq2 <- filter(rnorm(bump_duration, 
												 mean = input2$mu, 
												 sd = input2$sigma), 
									 filter = c(input2$root1, input2$root2), 
									 method = "recursive", 
									 init = c(seq1[bump_start - 2], seq1[bump_start - 1]))
		seq3 <- filter(rnorm(1000 - (bump_start + bump_duration - 1), 
												 mean = input1$mu, 
												 sd = input1$sigma), 
									 filter = c(input1$root1, input1$root2), 
									 method = "recursive", 
									 init = c(seq2[bump_duration - 2], seq2[bump_duration - 1]))
		## Run this line when debugging / executing code manually:
		# ar_data <- function(){ts(c(seq1,seq2,seq3))}
		return(ts(c(seq1,seq2,seq3)))
	})
	
	output$caption <- renderText({
		input$caption
	})
	
	output$ts_plot <- renderPlot({
		## Get inputs
		smoothing_period <- input$smoothing_period
		rate_of_decay <- input$rate_of_decay
		## Get exponential curve
		my_dist <- dexp(x = seq(1:smoothing_period), 
										rate = rate_of_decay)
		my_dist_normalized <- my_dist / sum(my_dist)
		
		## PLOT RAW DATA
		plot(ar_data(), 
				 xlab = "t", 
				 ylab = expression(y[t]), 
				 pch = 16, 
				 col = 'gray72',
				 ylim = range(c(0, ar_data())))
		## PLOT ROLLING MEAN
		lines(filter(ar_data(), 
								 my_dist_normalized, 
								 method = "convolution", 
								 sides = 1), 
					col="blue", 
					lwd=2)
		## CALCULATE ROLLING STANDARD STD DEV
		part1 <- filter(ar_data()^2, 
										my_dist_normalized, 
										method = "convolution", 
										sides = 1)
		part2 <- filter(ar_data(), 
										my_dist_normalized, 
										method = "convolution", 
										sides = 1)
		N <- length(my_dist_normalized)
		rolling_sd <- sqrt((part1 -part2 ^ 2 / N) / (N - 1))
		lines(rolling_sd, 
					col="red", 
					lwd=2)
		## 
		# ar_data <- ts(c(seq1,seq2,seq3))
		# plot(ar_data)
		# filter(ar_data, my_dist_normalized, method = "convolution", sides = 1)
		# smoothing_period <- 10
		# rate_of_decay <- .1
		# rm(ar_data, smoothing_period, rate_of_decay)
		
		## Manual sd check:
		# sd(ar_data[1:10])
		# sqrt((sum(ar_data[1:10]^2) - sum(ar_data[1:10])^2 / 10 ) / 9)
		## Manual check using filter:
		# filter(ar_data^2, my_dist_normalized, method = "convolution", sides = 1)
		# 
		# sqrt((filter(ar_data^2, rep(1,10), method = "convolution", sides = 1)[10] -
		# filter(ar_data, rep(1,10), method = "convolution", sides = 1)[10] ^ 2 / 10) / 9)
		# 
		# sqrt((filter(ar_data^2, rep(1,10), method = "convolution", sides = 1) -
		# 				filter(ar_data, rep(1,10), method = "convolution", sides = 1) ^ 2 / 10) / 9)
		
		
	})
	output$decay_pattern_plot <- renderPlot({
		smoothing_period <- input$smoothing_period
		rate_of_decay <- input$rate_of_decay
		
		my_dist <- dexp(x = seq(1:smoothing_period), 
										rate = rate_of_decay)
		my_dist_normalized <- my_dist / sum(my_dist)
		
		barplot(height = my_dist_normalized, 
						main="decay pattern", 
						names.arg = -(1:length(my_dist)),
						xlab = "lag period", 
						ylab = "weight")
	})
	
	
	# output$acf_plot <- renderPlot({
	# 	acf(ar_data())
	# })
	
})
