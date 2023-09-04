function saSeries = sa(nsaSeries)
% Seasonally adjust a series using the X13ARIMA-SEATS package.
%
% saSeries = sa(nsaSeries) seasonally adjusts nsaSeries. 

% David Kelley, 2017

saSeries = nsaSeries;

for iS = 1:size(saSeries, 2)
  usePeriods = ~isnan(nsaSeries{:,iS});
  dates = cbd.private.tableDates(nsaSeries(usePeriods, iS));

  xOut = cbd.private.sax13.x13([dates nsaSeries{usePeriods, iS}], 'quiet', '-n');  
  saSeries{usePeriods,iS} = xOut.d11.d11;
end