# recession_dates.R ----
# Function to convert recession dummy variables into data frames of recession dates
# The function is kept in base R on purpose.
# Matthias Spichiger (matthias.spichiger@bluewin.ch)
"recession_dates" <- function(series_id, frequency = "q") {
  
  # Load the full time series from FRED. Default frequency is quarterly.
  recession <- fredr(series_id = series_id, frequency = frequency)
  
  # Difference between the recession values
  recession$diff <- recession$value - lag(recession$value, n = 1)
  
  recession <- na.omit(recession)
  
  recession_start <- recession[recession$diff == 1, ]$date
  recession_end   <- recession[recession$diff == (-1), ]$date
  
  # If current recession has not ended, add today's date
  if (length(recession_start) > length(recession_end)) {
    recession_end <- c(recession_end, Sys.Date())
  }
  
  # If the first recession lacks a start date, add the smallest available date
  if (length(recession_end) > length(recession_start)) {
    recession_start <- c(min(recession$date), recession_start)
  }
  
  recession <- as.data.frame(cbind(recession_start, recession_end))
  
  recession$recession_start <- as.Date(as.numeric(recession$recession_start), origin = as.Date("1970-01-01"))
  recession$recession_end   <- as.Date(recession$recession_end, origin = as.Date("1970-01-01"))
  
  # Reorder the data frame so that most recent dates are on top
  id <- order(recession$recession_start, decreasing = TRUE)
  recession <- recession[id, ]
  
  # Return the data frame
  return(recession)
}

# END