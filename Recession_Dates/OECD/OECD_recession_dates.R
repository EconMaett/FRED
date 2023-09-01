# ************************************************************************
# OECD recession Dates ----
# ************************************************************************
# URL: https://www.oecd.org/sdd/leading-indicators/oecdcompositeleadingindicatorsreferenceturningpointsandcomponentseries.htm
# Feel free to copy, adapt, and use this code for your own purposes at
# your own risk.
#
# Matthias Spichiger (matthias.spichiger@bluewin.ch)
# ************************************************************************

## Load packages ----
library(fredr)
library(tidyverse)

source(file = "Recession_Dates/recession_dates.R")

# The Organisation of Economic Development (OECD) provides three interpretations of its
# Composite Leading Indicators (CLI): Reference Turning Points and Component Series data,
# http://www.oecd.org/std/leading-indicators/oecdcompositeleadingindicatorsreferenceturningpointsandcomponentseries.htm.

# The OECD identifies months of turning points without designating a date within the month that turning points occurred.
# The dummy variable adopts an arbitrary convention that the turning point occurred at a specific date within the month.
# A value of 1 is a recessionary period, while a value of 0 is an expansionary period.

# The period between a peak and trough is always shaded as a recession.
# The peak and trough are collectively extrema.

# In situations where a portion of a period is included in the recession,
# the whole period is deemed to be included in the recession period.

## Three methods ----

### 1. Midpoint method ----
# CHERECDM: (Daily) from the Peak through the Trough

# Shows a recession from the midpoint of the peak through
# the midpoint of the trough for monthly and quarterly data.
# For daily data, the recession begins on the 15th of the month of the peak
# and ends on the 15th of the month of the trough.

# For monthly and quarterly data, the entire peak and trough periods are included in the recession shading.
# This method shows the maximum number of periods as a recession for monthly and quarterly data.

# The Federal Reserve Bank of St. Louis uses this method in its own publications.


### 2. Trough method ----
# CHERECD: (Daily) from the Period following the Peak through the Trough

# Shows a recession from the period following the peak through the trough,
# i.e. the peak is not included in the recession shading, but the trough is.

# For daily data, the recession begins on the first day of the first month following the peak
# and ends on the last day of the month of the trough.

# The trough method is used when displaying data on FRED graphs.


### 3. Peak method ----
# CHERECDP: (Daily) from the Peak through the Period preceding the Trough

# Shows a recession from the period of the peak to the trough,
# i.e. the peak is included in the recession shading, but the trough is not.

# For daily data, the recession begins on the first day of the month of the peak
# and ends on the last day of the month preceding the trough.


## OECD vs NBER recession dates ----

# The OECD CLI system is based on the "growth cycle" approach,
# where business cycles and turning points are measured and
# identified in the deviation-from-trend series.

# The main reference series used in the OECD CLI system for the majority of countries is
# industrial production (IIP) covering all industry sectors excluding construction.

# This series is used because of its cyclical sensitivity and monthly availability,
# while the broad based Gross Domestic Product (GDP) is used to supplement the IIP series for
# identification of the final reference turning points in the growth cycle.

# Up to December 2008 the turning points chronologies shown for regional/zone area aggregates
# or individual countries are determined by the rules established by the National Bureau of Economic Research (NBER)
# in the United States, which have been formalized and incorporated in a computer routine (Bry and Boschan)
# and included in the Phase-Average Trend (PAT) de-trending procedure.

# Starting from December 2008 the turning point detection algorithm is decoupled from the de-trending procedure,
# and is a simplified version of the original Bry and Boschan routine.
# (The routine parses local minima and maxima in the cycle series
# and applies censor rules to guarantee alternating peaks and troughs, as well as phase and cycle length constraints.)

# The components of the CLI are time series which exhibit leading relationship
# with the reference series (IIP) at turning points.
# Country CLIs are compiled by combining de-trended smoothed and normalized components.
# The component series for each country are selected based on various criteria such as:
# - economic significance
# - cyclical behavior
# - data quality
# - timeliness
# - availability

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