# ************************************************************************
# Financial Markets ----
# ************************************************************************
# URL: https://stlouisfed.shinyapps.io/macro-snapshot/#financial
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

### Effective Federal Funds Rate ----
dff <- fredr(series_id = "DFF")
dff |> 
  select(date, value) |> 
  ggplot(mapping = aes(x = date, y = value)) +
  geom_line(linewidth = 1, color = "#374e8e") +
  scale_x_date(limits = c(date(start_date), NA), date_breaks = "1 year", date_labels = "%y") +
  scale_y_continuous(limits = c(0, 6), breaks = 0:6) +
  theme_bw() +
  labs(
    title = "Effective Federal Funds Rate",
    subtitle = "In percent",
    caption = "Graph created by @econmaett with data from FRED.",
    x = "", y = ""
  )

ggsave(filename = "Macro_Snapshot/FinancialMarkets/EFF.png", width = 8, height = 4)
graphics.off()


### Federal Reserve Assets ----
# Total Assets
# Less Eliminations from Consolidation
# Wednesday Level
walcl <- fredr(series_id = "WALCL")
walcl |> 
  select(date, value) |> 
  ggplot(mapping = aes(x = date, y = value)) +
  geom_line(linewidth = 1, color = "#374e8e") +
  scale_x_date(limits = c(date(start_date), NA), date_breaks = "1 year", date_labels = "%y") +
  scale_y_continuous(limits = c(0, 10e6), labels = label_number(suffix = "M", scale = 1e-6), breaks = c(0:10)*1e6) +
  theme_bw() +
  labs(
    title = "Federal Reserve Assets",
    subtitle = "In millions (M) of dollars",
    caption = "Graph created by @econmaett with data from FRED.",
    x = "", y = ""
  )

ggsave(filename = "Macro_Snapshot/FinancialMarkets/WALCL.png", width = 8, height = 4)
graphics.off()


### Mortgage Rates ----
# 30-Year Fixed Rate Mortgage Average: MORTGAGE30US
# 15-Year Fiexed Rate Mortgage Average: MORTGAGE15US
# 5/1-Year Adjustable Rate Mortgage Average: MORTGAGE5US (Discontinued)
params <- list(
  series_id = c("MORTGAGE30US", "MORTGAGE15US", "MORTGAGE5US"),
  units = c("lin", "lin", "lin")
)
df <- purrr::pmap_dfr(.l = params, .f = ~fredr(series_id = .x, units = .y))
df |> 
  select(date, series_id, value) |> 
  ggplot(mapping = aes(x = date, y = value, color = series_id)) +
  geom_line(linewidth = 1) +
  scale_x_date(limits = c(date(start_date), NA), date_breaks = "1 year", date_labels = "%y") +
  scale_y_continuous(limits = c(0, 8)) +
  scale_color_manual(values = c("#ac004f", "#374e8e", "#478c5b")) +
  theme_bw() +
  labs(
    title = "Mortgage Rates in percent",
    subtitle = "<span style = 'color: #ac004f;'>15-year fixed rate</span>, <span style = 'color: #374e8e;'>30-year fixed rate</span> and <span style = 'color: #478c5b;'>5/1-year adjustable rate</span>",
    caption = "Graph created by @econmaett with data from FRED.",
    x = "", y = ""
  ) +
  theme(plot.subtitle = element_markdown(), legend.position = "none")

ggsave(filename = "Macro_Snapshot/FinancialMarkets/MortgageRates.png", width = 8, height = 4)
graphics.off()


