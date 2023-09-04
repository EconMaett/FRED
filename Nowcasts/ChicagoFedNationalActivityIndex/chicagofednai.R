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
usrecdp <- read_csv(file = "Recession_Dates/NBER/US_NBER_Midpoint_Daily_Recession_Dates.csv")

## Access the data ----
params <- list(
  series_id = c("CFNAI", "CFNAIMA3", "CFNAIDIFF", "PANDI", "CANDH", "SOANDI", "EUANDH"),
  units = c("lin", "lin", "lin", "lin", "lin", "lin", "lin")
)

df <- purrr::pmap_dfr(.l = params, .f = ~fredr(series_id = .x, units = .y))

## Plot the data ----

### Chicago Fed National Activity Index ----
# - CFNAI: Chicago Fed National Activity Index 
# - PANDI: Chicago Fed National Activity Index: Production and Income 
# - CANDH: Chicago Fed National Activity Index: Personal Consumption and Housing 
# - SOANDI: Chicago Fed National Activity Index: Sales, Orders and Inventories 
# - EUANDH: Chicago Fed National Activity Index: Employment, Unemployment and Hours 
df |> 
  select(date, series_id, value) |> 
  filter(series_id %in% c("CFNAI", "PANDI", "CANDH", "SOANDI", "EUANDH")) |> 
  ggplot() +
  geom_line(mapping = aes(x = date, y = value, color = series_id), linewidth = 1) +
  geom_hline(yintercept = 0, linetype = "solid", color = "black", show.legend = NULL) +
  geom_rect(data = usrecdp, aes(xmin = recession_start, xmax = recession_end, ymin = -Inf, ymax = +Inf), fill = "darkgrey", alpha = 0.3) +
  scale_x_date(limits = c(date(start_date), today()), date_breaks = "1 year", date_labels = "%Y") +
  scale_y_continuous(limits = c(-1, 1), breaks = seq(-1, 1, 0.25)) +
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

ggsave(filename = "Nowcasts/ChicagoFedNationalActivityIndex/ChicagoFedNAI.png", width = 8, height = 4)
graphics.off()


### Chicago Fed National Activity Index: Three Month Moving Average  ----
df |> 
  select(date, series_id, value) |> 
  filter(series_id == "CFNAIMA3") |> 
  ggplot() +
  geom_line(mapping = aes(x = date, y = value), linewidth = 1, color = "#374e8e") +
  geom_hline(yintercept = 0, linetype = "solid", color = "black", show.legend = NULL) +
  geom_rect(data = usrecdp, aes(xmin = recession_start, xmax = recession_end, ymin = -Inf, ymax = +Inf), fill = "grey", alpha = 0.2) +
  scale_x_date(limits = c(date(start_date), today()), date_breaks = "1 year", date_labels = "%Y") +
  scale_y_continuous(limits = c(-2.5, 2.5), breaks = seq(-2.5, 2.5, 0.5)) +
  theme_bw() +
  labs(
    title = "Chicago Fed National Activity Index",
    subtitle = "Three Month Moving Average",
    caption = "Graph created by @econmaett with data from FRED.",
    x = "", y = ""
  ) +
  theme(plot.title = element_markdown(), legend.position = "none")

ggsave(filename = "Nowcasts/ChicagoFedNationalActivityIndex/ChicagoFedNAI3MA.png", width = 8, height = 4)
graphics.off()


### Chicago Fed National Activity Index: Diffusion Index ----
df |> 
  select(date, series_id, value) |> 
  filter(series_id == "CFNAIDIFF") |> 
  ggplot() +
  geom_line(mapping = aes(x = date, y = value), linewidth = 1, color = "#374e8e") +
  geom_hline(yintercept = 0, linetype = "solid", color = "black", show.legend = NULL) +
  geom_rect(data = usrecdp, aes(xmin = recession_start, xmax = recession_end, ymin = -Inf, ymax = +Inf), fill = "grey", alpha = 0.2) +
  scale_x_date(limits = c(date(start_date), today()), date_breaks = "1 year", date_labels = "%Y") +
  scale_y_continuous(limits = c(-2.5, 2.5), breaks = seq(-2.5, 2.5, 0.5)) +
  theme_bw() +
  labs(
    title = "Chicago Fed National Activity Index",
    subtitle = "Three Month Moving Average",
    caption = "Graph created by @econmaett with data from FRED.",
    x = "", y = ""
  ) +
  theme(plot.title = element_markdown(), legend.position = "none")

ggsave(filename = "Nowcasts/ChicagoFedNationalActivityIndex/ChicagoFedNAIDiffInd.png", width = 8, height = 4)
graphics.off()

# END