# ************************************************************************
# FRED Releases ----
# ************************************************************************
# Based on Sam Boysel, 2023-04-17.
# URL: https://sboysel.github.io/fredr/articles/fredr-releases.html
# Feel free to copy, adapt, and use this code for your own purposes.
# Matthias Spichiger (matthias.spichiger@bluewin.ch)
# ************************************************************************

## Load packages ----
library(fredr)
library(tidyverse)
library(tsbox)
library(xts)

## Introduction ----

# This vignette introduces the Releases endpoint of the FRED API.

# FRED time series are added to the database over time in **releases**.
# Each FRED release is assigned an integer identifier.


## Get all releases of econoomic data ----
fredr_releases()
# id, realtime_start, realtime_end, name, press_relase, link, notes
# The function only returns up to 1'000 releases.

# Check out the notes:
fredr_releases()[1, ]$notes


## Get release dates for all releases of economic data
# Maximum of 1'000 releases
fredr_release_dates()

# To instead order the results by ascending release ID:
fredr_releases_dates(
  sort_order = "asc",
  order_by = "release_id"
)


## Get a release of economic data ----

# Get release data for the Employment Cost Index:
fredr_release(
  release_id = 11L # Employment Cost Index
)


## Get release dates for single release of economic data ----

fredr_release_dates(
  release_id = 11L # Employment Cost Index
)


## Get the series in a release of economic data ----

fredr_release_series(
  release_id = 10L # Consumer Prices 
)

# Note the parameters available to filter series belonging to a release:
fredr_release_series(
  release_id = 10L,
  filter_variable = "frequency",
  filter_value = "Monthly",
  order_by = "popularity",
  sort_order = "desc",
  limit = 10L
)


## Get the FRED tags for a release ----
# Get the geographic tags (tag_group_id = "geo") assigned to series
# in the Consumer Price Index release (release_id = 10):
fredr_release_tags(
  release_id = 10L, # Consumer Price Index
  tag_group_id = "geo",
  order_by = "popularity",
  sort_order = "desc"
)
# We see that the releases for the CPI of the whole USA are twice
# as popular as the CPI releases for individual states.


## Get the related FRED tags for one or more FRED tags within a release ----
# Get the frequency tags assigned to series in the CPI release that
# are also related to the tag "bls" and *not* to the tag "annual":
fredr_release_related_tags(
  release_id = 10L,
  tag_names = "bls",
  tag_group_id = "freq",
  exclude_tag_names = "annual",
  order_by = "popularity",
  sort_order = "desc"
)
# Monthly and semiannual frequencies were included.
# Monthly frequencies are thrice as popular as semiannual ones.


## Get the source for a release of economic data ----

# The function fredr_release_tables() returns a set of FRED release
# tables for the FRED release specified by "release_id".

# The data is returned as a "tibble" object where each row represents
# one of the table tree's children.

# The column "name" gives the element ID and the column "value" stores
# the data noedws for the element (element ID, release ID, parent ID,
# element type, element name, children, etc.).

# Get the table tree for the CPI release:
cpi_tbl <- fredr_release_tables(release_id = 10L)
cpi_tbl

cpi_tbl |> 
  slice(2) |> 
  deframe() # Converts vectors and lists to data frames and vice versa

# You can extract the tree hierarchy of a deeper element by specifying
# an element_id.

# If you wanted to get the subtree for the child element "35712"
# of the CPI table:
fredr_release_tables(
  release_id = 10L, # CPI
  element_id = 36712L
)

# END