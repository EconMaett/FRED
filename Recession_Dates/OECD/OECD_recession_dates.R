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



## Load the data ----

# Since the trough method is used when displaying data on FRED graphs,
# this is the data we want:

# CH OECD, daily, monthly, quarterly: CHERECD, CHERECDM, CHERECDP
cherecd <- recession_dates(series_id = "CHERECD", frequency = "d")
cherecd

# NBER recession dates are available at monthly, quarterly or annual frequency
# OECD recession dates are available at daily frequency too.

# USA NBER: USRECD, USRECDM, USRECDP
usrec <- recession_dates(series_id = "USREC", frequency = "m")

# USA OECD: USARECDM, USARECD, USARECDP

# China OECD: CHNRECDM, CHNRECD, CHNRECDP

# OECD India: INDRECD, INDRECDM, INDRECDP

# OECD UK: GBRRECDM, GBRRECD, GBRRECDP