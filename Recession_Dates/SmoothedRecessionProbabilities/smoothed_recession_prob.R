# ************************************************************************
# Smoothed US Recession Probabilities ----
# ************************************************************************
# URL: 
# Feel free to copy, adapt, and use this code for your own purposes at
# your own risk.
#
# Matthias Spichiger (matthias.spichiger@bluewin.ch)
# ************************************************************************

## Load packages ----
library(fredr)
library(tidyverse)
library(rvest)

#  RECPROUSM156N: (Monthly) Smoothed U.S. Recession Probabilities
# Smoothed recession probabilities for the United States are obtained from a dynamic-factor 
# markov-switching model applied to four monthly coincident variables: 
# - non-farm payroll employment
# - the index of industrial production
# - real personal income excluding transfer payments
# - real manufacturing and trade sales
# This model was originally developed in Chauvet, M., "An Economic Characterization of Business Cycle Dynamics with Factor Structure and Regime Switching," International Economic Review, 1998, 39, 969-996.

# For additional details, including an analysis of the performance of this model for dating business cycles in real time, see:
#   Chauvet, M. and J. Piger, "A Comparison of the Real-Time Performance of Business Cycle Dating Methods," Journal of Business and Economic Statistics, 2008, 26, 42-49.

# JHDUSRGDPBR: Dates of U.S. recessions as inferred by GDP-based recession indicator
