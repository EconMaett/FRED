%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% StockWatsonMUB.m                                                        
%                                                                         
% Produces a median unbiased estimate of a time-varying intercept variance 
% for the local level model.
%                                            
%           y_t  = beta_t + u_t
%        beta_t  = beta_t-1 + v_t
%        a(L)u_t = epsilon_t
%
% See Stock and Watson (JASA, 1998) for further details.  
%
% Inputs:
%    y -- dependent variable
%    p -- degree of AR(p) process for a(L); ex: 0,1,2
% stat -- sequential break-point test statistic; ex: QLR,MW,EW
%
% Outputs:
%      rho -- AR(p) coefficients with constant ordered first
%   lambda -- scalar parameter estimated by median unbiased method
%    omega -- long-run variance estimate of u_t
%    sigma -- time-varying intercept variance equal to (labmda/T)^2*omega
%
%   Ex: [sigma,omega,lambda,rho]=StockWatsonMUB(y_t,1,'EW')
%
% Copyright: Scott A. Brave, 2016
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [sigma,omega,lambda,rho,tau]=StockWatsonMUB(y,x,p,stat)

drop = isnan(y);
y(drop) = [];
x(drop,:) = [];
        
if p>0
    
    % OLS regressions w/ AR(p) error dynamics
    [~,~,e] = regress(y,x);
    eLags = build_lags(e,p,0);
    rho = regress(e(1+p:end),[ones(size(e,1)-p,1) eLags]);

    % Scalar lag polynomial a(L) and mu
    aL = zeros(1,p+1);
    aL(1,1) = 1;
    aL(1,2:end) = -1*rho(2:end);
    
    mu = rho(1); 
    
    % FGLS transformed data (yTilde=a(L)y_t and xTilde=a(L)x_t)
    yLags = build_lags(y,p,0);
    yTilde = aL*[y(1+p:end,:)-mu yLags-mu]';
    
    % Long-run variance transformations for sigma2_u
    if p == 1
        gamma = (1-rho(2)^2);
    elseif p == 2
        gamma = ((1+rho(3))*(rho(2)+rho(3)-1)*(rho(3)-rho(2)-1))/(1-rho(3));
    elseif p == 3
        gamma = ((1-rho(4)-rho(3)-rho(2))*(1+rho(3)+rho(4)*rho(2)-rho(4)^2)*(1+rho(4)+rho(2)-rho(3)))/(1-rho(3)-rho(2)*rho(4)-rho(4)^2);
    else
        error('Cannot handle more than an AR(3) at this time.')
    end
    
    % D = 1 scale normalization used in Stock and Watson (1998)
    xTilde = sqrt(gamma).*x(1+p:end,:)';
    
else

    yTilde = y';
    xTilde = x';
    gamma = 1;
    rho = 0;
    
end

% Sequential break-point tests
[QLR,MW,EW,sigma2_eps]=break_t(yTilde',xTilde');
tm = [QLR,MW,EW];
crit_val = tm(strcmpi(stat, {'QLR', 'MW', 'EW'}));

% Median unbiased estimate of time-varying parameter variance (sigma)
lambda = lamfind(crit_val,stat);
tau    = lambda/size(y,1); 
omega  = sigma2_eps/gamma;
sigma  = tau^2*omega;
  
end