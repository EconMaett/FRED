# ************************************************************************
# Chicago Fed National Activity Index (NAI) ----
# ************************************************************************
# URL: https://www.chicagofed.org/research/data/cfnai/current-data
# Feel free to copy, adapt, and use this code for your own purposes.
# Matthias Spichiger (matthias.spichiger@bluewin.ch)
# ************************************************************************

## Load packages ----
library(fredr)
library(tidyverse)
library(scales)
library(ggtext)

start_date <- "2018-01-01"
usrecdp <- read_csv(file = "Recession-Dates/NBER/Recession-Dates_NBER_US_Daily_Midpoint.csv")

## Access the data ----
### Real GDP ---
gdpc1 <- fredr(series_id = "GDPC1", units = "pca") |> 
  select(date, series_id, value)

gdpc1std <- gdpc1
gdpc1std$series_id <- "GDPC1std"
gdpc1std$value <- (gdpc1$value - mean(gdpc1$value, na.rm = TRUE)) / sd(gdpc1$value, na.rm = TRUE)

### CFNAI ----
params <- list(
  series_id = c("CFNAI", "CFNAIMA3", "CFNAIDIFF", "PANDI", "CANDH", "SOANDI", "EUANDH"),
  units = c("lin", "lin", "lin", "lin", "lin", "lin", "lin")
)

df <- purrr::pmap_dfr(.l = params, .f = ~fredr(series_id = .x, units = .y)) |> 
  select(date, series_id, value)

## Plot the data ----

### Chicago Fed National Activity Index ----
# - CFNAI: Chicago Fed National Activity Index 
# - PANDI: Chicago Fed National Activity Index: Production and Income 
# - CANDH: Chicago Fed National Activity Index: Personal Consumption and Housing 
# - SOANDI: Chicago Fed National Activity Index: Sales, Orders and Inventories 
# - EUANDH: Chicago Fed National Activity Index: Employment, Unemployment and Hours 

### Plot CFNAI and standardized real GDP ---
start_date <- "2005-01-01"
rbind(gdpc1std, df) |> 
  filter(series_id %in% c("CFNAI", "GDPC1std")) |> 
  ggplot() +
  geom_line(mapping = aes(x = date, y = value, color = series_id), linewidth = 1) +
  geom_hline(yintercept = 0, linetype = "solid", color = "black", show.legend = NULL) +
  geom_rect(data = usrecdp, aes(xmin = recession_start, xmax = recession_end, ymin = -Inf, ymax = +Inf), fill = "darkgrey", alpha = 0.3) +
  scale_x_date(expand = c(0, 0), limits = c(date(start_date), today()), date_breaks = "1 year", date_labels = "%Y") +
  scale_y_continuous(expand = c(0, 0), limits = c(-10, 10)) +
  scale_color_manual(
    values = c("#374e8e", "#478c5b"), 
    breaks = c("CFNAI", "GDPC1std")
  ) +
  theme_bw() +
  labs(
    title = "<span style = 'color: #374e8e;'>Chicago Fed National Activity Index (NAI)</span> and <span style = 'color: #478c5b;'>standardized real GDP</span>",
    subtitle = "Seasonally-adjusted annual rate",
    caption = "Graph created by @econmaett with data from FRED.",
    x = "", y = ""
  ) +
  theme(plot.title = element_markdown(), legend.position = "none")

ggsave(filename = "Nowcasts/Chicago-Fed-NAI/Fig_Chicago-Fed-NAI-vs-GDP.png", width = 8, height = 4)
graphics.off()


### Plot the subindices ----
start_date <- "2022-01-01"

df |> 
  filter(series_id %in% c("CFNAI", "PANDI", "CANDH", "SOANDI", "EUANDH")) |> 
  ggplot() +
  geom_line(mapping = aes(x = date, y = value, color = series_id), linewidth = 1) +
  geom_hline(yintercept = 0, linetype = "solid", color = "black", show.legend = NULL) +
  geom_rect(data = usrecdp, aes(xmin = recession_start, xmax = recession_end, ymin = -Inf, ymax = +Inf), fill = "darkgrey", alpha = 0.3) +
  scale_x_date(expand = c(0, 0), limits = c(date(start_date), today()), date_breaks = "1 year", date_labels = "%Y") +
  scale_y_continuous(expand = c(0, 0), limits = c(-1, 1), breaks = seq(-1, 1, 0.25)) +
  scale_color_manual(
    values = c("#374e8e", "#478c5b", "#e3b13e", "#ce4631", "#ae49a2"), 
    breaks = c("CFNAI", "PANDI", "CANDH", "SOANDI", "EUANDH")
  ) +
  theme_bw() +
  labs(
    title = "<span style = 'color: #374e8e;'>Chicago Fed National Activity Index (NAI)</span>, <span style = 'color: #478c5b;'>Production and Income</span>, <span style = 'color: #e3b13e;'>Personal Consumption and Housing</span>, <span style = 'color: #ce4631;'>Sales, Orders and Inventories</span>, <span style = 'color: #ae49a2;'>Employment, Unemployment and Hours</span>",
    subtitle = "Year-on-year growth rates (in %)",
    caption = "Graph created by @econmaett with data from FRED.",
    x = "", y = ""
  ) +
  theme(plot.title = element_markdown(), legend.position = "none")

