library(shiny)
library(shinydashboard)
library(conflicted)
library(here)

conflict_prefer('box', 'shinydashboard')

source(here('shiny-app', 'proracun-bjelovar',
            'resources', '01-variables.R'))

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
                     icon = icon('coins')),
            menuItem('Isplate primateljima', tabName = 'by_entity',
                     icon = icon('address-card'))
        )
    ),
    dashboardBody(
        tags$head(tags$link(rel = 'stylesheet', type = 'text/css',
                            href = 'custom.css')),
        tabItems(
            ##### Informacije
            tabItem(tabName = 'info',
                    tags$h1('Opće informacije'),
                    tags$p('placeholder'),
                    tags$h1('Informacije o softveru'),
                    tags$p('Placeholder')),
            ##### Ukupne isplate
            tabItem(tabName = 'total',
                    tags$h1('Ukupne isplate iz proračuna'),
                    tags$p('Na prikazu ispod možete vidjeti ukupne isplate
                           iz proračuna Grada Bjelovara za određeni vremenski
                           period.'),
                    column(3,
                           box(title = 'Postavke',
                               tags$p('U polja ispod možete unijeti prvu i
                                      posljednju godinu vremenskog raspona za
                                      koji želite dobiti prikaz isplata iz
                                      proračuna:',
                                      style = 'padding-bottom: 10px'),
                               tags$span(textInput('date_start_total',
                                                   label = 'Početak',
                                                   placeholder = '2018',
                                                   value = '2018',
                                                   width = '60px'),
                                         style = 'display: inline-block;
                                                  padding-right: 10px'),
                               tags$span(textInput('date_end_total',
                                                   label = 'Kraj',
                                                   placeholder = '2020',
                                                   value = '2020',
                                                   width = '60px'),
                                         style = 'display: inline-block'),
                               tags$div(actionButton('total_update',
                                                     'Ažuriraj'),
                                        style = 'padding-above: 10px'),
                               width = NULL),
                           box(title = 'Isplate iz proračuna u odabranom
                                       razdoblju',
                               tags$div(DT::dataTableOutput('t_total'),
                                        style = 'height: 595px;'),
                               width = NULL)
                    ),
                    column(9,
                           box(title = 'Prikaz ukupnih isplata iz proračuna
                                       za odabrano razdoblje, podijeljeno po
                                       godinama i mjesecima',
                               plotOutput('p_total_line', height = '400px'),
                               width = NULL),
                           box(title = 'Prikaz ukupnih isplata iz proračuna
                                       za odabrano razdoblje, podijeljeno po
                                       godinama',
                               plotOutput('p_total_bar', height = '400px'),
                               width = NULL)
                    )
            ),
            tabItem(tabName = 'by_entity',
                    tags$h1('Isplate iz proračuna pojedinim primateljima'),
                    tags$p('placeholder'),
                    fluidRow(
                        column(3,
                            box(title = 'Postavke',
                                tags$p('U polja ispod možete unijeti prvu i
                                       posljednju godinu vremenskog raspona za
                                       koji želite dobiti prikaz isplata iz
                                       proračuna:',
                                       style = 'padding-bottom: 10px'),
                                tags$span(textInput('date_start_entity',
                                                    label = 'Početak',
                                                    placeholder = '2018',
                                                    value = '2018',
                                                    width = '60px'),
                                            style = 'display: inline-block;
                                                    padding-right: 10px'),
                                tags$span(textInput('date_end_entity',
                                                    label = 'Kraj',
                                                    placeholder = '2020',
                                                    value = '2020',
                                                    width = '60px'),
                                            style = 'display: inline-block'),
                                    tags$p('U polje ispod možete unijeti',
                                        tags$strong('ime ili OIB'),
                                        'kako biste pretraživali primatelje:'),
                                    uiOutput('entity_picker'),
                                    tags$div(actionButton('entity_update',
                                                          'Ažuriraj'),
                                            style = 'padding-above: 10px'),
                            width = NULL)
                        ),
                        column(9,
                            box(title = 'Prikaz ukupnih isplata odabranim
                                        primateljima za odabrano vremensko
                                        razdoblje',
                                plotOutput('p_entity_bar', height = '700px'),
                                width = NULL),
                        )
                    ),
                    fluidRow(
                        box(width = 12,
                            DT::dataTableOutput('t_entity'))
                        )
            )
        )
    ), skin = 'black'
)
