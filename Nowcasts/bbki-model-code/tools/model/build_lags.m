function [XX] = build_lags(ydata,lags,constant_flag)
%% build_lags.m

[obs,nvar] = size(ydata);
 
% set up lag matrix
XX = ones(obs-lags,constant_flag+nvar*lags);

    for ii=1:lags
        XX(:,1+nvar*(ii-1):nvar*ii) = ydata(lags-ii+1:end-ii,:);
    end
    
end
%% End of File