function [dataTab, props, rawData, transData, raggedData, outData] = loadDataset(specfile, varargin)
% Load the a dataset from a specification file
%
% dataTab = loadDataset(specfile) loads a dataset
%
% dataTab = loadDataset(specfile, Name, Value) loads the dataset with
% options specified by the Name-Value pairs described below. 
%
% The specification file should be an Excel file with a header row and a 
% row for each series. Each row should have entries in 3 columns: a series 
% name, a cbd.data specification, and a transformation to be applied to the
% specification. 
%
% Other series within the dataset can be reffered to by their name followed
% by '@LOCAL' (e.g., TEMP@LOCAL) to make the specifications more readable. 
% Any series without a transformation will be assumed to be used 
% temporarily in the construction of another series and discarded. The '%d'
% transformation can be used to prevent discarding a series.  
%
% The following options can be passed as name-value pairs: 
%   OutlierAdj  (boolean): adjust for outliers
%   OutThresh   (numeric): replace any values more than OutThresh*iqr away
%     from the median
%   FillJagged  (boolean): Fill the jagged edge with AR(p) models
%   AROrder     (numeric): Maximum lag order for the AR models
%   ARCrit      (string) : Criteria for AR models - BIC, AIC, fixed
%   Standardize (boolean): Demean and standardize the final dataset
%   DataStart   (string) : Date to start series at
%   DataEnd     (string) : Date to end series at
%   Display     (string) : Screen display detail: verbose, default, none

% David Kelley, 2016

%% Properties
inP = inputParser;
inP.addParameter('KeepOut', false, @islogical);
inP.addParameter('OutlierAdj', true, @islogical);
inP.addParameter('OutThresh', 6, @isnumeric);
inP.addParameter('FillJagged', true, @islogical);
inP.addParameter('AROrder', 5, @isnumeric);
inP.addParameter('ARCrit', 'BIC', @ischar);
inP.addParameter('Standardize', true, @islogical);
inP.addParameter('DataStart', '1/31/1960', @ischar);
inP.addParameter('DataEnd', '', @ischar);
inP.addParameter('Display', 'default', @ischar); % default, verbose, none
inP.parse(varargin{:});
opts = inP.Results;

line = @(char, len) repmat(char, [1 len]);

if any(strcmpi(opts.Display, {'default', 'verbose'}))
  [~, fname, ~] = fileparts(specfile);
  specfileName = fname;
  fprintf('\nRetrieving dataset: %s\n%s\n', ...
    specfileName, line('=', 20+length(specfileName)));
end

%% Read specification file
warning off MATLAB:table:ModifiedVarnames
spec_raw = readtable(specfile);
warning on MATLAB:table:ModifiedVarnames

serNames = spec_raw.Series;
serSpec = spec_raw.LevelSpecification;
transform = spec_raw.Transformation;
group = spec_raw.NIPAGroup;
release = spec_raw.Release;
description = spec_raw.Description;

finalMarker = ~cellfun(@isempty, transform);

%% Get data from cbd
nSeries = size(serNames, 1);
dataseries = cell(1, nSeries);
dataProps = cell(1, nSeries);
serIndexes = cell(1, nSeries);

outStr = '';
for iSer = 1:nSeries
  bspace = repmat('\b', [1 length(outStr)+(iSer>1)]*desktop('-inuse'));
  outStr = sprintf('Retrieving series %d of %d (%s)', ...
    max(1, sum(finalMarker(1:iSer))), sum(finalMarker), serNames{iSer});
  if any(strcmpi(opts.Display, {'default', 'verbose'}))
    fprintf([bspace '%s\n'], outStr);
  end

  [newStr, serIndexes{iSer}] = prepareExpression(serSpec{iSer}, serNames);
  iSers = dataseries(serIndexes{iSer});
  try
    [dataseries{iSer}, dataProps{iSer}] = cbd.expression(newStr, iSers{:});
  catch
    try
      [dataseries{iSer}, dataProps{iSer}] = cbd.expression(newStr, iSers{:});
    catch
      error('Error while retrieving %s: %s', serNames{iSer}, serSpec{iSer});
    end    
  end
end

