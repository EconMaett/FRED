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

source(file = "Recession_Dates/recession_dates.R")

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
write_csv(usarecdm, file = "Recession_Dates/OECD/US_OECD_Midpoint_Daily_Recession_Dates.csv")

cherecdm <- recession_dates(series_id = "CHERECDM", frequency = "d")
write_csv(cherecdm, file = "Recession_Dates/OECD/CH_OECD_Midpoint_Daily_Recession_Dates.csv")

chnrecdm <- recession_dates(series_id = "CHNRECDM", frequency = "d")
write_csv(chnrecdm, file = "Recession_Dates/OECD/CHN_OECD_Midpoint_Daily_Recession_Dates.csv")

indrecdm <- recession_dates(series_id = "INDRECDM", frequency = "d")
write_csv(indrecdm, file = "Recession_Dates/OECD/IND_OECD_Midpoint_Daily_Recession_Dates.csv")

rusrecdm <- recession_dates(series_id = "RUSRECDM", frequency = "d")
write_csv(rusrecdm, file = "Recession_Dates/OECD/RUS_OECD_Midpoint_Daily_Recession_Dates.csv")

eurorecdm <- recession_dates(series_id = "EURORECDM", frequency = "d")
write_csv(eurorecdm, file = "Recession_Dates/OECD/EURO_OECD_Midpoint_Daily_Recession_Dates.csv")


### 2) Trough Method ----
# USRECD: (Daily) From the Period following the Peak through the Trough

# Recession from the period following the peak through the trough 
# (i.e. the peak is not included in the recession shading, but the trough is). 

# Daily data:
# Recession begins on the first day of the first month following the peak and ends on the last day of the month of the trough. 
# The trough method is used when displaying data on FRED graphs. 
usarecd  <- recession_dates(series_id = "USARECD", frequency = "d")
write_csv(usarecd, file = "Recession_Dates/OECD/US_OECD_Trough_Daily_Recession_Dates.csv")

cherecd  <- recession_dates(series_id = "CHERECD", frequency = "d")
write_csv(cherecd, file = "Recession_Dates/OECD/CH_OECD_Trough_Daily_Recession_Dates.csv")

chnrecd  <- recession_dates(series_id = "CHNRECD", frequency = "d")
write_csv(chnrecd, file = "Recession_Dates/OECD/CHN_OECD_Trough_Daily_Recession_Dates.csv")

indrecd  <- recession_dates(series_id = "INDRECD", frequency = "d")
write_csv(indrecd, file = "Recession_Dates/OECD/IND_OECD_Trough_Daily_Recession_Dates.csv")

rusrecd  <- recession_dates(series_id = "RUSRECD", frequency = "d")
write_csv(rusrecd, file = "Recession_Dates/OECD/RUS_OECD_Trough_Daily_Recession_Dates.csv")

eurorecd  <- recession_dates(series_id = "EURORECD", frequency = "d")
write_csv(eurorecd, file = "Recession_Dates/OECD/EURO_OECD_Trough_Daily_Recession_Dates.csv")


### 3) Peak method ----
# USRECDP: (Daily) From the Peak through the Period preceding the Trough

# Recession from the period of the peak to the trough 
# (i.e. the peak is included in the recession shading, but the trough is not). 

# Daily data, the recession begins on the first day of the month of the peak 
# and ends on the last day of the month preceding the trough. 
usarecdp <- recession_dates(series_id = "USARECDP", frequency = "d")
write_csv(usarecdp, file = "Recession_Dates/OECD/US_OECD_Peak_Daily_Recession_Dates.csv")

cherecdp <- recession_dates(series_id = "CHERECDP", frequency = "d")
write_csv(cherecdp, file = "Recession_Dates/OECD/CH_OECD_Peak_Daily_Recession_Dates.csv")

chnrecdp <- recession_dates(series_id = "CHNRECDP", frequency = "d")
write_csv(chnrecdp, file = "Recession_Dates/OECD/CHN_OECD_Peak_Daily_Recession_Dates.csv")

indrecdp <- recession_dates(series_id = "INDRECDP", frequency = "d")
write_csv(indrecdp, file = "Recession_Dates/OECD/IND_OECD_Peak_Daily_Recession_Dates.csv")

rusrecdp <- recession_dates(series_id = "RUSRECDP", frequency = "d")
write_csv(rusrecdp, file = "Recession_Dates/OECD/RUS_OECD_Peak_Daily_Recession_Dates.csv")

eurorecdp <- recession_dates(series_id = "EURORECDP", frequency = "d")
write_csv(eurorecdp, file = "Recession_Dates/OECD/EURO_OECD_Peak_Daily_Recession_Dates.csv")

# END