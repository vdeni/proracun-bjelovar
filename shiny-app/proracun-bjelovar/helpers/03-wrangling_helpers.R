##### Isplate primateljima
# filtriranje tablice
.makeDataPerEntity <- function(.input, .data) {
    eventReactive(.input$entity_update,
                  {
                     filter(.data, year(date) >= .input$date_start_entity &
                            year(date) <= .input$date_end_entity &
                            name %in% .input$entity_picker)
                  })
}