### Treasury Yields ----
# Market Yield on U.S. Treasury Securities at:
# -  3-Month Constant Maturity: DGS3MO
# -  2-Year Constant Maturity: DGS2
# -  5-Year Constant Maturity: DGS5
# - 10-Year Constant Maturity: DGS10
params <- list(
  series_id = c("DGS3MO", "DGS2", "DGS5", "DGS10"),
  units = c("lin", "lin", "lin", "lin")
)
df <- purrr::pmap_dfr(.l = params, .f = ~fredr(series_id = .x, units = .y))
df |> 
  select(date, series_id, value) |> 
  ggplot(mapping = aes(x = date, y = value, color = series_id)) +
  geom_line(linewidth = 1) +
  scale_x_date(limits = c(date(start_date), NA), date_breaks = "1 year", date_labels = "%y") +
  scale_y_continuous(limits = c(0, 6)) +
  scale_color_manual(
    values = c("#374e8e", "#ac004f", "#478c5b", "#a07bde"), 
    breaks = c("DGS3MO", "DGS2", "DGS5", "DGS10")
    ) +
  theme_bw() +
  labs(
    title = "Treasury Yields in percent",
    subtitle = "<span style = 'color: #374e8e;'>3-month</span>, <span style = 'color: #ac004f;'>2-year</span>, <span style = 'color: #478c5b;'>5-year</span> and <span style = 'color: #a07bde;'>10-year</span>",
    caption = "Graph created by @econmaett with data from FRED.",
    x = "", y = ""
  ) +
  theme(plot.subtitle = element_markdown(), legend.position = "none")

ggsave(filename = "Macro_Snapshot/FinancialMarkets/TreasuryYields.png", width = 8, height = 4)
graphics.off()


### Yield Spreads ----
# 10-Year Treasury Constant Maturity Minus 2-Year Treasury Constant Maturity: T10Y2Y
# 10-Year Treasury Constant Maturity Minus 3-Month Treasury Constant Maturity: T10Y3M
params <- list(
  series_id = c("T10Y2Y", "T10Y3M"),
  units = c("lin", "lin")
)
df <- purrr::pmap_dfr(.l = params, .f = ~fredr(series_id = .x, units = .y))
df |> 
  select(date, series_id, value) |> 
  ggplot(mapping = aes(x = date, y = value, color = series_id)) +
  geom_line(linewidth = 1) +
  geom_hline(yintercept = 0, linetype = "dashed", color = "black", linewidth = 1, show.legend = NULL) +
  scale_x_date(limits = c(date(start_date), NA), date_breaks = "1 year", date_labels = "%y") +
  scale_y_continuous(limits = c(-3, 3), breaks = -3:3) +
  scale_color_manual(
    values = c("#374e8e", "#ac004f"), 
    breaks = c("T10Y2Y", "T10Y3M")
  ) +
  theme_bw() +
  labs(
    title = "Yield Spreads in percent",
    subtitle = "<span style = 'color: #374e8e;'>10-year Treasury minus 2-year Treasury</span> and <span style = 'color: #ac004f;'>10-year Treasury minus 3-month Treasury</span>",
    caption = "Graph created by @econmaett with data from FRED.",
    x = "", y = ""
  ) +
  theme(plot.subtitle = element_markdown(), legend.position = "none")

ggsave(filename = "Macro_Snapshot/FinancialMarkets/YieldSpreads.png", width = 8, height = 4)
graphics.off()


### Financial Market Stress Indices ----
# Kansas City Financial Stress Index: KCFSI
# Chicago Fed National Financial Conditions Index: NFCI
# St. Louis Fed Financial Stress Index: STLFSI4
params <- list(
  series_id = c("KCFSI", "NFCI", "STLFSI4"),
  units = c("lin", "lin", "lin")
)
df <- purrr::pmap_dfr(.l = params, .f = ~fredr(series_id = .x, units = .y))
df |> 
  select(date, series_id, value) |> 
  ggplot(mapping = aes(x = date, y = value, color = series_id)) +
  geom_line(linewidth = 1) +
  geom_hline(yintercept = 0, linetype = "dashed", color = "black", linewidth = 1, show.legend = NULL) +
  scale_x_date(limits = c(date(start_date), NA), date_breaks = "1 year", date_labels = "%y") +
  scale_y_continuous(limits = c(-2, 6)) +
  scale_color_manual(
    values = c("#374e8e", "#ac004f", "#478c5b"), 
    breaks = c("STLFSI4", "KCFSI", "NFCI")
  ) +
  theme_bw() +
  labs(
    title = "Financial Stress Indices",
    subtitle = "<span style = 'color: #374e8e;'>St. Louis Fed FSI</span>, <span style = 'color: #ac004f;'>Kansas City Fed FSI</span> and <span style = 'color: #478c5b;'>Chicago Fed FSI</span>",
    caption = "Graph created by @econmaett with data from FRED.",
    x = "", y = ""
  ) +
  theme(plot.subtitle = element_markdown(), legend.position = "none")

