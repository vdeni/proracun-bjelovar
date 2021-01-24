##### Ukupne isplate
# table functions
.makeTableTotal <- function(.data) {
    DT::renderDataTable({
        .data() %>%
            mutate_at(.,
                      vars(total), ~ . * 1000) %>%
            mutate_at(.,
                      vars(.month),
                      ~ v_months_full[.month]) %>%
            set_colnames(.,
                         c('Godina', 'Mjesec', 'Isplate u kunama')) %>%
            DT::datatable(.,
                          options = list(paging = F,
                                  searching = F,
                                  scrollX = F,
                                  scrollY = '555px',
                                  scrollCollapse = T,
                                  info = F),
                          rownames = F)
            }
    )
}
