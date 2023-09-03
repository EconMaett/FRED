# ************************************************************************
# Sahm Rule ----
# ************************************************************************
# URL: 
# Feel free to copy, adapt, and use this code for your own purposes.
# Matthias Spichiger (matthias.spichiger@bluewin.ch)
# ************************************************************************

## Load packages ----
library(fredr)
library(tidyverse)
library(rvest)

# - SAHMREALTIME: (Monthly) Real-time Sahm Rule Recession Indicator 
# Sahm Recession Indicator signals the start of a recession when the three-month moving average 
# of the national unemployment rate (U3) rises by 0.50 percentage points or more relative to its 
# low during the previous 12 months.
# This indicator is based on "real-time" data, that is, the unemployment rate 
# (and the recent history of unemployment rates) that were available in a given month. 
# The BLS revises the unemployment rate each year at the beginning of January, 
# when the December unemployment rate for the prior year is published. 
# Revisions to the seasonal factors can affect estimates in recent years. 
# Otherwise the unemployment rate does not revise.



# - SAHMCURRENT: (Monthly) Sahm Rule Recession Indicator 
# Sahm Recession Indicator signals the start of a recession when the three-month moving average
# of the national unemployment rate (U3) rises by 0.50 percentage points or more relative to its 
# low during the previous 12 months.