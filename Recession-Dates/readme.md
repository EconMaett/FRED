# Recession dates

This repository contains files to access business cycle indicators and reference dates from various sources. 

- United States: The [National Bureau of Economic Research (NBER)](https://www.nber.org/)'s [Business Cycle Dating Committee](https://www.nber.org/research/data/us-business-cycle-expansions-and-contractions)

- Europe: The [Centre for Economic Policy Research (CEPR)](https://cepr.org/)'s [Euro Area Business Cycle Network (EABCN)'s Business Cycle Dating Committee](https://eabcn.org/)

- OECD: The [Organisation for Economic Co-operation and Development (OECD)](https://www.oecd.org/)'s [Composite Leading Indicators (CLI) Reference Turning Points and Component Series](https://www.oecd.org/sdd/leading-indicators/oecdcompositeleadingindicatorsreferenceturningpointsandcomponentseries.htm)

- United Kingdom: The [National Institute of Economic and Social Research (NIESR)](https://www.niesr.ac.uk/)'s [UK Business Cycle Dating and Implications](https://www.niesr.ac.uk/publications/uk-business-cycle-dating-and-implications?type=letters-written-submissions)

- France: The [French Economic Association (AFSE)](https://www.afse.fr/en/)'s [French Business Cycle Dating Committe](https://www.afse.fr/fr/cycles-eco/english-version-500228)

- Japan: The [Government of Japan Cabinet Office](https://www.cao.go.jp/index-e.html)'s[ Economic and Social Research Institute (ESRI)](https://www.esri.cao.go.jp/index-e.html)'s [Index of Business Conditions](https://www.esri.cao.go.jp/en/stat/di/di-e.html)

- Canada: The [C. D. Howe Institute](https://www.cdhowe.org/)'s [Business Cycle Council](https://www.cdhowe.org/council/business-cycle-council)

- Spain: The [Spanish Economic Association (AEE)](http://asesec.org/en/)[ Business Cycle Dating Committee](http://www.asesec.org/CFCweb/index.php/en/)

- International: [The Conference Board](https://www.conference-board.org/us/)'s [Leading Economic Indicators (LEI)](https://data-central.conference-board.org/)

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
Recession from the **midpoint of the peak** through the **midpoint of the trough**. The entire peak and trough periods are included in the recession shading. This method shows the **maximum number of periods as a recession** for monthly and quarterly data.

#### Daily data: 
Recession starts on the **15th of the month of the peak** and ends on the **15th of the month of the trough**. The **Federal Reserve Bank of St. Louis** uses this method in its own **publications**.


### 2. Trough method
Recession from the period following the peak through the trough, i.e. **the peak is not included in the recession shading, but the trough is**.

#### Daily data:
Recession **begins on the 1st day of the 1st month following the peak** and **ends on the last day of the month of the trough**. The trough method is used when displaying data on **FRED graphs**.


### 3. Peak method
Recession from the period of the peak to the trough, i.e. **the peak is included in the recession shading, but the trough is not**.

#### Daily data: 
Recession begins on the 1st day of the month of the peak and **ends on the last day of the month preceding the trough**.


## OECD vs NBER recession dates

The OECD CLI system is based on the "growth cycle" approach, where business cycles and turning points are measured and identified in the deviation-from-trend series.

The main reference series used in the OECD CLI system for the majority of countries is industrial production (IIP) covering all industry sectors excluding construction.

**Up to December 2008** the turning points chronologies shown are determined by the rules established by the National Bureau of Economic Research (NBER) in the United States, which have been formalized and incorporated in a **computer routine (Bry and Boschan)** and included in the **Phase-Average Trend (PAT) de-trending procedure**.

Starting from December 2008 the turning point detection algorithm is decoupled from the de-trending procedure, and is a simplified version of the original Bry and Boschan routine. (The routine parses local minima and maxima in the cycle series and applies censor rules to guarantee alternating peaks and troughs, as well as phase and cycle length constraints.)

The components of the CLI are time series which exhibit leading relationship with the reference series (IIP) at turning points. Country CLIs are compiled by combining de-trended smoothed and normalized components.

Note that as of January 2023, the OECD has discontinued the CLIs for various small countries. I therefore follow the convention of: 

- Using NBER recession dates for the United States when referring to the U.S. alone.
- Using OECD recession dates when comparing multiple countries internationally (e.g. BRICS)
- Using CEPR recession dates when referring to economies in the Euro Area or neighboring countries whose business cycle follows that of the EA closely (e.g. Switzerland).
