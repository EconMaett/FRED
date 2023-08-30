# ************************************************************************
# International Indicators ----
# ************************************************************************
# URL: https://stlouisfed.shinyapps.io/macro-snapshot/#international
#
# Feel free to copy, adapt, and use this code for your own purposes at
# your own risk.
#
# Matthias Spichiger, 2023 (matthias.spichiger@bluewin.ch)
# ************************************************************************

## Load packages ----
library(fredr)
library(tidyverse)
library(scales)
library(ggtext)

start_date <- "2015-01-01"
usrecdp <- read_csv(file = "Recession_Dates/NBER_Recession_Dates.csv")


### Crude Oil Prices ----
# Crude Oil Prices: West Texas Intermediate (WTI) - Cushing Oklahoma: DCOILWTICO
# Crude Oil Prices: Brent - Europe: DCOILBRENTEU
params <- list(
  series_id = c("DCOILWTICO", "DCOILBRENTEU"),
  units = c("lin", "lin")
)
df <- purrr::pmap_dfr(.l = params, .f = ~fredr(series_id = .x, units = .y))
df |> 
  select(date, series_id, value) |> 
  ggplot() +
  geom_line(mapping = aes(x = date, y = value, color = series_id), linewidth = 1) +
  geom_rect(data = usrecdp, aes(xmin = Peak, xmax = Trough, ymin = -Inf, ymax = +Inf), fill = "grey", alpha = 0.2) +
  scale_x_date(limits = c(date(start_date), today()), date_breaks = "1 year", date_labels = "%y") +  scale_y_continuous(limits = c(0, 150), breaks = seq(0, 150, 25)) +
  scale_color_manual(
    values = c("#374e8e", "#ac004f"), 
    breaks = c("DCOILWTICO", "DCOILBRENTEU")
  ) +
  theme_bw() +
  labs(
    title = "Crude Oil Prices in Dollars per Barrel",
    subtitle = "<span style = 'color: #374e8e;'>West Texas Intermediate (Cushing, OK)</span> and <span style = 'color: #ac004f;'>Brent (Europe)</span>",
    caption = "Graph created by @econmaett with data from FRED.",
    x = "", y = ""
  ) +
  theme(plot.subtitle = element_markdown(), legend.position = "none")

ggsave(filename = "Macro_Snapshot/International/CrudeOilPrices.png", width = 8, height = 4)
graphics.off()


### Global Commodity Prices ----
# Global price of Energy Index: PNRGINDEXM
# Global price of Food index: PFOODINDEXM
# Global price of Agr. Raw Material Index: PRAWMINDEXM
# Global price of Metal index: PMETAINDEXM
params <- list(
  series_id = c("PNRGINDEXM", "PFOODINDEXM", "PRAWMINDEXM", "PMETAINDEXM"),
  units = c("lin", "lin", "lin", "lin")
)
df <- purrr::pmap_dfr(.l = params, .f = ~fredr(series_id = .x, units = .y))
df |> 
  select(date, series_id, value) |> 
  ggplot() +
  geom_line(mapping = aes(x = date, y = value, color = series_id), linewidth = 1) +
  geom_hline(yintercept = 100, linetype = "dashed", color = "black", show.legend = NULL) +
  geom_rect(data = usrecdp, aes(xmin = Peak, xmax = Trough, ymin = -Inf, ymax = +Inf), fill = "grey", alpha = 0.2) +
  scale_x_date(limits = c(date(start_date), today()), date_breaks = "1 year", date_labels = "%y") +  scale_y_continuous(limits = c(0, 400), breaks = seq(0, 400, 100)) +
  scale_color_manual(
    values = c("#374e8e", "#ac004f", "#478c5b", "#a07bde"), 
    breaks = c("PNRGINDEXM", "PFOODINDEXM", "PRAWMINDEXM", "PMETAINDEXM")
  ) +
  theme_bw() +
  labs(
    title = "Global Commodity Prices Index (2016 = 100)",
    subtitle = "<span style = 'color: #374e8e;'>Energy</span>, <span style = 'color: #ac004f;'>Food</span>, <span style = 'color: #478c5b;'>Agricultural raw materials</span> and <span style = 'color: #a07bde;'>Metal</span>",
    caption = "Graph created by @econmaett with data from FRED.",
    x = "", y = ""
  ) +
  theme(plot.subtitle = element_markdown(), legend.position = "none")

