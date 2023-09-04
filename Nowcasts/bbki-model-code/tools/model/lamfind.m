function [lam]=lamfind(val, name)
%% Finding the appropriate median-unbiased estimator for lambda
% Created: 4/2012, Max Lichtenstein

load stats

if strcmp(name,'L')
    test = stats(:,1);
elseif strcmp(name,'MW')
    test = stats(:,2);
elseif strcmp(name,'EW')
    test = stats(:,3);
elseif strcmp(name,'QLR')
    test = stats(:,4);
elseif strcmp(name,'POI7')
    test = stats(:,5);
else
    test = stats(:,6);
end

loc = 1;

for ii=1:31
    if val>test(ii)
        loc=loc+1;
    end
end

if loc-1>0 && loc <= 30
    lam = lambda(loc-1) + (val-test(loc-1))/(test(loc)-test(loc-1));
elseif loc-1==0
    lam = 0;
elseif loc>31
  % Added: David Kelley, 2015
    loc = 31;
    lam = lambda(loc-1) + (val-test(loc-1))/(test(loc)-test(loc-1));
end

end