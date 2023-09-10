function [F0,Gamma0,Sigma0,yBalanced] = ReissWatson(yData, nFactors, opts, yOut)
% Calculate the balanced panel and time series of the factor(s) and 
% loadings for a panel of time series with potentially missing observations
%
% Input: 
%   y          ~ time series dimensioned T x N 
%   nFactors   ~ number of factors to be estimated
%   opts       ~ structure of additional options
%     tol      ~ convergence tolerance
%     norm     ~ normalization type 1= Lambda'*Lambda, 2 = Fhat'*Fhat
%     verbose  ~ display SSE progress
%
% Output:
%   yBalanced ~ balanced time series dimensioned T x N
%   Gamma     ~ estimates of the loadings N x numFactors
%   Factor    ~ estimates of the factors  T x numFactors
%   Sigma     ~ estimate of the error variance matrix N x N

% R. Andrew Butters, 2013; David Kelley, 2016

if nargin < 3
  opts.verbose = false;
  opts.tol = 1e-6;
end

if opts.verbose
  bars = repmat('=', [1 29]);
  fprintf('Reiss & Watson (2009)\n%s\n Iteration | SSE differences\n%s\n', bars, bars);
end

try 
  useDisp = desktop('-inuse');
catch
  useDisp = false;
end

if opts.KeepOut
    y = yOut;
else
    y = yData;
end

%% Set up dimensions
nSeries = size(y, 2);

% Find portion of Y that needs to be balanced
firstObs = find(any(~isnan(y),2), 1, 'first');
lastObs = find(any(~isnan(y),2), 1, 'last');
balInd = firstObs:lastObs;
nPeriods = lastObs-firstObs+1;

nmiss = nan(size(y,1),1);
for ii = 1:size(y,1)
    nmiss(ii,1) = sum(~isnan(y(ii,:)),2);
end

%% Initialize 
l = ones(nSeries,1);
w = (1./nanstd(y(balInd,:)))';
ai = nanmean(y(balInd,:))';
wi = nanstd(y(balInd,:))';
a0 = nanmean(y(balInd,:),2);

