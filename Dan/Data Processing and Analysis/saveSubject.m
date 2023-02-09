function  saveSubject(strSubject)
% saveSubject(strSubject)
%   This function will load all the tables created throughout the
%   processing and save the workspace. This will have every table that has
%   been created. This information has everything from MoCap, IK,
%   BodyAnalysis, Perturbation information, GaitEvents, Joint Angles,
%   Spatiotemporal parameters, and dynamic Stability parameters. 
% INPUTS: strSubject               - a string of the subjects unique identifier for the
%                                   Perception study.
%
% OUPUT: This function has no direct output but the workspace with all the
% subjects tables will be saved under -> 
% G:\Shared drives\NeuroMobLab\Projects\Perception\Processed Data\Dan\Full Sub Data
%
% Created: 8 December 2021, DJL
% Modified: (format: date, initials, change made)
%   1 - 
% 
% 
% 
% 
% 


%%%%%%%%%%%%%%%% THINGS THAT STILL NEED TO BE ADDED %%%%%%%%%%%%%%%%%%%%%%
% 1 - 


%% Create subject name to load the necessary files for the subject 
% Naming convention for each log file "YAPercep##_" + YesNo or 2AFC or Cog

subject1 = ['YAPercep' strSubject];

%% Loading all the data tables for the subject 

% Video, analog, and gaitEventTable ## All the information from Vicon
% placed into tables 
load(['G:\Shared drives\NeuroMobLab\Projects\Perception\Processed Data\Dan\Matlab Analysis\' subject1 '\Data Tables\SepTables_' subject1 '.mat'])

% PertCycleStructure ## This should not be needed once the processes for
% the new pertTables has been determined 
load(['G:\Shared drives\NeuroMobLab\Projects\Perception\Processed Data\Dan\Matlab Analysis\' subject1 '\Data Tables\pertCycleStruc_' subject1 '.mat'])

% PertTable ## All the information about the perturbations sent 
load(['G:\Shared drives\NeuroMobLab\Projects\Perception\Processed Data\Dan\Matlab Analysis\' subject1 '\Data Tables\pertTable_' subject1 '.mat'])

% GCTables ## Table that includes all perturbation information in regards
% to all the gaitcycles for all trials 
load(['G:\Shared drives\NeuroMobLab\Projects\Perception\Processed Data\Dan\Matlab Analysis\' subject1 '\Data Tables\GCTables_' subject1 '.mat'])

% BodyAnalysis Table ## IK and bodyanalysis results 
load(['G:\Shared drives\NeuroMobLab\Projects\Perception\Processed Data\Dan\OpenSim\YAPercep Outputs\' subject1 '\Data Tables\BodyAnalysisTable_' subject1 '.mat'])

% HeadCalcStruc ## Head angle, velocity and acceleration 
load(['G:\Shared drives\NeuroMobLab\Projects\Perception\Processed Data\Dan\OpenSim\YAPercep Outputs\' subject1 '\Data Tables\headCalcStruc_' subject1 '.mat'])

% EMG Table ## npEmgStruct pEmgStruct
% load(['G:\Shared drives\NeuroMobLab\Projects\Perception\Processed Data\Dan\Matlab Analysis\' subject1 '\Data Tables\pEmgStruct_' subject1 '.mat'])

% Joint Angles Table ## Joint angles for the subject (i.e. Ankle, Hip,
% knee)
load(['G:\Shared drives\NeuroMobLab\Projects\Perception\Processed Data\Dan\OpenSim\YAPercep Outputs\' subject1 '\Data Tables\jointAnglesTable_' subject1 '.mat'])

% SpatiotemporalTable ## Spatiotemp parameters for the subject over all
% trials
load(['G:\Shared drives\NeuroMobLab\Projects\Perception\Processed Data\Dan\OpenSim\YAPercep Outputs\' subject1 '\Data Tables\SpatiotemporalTable_' subject1 '.mat'])


% SegmentsTable ## Position, velocity, acceleration, and angular accelerations for each segment of the subject's model
% # Inertial information is not listed here it's in an excel sheet located
% on the drive under MassAndInertia
load(['G:\Shared drives\NeuroMobLab\Projects\Perception\Processed Data\Dan\OpenSim\YAPercep Outputs\' subject1 '\Data Tables\SegmentsTables_' subject1 '.mat'])

% DyanamicStability Table 
load(['G:\Shared drives\NeuroMobLab\Projects\Perception\Processed Data\Dan\OpenSim\YAPercep Outputs\' subject1 '\Data Tables\dynamicStabilityTable_' subject1 '.mat'])

% translated Inertia Tensor for the subject 
% load(['G:\Shared drives\NeuroMobLab\Projects\Perception\Processed Data\Dan\OpenSim\YAPercep Outputs\' subject1 '\Data Tables\inertiaTensor_' subject1 '.mat']);


%% Saving this workspace for each subject so you can load this instead of loading individual tables 

% Setting the location to save the data tables for each subject 
if ispc
    tabLoc = ['G:\Shared drives\NeuroMobLab\Projects\Perception\Processed Data\Dan\Full Sub Data\'];
elseif ismac
    tabLoc = [''];
else
    tabLoc = input('Please enter the location where the tables should be saved.' ,'s');
end


% Saving the workspace with all tables for each subject. 
save([tabLoc subject1 '_Tables'], '-v7.3');

disp(['Tables saved for ' subject1]);
end

