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

source(file = "Recession-Dates/recession-dates.R")

## Daily Recession Dates ----

### 1) Midpoint method -----
# USRECDM: (Daily) From the Peak through the Trough

# Monthly / Quarterly data:
# Recession from the midpoint of the peak through the midpoint of the trough. 
# The entire peak and trough periods are included in the recession shading. 
# This method shows the maximum number of periods as a recession for monthly and quarterly data. 

# Daily data:
# Recession begins on the 15th of the month of the peak and ends on the 15th of the month of the trough. 

# The Federal Reserve Bank of St. Louis uses this method in its own publications. 
usrecdm <- recession_dates(series_id = "USRECDM", frequency = "d")
write_csv(usrecdm, file = "Recession-Dates/NBER/Recession-Dates_NBER_US_Daily_Midpoint.csv")


### 2) Trough Method ----
# USRECD: (Daily) From the Period following the Peak through the Trough

# Recession from the period following the peak through the trough 
# (i.e. the peak is not included in the recession shading, but the trough is). 

# Daily data:
# Recession begins on the first day of the first month following the peak and ends on the last day of the month of the trough. 
# The trough method is used when displaying data on FRED graphs. 
usrecd  <- recession_dates(series_id = "USRECD", frequency = "d")
write_csv(usrecdm, file = "Recession-Dates/NBER/Recession-Dates_NBER_US_Daily_Trough.csv")


### 3) Peak method ----
# USRECDP: (Daily) From the Peak through the Period preceding the Trough

# Recession from the period of the peak to the trough 
# (i.e. the peak is included in the recession shading, but the trough is not). 

# Daily data, the recession begins on the first day of the month of the peak 
# and ends on the last day of the month preceding the trough. 
usrecdp <- recession_dates(series_id = "USRECDP", frequency = "d")
write_csv(usrecdp, file = "Recession-Dates/NBER/Recession-Dates_NBER_US_Daily_Peak.csv")


## Monthly Recession Dates ----

# USREC: (Monthly) From the Period following the Peak through the Trough
usrec <- recession_dates(series_id = "USREC", frequency = "m")
write_csv(usrec, file = "Recession-Dates/NBER/Recession-Dates_NBER_US_Monthly_Trough.csv")

## Webscraping ----
nber_url <- "https://fredhelp.stlouisfed.org/fred/data/understanding-the-data/recession-bars/"

us_nber_rec <- read_html(nber_url) |>
  html_element("#post-2281 > div.entry-content > p:nth-child(5)") |>
  html_text2() |>
  read_delim(delim = ",") |>
  rename(Trough = ` Trough`)

us_nber_rec

## Write the dates to a CSV file ----
write_csv(us_nber_rec, file = "Recession-Dates/NBER/Recession-Dates_NBER_US_Monthly_Trough.csv")

# END