# ************************************************************************
# Brave-Butters-Kelley Indexes (BBKI) ----
# ************************************************************************
# URL: https://www.ibrc.indiana.edu/bbki/
# Feel free to copy, adapt, and use this code for your own purposes.
# Matthias Spichiger (matthias.spichiger@bluewin.ch)
# ************************************************************************

## Load packages ----
library(fredr)
library(tidyverse)
library(scales)
library(ggtext)

start_date <- "2018-01-01"
usrecdp <- read_csv(file = "Recession-Dates/NBER/Recession-Dates_NBER_US_Daily_Midpoint.csv")

## Access the data ----
### BBK Indexes
params <- list(
  series_id = c("BBKMLEIX", "BBKMCOIX", "BBKMGDP", "BBKMCY", "BBKMCLA", "BBKMCLE", "BBKMTRD"),
  units = c("lin", "lin", "lin", "lin", "lin", "lin", "lin")
)

df <- purrr::pmap_dfr(.l = params, .f = ~fredr(series_id = .x, units = .y)) |> 
  select(date, series_id, value)

### Real GDP ---
gdpc1 <- fredr(series_id = "GDPC1", units = "pca") |> 
  select(date, series_id, value)

## Plot the data ----

### Plot the BBKI-GDP index and real GDP ----
# - Brave-Butters-Kelley Real Gross Domestic Product (BBKMGDP) 
start_date <- "2021-01-01"

rbind(gdpc1, df) |> 
  filter(series_id %in% c("BBKMGDP", "GDPC1")) |> 
  ggplot() +
  geom_hline(yintercept = 0, linetype = "solid", color = "black", show.legend = NULL) +
  geom_line(mapping = aes(x = date, y = value, color = series_id), linewidth = 1) +
  geom_rect(data = usrecdp, aes(xmin = recession_start, xmax = recession_end, ymin = -Inf, ymax = +Inf), fill = "darkgrey", alpha = 0.3) +
  scale_x_date(limits = c(date(start_date), today()), date_breaks = "1 year", date_labels = "%Y") +
  scale_y_continuous(limits = c(-6, 12), breaks = seq(-6, 12, 2)) +
  scale_color_manual(
    values = c("#374e8e", "#383751"),
    breaks = c("BBKMGDP", "GDPC1")
  ) +
  theme_bw() +
  labs(
    title = "Brave-Butters-Kelley Indexes (BBKI)",
    subtitle = "<span style = 'color: #374e8e;'>Monthly GDP estimates</span> and <span style = 'color:#383751;'>real GDP</span>",
    caption = "Graph created by @econmaett with data from FRED.",
    x = "", y = ""
  ) +
  theme(plot.subtitle = element_markdown(), legend.position = "none")

ggsave(filename = "Nowcasts/Brave-Butters-Kelley-Indexes/Fig_Monthly-GDP-Estimates.png", width = 8, height = 4)
graphics.off()

### Plot leading and coincident index ----
# - Brave-Butters-Kelley Leading Index (BBKMLEIX)
# - Brave-Butters-Kelley Coincident Index (BBKMCOIX) 
rbind(gdpc1, df) |> 
  filter(series_id %in% c("BBKMLEIX", "BBKMCOIX", "GDPC1")) |> 
  ggplot() +
  geom_hline(yintercept = 0, linetype = "solid", color = "black", show.legend = NULL) +
  geom_line(mapping = aes(x = date, y = value, color = series_id), linewidth = 1) +
  geom_rect(data = usrecdp, aes(xmin = recession_start, xmax = recession_end, ymin = -Inf, ymax = +Inf), fill = "darkgrey", alpha = 0.3) +
  scale_x_date(limits = c(date(start_date), today()), date_breaks = "1 year", date_labels = "%Y") +
  scale_y_continuous(limits = c(-5, 10), breaks = seq(-5, 10, 5)) +
  scale_color_manual(
    values = c("#374e8e", "#006d64", "#383751"),
    breaks = c("BBKMCOIX", "BBKMLEIX", "GDPC1")
    ) +
  theme_bw() +
  labs(
    title = "Brave-Butters-Kelley Indexes (BBKI)",
    subtitle = "<span style = 'color: #374e8e;'>Coincident Index</span>, <span style = 'color: #006d64;'>Leading Index</span> and <span style = 'color:#383751;'>standardized real GDP</span>",
    caption = "Graph created by @econmaett with data from FRED.",
    x = "", y = ""
  ) +
  theme(plot.subtitle = element_markdown(), legend.position = "none")

ggsave(filename = "Nowcasts/Brave-Butters-Kelley-Indexes/Fig_Coincident-and-Leading-Index.png", width = 8, height = 4)
graphics.off()

### Remaining series: Trend & Cycle Components ----
# - Brave-Butters-Kelley Cycle Component of GDP (BBKMCY) 
# - Brave-Butters-Kelley Trend Component of GDP (BBKMTRD) 

# - Brave-Butters-Kelley Cycle: Lagging Subcomponent of GDP (BBKMCLA) 
# - Brave-Butters-Kelley Cycle: Leading Subcomponent of GDP (BBKMCLE) 

# END