# ************************************************************************
# New York Fed Weekly Economic Index (WEI) ----
# ************************************************************************
# URL: https://www.newyorkfed.org/research/policy/weekly-economic-index#/
# Feel free to copy, adapt, and use this code for your own purposes.
# Matthias Spichiger (matthias.spichiger@bluewin.ch)
# ************************************************************************

## Load packages ----
library(fredr)
library(tidyverse)
library(scales)
library(ggtext)
require(RcppRoll)

start_date <- "2005-01-01"
usrecdp <- read_csv(file = "Recession-Dates/NBER/Recession-Dates_NBER_US_Daily_Midpoint.csv")

## Access the data ----
params <- list(
  series_id = c("GDPC1", "WEI"),
  units = c("pc1", "lin")
)

gdpc1 <- fredr(series_id = "GDPC1", units = "pc1")
wei <- fredr(series_id = "WEI", units = "lin")
wei13week <- wei
wei13week$value <- RcppRoll::roll_mean(wei$value, n = 13, align = "right", fill = NA)
wei13week$series_id <- "WEI13Week"

## Plot the data ----
rbind(gdpc1, wei, wei13week) |> 
  ggplot() +
  geom_hline(yintercept = 0, linetype = "solid", color = "black", show.legend = NULL) +
  geom_line(mapping = aes(x = date, y = value, color = series_id), linewidth = 1) +
  geom_rect(data = usrecdp, aes(xmin = recession_start, xmax = recession_end, ymin = -Inf, ymax = +Inf), fill = "darkgrey", alpha = 0.3) +
  scale_x_date(expand = c(0, 0), limits = c(date(start_date), today()), date_breaks = "1 year", date_labels = "%Y") +
  scale_y_continuous(expand = c(0, 0), limits = c(-10, 15), breaks = seq(-10, 15, 5)) +
  scale_color_manual(
    values = c("#374e8e", "#478c5b", "#df7c18"), 
    breaks = c("GDPC1", "WEI", "WEI13Week")
  ) +
  theme_bw() +
  labs(
    title = "<span style = 'color: #374e8e;'>Real GDP</span>, <span style = 'color: #478c5b;'>NY Fed Weekly Economic Index (WEI)</span> and <span style = 'color: #df7c18;'>13-Week MA</span></span>",
    subtitle = "Year-on-year growth rates (in %)",
    caption = "Graph created by @econmaett with data from FRED.",
    x = "", y = ""
  ) +
  theme(plot.title = element_markdown(), legend.position = "none")

ggsave(filename = "Nowcasts/New-York-Fed-WEI/Fig_New-York-Fed-WEI.png", width = 8, height = 4)
graphics.off()

# END