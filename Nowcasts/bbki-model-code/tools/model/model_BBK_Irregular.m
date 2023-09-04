function estimated = model_BBK_Irregular(data, opts, ss0)
% Run the BBK model - collapsed factor analysis with quarterly GDP instrument

% Scott Brave, Andrew Butters, and David Kelley, 2018-2019

%% Set up the data
%dims.rnfacs = 1;
%opts.rotate = 0;
%static = initializeStaticFactors(data, opts, dims);
%data.indicators(:, static.Gamma0(:,1) < 0) = -data.indicators(:, static.Gamma0(:,1) < 0);
data.indicators(:,[87:100 105:113 121 152 368:380 389 413:414 439 471]) = -data.indicators(:,[87:100 105:113 121 152 368:380 389 413:414 439 471]);

dims.rnfacs = opts.nBalanceFactors;
opts.rotate = 1;
opts.norm = 1;
static = initializeStaticFactors(data, opts, dims);
static.yNonbal = data.indicators;
x_bar = static.f0(:,1);
F_hat = static.f0(:,2);

targIndex = strcmpi('GDPH', data.properties.targetLabels);
target = data.targets(:, targIndex);

gdp = cbd.stddm(target);

Y = [gdp x_bar F_hat];

% Calculate number of months to project forward for nowcast
% nowcastIndex = find(~isnan(data.targets), 1, 'last') + 3;
% if size(Y, 1) < nowcastIndex + 3 * opts.fcastHorizon
%     Y = [Y; nan(nowcastIndex - size(Y,1) + 3 * opts.fcastHorizon, size(Y,2))];
% end

