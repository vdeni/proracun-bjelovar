library(tidyverse)
library(here)
library(magrittr)
library(conflicted)
library(lubridate)

conflict_prefer('here', 'here')
conflict_prefer('filter', 'dplyr')

# get datafile names
l_data_files <- list.files(here('data', 'raw'),
                           pattern = 'proracun_.*\\.csv',
                           full.names = T)

# load data to list of tibbles
l_data <- map(l_data_files, read_csv,
              col_names = c("id",
                            "oib",
                            "name",
                            "postcode",
                            "city",
                            "date",
                            "amount",
                            "description",
                            "level_1",
                            "level_2",
                            "level_3",
                            "level_4",
                            "function_level_1",
                            "function_level_2",
                            "function_level_3",
                            "function_level_4",
                            "comment",
                            "update_date"),
              skip = 1,
              col_types = 'iccicccccccccccccc')

# formatting
# turn amount into numeric
dat %<>%
    mutate_at(.,
              vars(amount),
              str_replace, 'kn', '') %>%
    mutate_at(.,
              vars(amount),
              str_trim) %>%
    mutate_at(.,
              vars(amount),
              str_replace_all, '\\.', '') %>%
    mutate_at(.,
              vars(amount),
              str_replace, ',', '.') %>%
    mutate_at(.,
              vars(amount),
              as.numeric)

# parse date strings to dates
dat %<>%
    mutate_at(.,
              vars(date, update_date),
              dmy)

# output cleaned data
# write_csv(dat, here('data', 'proracun-bjelovar-clean.csv'))
