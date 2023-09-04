function static = initializeStaticFactors(data, opts, dims)
% Compute the initial static collapsed factors

% Scott Brave, Andrew Butters & David Kelley, 2015-2016

%% Compute factors & factor loadings
% Stock and Watson (2002) EM algorithm to obtain principal components
if opts.rotate == 0
    [f0init, Gamma0, Sigma0,yBal] = StockWatson(data.indicators, dims.rnfacs, opts);
elseif opts.rotate == 1
    [f0init, Gamma0, Sigma0,yBal] = ReissWatson(data.indicators, dims.rnfacs, opts, data.indicatorsOut);
end

%% Adjust for AR(p) process of error terms in observed series
Rho = [];

%% Flip signs of factors to have positive loading on first target
facTargs = [f0init(2:end,:) data.targets(1:end-1,:)];
facTargs(any(isnan(facTargs), 2),:) = [];
ftsCorr = corr(facTargs);

flips = sign(ftsCorr(1:size(f0init,2),size(f0init,2)+1))';

f0 = f0init .* repmat(flips, [size(f0init,1) 1]);
Gamma0 = Gamma0 .* repmat(flips, [size(Gamma0,1) 1]);

static = struct('f0', f0, 'Gamma0', Gamma0, 'Sigma0', Sigma0, ...
  'Rho', Rho, 'yBal', yBal);

