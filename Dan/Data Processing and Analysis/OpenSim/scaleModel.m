% This script will create a setup for OpenSim scaling, and will also
% run the scaling tool to create a scaled model. 
% Created by JLA Feb 2020
% Modified HDM Feb 2020 
% % could make a function?

clear
home

%---------------------%
%------USER INPUT----
%---------------------%

subjectName = 'YAUSPercep10';
calName = 'Cal01';
subjectMass = 64.9;
handPickFiles = 1; 
modelFileNameOut = ['3DGaitModel2392-scaled-' subjectName '-' calName '.osim'];
scaleOutputFileName = strrep(modelFileNameOut, 'osim', 'xml');
fileOutLocation = ['G:\Shared drives\Perception Project\Ultrasound\OpenSim\' subjectName '\Scaled Model\'];
%---------------------%
%------LOAD DATA------%
%---------------------%

import org.opensim.modeling.*

if ispc    
%     startPath = 'G:\My Drive\Research\AgingPilotsAnalysis\OpenSim\Practice\YAPilot15\';
%     startPath = 'C:\Users\Hannah\Documents\GitHub\NeuroMobLab_Allen\AgingProject\OpenSim\templateFiles\';   % laptop
% startPath = 'D:\Research\repos\OpenSim\GeneralCode\templateFiles\';                               % office pc
startPath = 'G:\Shared drives\NeuroMobLab\Projects\Perception\Processed Data\Dan\OpenSim\YAPercep Outputs\XML and Model\'; % Dan OpenSim Files
elseif ismac
	% to do
end

if handPickFiles
    % Get and operate on the files
    % Choose a generic setup file to work from
    fprintf('Pick SetupScale_Perception for any trial that has C7 in it.\n Otherwise pick SetupScale_Perception_NoC7 \n');
    [genericSetupForScale,genericSetupPath,FilterIndex] = ...
        uigetfile('*.xml','Pick the a generic setup file to for this subject/model as a basis for changes.',[startPath]);
        
    % Get the model
    [modelFile,modelFilePath,FilterIndex] = ...
        uigetfile('*.osim','Pick the the model file to be used.', startPath);    
    
    % Get the markerset
    [markerSetFile,markerSetPath,FilterIndex] = ...
    uigetfile('*.xml','Pick the marker set file for scaling.',[startPath]);

    
       
else
    
    % setup file stuff
    genericSetupForScale = 'SetupScale.xml';
    genericSetupPath = [startPath 'GenericModelAndSetupFiles' filesep];
    
    % model stuff, from gait2392 model
%     modelFilePath = [startPath 'GenericModelAndSetupFiles' filesep];
%     modelFile = 'gait2392_simbody.osim';
    modelFilePath = 'G:\My Drive\Research\AgingPilotsAnalysis\OpenSim\MocoTesting\';
    modelFile = 'gait2392_Moco.osim';

    
    % get marker set
    markerSetPath = [startPath 'GenericModelAndSetupFiles' filesep];
    markerSetFile = 'OSIM_Scale_MarkerSet.xml';
    
    
end

% set up the scale tool
scaleTool = ScaleTool([genericSetupPath genericSetupForScale]);

% Load the model and initialize
model = Model(fullfile(modelFilePath, modelFile));
model.initSystem();



% get the marker file
[markerFile, markerFilePath, FilterIndex] = ...
    uigetfile('*.trc','Pick the marker file for scaling (usually StaticCal).', ['G:\Shared drives\Perception Project\Ultrasound\OpenSim\' subjectName]);
% load marker data from file
markerData = MarkerData(fullfile(markerFilePath,markerFile));
name = regexprep(markerFile,'.trc','');
% Get initial and intial time and store in TimeArray
initial_time = markerData.getStartFrameTime();
final_time = markerData.getLastFrameTime();
TimeArray = ArrayDouble();
TimeArray.set(0,initial_time);
TimeArray.set(1,final_time);

% create location to save files
% fileOutLocation = regexprep(markerFilePath, 'MarkerAndGRFDataFiles','modelAndSetupFiles');
% if ~exist(fileOutLocation, 'dir')
%   mkdir(fileOutLocation)
% end
% keyboard
%----------------------------------------%
%------SETUP SCALE OPTIONS AND INFO------%
%----------------------------------------%
scaleTool.setName(subjectName);
scaleTool.setPrintResultFiles(true);
% since all file locations include the full filepath, need to set the
% "pathToSubject" to be empty
scaleTool.setPathToSubject('')
% set subject mass
scaleTool.setSubjectMass(subjectMass); 
% set ModelFile and MarkerSet
scaleTool.getGenericModelMaker().setModelFileName(fullfile(modelFilePath, modelFile));
scaleTool.getGenericModelMaker().setMarkerSetFileName(fullfile(markerSetPath, markerSetFile));

% setup for the ModelScaler
scaleTool.getModelScaler().setApply(true);
scaleTool.getModelScaler().setPreserveMassDist(true);
scaleTool.getModelScaler().setMarkerFileName(fullfile(markerFilePath, markerFile)); % trc file for measurements
% scaleTool.getModelScaler().setOutputModelFileName(fullfile(fileOutLocation, [subjectName '_scaled.osim'])); %output scaled osim file
% scaleTool.getModelScaler().setOutputScaleFileName(fullfile(fileOutLocation,[name scaleOutputFileName])); % scale data
scaleTool.getModelScaler().setTimeRange(TimeArray); % set time range for model scaling
% setup for the MarkerPlacer
scaleTool.getMarkerPlacer().setApply(true);
scaleTool.getMarkerPlacer().setMoveModelMarkers(true); % is3Dmodel: set to false for 2D model, true for 3D
scaleTool.getMarkerPlacer().setStaticPoseFileName(fullfile(markerFilePath, markerFile)); % trc for static pose
scaleTool.getMarkerPlacer().setTimeRange(TimeArray); % set time range for static pose
scaleTool.getMarkerPlacer().setOutputModelFileName(fullfile(fileOutLocation, [modelFileNameOut])); %output scaled osim file


%--------------------------------%
%------RUN THE SCALING TOOL------%
%--------------------------------%

% save setupfile
if ispc
    outfile = ['SetupScale_' name '_PC.xml'];
elseif ismac
    % to do
end

scaleTool.print(fullfile(fileOutLocation, outfile));

% run scaling
scaleTool.run();

disp('scaling - done')
