# Recession dates

This repository contains files to access recession dates from various institutions, 
including:

- The National Bureau of Economic Research (NBER)'s [Business Cycle Dating Committee](https://www.nber.org/research/data/us-business-cycle-expansions-and-contractions)

- The Centre for Economic Policy Research (CEPR)'s Euro Area Business Cycle Network (EABCN)'s [Business Cycle Dating Committee](https://eabcn.org/)

- Interpretations of the Organisation for Economic Co-operation and Development (OECD)'s [Composite Leading Indicators (CLI) Reference Turning Points and Component Series](https://www.oecd.org/sdd/leading-indicators/oecdcompositeleadingindicatorsreferenceturningpointsandcomponentseries.htm) data

The function to implement recession shading is taken from the post on RPubs by [Scheler, Fabian, 2020](https://rpubs.com/FSl/609471).


## Methodology

A committee tasked with identifying recession dates selects a range of indicators to identify turning points in the business cycle. These indicators are selected based on their: 
- economic significance
- cyclical behavior
- data quality
- timeliness
- availability

Examples of such selections are the [Data Considered for the NBER Turning Points](https://fredaccount.stlouisfed.org/public/dashboard/84408) or the OECD's [Composite Leading Indicators (CLI): Reference Turning Points and Component Series data](http://www.oecd.org/std/leading-indicators/oecdcompositeleadingindicatorsreferenceturningpointsandcomponentseries.htm).

Recession dates are then reported as dummy variables where a value of 1 is a recessionary period, while a value of 0 is an expansionary period. The period between a peak and trough is always shaded as a recession.

There are three methods to specify peaks and troughs in the selection of data.


### 1. Midpoint method

#### Monthly & Quarterly data: 
Recession from the midpoint of the peak through the midpoint of the trough.
The entire peak and trough periods are included in the recession shading.
This method shows the maximum number of periods as a recession for monthly and quarterly data.

#### Daily data: 
Recession starts on the 15th of the month of the peak and ends on the 15th of the month of the trough.

The Federal Reserve Bank of St. Louis uses this method in its own publications.


### 2. Trough method

Recession from the period following the peak through the trough, i.e. the peak is not included in the recession shading, but the trough is.

#### Daily data:
Recession begins on the 1st day of the 1st month following the peak and ends on the last day of the month of the trough.

The trough method is used when displaying data on FRED graphs.


### 3. Peak method

Recession from the period of the peak to the trough, i.e. the peak is included in the recession shading, but the trough is not.

#### Daily data: 
Recession begins on the 1st day of the month of the peak and ends on the last day of the month preceding the trough.


## OECD vs NBER recession dates

The OECD CLI system is based on the "growth cycle" approach, where business cycles and turning points are measured and identified in the deviation-from-trend series.

The main reference series used in the OECD CLI system for the majority of countries is industrial production (IIP) covering all industry sectors excluding construction.

This series is used because of its cyclical sensitivity and monthly availability, while the broad based Gross Domestic Product (GDP) is used to supplement the IIP series for identification of the final reference turning points in the growth cycle.

Up to December 2008 the turning points chronologies shown for regional/zone area aggregates or individual countries are determined by the rules established by the National Bureau of Economic Research (NBER) in the United States, which have been formalized and incorporated in a computer routine (Bry and Boschan) and included in the Phase-Average Trend (PAT) de-trending procedure.

Starting from December 2008 the turning point detection algorithm is decoupled from the de-trending procedure, and is a simplified version of the original Bry and Boschan routine. (The routine parses local minima and maxima in the cycle series and applies censor rules to guarantee alternating peaks and troughs, as well as phase and cycle length constraints.)

The components of the CLI are time series which exhibit leading relationship with the reference series (IIP) at turning points. Country CLIs are compiled by combining de-trended smoothed and normalized components. The component series for each country are selected based on various criteria such as:
