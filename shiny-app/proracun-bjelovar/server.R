library(shiny)
library(here)
library(tidyverse)
library(conflicted)
library(magrittr)
library(glue)

conflict_prefer('filter', 'dplyr')

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
    
    # ---------- setup ----------
    # load data
    dat <- read_csv(here('data', 'proracun-bjelovar-clean.csv'),
                    col_types = 'iccicccccccccccccc')
    
    # init variable with pretty column names
    prettyColnames <- c("id" = 'Identifikacijski broj',
                        "oib" = 'OIB',
                        "name" = 'Ime primatelja',
                        "postcode" = 'Poštanski broj primatelja',
                        "city" = 'Grad primatelja',
                        "date" = 'Datum transakcije',
                        "amount" = 'Iznos transakcije u kunama',
                        "description" = 'Opis plaćanja',
                        "level_1" = 'Ekonomska klasifikacija, razina 1',
                        "level_2" = 'Ekonomska klasifikacija, razina 2',
                        "level_3" = 'Ekonomska klasifikacija, razina 3',
                        "level_4" = 'Ekonomska klasifikacija, razina 4',
                        "function_level_1" = 'Funkcionalna klasifikacija, razina 1',
                        "function_level_2" = 'Funkcionalna klasifikacija, razina 2',
                        "function_level_3" = 'Funkcionalna klasifikacija, razina 3',
                        "function_level_4" = 'Funkcionalna klasifikacija, razina 4',
                        "comment" = 'Komentar',
                        "update_date" = 'Datum ažuriranja')
    
    radioChoices <- list('OIB' = 'oib',
                         'Ime primatelja' = 'name')
    
    # add search criteria
    observeEvent(input$addFilter,
                 {
                     insertUI(selector = 'div.well:last',
                              where = 'afterEnd',
                              ui = tags$div(
                                             wellPanel(
                                                 radioButtons(inputId = glue('filterSelect_{input$addFilter}'),
                                                              label = 'Pretraži',
                                                              choices = radioChoices),
                                                 textInput(inputId = 'query_{input$addFilter}',
                                                           label = 'Traži:'),
        )))
                 })
    
    # ---------- analyses ----------
    # filter data
    filteredData <-
        eventReactive(input$search, {
            radioVars <- str_subset(names(input), 'filterSelect')
            radioChosen <- vector(mode = 'character', length = length(radioVars))

            queryVars <- str_subset(names(input), 'query')
            queryChosen <- vector(mode = 'character', length = length(queryVars))

            for (i in radioVars) {
                radioChosen[i] <- input[[i]]
            }
            
            for (i in queryVars) {
                queryChosen[i] <- input[[i]]
            }
            
            filters <- tibble('field' = radioChosen,
                              'query' = queryChosen)
                            
            filters %<>%
                mutate(.,
                       filter = case_when(.$field == 'oib' ~
                                              glue('{.$field} == as.numeric("{.$query}")'),
                                          .$field == 'name' ~
                                              glue('str_detect({.$field},',
                                                   'regex(str_squish("{.$query}"),',
                                                   'ignore_case = T))'))) %>%
                drop_na(., filter)
            
            if (nrow(filters) == 1) {
                query <- filters$filter[1]
            } else if (nrow(filters) > 1) {
                query <- glue_collapse(filters$filter, sep = ' & ')
            }
            
            dat %>%
                filter(.,
                       eval(parse(text = query))) %>%
                return(.)
            
                                  })

    output$table <- renderTable({
        input$search
        
        isolate({
                filteredData() %>%
                    mutate_at(.,
                              vars(contains('date')),
                              format.Date, format = '%d.%m.%Y') %>%
                    set_colnames(prettyColnames)
        })
    },
    hover = T, striped = T)
})
