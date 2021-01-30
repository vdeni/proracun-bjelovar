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

# combine datasets
# list dimensions of datasets in list
l_dimensions <- map(l_data, dim)

row_sum <- reduce(l_dimensions,
                  function(x, y) {
                      row_sum <- x[1] + y[1]

                      return(row_sum)
                  })

dat <- reduce(l_data, bind_rows)

if (dim(dat)[1] != row_sum) {
    stop(paste('Dimensions of component files differ from the dimensions',
               'of the combined file.'))
}

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

# parse strings to dates
dat %<>%
    mutate_at(.,
              vars(date, update_date),
              dmy)

# dump columns not available in app
dat %<>%
    select(.,
           -matches('.*level.*'), -comment, -update_date)

# add col with name+oib (for selector)
dat %<>%
    mutate(.,
           name_oib = paste0(name, ' (', oib, ')'))

# output cleaned data
write_csv(dat, here('data', 'clean', 'proracun_bjelovar_clean.csv'))
