# ************************************************************************
# NBER Recession Dates ----
# ************************************************************************
# URL: https://fredhelp.stlouisfed.org/fred/data/understanding-the-data/recession-bars/
# Feel free to copy, adapt, and use this code for your own purposes.
# Matthias Spichiger (matthias.spichiger@bluewin.ch)
# ************************************************************************

## Load packages ----
library(fredr)
library(tidyverse)
library(rvest)

### NBER Recession Dates ----
# The National Bureau of Economic Research (NBER) provides the following dummy variables on FRED:
# NBER based Recession Indicators for the United States
# - USREC: (Monthly) From the Period following the Peak through the Trough
# - USRECD: (Daily) From the Period following the Peak through the Trough
# - USRECDM: (Daily) From the Peak through the Trough
# - USRECDP: (Daily) From the Peak through the Period preceding the Trough

## Recession dates form FRED ----
nber_url <- "https://fredhelp.stlouisfed.org/fred/data/understanding-the-data/recession-bars/"

us_nber_rec <- read_html(nber_url) |>
  html_element("#post-2281 > div.entry-content > p:nth-child(5)") |>
  html_text2() |>
  read_delim(delim = ",") |>
  rename(Trough = ` Trough`)

us_nber_rec

## Write the dates to a CSV file ----
write_csv(us_nber_rec, file = "Recession_Dates/NBER/US_NBER_Recession_Dates.csv")

# END