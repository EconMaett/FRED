# ************************************************************************
# Smoothed US Recession Probabilities ----
# ************************************************************************
# URL: https://jeremypiger.com/recession_probs/
# Feel free to copy, adapt, and use this code for your own purposes.
# Matthias Spichiger (matthias.spichiger@bluewin.ch)
# ************************************************************************

## Load packages ----
library(fredr)
library(tidyverse)
library(scales)
library(ggtext)

start_date <- "2000-01-01"
usrecdp <- read_csv(file = "Recession_Dates/NBER/US_NBER_Midpoint_Daily_Recession_Dates.csv")

## Load the data ----

recprousm156n <- fredr(series_id = "RECPROUSM156N") |> 
  select(date, value) |> 
  mutate(value = value / 100)

## Plot the data ----
recprousm156n |> 
  ggplot() +
  geom_hline(yintercept = 0, linetype = "solid", color = "black", show.legend = NULL) +
  geom_hline(yintercept = 0.5, linetype = "solid", color = "darkgrey", show.legend = NULL) +
  geom_hline(yintercept = 1, linetype = "solid", color = "black", show.legend = NULL) +
  geom_line(mapping = aes(x = date, y = value), linewidth = 1, color = "#374e8e") +
  geom_rect(data = usrecdp, aes(xmin = recession_start, xmax = recession_end, ymin = -Inf, ymax = +Inf), fill = "darkgrey", alpha = 0.3) +
  scale_x_date(limits = c(date(start_date), today()), date_breaks = "1 year", date_labels = "%y") +
  scale_y_continuous(limits = c(0, 1), breaks = seq(0, 1, 0.25)) +
  theme_bw() +
  labs(
    title = "Smoothed US Recession Probabilities",
    subtitle = "Derived from four monthly indicators",
    caption = "Graph created by @econmaett with data from FRED.",
    x = "", y = ""
  )

ggsave(filename = "Recession_Dates/RecessionProbabilities/RecessionProb.png", width = 8, height = 4)
graphics.off()

# END