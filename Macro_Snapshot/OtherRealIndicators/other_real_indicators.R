# ************************************************************************
# Other Real Indicators ----
# ************************************************************************
# URL: https://stlouisfed.shinyapps.io/macro-snapshot/#real
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

start_date <- "2018-01-01"
usrecdp <- read_csv(file = "Recession_Dates/NBER_Recession_Dates.csv")


### Real Personal Income ----
# Real Personal Income: RPI
# Real personal income excluding current transfer receipts: W875RX1
params <- list(
  series_id = c("RPI", "W875RX1"),
  units = c("lin", "lin")
)
df <- purrr::pmap_dfr(.l = params, .f = ~fredr(series_id = .x, units = .y))
df |> 
  select(date, series_id, value) |> 
  ggplot() +
  geom_line(mapping = aes(x = date, y = value, color = series_id), linewidth = 1) +
  geom_hline(yintercept = 0, linetype = "dashed", color = "black", linewidth = 1, show.legend = NULL) +
  geom_rect(data = usrecdp, aes(xmin = Peak, xmax = Trough, ymin = -Inf, ymax = +Inf), fill = "grey", alpha = 0.2) +
  scale_x_date(limits = c(date(start_date), NA), date_breaks = "1 year", date_labels = "%Y") +  scale_y_continuous(limits = c(0, 150), breaks = seq(0, 150, 25)) +
  scale_y_continuous(limits = c(12.5e3, 22.5e3), labels = label_number(suffix = "K", scale = 1e-3)) +
  scale_color_manual(
    values = c("#374e8e", "#ac004f"), 
    breaks = c("RPI", "W875RX1")
  ) +
  theme_bw() +
  labs(
    title = "Real Personal Income",
    subtitle = "<span style = 'color: #374e8e;'>Real personal income</span> and <span style = 'color: #ac004f;'>Real personal income excluding transfers</span>",
    caption = "Graph created by @econmaett with data from FRED.",
    x = "", y = ""
  ) +
  theme(plot.subtitle = element_markdown(), legend.position = "none")

ggsave(filename = "Macro_Snapshot/OtherRealIndicators/RealPersonalIncome.png", width = 8, height = 4)
graphics.off()


### Personal Savings ----
pmsave <- fredr(series_id = "PMSAVE")
pmsave |> 
  select(date, value) |> 
  ggplot() +
  geom_line(mapping = aes(x = date, y = value), linewidth = 1, color = "#374e8e") +
  geom_rect(data = usrecdp, aes(xmin = Peak, xmax = Trough, ymin = -Inf, ymax = +Inf), fill = "grey", alpha = 0.2) +
  scale_x_date(limits = c(date(start_date), NA), date_breaks = "1 year", date_labels = "%Y") +  scale_y_continuous(limits = c(0, 150), breaks = seq(0, 150, 25)) +
  scale_y_continuous(limits = c(0, 8e3), labels = label_number(suffix = "K", scale = 1e-3)) +
  theme_bw() +
  labs(
    title = "Personal Savings",
    subtitle = "In billions of chained 2012 dollars",
    caption = "Graph created by @econmaett with data from FRED.",
    x = "", y = ""
  )

ggsave(filename = "Macro_Snapshot/OtherRealIndicators/PersonalSavings.png", height = 4, width = 8)
graphics.off()


### Real Retail Sales ----
# Advance Retail Sales: Retail Trade and Food Services: RSAFS
# Chained Consumer Price Index for All Urban Consumers:
# All Items in U.S. City Average: SUUR0000SA0
params <- list(
  series_id = c("RSAFS", "SUUR0000SA0"),
  units = c("lin", "lin")
)
df <- purrr::pmap_dfr(.l = params, .f = ~fredr(series_id = .x, units = .y))

df |> 
  select(date, series_id, value) |> 
  pivot_wider(names_from = series_id, values_from = value) |> 
  mutate(RealRetailSales = RSAFS / SUUR0000SA0 *131.97575) |> 
  ggplot() +
  geom_line(mapping = aes(x = date, y = RealRetailSales), linewidth = 1, color = "#374e8e") +
  geom_rect(data = usrecdp, aes(xmin = Peak, xmax = Trough, ymin = -Inf, ymax = +Inf), fill = "grey", alpha = 0.2) +
  scale_x_date(limits = c(date(start_date), NA), date_breaks = "1 year", date_labels = "%Y") +  scale_y_continuous(limits = c(0, 150), breaks = seq(0, 150, 25)) +
  scale_y_continuous(limits = c(350e3, 600e3), labels = label_number(suffix = "K", scale = 1e-3)) +
  theme_bw() +
  labs(
    title = "Real Retail Sales",
    subtitle = "In millions of chained 2012 dollars",
    caption = "Graph created by @econmaett with data from FRED.",
    x = "", y = ""
  )

