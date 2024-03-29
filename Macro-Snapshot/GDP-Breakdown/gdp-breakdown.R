# ************************************************************************
# Gross Domestic Product ----
# ************************************************************************
# URL: https://stlouisfed.shinyapps.io/macro-snapshot/#GDP
# Feel free to copy, adapt, and use this code for your own purposes.
# ************************************************************************

## Load packages ----
library(fredr)
library(tidyverse)
library(scales)
library(ggtext)

start_date <- "2018-01-01"
usrecdp <- read_csv(file = "Recession-Dates/US_NBER/Recession-Dates_NBER_US_Daily_Midpoint.csv")



### Real Gross Domestic Product (GDP) ----
params <- list(
  series_id = c("GDPPOT", "GDPC1"),
  units = c("lin", "lin")
)
df <- purrr::pmap_dfr(.l = params, .f = ~fredr(series_id = .x, units = .y))
df |> 
  select(date, series_id, value) |> 
  ggplot() +
  geom_line(mapping = aes(x = date, y = value, color = series_id), linewidth = 1) +
  geom_rect(data = usrecdp, aes(xmin = recession_start, xmax = recession_end, ymin = -Inf, ymax = +Inf), fill = "darkgrey", alpha = 0.3) +
  scale_x_date(expand = c(0, 0), limits = c(date(start_date), today()), date_breaks = "1 year", date_labels = "%Y") +
  scale_y_continuous(expand = c(0, 0), limits = c(17e3, 22e3), labels = label_number(suffix = "K", scale = 1e-3)) +
  scale_color_manual(values = c("#ac004f", "#374e8e")) +
  theme_bw() +
  labs(
    title = "Real Gross Domestic Product (GDP) in billions of chained 2012 Dollars",
    subtitle = "<span style = 'color: #374e8e;'>Real Potential GDP</span> and <span style = 'color: #ac004f;'>Real GDP</span>",
    caption = "Graph created by @econmaett with data from FRED.",
    x = "", y = ""
  ) +
  theme(plot.subtitle = element_markdown(), legend.position = "none")

ggsave(filename = "Macro-Snapshot/GDP-Breakdown/Fig_Real-Gross-Domestic-Product.png", width = 8, height = 4)
graphics.off()


### Real Personal Consumption Expenditures (PCE) ----
# Services, Non-durable goods, durable goods
params <- list(
  series_id = c("PCESVC96", "PCNDGC96", "PCDGCC96"),
  units = c("lin", "lin", "lin")
)
df <- purrr::pmap_dfr(.l = params, .f = ~fredr(series_id = .x, units = .y))
df |> 
  select(date, series_id, value) |> 
  ggplot() +
  geom_line(mapping = aes(x = date, y = value, color = series_id), linewidth = 1) +
  geom_rect(data = usrecdp, aes(xmin = recession_start, xmax = recession_end, ymin = -Inf, ymax = +Inf), fill = "darkgrey", alpha = 0.3) +
  scale_x_date(expand = c(0, 0), limits = c(date(start_date), NA), date_breaks = "1 year", date_labels = "%Y") +
  scale_y_continuous(expand = c(0, 0), limits = c(0, 10e3), labels = label_number(suffix = "K", scale = 1e-3)) +
  scale_color_manual(values = c("#478c5b", "#374e8e", "#ac004f")) +
  theme_bw() +
  labs(
    title = "Real Personal Consumption Expenditures (PCE)",
    subtitle = "<span style = 'color:#478c5b;'>Durable goods</span>, <span style = 'color: #374e8e;'>Services</span> and <span style = 'color: #ac004f;'>Nondurable goods</span>",
    caption = "Graph created by @econmaett with data from FRED.",
    x = "", y = ""
  ) +
  theme(plot.subtitle = element_markdown(), legend.position = "none")

ggsave(filename = "Macro-Snapshot/GDP-Breakdown/Fig_Real-Personal-Consumption-Expenditures.png", width = 8, height = 4)
graphics.off()


