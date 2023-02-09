function batchIKnBAprocessingOS_US(strSubject, markerOps)
% 
%  batchIKprocessingOS(Subject ID)
%   This function will create the inverse kinematics files and run
%   the analysis outputs for openSim processing
%   for both the CoM calcualtions. This will do
%   so by scripting in Matlab so there is no need to go through the GUI. 
% 
% Inputs: stringSubject: Character or string matrix of the subjects ID
% number
% 
% 
% Outputs: This file does not have any outputs to Matlab, but does save
%       IKresults files, bodykinematic analysis results, and muscle analysis
%       result files.
% 
% Created: 12/22/2021 (DJL)
% Modified: 
% 
% 
%% Connect to OpenSim

% Load OpenSim libs 
import org.opensim.modeling.*

% Get paths of where you want the files to be saved from the IK Results and
% Analysis models.
if ispc    
    startPath = ['G:\Shared drives\Perception Project\Ultrasound\OpenSim\YAUSPercep' strSubject '\'];
%     startPath = 'G:\My Drive\MotionAnalysisLabData\OSIM Files\';
elseif ismac
%     startPath = 'G:\My Drive\MotionAnalysisLabData\OSIM Files\';
end


%% This section will load the data by picking the folders where the trc and mot files, setup files for IK, and the scaled model for the subject.
%---------------------%
%------LOAD DATA------%
%---------------------%

% Go to the folder in the subject's folder where .trc files are
% trc_data_folder = uigetdir(startPath, 'Select the folder that contains the marker data files in .trc format.');
trc_data_folder = ['G:\Shared drives\Perception Project\Ultrasound\OpenSim\YAUSPercep' strSubject '\MarkerAndGRFDataFiles\'];

% set up where results will be printed
replaceString = 'IKResults and Analysis Output'; 

results_folder = regexprep(trc_data_folder,'MarkerAndGRFDataFiles',replaceString);
if ~exist(results_folder, 'dir')
  mkdir(results_folder)
end


% Get and operate on the files
% Choose a generic setup file to work from
% Want to choose the file that has all the markers in it
% [genericSetupForIK,genericSetupPath,FilterIndex] = ...
%     uigetfile('*.xml','Pick the a generic setup file to for this subject/model as a basis for changes.',[startPath 'Calibration' filesep]);

if markerOps == 0
    % This file is for all markers 
    genericSetupForIK = 'G:\Shared drives\NeuroMobLab\Projects\Perception\Processed Data\Dan\OpenSim\YAPercep Outputs\XML and Model\IK setup Files\SetupIK.xml';
    genericSetupPath = [startPath 'Calibration' filesep];

elseif markerOps == 1

    % This file is for C7 only 
    genericSetupForIK = 'G:\Shared drives\NeuroMobLab\Projects\Perception\Processed Data\Dan\OpenSim\YAPercep Outputs\XML and Model\IK setup Files\SetupIK_C7only.xml';
    genericSetupPath = [startPath 'Calibration' filesep];

elseif markerOps == 2
    % This file is for clav only 
    genericSetupForIK = 'G:\Shared drives\NeuroMobLab\Projects\Perception\Processed Data\Dan\OpenSim\YAPercep Outputs\XML and Model\IK setup Files\SetupIK_CLAVonly.xml';
    genericSetupPath = [startPath 'Calibration' filesep];

else
    [genericSetupForIK,genericSetupPath,FilterIndex] = uigetfile('*.xml','Pick the a generic setup file to for this subject/model as a basis for changes.',[startPath 'Calibration' filesep]);
end
ikTool = InverseKinematicsTool(genericSetupForIK);

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
% This is the scaled model for the subject 
modelFilePath = [startPath 'Scaled Model'];
% modelFilePath = 'G:\Shared drives\NeuroMobLab\Projects\Perception\Processed Data\Dan\OpenSim\YAPercep Outputs\YAPercep05\TestScale\';
temp = dir(modelFilePath);
modelFile = temp(3).name;
% [modelFile,modelFilePath,FilterIndex] = ...
%     uigetfile('*.osim','Pick the the scaled model file to be used.', [startPath 'Scaled Model']);

% Load the model and initialize
model = Model(fullfile(modelFilePath, modelFile));
model.initSystem();

% Tell Tool to use the loaded model
ikTool.setModel(model);

trialsForIK = dir(fullfile(trc_data_folder, '*.trc'));

nTrials = size(trialsForIK);

% % Loop through the trials
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
%     outfile = ['Setup_IK_' name '.xml'];
%     ikTool.print(fullfile(setupfolder, outfile));
    
    fprintf(['Performing IK on ' markerFile '\n']);
    % Run IK
    ikTool.run();

end


%% Running the Body kinematics and Muscle analysis for OpenSim calculations
% Getting the setup file for analysis 
% [genericSetupForAnalysis,genericSetupPathAnalysis,FilterIndex] = ...
%     uigetfile('*.xml','Pick the a generic setup file to for this subject/model as a basis for analysis.',[startPath 'AnalyzeSetUp' filesep]);
genericSetupForAnalysis = 'G:\Shared drives\NeuroMobLab\Projects\Perception\Processed Data\Dan\OpenSim\YAPercep Outputs\XML and Model\BodyAnalysis setup Files\MA_BKSetup.xml';


% get the file names that match the ik_reults convention
% this is where consistent naming conventions pay off
trialsForAn = dir(fullfile(results_folder, '*_ik.mot'));
nTrials =length(trialsForAn);

% Loop through the trials
for trial= 1:nTrials
    
    % Get the name of the file for this trial
    resultsFile = trialsForAn(trial).name;
    
    % Create name of trial from .trc file name
    name = regexprep(resultsFile,'.mot','');
    fullpath = fullfile(results_folder, resultsFile);
    
    % Get mot data to determine time range
    IKresultsData = Storage(fullpath);
    
    % Get initial and intial time 
    initial_time = IKresultsData.getFirstTime();
    final_time = IKresultsData.getLastTime();
    
    
    % Save the settings in a setup file
    outfile = ['Setup_Analysis_' name '.xml'];
    
    
    updatedBKXml = [startPath 'AnalyzeSetUp' filesep name];
    Osim.editSetupXML(genericSetupForAnalysis, ...
        'model_file', [modelFilePath filesep modelFile], 'results_directory', results_folder,...
        'coordinates_file', fullpath, 'FilePath', updatedBKXml);
    xmltemp = xmlread(updatedBKXml);
    xmltemp.getElementsByTagName('AnalyzeTool').item(0).setAttribute('name', name);
    xmlwrite(updatedBKXml, xmltemp);
    analysis = AnalyzeTool(updatedBKXml);
    % Set up rest of analysis tool
%     analysis.setName(name);
%     analysis.setModel(model);
    analysis.setInitialTime(initial_time);
    analysis.setFinalTime(final_time);
%     analysis.setLowpassCutoffFrequency(6); %Filtering data at 6 Hz
%     analysis.setCoordinatesFileName(fullpath);
    analysis.setLoadModelAndInput(true);
    analysis.setResultsDir(results_folder);
    % printing the set up file for analysis
%     analysis.printResults(fullfile([startPath 'AnalyzeSetUp' filesep], outfile));
    
    fprintf(['Performing Analysis on ' name '\n']);
    % Run Analysis
    
    analysis.run();

end


disp(['Finished processing for subject ' strSubject]);

end

