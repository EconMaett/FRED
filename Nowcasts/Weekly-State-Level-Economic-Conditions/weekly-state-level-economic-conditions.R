# ************************************************************************
# Baumeister, Leiva-León, and Sims - Weekly State-Level Economic Conditions ----
# ************************************************************************
# URL: https://sites.google.com/view/weeklystateindexes/dashboard
# Feel free to copy, adapt, and use this code for your own purposes.
# ************************************************************************

## Load packages ----
library(fredr)
library(tidyverse)
library(scales)
library(ggtext)
library(googledrive)


start_date <- "2000-01-01"
usrecdp <- read_csv(file = "Recession-Dates/US_NBER/Recession-Dates_NBER_US_Daily_Midpoint.csv")

## Access the data ----

### Real GDP ---
gdpc1 <- fredr(series_id = "GDPC1", units = "pc1") |> 
  select(date, series_id, value)

gdpc1std <- gdpc1
gdpc1std$series_id <- "GDPC1std"
# Here, we only subtract the long-run mean from the series
gdpc1std$value <- gdpc1$value - mean(gdpc1$value, na.rm = TRUE)

### Weekly State-Level Economic Conditions ----
wsleci_url <- "https://drive.google.com/uc?export=download&id=123jYAWm30IYq9PCoqUaEGyBcr4sKqB7l"

file_path <- "Nowcasts/Weekly-State-Level-Economic-Conditions/Weekly-State-Level-Economic-Conditions.xlsx"
dl <- drive_download(file = as_id("123jYAWm30IYq9PCoqUaEGyBcr4sKqB7l"), path = file_path, overwrite = TRUE)

# There are two sheets: "states" and "national"
wsleci_n <- readxl::read_excel(path = dl$local_path, sheet = "national") |> 
  mutate(
    date = date(`Week ending`), 
    value = `US Economic Conditions Indicator`,
    series_id = "USECI"
    ) |> 
  select(date, series_id, value)


## Plot the data ----
rbind(gdpc1std, wsleci_n) |> 
  ggplot() +
  geom_hline(yintercept = 0, linetype = "solid", color = "black", show.legend = NULL) +
  geom_line(mapping = aes(x = date, y = value, color = series_id), linewidth = 1) +
  geom_rect(data = usrecdp, aes(xmin = recession_start, xmax = recession_end, ymin = -Inf, ymax = +Inf), fill = "darkgrey", alpha = 0.3) +
  scale_x_date(expand = c(0, 0), limits = c(date(start_date), today()), date_breaks = "1 year", date_labels = "%Y") +
  scale_y_continuous(expand = c(0, 0), limits = c(-15, 15)) +
  scale_color_manual(
    values = c("#374e8e", "#383751"),
    breaks = c("USECI", "GDPC1std")
  ) +
  theme_bw() +
  labs(
    title = "<span style = 'color: #374e8e;'>Weekly Economic Conditions Indicator for the U.S.</span> and <span style = 'color:#383751;'>real GDP</span>)",
    subtitle = "Year-on-year growth rates (in %)",
    caption = "Graph created by @econmaett with data from FRED.",
    x = "", y = ""
  ) +
  theme(plot.title = element_markdown(), legend.position = "none")

ggsave(filename = "Nowcasts/Weekly-State-Level-Economic-Conditions/Fig_Weekly-National-Economic-Conditions.png", width = 8, height = 4)
graphics.off()

# END