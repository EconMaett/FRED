# Recession dates

This repository contains code to access recession dates from various institutions, 
including:

- The National Bureau of Economic Research (NBER)'s [Business Cycle Dating Committee](https://www.nber.org/research/data/us-business-cycle-expansions-and-contractions)

- The Centre for Economic Policy Research (CEPR)'s Euro Area Business Cycle Network (EABCN)'s [Business Cycle Dating Committee](https://eabcn.org/)

- Interpretations of the Organisation for Economic Co-operation and Development (OECD)'s [Composite Leading Indicators (CLI) Reference Turning Points and Component Series](https://www.oecd.org/sdd/leading-indicators/oecdcompositeleadingindicatorsreferenceturningpointsandcomponentseries.htm) data

The function to implement recession shading is taken from the post on RPubs by [Scheler, Fabian, 2020](https://rpubs.com/FSl/609471).

## Methodology

The Organisation of Economic Development (OECD) provides three interpretations of its
Composite Leading Indicators (CLI): Reference Turning Points and Component Series data,
http://www.oecd.org/std/leading-indicators/oecdcompositeleadingindicatorsreferenceturningpointsandcomponentseries.htm.

The OECD identifies months of turning points without designating a date within the month that turning points occurred.
The dummy variable adopts an arbitrary convention that the turning point occurred at a specific date within the month.
A value of 1 is a recessionary period, while a value of 0 is an expansionary period.

The period between a peak and trough is always shaded as a recession.
The peak and trough are collectively extrema.

In situations where a portion of a period is included in the recession,
the whole period is deemed to be included in the recession period.


### 1. Midpoint method
[Country]-REC-DM: From the Peak through the Trough

Monthly & Quarterly data: 
Recession from the midpoint of the peak through
the midpoint of the trough.
the entire peak and trough periods are included in the recession shading.
This method shows the maximum number of periods as 
a recession for monthly and quarterly data.

Daily data: 
Recession starts on the 15th of the month of the peak
Recession starts on the 15th of the month of the trough.

The Federal Reserve Bank of St. Louis uses this method in its own publications.


### 2. Trough method
[Country]-REC-D: From the Period following the Peak through the Trough

Recession from the period following the peak through the trough,
i.e. the peak is not included in the recession shading, but the trough is.

Daily data:
- Recession begins on the 1st day of the 1st month following the peak
- Recession begins on the last day of the month of the trough.

The trough method is used when displaying data on FRED graphs.


### 3. Peak method
[Country]REC-DP: From the Peak through the Period preceding the Trough

Recession from the period of the peak to the trough,
i.e. the peak is included in the recession shading, but the trough is not.

Daily data: 
- Recession begins on the 1st day of the month of the peak
- Recession ends on the last day of the month preceding the trough.


## OECD vs NBER recession dates

The OECD CLI system is based on the "growth cycle" approach, where business cycles and turning points are measured and identified in the deviation-from-trend series.

The main reference series used in the OECD CLI system for the majority of countries is industrial production (IIP) covering all industry sectors excluding construction.

This series is used because of its cyclical sensitivity and monthly availability, while the broad based Gross Domestic Product (GDP) is used to supplement the IIP series for identification of the final reference turning points in the growth cycle.

Up to December 2008 the turning points chronologies shown for regional/zone area aggregates or individual countries are determined by the rules established by the National Bureau of Economic Research (NBER) in the United States, which have been formalized and incorporated in a computer routine (Bry and Boschan) and included in the Phase-Average Trend (PAT) de-trending procedure.

Starting from December 2008 the turning point detection algorithm is decoupled from the de-trending procedure, and is a simplified version of the original Bry and Boschan routine.
(The routine parses local minima and maxima in the cycle series and applies censor rules to guarantee alternating peaks and troughs, as well as phase and cycle length constraints.)

The components of the CLI are time series which exhibit leading relationship with the reference series (IIP) at turning points.
Country CLIs are compiled by combining de-trended smoothed and normalized components. The component series for each country are selected based on various criteria such as:
- economic significance
- cyclical behavior
- data quality
- timeliness
- availability