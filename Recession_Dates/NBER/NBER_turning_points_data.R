# ************************************************************************
# Data Considered for the NBER Turning Points ----
# ************************************************************************
# URL: https://fredaccount.stlouisfed.org/public/dashboard/84408
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

## Single series ----
params <- list(
  series_id = c("PAYEMS", "CE16OV", "INDPRO", "CMRMT", "W875RX1", "PCEC96", "GDPC1", "A261RX1Q020SBEA", "LB0000091Q020SBEA"),
  units = c("chg", "chg", "pc1", "pc1", "pc1", "pc1", "pca", "pca", "pca")
)

df <- purrr::pmap_dfr(.l = params, .f = ~fredr(series_id = .x, units = .y))

### PAYEMS: All Employees, Total Nonfarm ----
df |> 
  select(date, series_id, value) |> 
  filter(series_id == "PAYEMS") |> 
  ggplot() +
  geom_hline(yintercept = 0, linetype = "solid", color = "darkgrey", show.legend = NULL) +
  geom_line(mapping = aes(x = date, y = value), linewidth = 1, color = "#374e8e") +
  geom_rect(data = usrecdp, aes(xmin = recession_start , xmax = recession_end, ymin = -Inf, ymax = +Inf), fill = "darkgrey", alpha = 0.2) +
  scale_x_date(limits = c(date(start_date), today()), date_breaks = "1 year", date_labels = "%Y") +
  scale_y_continuous(limits = c(-25e3, 5e3), labels = label_number(suffix = "K", scale = 1e-3)) +
  theme_bw() +
  labs(
    title = "All Employees, Total Nonfarm",
    subtitle = "Change, in thousands (K) of persons",
    caption = "Graph created by @econmaett with data from FRED.",
    x = "", y = ""
  ) +
  theme(plot.subtitle = element_markdown(), legend.position = "none")

ggsave(filename = "Recession_Dates/NBER/NonfarmEmployment.png", width = 8, height = 4)
graphics.off()

### CE16OV: Employment Level ----
df |> 
  select(date, series_id, value) |> 
  filter(series_id == "CE16OV") |> 
  ggplot() +
  geom_hline(yintercept = 0, linetype = "solid", color = "darkgrey", show.legend = NULL) +
  geom_line(mapping = aes(x = date, y = value), linewidth = 1, color = "#374e8e") +
  geom_rect(data = usrecdp, aes(xmin = recession_start, xmax = recession_end, ymin = -Inf, ymax = +Inf), fill = "darkgrey", alpha = 0.2) +
  scale_x_date(limits = c(date(start_date), today()), date_breaks = "1 year", date_labels = "%Y") +
  scale_y_continuous(limits = c(-25e3, 10e3), labels = label_number(suffix = "K", scale = 1e-3)) +
  theme_bw() +
  labs(
    title = "Employment Level",
    subtitle = "Change, in thousands (K) of persons",
    caption = "Graph created by @econmaett with data from FRED.",
    x = "", y = ""
  ) +
  theme(plot.subtitle = element_markdown(), legend.position = "none")

ggsave(filename = "Recession_Dates/NBER/EmploymentLevel.png", width = 8, height = 4)
graphics.off()


### INDPRO: Industrial Production: Total Index ----
df |> 
  select(date, series_id, value) |> 
  filter(series_id == "INDPRO") |> 
  ggplot() +
  geom_hline(yintercept = 0, linetype = "solid", color = "darkgrey", show.legend = NULL) +
  geom_line(mapping = aes(x = date, y = value), linewidth = 1, color = "#374e8e") +
  geom_rect(data = usrecdp, aes(xmin = recession_start, xmax = recession_end, ymin = -Inf, ymax = +Inf), fill = "darkgrey", alpha = 0.2) +
  scale_x_date(limits = c(date(start_date), today()), date_breaks = "1 year", date_labels = "%Y") +
  scale_y_continuous(limits = c(-20, 20), breaks = seq(-20, 20, 5)) +
  theme_bw() +
  labs(
    title = "Industrial Production: Total Index",
    subtitle = "Percent Change from Year Ago",
    caption = "Graph created by @econmaett with data from FRED.",
    x = "", y = ""
  ) +
  theme(plot.subtitle = element_markdown(), legend.position = "none")

