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
                    tags$p('Ovaj projekt započet je u sklopu',
                           tags$a('Dana otvorenih podataka 2020.',
                                  href = 'https://odd.codeforcroatia.org/'),
                           'Projekt je, očito, motiviran otvaranjem isplata
                           iz proračuna Grada Bjelovara putem',
                           tags$a('web aplikacije',
                                  href = 'https://transparentnost.bjelovar.hr/'),
                           'koja svima zainteresiranima omogućava pretraživanje
                           isplata prema nekim kriterijima.'),
                    tags$p('Budući da su podaci o isplatama iz proračuna već
                           dostupni, opravdano je pitati koja je poanta ove
                           web aplikacije. Odgovor bi mogao biti da nadograđuje
                           funkcionalnost koju nudi aplikacija Grada:',
                           tags$li('omogućava jednostvnu izradu neki osnovnih
                                   vizualizacija isplata iz proračuna'),
                           tags$li('rezultati pretraživanja nisu ograničeni
                                   na 1000 unosa'),
                           tags$li('nudi uvid u ukupne isplate u zadanim
                                   vremenskim razdobljima, ili odabranim
                                   primateljima.')),
                    tags$p('Naravno, vjerojatno ima i neke mane. Ono što mi
                           prvo pada na pamet jest to da su podaci koji
                           su dostupni na stranicama Grada nešto su
                           detaljniji od onih dostupnih kroz ovu aplikaciju.
                           To je zato što na prvu nisam znao što započeti s
                           dijelom podatka (primjerice, s ekonomskim i
                           funkcionalnim klasifikacijama).'),
                    tags$p('Ako netko želi sudjelovati u radu na ovoj
                           aplikaciji, primjerice oko uvođenja novih
                           mogućnosti, može se mi se javiti na',
                           tags$a('Twitter',
                                  href = 'https://twitter.com/dvlasicek'),
                           'ili e-mail: dvlasice [at] ffzg [točka] hr.
                           U protivnom ću sam dodavati stvari kako će mi
                           padati na pamet.'),
                    tags$h1('Kod i materijali'),
                    tags$p('Svi materijali i kod za izradu ove aplikacije
                           dostupni su na',
                           tags$a('GitHubu.',
                                  href = 'https://github.com/vdeni/proracun-bjelovar'),
                           'Tamo možete pronaći i pročišćene i sirove podatke
                           o isplatama iz proračuna preuzete putem API-ja
                           Grada Bjelovara.'),
                    tags$p('Podaci i materijali licencirani su pod',
                           tags$a('CC0 licencom,',
                                  href = 'https://creativecommons.org/publicdomain/zero/1.0/'),
                           'što znači da ih možete slobodno koristiti za što
                           god.  Naravno, ako Vam je nešto bilo korisno, možete
                           mi zahvaliti, ali ne morate.'),
                    tags$h1('Informacije o softveru'),
                    verbatimTextOutput('software_info')),
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
                        box(title = 'Pojedinačne isplate odabranim
                                    primateljima',
                            width = 12,
                            tags$p('Podatke za odabrane primatelje i vremensko
                                   razdoblje možete preuzeti u
                                   CSV (comma separated values) formatu:',
                            downloadButton('download_csv', 'Preuzmi CSV')),
                            DT::dataTableOutput('t_entity'))
                        )
            )
        )
    ), skin = 'black'
)
