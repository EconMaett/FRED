# ************************************************************************
# Atlanta Fed GDPNow ----
# ************************************************************************
# URL: https://www.atlantafed.org/cqer/research/gdpnow.aspx?panel=1
# Feel free to copy, adapt, and use this code for your own purposes.
# Matthias Spichiger (matthias.spichiger@bluewin.ch)
# ************************************************************************

## Load packages ----
library(fredr)
library(tidyverse)
library(scales)
library(ggtext)

start_date <- "2015-01-01"
usrecdp <- read_csv(file = "Recession-Dates/NBER/Recession-Dates_NBER_US_Daily_Midpoint.csv")

## Access the data ----
params <- list(
  series_id = c("GDPC1", "GDPNOW"),
  units = c("pca", "lin")
)
df <- purrr::pmap_dfr(.l = params, .f = ~fredr(series_id = .x, units = .y))

## Plot the data ----
df |> 
  select(date, series_id, value) |> 
  ggplot() +
  geom_hline(yintercept = 0, linetype = "solid", color = "black", show.legend = NULL) +
  geom_line(mapping = aes(x = date, y = value, color = series_id), linewidth = 1) +
  geom_rect(data = usrecdp, aes(xmin = recession_start, xmax = recession_end, ymin = -Inf, ymax = +Inf), fill = "darkgrey", alpha = 0.3) +
  scale_x_date(limits = c(date(start_date), today()), date_breaks = "1 year", date_labels = "%Y") +
  scale_y_continuous(limits = c(-40, 40), breaks = seq(-40, 40, 10)) +
  scale_color_manual(
    values = c("#374e8e", "#478c5b"), 
    breaks = c("GDPC1", "GDPNOW")
    ) +
  theme_bw() +
  labs(
    title = "<span style = 'color: #374e8e;'>Real GDP</span> and <span style = 'color: #478c5b;'>Atlanta Fed GDPNow</span>",
    subtitle = "Seasonally-adjusted annual rate",
    caption = "Graph created by @econmaett with data from FRED.",
    x = "", y = ""
  ) +
  theme(plot.title = element_markdown(), legend.position = "none")

ggsave(filename = "Nowcasts/Atlanta-Fed-GDPNow/Fig_Atlanta-Fed-GDPNow.png", width = 8, height = 4)
graphics.off()

# Contributions to percent change in GDPNow: : 
# - FINSALESCONTRIBNOW: Real Final Sales of Domestic Product 
# - PCECONTRIBNOW: Real Personal Consumption Expenditures 
#   - PCEGOODSCONTRIBNOW: Real Personal Consumption Expenditures: Goods 
#   - PCESERVICESCONTRIBNOW: Real Personal Consumption Expenditures: Services 
# - GDPICONTRIBNOW: Real Gross Private Domestic Investment 
#   - FIXINVESTCONTRIBNOW: Real Gross Private Domestic Investment: Fixed Investment 
#     - RESCONTRIBNOW: Real Gross Private Domestic Investment: Fixed Investment: Residential  
#   - BUSFIXINVESTCONTRIBNOW: Real Gross Private Domestic Investment: Fixed Investment: Business 
#     - EQUIPCONTRIBNOW: Real Gross Private Domestic Investment: Fixed Investment: Business: Equipment 
#     - STRUCTCONTRIBNOW: Real Gross Private Domestic Investment: Fixed Investment: Business: Structures 
#     - IPPCONTRIBNOW: Real Gross Private Domestic Investment: Fixed Investment: Business: Intellectual Property Products 
# - GOVCONTRIBNOW: Real Gross Government Investment 
#   - FEDGOVCONTRIBNOW: Real Gross Government Investment: Federal Government 
#   - SLGOVCONTRIBNOW: Real Gross Government Investment: State and Local Government
# - CHNGNETEXPORTSCONTRIBNOW: Real Change of Net Exports of Goods and Services 
#   - EXPORTSCONTRIBNOW: Real Exports of Goods and Services 
#     - EXPORTSGOODSCONTRIBNOW: Real Exports of Goods 
#     - EXPORTSSERVICESCONTRIBNOW: Real Exports of Services 
#   - IMPORTSCONTRIBNOW: Real Imports of Goods and Services 
#     - IMPORTSGOODSCONTRIBNOW: Real Imports of Goods
#     - IMPORTSERVICESCONTRIBNOW: Real Imports of Services
# - CHNGNETINVENTCONTRIBNOW: Real Change of Inventory Investment 

# END