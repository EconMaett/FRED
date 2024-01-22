# ************************************************************************
# Philadelphia Fed State Coincident Indexes ----
# ************************************************************************
# URL: https://www.philadelphiafed.org/surveys-and-data/regional-economic-analysis/state-coincident-indexes
# Feel free to copy, adapt, and use this code for your own purposes.
# ************************************************************************

## Load packages ----
library(fredr)
library(tidyverse)
library(scales)
library(ggtext)

start_date <- "2005-01-01"
usrecdp <- read_csv(file = "Recession-Dates/US_NBER/Recession-Dates_NBER_US_Daily_Midpoint.csv")

## Access the data ----
params <- list(
  series_id = c("GDPC1", "USPHCI"),
  units = c("pc1", "pc1")
)
df <- purrr::pmap_dfr(.l = params, .f = ~fredr(series_id = .x, units = .y))

## Plot the data ----
df |> 
  select(date, series_id, value) |> 
  ggplot() +
  geom_line(mapping = aes(x = date, y = value, color = series_id), linewidth = 1) +
  geom_hline(yintercept = 0, linetype = "solid", color = "black", show.legend = NULL) +
  geom_rect(data = usrecdp, aes(xmin = recession_start, xmax = recession_end, ymin = -Inf, ymax = +Inf), fill = "darkgrey", alpha = 0.3) +
  scale_x_date(expand = c(0, 0), limits = c(date(start_date), today()), date_breaks = "1 year", date_labels = "%Y") +
  scale_y_continuous(expand = c(0, 0), limits = c(-10, 15), breaks = seq(-10, 15, 5)) +
  scale_color_manual(
    values = c("#374e8e", "#478c5b"), 
    breaks = c("GDPC1", "USPHCI")
  ) +
  theme_bw() +
  labs(
    title = "<span style = 'color: #374e8e;'>Real GDP</span> and <span style = 'color: #478c5b;'>Coincident Economic Activity Index for the U.S.</span>",
    subtitle = "Year-over-year growth rate (in %)",
    caption = "Graph created by @econmaett with data from FRED.",
    x = "", y = ""
  ) +
  theme(plot.title = element_markdown(), legend.position = "none")

ggsave(filename = "Nowcasts/Philadelphia-Fed-State-Coincident-Indexes/Fig_Philadelphia-Fed-National-Coincident-Index.png", width = 8, height = 4)
graphics.off()

# END