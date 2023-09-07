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

start_date <- "2005-01-01"
usrecdp <- read_csv(file = "Recession-Dates/NBER/Recession-Dates_NBER_US_Daily_Midpoint.csv")

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
  geom_rect(data = usrecdp, aes(xmin = recession_start , xmax = recession_end, ymin = -Inf, ymax = +Inf), fill = "darkgrey", alpha = 0.3) +
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

ggsave(filename = "Recession-Dates/NBER/TP_Nonfarm-Employment.png", width = 8, height = 4)
graphics.off()

### CE16OV: Employment Level ----
df |> 
  select(date, series_id, value) |> 
  filter(series_id == "CE16OV") |> 
  ggplot() +
  geom_hline(yintercept = 0, linetype = "solid", color = "darkgrey", show.legend = NULL) +
  geom_line(mapping = aes(x = date, y = value), linewidth = 1, color = "#374e8e") +
  geom_rect(data = usrecdp, aes(xmin = recession_start, xmax = recession_end, ymin = -Inf, ymax = +Inf), fill = "darkgrey", alpha = 0.3) +
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

ggsave(filename = "Recession-Dates/NBER/TP_Employment-Level.png", width = 8, height = 4)
graphics.off()


### INDPRO: Industrial Production: Total Index ----
df |> 
  select(date, series_id, value) |> 
  filter(series_id == "INDPRO") |> 
  ggplot() +
  geom_hline(yintercept = 0, linetype = "solid", color = "darkgrey", show.legend = NULL) +
  geom_line(mapping = aes(x = date, y = value), linewidth = 1, color = "#374e8e") +
  geom_rect(data = usrecdp, aes(xmin = recession_start, xmax = recession_end, ymin = -Inf, ymax = +Inf), fill = "darkgrey", alpha = 0.3) +
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

ggsave(filename = "Recession-Dates/NBER/TP_Industrial-Production.png", width = 8, height = 4)
graphics.off()

### CMRMT: Real Manufacturing and Trade Industries Sales ----
df |> 
  select(date, series_id, value) |> 
  filter(series_id == "CMRMT") |> 
  ggplot() +
  geom_hline(yintercept = 0, linetype = "solid", color = "darkgrey", show.legend = NULL) +
  geom_line(mapping = aes(x = date, y = value), linewidth = 1, color = "#374e8e") +
  geom_rect(data = usrecdp, aes(xmin = recession_start, xmax = recession_end, ymin = -Inf, ymax = +Inf), fill = "darkgrey", alpha = 0.3) +
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

ggsave(filename = "Recession-Dates/NBER/TP_Manufacturing-Sales.png", width = 8, height = 4)
graphics.off()


### W875RX1: Real personal income excluding current transfer receipts ----
df |> 
  select(date, series_id, value) |> 
  filter(series_id == "W875RX1") |> 
  ggplot() +
  geom_hline(yintercept = 0, linetype = "solid", color = "darkgrey", show.legend = NULL) +
  geom_line(mapping = aes(x = date, y = value), linewidth = 1, color = "#374e8e") +
  geom_rect(data = usrecdp, aes(xmin = recession_start, xmax = recession_end, ymin = -Inf, ymax = +Inf), fill = "darkgrey", alpha = 0.3) +
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

ggsave(filename = "Recession-Dates/NBER/TP_Real-Personal-Income.png", width = 8, height = 4)
graphics.off()

### PCEC96: Real Personal Consumption Expenditures ----
df |> 
  select(date, series_id, value) |> 
  filter(series_id == "PCEC96") |> 
  ggplot() +
  geom_hline(yintercept = 0, linetype = "solid", color = "darkgrey", show.legend = NULL) +
  geom_line(mapping = aes(x = date, y = value), linewidth = 1, color = "#374e8e") +
  geom_rect(data = usrecdp, aes(xmin = recession_start, xmax = recession_end, ymin = -Inf, ymax = +Inf), fill = "darkgrey", alpha = 0.3) +
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

ggsave(filename = "Recession-Dates/NBER/TP_Real-Personal-Consumption-Expenditure.png", width = 8, height = 4)
graphics.off()

### GDP, GDI, and Average of GDP and GDI ----
# - GDPC1: Real Gross Domestic Product
# - A261RX1Q020SBEA: Real gross domestic income
# - LB0000091Q020SBEA: Real Average of GDP and GDI
df |> 
  select(date, series_id, value) |> 
  filter(series_id %in% c("GDPC1", "A261RX1Q020SBEA", "LB0000091Q020SBEA")) |> 
  ggplot() +
  geom_hline(yintercept = 0, linetype = "solid", color = "darkgrey", show.legend = NULL) +
  geom_line(mapping = aes(x = date, y = value, color = series_id), linewidth = 1) +
  geom_rect(data = usrecdp, aes(xmin = recession_start, xmax = recession_end, ymin = -Inf, ymax = +Inf), fill = "darkgrey", alpha = 0.3) +
  scale_x_date(limits = c(date(start_date), today()), date_breaks = "1 year", date_labels = "%Y") +
  scale_y_continuous(limits = c(-40, 40), breaks = seq(-40, 40, 10)) +
  scale_color_manual(
    breaks = c("GDPC1", "A261RX1Q020SBEA", "LB0000091Q020SBEA"), 
    values = c("#374e8e", "#006d64", "#ac004f")
    ) +
  theme_bw() +
  labs(
    title = "Real Gross Domestic Product",
    subtitle = "SAAR: <span style = 'color: #374e8e;'>GDP</span>, <span style = 'color: #006d64;'>GDI</span> and <span style = 'color: #ac004f;'>Average of GDP and GDI</span>",
    caption = "Graph created by @econmaett with data from FRED.",
    x = "", y = ""
  ) +
  theme(plot.subtitle = element_markdown(), legend.position = "none")

ggsave(filename = "Recession-Dates/NBER/TP_Real-GDP-GDI-Average.png", width = 8, height = 4)
graphics.off()

# END