ggsave(filename = "Macro_Snapshot/OtherRealIndicators/RealRetailSales.png", height = 4, width = 8)
graphics.off()


### Light Weight Vehicle Sales ----
# Light Weight Vehicle Sales: Autos and Light Trucks: ALTSALES
altsales <- fredr(series_id = "ALTSALES")
altsales |> 
  select(date, value) |> 
  ggplot() +
  geom_line(mapping = aes(x = date, y = value), linewidth = 1, color = "#374e8e") +
  geom_rect(data = usrecdp, aes(xmin = Peak, xmax = Trough, ymin = -Inf, ymax = +Inf), fill = "grey", alpha = 0.2) +
  scale_x_date(limits = c(date(start_date), NA), date_breaks = "1 year", date_labels = "%Y") +  scale_y_continuous(limits = c(0, 150), breaks = seq(0, 150, 25)) +
  scale_y_continuous(limits = c(0, 20), labels = label_number(suffix = "M")) +
  theme_bw() +
  labs(
    title = "Light Weight Vehicle Sales",
    subtitle = "In millions (M)",
    caption = "Graph created by @econmaett with data from FRED.",
    x = "", y = ""
  )

ggsave(filename = "Macro_Snapshot/OtherRealIndicators/LightWeightVehicleSales.png", height = 4, width = 8)
graphics.off()


### Industrial Production -----
# Industrial Production: Total Index: INDPRO
indpro <- fredr(series_id = "INDPRO")
indpro |> 
  select(date, value) |> 
  ggplot() +
  geom_line(mapping = aes(x = date, y = value), linewidth = 1, color = "#374e8e") +
  geom_hline(yintercept = 100, linetype = "dashed", color = "black", show.legend = NULL) +
  geom_rect(data = usrecdp, aes(xmin = Peak, xmax = Trough, ymin = -Inf, ymax = +Inf), fill = "grey", alpha = 0.2) +
  scale_x_date(limits = c(date(start_date), NA), date_breaks = "1 year", date_labels = "%Y") +  scale_y_continuous(limits = c(0, 150), breaks = seq(0, 150, 25)) +
  scale_y_continuous(limits = c(80, 110), breaks = seq(80, 110, 5)) +
  theme_bw() +
  labs(
    title = "Industrial Production",
    subtitle = "Index (2017 = 100)",
    caption = "Graph created by @econmaett with data from FRED.",
    x = "", y = ""
  )

ggsave(filename = "Macro_Snapshot/OtherRealIndicators/IndustrialProduction.png", height = 4, width = 8)
graphics.off()


### Capacity Utilization, Total Industry ----
# Capacity Utilization: Total Index: TCU
tcu <- fredr(series_id = "TCU")
tcu |> 
  select(date, value) |> 
  ggplot() +
  geom_line(mapping = aes(x = date, y = value), linewidth = 1, color = "#374e8e") +
  geom_rect(data = usrecdp, aes(xmin = Peak, xmax = Trough, ymin = -Inf, ymax = +Inf), fill = "grey", alpha = 0.2) +
  scale_x_date(limits = c(date(start_date), NA), date_breaks = "1 year", date_labels = "%Y") +  scale_y_continuous(limits = c(0, 150), breaks = seq(0, 150, 25)) +
  scale_y_continuous(limits = c(60, 85), breaks = seq(60, 85, 5)) +
  theme_bw() +
  labs(
    title = "Capacity Utilization, Total Industry",
    subtitle = "% of capacity",
    caption = "Graph created by @econmaett with data from FRED.",
    x = "", y = ""
  )

ggsave(filename = "Macro_Snapshot/OtherRealIndicators/CapacityUtilization.png", height = 4, width = 8)
graphics.off()


