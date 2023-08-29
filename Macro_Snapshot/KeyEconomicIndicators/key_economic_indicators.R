# ************************************************************************
# Key Economic Indicators ----
# ************************************************************************
# Key series the FOMC highlights in its Summary of Economic Projections (SEP)
# URL: https://stlouisfed.shinyapps.io/macro-snapshot/#keyIndicators
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

# Possible changes:
# - Shaded areas indicating NBER recessions
# - SEP projections as single data points or box plots
# - Monthly observations are assigned to the first day of
#   the new month, e.g 2023-07-01. But then it looks as if this
#   observation belongs to the last month. Change this.


### Real Gross Domestic Product (GDP) Growth ----

# We use purrr::pmap_dfr() which allows varying optional parameters:
params <- list(
  series_id = c("GDPC1", "GDPC1RH", "GDPC1RL", "GDPC1CTH", "GDPC1CTL", "GDPC1MD"),
  unis = c("pc1", "lin", "lin", "lin", "lin", "lin")
)

df <- purrr::pmap_dfr(.l = params, .f = ~fredr(series_id = .x, units = .y, observation_end = today() + years(4))) |> 
  select(date, series_id, value) |> 
  filter(date >= "2015-01-01")

df |> 
  ggplot() +
  geom_line(data = df |> filter(series_id == "GDPC1"), mapping = aes(x = date, y = value), color = "#006d64", linewidth = 1) +
  geom_boxplot(data = df |> filter(series_id != "GDPC1"), mapping = aes(x = date, y = value, group = date),
               show.legend = NULL, width = 50, fill = "#df7c18") +
  geom_hline(yintercept = 0, linetype = "dashed", color = "black", show.legend = NULL) +
  scale_x_date(date_breaks = "1 year", date_labels = "%y") +
  scale_y_continuous(limits = c(-10, 15)) +
  theme_bw() +
  labs(
    title = "Real Gross Domestic Product (GDP) growth & SEP projection",
    subtitle = "Year-over-year % change",
    caption = "Graph produced by @econmaett with data from FRED.",
    x = "", y = ""
  )

ggsave(filename = "Macro_Snapshot/KeyEconomicIndicators/RealGDPgrowth.png", width = 8, height = 4)
graphics.off()


### Unemployment rate ----
series_id <- c("UNRATE", "UNRATERH", "UNRATECTH", "UNRATEMD", "UNRATECTL", "UNRATERL")
df <- purrr::map_dfr(.x = series_id, .f = fredr) |> 
  select(date, series_id, value) |> 
  filter(date >= "2015-01-01")

df |> 
  ggplot() +
  geom_line(data = df |> filter(series_id == "UNRATE"), mapping = aes(x = date, y = value), color = "#006d64", linewidth = 1) +
  geom_boxplot(data = df |> filter(series_id != "UNRATE"), mapping = aes(x = date, y = value, group = date),
               show.legend = NULL, width = 50, fill = "#df7c18") +
  geom_hline(yintercept = 0, linetype = "solid", color = "black", show.legend = NULL) +
  scale_x_date(date_breaks = "1 year", date_labels = "%y") +
  theme_bw() +
  labs(
    title = "Unemployment rate & SEP projection",
    subtitle = "In percent",
    caption = "Graph produced by @econmaett with data from FRED.",
    x = "", y = ""
  )

ggsave(filename = "Macro_Snapshot/KeyEconomicIndicators/UnemploymentRate.png", width = 8, height = 4)
graphics.off()

### Personal consumption expenditures (PCE) inflation ----
params <- list(
  series_id = c(
    "PCEPI", "PCECTPIRH", "PCECTPICTH", "PCECTPIMD", "PCECTPICTL", "PCECTPIRL",
    "PCEPILFE", "JCXFERH", "JCXFECTH", "JCXFEMD", "JCXFECTL", "JCXFERL"
    ),
  unis = c(
    "pc1", "lin", "lin", "lin", "lin", "lin",
    "pc1", "lin", "lin", "lin", "lin", "lin")
)

df <- purrr::pmap_dfr(.l = params, .f = ~fredr(series_id = .x, units = .y)) |> 
  select(date, series_id, value) |> 
  filter(date >= "2015-01-01")

df |> 
  ggplot() +
  geom_line(data = df |> filter(series_id == "PCEPI"), mapping = aes(x = date, y = value), color = "#374e8e", linewidth = 1) +
  geom_boxplot(data = df |> filter(series_id %in% params$series_id[2:6]), mapping = aes(x = date, y = value, group = date),
               show.legend = NULL, width = 50, fill = "#8aabfd") +
  geom_line(data = df |> filter(series_id == "PCEPILFE"), mapping = aes(x = date, y = value), color = "#ac004f", linewidth = 1) +
  geom_boxplot(data = df |> filter(series_id %in% params$series_id[8:12]), mapping = aes(x = date, y = value, group = date),
               show.legend = NULL, width = 50, fill = "#ce4631") +
  geom_hline(yintercept = 0, linetype = "solid", color = "black", show.legend = NULL) +
  geom_hline(yintercept = 2, linetype = "dashed", color = "black", show.legend = NULL) +
  scale_x_date(date_breaks = "1 year", date_labels = "%y") +
  theme_bw() +
  labs(
    title = "Personal Consumption Expenditures (PCE) Inflation & SEP projection",
    subtitle = "Year-over-year % change",
    caption = "Graph produced by @econmaett with data from FRED.",
    x = "", y = ""
  )

ggsave(filename = "Macro_Snapshot/KeyEconomicIndicators/PCE.png", width = 8, height = 4)
graphics.off()


## Effective Federal Funds Rate ----
series_id <- c("DFF", "FEDTARRH", "FEDTARCTH", "FEDTARMD", "FEDTARCTL", "FEDTARRL")
df <- purrr::map_dfr(.x = series_id, .f = fredr) |> 
  select(date, series_id, value) |> 
  filter(date >= "2015-01-01")

df |> 
  ggplot() +
  geom_line(data = df |> filter(series_id == "DFF"), mapping = aes(x = date, y = value), color = "#374e8e", linewidth = 1) +
  geom_boxplot(data = df |> filter(series_id != "DFF"), mapping = aes(x = date, y = value, group = date), 
               show.legend = NULL, width = 50, fill = "#df7c18") +
  geom_hline(yintercept = 0, linetype = "dashed", color = "black", show.legend = NULL) +
  scale_x_date(date_breaks = "1 year", date_labels = "%y") +
  scale_y_continuous(limits = c(0, 8)) +
  theme_bw() +
  labs(
    title = "Effective Federal Funds Rate & SEP projection",
    subtitle = "Percent",
    caption = "Graph produced by @econmaett with data from FRED.",
    x = "", y = ""
  )

ggsave(filename = "Macro_Snapshot/KeyEconomicIndicators/EFFR.png", width = 8, height = 4)
graphics.off()

# END