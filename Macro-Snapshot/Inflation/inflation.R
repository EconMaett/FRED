# ************************************************************************
# Inflation ----
# ************************************************************************
# URL: https://stlouisfed.shinyapps.io/macro-snapshot/#inflation
# Feel free to copy, adapt, and use this code for your own purposes.
# Matthias Spichiger (matthias.spichiger@bluewin.ch)
# ************************************************************************

## Load packages ----
library(fredr)
library(tidyverse)
library(scales)
library(ggtext)

start_date <- "2018-01-01"
usrecdp <- read_csv(file = "Recession-Dates/US_NBER/Recession-Dates_NBER_US_Daily_Midpoint.csv")

### Personal Consumption Expenditures (PCE) Inflation ----
params <- list(
  series_id = c("PCEPI", "PCEPILFE"),
  units = c("pc1", "pc1")
)
df <- purrr::pmap_dfr(.l = params, .f = ~fredr(series_id = .x, units = .y))
df |> 
  select(date, series_id, value) |> 
  ggplot() +
  geom_hline(yintercept = 2, linetype = "solid", color = "darkgrey", show.legend = NULL) +
  geom_hline(yintercept = 0, linetype = "solid", color = "black", show.legend = NULL) +
  geom_line(mapping = aes(x = date, y = value, color = series_id), linewidth = 1) +
  geom_rect(data = usrecdp, aes(xmin = recession_start, xmax = recession_end, ymin = -Inf, ymax = +Inf), fill = "darkgrey", alpha = 0.3) +
  scale_x_date(expand = c(0, 0), limits = c(date(start_date), today()), date_breaks = "1 year", date_labels = "%Y") +
  scale_y_continuous(expand = c(0, 0), limits = c(-2, 12), breaks = seq(-2, 12, 2)) +
  scale_color_manual(values = c("#374e8e", "#ac004f")) +
  theme_bw() +
  labs(
    title = "Personal Consumption Expenditure (PCE) Inflation",
    subtitle = "<span style = 'color: #374e8e;'>PCEPI</span> and <span style = 'color: #ac004f;'>Core PCEPI (PCEPI less food & energy)</span>",
    caption = "Graph created by @econmaett with data from FRED.",
    x = "", y = ""
  ) +
  theme(plot.subtitle = element_markdown(), legend.position = "none")

ggsave(filename = "Macro-Snapshot/Inflation/Fig_Personal-Consumption-Expenditure-Inflation.png", width = 8, height = 4)
graphics.off()


### Consumer Price Index (CPI) Inflation ----
# Consumer Price Index of All Urban Consumers: All Items
# - Less Food and Energy 
# - in U.S. City Average
params <- list(
  series_id = c("CPIAUCSL", "CPILFESL"),
  units = c("pc1", "pc1")
)
df <- purrr::pmap_dfr(.l = params, .f = ~fredr(series_id = .x, units = .y))
df |> 
  select(date, series_id, value) |> 
  ggplot() +
  geom_hline(yintercept = 2, linetype = "solid", color = "darkgrey", show.legend = NULL) +
  geom_hline(yintercept = 0, linetype = "solid", color = "black", show.legend = NULL) +
  geom_line(mapping = aes(x = date, y = value, color = series_id), linewidth = 1) +
  geom_rect(data = usrecdp, aes(xmin = recession_start, xmax = recession_end, ymin = -Inf, ymax = +Inf), fill = "darkgrey", alpha = 0.3) +
  scale_x_date(expand = c(0, 0), limits = c(date(start_date), today()), date_breaks = "1 year", date_labels = "%Y") +
  scale_y_continuous(expand = c(0, 0), limits = c(-2, 12), breaks = seq(-2, 12, 2)) +
  scale_color_manual(values = c("#374e8e", "#ac004f")) +
  theme_bw() +
  labs(
    title = "Consumer Price Index (CPI) Inflation",
    subtitle = "<span style = 'color: #374e8e;'>CPI</span> and <span style = 'color: #ac004f;'>Core CPI (CPI less food & energy)</span>",
    caption = "Graph created by @econmaett with data from FRED.",
    x = "", y = ""
  ) +
  theme(plot.subtitle = element_markdown(), legend.position = "none")

ggsave(filename = "Macro-Snapshot/Inflation/Fig_Consumer-Price-Index-Inflation.png", width = 8, height = 4)
graphics.off()
  

