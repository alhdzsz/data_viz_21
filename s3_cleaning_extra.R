#-----------------------------------------------
# Author: Alfredo Hernandez Sanchez
# Title: Cleaning Script
# Date: 2021-03-16
# Course: DVIZ_2021 IBEI
#-----------------------------------------------

library(tidyverse)
library(reshape2)
library(countrycode)

df = KOFGI_2020_public %>% 
  select(code, country, year, KOFGI) %>% 
  mutate(code = countrycode(country, origin = "country.name", destination = "iso3c")) %>% 
  filter(year >= 1995,
         !is.na(code))

df2 = Country_Complexity_Rankings_1995_2018 %>% 
  melt(id.vars=c("Country")) %>% 
  filter(grepl('ECI [0-9]{4}', variable)) %>% 
  mutate(year=str_extract(variable, "[:digit:]{4}"),
         year=as.double(year)) %>% 
  rename(ECI=value) %>% 
  select(-variable) %>% 
  mutate(code = countrycode(Country, origin = "country.name", destination = "iso3c")) %>% 
  select(-Country)

saveRDS(df,"KOF_clean.rds") 
saveRDS(df2, "ECI_clean.rds")


