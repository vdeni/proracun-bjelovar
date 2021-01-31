library(shiny)
library(here)
library(tidyverse)
library(conflicted)
library(magrittr)
library(lubridate)
library(viridis)
library(DT)

conflict_prefer('filter', 'dplyr')

source(here('resources', '01-variables.R'))

source(here('resources', '02-plot_settings.R'))

source(here('helpers', '01-plot_helpers.R'))

source(here('helpers', '02-table_helpers.R'))

# server setup
shinyServer(function(input, output) {
    # load data
    dat <- read_csv(here('resources', 'proracun_bjelovar_clean.csv'))

    dat_reactive <- reactiveVal(dat)

    ##### Opce informacije
    output$software_info <- renderPrint({sessionInfo()})

    ##### Ukupne isplate
    # prepare data
    d_p_total <- .makeDataPlotTotal(input, dat)

    # grafovi
    output$p_total_line <- .plotLineChartTotal(d_p_total)

    output$p_total_bar <- .plotBarChartTotal(d_p_total)

    output$t_total <- .makeTableTotal(d_p_total)

    ##### Isplate primateljima
    output$entity_picker <- renderUI({
        selectInput('choose_entity',
                    label = NULL,
                    multiple = T,
                    choices = unique(dat_reactive()$name_oib))
    })

    # prepare data
    d_p_entity <- .makeDataPerEntity(input, dat)

    d_t_entity <- .makeDataPerEntityTable(input, dat)

    # plot
    output$p_entity_bar <- .plotBarChartEntity(d_p_entity)

    # make table
    output$t_entity <- .makeTablePerEntity(d_t_entity)

    # table download
    output$download_csv <- downloadHandler(content = function(file) {
                                                d_t_entity %>%
                                                .makeTablePerEntityExport(.) %>%
                                                write.csv(.,
                                                        file,
                                                        row.names = F)
                                           },
                                           filename = 'isplate_primateljima.csv'
                                           )
})
