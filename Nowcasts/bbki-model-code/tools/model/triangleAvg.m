function triAvg = triangleAvg(data)
% Get the quarterly version of a state variable

% Scott Brave and David Kelley, 2016

triAvg = nan(size(data'));
for iS = 1:size(data, 1)
  QL0scale = [1 0 0; 0 2/3 0; 0 0 1/3];
  QL1scale = [0 0 0; 0 1/3 0; 0 0 2/3];

  triAvg(:,iS) = kron([NaN  sum(QL0scale*reshape(data(iS,4:end)',3,[]) + ...
    QL1scale*reshape(data(iS,1:end-3)',3,[])) ],[NaN NaN 1])';
end