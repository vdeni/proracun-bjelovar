library(shiny)
library(shinydashboard)

conflict_prefer('box', 'shinydashboard')

# design variables
title_width = '300px'

# define UI
dashboardPage(
    dashboardHeader(title = 'Proračun Grada Bjelovara',
                    titleWidth = title_width),
    dashboardSidebar(
        width = title_width,
        sidebarMenu(
            menuItem('Informacije', tabName = 'info',
                     icon = icon('info-circle')),
            menuItem('Ukupne isplate', tabName = 'total',
                     icon = icon('coins'))
        )
    ),
    dashboardBody(
        tabItems(
            # Informacije
            tabItem(tabName = 'info',
                    tags$h1('Opće informacije'),
                    tags$p('placeholder'),
                    tags$h1('Informacije o softveru'),
                    tags$p('Placeholder')),
            # Ukupne isplate
            tabItem(tabName = 'total',
                    tags$h1('Ukupne isplate iz proračuna'),
                    tags$p('Na prikazu ispod možete vidjeti ukupne isplate
                           iz proračuna Grada Bjelovara za određeni vremenski
                           period.'),
                    fluidRow(
                    tags$style('.box-title {
                               font-weight: bold;
                               }'),
                    box(title = 'Postavke',
                        tags$p('U polja ispod možete unijeti prvu i posljednju
                               godinu vremenskog raspona za koji želite dobiti
                               prikaz isplata iz proračuna:',
                               style = 'padding-bottom: 10px'),
                        tags$span(textInput('date_start',
                                            label = 'Početak',
                                            placeholder = '2018',
                                            value = '2018',
                                            width = '60px'),
                                 style = 'display: inline-block;
                                          padding-right: 10px'),
                        tags$span(textInput('date_end',
                                            label = 'Kraj',
                                            placeholder = '2020',
                                            value = '2020',
                                            width = '60px'),
                                  style = 'display: inline-block'),
                        tags$div(actionButton('total_update', 'Ažuriraj'),
                                 style = 'padding-above: 10px'),
                        width = 3),
                    box(title = 'Prikaz ukupnih isplata iz proracuna za odabrano
                                 razdoblje',
                        plotOutput('p_total'),
                        width = 9))
                    )
        )
    ),
    skin = 'black'
)
