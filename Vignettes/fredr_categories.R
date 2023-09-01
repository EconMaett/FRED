# ************************************************************************
# FRED Categories ----
# ************************************************************************
# Based on Sam Boysel, 2023-04-17.
# URL: https://sboysel.github.io/fredr/articles/fredr-categories.html
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

# This vignette introduces the Categories endpoint of the FRED API.

# FRED seris are assigned to **categories**.
# Each FRED category is assigned an integer identifier:
# - Population, Employment, & Labor Markets: category_id = 10
# - National Accounts: category_id = 32992
# - Production & Business Activity: category_id = 1
# - Housing: category_id = 97

# Categories have a hierarchical structure with parent categories
# containing child categories.

# All categories are children of the root category (category_id = 0).


## Get a FRED category ----

# fredr_category() returns minimal information about the category specified
# in category_id as a tibble:
fredr_category(category_id = 0L)
# id, name, parent id

fredr_category(category_id = 1L)
# name: Produciton & Business aCtivity

fredr_category(category_id = 2L)
# Productivity & Costs

fredr_category(category_id = 3L)
# Industrial Production & Capacity Utilization

fredr_category(category_id = 4L)
# Employment Cost Index

fredr_category(category_id = 5L)
# Federal Government Debt

fredr_category(category_id = 6L)
# Retail Trade

fredr_category(category_id = 97L)
# Housing


## Get the children of a FRED category ----

# fredr_category_children() returns minimal information (child ID,
# name, parent ID) for all child categories of the parent category
# specified by category_id:
fredr_category_children(category_id = 0L)
# The root category (0) has 8 child categories:
# - Money, Banking, & Finance: category_id = 32991
# - Population, Employment, & Labor Markets: category_id = 10
# - National Accounts: category_id = 32992
# - Produciton & Business Activity: category_id = 1
# - Prices: category_id = 32455
# - International Data: category_id = 32264
# - U.S. Regional Data: category_id = 3008
# - Academic Data: category_id = 33060

fredr_category_children(category_id = 1L)
# The parent category "National Accounts" (category_id = 1)
# has 16 child categories:
# - Business Cycle Expansions & Contractions
# - Business Surveys
# - Construction
# - Emissions
# - Expenditures
# - Finance Companies
# - Health Insurance
# - Housing
# - Industrial Production & Capacity Utilization
# - Manufacturing
# - Patents
# - Retail Trade
# - Services
# - Technology
# - Transportation
# - Wholsale Trade


## Get a related FRED category ----
# Note that not all categories have related categories.

# Nothin is related to the root category:
fredr_category_related(category_id = 0L)
# A tibble: 0 x 0

# What is related to the Emloyment Cost Index category?
fredr_category_related(category_id = 4L)
# Population, Employment, & Labor Markets: category_id = 10


## Get series in a category ----

# Get the top 100 quarterly series in the category "Housing" (category_id = 97),
# and order the result so that the most recently updated series appears first:
fredr_category_series(
  category_id = 97L, # Housing
  limit = 100L,
  order_by = "last_updated",
  filter_variable = "frequency",
  filter_value = "Quarterly"
)

# Return all series in the category "National Accounts" tagged with
# "usa" and *not* "gnp", in descending order, meaning that
# higher frequency series appear first:
fredr_category_series(
  category_id = 32992L, # National Accounts
  order_by = "frequency",
  sort_order = "desc",
  tag_names = "usa",
  exclude_tag_names = "gnp"
)


## Get tags with a FRED category ----

# Get all "source" tags belonging to series in the category
# "Retail Trade"
fredr_category_tags(
  category_id = 6L, # Retail Trade
  tag_group_id = "src" # source
)
# Census (cencus), St. Louis Fed (frb stl), Chicago Fed (frb chi),
# Bureau of Economic Analysis (bea)

# Search for tags with the words "usa" in the category
# "Production & Buisness Activity", ordered by popularity:
fredr_category_tags(
  category_id = 1L, # Production & Buisness Acitvity
  search_text = "usa",
  order_by = "popularity",
  sort_order = "desc"
)


## Get related tags within a FRED category ----

# Get all tags *except* "rate" in the category "Production & Buisness Acitvity" 
# that are related to the tags "business" and "monthly",
# ordered alphabetically:
fredr_category_related_tags(
  category_id = 1L, # Production & Buisness Acitvity
  tag_names = "business;monthly",
  exclude_tag_names = "rate",
  order_by = "name"
)

# END
