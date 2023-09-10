function output_bbki(estimated, opts)
% Create Excel output
%
% Saves bbki-data-series-xlsx.xlsx: XLSX file with monthly and quarterly series.
%
% David Kelley & Ross Cole, 2019

%% Output data file - One xlsx file with all data and a separate csv
%  with the monthly data and quarterly data.
outdir = opts.paths.output;

% XLSX file name
xlsxFilename = fullfile(outdir, 'bbki-data-series-xlsx.xlsx');
if exist(xlsxFilename, 'file')==2
    delete(xlsxFilename);
    warning('Overwriting output in %s...\n',xlsxFilename);
end

%% Key sheet

% Cell with date last updated
updateInfo = sprintf('Last updated: %s', datestr(opts.timeStamp, 'mmmm dd, yyyy'));

% Key values - two columns: one with the variable name and the second with
% a more detailed description of the variable 
keytable = {...
    ['Variable'],['Description'];...
    ['CoincidentIndex'],['BBK Coincident Index: the sum of the leading '...
        'and lagging subcomponents of the cycle measured in standard '...
        'deviation units from trend real GDP growth.'];...
    ['LeadingIndex'],['BBK Leading Index: the leading subcomponent of '...
        'the cycle measured in standard deviation units from trend '...
        'real GDP growth.'];...
    ['Cycle'],['Cycle component expressed in annualized real GDP growth '...
        'equivalent units.'];...
    ['CycleLeading'],['Leading subcomponent of the cycle expressed in '...
        'annualized real GDP growth equivalent units.'];...
    ['CycleLagging'],['Lagging subcomponent of the cycle expressed in '...
        'annualized real GDP growth equivalent units.'];...
    ['Trend'],['Trend component expressed in annualized real GDP growth '...
        'equivalent units.'];...
    ['Irregular'],['Irregular component expressed in annualized real '...
        'GDP growth equivalent units.'];...
    ['MGDP'],['BBK Monthly GDP Growth, which is indexed to the quarterly '...
        'estimates of real GDP growth from the U.S. Bureau of '...
        'Economic Analysis.'];
    };

% Notes to append to the bottom of the table
notes = {...
    ['Notes: The Cycle component is the sum of the leading and lagging subcomponents. '...
    'All quarterly series are the appropriately aggregated versions of the monthly series. '...
    'Aggregation uses the triangle average described in Brave, '...
        'Butters, and Kelley (2019) to approximate quarterly annualized '...
        '(log) percent changes from the monthly series.'],[''];...
    };

% Cite/see also - references at the bottom of the page
cite = {...
    ['Brave, Scott A., Ross Cole, and David Kelley, 2019, '...
        '"A ''big data'' view of the U.S. economy: Introducing the '...
        'Brave-Butters-Kelley Indexes," Chicago Fed Letter, Federal '...
        'Reserve Bank of Chicago, No. 422. Crossref, '...
        'https://doi.org/10.21033/cfl-2019-422'],[''];...
    ['Brave, Scott A., R. Andrew Butters, and David Kelley, 2019, '...
        '"A new ''big data'' index of U.S. economic activity," Economic '...
        'Perspectives, Federal Reserve Bank of Chicago, Vol. 43, No. 1. '...
        'Crossref, https://doi.org/10.21033/ep-2019-1'],[''];...
    };

% Combine the different cells to get everything we want to dump into excel
keyCell = [{'BBKI Data Key', updateInfo}; keytable; notes; {''}, {''}; {'See also:'},{''};cite];

% Now dump everything into excel -- adding a tab named "key"
warning off 'MATLAB:xlswrite:AddSheet'
xlswrite(xlsxFilename, keyCell, 'key');

%% Monthly data

% First create table for the XLSX file
monthly = estimated.seriesM;
monthly(:,1:6) = [];
monthly.Date = datetime(estimated.seriesM.Properties.RowNames, 'Format','MM/yyyy');
monthly.CoincidentIndex = zscore(estimated.seriesM.Cycle);
monthly.LeadingIndex = zscore(estimated.seriesM.Leading);
monthly.Cycle = estimated.seriesM.Leading+estimated.seriesM.Lagging;
monthly.CycleLeading = estimated.seriesM.Leading;
monthly.CycleLagging = estimated.seriesM.Lagging;
monthly.Trend = estimated.seriesM.Trend;
monthly.Irregular = estimated.seriesM.Irregular;
monthly.MGDP = estimated.seriesM.MGDP;
monthly.Properties.RowNames = cellstr(datetime(estimated.seriesM.Properties.RowNames,'Format','MM/yyyy'));

% Write monthly data to xlsx file
writetable(monthly, xlsxFilename, ...
   'WriteRowNames', false, ...
   'Sheet', 'monthly_data');

%% Quarterly data

% Drop values beyond the quarter of full data
estimated.seriesQ(isnan(estimated.seriesQ.GDP),:) = [];

% First create table for the xlsx file.
quarterly = estimated.seriesQ;
quarterly(:,1:6) = [];
quarterly.Date = cellstr(datetime(estimated.seriesQ.Properties.RowNames, 'Format','QQQ/yyyy'));
quarterly.CoincidentIndex = zscore(estimated.seriesQ.Cycle);
quarterly.LeadingIndex = zscore(estimated.seriesQ.Leading);
quarterly.Cycle = estimated.seriesQ.Leading+estimated.seriesQ.Lagging;
quarterly.CycleLeading = estimated.seriesQ.Leading;
quarterly.CycleLagging = estimated.seriesQ.Lagging;
quarterly.Trend = estimated.seriesQ.Trend;
quarterly.Irregular = estimated.seriesQ.Irregular;
quarterly.GDP = estimated.seriesQ.GDP;