ggsave(filename = "Macro_Snapshot/International/GlobalCommodityPrices.png", width = 8, height = 4)
graphics.off()


### Real Broad Dollar Index ----
# Real Broad Dollar Index
rtwexbgs <- fredr(series_id = "RTWEXBGS")
rtwexbgs |> 
  select(date, value) |> 
  ggplot() +
  geom_line(mapping = aes(x = date, y = value), linewidth = 1, color = "#374e8e") +
  geom_rect(data = usrecdp, aes(xmin = Peak, xmax = Trough, ymin = -Inf, ymax = +Inf), fill = "grey", alpha = 0.2) +
  scale_x_date(limits = c(date(start_date), today()), date_breaks = "1 year", date_labels = "%y") +  scale_y_continuous(limits = c(100, 125), breaks = seq(100, 125, 5)) +
  theme_bw() +
  labs(
    title = "Real Broad dollar Index",
    subtitle = "Index (Jan 2016 = 100)",
    caption = "Graph created by @econmaett with data from FRED.",
    x = "", y = ""
  )

ggsave(filename = "Macro_Snapshot/International/RealBraodDollarIndex.png", width = 8, height = 4)
graphics.off()


### Foreign Exchange Rates ----
# Canadian Dollars to U.S. Dollar Spot Exchange Rate: DEXCAUS
# U.S. Dollars to Euro Spot Exchange Rate: EXUSEU
# Japanese Yen to U.S. Dollar Spot Exchange Rate: EXJPUS
# Mexican Pesos to U.S. Dollar Spot Exchange Rate: EXMXUS
params <- list(
  series_id = c("DEXCAUS", "EXUSEU"),
  units = c("lin", "lin")
)
df <- purrr::pmap_dfr(.l = params, .f = ~fredr(series_id = .x, units = .y))
df |> 
  select(date, series_id, value) |> 
  ggplot() +
  geom_line(mapping = aes(x = date, y = value, color = series_id), linewidth = 1) +
  geom_rect(data = usrecdp, aes(xmin = Peak, xmax = Trough, ymin = -Inf, ymax = +Inf), fill = "grey", alpha = 0.2) +
  scale_x_date(limits = c(date(start_date), today()), date_breaks = "1 year", date_labels = "%y") +
  scale_y_continuous(limits = c(0.9, 1.5), breaks = seq(0.9, 1.5, 0.3)) +
  scale_color_manual(
    values = c("#374e8e", "#ac004f"), 
    breaks = c("DEXCAUS", "EXUSEU")
  ) +
  theme_bw() +
  labs(
    title = "Foreign Exchange Rates, Currency to USD",
    subtitle = "<span style = 'color: #374e8e;'>Canadian Dollars</span> and <span style = 'color: #ac004f;'>Euros</span>",
    caption = "Graph created by @econmaett with data from FRED.",
    x = "", y = ""
  ) +
  theme(plot.subtitle = element_markdown(), legend.position = "none")

ggsave(filename = "Macro_Snapshot/International/ForeignExchangeRates.png", width = 8, height = 4)
graphics.off()


