# ************************************************************************
# Sahm Rule ----
# ************************************************************************
# Feel free to copy, adapt, and use this code for your own purposes.
# Matthias Spichiger (matthias.spichiger@bluewin.ch)
# ************************************************************************

## Load packages ----
library(fredr)
library(tidyverse)
library(scales)
library(ggtext)

start_date <- "2000-01-01"
usrecdp <- read_csv(file = "Recession-Dates/NBER/Recession-Dates_NBER_US_Daily_Midpoint.csv")

## Load the data ----
params <- list(
  series_id = c("SAHMREALTIME", "SAHMCURRENT", "UNRATE"),
  units = c("lin", "lin", "lin")
)

df <- purrr::pmap_dfr(.l = params, .f = ~fredr(series_id = .x, units = .y)) |> 
  select(date, series_id, value)

### Sahm Rule Recession Indicator -----
df |> 
  filter(series_id == "SAHMCURRENT") |> 
  ggplot() +
  geom_hline(yintercept = 0.5, linetype = "solid", color = "#ac004f", show.legend = NULL) +
  geom_hline(yintercept = 0, linetype = "solid", color = "black", show.legend = NULL) +
  geom_line(mapping = aes(x = date, y = value), linewidth = 1, color = "#374e8e") +
  geom_rect(data = usrecdp, aes(xmin = recession_start, xmax = recession_end, ymin = -Inf, ymax = +Inf), fill = "darkgrey", alpha = 0.3) +
  scale_x_date(limits = c(date(start_date), today()), date_breaks = "1 year", date_labels = "%y") +
  scale_y_continuous(limits = c(-1, 10), breaks = seq(-1, 10, 1)) +
  theme_bw() +
  labs(
    title = "Sahm Rule Recession Indicator",
    subtitle = "<span style = 'color: #374e8e;'>3-month moving average of the national unemployment rate (U3) relative to its 12-month low</span> and <span style = 'color: #ac004f;'>0.5 Threshold</span>",
    caption = "Graph created by @econmaett with data from FRED.",
    x = "", y = ""
  ) +
  theme(plot.subtitle = element_markdown(), legend.position = "none")

ggsave(filename = "Recession-Dates/Sahm-Rule/Sahm-Rule-Current.png", width = 8, height = 4)
graphics.off()

### Real-time Sahm Rule Recession Indicator ----
df |> 
  filter(series_id == "SAHMREALTIME") |> 
  ggplot() +
  geom_hline(yintercept = 0.5, linetype = "solid", color = "#ac004f", show.legend = NULL) +
  geom_hline(yintercept = 0, linetype = "solid", color = "black", show.legend = NULL) +
  geom_line(mapping = aes(x = date, y = value), linewidth = 1, color = "#374e8e") +
  geom_rect(data = usrecdp, aes(xmin = recession_start, xmax = recession_end, ymin = -Inf, ymax = +Inf), fill = "darkgrey", alpha = 0.3) +
  scale_x_date(limits = c(date(start_date), today()), date_breaks = "1 year", date_labels = "%y") +
  scale_y_continuous(limits = c(-1, 10), breaks = seq(-1, 10, 1)) +
  theme_bw() +
  labs(
    title = "Real-Time Sahm Rule Recession Indicator",
    subtitle = "<span style = 'color: #374e8e;'>3-month moving average of the national unemployment rate (U3) relative to its 12-month low</span> and <span style = 'color: #ac004f;'>0.5 Threshold</span>",
    caption = "Graph created by @econmaett with data from FRED.",
    x = "", y = ""
  ) +
  theme(plot.subtitle = element_markdown(), legend.position = "none")

ggsave(filename = "Recession-Dates/Sahm-Rule/Sahm-Rule-Real-Time.png", width = 8, height = 4)
graphics.off()

# END