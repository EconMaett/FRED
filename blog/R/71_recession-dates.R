# 71 - Discrepancies in dating recessions ----
# URL: https://fredblog.stlouisfed.org/2021/08/discrepancies-in-dating-recessions/
library(tidyverse)
library(fredr)
library(zoo)
fig_path <- "blog/figures/"
# How the COVID-19 recession lasted only two months but spanned
# two quarters.

# There is no hard and fast rule to determine when the U.S. economy has
# entered a recession, and there is no one indicator that determines a recession.

# Most recently, the NBER's recession dating committee identified
# February 2020 as the latest business cycle peak and April 2020 as the trough.
# This is the shortest recession in US history - 
# just 2 to 3 months.

# The committee also releases the corresponding *quarters* of the peak and trough.
# These turning points are primarily based on quarterly averages of the monthly indicators,
# along with prominent quarterly series such as real GDP.

# In most instances, the turning point quarters match the turning point months.

# In fact, the months and quarters *had* all been in alignment since March (Q1) 1954.

# But for the COVID-19 recession, the months and quarters of the business cycle turning points do not align.


# The FRED team applies recession shading starting with the month of the peak and ending with the month prior to the trough.
# This method has most accurately aligned with the turning points in economic data
# because of the consistency between NBER turning point months and quarters.

# https://fred.stlouisfed.org/graph/?g=FYxH

# - USRECM. Monthly: NBER based recession indicators for the US from the Peak through the Trough.
# - USRECQM. Quarterly: NBER based recession indicators for the US from the Peak through the Trough.


## 1) Plot the monthly and quarterly NBER recession dates ----
params <- list(
  series_id = c("USRECM", "USRECQM"),
  frequency = c("m", "q")
)

df <- pmap_df(.l = params, .f = ~ fredr(series_id = .x, frequency = .y)) |> 
  select(1:3) |> 
  filter(year(date) >= 2019 & year(date) < 2021)

df |> 
  mutate(
    series_id = case_when(
      series_id == "USRECM" ~ "Monthly",
      series_id == "USRECQM" ~ "Quarterly"
    ),
    series_id = factor(series_id)
  ) |> 
  ggplot(mapping = aes(x = date, y = value, color = series_id)) +
  geom_step(lwd = 1.2) +
  scale_color_manual(values = c("darkblue", "firebrick")) +
  labs(
    title = "NBER based Recession Indicators for the United States",
    subtitle = "From the Peak through the Trough", 
    caption = "Source: Federal Reserve Bank of St. Louis",
    x = NULL, y = NULL
  ) +
  scale_y_continuous(breaks = c(0, 1)) +
  scale_x_date(date_breaks = "1 month", date_labels = "%Y-%m") +
  theme_minimal() +
  theme(
    legend.title = element_blank(),
    legend.position = "top",
    legend.text = element_text(size = 12),
    legend.direction = "horizontal"
  )

ggsave(filename = "71_recession-dates.png", path = fig_path, height = 8, width = 12, bg = "white")
graphics.off()


## 2) Plot the monthly and quarterly employment level ----
# Change in thousands of persons
# CE16OV
df_m <- fredr(series_id = "CE16OV", frequency = "m", units = "chg") |> 
  select(1:3) |> 
  filter(year(date) >= 2019 & year(date) <= 2021)|> 
  mutate(series_id = "CE16OV_m")

df_m


df_q <- fredr(series_id = "CE16OV", frequency = "q", units = "chg") |> 
  select(1:3) |> 
  filter(year(date) >= 2019 & year(date) <= 2021)|> 
  mutate(series_id = "CE16OV_q")

df_q

bind_rows(df_m, df_q) |> 
  mutate(
    series_id = case_when(
      series_id == "CE16OV_m" ~ "Monthly",
      series_id == "CE16OV_q" ~ "Quarterly"
    ),
    series_id = factor(series_id)
  ) |> 
  ggplot(mapping = aes(x = date, y = value, color = series_id)) +
  geom_hline(yintercept = 0, lwd = 1, color = "black") +
  geom_line(lwd = 1.2) +
  scale_color_manual(values = c("darkblue", "firebrick")) +
  labs(
    title = "United States: Employment Level",
    subtitle = "Change, Thousands of Persons",
    caption = "Source: U.S. Bureau of Labor Statistics",
    x = NULL, y = NULL
  ) +
  scale_y_continuous(breaks = seq(from = -24000, to = 12000, by = 4000), limits = c(-24000, 12000)) +
  scale_x_date(date_breaks = "3 months", date_labels = "%Y-%m", limits = c(date("2019-01-01"), date("2021-07-30"))) +
  theme_minimal() +
  theme(
    legend.title = element_blank(),
    legend.position = "top",
    legend.text = element_text(size = 12),
    legend.direction = "horizontal"
  )

ggsave(filename = "71_employment-levels.png", path = fig_path, height = 8, width = 12, bg = "white")
graphics.off()

# END