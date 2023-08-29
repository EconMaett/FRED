# ************************************************************************
# Financial Markets ----
# ************************************************************************
# URL: https://stlouisfed.shinyapps.io/macro-snapshot/#financial
#
# Feel free to copy, adapt, and use this code for your own purposes at
# your own risk.
#
# Matthias Spichiger, 2023 (matthias.spichiger@bluewin.ch)
# ************************************************************************

## Load packages ----
library(fredr)
library(tidyverse)
library(scales)
library(ggtext)
library(tsbox)
library(xts)

### Effective Federal Funds Rate ----
dff <- fredr(series_id = "DFF")
dff |> 
  select(date, value) |> 
  ggplot(mapping = aes(x = date, y = value)) +
  geom_line(linewidth = 1, color = "#374e8e") +
  scale_x_date(limits = c(date("2015-01-01"), NA), date_breaks = "1 year", date_labels = "%y") +
  scale_y_continuous(limits = c(0, 6), breaks = 0:6) +
  theme_bw() +
  labs(
    title = "Effective Federal Funds Rate",
    subtitle = "In percent",
    caption = "Graph created by @econmaett with data from FRED.",
    x = "", y = ""
  )

ggsave(filename = "Macro_Snapshot/FinancialMarkets/EFF.png", height = 8, width = 4)
graphics.off()


### Federal Reserve Assets ----
# Total Assets
# Less Eliminations from Consolidation
# Wednesday Level
walcl <- fredr(series_id = "WALCL")
walcl |> 
  select(date, value) |> 
  ggplot(mapping = aes(x = date, y = value)) +
  geom_line(linewidth = 1, color = "#374e8e") +
  scale_x_date(limits = c(date("2015-01-01"), NA), date_breaks = "1 year", date_labels = "%y") +
  scale_y_continuous(limits = c(0, 10e6), labels = label_number(suffix = "M", scale = 1e-6), breaks = c(0:10)*1e6) +
  theme_bw() +
  labs(
    title = "Federal Reserve Assets",
    subtitle = "In millions (M) of dollars",
    caption = "Graph created by @econmaett with data from FRED.",
    x = "", y = ""
  )

ggsave(filename = "Macro_Snapshot/FinancialMarkets/WALCL.png", height = 8, width = 4)
graphics.off()

### Mortgage Rates ----


### Treasury Yields ----

### Yield Spreads ----

### Financial Market Stress Indices ----

### Stock Market Indices ----

### Corporate Bond Spreads ----

# END