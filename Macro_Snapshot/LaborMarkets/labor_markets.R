# ************************************************************************
# Labor Markets ----
# URL: https://stlouisfed.shinyapps.io/macro-snapshot/#labor
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


## Unemployment Rate ----
unrate <- fredr(series_id = "UNRATE")

unrate |> 
  select(date, value) |> 
  ggplot() +
  geom_line(mapping = aes(x = date, y = value), color = "#374e8e", linewidth = 1) +
  geom_hline(yintercept = 0, linetype = "solid", color = "black", show.legend = NULL) +
  geom_rect(data = usrecdp, aes(xmin = recession_start, xmax = recession_end, ymin = -Inf, ymax = +Inf), fill = "grey", alpha = 0.2) +
  scale_x_date(limits = c(date(start_date), NA), date_breaks = "1 year", date_labels = "%Y") +  scale_y_continuous(limits = c(0, 150), breaks = seq(0, 150, 25)) +
  scale_y_continuous(limits = c(0, 15)) +
  theme_bw() +
  labs(
    title = "Unemployment Rate",
    subtitle = "Seasonally adjusted, in percent",
    caption = "Graph created by @econmaett with data from FRED.",
    x = "", y = ""
  )

ggsave(filename = "Macro_Snapshot/LaborMarkets/UNRATE.png", width = 8, height = 4)
graphics.off()


### Non-farm Payroll Employment Growth ----
payems <- fredr(series_id = "PAYEMS", units = "chg")
payems |> 
  ggplot() +
  geom_line(mapping = aes(x = date, y = value), color = "#374e8e", linewidth = 1) +
  geom_hline(yintercept = 0, linetype = "dashed", color = "black", show.legend = NULL) +
  geom_rect(data = usrecdp, aes(xmin = recession_start, xmax = recession_end, ymin = -Inf, ymax = +Inf), fill = "grey", alpha = 0.2) +
  scale_x_date(limits = c(date(start_date), NA), date_breaks = "1 year", date_labels = "%Y") +  scale_y_continuous(limits = c(0, 150), breaks = seq(0, 150, 25)) +
  scale_y_continuous(labels = label_number(suffix = "K", scale = 1e-3)) +
  theme_bw() +
  labs(
    title = "Nonfarm Payroll Employment Growth",
    subtitle = "Change, in thousands (K)",
    caption = "Graph created by @econmaett with data from FRED.",
    x = "", y = ""
  )

ggsave(filename = "Macro_Snapshot/LaborMarkets/PAYEMS.png", width = 8, height = 4)
graphics.off()


### Labor Force Participation Rate ----
civpart <- fredr(series_id = "CIVPART")
civpart |> 
  filter(date >= "2000-01-01") |> 
  ggplot() +
  geom_line(mapping = aes(x = date, y = value), linewidth = 1, color = "#374e8e") +
  geom_rect(data = usrecdp, aes(xmin = recession_start, xmax = recession_end, ymin = -Inf, ymax = +Inf), fill = "grey", alpha = 0.2) +
  scale_x_date(limits = c(date(start_date), NA), date_breaks = "1 year", date_labels = "%Y") +  scale_y_continuous(limits = c(0, 150), breaks = seq(0, 150, 25)) +
  scale_y_continuous(limits = c(60, 64)) +
  theme_bw() +
  labs(
    title = "Labor Force Participation Rate & Trend (since Jan 2000)",
    subtitle = "In percent",
    caption = "Graph created by @econmaett with data from FRED.",
    x = "", y = ""
  )

ggsave(filename = "Macro_Snapshot/LaborMarkets/CIVPART.png", width = 8, height = 4)
graphics.off()


### Vacancies per Unemployed Person ----
# Job Openings and Labor Turnover Survey (JOLTS)
# Job Openings: Total Nonfarm / Unemployment Level
# Both in thousands of persons, seasonally adjusted
jtsjol   <- fredr(series_id = "JTSJOL")
unemploy <- fredr(series_id = "UNEMPLOY")

rbind(jtsjol, unemploy) |> 
  select(date, series_id, value) |> 
  pivot_wider(names_from = series_id, values_from = value) |> 
  mutate(VACANC = JTSJOL / UNEMPLOY) |> 
  ggplot() +
  geom_line(mapping = aes(x = date, y = VACANC), color = "#374e8e", linewidth = 1) +
  geom_hline(yintercept = min(jtsjol$value / unemploy$value, na.rm = TRUE), linetype = "dotted", color = "#374e8e", linewidth = 1) +
  geom_rect(data = usrecdp, aes(xmin = recession_start, xmax = recession_end, ymin = -Inf, ymax = +Inf), fill = "grey", alpha = 0.2) +
  scale_x_date(limits = c(date(start_date), NA), date_breaks = "1 year", date_labels = "%Y") +  scale_y_continuous(limits = c(0, 150), breaks = seq(0, 150, 25)) +
  scale_y_continuous(limits = c(0, 3)) +
  theme_bw() +
  labs(
    title = "Vacancies per Unemployed Person & Historical Minimum (July 2009)",
    subtitle = "Ratio",
    caption = "Graph created by @econmaett with data from FRED.",
    x = "", y = ""
  )

ggsave(filename = "Macro_Snapshot/LaborMarkets/VACANC.png", width = 8, height = 4)
graphics.off()


