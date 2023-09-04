function getCBD()
% Install Chartbook Data (CBD) toolbox for time series data management.
% 
% This function downloads CBD from GitHub and saves it in the appropriate
% relative path. The raw archive is first saved to your temporary
% directory, unzipped, and renamed. It is then copied to tools/cbd. The
% seasonal adjustment functions for the BBKI are different from those
% pulled from GitHub, so after adding cbd to the tools folder, two
% functions, sa.m and sa_opt.m, are copied from tools/setup/cbd to
% tools/cbd.
%
% Ross Cole, 2022

% Download CBD zip archive and set up if it doesn't already exist
if exist('tools/cbd', 'dir') ~= 7
    
    % Save CBD archive to temporary directory and unzip
    filename = fullfile(tempdir, 'master.zip');
    url = 'https://github.com/davidakelley/cbd/archive/refs/heads/master.zip';
    websave(filename, url);
    unzip(filename, tempdir);
    
    % Copy to BBK folder
    inFile = strrep(filename, 'master.zip', 'cbd-master');
    outFile = fullfile(pwd, 'tools', 'cbd');
    copyfile(inFile, outFile);
    
    % The current cbd.sa function causes problems. Copy working version
    % from tools folder and cbd.sa_opts function
    copyfile(fullfile('tools', 'setup', 'cbd', 'sa.m'), fullfile('tools', 'cbd', '+cbd', 'sa.m'));
    copyfile(fullfile('tools', 'setup', 'cbd', 'sa_opt.m'), fullfile('tools', 'cbd', '+cbd', 'sa_opt.m'));
    fprintf('\nCBD was successfully installed to: %s\n', fullfile(pwd, 'tools', 'cbd'));

else
    fprintf('\nCBD already installed\n');
end

end
