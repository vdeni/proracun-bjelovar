##### Ukupne isplate
# preparation functions
.makeDataPlotTotal <- function(.input, .data) {
    eventReactive(.input$total_update,
                  {
                     filter(.data, year >= .input$date_start_total &
                            year <= .input$date_end_total) %>%
                     group_by(.,
                              year, month) %>%
                     summarise(.,
                               total = sum(amount)) %>%
                     mutate_at(.,
                               vars(year),
                               as.factor) %>%
                     mutate_at(.,
                               vars(total),
                               ~ . / 1e3)
                  },
                  ignoreNULL = F)
}

# plotting functions
.plotLineChartTotal <- function(.data) {
    renderPlot({
        ggplot(.data(),
               aes(x = month, y = total,
                   group = year,
                   color = year)) +
               geom_line(size = 1.5) +
               labs(x = 'Mjesec', y = 'Isplate u tisućama kuna') +
               scale_y_continuous(breaks = seq(0, 1e5, 5e3)) +
               scale_color_viridis_d(name = 'Godina')
    })
}

.plotBarChartTotal <- function(.data) {
    renderPlot({
        .data() %>%
            mutate_at(.,
                      vars(total), ~ . / 1000) %>%
            group_by(.,
                     year) %>%
            summarise(.,
                      year_total = sum(total)) %>%
            ggplot(.,
                   mapping = aes(y = year_total, x = year,
                                 fill = year)) +
                geom_bar(stat = 'identity', alpha = .7, width = .7,
                         color = 'black', size = 1.5) +
                labs(x = 'Godina', y = 'Isplate u milijunima kuna') +
                scale_fill_viridis_d() +
                scale_y_continuous(breaks = seq(0, 500, by = 50)) +
                guides(fill = F) +
                theme(panel.grid.major.x = element_blank())
    })
}

##### Isplate primateljima
# preparation functions
.makeDataPerEntity <- function(.input, .data) {
    eventReactive(.input$entity_update,
                  {
                     filter(.data, year >= .input$date_start_entity &
                            year <= .input$date_end_entity &
                            name_oib %in% .input$choose_entity) %>%
                     group_by(.,
                              name_oib, year) %>%
                     summarise(.,
                               total = sum(amount)) %>%
                     mutate_at(.,
                               vars(total),
                               ~ . / 1e3) %>%
                     mutate_at(.,
                               vars(year), as.factor)
                  })
}

# plotting functions
.plotBarChartEntity <- function(.data) {
    renderPlot({
        ggplot(.data(),
               mapping = aes(y = total, x = year,
                             fill = name_oib)) +
            geom_bar(stat = 'identity', alpha = .7, width = .7,
                     color = 'black', size = 1.5,
                     position = 'dodge') +
            labs(x = 'Godina', y = 'Isplate u tisućama kuna') +
            scale_fill_viridis_d() +
            guides(fill = guide_legend(title = 'Primatelj',
                                       ncol = 1, direction = 'vertical')) +
            theme(panel.grid.major.x = element_blank(),
                  legend.position = 'bottom')
    })
}