if any(strcmpi(opts.Display, {'default', 'verbose'}))
  bspace = repmat('\b', [1 (length(outStr)+1)]*desktop('-inuse'));
  fprintf([bspace 'Completed retrieval of %d%s\n'], ...
    sum(finalMarker), ' series.');
end

%% Clean up raw series
[rawCell, dbInfo] = cellfun(@stripSeries, dataProps, 'Uniform', false);

rawSeries = cbd.merge(rawCell{:}); 

% Find the (potentially duplicated) ordering where the temp series are used
tempSerUsed = [serIndexes{:}];

baseNames = @(y) cellfun(@(x) ...
  subsref(strsplit(x, '_'), struct('type', '{}', 'subs', {{1}})), ...
  y.Properties.VariableNames, 'Uniform', false);

% Remove duplicate pulled series (after checking they really are duplicate)
rawNames = baseNames(rawSeries);
localSeries = strcmpi(unnest(dbInfo), 'local'); % need names replaced
rawNames(localSeries) = serNames(tempSerUsed);
[uniqueRawNames, sortOrder, duplicateIndex] = unique(rawNames);
arrayfun(@(iS) assertSameSeries(...
  rawSeries(:, duplicateIndex' == iS)), 1:length(uniqueRawNames)); 
rawData = rawSeries(:, sortOrder');
rawData.Properties.VariableNames = uniqueRawNames;

%% Filter series that are not "Final" series
tempSer = ~finalMarker;
dataseries(tempSer) = [];
serNames(tempSer) = [];
transform(tempSer) = [];
group(tempSer) = [];
release(tempSer) = [];
description(tempSer) = [];

% Combine into one table
dataTab = cbd.merge(dataseries{:});
dataTab.Properties.VariableNames = serNames';

% Trim if there are any all nan periods at the end
[~, inds] = cbd.last(dataTab);
if max(inds) < size(dataTab, 1)
  dataTab = cbd.trim(dataTab, 'endDate', dataTab.Properties.RowNames{max(inds)});
end

%% Apply transformations and trim 
nSeries = size(dataTab, 2);
transformSeries = cell(size(dataseries));
for iSer = 1:nSeries
  transformSeries{iSer} = cbd.expression(transform{iSer}, dataseries{iSer});
end
dataTab = cbd.merge(transformSeries{:});
dataTab.Properties.VariableNames = serNames;

if isempty(opts.DataEnd)
  opts.DataEnd = dataTab.Properties.RowNames{end};
end
% Trim if there are any all nan periods at the end
[~, inds] = cbd.last(dataTab);
if max(inds) < size(dataTab, 1)
  dataTab = cbd.trim(dataTab, 'endDate', dataTab.Properties.RowNames{max(inds)});
end
dataTab = cbd.trim(dataTab, 'startDate', opts.DataStart);

transData = dataTab;

%% Check for outliers
% Replace any values greater than 6 times the interquartile range with
% the median plus 6 times the interquartile range
if opts.OutlierAdj
  dataTab = adjustOutliers(dataTab, opts);
end
dataTab = cbd.trim(dataTab, 'endDate', opts.DataEnd);

raggedData = dataTab;

%% Forecast series that end early with an AR
% Use the BIC to selecct the optimal AR model up to an AR(5). Then forecast
% any series that end before the sample with the optimal AR.
if opts.FillJagged
  dataTab = fillJagged(dataTab, opts);
end

%% Trim the monthly data if we don't have at least the ISM yet
% dataTab.NAPMC(end) = nan;
% dataTab.NAPMC
if find(~isnan(dataTab{:,'NAPMC'}), 1, 'last') < size(dataTab, 1)
  dataTab = cbd.trim(dataTab, 'endDate', ...
      dataTab.Properties.RowNames{find(~isnan(dataTab{:,'NAPMC'}), 1, 'last')});
end

%% Check for nan values 
nanvals = sum(sum(isnan(dataTab{:,:})));
if nanvals > 0 && any(strcmpi(opts.Display, {'verbose', 'default'}))
  fprintf('%d nan values occur in final data.\n', nanvals);
end

%% Demean & standardize
if opts.Standardize
  
    if opts.KeepOut == false
        dataTab = cbd.stddm(dataTab);
        outData = dataTab;
    else
        outData = cbd.stddm(dataTab);
        if find(~isnan(transData{:,'NAPMC'}), 1, 'last') < size(transData, 1)
            transData = cbd.trim(transData, 'endDate', ...
                dataTab.Properties.RowNames{find(~isnan(transData{:,'NAPMC'}), 1, 'last')});
        end
        dataTab = cbd.stddm(transData);
    end
  
  if nanvals > 0 && any(strcmpi(opts.Display, {'verbose', 'default'}))
    fprintf('Data demeaned and standardized.\n');
  end
  
end

%% Set properties
props = struct;
props.group = group;
props.release = release;
props.description = description; 
props.dbinfo = dataProps;

% Report number of series that end by period
if any(strcmpi(opts.Display, {'default', 'verbose'}))
  lastObsCount = zeros(size(transData, 1), 1);
  for iSer = 1:nSeries
    [~,iLastObs] = cbd.last(transData(:,iSer)); 
    lastObsCount(iLastObs) = lastObsCount(iLastObs) + 1;
  end
  
  fullPer = find(lastObsCount ~= 0, 1, 'first')-1;
  fprintf('\nSeries by last observation\n%s\n', line('-', 26));
  for iPer = fullPer+1:size(transData, 1)
    fprintf('  %s  |  %3.0f \n', ...
      transData.Properties.RowNames{iPer}, lastObsCount(iPer))
  end
  fprintf('%s\n', line('-', 26));
end

if any(strcmpi(opts.Display, {'verbose'}))
  loadMsg = sprintf('Loaded data through %s', ...
    datestr(datenum(dataTab.Properties.RowNames{end}), 'mmm. yyyy'));
  fprintf('\n%s\n%s\n', loadMsg, line('=', length(loadMsg)));
end

end


function [newStr, seriesIndexes] = prepareExpression(strIn, serNames)
% Replace strings of "local" series with "%d" symbols and note the indexes
% of the series for use with cbd.expression later

newStr = upper(strIn);
serInds = [];
serLocs = [];
for iS = 1:length(serNames)
  iSname = [upper(serNames{iS}) '@LOCAL'];
  
  % Replace names of local series
  newStr = strrep(newStr, iSname, '%d');
  
  % Find where the series was in what will be the string of %d's
  iStrInds = strfind(upper(strIn), iSname);
  
  serInds = [serInds repmat(iS, [1 length(iStrInds)])]; %#ok<AGROW>
  serLocs = [serLocs iStrInds]; %#ok<AGROW>
end

[~,serLocOrder] = sort(serLocs);
seriesIndexes = serInds(serLocOrder);

end

function [series, dbSource] = stripSeries(cbdProps)
% Returns a single table of all series used in constructing an indicator. 

nSeries = size(cbdProps, 2);
components = cell(nSeries, 1);
dbSource = cell(nSeries, 1);

for iS = 1:nSeries
  if isfield(cbdProps{iS}, 'value') 
    if istable(cbdProps{iS}.value)
      components{iS} = cbdProps{iS}.value;
      
      if isfield(cbdProps{iS}, 'provider') && ~isempty(cbdProps{iS}.provider)
        dbSource{iS} = cbdProps{iS}.provider;
      else
        dbSource{iS} = 'local';
      end
    end

  elseif isfield(cbdProps{iS}, 'series')
    [components{iS}, dbSource{iS}] = stripSeries(cbdProps{iS}.series);
  end
end

nonempty = ~cellfun(@isempty, components);
series = cbd.merge(components{nonempty});
dbSource = dbSource(nonempty);
end

function assertSameSeries(datatable)
% Asserts that all of the series in a table have the same data
areDuplicates = all(all(datatable{:,:} == ...
  repmat(datatable{:,1}, [1 size(datatable, 2)]) | ...
  isnan(datatable{:,:})));
assert(areDuplicates);  
end

function out = unnest(cellIn)
% Unnest a nested cell array

if iscell(cellIn)
  oneLevel = cellfun(@unnest, cellIn, 'Uniform', false);
  out = [oneLevel{:}];
else
  out = {cellIn};
end
end