### Unemployment Claims ----
series_id <- c("ICSA", "CCSA")
df <- purrr::map_dfr(.x = series_id, .f = fredr)
df |> 
  select(date, series_id, value) |> 
  pivot_wider(names_from = series_id, values_from = value) |> 
  ggplot() +
  geom_line(mapping = aes(x = date, y = ICSA), color = "#374e8e", linewidth = 1) +
  geom_line(mapping = aes(x = date, y = CCSA), color = "#ac004f", linewidth = 1) +
  geom_rect(data = usrecdp, aes(xmin = recession_start, xmax = recession_end, ymin = -Inf, ymax = +Inf), fill = "grey", alpha = 0.2) +
  scale_x_date(limits = c(date(start_date), NA), date_breaks = "1 year", date_labels = "%Y") +  scale_y_continuous(limits = c(0, 150), breaks = seq(0, 150, 25)) +
  scale_y_continuous(labels = label_number(suffix = "M", scale = 1e-6), limits = c(0, 25e6)) +
  theme_bw() +
  labs(
    title = "Unemployment claims in millions (M)",
    subtitle = "<span style = 'color: #ac004f;'>Continued Claims</span> and <span style = 'color: #374e8e;'>Initial Claims</span>",
    caption = "Graph created by @econmaett with data from FRED.",
    x = "", y = ""
  ) +
  theme(plot.subtitle = element_markdown(), legend.position = "none")

ggsave(filename = "Macro_Snapshot/LaborMarkets/UnemploymentClaims.png", width = 8, height = 4)
graphics.off()


### Average Hourly Earnings Growth of Private Employees ----
avhe <- fredr(series_id = "CES0500000003", units = "pc1")
avhe |> 
  select(date, value) |> 
  ggplot() +
  geom_line(mapping = aes(x = date, y = value), color = "#374e8e", linewidth = 1) +
  geom_rect(data = usrecdp, aes(xmin = recession_start, xmax = recession_end, ymin = -Inf, ymax = +Inf), fill = "grey", alpha = 0.2) +
  scale_x_date(limits = c(date(start_date), NA), date_breaks = "1 year", date_labels = "%Y") +  scale_y_continuous(limits = c(0, 150), breaks = seq(0, 150, 25)) +
  scale_y_continuous(limits = c(0, 10), breaks = c(0, 2, 4, 6, 8, 10)) +
  theme_bw() +
  labs(
    title = "Average Hourly Earnings Growth of Private Employees",
    subtitle = "Year-over-year % change",
    caption = "Graph created by @econmaett with data from FRED",
    x = "", y = ""
  )

ggsave(filename = "Macro_Snapshot/LaborMarkets/AVHE.png", width = 8, height = 4)
graphics.off()


### Kansas City Fed Labor Market Conditions Indicator ----
kclmc <- fredr(series_id = "FRBKCLMCILA")
kclmc |> 
  select(date, value) |> 
  ggplot() +
  geom_line(mapping = aes(x = date, y = value), color = "#374e8e", linewidth = 1) +
  geom_hline(yintercept = 0, linetype = "dashed", color = "black", show.legend = NULL) +
  geom_rect(data = usrecdp, aes(xmin = recession_start, xmax = recession_end, ymin = -Inf, ymax = +Inf), fill = "grey", alpha = 0.2) +
  scale_x_date(limits = c(date(start_date), NA), date_breaks = "1 year", date_labels = "%Y") +  scale_y_continuous(limits = c(0, 150), breaks = seq(0, 150, 25)) +
  scale_y_continuous(limits = c(-3, 2)) +
  theme_bw() +
  labs(
    title = "Kansas City Fed Labor Market Conditions Index",
    subtitle = "Level of activity (index). Normal conditions = 0.",
    caption = "Graph created by @econmaett with data from FRED.",
    x = "", y = ""
  )

ggsave(filename = "Macro_Snapshot/LaborMarkets/KansasCityFedLaborMarketCond.png", width = 8, height = 4)
graphics.off()


### Labor Demand and Labor Supply ----
# Employment level, Job Openings Total, Civilian labor force level
# Labor demand = job openings + employment
# Labor supply = civilian labor force
series_id <- c("CE16OV", "JTSJOL", "CLF16OV")
df <- purrr::map_dfr(.x = series_id, .f = fredr)
df |> 
  select(date, series_id, value) |> 
  pivot_wider(names_from = series_id, values_from = value) |> 
  mutate(
    `Labor Demand` = CE16OV + JTSJOL,
    `Labor Supply` = CLF16OV, .keep = "unused"
  ) |> 
  ggplot() +
  geom_line(mapping = aes(x = date, y = `Labor Demand`), color = "#374e8e", linewidth = 1) +
  geom_line(mapping = aes(x = date, y = `Labor Supply`), color = "#ac004f", linewidth = 1) +
  geom_rect(data = usrecdp, aes(xmin = recession_start, xmax = recession_end, ymin = -Inf, ymax = +Inf), fill = "grey", alpha = 0.2) +
  scale_x_date(limits = c(date(start_date), NA), date_breaks = "1 year", date_labels = "%Y") +  scale_y_continuous(limits = c(0, 150), breaks = seq(0, 150, 25)) +
  scale_y_continuous(labels = label_number(suffix = "M", scale = 1e-3), limits = c(130e3, 180e3)) +
  theme_bw() +
  labs(
    title = "<span style = 'color: #374e8e;'>Labor Demand (job openings + employment)</span> and <span style = 'color: #ac004f;'>Labor Supply (civilian labor force)</span>",
    subtitle = "In millions (M)",
    caption = "Graph created by @econmaett with data from FRED.",
    x = "", y = ""
  ) +
  theme(plot.title = element_markdown(), legend.position = "none")

ggsave(filename = "Macro_Snapshot/LaborMarkets/LaborDemandSupply.png", width = 8, height = 4)
graphics.off()

# END