function [series, fullSeries] = loadData_series(series, startDate, endDate)
% Load dataseries from Haver for later use

% David Kelley, 2016

sd = {'startDate', startDate};
if ~isempty(endDate)
  dateRange = [sd {'endDate', endDate}];
else
  dateRange = sd;
end

trimExtend = @(x) cbd.extend(cbd.trim(x, dateRange{:}), dateRange{:});

% Haver series
GDPHfull = cbd.data('DISAGG(DIFAL(GDPH), "M", "NAN")');
GDPH = trimExtend(GDPHfull);
series.GDPH = GDPH{:,1};

% Recessions 
recessions = trimExtend(cbd.data('RECESSM2'));
series.recessions = recessions{:,1};

% Inflation series
dates = datenum(recessions.Properties.RowNames);

series.inflation = zeros(size(series.recessions,1),1);
series.inflation(dates>=datenum('6/1/1966') & dates<=datenum('10/31/1971'),1) = 1;
series.inflation(dates>=datenum('5/1/1973') & dates<=datenum('5/31/1975'),1) = 1;
series.inflation(dates>=datenum('6/1/1977') & dates<=datenum('6/30/1981'),1) = 1;
series.inflation(dates>=datenum('12/1/1987') & dates<=datenum('7/31/1991'),1) = 1;
series.inflation(dates>=datenum('10/1/2004') & dates<=datenum('11/30/2008'),1) = 1;


fullSeries = struct('GDPHfull', GDPHfull);