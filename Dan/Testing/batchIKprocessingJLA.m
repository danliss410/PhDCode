
% This script will ...
% Created by JLA Feb 2020
% Modified HDM Feb 2020
% Modified DJL April 2020
clear

%---------------------%
%------USER INPUT-----%
%---------------------%

handPickFiles = 0; 

% Pull in the modeling classes straight from the OpenSim distribution
import org.opensim.modeling.*

if ispc    
    startPath = 'G:\Shared drives\NeuroMobLab\LabMemberFolders\Dan\Perception Study\OpenSim\YAPercep Outputs\YAPercep11\IK and Analysis Output';
%     startPath = 'G:\My Drive\MotionAnalysisLabData\OSIM Files\';
elseif ismac
%     startPath = 'G:\My Drive\MotionAnalysisLabData\OSIM Files\';
end

%---------------------%
%------LOAD DATA------%
%---------------------%

% Go to the folder in the subject's folder where .trc files are
trc_data_folder = uigetdir(startPath, 'Select the folder that contains the marker data files in .trc format.');

% set up where results will be printed
replaceString = 'IKResults'; 

results_folder = regexprep(trc_data_folder,'MarkerAndGRFDataFiles',replaceString);
if ~exist(results_folder, 'dir')
  mkdir(results_folder)
end

% Get and operate on the files
% Choose a generic setup file to work from
[genericSetupForIK,genericSetupPath,FilterIndex] = ...
    uigetfile('*.xml','Pick the a generic setup file to for this subject/model as a basis for changes.',[startPath 'GenericModelAndSetupFiles' filesep]);
ikTool = InverseKinematicsTool([genericSetupPath genericSetupForIK]);

% set up where IK setup files will be saved
if ispc
setupfolder = [genericSetupPath 'IKSetupFiles_PC' filesep];
elseif ismac
    setupfolder = [genericSetupPath 'IKSetupFiles_mac' filesep];
end
if ~exist(setupfolder, 'dir')
  mkdir(setupfolder)
end

% Get the model
[modelFile,modelFilePath,FilterIndex] = ...
    uigetfile('*.osim','Pick the the model file to be used.',trc_data_folder);

% Load the model and initialize
model = Model(fullfile(modelFilePath, modelFile));
model.initSystem();

% Tell Tool to use the loaded model
ikTool.setModel(model);

trialsForIK = dir(fullfile(trc_data_folder, '*.trc'));

nTrials = size(trialsForIK);

% Loop through the trials
for trial= 1:nTrials
    
    % Get the name of the file for this trial
    markerFile = trialsForIK(trial).name;
    
    % Create name of trial from .trc file name
    name = regexprep(markerFile,'.trc','');
    fullpath = fullfile(trc_data_folder, markerFile);
    
    % Get trc data to determine time range
    markerData = MarkerData(fullpath);
    
    % Get initial and intial time 
    initial_time = markerData.getStartFrameTime();
    final_time = markerData.getLastFrameTime();
    
    % Setup the ikTool for this trial
    ikTool.setName(name);
    ikTool.setMarkerDataFileName(fullpath);
    ikTool.setStartTime(initial_time);
    ikTool.setEndTime(final_time);
    ikTool.setOutputMotionFileName(fullfile(results_folder, [name '_ik.mot']));
    ikTool.setResultsDir(results_folder);
    
    % Save the settings in a setup file
    outfile = ['Setup_IK_' name '.xml'];
    ikTool.print(fullfile(setupfolder, outfile));
    
    fprintf(['Performing IK on' markerFile '\n']);
    % Run IK
    ikTool.run();

end