yStd = (y(balInd,:)-repmat(ai,1,size(y(balInd,:),1))').*repmat(w,1,size(y(balInd,:),1))';

% Fill in missing data with zeros (means) initially
if sum(sum(isnan(y)))>0
  yStd(isnan(y(balInd,:))) = 0;
end

z0 = yStd - a0*(l.*w)';
[gam,f0] = pca(z0,'NumComponents',nFactors);

resid0 = z0 - f0*gam';
v0 = diag(diag(resid0*resid0')./nSeries);
[gamma,f0] = pca(sqrt(v0)\z0,'NumComponents',nFactors);

for ii = 1:nFactors
    if corr(f0(:,ii),yStd(:,15))<0
        f0(:,ii) = -1*f0(:,ii);  %% impose sign restriction
        gamma(:,ii) = -1*gamma(:,ii);
    end
end

if opts.norm == 1
    if opts.KeepOut == true
        w2 = (1./nanstd(yData(balInd,:)))';
        ai2 = nanmean(yData(balInd,:))';
        wi2 = nanstd(yData(balInd,:))';
        yStdOut = (yData(balInd,:)-repmat(ai2,1,size(yData(balInd,:),1))').*repmat(w2,1,size(yData(balInd,:),1))';
        if sum(sum(isnan(y)))>0
            yStdOut(isnan(yData(balInd,:))) = 0;
        end
        lam = [w2,gamma];
        G = chol((lam'*lam)/nSeries);     %% imposes (Lambda'Lambda)=I
        Lambda = (lam/G)/sqrt(nSeries);
        Fhat = (yStdOut*Lambda);
    else
        lam = [w,gamma];
        G = chol((lam'*lam)/nSeries);     %% imposes (Lambda'Lambda)=I
        Lambda = (lam/G)/sqrt(nSeries);
        Fhat = (yStd*Lambda);
    end
else
    if opts.KeepOut == true
        w2 = (1./nanstd(yData(balInd,:)))';
        ai2 = nanmean(yData(balInd,:))';
        wi2 = nanstd(yData(balInd,:))';
        yStdOut = (yData(balInd,:)-repmat(ai2,1,size(yData(balInd,:),1))').*repmat(w2,1,size(yData(balInd,:),1))';
        if sum(sum(isnan(y)))>0
            yStdOut(isnan(yData(balInd,:))) = 0;
        end
        lam = [w2,gamma];
        f0 = yStdOut*lam/(lam'*lam);
        G = chol((f0'*f0)/nPeriods);      %% imposes (F'F) = I
        Fhat = (f0/G)/sqrt(nPeriods);
        Lambda = lam;
    else
        lam = [w,gamma];
        f0 = yStd*lam/(lam'*lam);
        G = chol((f0'*f0)/nPeriods);      %% imposes (F'F) = I
        Fhat = (f0/G)/sqrt(nPeriods);
        Lambda = lam;
    end
end

%% EM algorithm with missing observations and factor loading restrictions
gap = 1; SumSquareResids0 = 0; iter = 0;

while abs(gap) > opts.tol 
  a = Fhat(:,size(l,2));
  R = Fhat(:,size(l,2)+1:end);
  if sum(sum(isnan(y(balInd,:))))>0
      yPred = Fhat*Lambda';
      yStd(isnan(y(balInd,:))) = yPred(isnan(y(balInd,:)));
      yStd = repmat(ai,1,size(a,1))'+standard(demean(yStd)).*repmat(wi,1,size(a,1))';
      if opts.KeepOut == true
          yStdOut(isnan(y(balInd,:))) = yPred(isnan(y(balInd,:)));
          yStdOut = repmat(ai2,1,size(a,1))'+standard(demean(yStdOut)).*repmat(wi2,1,size(a,1))';
      end
  end
  if opts.KeepOut == true
      resid = yStdOut - Fhat*Lambda';
  else
      resid = yStd - Fhat*Lambda';
  end
  V = diag(diag(resid*resid')./nSeries);
  %       V = eye(size(f0,1));
  %       V(end-2,end-2) = 1e14;
  %       V(end-1,end-1) = 1e14;
  %       V(end,end) = 1e14;
  SumSquareResids =sum(sum((resid(~isnan(y(balInd,:)))).^2));
  gap = SumSquareResids - SumSquareResids0;
  if iter>2
    if gap>0
      error('EM algorithm backed up!!')
    end
    if opts.verbose
        if iter > 2; bspace = repmat('\b', [1 30]*useDisp); else bspace = []; end
        fprintf([bspace '%10.0d | %16.8f\n'], iter, gap)
    end
  end
  SumSquareResids0 = SumSquareResids;
  iter = iter + 1;
  if opts.norm == 1
      X = yStd- a*(l.*w)';
      gamma = (X'/V*R)/((R'/V*R));
      if opts.KeepOut == 1
          lam = [w2,gamma];
          G = chol((lam'*lam)/nSeries);    %% imposes (Lambda'Lambda)=I
          Lambda = (lam/G)/sqrt(nSeries);
          Fhat = (yStdOut*Lambda);
      else
          lam = [w,gamma];
          G = chol((lam'*lam)/nSeries);    %% imposes (Lambda'Lambda)=I
          Lambda = (lam/G)/sqrt(nSeries);
          Fhat = (yStd*Lambda);
      end
      for ii = 1:nFactors
        if corr(Fhat(:,ii),yStd(:,15))<0
            Fhat(:,1+ii) = -1*Fhat(:,1+ii);  %% impose sign restriction
            Lambda(:,1+ii) = -1*Lambda(:,1+ii);
        end
      end
  else
      X = yStd- a*(l.*w)';
      gamma = (X'*R)/((R'*R));
      Q = ones(1,nSeries);
      gamma = gamma - (R'*R)\Q'/((Q/(R'*R)*Q'))*(Q*gamma);
      if opts.KeepOut == 1
          lam = [w2,gamma];
          f0 = yStdOut*lam/(lam'*lam);
          G = chol((f0'*f0)/nPeriods);     %% imposes (F'F) = I
          Fhat = (f0/G)/sqrt(nPeriods);
          Lambda = lam;
      else
          lam = [w,gamma];
          f0 = yStd*lam/(lam'*lam);
          G = chol((f0'*f0)/nPeriods);     %% imposes (F'F) = I
          Fhat = (f0/G)/sqrt(nPeriods);
          Lambda = lam;
      end
      for ii = 1:nFactors
        if corr(Fhat(:,ii),yStd(:,15))<0
            Fhat(:,1+ii) = -1*Fhat(:,1+ii);  %% impose sign restriction
            Lambda(:,1+ii) = -1*Lambda(:,1+ii);
        end
      end
  end
end

% Rescale but maintain factor loading restrictions and use outliers in final factors if chosen
if opts.norm == 1
    if opts.KeepOut == true
        G = chol((lam.*repmat(wi2,1,nFactors+1))'*(lam.*repmat(wi2,1,nFactors+1)));   
        Gamma0 = ((lam.*repmat(wi2,1,nFactors+1))/G)/sqrt(nSeries);
        F0 = (yStdOut*Gamma0);
    else
        G = chol((lam.*repmat(wi,1,nFactors+1))'*(lam.*repmat(wi,1,nFactors+1)));
        Gamma0 = ((lam.*repmat(wi,1,nFactors+1))/G)/sqrt(nSeries);
        F0 = (yStd*Gamma0);
    end
else
   if opts.KeepOut ==  true
       Gamma0 =(lam.*repmat(wi2,1,nFactors+1))/nSeries;
       Fhat = (yStdOut*Gamma0)/(Gamma0'*Gamma0);
       G = chol((Fhat'*Fhat)/nPeriods); %% imposes (F'F) = I
       F0 = (Fhat/G);
   else
       Gamma0 =(lam.*repmat(wi,1,nFactors+1))/nSeries;
       Fhat = (yStd*Gamma0)/(Gamma0'*Gamma0);
       G = chol((Fhat'*Fhat)/nPeriods); %% imposes (F'F) = I
       F0 = (Fhat/G);
   end
end

%% Create desired outputs
F0 = [nan(firstObs-1, nFactors+1); 
  F0; 
  nan(nPeriods - lastObs,nFactors+1)];
yBalanced = [nan(firstObs-1, nSeries); 
  yStd; 
  nan(nPeriods - lastObs, nSeries)];

errs = (yBalanced(balInd,:)-F0(balInd,:)*Gamma0');
Sigma0 = diag(diag(errs'*errs)) ./ size(balInd,2);

if opts.verbose
  fprintf('%s\nCompleted Reiss & Watson\n', bars);
end

end

function [ynew] = demean(yold)
% demean.m will demean a matrix or vector of observations, where different
% rows distinguish different observations and different columns distinguish
% different series.
%
% input:  
%    yold - data (matrix or vector)
%
% output:
%    ynew - data demeaned
%
%
%    % See also: standard
%
%
%   % Copyright: R. Andrew Butters 2009

t=size(yold,1);
mu=mean(yold);
e=repmat(mu,t,1);
ynew=yold-e;
end

function [ynew] = standard(yold)
% standard.m will standardize a matrix or vector of observations, where
% different rows distinguish different observations and different columns
% distinguish different series.
%
% input: 
%    yold - data (matrix or vector)
%
% output: 
%    ynew - data standardized
%
%
%   % See also: demean
%
%   % Copyright: R. Andrew Butters 2009

t=size(yold,1);
sd=std(yold);
e=repmat(sd,t,1);
ynew=yold./e;
end
