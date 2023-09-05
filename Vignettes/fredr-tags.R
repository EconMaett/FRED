# ************************************************************************
# FRED Tags ----
# ************************************************************************
# Based on Sam Boysel, 2023-04-17.
# URL: https://sboysel.github.io/fredr/articles/fredr-tags.html
# Feel free to copy, adapt, and use this code for your own purposes.
# Matthias Spichiger (matthias.spichiger@bluewin.ch)
# ************************************************************************

## Load packages ----
library(fredr)
library(tidyverse)
library(tsbox)
library(xts)

## Introduction ----

# This vignette introduces the Tags endpoint of the fRED API.

# FRED series are assigned **tags** as an attribute for classification.
# Each FRED tag has a unique string ID.
# frequencies: "annual", "monthly",
# source: "census", "bls"
# geography: "usa", "county"
# "manufacturing", "exports", "households"
# "sa" (seasonally adjusted)


## Get series tags ----

fredr_tags(limit = 5)

# Return tags specific tags by tag name:
fredr_tags(tag_names = "gdp;oecd", limit = 5)

# Return tags for a given group ID:
fredr_tags(
  tag_group_id = "geo",
  limit = 5
)

# Search for tags by text:
fredr_tags(search_text = "unemployment")

# Note that there are several tags matching "unemployment".
# To search for the set of *series* with series ID for unemployment,
# use fredr_series_search_tags():
fredr_series_search_tags(
  series_search_text = "unemployment",
  limit = 10L
)

# Filter for tags belonging to the "General" tag group:
fredr_related_tags(
  tag_names = "monetary aggregates;weekly",
  tag_group_id = "gen"
)
# M1, M2, M3, MZM Money Stock


# Keep only the tags matching the string "money stock":
fredr_related_tags(
  tag_names = "monetary aggregates;weekly",
  tag_group_id = "gen",
  search_text = "money stock"
)


## Get series by tag names ----
# Get all series tagged with "gdp":
fredr_tags_series(tag_names = "gdp")

# Get the top 100 most popular non-quarterly series tagged with "gdp":
fredr_tags_series(
  tag_names = "gdp",
  exclude_tag_names = "quarterly",
  order_by = "popularity",
  limit = 10L
)

# Those are annual series that are not very popular in general 

# END
