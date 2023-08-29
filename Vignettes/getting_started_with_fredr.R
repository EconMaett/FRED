# ************************************************************************
# Getting started with fredr ----
# ************************************************************************
# CRAN: https://cran.r-project.org/web/packages/fredr/index.html
# Vignette: https://cran.r-project.org/web/packages/fredr/vignettes/fredr.html
# Based on Sam Boysel, 2021-01-29.
#
# Feel free to copy, adapt, and use this code for your own purposes at
# your own risk.
#
# Matthias Spichiger, 2023 (matthias.spichiger@bluewin.ch)
# ************************************************************************

## Load packages ----
library(tidyverse)
library(fredr)
library(xts)
library(tsbox)

## Introduction ----

# The "fredr" package provides bindings to the
# Federal REserve Economic Data (FRED) RESTful API 
# provided by the Federal Reserve Bank of St. Louis.
# FRED: https://fred.stlouisfed.org/

# The core function is fredr() which fetches observations
# for FRED time series.

# fredr_searies_search_text() allows you to search for a 
# FRED series by text.

## Authentication ----

# To use the FRED API you must obtain a FRED API key.
# "c6111687930cefedd1119a2c7263fa3e"

# Once you have obtained the API key, the best way to use it
# is to set the key as an environment variable called
# FRED_API_KEY.

# The easiest way is by calling
# usethis::edit_r_environ() to open a .Renviron file
# and set the key as:
# FRED_API_KEY=c6111687930cefedd1119a2c7263fa3e
usethis::edit_r_environ()

# You need to restart R after saving and closing
# the .Renviron file.

# Alternatively, you can set an API key just for the
# current session with fredr_set_key():
fredr::fredr_set_key(key = "FRED_API_KEY=c6111687930cefedd1119a2c7263fa3e")

# This will only set the key for the current R session,
# and it is recommended to use an environment variable.


## Retrieve series observations ----

# The fredr() function is an alias for the 
# fredr_series_observations() function that
# retrieves the observations of the FRED time series data.
# You need to specify the FRED series ID.
# The function returns an object of type "tibble"
# with 3 columns (date, ID, value):
unrate <- fredr(
  series_id = "UNRATE",
  observation_start = as.Date("1990-01-01"),
  observation_end = today()
)

head(unrate) # date, series_id, value, realtime_start
unrate |> 
  select(date, value) |> 
  rename(time = date) |> 
  ggplot(mapping = aes(x = time, y = value)) +
  geom_line(linewidth = 1, color = "black") +
  geom_hline(yintercept = 0, color = "black", linetype = "solid", show.legend = FALSE) +
  theme_bw() +
  labs(
    title = "U.S. unemployment rate (in %)",
    subtitle = "",
    caption = "Graph created by @econmaett with FRED data.",
    x = "", y = ""
  )

graphics.off()


# Leverage the native features of the FRED API by passing additional parameters:
unrate <- fredr(
  series_id = "UNRATE",
  observation_start = date("1990-01-01"),
  observation_end = today(),
  frequency = "q", # quarterly
  units = "chg" # change over previous value
)

names(unrate) # date, series_id, value, realtime_start, realtime_end

unrate |> 
  select(date, value) |> 
  rename(time = date) |> 
  ggplot(mapping = aes(x = time, y = value)) +
  geom_line(linewidth = 1, color = "black") +
  geom_hline(yintercept = 0, linetype = "solid", color = "black", show.legend = NULL) +
  scale_y_continuous(limits = c(-5, 10)) +
  theme_bw() +
  labs(
    title = "U.S. unemployment rate",
    subtitle = "Change over previous obervation",
    caption = "Graph created by @econmaett with FRED data.",
    x = "", y= ""
  )

graphics.off()


## fredr plays nicely with the tidyverse package
popular_funds_series <- fredr_series_search_text(
  search_text = "federal funds",
  order_by = "popularity",
  sort_order = "desc", 
  limit = 1 # Maximum number of results to return
)

popular_funds_series # id, realtime_start, realtime_end, title, observation_start

popular_funds_series_id <- popular_funds_series$id # id: FEDFUNDS

popular_funds_series_id |> 
  fredr(
    observation_start = date("1990-01-01"),
    observation_end = today()
  ) |> 
  ggplot(mapping = aes(x = date, y = value, color = series_id)) +
  geom_line(linewidth = 1) +
  labs(
    x = "", y = "", color = "Series"
  ) +
  theme_minimal()


# Since fredr() returns a tibble with a series ID, mapping fredr()
# over a vector of series can be useful:
map_dfr(.x = c("UNRATE", "FEDFUNDS"), .f = fredr) |> 
  ggplot(mapping = aes(x = date, y = value, color = series_id)) +
  geom_line(linewidth = 1) +
  labs(x = "", y = "", color = "Series") +
  theme_bw()

# purrr::pmap_dfr() allows you to use varying optional parameters as well:
params <- list(
  series_id = c("UNRATE", "OILPRICE"),
  frequency = c("m", "q")
)

pmap_dfr(
  .l = params,
  .f = ~ fredr(series_id = .x, frequency = .y)
) |> 
  ggplot(mapping = aes(x = date, y = value, color = series_id)) +
  geom_line(linewidth = 1) +
  labs(x = "", y = "", color = "Series") +
  theme_bw()
graphics.off()


# You can easily convert the tibbles returned by fredr() into other
# time series objects:

gnpca <- fredr(series_id = "GNPCA", units = "log") |> 
  mutate(value = value - lag(value)) |> 
  filter(!is.na(value))

gnpca.xts <- xts(x = gnpca$value, order.by = gnpca$date)

gnpca.xts |> 
  StructTS() |> # Fit a structural model for the time series
  residuals() |> 
  acf(main = "ACF for First Differenced real US GNP, log")
graphics.off()


## Endpoints ----

# fredr provides functions for all FRED API endpoints.
fredr_endpoints


## View FRED API documentation ----
fredr_docs()
# Opens the website https://fred.stlouisfed.org/docs/api/fred/

## General queries ----

# You can use the low-level function fredr_request() to run more general
# queries against *any* FRED API endpoint, e.g. Categories, Series, Sources, Releases, Tags.

# The required parametr is "endpoint" and the API paarameters are passed
# through as named arguments:
fredr_request(
  endpoint = "tags/series",
  tag_names = "population;south africa",
  limit = 25L
)

# By default, fredr_request() returns a tibble.
# Set to_frame = FALSE to return a generic "response" object
# returned by a httr::GET() request that can be parsed further with
# httr::content():
fredr_request(
  endpoint = "series/observations",
  series_id = "UNRATE",
  to_frame = FALSE
)

# END