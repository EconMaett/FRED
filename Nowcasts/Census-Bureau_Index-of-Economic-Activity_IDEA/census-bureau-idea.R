# ************************************************************************
# U.S. Census Bureau Index of Economic Activity (IDEA) ----
# ************************************************************************
# URL: https://www.census.gov/economic-indicators/
# Feel free to copy, adapt, and use this code for your own purposes.
# Matthias Spichiger (matthias.spichiger@bluewin.ch)
# ************************************************************************

## Load packages ----
library(fredr)
library(tidyverse)
library(scales)
library(ggtext)

start_date <- "2005-01-01"
usrecdp <- read_csv(file = "Recession-Dates/NBER/Recession-Dates_NBER_US_Daily_Midpoint.csv")

## Access the data ----

### Real GDP ---
gdpc1 <- fredr(series_id = "GDPC1", units = "pc1") |> 
  select(date, series_id, value)

gdpc1std <- gdpc1
gdpc1std$series_id <- "GDPC1std"
gdpc1std$value <- (gdpc1$value - mean(gdpc1$value, na.rm = TRUE)) / sd(gdpc1$value, na.rm = TRUE)

### Get the correct URLs ----
last_update <- gsub(pattern = "-", replacement = "", x = today() - wday(Sys.Date() + 1))
input_url   <- paste0("https://www.census.gov/econ_index/archive_data/Indicator_Input_Values_", last_update, ".csv")

weights_url <- "https://www.census.gov/econ_index/Weights.csv"

### Input series ----
input <- read_csv(file = input_url) # 15 input series

input <- input |> 
  mutate(date = date(paste0(Year, "-", Month, "-01"))) |> 
  select(-Year, -Month) |> 
  pivot_longer(cols = BusinessApplications:WholesaleInventories, names_to = "series_id", values_to = "value")

weights <- read_csv(file = weights_url) # 9 PCA weights for the 15 input series

### U.S. Census Bureau Index of Economic Activity (IDEA) ----
index_url <- "https://www.census.gov/econ_index/Index_Values_2023.csv"
index <- read_csv(file = index_url)
names(index) # Last vintage is the rightmost column

# Create date column
index <- index |> 
  select(Year, Month, length(names(index))) |> 
  mutate(date = date(paste0(Year, "-", Month, "-01"))) |> 
  select(-Year, -Month)

# Rename the columns and reorder them
names(index) <- c("value", "date")
index <- index |> 
  select(date, value)

index$series_id <- "IDEA"

## Plot the data ----

## Plot the IDEA index ----
index |> 
  ggplot() +
  geom_hline(yintercept = 0, linetype = "solid", color = "black", show.legend = NULL) +
  geom_line(mapping = aes(x = date, y = value), linewidth = 1, color = "#374e8e") +
  geom_rect(data = usrecdp, aes(xmin = recession_start, xmax = recession_end, ymin = -Inf, ymax = +Inf), fill = "darkgrey", alpha = 0.3) +
  scale_x_date(expand = c(0, 0), limits = c(date(start_date), today()), date_breaks = "1 year", date_labels = "%Y") +
  scale_y_continuous(expand = c(0, 0), limits = c(-12, 4), breaks = seq(-12, 4, 2)) +
  theme_bw() +
  labs(
    title = "U.S. Census Bureau Index of Economic Activity (IDEA)",
    subtitle = "Year-on-year growth rates (in %)",
    caption = "Graph created by @econmaett with data from FRED.",
    x = "", y = ""
  ) +
  theme(plot.title = element_markdown(), legend.position = "none")

ggsave(filename = "Nowcasts/Census-Bureau_Index-of-Economic-Activity_IDEA/Fig_Census-Bureau-IDEA.png", width = 8, height = 4)
graphics.off()

### Plot Standardized Real GDP and IDEA ----
rbind(gdpc1std, index) |> 
  ggplot() +
  geom_hline(yintercept = 0, linetype = "solid", color = "black", show.legend = NULL) +
  geom_line(mapping = aes(x = date, y = value, color = series_id), linewidth = 1) +
  geom_rect(data = usrecdp, aes(xmin = recession_start, xmax = recession_end, ymin = -Inf, ymax = +Inf), fill = "darkgrey", alpha = 0.3) +
  scale_x_date(expand = c(0, 0), limits = c(date(start_date), today()), date_breaks = "1 year", date_labels = "%Y") +
  scale_y_continuous(expand = c(0, 0), limits = c(-12, 4), breaks = seq(-12, 4, 2)) +
  scale_color_manual(
    values = c("#374e8e", "#478c5b"), 
    breaks = c("IDEA", "GDPC1std")
  ) +
  theme_bw() +
  labs(
    title = "<span style = 'color: #374e8e;'>U.S. Census Bureau Index of Economic Activity (IDEA)</span> and <span style = 'color: #478c5b;'>Standardized Real GDP</span>",
    subtitle = "Year-on-year growth rates (in %)",
    caption = "Graph created by @econmaett with data from FRED.",
    x = "", y = ""
  ) +
  theme(plot.title = element_markdown(), legend.position = "none")

ggsave(filename = "Nowcasts/Census-Bureau_Index-of-Economic-Activity_IDEA/Fig_Census-Bureau-IDEA-vs-real-GDP.png", width = 8, height = 4)
graphics.off()

# END