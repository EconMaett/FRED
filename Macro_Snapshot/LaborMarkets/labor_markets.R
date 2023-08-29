# ************************************************************************
# Labor Markets ----
# URL: https://stlouisfed.shinyapps.io/macro-snapshot/#labor
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

## Unemployment Rate ----
unrate <- fredr(series_id = "UNRATE")

unrate |> 
  select(date, value) |> 
  filter(date >= "2015-01-01") |> 
  ggplot(mapping = aes(x = date, y = value)) +
  geom_line(color = "#374e8e", linewidth = 1) +
  geom_hline(yintercept = 0, linetype = "solid", color = "black", show.legend = NULL) +
  theme_bw() +
  labs(
    title = "Unemployment Rate",
    subtitle = "In percent",
    caption = "Graph created by @econmaett with data from FRED.",
    x = "", y = ""
  )

ggsave(filename = "Macro_Snapshot/LaborMarkets/UNRATE.png", width = 8, height = 4)
graphics.off()


### Non-farm Payroll Employment Growth ----


### Labor Force Participation Rate ----


### Vacancies per Unemployed Person ----


### Unemployment Claims ----

### Average Hourly Earnings Growth of Private Employees ----

### Kansas City Fed Labor Market Conditions Indicator ----

### Labor Demand and Labor Supply ----

# END