ggsave(filename = "Recession_Dates/NBER/IndustrialProduction.png", width = 8, height = 4)
graphics.off()

### CMRMT: Real Manufacturing and Trade Industries Sales ----
df |> 
  select(date, series_id, value) |> 
  filter(series_id == "CMRMT") |> 
  ggplot() +
  geom_hline(yintercept = 0, linetype = "solid", color = "darkgrey", show.legend = NULL) +
  geom_line(mapping = aes(x = date, y = value), linewidth = 1, color = "#374e8e") +
  geom_rect(data = usrecdp, aes(xmin = recession_start, xmax = recession_end, ymin = -Inf, ymax = +Inf), fill = "darkgrey", alpha = 0.2) +
  scale_x_date(limits = c(date(start_date), today()), date_breaks = "1 year", date_labels = "%Y") +
  scale_y_continuous(limits = c(-20, 30), breaks = seq(-20, 30, 10)) +
  theme_bw() +
  labs(
    title = "Real Manufacturing and Trade Industries Sales (CMRMT)",
    subtitle = "Percent Change from Year Ago",
    caption = "Graph created by @econmaett with data from FRED.",
    x = "", y = ""
  ) +
  theme(plot.subtitle = element_markdown(), legend.position = "none")

ggsave(filename = "Recession_Dates/NBER/ManufacturingSales.png", width = 8, height = 4)
graphics.off()


### W875RX1: Real personal income excluding current transfer receipts ----
df |> 
  select(date, series_id, value) |> 
  filter(series_id == "W875RX1") |> 
  ggplot() +
  geom_hline(yintercept = 0, linetype = "solid", color = "darkgrey", show.legend = NULL) +
  geom_line(mapping = aes(x = date, y = value), linewidth = 1, color = "#374e8e") +
  geom_rect(data = usrecdp, aes(xmin = recession_start, xmax = recession_end, ymin = -Inf, ymax = +Inf), fill = "darkgrey", alpha = 0.2) +
  scale_x_date(limits = c(date(start_date), today()), date_breaks = "1 year", date_labels = "%Y") +
  scale_y_continuous(limits = c(-10, 10), breaks = seq(-10, 10, 5)) +
  theme_bw() +
  labs(
    title = "Real personal income excluding current transfer receipts",
    subtitle = "Percent Change from Year Ago",
    caption = "Graph created by @econmaett with data from FRED.",
    x = "", y = ""
  ) +
  theme(plot.subtitle = element_markdown(), legend.position = "none")

ggsave(filename = "Recession_Dates/NBER/RealPersonalIncome.png", width = 8, height = 4)
graphics.off()

### PCEC96: Real Personal Consumption Expenditures ----
df |> 
  select(date, series_id, value) |> 
  filter(series_id == "PCEC96") |> 
  ggplot() +
  geom_hline(yintercept = 0, linetype = "solid", color = "darkgrey", show.legend = NULL) +
  geom_line(mapping = aes(x = date, y = value), linewidth = 1, color = "#374e8e") +
  geom_rect(data = usrecdp, aes(xmin = recession_start, xmax = recession_end, ymin = -Inf, ymax = +Inf), fill = "darkgrey", alpha = 0.2) +
  scale_x_date(limits = c(date(start_date), today()), date_breaks = "1 year", date_labels = "%Y") +
  scale_y_continuous(limits = c(-20, 30), breaks = seq(-20, 30, 10)) +
  theme_bw() +
  labs(
    title = "Real Personal Consumption Expenditures",
    subtitle = "Percent Change from Year Ago",
    caption = "Graph created by @econmaett with data from FRED.",
    x = "", y = ""
  ) +
  theme(plot.subtitle = element_markdown(), legend.position = "none")

