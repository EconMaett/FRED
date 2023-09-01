# ************************************************************************
# FRED Series ----
# ************************************************************************
# Based on Sam Boysel, 2023-04-17.
# URL: https://sboysel.github.io/fredr/articles/fredr-series.html
#
# Feel free to copy, adapt, and use this code for your own purposes at
# your own risk.
#
# Matthias Spichiger (matthias.spichiger@bluewin.ch)
# ************************************************************************

## Load packages ----
library(fredr)
library(tidyverse)
library(tsbox)
library(xts)

## Introduction ----

# This vignette introduces the Series endpoint of the FRED API.

# FRED series are assigned a character string identifier:
# - Civilian unemployment rate: series_id = "UNRATE"
# - Real gross national product: series_id = "GNPCA"
# - Effective federal funds rate: series_id = "FEDFUNDS"

# FRED series are assigned categories and tags attributes for organization
# and classification.


## Retrieve observations ----

# The fredr() function is an alias for fredr_series_observations().
# Use ?fredr to find out more:
?fredr

unrate <- fredr(
  series_id = "UNRATE",
  observation_start = date("1990-01-01")
)

head(unrate) # date, series_id, value, realtime_start, realtime_end


## Search for FRED series ----

# Use fredr_series_search_text() to search for a series *by text*
# in the series description.
# The function returns a tibble where each row represents a series
# that matches the search_text:
fredr_series_search_text(
  search_text = "unemployment",
  limit = 100L
)

# Use fred_series_search_id() to search for a series *by character ID":
fredr_series_search_id(
  search_text = "UNRATE",
  limit = 100L
)


## Search for FRED series by tags ----
fredr_series_search_tags(
  series_search_text = "unemployment",
  limit = 100L
)

## Search for FRED series by related tags ----
fredr::fredr_series_search_related_tags(
  series_search_text = "gnp",
  tag_names = "usa",
  limit = 30L
)

## Get basic information for a FRED series ----

fredr_series(series_id = "UNRATE") # id, realtime_start, realtime_ned, title, observation_start

# Note that there may potentially be more than one row returned if the
# series has been revised an real time periods are adjusted:
fredr_series(
  series_id = "UNRATE",
  realtime_start = date("1950-01-01")
)

## Get the categories for a FRED series ----

fredr_series_categories(series_id = "UNRATE")
# id, name, parent_id, notes

fredr_series_categories(series_id = "UNRATE")$notes
# "The ratio of unemployed to the civilian labor force expressed as a percent."


## Get the release for a FRED series ----

# The fredr_series_release() function returns a list of releases that the
# series specified by series_id belongs to.

fredr_series_release(series_id = "UNRATE")
# id, realtime_start, realtime_end, name, press_release, link

fredr_series_release(series_id = "UNRATE")$link
# "http://www.bls.gov/ces/"
# Current Employment Statistics - CES (National)


## Get the tags for a FRED series ----

fredr_series_tags(series_id = "UNRATE", order_by = "name")
# name, group_id, notes, created, poplarity, series_count


## Get a set of recently updated FRED series ----

# The default call simply lists 1'000 recent updates (default value
# for the "limit" parameter).
# The most recent updates appear first.
fredr_series_updates(limit = 10L)


# Use the start_time and end_time parameters to filter the span
# of the returned series.
# Use Sys.time() or lubridate::today() to get data up to the
# last available day:

# For example, only get time series that were updated within the
# last 24 hours:
fredr_series_updates(
  start_time = Sys.time() - 60*60*24,
  end_time = Sys.time(),
  limit = 10L
)


# Using lubridate:
fredr_series_updates(
  start_time = today() - days(1),
  end_time = today(),
  limit = 10L
)


## Get the vintage dates for a FRED series ----

# fredr_series_vintagedates() returns a sequence of dates when
# the specified time series was revised or appended to.
fredr_series_vintagedates(series_id = "UNRATE")


# END