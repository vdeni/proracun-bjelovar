library(shiny)
library(here)
library(tidyverse)
library(conflicted)
library(magrittr)
library(lubridate)
library(viridis)

conflict_prefer('filter', 'dplyr')

source(here('shiny-app', 'proracun-bjelovar',
            'resources', '01-variables.R'))
source(here('shiny-app', 'proracun-bjelovar',
        'resources', '02-plot_settings.R'))
source(here('shiny-app', 'proracun-bjelovar',
            'helpers', '01-plot_helpers.R'))

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
})