### Producer Price Index (PPI) Inflation ----
# Producer Price Index by Commodity: 
# - Final Demand
# - Less Foods and Energy
params <- list(
  series_id = c("PPIFIS", "PPIFES"),
  units = c("pc1", "pc1")
)
df <- purrr::pmap_dfr(.l = params, .f = ~fredr(series_id = .x, units = .y))
df |> 
  select(date, series_id, value) |> 
  ggplot() +
  geom_hline(yintercept = 2, linetype = "solid", color = "darkgrey", show.legend = NULL) +
  geom_hline(yintercept = 0, linetype = "solid", color = "black", show.legend = NULL) +
  geom_line(mapping = aes(x = date, y = value, color = series_id), linewidth = 1) +
  geom_rect(data = usrecdp, aes(xmin = recession_start, xmax = recession_end, ymin = -Inf, ymax = +Inf), fill = "darkgrey", alpha = 0.3) +
  scale_x_date(expand = c(0, 0), limits = c(date(start_date), today()), date_breaks = "1 year", date_labels = "%Y") +
  scale_y_continuous(expand = c(0, 0), limits = c(-2, 12), breaks = seq(-2, 12, 2)) +
  scale_color_manual(values = c("#ac004f", "#374e8e")) +
  theme_bw() +
  labs(
    title = "Producer Price Index (PPI) Inflation",
    subtitle = "<span style = 'color: #374e8e;'>PPI</span> and <span style = 'color: #ac004f;'>Core PPI (PPI less food & energy)</span>",
    caption = "Graph created by @econmaett with data from FRED.",
    x = "", y = ""
  ) +
  theme(plot.subtitle = element_markdown(), legend.position = "none")

ggsave(filename = "Macro-Snapshot/Inflation/Fig_Producer-Price-Index-Inflation.png", width = 8, height = 4)
graphics.off()


### Alternative Core Inflation Measures ----
# - Trimmed Mean PCE Inflation Rate
# - 16% Trimmed-Mean Consumer Price Index
# - Median Consumer Price Index
params <- list(
  series_id = c("PCETRIM12M159SFRBDAL", "TRMMEANCPIM159SFRBCLE", "MEDCPIM159SFRBCLE"),
  units = c("lin", "lin", "lin")
)
df <- purrr::pmap_dfr(.l = params, .f = ~fredr(series_id = .x, units = .y))
df |> 
  select(date, series_id, value) |> 
  ggplot() +
  geom_hline(yintercept = 2, linetype = "solid", color = "darkgrey", show.legend = NULL) +
  geom_hline(yintercept = 0, linetype = "solid", color = "black", show.legend = NULL) +
  geom_line(mapping = aes(x = date, y = value, color = series_id), linewidth = 1) +
  geom_rect(data = usrecdp, aes(xmin = recession_start, xmax = recession_end, ymin = -Inf, ymax = +Inf), fill = "darkgrey", alpha = 0.3) +
  scale_x_date(expand = c(0, 0), limits = c(date(start_date), today()), date_breaks = "1 year", date_labels = "%Y") +
  scale_y_continuous(expand = c(0, 0), limits = c(-2, 12), breaks = seq(-2, 12, 2)) +
  scale_color_manual(values = c("#478c5b", "#374e8e", "#ac004f")) +
  theme_bw() +
  labs(
    title = "Alternative Core Inflation Measures",
    subtitle = "<span style = 'color:#478c5b;'>Median CPI</span>, <span style = 'color: #374e8e;'>Trimmed-mean PCE</span> and <span style = 'color: #ac004f;'>Trimmed-mean CPI</span>",
    caption = "Graph created by @econmaett with data from FRED.",
    x = "", y = ""
  ) +
  theme(plot.subtitle = element_markdown(), legend.position = "none")

ggsave(filename = "Macro-Snapshot/Inflation/Fig_Alternative-Core-Inflation-Measures.png", width = 8, height = 4)
graphics.off()