### Real Private Fixed Investment ----
# - Real Private Residential Fixed Investment (PRFIC1)
# - Real Private Nonresidential Fixed Investment (PNFIC1)
params <- list(
  series_id = c("PRFIC1", "PNFIC1"),
  units = c("lin", "lin")
)
df <- purrr::pmap_dfr(.l = params, .f = ~fredr(series_id = .x, units = .y))
df |> 
  select(date, series_id, value) |> 
  ggplot() +
  geom_line(mapping = aes(x = date, y = value, color = series_id), linewidth = 1) +
  geom_rect(data = usrecdp, aes(xmin = recession_start, xmax = recession_end, ymin = -Inf, ymax = +Inf), fill = "darkgrey", alpha = 0.3) +
  scale_x_date(expand = c(0, 0), limits = c(date(start_date), today()), date_breaks = "1 year", date_labels = "%Y") +
  scale_y_continuous(expand = c(0, 0), limits = c(0, 3000), labels = label_number(suffix = "B")) +
  scale_color_manual(values = c("#ac004f", "#374e8e")) +
  theme_bw() +
  labs(
    title = "Real Private Fixed Investment in billions of chained 2012 Dollars",
    subtitle = "<span style = 'color: #ac004f;'>Nonresidential</span> and <span style = 'color: #ac004f;'>Residential</span>",
    caption = "Graph created by @econmaett with data from FRED.",
    x = "", y = ""
  ) +
  theme(plot.subtitle = element_markdown(), legend.position = "none")

ggsave(filename = "Macro-Snapshot/GDP-Breakdown/Fig_Real-Private-Fixed-Investment.png", width = 8, height = 4)
graphics.off()


### Change in Real Private Inventories ----
cbic1 <- fredr(series_id = "CBIC1", units = "lin")
cbic1 |> 
  select(date, value) |> 
  ggplot() +
  geom_line(mapping = aes(x = date, y = value), color = "#374e8e", linewidth = 1) +
  geom_hline(yintercept = 0, linetype = "dashed", color = "black", show.legend = NULL) +
  geom_rect(data = usrecdp, aes(xmin = recession_start, xmax = recession_end, ymin = -Inf, ymax = +Inf), fill = "darkgrey", alpha = 0.3) +
  scale_x_date(expand = c(0, 0), limits = c(date(start_date), today()), date_breaks = "1 year", date_labels = "%Y") +
  theme_bw() +
  labs(
    title = "Change in Real Private Inventories",
    subtitle = "In billions of chained 2012 dollars",
    caption = "Graph created by @econmaett with data from FRED.",
    x = "", y = ""
  )

ggsave(filename = "Macro-Snapshot/GDP-Breakdown/Fig_Real-Private-Inventories.png", width = 8, height = 4)
graphics.off()


### Real Government Consumption and Gross Investment ----
gcec1 <- fredr(series_id = "GCEC1", units = "lin")
gcec1 |> 
  select(date, value) |> 
  ggplot() +
  geom_line(mapping = aes(x = date, y = value), color = "#374e8e", linewidth = 1) +
  geom_rect(data = usrecdp, aes(xmin = recession_start, xmax = recession_end, ymin = -Inf, ymax = +Inf), fill = "darkgrey", alpha = 0.3) +
  scale_x_date(expand = c(0, 0), limits = c(date(start_date), today()), date_breaks = "1 year", date_labels = "%Y") +
  scale_y_continuous(expand = c(0, 0), limits = c(3000, 3500), labels = label_number(suffix = "K", scale = 1e-3)) +
  theme_bw() +
  labs(
    title = "Real Government Consumption and Gross Investment",
    subtitle = "In billions of chained 2012 dollars",
    caption = "Graph created by @econmaett with data from FRED.",
    x = "", y = ""
  )

ggsave(filename = "Macro-Snapshot/GDP-Breakdown/Fig_Real-Government-Consumption-and-Gross-Investment.png", width = 8, height = 4)
graphics.off()


