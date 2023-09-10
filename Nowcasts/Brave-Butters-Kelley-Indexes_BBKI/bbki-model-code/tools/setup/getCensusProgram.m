function exe = getCensusProgram()
% Install Census Bureau's seasonal adjustment executable file.
%
% This function checks to see if the Census program already exists in the
% cbd/+cbd/+private/+sax13/exe/ folder. If not, the file is downloaded and
% saved. The function "InstallMissingCensusProgram.m" is supposed to do
% this, however, the structure of the Census' website has since changed,
% which results in an error. 
%
% Ross Cole, 2022

% Download archive to temporary directory
filename = fullfile( 'winx13-v3.0.zip');
url = 'https://www2.census.gov/software/x-13arima-seats/win-x-13/download/winx13-v3.0.zip';
websave(filename, url);
unzip(filename, tempdir);

% Copy executable file to cbd/+cbd/+private/+sax13/exe
exeDir = fullfile(pwd, 'tools', 'cbd', '+cbd', '+private', '+sax13', 'exe');
if exist(exeDir, 'dir') ~= 7
    mkdir(exeDir);
end

inFile = fullfile(tempdir, 'WinX13', 'x13as', 'x13as.exe');
outFile = fullfile(exeDir, 'x13as.exe');
copyfile(inFile, outFile);
fprintf('\nSAX13 successfully installed to: %s\n', fullfile(exeDir, 'x13as.exe'));

end