% Write quarterly data to xlsx file
writetable(quarterly, xlsxFilename, ...
   'WriteRowNames', false, ...
   'Sheet', 'quarterly_data');

%% Clean up sheets and add formatting
warning on 'MATLAB:xlswrite:AddSheet'
xlsxFile = cbd.xlsfile(xlsxFilename);
xlsxFile.wkBook.Sheets.Item(1).Delete();

% Define sheets
keySheet = xlsxFile.wkBook.Sheets.Item(1);
monthlySheet = xlsxFile.wkBook.Sheets.Item(2);
quarterSheet = xlsxFile.wkBook.Sheets.Item(3);

% Format the "key" tab
keySheet.Range('A1:A1').Font.Size = 14;
keySheet.Range('A1:A2').Font.FontStyle = 'Bold';
keySheet.Range('B2:B2').Font.FontStyle = 'Bold';
keySheet.Range('B1:B1').Font.FontStyle = 'Italic';
keySheet.Range('A3:A4').Font.FontStyle = 'Bold';
keySheet.Range('A10:A10').Font.FontStyle = 'Bold';
keySheet.Range('A:A').ColumnWidth = 20;
keySheet.Range('B:B').ColumnWidth = 88;
keySheet.Range('A2:B2').Borders.Item('xlEdgeTop').LineStyle = 12;
keySheet.Range('A2:B2').Borders.Item('xlEdgeBottom').LineStyle = 1;
keySheet.Range('A10:B10').Borders.Item('xlEdgeBottom').LineStyle = 1;
keySheet.Range('A4:B4').Borders.Item('xlEdgeBottom').LineStyle = 1;
keySheet.Range('B3:B10').WrapText = 1;
keySheet.Range('A3:B10').VerticalAlignment = 1;
keySheet.Range('A6:A7').IndentLevel = 2;
keySheet.Range('A11:B11').MergeCells = 1;
keySheet.Range('A14:B14').MergeCells = 1;
keySheet.Range('A15:B15').MergeCells = 1;
keySheet.Range('A11:A11').WrapText = 1;
keySheet.Range('A14:B15').WrapText = 1;
keySheet.Range('A11:B15').HorizontalAlignment = 2;
keySheet.Range('A14:B15').IndentLevel = 1;
keySheet.Range('A11:B11').RowHeight = 36;
keySheet.Range('A14:B14').RowHeight = 24;
keySheet.Range('A15:B15').RowHeight = 26;
keySheet.Range('A11:B15').Font.Size = 8;
keySheet.Range('A2:B10').Font.Size = 10;
keySheet.Range('A1:B1').RowHeight = 30;

% Number formatting
monthlySheet.Range('A1:I1').Font.FontStyle = 'Bold';
quarterSheet.Range('A1:I1').Font.FontStyle = 'Bold';
monthlySheet.Range(['A2:A' num2str(1+size(monthly,1))]).NumberFormat = 'mm/YYYY';
monthlySheet.Range(['B2:I' num2str(1+size(monthly,1))]).NumberFormat = '0.00';
quarterSheet.Range(['B2:I' num2str(1+size(quarterly,1))]).NumberFormat = '0.00';

monthlySheet.Range('A1:I1').Borders.Item('xlEdgeBottom').LineStyle = 1;
quarterSheet.Range('A1:I1').Borders.Item('xlEdgeBottom').LineStyle = 1;
monthlySheet.Range(['B1:B' num2str(1+size(monthly,1))]).Borders.Item('xlEdgeLeft').LineStyle = 1;
monthlySheet.Range(['D1:D' num2str(1+size(monthly,1))]).Borders.Item('xlEdgeLeft').LineStyle = 1;
quarterSheet.Range(['B1:B' num2str(1+size(quarterly,1))]).Borders.Item('xlEdgeLeft').LineStyle = 1;
quarterSheet.Range(['D1:D' num2str(1+size(quarterly,1))]).Borders.Item('xlEdgeLeft').LineStyle = 1;

monthlySheet.Range(['B1:I' num2str(1+size(monthly,1))]).HorizontalAlignment = 3;
quarterSheet.Range(['B1:I' num2str(1+size(quarterly,1))]).HorizontalAlignment = 3;

% Here we are going to freeze the panes

% Monthly sheet
monthlySheet.Activate;
monthlySheet.Range('B2').Select();
monthlySheet.Application.ActiveWindow.FreezePanes = 1;

% Quarterly Sheet
quarterSheet.Activate;
quarterSheet.Range('B2').Select();
quarterSheet.Application.ActiveWindow.FreezePanes = 1;

% Now reactivate the key sheet
keySheet.Activate;

% Sanitize
keySheet.Range('A1').Select();
xlsxFile.wkBook.RemoveDocumentInformation(99);

% This line sets the "SaveLinkValues" to "false"
xlsxFile.wkBook.SaveLinkValues = 0;
   
% Save and close
xlsxFile.wkBook.Save()
xlsxFile.close();

end





















