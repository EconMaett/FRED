# ************************************************************************
# OECD Weekly Tracker of Economic Activity ----
# ************************************************************************
# URL: https://www.oecd.org/economy/weekly-tracker-of-gdp-growth/
# Feel free to copy, adapt, and use this code for your own purposes.
# Matthias Spichiger (matthias.spichiger@bluewin.ch)
# ************************************************************************

## Load packages ----
library(fredr)
library(tidyverse)
library(scales)
library(ggtext)

start_date <- "2019-11-01"
usrecdp <- read_csv(file = "Recession-Dates/OECD/Recession-Dates_OECD_CH_Daily_Midpoint.csv")

## Access the data ----
# human and machine readable urls:
tracker_url1 <- "https://webfs.oecd.org/oecd_weekly_tracker/Data/Weekly_Tracker_Excel.xlsx"

tracker_url2 <- "https://webfs.oecd.org/oecd_weekly_tracker/Data/weekly_tracker_level.xlsx"

download.file(url = tracker_url1, destfile = "Nowcasts/OECD-Weekly-Tracker/Weekly-Tracker-Excel.xlsx", method = "curl")
download.file(url = tracker_url2, destfile = "Nowcasts/OECD-Weekly-Tracker/weekly-tracker-level.xlsx", method = "curl")

# Every country is in another sheet of the Excel file
df <- readxl::read_excel(path = "Nowcasts/OECD-Weekly-Tracker/Weekly-Tracker-Excel.xlsx", 
                         sheet = "United States")
df
names(df)

### Plot the yoy tracker ----
df |> 
  mutate(date = date(date)) |> 
  ggplot() +
  geom_hline(yintercept = 0, linetype = "solid", color = "black", show.legend = NULL) +
  geom_ribbon(mapping = aes(x = date, ymin = `Low (yoy)`, ymax = `High (yoy)`), fill = "#8aabfd", alpha = 0.3) +
  geom_line(mapping = aes(x = date, y = `Tracker (yoy)`), linewidth = 1, color = "#374e8e") +
  geom_rect(data = usrecdp, aes(xmin = recession_start, xmax = recession_end, ymin = -Inf, ymax = +Inf), fill = "darkgrey", alpha = 0.3) +
  scale_x_date(limits = c(date(start_date), today()), date_breaks = "1 year", date_labels = "%Y") +
  scale_y_continuous(limits = c(-30, 40), breaks = seq(-30, 40, 10)) +
  theme_bw() +
  labs(
    title = "<span style = 'color: #374e8e;'>OECD Weekly Tracker of Economic Activity</span>",
    subtitle = "Year-on-year growth rate (in %)",
    caption = "Graph created by @econmaett with data from FRED.",
    x = "", y = ""
  ) +
  theme(plot.title = element_markdown(), legend.position = "none")

ggsave(filename = "Nowcasts/OECD-Weekly-Tracker/Fig_OECD-Weekly-Tracker-yoy.png", width = 8, height = 4)
graphics.off()

### Plot y02y ----
df |> 
  mutate(date = date(date)) |> 
  ggplot() +
  geom_hline(yintercept = 0, linetype = "solid", color = "black", show.legend = NULL) +
  geom_ribbon(mapping = aes(x = date, ymin = `Low (yo2y)`, ymax = `High (yo2y)`), fill = "#8aabfd", alpha = 0.3) +
  geom_line(mapping = aes(x = date, y = `Tracker (yo2y)`), linewidth = 1, color = "#374e8e") +
  geom_rect(data = usrecdp, aes(xmin = recession_start, xmax = recession_end, ymin = -Inf, ymax = +Inf), fill = "darkgrey", alpha = 0.3) +
  scale_x_date(limits = c(date(start_date), today()), date_breaks = "1 year", date_labels = "%Y") +
  scale_y_continuous(limits = c(-30, 40), breaks = seq(-30, 40, 10)) +
  theme_bw() +
  labs(
    title = "<span style = 'color: #374e8e;'>OECD Weekly Tracker of Economic Activity</span>",
    subtitle = "level of weekly GDP relative to 2019 Q4",
    caption = "Graph created by @econmaett with data from FRED.",
    x = "", y = ""
  ) +
  theme(plot.title = element_markdown(), legend.position = "none")

ggsave(filename = "Nowcasts/OECD-Weekly-Tracker/Fig_OECD-Weekly-Tracker-yo2y.png", width = 8, height = 4)
graphics.off()

# END