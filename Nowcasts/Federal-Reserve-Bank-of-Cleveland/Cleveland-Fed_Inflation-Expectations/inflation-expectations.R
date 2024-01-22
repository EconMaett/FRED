# ************************************************************************
# Cleveland Fed Inflation Expectations  ----
# ************************************************************************
# URL: https://www.clevelandfed.org/indicators-and-data/inflation-expectations
# Feel free to copy, adapt, and use this code for your own purposes.
# ************************************************************************

## Load packages ----
library(fredr)
library(tidyverse)
library(scales)
library(ggtext)

start_date <- "2000-01-01"
usrecdp <- read_csv(file = "Recession-Dates/US_NBER/Recession-Dates_NBER_US_Daily_Midpoint.csv")

## Access the data ----
# - N-Year Expected Inflation (EXPINF[1-30]YR)
df <- purrr::map_dfr(.x = paste0("EXPINF", seq(from = 1, to = 30, by = 1), "YR"), .f = ~fredr(series_id = .x))

df |> 
  select(date, series_id, value) |> 
  filter(series_id %in% c("EXPINF1YR", "EXPINF2YR", "EXPINF3YR", "EXPINF5YR", "EXPINF10YR")) |> 
  ggplot() +
  geom_hline(yintercept = 0, linetype = "solid", color = "black", show.legend = NULL) +
  geom_rect(data = usrecdp, aes(xmin = recession_start, xmax = recession_end, ymin = -Inf, ymax = +Inf), fill = "darkgrey", alpha = 0.3) +
  geom_line(mapping = aes(x = date, y = value, color = series_id), linewidth = 1) +
  scale_x_date(expand = c(0, 0), limits = c(date(start_date), today()), date_breaks = "1 year", date_labels = "%Y") +
  scale_y_continuous(expand = c(0, 0), limits = c(-1, 5)) +
  scale_color_manual(
    values = c("#e3b13e", "#df7c18", "#ce4631", "#ac004f", "#ae49a2"), 
    breaks = c("EXPINF1YR", "EXPINF2YR", "EXPINF3YR", "EXPINF5YR", "EXPINF10YR")
    ) +
  theme_bw() +
  labs(
    title = "<span style = 'color: #374e8e;'>Chicago Fed National Activity Index (NAI)</span>, <span style = 'color: #478c5b;'>Production and Income</span>, <span style = 'color: #e3b13e;'>Personal Consumption and Housing</span>, <span style = 'color: #ce4631;'>Sales, Orders and Inventories</span>, <span style = 'color: #ae49a2;'>Employment, Unemployment and Hours</span>",
    subtitle = "Year-on-year growth rates (in %)",
    caption = "Graph created by @econmaett with data from FRED.",
    x = "", y = ""
  ) +
  theme(plot.title = element_markdown(), legend.position = "none")

ggsave(filename = "Nowcasts/Cleveland-Fed_Inflation-Nowcast/Fig_Chicago-Fed-NAI-Sub-Indices.png", width = 8, height = 4)
graphics.off()
  