### Real Imports and Exports of Goods and Services ----
params <- list(
  series_id = c("IMPGSC1", "EXPGSC1"),
  units = c("lin", "lin")
)

df <- purrr::pmap_dfr(.l = params, .f = ~fredr(series_id = .x, units = .y))
df |> 
  select(date, series_id, value) |> 
  ggplot() +
  geom_line(mapping = aes(x = date, y = value, color = series_id), linewidth = 1) +
  geom_rect(data = usrecdp, aes(xmin = recession_start, xmax = recession_end, ymin = -Inf, ymax = +Inf), fill = "darkgrey", alpha = 0.3) +
  scale_x_date(expand = c(0, 0), limits = c(date(start_date), today()), date_breaks = "1 year", date_labels = "%Y") +
  scale_y_continuous(expand = c(0, 0), limits = c(0, 4500)) +
  scale_color_manual(values = c("#374e8e", "#ac004f")) +
  theme_bw() +
  labs(
    title = "Real Imports and Exports of Goods and Services in billions of chained 2012 Dollars",
    subtitle = "<span style = 'color: #374e8e;'>Imports</span> and <span style = 'color: #ac004f;'>Exports</span>",
    caption = "Graph created by @econmaett with data from FRED.",
    x = "", y = ""
  ) +
  theme(plot.subtitle = element_markdown(), legend.position = "none")

ggsave(filename = "Macro-Snapshot/GDP-Breakdown/Fig_Real-Imports-and-Exports-of-Goods-and-Services.png", width = 8, height = 4)
graphics.off()


### Real Net Exports of Goods and Services ----
netexc <- fredr(series_id = "NETEXC", units = "lin")
netexc |> 
  select(date, value) |> 
  ggplot() +
  geom_line(mapping = aes(x = date, y = value), color = "#374e8e", linewidth = 1) +
  geom_hline(yintercept = 0, linetype = "dashed", color = "black", show.legend = NULL) +
  geom_rect(data = usrecdp, aes(xmin = recession_start, xmax = recession_end, ymin = -Inf, ymax = +Inf), fill = "darkgrey", alpha = 0.3) +
  scale_x_date(expand = c(0, 0), limits = c(date(start_date), today()), date_breaks = "1 year", date_labels = "%Y") +
  scale_y_continuous(expand = c(0, 0), limits = c(-1600, 0)) +
  theme_bw() +
  labs(
    title = "Real Net Exports of Goods and Services",
    subtitle = "In billions of chained 2012 dollars",
    caption = "Graph created by @econmaett with data from FRED.",
    x = "", y = ""
  )

ggsave(filename = "Macro-Snapshot/GDP-Breakdown/Fig_Real-Net-Exports-of-Goods-and-Services.png", width = 8, height = 4)
graphics.off()


### Real Gross Domestic Income (GDI) ----
gdi <- fredr(series_id = "A261RX1Q020SBEA")
gdi |> 
  select(date, value) |> 
  ggplot() +
  geom_line(mapping = aes(x = date, y = value), linewidth = 1, color = "#374e8e") +
  geom_rect(data = usrecdp, aes(xmin = recession_start, xmax = recession_end, ymin = -Inf, ymax = +Inf), fill = "darkgrey", alpha = 0.3) +
  scale_x_date(expand = c(0, 0), limits = c(date(start_date), today()), date_breaks = "1 year", date_labels = "%Y") +  scale_y_continuous(expand = c(0, 0), limits = c(17e3, 21e3), labels = label_number(suffix = "K", scale = 1e-3)) +
  theme_bw() +
  labs(
    title = "Real Gross Domestic Income (GDI)",
    subtitle = "In billions of chained 2012 dollars",
    caption = "Graph created by @econmaett with data from FRED.",
    x = "", y = ""
  )

ggsave(filename = "Macro-Snapshot/GDP-Breakdown/Fig_Real-Gross-Domestic-Income.png", width = 8, height = 4)
graphics.off()

# END