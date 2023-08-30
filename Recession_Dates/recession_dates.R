# ************************************************************************
# Recession Dates ----
# ************************************************************************
# URL: https://fredhelp.stlouisfed.org/fred/data/understanding-the-data/recession-bars/
# Based on Breen, Jeffrey, 2011-08-15.
# R-Bloggers: https://www.r-bloggers.com/2011/08/use-geom_rect-to-add-recession-bars-to-your-time-series-plots-rstats-ggplot/
#
# Feel free to copy, adapt, and use this code for your own purposes at
# your own risk.
#
# Matthias Spichiger, 2023 (matthias.spichiger@bluewin.ch)
# ************************************************************************

## Load packages ----
library(fredr)
library(tidyverse)
library(rvest)

start_date <- "2015-01-01"

# The National Bureau of Economic Research (NBER) provides
# three time series available on FRED:
# NBER based Recession Indicators for the United States:
# - from the Period following the Peak through the Trough: USRECD
# - from the Peak through the Trough: USRECDM
# - from the Peak through the Period preceding the Trough: USRECDP

# An interesting theoretical concept is the following:
# Dates of U.S. recessions as inferred by GDP-based recession indicator: JHDUSRGDPBR

# Other cool recession indicators are
# - Sahm Rule Recession Indicator: SAHMCURRENT
# - Real-time Sahm Rule Recession Indicator: SAHMREALTIME


## Recession dates form FRED ----
url <- "https://fredhelp.stlouisfed.org/fred/data/understanding-the-data/recession-bars/"
html <- read_html(url)

## Access the dates of Peaks and Troughs ----
usrecdp <- html |>
  html_element("#post-2281 > div.entry-content > p:nth-child(5)") |>
  html_text2() |>
  read_delim(delim = ",") |>
  rename(Trough = ` Trough`)

## Write the dates to a CSV file ----
write_csv(usrecdp, file = "Recession_Dates/NBER_Recession_Dates.csv")

# END