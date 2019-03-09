function ColorImagePriorsLocalHook
% ColorImagePriors
%
% Configure things for working on the LightnessPopCode project.
%
% For use with the ToolboxToolbox.  If you copy this into your
% ToolboxToolbox localToolboxHooks directory (by defalut,
% ~/localToolboxHooks) and delete "LocalHooksTemplate" from the filename,
% this will get run when you execute tbUseProject('LightnessPopCode') to set up for
% this project.  You then edit your local copy to match your configuration.
%
% You will need to edit the project location and i/o directory locations
% to match what is true on your computer.

%% Say hello
fprintf('Running ColorImagePriors local hook\n');
sysInfo = GetComputerInfo();
%% Specify project name and location
projectName = 'ColorImagePriors';
if (ispref(projectName))
    rmpref(projectName);
end

%% Specify base paths for materials and data
[~, userID] = system('whoami');
userID = strtrim(userID);
switch userID
    case {'dhb'}
        baseDir = '/Users1/Users1Shared/Matlab/Analysis/ColorImagePriors';    
    otherwise
        baseDir = ['/Users/' sysInfo.userShortName '/Dropbox (Aguirre-Brainard Lab)'];
end

%% Set the preferences
setpref(projectName,'dataDir',fullfile(baseDir,'IBIO_Analysis','ISETImagePipeline'));




