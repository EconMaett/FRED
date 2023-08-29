# ************************************************************************
# FRED Sources ----
# ************************************************************************
# Based on Sam Boysel, 2023-04-17.
# URL: https://sboysel.github.io/fredr/articles/fredr-sources.html
#
# Feel free to copy, adapt, and use this code for your own purposes at
# your own risk.
#
# Matthias Spichiger, 2023 (matthias.spichiger@bluewin.ch)
# ************************************************************************

## Load packages ----
library(fredr)
library(tidyverse)
library(tsbox)
library(xts)

## Introduction ----

# This vignette introduces the Sources endpoint of the FRED API.

# FRED series are derived from several data **sources**.
# Each fRED source is assigned a unique integer identifier.


## Get FRED sources ----

fredr_sources(limit = 10L)
# The default for limit is 1'000.
# id, realtime_start/_end, name, link

# Sources include: 
# - Board of Governors of the Federal Reserve System (US)

# - 12 Federal Reserve Banks
#   - Atlanta, Georgia: Covers Alabama, Florida, and Georgia
#     - Produces GDPnow
#     - Produces the Wage Growth Tracker
#   - Boston, Massachusetts: Covers New England
#   - Chicago: Covers Iowa and the Midwest (Illinois, Indiana, Michigan, Wisconsin)
#   - Cleveland, Missouri: Covers Ohio, Western Pennsylvania, Eastern Kentucky
#   - Dallas, Texas: Covers Texas, Louisiana, New Mexico (the Oil Patch).
#   - Kansas City, Missouri: Covers Arkansas and Parts of the Southwest
#     - Holds the annual economic symposium in Jackson Hole, Wyoming.
#   - Minneapolis, Minnesota: Covers the North West (Minnesota, Montana, North Dakota, South Dakota)
#   - New York: Covers New York, New Jersey, Fairfield County Connecticut, Puerto Rico, the U.S. Virgin Islands. Located at 33 Liberty Street in Lower Manhatten
#     - Largest (by assets) and most active (by volume) of the Reserve Banks.
#     - Has the unique responsibility of implementing monetary policy on behalf of the Federal Open Market Committee (FOMC)
#     - Houses the Open Market Trading Desk and manages System Open Market Account
#     - Is the sole fiscal agent of the U.S. Department fo the Treasury
#     - Custodian of the world's largest gold reserve.
#     - Produces the Empire State Index (faster than Philly Fed Mfg Index).
#   - Philadelphia: Covers Pennsylvania, Delaware and Southern New Jersey.
#     - Produces the monthly Philly Fed Manufacturing Index 
#     - Publishes the Survey of Professional Forecasters (SPF).
#   - Richmond, Virginia: Covers West Virginia, Maryland, D.C., Virginia, North Carolina and South Carolina
#   - San Francisco, California: Covers Alaska, California, Hawaii, Nevada, Oregon, Washington, Utah, Idaho
#   - St. Louis, Missouri: (Missouri is the only state with two branches) 
#     - Maintains the Federal Reserve Economic Database (FRED)
#     - Maintains the Research Papers in Economics (RePEc) 

# - Other National Banks
#   - Reserve Bank of Australia
#   - Swiss National Bank

# - Third party private data providers
#   - Dow Jones & Company
#   - Haver Analytics

# - U.S. Statistical agencies
#   - U.S. Office of Management and Budget
# - U.S. Congressional Budget Office
# - U.S. Bureau of Economic Analysis (BEA)
# - U.S. Census Bureau
# - U.S. Department of Housing and Urban Development
# - U.S. Bureau of Labor Statistics (BLS)
# - U.S. Department of the Treasury

# - Private universities
# - University of Michigan


## Get a single FRED source ----

# The source ID for the Federal Financial Institutions Examination
# Council is 6:
fredr_source(
  source_id = 6L # Federal Financial Institutions Examination Council
)


# 34  for ths Swiss National Bank?
fredr_source(
  source_id = 34L # Swiss National Bank
)

## Get FRED releases for a source ----

# Get the first 10 releases from the Federal Reserve Board of Governors,
# ordered by ascending release ID:
fredr_source_releases(
  source_id = 1L, # Federal Reserve Board of Governors
  limit = 10L
)

# Get University of Michigan releases since 1950:
fredr_source_releases(
  source_id = 14L, # University of Michigan
  realtime_start = date("1950-01-01")
)
# The University of Michigan provides only the Survey of 
# Consumers

# Get all the releases form the SNB:
fredr_source_releases(
  source_id = 34L # SNB
)

fredr_source(source_id = 34L) # Swiss National Bank

# The FRED only includes three releases from the SNB:
# - Swiss Foreign Exchange Intervantion
# - Swiss National Bank Monthly Statistical Bulletin
# - Swiss National Bank HIstorical Time Series

fredr_source_releases(
  source_id = 34L
)[3,]$link
# https://www.snb.ch/en/iabout/stat/statrep/statpubdis/id/statpub_histz_arch#t3
# This is a one-time-only release of statistical brochures in 2007.

# END