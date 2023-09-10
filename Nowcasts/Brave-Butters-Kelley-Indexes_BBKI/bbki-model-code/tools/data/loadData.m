function data = loadData(opts)
% Load the data, compute dimensions
%
% This function should be used only for retrieving the most recent dataset.
% Other data functions have been written for trimming data and creating
% realtime datasets.

% David Kelley, 2015-2016

%% Load indicators dataset
[indicators, loadProps, rawData, ~, preARindicators, outADJindicators] = loadDataset(...
  fullfile(opts.paths.data, opts.dataspec), 'DataStart', opts.startDateFactors, ...
  'FillJagged', opts.balanceARs, 'KeepOut', opts.KeepOut, 'OutlierAdj', opts.OutlierAdj, 'OutThresh', opts.OutThresh);

datenums = datenum(indicators.Properties.RowNames);
datestrFmt = 'mm/dd/yyyy';

endDateFactors = datestr(datenum(datenums(end)), datestrFmt);

dateRange = {'startDate', opts.startDate, 'endDate', endDateFactors};
indicators = cbd.extend(indicators, dateRange{:});
preARindicators = cbd.extend(preARindicators, dateRange{:});
outADJindicators = cbd.extend(outADJindicators, dateRange{:});
series = struct;

%% Load other series
[series, fullSeries] = loadData_series(series, opts.startDate, endDateFactors);
data.series = orderfields(series);

%% Merge sets of indicators
data.indicators = indicators{:,:};
data.indicatorsOut = outADJindicators{:,:};
data.indicatorsPreAR = preARindicators{:,:};

data.rawData = cbd.trim(rawData, 'startDate', indicators.Properties.RowNames{1});

% Properties
dates = indicators.Properties.RowNames;
properties.indicatorLabels = indicators.Properties.VariableNames; 
properties.indicatorGroup = loadProps.group';
properties.indicatorRelease = loadProps.release';
properties.indicatorDescription = loadProps.description';
properties.indicatorInfo = loadProps.dbinfo;
properties.dates = dates;


%% Set up targets
nTargets = size(opts.targets, 2);
nPeriods = size(data.indicators, 1);

% Set vector of if targets get triange accumulator
accumSeries = {'GDPH'};
properties.targetAccum = cellfun(@(strIn) any(strcmp(strIn, accumSeries)), opts.targets);

data.targets = nan(nPeriods, nTargets);
properties.accumLags = nan(1, nTargets);
for iT = 1:nTargets
  % Set data
  data.targets(:,iT) = data.series.(opts.targets{iT});
  % Set the lagged value of each series to be accumulated.
  properties.accumLags(iT) = fullSeries.([opts.targets{iT} 'full']){end,1};
end

% Names
properties.targetLabels = opts.targets;

%% Set computed properties
data.properties = properties;

data.properties.nSeries = size(data.indicators, 2);
data.properties.periods = size(data.indicators, 1);
data.properties.nTargets = size(opts.targets, 2);

data.properties.datenums = datenum(data.properties.dates);

% Get which month of the quarter we have indicators for
data.properties.month = mod(data.properties.periods-1,3)+1;

% Order field names
data.properties = orderfields(data.properties);
data = orderfields(data);

%% Error checking
dataSeries = fields(data.series);
for iS = 1:length(dataSeries)
  assert(size(data.series.(dataSeries{iS}), 1) == data.properties.periods);
end

%% Output summary of data
if opts.verbose
  targetDates = data.properties.datenums(any(~isnan(data.targets), 2));
  indicatorDates = data.properties.datenums;
  
  fprintf('Last date of indicators: %s\n', datestr(indicatorDates(end), 'mmm. yyyy'));
  fprintf('Last date of targets: %s\n\n', datestr(targetDates(end), 'yyyy QQ'));
end