### Manufacturers' Non-defense Capital Goods Shipments ---
# Manufactuers' Value of Shipments: Nondefense Captial Goods: ANDEVS
# Producer Price Index by Commodity: Final Demand: Private Capital Equipment: WPSFD41312
params <- list(
  series_id = c("ANDEVS", "WPSFD41312"),
  units = c("lin", "lin")
)
df <- purrr::pmap_dfr(.l = params, .f = ~fredr(series_id = .x, units = .y))

df |> 
  select(date, series_id, value) |> 
  pivot_wider(names_from = series_id, values_from = value) |> 
  mutate(RealNondefCapGoodShip = ANDEVS / WPSFD41312 * 162.775) |> 
  ggplot() +
  geom_line(mapping = aes(x = date, y = RealNondefCapGoodShip), linewidth = 1, color = "#374e8e") +
  geom_rect(data = usrecdp, aes(xmin = Peak, xmax = Trough, ymin = -Inf, ymax = +Inf), fill = "grey", alpha = 0.2) +
  scale_x_date(limits = c(date(start_date), NA), date_breaks = "1 year", date_labels = "%Y") +  scale_y_continuous(limits = c(0, 150), breaks = seq(0, 150, 25)) +
  scale_y_continuous(limits = c(50e3, 75e3), labels = label_number(suffix = "K", scale = 1e-3)) +
  theme_bw() +
  labs(
    title = "Manufacturers' Nondefense Capital Goods Shipments",
    subtitle = "In millions of chained 2012 dollars",
    caption = "Graph created by @econmaett with data from FRED.",
    x = "", y = ""
  )

ggsave(filename = "Macro_Snapshot/OtherRealIndicators/ManNondefCapGoodsShip.png", height = 4, width = 8)
graphics.off()


### Manufacturers' New Durable Goods Orders ----
# Manufactures' New Orders: Durable Goods: DGORDER
# Producer Price Index by Commodity:
# Final Demand: Capital Equipment: DGORDER
params <- list(
  series_id = c("DGORDER", "WPSFD41312"),
  units = c("lin", "lin")
)
df <- purrr::pmap_dfr(.l = params, .f = ~fredr(series_id = .x, units = .y))

df |> 
  select(date, series_id, value) |> 
  pivot_wider(names_from = series_id, values_from = value) |> 
  mutate(RealNewDurableGoodsOrders = DGORDER / WPSFD41312 * 162.775) |> 
  ggplot() +
  geom_line(mapping = aes(x = date, y = RealNewDurableGoodsOrders), linewidth = 1, color = "#374e8e") +
  geom_rect(data = usrecdp, aes(xmin = Peak, xmax = Trough, ymin = -Inf, ymax = +Inf), fill = "grey", alpha = 0.2) +
  scale_x_date(limits = c(date(start_date), NA), date_breaks = "1 year", date_labels = "%Y") +  scale_y_continuous(limits = c(0, 150), breaks = seq(0, 150, 25)) +
  scale_y_continuous(limits = c(125e3, 250e3), labels = label_number(suffix = "K", scale = 1e-3)) +
  theme_bw() +
  labs(
    title = "Manufacturers' New Durable Goods Orders",
    subtitle = "In millions of chained 2012 dollars",
    caption = "Graph created by @econmaett with data from FRED.",
    x = "", y = ""
  )

ggsave(filename = "Macro_Snapshot/OtherRealIndicators/ManNewDurGoodsOrders.png", height = 4, width = 8)
graphics.off()


### New Private Housing Construction ----
# New Privately-Owned Housing Units Authorized in Permit-Issuing Places:
# Total Units: PERMIT
# New Privately-Owned Housing Units Started: Total Units: HOUST
params <- list(
  series_id = c("PERMIT", "HOUST"),
  units = c("lin", "lin")
)
df <- purrr::pmap_dfr(.l = params, .f = ~fredr(series_id = .x, units = .y))
df |> 
  select(date, series_id, value) |> 
  ggplot() +
  geom_line(mapping = aes(x = date, y = value, color = series_id), linewidth = 1) +
  geom_hline(yintercept = 0, linetype = "dashed", color = "black", linewidth = 1, show.legend = NULL) +
  geom_rect(data = usrecdp, aes(xmin = Peak, xmax = Trough, ymin = -Inf, ymax = +Inf), fill = "grey", alpha = 0.2) +
  scale_x_date(limits = c(date(start_date), NA), date_breaks = "1 year", date_labels = "%Y") +  scale_y_continuous(limits = c(0, 150), breaks = seq(0, 150, 25)) +
  scale_y_continuous(limits = c(750, 2000), breaks = seq(750, 2000, 250)) +
  scale_color_manual(
    values = c("#374e8e", "#ac004f"), 
    breaks = c("PERMIT", "HOUST")
  ) +
  theme_bw() +
  labs(
    title = "New Private Housing Construction",
    subtitle = "<span style = 'color: #374e8e;'>New permits</span> and <span style = 'color: #ac004f;'>New starts</span>",
    caption = "Graph created by @econmaett with data from FRED.",
    x = "", y = ""
  ) +
  theme(plot.subtitle = element_markdown(), legend.position = "none")

