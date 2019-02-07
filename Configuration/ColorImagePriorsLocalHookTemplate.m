function ColorImagePriorsLocalHookTemplate
% ColorImagePriors
%
%
% For use with the ToolboxToolbox.  If you copy this into your
% ToolboxToolbox localToolboxHooks directory (by defalut,
% ~/localToolboxHooks) and delete "LocalHooksTemplate" from the filename,
% this will get run when you execute tbUseProject('ColorImagePriors') to set up for
% this project.  You then edit your local copy to match your configuration.
%
% You will need to edit the project location and i/o directory locations
% to match what is true on your computer.


%% Specify project name and location
projectName = 'ColorImagePriors';
projectBaseDir = tbLocateProject('ColorImagePriors');
if (ispref(projectName))
    rmpref(projectName);
end

%% Specify base paths for materials and data
[~, userID] = system('whoami');
userID = strtrim(userID);
sysInfo = GetComputerInfo();
switch userID
    case {'dhb'}
        baseDir = '/Users1/Users1Shared/Matlab/Analysis/ColorImagePriors';
    otherwise
        baseDir = ['/Users/' sysInfo.userShortName '/Dropbox (Aguirre-Brainard Lab)'];
end

%% Set the preferences
setpref(projectName,'trainingDataDir',fullfile(baseDir,'IBIO_Analysis','ISETImagePipeline'));




