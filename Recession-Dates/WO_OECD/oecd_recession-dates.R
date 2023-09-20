# ************************************************************************
# OECD recession Dates ----
# ************************************************************************
# URL: https://www.oecd.org/sdd/leading-indicators/oecdcompositeleadingindicatorsreferenceturningpointsandcomponentseries.htm
# Feel free to copy, adapt, and use this code for your own purposes.
# Matthias Spichiger (matthias.spichiger@bluewin.ch)
# ************************************************************************

## Load packages ----
library(fredr)
library(tidyverse)

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
usarecdm <- recession_dates(series_id = "USARECDM", frequency = "d")
write_csv(usarecdm, file = "Recession-Dates/OECD/Recession-Dates_OECD_US_Daily_Midpoint.csv")

chnrecdm <- recession_dates(series_id = "CHNRECDM", frequency = "d")
write_csv(chnrecdm, file = "Recession-Dates/OECD/Recession-Dates_OECD_CHN_Daily_Midpoint.csv")

indrecdm <- recession_dates(series_id = "INDRECDM", frequency = "d")
write_csv(indrecdm, file = "Recession-Dates/OECD/Recession-Dates_OECD_IND_Daily_Midpoint.csv")

rusrecdm <- recession_dates(series_id = "RUSRECDM", frequency = "d")
write_csv(rusrecdm, file = "Recession-Dates/OECD/Recession-Dates_OECD_RUS_Daily_Midpoint.csv")


### 2) Trough Method ----
# USRECD: (Daily) From the Period following the Peak through the Trough

# Recession from the period following the peak through the trough 
# (i.e. the peak is not included in the recession shading, but the trough is). 

# Daily data:
# Recession begins on the first day of the first month following the peak and ends on the last day of the month of the trough. 
# The trough method is used when displaying data on FRED graphs. 
usarecd  <- recession_dates(series_id = "USARECD", frequency = "d")
write_csv(usarecd, file = "Recession-Dates/OECD/Recession-Dates_OECD_US_Daily_Trough.csv")

chnrecd  <- recession_dates(series_id = "CHNRECD", frequency = "d")
write_csv(chnrecd, file = "Recession-Dates/OECD/Recession-Dates_OECD_CHN_Daily_Trough.csv")

indrecd  <- recession_dates(series_id = "INDRECD", frequency = "d")
write_csv(indrecd, file = "Recession-Dates/OECD/Recession-Dates_OECD_IND_Daily_Trough.csv")

rusrecd  <- recession_dates(series_id = "RUSRECD", frequency = "d")
write_csv(rusrecd, file = "Recession-Dates/OECD/Recession-Dates_OECD_RUS_Daily_Trough.csv")


### 3) Peak method ----
# USRECDP: (Daily) From the Peak through the Period preceding the Trough

# Recession from the period of the peak to the trough 
# (i.e. the peak is included in the recession shading, but the trough is not). 

# Daily data, the recession begins on the first day of the month of the peak 
# and ends on the last day of the month preceding the trough. 
usarecdp <- recession_dates(series_id = "USARECDP", frequency = "d")
write_csv(usarecdp, file = "Recession-Dates/OECD/Recession-Dates_OECD_US_Daily_Peak.csv")

chnrecdp <- recession_dates(series_id = "CHNRECDP", frequency = "d")
write_csv(chnrecdp, file = "Recession-Dates/OECD/Recession-Dates_OECD_CHN_Daily_Peak.csv")

indrecdp <- recession_dates(series_id = "INDRECDP", frequency = "d")
write_csv(indrecdp, file = "Recession-Dates/OECD/Recession-Dates_OECD_IND_Daily_Peak.csv")

rusrecdp <- recession_dates(series_id = "RUSRECDP", frequency = "d")
write_csv(rusrecdp, file = "Recession-Dates/OECD/Recession-Dates_OECD_RUS_Daily_Peak.csv")

# END