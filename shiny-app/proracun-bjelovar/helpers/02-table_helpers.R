##### Ukupne isplate
# table functions
.makeTableTotal <- function(.data) {
    DT::renderDataTable({
        .data() %>%
            mutate_at(.,
                      vars(total), ~ . * 1000) %>%
            mutate_at(.,
                      vars(month),
                      ~ v_months_full[month]) %>%
            set_colnames(.,
                         c('Godina', 'Mjesec', 'Isplate u kunama')) %>%
            DT::datatable(.,
                          options = list(paging = F,
                                         searching = F,
                                         scrollX = F,
                                         scrollY = '450px',
                                         scrollCollapse = T,
                                         info = F),
                          rownames = F)
            }
    )
}

##### Isplate primateljima
# preparation functions
.makeDataPerEntityTable <- function(.input, .data) {
    eventReactive(.input$entity_update,
                  {
                     filter(.data, year >= str_trim(.input$date_start_entity) &
                            year <= str_trim(.input$date_end_entity) &
                            name_oib %in% .input$choose_entity) %>%
                     select(.,
                            'Naziv i OIB' = name_oib,
                            'Datum' = date,
                            'Iznos' = amount,
                            'Opis plaćanja' = description)
                  })
}

# table functions
.makeTablePerEntity <- function(.data) {
    DT::renderDataTable({
        .data() %>%
            DT::datatable(.,
                          options = list(paging = F,
                                         searching = T,
                                         scrollX = F,
                                         scrollY = '500px',
                                         scrollCollapse = F,
                                         info = F,
                                         language = list(search = 'Traži: ')),
                          rownames = F)
    })
}

# prepare for export
.makeTablePerEntityExport <- function(.data) {
    .data() %>%
        set_colnames(.,
                     c('name_oib', 'datum', 'iznos', 'opis')) %>%
        mutate(.,
               oib = str_extract(name_oib, '(?<=\\()\\d+(?=\\))')) %>%
        mutate_at(.,
                  vars(name_oib), str_replace, '\\(\\d+\\)', '') %>%
        separate(.,
                 datum, into = c('godina', 'mjesec', 'dan'),
                 sep = '-') %>%
        rename(.,
               'naziv' = 'name_oib') %>%
        select(.,
               naziv, oib, everything())
}
