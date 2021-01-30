library(shiny)
library(here)
library(tidyverse)
library(conflicted)
library(magrittr)
library(lubridate)
library(viridis)
library(DT)

conflict_prefer('filter', 'dplyr')

source(here('shiny-app', 'proracun-bjelovar',
            'resources', '01-variables.R'))

source(here('shiny-app', 'proracun-bjelovar',
        'resources', '02-plot_settings.R'))

source(here('shiny-app', 'proracun-bjelovar',
            'helpers', '01-plot_helpers.R'))

source(here('shiny-app', 'proracun-bjelovar',
            'helpers', '02-table_helpers.R'))

source(here('shiny-app', 'proracun-bjelovar',
            'helpers', '03-wrangling_helpers.R'))

# server setup
shinyServer(function(input, output) {
    # load data
    dat <- read_csv(here('data', 'clean', 'proracun_bjelovar_clean.csv'))

    ##### Ukupne isplate
    # izvuci relevantan podskup
    d_p_total <- .makeDataPlotTotal(input, dat)

    # grafovi
    output$p_total_line <- .plotLineChartTotal(d_p_total)

    output$p_total_bar <- .plotBarChartTotal(d_p_total)

    output$t_total <- .makeTableTotal(d_p_total)

    ##### Isplate primateljima
    # d_per_entity <- .makeDataPerEntity(input, dat)
    d_per_entity <- reactive(dat)

    output$entity_picker <- renderUI({
        selectInput('choose_entity',
                    label = 'Odaberite primatelje za koje želite dobiti prikaz',
                    multiple = T,
                    choices = unique(d_per_entity()$name))
    })
})
