function output_series_contributions(data, estimated, opts)

%% Output contributions for all series
% 
% Generate excel file with four tabs:
%    1. KEY: List of mnemonics and series descriptions (make sure they
%       match what's up on the website in the indicators list)
%    2. COINCIDENT: Contributions from each series to the BBKI coincident index
%    3. LEADING: Contributions from each series to the BBKI leading index
%    4. MGDP: Contributions from each series to BBKI MGDP
%
% Scott Brave and Ross Cole, 2020

%% XLSX file
nSeries = size(data.indicators, 2);
outdir = opts.paths.output;
xlsxFilename = fullfile(outdir, 'bbki-data-series-contributions-xlsx.xlsx');
if exist(xlsxFilename, 'file')==2
    delete(xlsxFilename);
    warning('Overwriting output in %s...\n',xlsxFilename);
end


%% Decompose Coincident Index, Leading Index, and monthly GDP
dataGood = find(~isnan(estimated.Y(:,2)));
stateContrib = estimated.ssOpt.decompose_smoothed(estimated.Y);
uncollapse = pinv(estimated.static.Gamma0 * ...
                  estimated.static.Gamma0') * ...
                  estimated.static.Gamma0 * ...
                  estimated.ssOpt.Z(2:3,1:2);
              
% Weights are computed as each series' contribution over their sum
serW = (uncollapse ./ repmat(sum(uncollapse), [size(estimated.static.Gamma0,1) 1]));

% Decomposition of Coincident Index
rawStd = std(sum(estimated.alpha(1:2,dataGood), 1)');
rawMean = mean(sum(estimated.alpha(1:2, dataGood), 1)') / (size(data.indicators,2) + size(data.targets, 2));
seriesContrib = nan(estimated.ssOpt.m, nSeries, size(estimated.Y, 1));
for iS = 1:size(data.indicators, 2)
  for iState = 1:size(stateContrib, 1)
    seriesContrib(iState,iS,:,1) = serW(iS,1) .* squeeze(stateContrib(iState,2,:))' + ...
        serW(iS,2) .* squeeze(stateContrib(iState,3,:))';
  end
end

% Create table and display contributions to C_t
cContrib = ([squeeze(sum(stateContrib(1:2,1,dataGood), 1)) squeeze(sum(seriesContrib(1:2,:,dataGood), 1))'] - rawMean) ./ rawStd;
test = sum(cContrib, 2) - estimated.seriesM.Cycle; 
assert(max(abs(test))<1e-8);

% Decomposition of Leading Index: contributions to L_t
rawStd = std(estimated.alpha(1,dataGood)');
rawMean = mean(estimated.alpha(1, dataGood)') / (size(data.indicators,2) + size(data.targets, 2));
lContrib = ([squeeze(stateContrib(1,1,dataGood)) squeeze(seriesContrib(1,:,dataGood))'] - rawMean) ./ rawStd;
test = sum(lContrib, 2) - zscore(estimated.seriesM.Leading);
assert(max(abs(test))<1e-8);

% MGDP decomposition
mGdpStd = nanstd(data.targets(:))*3;
mGdpMean = nanmean(data.targets(:));
mGDP = mGdpMean + (mGdpStd .* sum(estimated.alpha(1:4, :)', 2));
mContribGdp = mGdpMean + (mGdpStd .* squeeze(sum(stateContrib(1:4,1,:),1)));
mContribSeries = mGdpStd .* squeeze(sum(seriesContrib(1:4,:,:),1))';
mContrib = [mContribGdp mContribSeries] ;
test = sum(mContrib, 2) - mGDP;
assert(max(abs(test)) < 1e-8);


%% Create table to dump into excel
warning off 'MATLAB:xlswrite:AddSheet'
description = 'This file contains contributions to the BBK Coincident Index (coincidentIndex), the BBK Leading Index (leadingIndex), and BBK Monthly GDP growth (monthlyGDP) from all series and GDP. The full indicators list can be found at https://www.chicagofed.org/~/media/publications/bbki/bbki-indicators-list-pdf.pdf.';

% Key tab
updateInfo = sprintf('Last updated: %s', datestr(opts.timeStamp, 'mmmm dd, yyyy'));
key = [{'BBKI Series Contributions', updateInfo}; {description, ''}; {'',''};{'Mnemonic', 'Description'}; ...
    ['GDP'; data.properties.indicatorLabels'], ['Real Gross Domestic Product'; data.properties.indicatorDescription']];
xlswrite(xlsxFilename, key, 'key');

% Contributions to the Coincident Index
cContrib = [datenum(data.properties.dates(dataGood)) cContrib];
coincidentIndexContribs = array2table(cContrib, 'VariableNames', ...
    ['Date' 'GDP' data.properties.indicatorLabels], 'RowNames', data.properties.dates(dataGood));
coincidentIndexContribs.Date = cellstr(datetime(data.properties.dates(dataGood), 'Format', 'MM/yyyy'));
writetable(coincidentIndexContribs(:,:), xlsxFilename, 'WriteRowNames', false, 'Sheet', 'coincidentIndex');

% Contributions to the Leading Index
lContrib = [datenum(data.properties.dates(dataGood)) lContrib];
leadingIndexContribs = array2table(lContrib, 'VariableNames', ...
    ['Date' 'GDP' data.properties.indicatorLabels], 'RowNames', data.properties.dates(dataGood));
leadingIndexContribs.Date = cellstr(datetime(data.properties.dates(dataGood), 'Format', 'MM/yyyy'));
writetable(leadingIndexContribs(:,:), xlsxFilename, 'WriteRowNames', false, 'Sheet', 'leadingIndex');

% Contributions to monthly GDP
mContrib = [datenum(data.properties.dates) mContrib];
monthlyGdpContribs = array2table(mContrib, 'VariableNames', ...
    ['Date' 'GDP' data.properties.indicatorLabels], 'RowNames', data.properties.dates);
monthlyGdpContribs.Date = cellstr(datetime(data.properties.dates, 'Format', 'MM/yyyy'));
writetable(monthlyGdpContribs(dataGood,:), xlsxFilename, 'WriteRowNames', false, 'Sheet', 'monthlyGDP');

%% Clean up sheets and add formatting
xlsxFile = cbd.xlsfile(xlsxFilename);
xlsxFile.wkBook.Sheets.Item(1).Delete();

% Define sheets
keySheet = xlsxFile.wkBook.Sheets.Item(1);
coincidentSheet = xlsxFile.wkBook.Sheets.Item(2);
leadingSheet = xlsxFile.wkBook.Sheets.Item(3);
gdpSheet = xlsxFile.wkBook.Sheets.Item(4);

% Format the "key" tab
keySheet.Range('A1:A1').Font.Size = 14;
keySheet.Range('A1:A1').Font.FontStyle = 'Bold';
keySheet.Range('B1:B1').Font.FontStyle = 'Italic';
keySheet.Range('A4:B4').Font.FontStyle = 'Bold';
keySheet.Range('A:A').ColumnWidth = 34;
keySheet.Range('B:B').ColumnWidth = 93;
keySheet.Range('A2:B2').Borders.Item('xlEdgeTop').LineStyle = 12;
keySheet.Range('A4:B4').Borders.Item('xlEdgeBottom').LineStyle = 1;
keySheet.Range(['A' num2str(nSeries+5) ':B' num2str(nSeries+5)]).Borders.Item('xlEdgeBottom').LineStyle = 1;
keySheet.Range('A1:B1').RowHeight = 30;
keySheet.Range('A2:B2').MergeCells = 1;
keySheet.Range('A2:B2').WrapText = 1;
%keySheet.Range('A2:B2').VerticalAlignment = 1;
keySheet.Range('A2:B2').RowHeight = 29;
keySheet.Range('A2:B2').Font.Size = 10;
keySheet.Range('A2:B2').Borders.Item('xlEdgeBottom').LineStyle = 1;

% Number formatting
coincidentSheet.Range('A1:SH1').Font.FontStyle = 'Bold';
leadingSheet.Range('A1:SH1').Font.FontStyle = 'Bold';
gdpSheet.Range('A1:SH1').Font.FontStyle = 'Bold';
coincidentSheet.Range(['A2:A' num2str(1+size(dataGood,1))]).NumberFormat = 'mm/YYYY';
leadingSheet.Range(['A2:A' num2str(1+size(dataGood,1))]).NumberFormat = 'mm/YYYY';
gdpSheet.Range(['A2:A' num2str(1+size(dataGood,1))]).NumberFormat = 'mm/YYYY';
coincidentSheet.Range(['B2:SH' num2str(1+size(dataGood,1))]).NumberFormat = '0.000';
leadingSheet.Range(['B2:SH' num2str(1+size(dataGood,1))]).NumberFormat = '0.000';
gdpSheet.Range(['B2:SH' num2str(1+size(dataGood,1))]).NumberFormat = '0.000';
coincidentSheet.Range(['B1:SH' num2str(1+size(dataGood,1))]).HorizontalAlignment = 3;
leadingSheet.Range(['B1:SH' num2str(1+size(dataGood,1))]).HorizontalAlignment = 3;
gdpSheet.Range(['B1:SH' num2str(1+size(dataGood,1))]).HorizontalAlignment = 3;

% Freeze panes on the contribution sheets
coincidentSheet.Activate;
coincidentSheet.Range('B2').Select();
coincidentSheet.Application.ActiveWindow.FreezePanes = 1;
leadingSheet.Activate;
leadingSheet.Range('B2').Select();
leadingSheet.Application.ActiveWindow.FreezePanes = 1;
gdpSheet.Activate;
gdpSheet.Range('B2').Select();
gdpSheet.Application.ActiveWindow.FreezePanes = 1;

% Now reactivate the key sheet and sanitize the file
keySheet.Activate;
keySheet.Range('A1').Select();
xlsxFile.wkBook.RemoveDocumentInformation(99);
xlsxFile.wkBook.SaveLinkValues = 0;
   
% Save and close
xlsxFile.wkBook.Save()
xlsxFile.close();

end
















