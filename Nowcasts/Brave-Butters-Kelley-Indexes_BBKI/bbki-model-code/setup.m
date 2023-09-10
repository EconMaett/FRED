%% Set-up instructions and code for the BBKI
%
% There are several installations that need to take place prior to running
% the BBKI. 
%
% First, ensure that you have installed MFSS. Documentation and the
% necessary files can be found on GitHub, https://github.com/davidakelley/MFSS
%
% After doing so, run this script to finish installations. This includes
% installing CBD, the Census Bureau's seasonal adjustment software (X13),
% and replacing a couple CBD functions.
%
% If the automated downloads fail, simply look at the links in the getCBD
% and getCensusProgram functions and download them manually, saving them to
% the proper locations
%
% Ross Cole, 2022

clear; clc;
addpath(genpath('tools'));

%% Download CBD toolbox
getCBD();

%% Get Census seasonal adjustment executable
getCensusProgram();
