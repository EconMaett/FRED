%% Brave-Butters-Kelley Indexes

% Scott Brave, Andrew Butters, and David Kelley, 2018-2019
clear; clc; close all;

%% Get the data
opts = estimationOptions();
data = loadData(opts);

%% Get saved parameters
load latestModelRun.mat
ss0 = makeSS0_Irregular(ss0A);

%% Collapsed Factor Model
est = model_BBK_Irregular(data, opts, ss0);

%% Output figures and tables
output_bbki(est, opts);
output_series_contributions(data, est, opts);

%% Store latest parameters in the working directory
ss0A = est.ssOpt;
save('latestModelRun','ss0A')
