require(foreign)
require(ff)
require(dplyr)
require(lubridate)
require(ggplot2)
require(ggmap)
require(dplyr)
require(plotly)
require(tidyr)
require(Formula)
require(Hmisc)
require(WDI)
require(XML)
require(acepack)
require(acs)
require(checkmate)
require(choroplethr)
require(choroplethrMaps)
require(htmlTable)
require(zipcode)
#loading data from Markdown file 
load("wild07.Rdata")
load("wild15.Rdata")
load("tot_acre07.Rdata")
load("tot_acre15.Rdata")

new <- spread(tot_acres1, key = STATE, value = TOT_ACRE)
new2 <- spread(tot_acres2, key = STATE, value = TOT_ACRE)
row.names(new) <- c("2007")
master <- full_join(new, new2)

#ShinyApp
# Define UI for application that draws a histogram
ui <- shinyUI (fluidPage(
  
  # Application title
  titlePanel("United States Wildfires in 2007 and 2015"),
  
  # Sidebar  
  sidebarLayout(
    sidebarPanel(
      helpText("Create a bar graph showing the change in frequency of wildfires for different states."),
      
      checkboxGroupInput("state1",
                  "Choose which state you'd like to see:",
                  choices = colnames(master)),
      # checkboxGroupInput("state2",
      #                    "Choose which state you'd like to see:",
      #                    choices = c(levels(wild07$STATE))),
      hr(),
      helpText("Data from U.S. Department of Homeland Security United States Fire 
               Administration National Fire Data Center")
      ),
  
  # Show a plot of the generated distribution
  mainPanel(
    plotOutput("distPlot"),
    textOutput("text1")
  )
  )
)
)


#Define server logic required to draw a histogram
server <- shinyServer(function(input, output) {
  output$text1 <- renderText({
    paste("You have selected the state",input$state1)})
  # output$text2 <- renderText({
  #   paster("and", input$state2)})
  output$distPlot <- renderPlot({
    barplot(master[,input$state1] *1000,
            main = input$state1,
            ylab = "Number of Wildfires",
            xlab = "State"
    )
  })
})

# Run the application 
shinyApp(ui = ui, server = server)