### St. Louis Fed Price Pressures Measure ----
stlppm <- fredr(series_id = "STLPPM")
stlppm |> 
  select(date, value) |> 
  ggplot() +
  geom_line(mapping = aes(x = date, y = value), linewidth = 1, color = "#374e8e") +
  geom_hline(yintercept = 0, linetype = "solid", color = "black", show.legend = NULL) +  
  geom_hline(yintercept = 0.5, linetype = "solid", color = "darkgrey", show.legend = NULL) +
  geom_hline(yintercept = 1, linetype = "solid", color = "black", show.legend = NULL) +
  geom_rect(data = usrecdp, aes(xmin = recession_start, xmax = recession_end, ymin = -Inf, ymax = +Inf), fill = "darkgrey", alpha = 0.3) +
  scale_x_date(expand = c(0, 0), limits = c(date(start_date), today()), date_breaks = "1 year", date_labels = "%Y") +
  scale_y_continuous(expand = c(0, 0), limits = c(0, 1), breaks = seq(0, 1, 0.25)) +
  theme_bw() +
  labs(
    title = "St. Louis Fed Price Pressures Measure",
    subtitle = "Probability PCE ifnlation exceeds 2.5% in a year",
    caption = "Graph created by @econmaett with data from FRED.",
    x = "", y = ""
  )

ggsave(filename = "Macro-Snapshot/Inflation/Fig_StLouis-Fed-Price-Pressure-Measure.png", width = 8, height = 4)
graphics.off()


### Year-Ahead Inflation Expectations ----
# University of Michigan: Inflation Expectation
mich <- fredr(series_id = "MICH")
mich |> 
  select(date, value) |> 
  ggplot() +
  geom_hline(yintercept = 2, linetype = "solid", color = "darkgrey", show.legend = NULL) +
  geom_hline(yintercept = 0, linetype = "solid", color = "black", show.legend = NULL) +  
  geom_line(mapping = aes(x = date, y = value), color = "#374e8e", linewidth = 1) +
  geom_rect(data = usrecdp, aes(xmin = recession_start, xmax = recession_end, ymin = -Inf, ymax = +Inf), fill = "darkgrey", alpha = 0.3) +
  scale_x_date(expand = c(0, 0), limits = c(date(start_date), today()), date_breaks = "1 year", date_labels = "%Y") +  scale_y_continuous(expand = c(0, 0), limits = c(0, 6), breaks = 0:6) +
  scale_y_continuous(expand = c(0, 0), limits = c(0, 6), breaks = seq(0, 6, 1)) +
  theme_bw() +
  labs(
    title = "Year-Ahead Inflation Expectations",
    subtitle = "In percent",
    caption = "Graph created by @econmaett with data from FRED.",
    x = "", y = ""
  )

ggsave(filename = "Macro-Snapshot/Inflation/Fig_University-of-Michigan-Inflation-Expectations.png", width = 8, height = 4)
graphics.off()
  

### Break-even Inflation Rates ----
# 5-Year Break-even Inflation Rate
# 5-Year, 5-Year Forward Inflation Expectation Rate
params <- list(
  series_id = c("T5YIE", "T5YIFR"),
  units = c("lin", "lin")
)
df <- purrr::pmap_dfr(.l = params, .f = ~fredr(series_id = .x, units = .y)) |> 
  fill(value)
df |> 
  select(date, series_id, value) |> 
  ggplot() +
  geom_hline(yintercept = 2, linetype = "solid", color = "darkgrey", show.legend = NULL) +
  geom_hline(yintercept = 0, linetype = "solid", color = "black", show.legend = NULL) +  
  geom_line(mapping = aes(x = date, y = value, color = series_id), linewidth = 1) +
  geom_rect(data = usrecdp, aes(xmin = recession_start, xmax = recession_end, ymin = -Inf, ymax = +Inf), fill = "darkgrey", alpha = 0.3) +
  scale_x_date(expand = c(0, 0), limits = c(date(start_date), today()), date_breaks = "1 year", date_labels = "%Y") +
  scale_y_continuous(expand = c(0, 0), limits = c(0, 5), breaks = seq(0, 5, 1)) +
  scale_color_manual(values = c("#374e8e", "#ac004f")) +
  theme_bw() +
  labs(
    title = "Breakeven Inflation Rates",
    subtitle = "<span style = 'color: #374e8e;'>5-year BEI</span> and <span style = 'color: #ac004f;'>5-year, 5-year forward BEI</span>",
    caption = "Graph created by @econmaett with data from FRED.",
    x = "", y = ""
  ) +
  theme(plot.subtitle = element_markdown(), legend.position = "none")

ggsave(filename = "Macro-Snapshot/Inflation/Fig_Breakeven-Inflation.png", width = 8, height = 4)
graphics.off()

# END