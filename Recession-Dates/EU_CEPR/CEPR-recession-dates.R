# ************************************************************************
# CEPR recession Dates ----
# ************************************************************************
# URL: https://cepr.org/about/news/latest-findings-cepr-eabcn-euro-area-business-cycle-dating-committee-eabcdc-june-2023
# Feel free to copy, adapt, and use this code for your own purposes.
# Matthias Spichiger (matthias.spichiger@bluewin.ch)
# ************************************************************************

## Load packages ----
library(tidyverse)
library(rvest)

# The Center for Economic Policy Research (CEPR)'s
# Euro Area Business Cycle Network (EABCDC) Dating Committee
# assesses the state of the euro area economic activity.

## Access the data ----

### Web scraping ----
cepr_url <- "https://eabcn.org/dc/chronology-euro-area-business-cycles"

ea_cepr_rec <- read_html(cepr_url) |> 
  html_element("#node-441 > div.content > div > div > div > div > div > div > div > div > div > table") |> 
  html_table(header = TRUE) |> 
  rename(date = Date, period = `Peak / Trough`) |> 
  select(date, period) |> 
  mutate(date = date(parse_date_time(date, "%Y %q"))) |> 
  mutate(id = row_number()) |> 
  select(id, date, period) |> 
  pivot_wider(names_from = period, values_from = date) |> 
  select(-id)

ea_cepr_rec <- tibble(recession_start = na.omit(ea_cepr_rec$Peak), recession_end = na.omit(ea_cepr_rec$Trough))
ea_cepr_rec

## Write the dates to a CSV file ----
write_csv(ea_cepr_rec, file = "Recession-Dates/CEPR/Recession-Dates_CEPR_EA_Monthly_Midpoint.csv")

# END