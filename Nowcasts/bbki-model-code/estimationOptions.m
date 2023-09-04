function opts = estimationOptions(varargin)
% Get options for BBK estimation

% David Kelley, 2016-2019
% Ross Cole, 2020-2022

inP = inputParser;
inP.parse(varargin{:});
inOpts = inP.Results;

%% General Options
opts = struct;

% Print log to screen
opts.verbose = true;

% Print output showing either forecast or model evaluation output
opts.diagnostic = true;

% Run in parallel
opts.parallel = true;

% Estimation tolerance
opts.tol = 1e-6;

% Estimation start time
opts.timeStamp = now();
opts.KeepOut = false;
opts.OutlierAdj = false;
opts.OutThresh = 6;
opts.fcastHorizon = 0;

%% Paths
paths.root = pwd;
paths.data  = fullfile(paths.root);
paths.output = fullfile(paths.root, 'output');
addpath(genpath(fullfile(paths.root, 'tools')));
opts.paths = paths;

%% Data 

% Data dictionary file
opts.dataspec = 'data_dictionary.xlsx';

% Target specification
opts.targets = {'GDPH'};

% Balance the end of the panel with AR(p)s before balancing with common factor
opts.balanceARs = false;

% Number of factor to balance the panel with
opts.nBalanceFactors = 1;

% Start of estimation
opts.startDate = '7/31/1959';

% Start of factors in data set
opts.startDateFactors = '1/31/1960';

%% Order alphabetically
opts = orderfields(opts);