ggsave(filename = "Nowcasts/Chicago-Fed-NAI/Fig_Chicago-Fed-NAI-Sub-Indices.png", width = 8, height = 4)
graphics.off()


### Chicago Fed National Activity Index: Three Month Moving Average  ----
start_date <- "2018-01-01"

rbind(gdpc1std, df) |> 
  filter(series_id %in% c("CFNAIMA3", "GDPC1std")) |> 
  ggplot() +
  geom_line(mapping = aes(x = date, y = value, color = series_id), linewidth = 1) +
  geom_hline(yintercept = 0.20, linetype = "solid", color = "darkgrey", show.legend = NULL) +
  geom_hline(yintercept = 0, linetype = "solid", color = "black", show.legend = NULL) +
  geom_hline(yintercept = -0.70, linetype = "solid", color = "darkgrey", show.legend = NULL) +
  geom_rect(data = usrecdp, aes(xmin = recession_start, xmax = recession_end, ymin = -Inf, ymax = +Inf), fill = "darkgrey", alpha = 0.3) +
  scale_x_date(expand = c(0, 0), limits = c(date(start_date), today()), date_breaks = "1 year", date_labels = "%Y") +
  scale_y_continuous(expand = c(0, 0), limits = c(-10, 10)) +
  scale_color_manual(
    values = c("#374e8e", "#478c5b"), 
    breaks = c("CFNAIMA3", "GDPC1std")
  ) +
  theme_bw() +
  labs(
    title = "<span style = 'color: #374e8e;'>3M-MA of Chicago Fed National Activity Index (NAI)</span> and <span style = 'color: #478c5b;'>standardized real GDP</span> and <span style = 'color: #ac004f;'></span>",
    subtitle = "Seasonally-adjusted annual rate. Recession threshold: -0.70. Expansion threshold: 0.2",
    caption = "Graph created by @econmaett with data from FRED.",
    x = "", y = ""
  ) +
  theme(plot.title = element_markdown(), legend.position = "none")

ggsave(filename = "Nowcasts/Chicago-Fed-NAI/Fig_Chicago-Fed-NAI-3MA-vs-GDP.png", width = 8, height = 4)
graphics.off()


### Chicago Fed National Activity Index: Diffusion Index ----
start_date <- "2005-01-01"

df |> 
  select(date, series_id, value) |> 
  filter(series_id %in% c("CFNAIDIFF")) |> 
  ggplot() +
  geom_hline(yintercept = 1, linetype = "solid", color = "black", show.legend = NULL) +
  geom_hline(yintercept = 0, linetype = "solid", color = "black", show.legend = NULL) +
  geom_hline(yintercept = -0.35, linetype = "solid", color = "darkgrey", show.legend = NULL) +
  geom_hline(yintercept = -1, linetype = "solid", color = "black", show.legend = NULL) +
  geom_line(mapping = aes(x = date, y = value), linewidth = 1, color = "#374e8e") +
  geom_rect(data = usrecdp, aes(xmin = recession_start, xmax = recession_end, ymin = -Inf, ymax = +Inf), fill = "grey", alpha = 0.2) +
  scale_x_date(expand = c(0, 0), limits = c(date(start_date), today()), date_breaks = "1 year", date_labels = "%Y") +
  scale_y_continuous(expand = c(0, 0), limits = c(-1, 1), breaks = seq(-1, 1, 0.25)) +
  theme_bw() +
  labs(
    title = "Chicago Fed National Activity Diffusion Index",
    subtitle = "Expansion threshold: -0.35",
    caption = "Graph created by @econmaett with data from FRED.",
    x = "", y = ""
  ) +
  theme(plot.title = element_markdown(), legend.position = "none")

ggsave(filename = "Nowcasts/Chicago-Fed-NAI/Fig_Chicago-Fed-NAI-Diffusion-Index.png", width = 8, height = 4)
graphics.off()

# END