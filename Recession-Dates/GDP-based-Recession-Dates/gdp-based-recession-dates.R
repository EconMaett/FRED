# ************************************************************************
# GDP-based Recession Dates ----
# ************************************************************************
# URL: https://econbrowser.com/recession-index
# Feel free to copy, adapt, and use this code for your own purposes.
# Matthias Spichiger (matthias.spichiger@bluewin.ch)
# ************************************************************************

## Load packages ----
library(fredr)
library(tidyverse)

source(file = "Recession-Dates/recession-dates.R")

# JHDUSRGDPBR: Dates of U.S. recessions as inferred by GDP-based recession indicator	
jhdusrgdpbr <- recession_dates(series_id = "JHDUSRGDPBR", frequency = "q")
write_csv(jhdusrgdpbr, file = "Recession-Dates/GDP-based-Recession-Dates/Recession-Dates_GDP-based_US_Quarterly_Midpoint.csv")

# END