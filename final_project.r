library(tidyverse)
library(janitor)

# loading in the stores, cleaning names and filtering data down to just NYC stores
# then filtering out specialty stores lumped in with grocery stores that don't offer nutritious/fresh foods
# (delis, candy stores, pharmacies, etc.)
stores <- read_csv("data/Retail_Food_Stores_20241129.csv")  %>%
  clean_names()  %>%
  filter((city == "NEW YORK" | city == "BROOKLYN" | city == "BRONX" | county == "QUEENS" | city == "STATEN ISLAND") & establishment_type == "A")  %>% 
  filter(!grepl("DELI", dba_name) & !grepl("CANDY", dba_name) & !grepl("PHARMACY", dba_name) & !grepl("CONVENIENCE", dba_name) & !grepl("NEWS", dba_name))
  #filter(county == "QUEENS"  & establishment_type == "A")

stores  %>% write_csv("food_stores_filtered.csv")

# reading in census data for % of households without a car by census tract, filtering out invalid datapoints and 
# ensuring percentage column is stored as a number and not a string
census <- read_csv("data/ACSST5Y2022.S2504_2024-12-05T160822/ACSST5Y2022.S2504-Data.csv")  %>%
  clean_names()  %>% 
  select(geo_id, name, s2504_c02_027e) %>% 
  mutate(geo_id = substring(geo_id, 10, nchar(geo_id)))  %>% 
  filter(geo_id != "" & s2504_c02_027e >= 0)

census$s2504_c02_027e = as.numeric(census$s2504_c02_027e)
census %>% write_csv("data/census_filtered.csv")

# using data generated in qgis (joined census data from previous step with nyc census tracts data)
# data is grouped by community district, summarized to obtain average percentae without a car per cd
# and then reformatted so cd code is in format (BK01 --> 301) that matches other dataset for next step

car_owners <- read_csv("data/car_ownership_by_census_tract.csv")  %>% 
  clean_names()  %>% 
  group_by(cdta2020)  %>% 
  summarize(pct_without_car = mean(census_filtered_s2504_c02_027e, na.rm = T))  %>% 
  filter(pct_without_car >= 0) %>% 
  mutate(cd_code = case_when(substring(cdta2020, 0, 2) == "MN" ~ paste("01", substring(cdta2020, 3, nchar(cdta2020)), sep=""),
                             substring(cdta2020, 0, 2) == "BX" ~ paste("02", substring(cdta2020, 3, nchar(cdta2020)), sep=""),
                             substring(cdta2020, 0, 2) == "BK" ~ paste("03", substring(cdta2020, 3, nchar(cdta2020)), sep=""),
                             substring(cdta2020, 0, 2) == "QN" ~ paste("04", substring(cdta2020, 3, nchar(cdta2020)), sep=""),
                             substring(cdta2020, 0, 2) == "SI" ~ paste("05", substring(cdta2020, 3, nchar(cdta2020)), sep=""))) 

car_owners$cd_code = as.numeric(car_owners$cd_code)

# importing ratio of bodegas: grocery store by cd, joined with
# data for % without a car by cd

bodega_ratios <- read_csv("data/bodega_ratios.csv")  %>% 
  clean_names()  %>%
  mutate(cd_code = geography_id)
bodega_ratios

bodegas_cars_cd <- left_join(bodega_ratios, car_owners, by = "cd_code")
bodegas_cars_cd  %>% write_csv("bodega_ratios_pct_no_car.csv")