# ************************************************************************
# St. Louis Fed Economic News Index (ENI) ----
# ************************************************************************
# URL: https://research.stlouisfed.org/publications/review/2016/12/05/a-macroeconomic-news-index-for-constructing-nowcasts-of-u-s-real-gross-domestic-product-growth/
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

## Access the data ----
params <- list(
  series_id = c("GDPC1", "STLENI"),
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
    breaks = c("GDPC1", "STLENI")
  ) +
  theme_bw() +
  labs(
    title = "<span style = 'color: #374e8e;'>Real GDP</span> and <span style = 'color: #478c5b;'>St. Louis Fed Economic News Index</span>",
    subtitle = "Seasonally-adjusted annual rate",
    caption = "Graph created by @econmaett with data from FRED.",
    x = "", y = ""
  ) +
  theme(plot.title = element_markdown(), legend.position = "none")

ggsave(filename = "Nowcasts/StLouisFedEconomicNews/StLouisFedEconNews.png", width = 8, height = 4)
graphics.off()

# END