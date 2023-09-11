# ************************************************************************
# New York Fed Staff Nowcast ----
# ************************************************************************
# URL: https://www.newyorkfed.org/research/policy/nowcast#/overview
# Feel free to copy, adapt, and use this code for your own purposes.
# Matthias Spichiger (matthias.spichiger@bluewin.ch)
# ************************************************************************

## Load packages ----
library(fredr)
library(tidyverse)
library(scales)
library(ggtext)

start_date <- "2015-01-01"
usrecdp <- read_csv(file = "Recession-Dates/NBER/Recession-Dates_NBER_US_Daily_Midpoint.csv")

## Access the data ----
staff_url <- "https://www.newyorkfed.org/medialibrary/Research/Interactives/Data/NowCast/Downloads/New-York-Fed-Staff-Nowcast_download_data.xlsx"
download.file(
  url = staff_url, destfile = "Nowcasts/Federal-Reserve-Bank-of-New-York/New-York-Fed_Staff-Nowcast/Staff-Nowcast.xlsx", 
  method = "curl"
  )

df <- readxl::read_excel(
  path = "Nowcasts/Federal-Reserve-Bank-of-New-York/New-York-Fed_Staff-Nowcast/Staff-Nowcast.xlsx", 
  sheet = "Forecasts By Quarter", range = readxl::cell_limits(ul = c(6, 1), lr = c(NA, NA)) # Upper left = A6
  ) |> 
  mutate(`Forecast Date` = date(`Forecast Date`))

names(df) <- c("date", "Q1", "Q2", "Q3")

df <- df |> 
  select(date, Q1, Q2, Q3)

df
