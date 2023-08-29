# ************************************************************************
# Other Real Indicators ----
# ************************************************************************
# URL: https://stlouisfed.shinyapps.io/macro-snapshot/#real
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


### Real Personal Income ----


### Personal Savings ----


### Real Retail Sales ----


### Light Weight Vehicle Sales ----


### Industrial Production -----


### Capacity Utilization, Total Industry ----


### Manufacturers' Non-defense Capital Goods Shipments ---


### Manufacturers' New Durable Goods Orders ----


### New Private Housing Construction ----


### Housing Prices ----


### Weekly Economic Index (Lewis-Mertens-Stock) ----
# Website: https://www.newyorkfed.org/research/policy/weekly-economic-index#/
wei <- fredr(series_id = "WEI")
wei |> 
  select(date, value) |> 
  filter(date >= "2015-01-01") |> 
  ggplot(mapping = aes(x = date, y = value)) +
  geom_line(color = "#374e8e", linewidth = 1) +
  geom_hline(yintercept = 0, linetype = "dashed", color = "black", linewidth = 1) +
  scale_x_date(date_breaks = "1 year", date_labels = "%y") +
  scale_y_continuous(limits = c(-10, 15)) +
  theme_bw() +
  labs(
    title = "Weekly Economic Index (Lewis-Mertens-Stock)",
    subtitle = "Index",
    caption = "Graph created by @econmaett with data from FRED.",
    x = "", y = ""
  )

ggsave(filename = "Macro_Snapshot/OtherRealIndicators/WEI.png", width = 8, height = 4)
graphics.off()

# END