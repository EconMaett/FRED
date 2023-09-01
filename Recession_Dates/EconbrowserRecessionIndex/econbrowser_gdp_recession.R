# ************************************************************************
# Econbrowser GDP-based recession indicator ----
# ************************************************************************
# URL: https://fredhelp.stlouisfed.org/fred/data/understanding-the-data/recession-bars/
# Feel free to copy, adapt, and use this code for your own purposes at
# your own risk.
#
# Matthias Spichiger (matthias.spichiger@bluewin.ch)
# ************************************************************************

## Load packages ----
library(fredr)
library(tidyverse)
library(rvest)

### Recession Dates implied by GDP-based indicator ----
# JHDUSRGDPBR: (Quarterly) Dates of U.S. recessions as inferred by GDP-based recession indicator
# The series assigns dates to U.S. recessions based on a mathematical model of the way that recessions differ from expansions. Whereas the NBER business cycle dates are based on a subjective assessment of a variety of indicators, the dates here are entirely mechanical and are calculated solely from historically reported GDP data. Whenever the GDP-based recession indicator index rises above 67%, the economy is determined to be in a recession. The date that the recession is determined to have begun is the first quarter prior to that date for which the inference from the mathematical model using all data available at that date would have been above 50%. The next time the GDP-based recession indicator index falls below 33%, the recession is determined to be over, and the last quarter of the recession is the first quarter for which the inference from the mathematical model using all available data at that date would have been below 50%.

# For more information about this series visit http://econbrowser.com/recession-index.

# JHGDPBRINDX: (Quarterly) GDP-Based Recession Indicator Index
# This index measures the probability that the U.S. economy was in a recession during the 
# indicated quarter. 
# It is based on a mathematical description of the way that recessions differ from expansions. 
# The index corresponds to the probability (measured in percent) that the underlying true economic regime 
# is one of recession based on the available data. 
# Whereas the NBER business cycle dates are based on a subjective assessment of a variety of indicators 
# that may not be released until several years after the event, this index is entirely mechanical, 
# is based solely on currently available GDP data and is reported every quarter. 

# Due to the possibility of data revisions and the challenges in accurately identifying the business 
# cycle phase, the index is calculated for the quarter just preceding the most recently available 
# GDP numbers. 
# Once the index is calculated for that quarter, it is never subsequently revised. 
# The value at every date was inferred using only data that were available one quarter after 
# that date and as those data were reported at the time.

# If the value of the index rises above 67% that is a historically reliable indicator that the economy has entered a recession. Once this threshold has been passed, if it falls below 33% that is a reliable indicator that the recession is over.

# For more information about this series visit http://econbrowser.com/recession-index.