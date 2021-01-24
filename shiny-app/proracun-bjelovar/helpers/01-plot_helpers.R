##### Ukupne isplate
# preparation functions
.makeDataPlotTotal <- function(.input, .data = dat) {
    eventReactive(.input$total_update,
                  {
                     filter(.data, year(date) >= .input$date_start &
                         year(date) <= .input$date_end) %>%
                     mutate(.,
                            .year = year(date),
                            .month = month(date, label = T)) %>%
                     group_by(.,
                              .year, .month) %>%
                     summarise(.,
                               total = sum(amount)) %>%
                     mutate_at(.,
                               vars(.year),
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
               aes(x = .month, y = total,
                   group = .year,
                   color = .year)) +
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
                     .year) %>%
            summarise(.,
                      year_total = sum(total)) %>%
            ggplot(.,
                   mapping = aes(y = year_total, x = .year,
                                 fill = .year)) +
                geom_bar(stat = 'identity', alpha = .7, width = .7,
                         color = 'black', size = 1.5) +
                labs(x = 'Godina', y = 'Isplate u milijunima kuna') +
                scale_fill_viridis_d() +
                scale_y_continuous(breaks = seq(0, 500, by = 50)) +
                guides(fill = F) +
                theme(panel.grid.major.x = element_blank())
    })
}
