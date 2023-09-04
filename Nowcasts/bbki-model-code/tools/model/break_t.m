%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% BREAK_T.M

% This file contains the Matlab procedure  BREAK_T  written by

% Bruce E. Hansen
% Department of Economics
% Social Science Building
% University of Wisconsin
% Madison, WI 53706-1393
% bhansen@ssc.wisc.edu
% http://www.ssc.wisc.edu/~bhansen/

% The procedure augments the testing methods dicussed in
% "Testing for Structural Change in Conditional Models."

% Format:   break_t(y,x);

% Outputs:
% QLR, MW, and EW test statistics
%
% Inputs:

% y    = dependent variable (nx1 vector)
% x    = regressors (nxk matrix, may contain lagged y's)
%        Note: For Sup test, Andrews recommends t1=.15 and t2=.85
%              For Exp test, Andrews-Ploberger recommend t1=.02 and t2=.98

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [QLR,MW,EW,sig]=break_t(y,x)
 
k=length(x(1,:));
n=length(y(:,1));

if 1-(n==length(x(:,1)))
    disp('ERROR:  Number of rows in Y and X must equal.');
    disp('      Please re-specify.');
end;

for jj=1:2

if jj==1
    n1=floor(n*0.15);
    n2=floor(n*0.85);
else
    n1=floor(n*0.02);
    n2=floor(n*0.98);
end

xx=x'*x;
xxi=inv(xx);
beta=xxi*(x'*y);
e=y-x*beta;
xe=x.*(e*ones(1,length(x(1,:))));
ee=e'*e;
sig=ee/(n-k);
yd=y-mean(y);

f=zeros(n,1);
m=x(1:n1-1,:)'*x(1:n1-1,:);
mi=inv(m);
msi=inv(xx-m);
sn=sum(xe(1:n1-1,:))';

ib=n1;
while ib<=n2
    xi=x(ib,:)';
    xim=xi'*mi;
    mi=mi-((xim'*xim)'/(1+xim*xi)')';
    xim=xi'*msi;
    msi=msi+((xim'*xim)'/(1-xim*xi)')';
    sn=sn+(xe(ib,:)');
    q=sn'*msi*xx*mi*sn;
    f(ib)=q*(n-k*2)/(ee-q);
    ib=ib+1;
end;

if jj==1
    [QLR,im]=max(f); %formerly supf
    MW=mean(f(n1:n2))'; %formerly avef
else
    EW=log(mean(exp(f(n1:n2)/2))'); %formerly expf
end

end
end

    
    