ggsave(filename = "Macro_Snapshot/OtherRealIndicators/NewPrivateHousingConstruction.png", width = 8, height = 4)
graphics.off()


### Housing Prices ----
# All-Trnasactions House Price Index for the United States: USSTHPI
# S&P/Case-Shiller U.S. National Home Price Index: CSUSHPISA
# Interest Rates and Price Indexes; 
# Owner-Occupied Real Estate Zillow ZHVI Index, Level: BOGZ1FL075035253Q
params <- list(
  series_id = c("USSTHPI", "CSUSHPISA", "BOGZ1FL075035253Q"),
  units = c("pc1", "pc1", "pc1")
)
df <- purrr::pmap_dfr(.l = params, .f = ~fredr(series_id = .x, units = .y))
df |> 
  select(date, series_id, value) |> 
  ggplot() +
  geom_line(mapping = aes(x = date, y = value, color = series_id), linewidth = 1) +
  geom_hline(yintercept = 0, linetype = "dashed", color = "black", show.legend = NULL) +
  geom_rect(data = usrecdp, aes(xmin = Peak, xmax = Trough, ymin = -Inf, ymax = +Inf), fill = "grey", alpha = 0.2) +
  scale_x_date(limits = c(date(start_date), NA), date_breaks = "1 year", date_labels = "%Y") +  scale_y_continuous(limits = c(0, 150), breaks = seq(0, 150, 25)) +
  scale_y_continuous(limits = c(-10, 30), breaks = seq(-10, 30, 10)) +
  scale_color_manual(
    values = c("#ac004f", "#374e8e", "#478c5b"),
    breaks = c("CSUSHPISA", "USSTHPI", "BOGZ1FL075035253Q")) +
  theme_bw() +
  labs(
    title = "Housing Prices year-over-year % change",
    subtitle = "<span style = 'color: #374e8e;'>FHFA house price index</span>, <span style = 'color: #ac004f;'>S&P/Case-Shiller national home price index</span> and <span style = 'color: #478c5b;'>Zillow home value index</span>",
    caption = "Graph created by @econmaett with data from FRED.",
    x = "", y = ""
  ) +
  theme(plot.subtitle = element_markdown(), legend.position = "none")

ggsave(filename = "Macro_Snapshot/OtherRealIndicators/HousingPrices.png", width = 8, height = 4)
graphics.off()


### Weekly Economic Index (Lewis-Mertens-Stock) ----
# Website: https://www.newyorkfed.org/research/policy/weekly-economic-index#/
wei <- fredr(series_id = "WEI")
wei |> 
  select(date, value) |> 
  filter(date >= start_date) |> 
  ggplot() +
  geom_line(mapping = aes(x = date, y = value), color = "#374e8e", linewidth = 1) +
  geom_hline(yintercept = 0, linetype = "dashed", color = "black") +
  geom_rect(data = usrecdp, aes(xmin = Peak, xmax = Trough, ymin = -Inf, ymax = +Inf), fill = "grey", alpha = 0.2) +
  scale_x_date(limits = c(date(start_date), NA), date_breaks = "1 year", date_labels = "%Y") +  scale_y_continuous(limits = c(0, 150), breaks = seq(0, 150, 25)) +
  scale_y_continuous(limits = c(-10, 15)) +
  theme_bw() +
  labs(
    title = "Weekly Economic Index (Lewis-Mertens-Stock)",
    subtitle = "Index",
    caption = "Graph created by @econmaett with data from FRED.",
    x = "", y = ""
  )

ggsave(filename = "Macro_Snapshot/OtherRealIndicators/WEI.png", width = 8, height = 4)
graphics.off()

# END