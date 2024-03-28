# 10 - Daily recession dates in FRED ----
# URL: https://fredblog.stlouisfed.org/2022/06/daily-recession-dates-in-fred/
library(tidyverse)
library(fredr)
fig_path <- "blog/figures/"
# Recessions have beginnings and ends.

# In the U.S., these are determined by the Business Cycle Dating Committee
# of the National Bureau of Economic Research (NBER).

# They announce the months and quarters when overall economic activity has reached a peak 
# and starts to contract and when it reached a trough and starts expanding again.

# The NBER determined the beginning and end of the COVID-19 recession as
# February 2020 and April 2020, respectively.

# The Federal Reserve Bank of St. Louis has created *daily*
# data series to help us better understand the possible choices for
# dating recessions.

# We can create a graph that shows the start and end of the COVID-19 recession
# with three series of recession dates.

# The series have a value of 1 when the economy is in a recession and 0 otherwise.

# The three series report the same total number of days (60 days) during which
# overall economic activity was contracting.


## NBER based Recession Indicators for the United States ----

# - USRECDP: (Blue)   From the Peak through the Period preceding the Trough

# - USRECDM: (Yellow) From the Peak through the Trough

# - USRECD: (Red)     From the Period following the Peak through the Trough



df <- map_dfr(.x = c("USRECDP", "USRECDM", "USRECD"), .f = fredr)

df |> 
  select(1:3) |> 
  mutate(
    series_id = case_when(
      series_id == "USRECDP" ~ "From the Peak through the Period preceding the Trough", 
      series_id == "USRECDM" ~ "From the Peak through the Trough", 
      series_id == "USRECD" ~ "From the Period following the Peak through the Trough"
    ),
    series_id = factor(series_id)
  ) |> 
  filter(year(date) > 2019 & date <= date("2020-06-01")) |> 
  ggplot(mapping = aes(x = date, y = value, color = series_id)) +
  geom_line(lwd = 1.2) +
  scale_color_manual(values = c("blue", "yellow", "red")) +
  labs(
    title = "NBER based Recession Indicators for the United States",
    caption = "Source: Federal Reserve Bank of St. Louis",
    x = NULL, y = NULL
  ) +
  theme_minimal() +
  scale_y_continuous(breaks = c(0, 1)) +
  scale_x_date(date_breaks = "1 month", date_labels = "%Y-%M") +
  theme(
    legend.title = element_blank(),
    legend.position = "top",
    legend.text = element_text(size = 12),
    legend.direction = "vertical"
    )

ggsave(filename = "10_recession-dates.png", path = fig_path, height = 8, width = 12, bg = "white")
graphics.off()

# END