%% Initial states and parameters (unconditional moments)
QG0scale = [1/3 2/3 1 2/3 1/3];
Qx_bar = (QG0scale*...
    [x_bar(5:end)';x_bar(4:end-1)';x_bar(3:end-2)';x_bar(2:end-3)';x_bar(1:end-4)'])';
Qx_bar = [NaN(4,1);Qx_bar];

QF_hat = (QG0scale*...
    [F_hat(5:end)';F_hat(4:end-1)';F_hat(3:end-2)';F_hat(2:end-3)';F_hat(1:end-4)'])';
QF_hat = [NaN(4,1);QF_hat];

% Collapsed factor model parameters
cholF = chol(nancov([gdp Qx_bar QF_hat]));
B = cholF/diag([cholF(1,1),cholF(1,2),cholF(1,3)]);
B = B/diag([B(1,1),B(2,2),B(3,3)]);
gamma = B(2,3);

% AR parameters (See Taylor (2001) Econometrica article for derivation)
qF = (B\[gdp Qx_bar QF_hat]')';
warning off 'stats:regress:NoConst'
[rho,~,~,~,rstats] = regress(qF(6:3:end,2),qF(3:3:end-3,2));
[phi,~,~,~,pstats] = regress(qF(6:3:end,3),qF(3:3:end-3,3));
warning on 'stats:regress:NoConst'

rhoGrid = linspace(0,1,1000);
P = 3;
rhoStar = zeros(length(rhoGrid),1);
for ii = 1:length(rhoGrid)
    rhoStar(ii) = (rhoGrid(ii)*(1-rhoGrid(ii)^P)^2)/...
        (P*(1-rhoGrid(ii)^2)-2*rhoGrid(ii)*(1-rhoGrid(ii)^P));
end

rho = rhoGrid(find(rhoStar<rho,1,'last'));
phi = rhoGrid(find(rhoStar<phi,1,'last'));

varrho = rstats(4)/((1/9)*(3 + 4*rho + 4*rho^2 + 4*rho^3 + 3*rho^4));
varphi = pstats(4)/((1/9)*(3 + 4*phi + 4*phi^2 + 4*phi^3 + 3*phi^4));

% GDP growth trend parameters
[~,~,~,~,tau] = StockWatsonMUB(qF(3:3:end,1),ones(size(qF(3:3:end,1),1),1),1,'EW');

varEta = nanvar(qF(:,1))/(1+tau^2);

%% Set up state and initialize state matrices
Z = [ 1 1 1 1 0;
    1 nan 0 0 0;
    0 1   0 0 0];

H = blkdiag(0,nan,nan);

T = [nan 0 0 0 0; 
    0 nan 0 0 0; 
    0 0 1 0 0; 
    0 0 0 nan nan;
    0 0 0 1   0];

R = [1 0 0 0; 
    0 1 0 0; 
    0 0 tau 0; 
    0 0 0 1;
    0 0 0 0];

Q = diag([nan nan nan nan]);

ssE = StateSpaceEstimation(Z, H, T, Q, 'R', R);

% Stationarity constraint on the AR dynamics
ssE.constraints{1} = @(theta,ss) max(abs(eig(ss.T(:,:,1))))-1;
ssE.constraints{2} = @(theta,ss) max(abs(eig(ss.T(:,:,2))))-1;
ssE.constraints{3} = @(theta,ss) max(abs(eig(ss.T(:,:,3))))-1;

% Set the restricted elements to use the same theta element
ssE.ThetaMapping.index.Q(3,3) = ssE.ThetaMapping.index.Q(4,4);

% Clean up the indexes we got rid of
ssE.ThetaMapping = ssE.ThetaMapping.validateThetaMap();

%% Set up parameter bounds
LB = ssE.ThetaMapping.LowerBound;
UB = ssE.ThetaMapping.UpperBound;

% if isnan(Y(end,1))
    LB.T(1, 1) = ss0.T(1,1)-1e-3;
    LB.T(2, 2) = ss0.T(2,2)-1e-3;
    LB.T(4, 4) = ss0.T(4,4)-1e-3;
    LB.T(4, 5) = ss0.T(4,5)-1e-3;
    UB.T(1, 1) = ss0.T(1,1)+1e-3;
    UB.T(2, 2) = ss0.T(2,2)+1e-3;
    UB.T(4, 4) = ss0.T(4,4)+1e-3;
    UB.T(4, 5) = ss0.T(4,5)+1e-3;
    
    LB.Q(1,1) = ss0.Q(1,1)-1e-3;
    LB.Q(2,2) = ss0.Q(2,2)-1e-3;
    LB.Q(3,3) = ss0.Q(3,3)-1e-3;
    LB.Q(4,4) = ss0.Q(4,4)-1e-3;
    UB.Q(1,1) = ss0.Q(1,1)+1e-3;
    UB.Q(2,2) = ss0.Q(2,2)+1e-3;
    UB.Q(3,3) = ss0.Q(3,3)+1e-3;
    UB.Q(4,4) = ss0.Q(4,4)+1e-3;
    
%     LB.Z(2,2) = 0.8744-1e-3;
%     UB.Z(2,2) = 0.8744+1e-3;
    
    LB.H(2,2) = ss0.H(2,2)-1e-3;
    LB.H(3,3) = ss0.H(3,3)-1e-3;
    UB.H(2,2) = ss0.H(2,2)+1e-3;
    UB.H(3,3) = ss0.H(3,3)+1e-3;
% else
%     LB.T(1, 1) = ss0.T(1,1)-1e-3;
%     LB.T(2, 2) = ss0.T(2,2)-1e-3;
%     LB.T(4, 4) = ss0.T(4,4)-1e-3;
%     LB.T(4, 5) = ss0.T(4,5)-1e-3;
%     UB.T(1, 1) = ss0.T(1,1)+1e-3;
%     UB.T(2, 2) = ss0.T(2,2)+1e-3;
%     UB.T(4, 4) = ss0.T(4,4)+1e-3;
%     UB.T(4, 5) = ss0.T(4,5)+1e-3;
% end

ssE.ThetaMapping = ssE.ThetaMapping.addRestrictions(LB, UB);

%% Add accumulators
accum = Accumulator.GenerateRegular(Y, {'avg', '', ''}, [3 0 0]);
ssEA = accum.augmentStateSpaceEstimation(ssE);

%% Initalization
if nargin < 3 || isempty(ss0)
    Z0 = Z;
    Z0(2,2) = gamma;
  
    H0 = H;
    H0(2,2) = 0.05;
    H0(3,3) = 0.05;
  
    T0 = T;
    T0(1,1) = 0.9; % rho
    T0(2,2) = 0.9; % phi
    T0(4,4) = 0.8;
    T0(4,5) = -0.6;
  
    R0 = R;
    Q0 = Q;
    Q0(1,1) = varrho;
    Q0(2,2) = varphi;
    Q0(3,3) = varEta;
    Q0(4,4) = varEta;
    
    ss0 = StateSpace(Z0, H0, T0, Q0, 'R', R0);
    ss0A = accum.augmentStateSpace(ss0);
else
    % This part was added on 11/20
    ss0A = accum.augmentStateSpace(ss0);
end

% Check ss0A
[~, ll0] = ss0A.filter(Y');
assert(isfinite(ll0));

%% Estimate the model
ssEA.diagnosticPlot = opts.diagnostic;
if isfield(opts, 'parallel')
    ssEA.useParallel = opts.parallel;
end

%ssEA.solver = 'fmincon';
ssOpt = ssEA.estimate(Y', ss0A);
[alpha, smOut] = ssOpt.smooth(Y');

%% Construct final series
gdpMean = nanmean(target);
gdpStd = nanstd(target);

% New - monthly annualized units
mGdpMean = gdpMean;
mGdpStd = gdpStd * 3;

blankInd = find(isfinite(data.targets),1,'last')+1:size(alpha,2);

% Final estimated series
nPer = size(alpha,2);
mgdpComponents = alpha(1:4,:)' * mGdpStd + repmat([0 0 mGdpMean 0], [nPer 1]);
mgdpComponents(blankInd,4) = nan;

dataGood = find(~isnan(Y(:,2)));
rawIndex = sum(alpha(1:2,dataGood), 1)';
cycle = (sum(alpha(1:2,:), 1)' - mean(rawIndex)) ./ std(rawIndex);
mGDP = mGdpStd * sum(alpha(1:4,:), 1)' + mGdpMean;
mGDP(blankInd) = nan;

modelSeriesM = [cycle, mgdpComponents, mGDP];

rawIndexQ = sum(alpha(9:10,dataGood),1)';
newIndexQ = (sum(alpha(9:10,:), 1)' - mean(rawIndexQ)) ./ std(rawIndexQ);
q_series = [newIndexQ, gdpStd * alpha(9:12,:)' + repmat([0 0 gdpMean 0], [nPer 1]) ...
    (Y(:,1) * gdpStd + gdpMean)];
q_series(find(isfinite(data.targets),1,'last')+1:end,5) = nan;

modelSeriesNames = {'Cycle', 'Leading', 'Lagging', 'Trend', 'Irregular', 'MGDP'};

% Check that the quarterly is the average of the monthly
% lastGDPind = find(~isnan(target), 1, 'last');
% assert(max(abs(triangleAvg(mGDP(1:lastGDPind)') ./ 3 - ...
%     target(1:lastGDPind))) < 1e-10, 'Aggregation failed.');

% Check that the components of both add up to the GDP number
assert(max(abs(sum(q_series(:,2:5),2) - q_series(:,6))) < 1e-10, 'Decomposition failed.');
assert(max(abs(sum(modelSeriesM(:,2:5),2) - modelSeriesM(:,6))) < 1e-10, 'Decomposition failed.');

%% Compile output series
usePeriods = find(data.properties.datenums >= datenum(opts.startDateFactors)); 

series_monthly = array2table(...
    modelSeriesM(usePeriods,:), ...
    'VariableNames', modelSeriesNames, ...
    'RowNames', data.properties.dates(usePeriods));

series_quarterly = array2table(q_series(usePeriods(3:3:end),:), ...
    'VariableNames', [modelSeriesNames(1:5) {'GDP'}], ...
    'RowNames', data.properties.dates(usePeriods(3:3:end)));

%% Compile
estimated = struct('seriesM', series_monthly, 'seriesQ', series_quarterly, ...
    'ssOpt', ssOpt, 'Y', Y, 'alpha', alpha, 'static', static);

end
