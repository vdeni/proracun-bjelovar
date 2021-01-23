library(shiny)
library(here)
library(tidyverse)
library(conflicted)
library(magrittr)
library(lubridate)

conflict_prefer('filter', 'dplyr')

# plot options
theme_set(theme_minimal())

# server setup
shinyServer(function(input, output) {
    # load data
    dat <- read_csv(here('data', 'clean', 'proracun_bjelovar_clean.csv'))

    # Ukupne isplate
    # izvuci relevantan podskup
    dat_subset <- eventReactive(input$total_update,
                                {
                                    filter(dat, year(date) >= input$date_start &
                                       year(date) <= input$date_end)
                                },
                                ignoreNULL = F)

    # graf
    output$p_total <- renderPlot({
        ggplot(dat_subset(), aes(x = amount)) +
            geom_histogram()
    })
})