ggsave(filename = "Macro_Snapshot/FinancialMarkets/FinancialStressIndices.png", width = 8, height = 4)
graphics.off()


### Stock Market Indices ----
params <- list(
  series_id = c("DJIA", "SP500"),
  units = c("lin", "lin")
)
df <- purrr::pmap_dfr(.l = params, .f = ~fredr(series_id = .x, units = .y))
df |> 
  select(date, series_id, value) |> 
  ggplot(mapping = aes(x = date, y = value, color = series_id)) +
  geom_line(linewidth = 1) +
  geom_hline(yintercept = 0, linetype = "dashed", color = "black", linewidth = 1, show.legend = NULL) +
  scale_x_date(limits = c(date(start_date), NA), date_breaks = "1 year", date_labels = "%y") +
  scale_y_continuous(limits = c(0, 40e3), labels = label_number(suffix = "K", scale = 1e-3)) +
  scale_color_manual(
    values = c("#374e8e", "#ac004f"), 
    breaks = c("DJIA", "SP500")
  ) +
  theme_bw() +
  labs(
    title = "Stock Market Indices",
    subtitle = "<span style = 'color: #374e8e;'>Dow Jones Industrial Average</span> and <span style = 'color: #ac004f;'>S&P 500</span>",
    caption = "Graph created by @econmaett with data from FRED.",
    x = "", y = ""
  ) +
  theme(plot.subtitle = element_markdown(), legend.position = "none")

ggsave(filename = "Macro_Snapshot/FinancialMarkets/StockMarketIndices.png", width = 8, height = 4)
graphics.off()


### Corporate Bond Spreads ----
# Moody's Seasoned Baa Corporate Bond Yield Relative to Yield on 10-Year Treasury Constant Maturity: BC_10YEAR
# ICE BofA US High Yield Index Option-Adjusted Spread: BAMLH0A0HYM2
params <- list(
  series_id = c("BAA10Y", "BAMLH0A0HYM2"),
  units = c("lin", "lin")
)
df <- purrr::pmap_dfr(.l = params, .f = ~fredr(series_id = .x, units = .y))
df |> 
  select(date, series_id, value) |> 
  ggplot(mapping = aes(x = date, y = value, color = series_id)) +
  geom_line(linewidth = 1) +
  scale_x_date(limits = c(date(start_date), NA), date_breaks = "1 year", date_labels = "%y") +
  scale_y_continuous(limits = c(0, 12), breaks = seq(0, 12, 2)) +
  scale_color_manual(
    values = c("#374e8e", "#ac004f"), 
    breaks = c("BAA10Y", "BAMLH0A0HYM2")
  ) +
  theme_bw() +
  labs(
    title = "Corporate Bond Spreads in Percent",
    subtitle = "<span style = 'color: #374e8e;'>Seasoned BAA corporate bond yield relative to 10-year Treasury</span> and <span style = 'color: #ac004f;'>High yield index option-adjusted spread</span>",
    caption = "Graph created by @econmaett with data from FRED.",
    x = "", y = ""
  ) +
  theme(plot.subtitle = element_markdown(), legend.position = "none")

ggsave(filename = "Macro_Snapshot/FinancialMarkets/CorporateBondSpreads.png", width = 8, height = 4)
graphics.off()

# END