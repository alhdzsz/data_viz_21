# Load R packages
library(shiny)
library(shinythemes)

#---------- 1

# Define User Interface
ui <- fluidPage(theme = shinytheme("journal"), #see more: https://rstudio.github.io/shinythemes/
                navbarPage("My first app", #Name of Navigation bar page
                           tabPanel("Name",
                           sidebarPanel(
                             tags$h3("What is your name?"), #level of heading
                             textInput("txt1", "Name:", ""), #collects from user to send to server
                             textInput("txt2", "Surname:", ""),
                             
                           ), # sidebarPanel
                           mainPanel(
                             h1("Header 1 (example)"),
                             h4("Greetings!"),
                             verbatimTextOutput("txtout"),
                             
                           ) # mainPanel
                           
                  ), # Navbar 1, tabPanel
                  tabPanel("Another Vignette!", "This panel is intentionally left blank")
                  
                ) # end of navbarPage
) # end of fluidPage

#---------- 2

# Define server function  
server <- function(input, output) {
    output$txtout <- renderText({ #this sends out from the server to the user!
    paste("Hello", input$txt1, input$txt2, "nice to meet you!",sep = " " )  
  })
} 

#---------- 3

# Create Shiny App!
shinyApp(ui = ui, server = server)