### Real Gross Domestic Product (GDP) ----
# GDP Canada: NAEXKP01CAQ189S
# GDP Japan: NAEXKP01JPQ189S
# GDP Euro Area: NAEXKP01EZQ652S
# GDP UK: NAEXKP01GBQ652S
# GDP USA: NAEXKP01USQ652S
params <- list(
  series_id = c("NAEXKP01CAQ189S", "NAEXKP01JPQ189S", "NAEXKP01EZQ652S", "NAEXKP01GBQ652S", "NAEXKP01USQ652S"),
  units = c("pc1", "pc1", "pc1", "pc1", "pc1")
)
df <- purrr::pmap_dfr(.l = params, .f = ~fredr(series_id = .x, units = .y))
df |> 
  select(date, series_id, value) |> 
  ggplot() +
  geom_line(mapping = aes(x = date, y = value, color = series_id), linewidth = 1) +
  geom_hline(yintercept = 0, linetype = "dashed", color = "black", show.legend = NULL) +
  geom_rect(data = usrecdp, aes(xmin = Peak, xmax = Trough, ymin = -Inf, ymax = +Inf), fill = "grey", alpha = 0.2) +
  scale_x_date(limits = c(date(start_date), today()), date_breaks = "1 year", date_labels = "%y") +  scale_y_continuous(limits = c(-30, 30), breaks = seq(-30, 30, 10)) +
  scale_color_manual(
    values = c("#374e8e", "#ac004f", "#478c5b", "#8aabfd", "black"), 
    breaks = c("NAEXKP01CAQ189S", "NAEXKP01JPQ189S", "NAEXKP01EZQ652S", "NAEXKP01GBQ652S", "NAEXKP01USQ652S")
  ) +
  theme_bw() +
  labs(
    title = "Real Gross Domestic Product, Year-over-year % change",
    subtitle = "<span style = 'color: #374e8e;'>Canada</span>, <span style = 'color: #ac004f;'>Japan</span>, <span style = 'color: #478c5b;'>Euro Area</span>, <span style = 'color: #a07bde;'>U.K.</span> and <span style = 'color: black;'>U.S.</span>",
    caption = "Graph created by @econmaett with data from FRED.",
    x = "", y = ""
  ) +
  theme(plot.subtitle = element_markdown(), legend.position = "none")

ggsave(filename = "Macro_Snapshot/International/RealGDP.png", width = 8, height = 4)
graphics.off()


### Consumer Price Indices (CPI) ----
# CPI Canada: CANCPIALLMINMEI
# CPI Euro Area: EA19CPALTT01IXOBM
# CPI Japan: JPNCPIALLMINMEI
# CPI UK: GBRCPIALLMINMEI
# CPI US: USACPIALLMINMEI
params <- list(
  series_id = c("CANCPIALLMINMEI", "EA19CPALTT01IXOBM", "GBRCPIALLMINMEI", "USACPIALLMINMEI"),
  units = c("pc1", "pc1", "pc1", "pc1")
)
df <- purrr::pmap_dfr(.l = params, .f = ~fredr(series_id = .x, units = .y))
df |> 
  select(date, series_id, value) |> 
  ggplot() +
  geom_line(mapping = aes(x = date, y = value, color = series_id), linewidth = 1) +
  geom_hline(yintercept = 0, linetype = "dashed", color = "black", show.legend = NULL) +
  geom_rect(data = usrecdp, aes(xmin = Peak, xmax = Trough, ymin = -Inf, ymax = +Inf), fill = "grey", alpha = 0.2) +
  scale_x_date(limits = c(date(start_date), today()), date_breaks = "1 year", date_labels = "%y") +
  scale_y_continuous(limits = c(-5, 15), breaks = seq(-5, 15, 5)) +
  scale_color_manual(
    values = c("#374e8e", "#ac004f", "#478c5b", "black"), 
    breaks = c("CANCPIALLMINMEI", "EA19CPALTT01IXOBM", "GBRCPIALLMINMEI", "USACPIALLMINMEI")
  ) +
  theme_bw() +
  labs(
    title = "Consumer Prices, Year-over-year % change",
    subtitle = "<span style = 'color: #374e8e;'>Canada</span>, <span style = 'color: #ac004f;'>Euro area</span>, <span style = 'color: #478c5b;'>U.K.</span> and <span style = 'color: black;'>U.S.</span>",
    caption = "Graph created by @econmaett with data from FRED.",
    x = "", y = ""
  ) +
  theme(plot.subtitle = element_markdown(), legend.position = "none")

ggsave(filename = "Macro_Snapshot/International/ConsumerPrices.png", width = 8, height = 4)
graphics.off()

# END