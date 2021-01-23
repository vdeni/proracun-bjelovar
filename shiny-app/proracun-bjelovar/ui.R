library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(

    # Application title
    titlePanel("Isplate iz proračuna Grada Bjelovara"),

    # Sidebar with a slider input for number of bins
    sidebarLayout(
        sidebarPanel(
            wellPanel(
                radioButtons(inputId = 'filterSelect',
                             label = 'Pretraži',
                             choices = list('OIB' = 'oib',
                                            'Ime primatelja' = 'name')),
                
                textInput(inputId = 'query',
                          label = 'Traži:')
        ),
            actionButton('addFilter', 'Dodaj kriterij'),
        
            actionButton('search', 'Traži')
        ),

        # Show a plot of the generated distribution
        mainPanel(
            tabsetPanel(
                tabPanel('Podaci',
                         tableOutput('table'))
            )
        )
    )
))
