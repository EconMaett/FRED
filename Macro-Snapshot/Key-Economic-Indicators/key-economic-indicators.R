# ************************************************************************
# Key Economic Indicators ----
# ************************************************************************
# Key series the FOMC highlights in its Summary of Economic Projections (SEP)
# URL: https://stlouisfed.shinyapps.io/macro-snapshot/#keyIndicators
# Feel free to copy, adapt, and use this code for your own purposes.
# ************************************************************************

## Load packages ----
library(fredr)
library(tidyverse)
library(scales)
library(ggtext)

start_date <- "2018-01-01"
usrecdp <- read_csv(file = "Recession-Dates/US_NBER/Recession-Dates_NBER_US_Daily_Midpoint.csv")


### Real Gross Domestic Product (GDP) Growth ----
params <- list(
  series_id = c("GDPC1", "GDPC1RH", "GDPC1RL", "GDPC1CTH", "GDPC1CTL", "GDPC1MD"),
  unis = c("pc1", "lin", "lin", "lin", "lin", "lin")
)

df <- purrr::pmap_dfr(.l = params, .f = ~fredr(series_id = .x, units = .y))

df |> 
  select(date, series_id, value) |> 
  ggplot() +
  geom_line(data = df |> filter(series_id == "GDPC1"), mapping = aes(x = date, y = value), color = "#006d64", linewidth = 1) +
  geom_boxplot(data = df |> filter(series_id != "GDPC1"), mapping = aes(x = date, y = value, group = date),
               show.legend = NULL, width = 50, fill = "#df7c18") +
  geom_hline(yintercept = 0, linetype = "solid", color = "black", show.legend = NULL) +
  geom_rect(data = usrecdp, aes(xmin = recession_start, xmax = recession_end, ymin = -Inf, ymax = +Inf), fill = "darkgrey", alpha = 0.3) +
  scale_x_date(expand = c(0, 0), limits = c(date(start_date), NA), date_breaks = "1 year", date_labels = "%Y") +  
  scale_y_continuous(expand = c(0, 0), limits = c(-10, 15)) +
  theme_bw() +
  labs(
    title = "Real Gross Domestic Product (GDP) growth & SEP projection",
    subtitle = "Year-over-year % change",
    caption = "Graph produced by @econmaett with data from FRED.",
    x = "", y = ""
  )

ggsave(filename = "Macro-Snapshot/Key-Economic-Indicators/Fig_Real-Gross-Domestic-Product.png", width = 8, height = 4)
graphics.off()


### Unemployment rate ----
series_id <- c("UNRATE", "UNRATERH", "UNRATECTH", "UNRATEMD", "UNRATECTL", "UNRATERL")
df <- purrr::map_dfr(.x = series_id, .f = fredr)


df |> 
  select(date, series_id, value) |> 
  ggplot() +
  geom_line(data = df |> filter(series_id == "UNRATE"), mapping = aes(x = date, y = value), color = "#006d64", linewidth = 1) +
  geom_boxplot(data = df |> filter(series_id != "UNRATE"), mapping = aes(x = date, y = value, group = date),
               show.legend = NULL, width = 50, fill = "#df7c18") +
  geom_hline(yintercept = 0, linetype = "solid", color = "black", show.legend = NULL) +
  geom_rect(data = usrecdp, aes(xmin = recession_start, xmax = recession_end, ymin = -Inf, ymax = +Inf), fill = "darkgrey", alpha = 0.3) +
  scale_x_date(expand = c(0, 0), limits = c(date(start_date), NA), date_breaks = "1 year", date_labels = "%Y") +  
  scale_y_continuous(expand = c(0, 0), limits = c(0, 15), breaks = seq(0, 15, 5)) +
  theme_bw() +
  labs(
    title = "Unemployment rate & SEP projection",
    subtitle = "In percent",
    caption = "Graph produced by @econmaett with data from FRED.",
    x = "", y = ""
  )

ggsave(filename = "Macro-Snapshot/Key-Economic-Indicators/Fig_Unemployment-Rate.png", width = 8, height = 4)
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

df <- purrr::pmap_dfr(.l = params, .f = ~fredr(series_id = .x, units = .y))

df |> 
  select(date, series_id, value) |> 
  ggplot() +
  geom_line(data = df |> filter(series_id == "PCEPI"), mapping = aes(x = date, y = value), color = "#374e8e", linewidth = 1) +
  geom_boxplot(data = df |> filter(series_id %in% params$series_id[2:6]), mapping = aes(x = date, y = value, group = date),
               show.legend = NULL, width = 50, fill = "#8aabfd") +
  geom_line(data = df |> filter(series_id == "PCEPILFE"), mapping = aes(x = date, y = value), color = "#ac004f", linewidth = 1) +
  geom_boxplot(data = df |> filter(series_id %in% params$series_id[8:12]), mapping = aes(x = date, y = value, group = date),
               show.legend = NULL, width = 50, fill = "#ce4631") +
  geom_hline(yintercept = 0, linetype = "solid", color = "black", show.legend = NULL) +
  geom_hline(yintercept = 2, linetype = "solid", color = "darkgrey", show.legend = NULL) +
  geom_rect(data = usrecdp, aes(xmin = recession_start, xmax = recession_end, ymin = -Inf, ymax = +Inf), fill = "darkgrey", alpha = 0.3) +
  scale_x_date(expand = c(0, 0), limits = c(date(start_date), NA), date_breaks = "1 year", date_labels = "%Y") +  
  scale_y_continuous(expand = c(0, 0), limits = c(0, 8), breaks = seq(0, 8, 2)) +
  theme_bw() +
  labs(
    title = "Personal Consumption Expenditures (PCE) Inflation & SEP projection",
    subtitle = "Year-over-year % change",
    caption = "Graph produced by @econmaett with data from FRED.",
    x = "", y = ""
  )

ggsave(filename = "Macro-Snapshot/Key-Economic-Indicators/Fig_Personal-Consumption-Expenditures.png", width = 8, height = 4)
graphics.off()


## Effective Federal Funds Rate ----
series_id <- c("DFF", "FEDTARRH", "FEDTARCTH", "FEDTARMD", "FEDTARCTL", "FEDTARRL")
df <- purrr::map_dfr(.x = series_id, .f = fredr)
df |> 
  ggplot() +
  geom_line(data = df |> filter(series_id == "DFF"), mapping = aes(x = date, y = value), color = "#374e8e", linewidth = 1) +
  geom_boxplot(data = df |> filter(series_id != "DFF"), mapping = aes(x = date, y = value, group = date), 
               show.legend = NULL, width = 50, fill = "#df7c18") +
  geom_hline(yintercept = 0, linetype = "solid", color = "black", show.legend = NULL) +
  geom_rect(data = usrecdp, aes(xmin = recession_start, xmax = recession_end, ymin = -Inf, ymax = +Inf), fill = "darkgrey", alpha = 0.3) +
  scale_x_date(expand = c(0, 0), limits = c(date(start_date), NA), date_breaks = "1 year", date_labels = "%Y") +  
  scale_y_continuous(expand = c(0, 0), limits = c(0, 8)) +
  theme_bw() +
  labs(
    title = "Effective Federal Funds Rate & SEP projection",
    subtitle = "Percent",
    caption = "Graph produced by @econmaett with data from FRED.",
    x = "", y = ""
  )

ggsave(filename = "Macro-Snapshot/Key-Economic-Indicators/Fig_Effective-Federal-Funds-Rate.png", width = 8, height = 4)
graphics.off()

# END