ggsave(filename = "Recession_Dates/NBER/RealPersonalConExp.png", width = 8, height = 4)
graphics.off()


### GDPC1: Real Gross Domestic Product ----
# Compounded Annual Rate of Change
df |> 
  select(date, series_id, value) |> 
  filter(series_id == "GDPC1") |> 
  ggplot() +
  geom_hline(yintercept = 0, linetype = "solid", color = "darkgrey", show.legend = NULL) +
  geom_line(mapping = aes(x = date, y = value), linewidth = 1, color = "#374e8e") +
  geom_rect(data = usrecdp, aes(xmin = recession_start, xmax = recession_end, ymin = -Inf, ymax = +Inf), fill = "darkgrey", alpha = 0.2) +
  scale_x_date(limits = c(date(start_date), today()), date_breaks = "1 year", date_labels = "%Y") +
  scale_y_continuous(limits = c(-40, 40), breaks = seq(-40, 40, 10)) +
  theme_bw() +
  labs(
    title = "Real Gross Domestic Product",
    subtitle = "Compounded Annual Rate of Change",
    caption = "Graph created by @econmaett with data from FRED.",
    x = "", y = ""
  ) +
  theme(plot.subtitle = element_markdown(), legend.position = "none")

ggsave(filename = "Recession_Dates/NBER/RealGDP.png", width = 8, height = 4)
graphics.off()

### A261RX1Q020SBEA: Real gross domestic income ----
df |> 
  select(date, series_id, value) |> 
  filter(series_id == "A261RX1Q020SBEA") |> 
  ggplot() +
  geom_hline(yintercept = 0, linetype = "solid", color = "darkgrey", show.legend = NULL) +
  geom_line(mapping = aes(x = date, y = value), linewidth = 1, color = "#374e8e") +
  geom_rect(data = usrecdp, aes(xmin = recession_start, xmax = recession_end, ymin = -Inf, ymax = +Inf), fill = "darkgrey", alpha = 0.2) +
  scale_x_date(limits = c(date(start_date), today()), date_breaks = "1 year", date_labels = "%Y") +
  scale_y_continuous(limits = c(-40, 40), breaks = seq(-40, 40, 10)) +
  theme_bw() +
  labs(
    title = "Real gross domestic income (GDI)",
    subtitle = "Compounded Annual Rate of Change",
    caption = "Graph created by @econmaett with data from FRED.",
    x = "", y = ""
  ) +
  theme(plot.subtitle = element_markdown(), legend.position = "none")

ggsave(filename = "Recession_Dates/NBER/RealGDI.png", width = 8, height = 4)
graphics.off()

### LB0000091Q020SBEA: Real Average of GDP and GDI ----
df |> 
  select(date, series_id, value) |> 
  filter(series_id == "LB0000091Q020SBEA") |> 
  ggplot() +
  geom_hline(yintercept = 0, linetype = "solid", color = "darkgrey", show.legend = NULL) +
  geom_line(mapping = aes(x = date, y = value), linewidth = 1, color = "#374e8e") +
  geom_rect(data = usrecdp, aes(xmin = recession_start, xmax = recession_end, ymin = -Inf, ymax = +Inf), fill = "darkgrey", alpha = 0.2) +
  scale_x_date(limits = c(date(start_date), today()), date_breaks = "1 year", date_labels = "%Y") +
  scale_y_continuous(limits = c(-40, 40), breaks = seq(-40, 40, 10)) +
  theme_bw() +
  labs(
    title = "Real Average of GDP and GDI",
    subtitle = "Compounded Annual Rate of Change",
    caption = "Graph created by @econmaett with data from FRED.",
    x = "", y = ""
  ) +
  theme(plot.subtitle = element_markdown(), legend.position = "none")

ggsave(filename = "Recession_Dates/NBER/RealAvgGDPGDI.png", width = 8, height = 4)
graphics.off()

# END