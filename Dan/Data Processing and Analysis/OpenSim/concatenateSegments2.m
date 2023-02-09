
function [posSegmentsTable, velSegmentsTable, accSegmentsTable] = concatenateSegments2(strSubject,numTrials,numTreadmillTrials)
%[posSegmentsTable, velSegmentsTable, accSegmentsTable, angVelSegmentsTable] = concatenateSegments(strSubject,numTrials,numTreadmillTrials)
%
% This function will concatenate all the openSim data needed for dynamic
% stability calculations. Position, velocity, angular velocity, and
% acceleration values calculated from OpenSim's BodyAnalysis process.
% 
% INPUTS: strSubject               - a string of the subjects unique identifier for the
%                                   Perception study.
%         numTrials             - number (double) of whole perception trials (Should be 4,
%                                   but may be more or less depending on if recording was messed up)
%         numTreamillTrials     - number (double) of treadmill trials (Should be 2-3,
%                                   but may be more depending on if recording was messed up)
%
% OUPUT: posSegmentsTable       - a table that has the processed body analysis OpenSim data for all trials the subject
%                                 participated in during the experiment.
%                                 This table has all the position data for
%                                 the segments listed below. For each
%                                 segment is a nX3 for X-Y-Z. 
%                                 The data is concatenated for all subtrials
%                                 in this table includes: time, CoM position (X, Y, Z), Torso, Pelvis, Femur_r, Tibia_r, Talus_r, Calcn_r, Toes_r, Femur_l,
%                                 Tibia_l, Talus_l, Calcn_l, Toes_l and the
%                                 corresponding orientations.
%
%
%       velSegmentsTable        - a table that has the processed body analysis OpenSim data for all trials the subject
%                                 participated in during the experiment.
%                                 This table has all the linear velocity data for
%                                 the segments listed below. For each
%                                 segment is a nX3 for X-Y-Z. 
%                                 The data is concatenated for all subtrials
%                                 in this table includes: time, CoM position (X, Y, Z), Torso, Pelvis, Femur_r, Tibia_r, Talus_r, Calcn_r, Toes_r, Femur_l,
%                                 Tibia_l, Talus_l, Calcn_l, Toes_l and the
%                                 corresponding angular velocities.
%
%
%       accSegmentsTable        - a table that has the processed body analysis OpenSim data for all trials the subject
%                                 participated in during the experiment.
%                                 This table has all the acceleration data for
%                                 the segments listed below. For each
%                                 segment is a nX3 for X-Y-Z. 
%                                 The data is concatenated for all subtrials
%                                 in this table includes: time, CoM (X, Y, Z), Torso, Pelvis, Femur_r, Tibia_r, Talus_r, Calcn_r, Toes_r, Femur_l,
%                                 Tibia_l, Talus_l, Calcn_l, Toes_land the
%                                 corresponding angular accelerations.
%
%
%
%
%
% Created: 9 November 2021, DJL
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


%% Setting the file location based on which computer is running the code
if ispc
    fileLocation = 'G:\Shared drives\NeuroMobLab\Projects\Perception\Processed Data\Dan\OpenSim\YAPercep Outputs';
elseif ismac %################# Need to add the spots for a mac
%     fileLocation = '/Volumes/GoogleDrive/Shared drives/NeuroMobLab/Experimental Data/Vicon Matlab Processed/Pilot Experiments/WVCTSI_Perception2019/';
else
    fileLocation = input('Please enter the file location:' );
end

startLocation = 'D:\Github\Perception-Project\Dan\Data Processing and Analysis\'; %Location where all the functions and matlab scripts are 

IKLoc = [fileLocation filesep subject1 filesep 'IKResults and Analysis Output' filesep]; % Creating new location based on the subject that is being processed for IK data

cd(IKLoc)

%% Finding the locations of the position, velocity, and acceleration body analysis files in the folder

% Create directory of files that need to be loaded for each subject for IK 
IKDir = dir(IKLoc);
IKDir = IKDir(3:end);

% This gives you the indicies of all the open sim data for the position and
% velocity data for IK results. 
for i = 1:size(IKDir,1)
    pos1(i) = contains(IKDir(i).('name'), "_pos_");
	vel1(i) = contains(IKDir(i).('name'), "_vel_");
    acc1(i) = contains(IKDir(i).('name'), "_acc_");
end

% Creating a directory of just the position Body Kinematics files
IKposDir = IKDir(pos1);

% Creating a directory of the velocity Body Kinematics files
IKvelDir = IKDir(vel1);

% Creating a directory of the accelerations Body Kinematics files 
IKaccDir = IKDir(acc1); 

%% This section will determine what files need to be loaded and placed together 
% This loop finds the indicies of the position table of the subsections of
% each perception trial 
for iSubtrials = 1:size(IKposDir,1)
    posA(iSubtrials) = contains(IKposDir(iSubtrials).name, 'Percep01');
    posB(iSubtrials) = contains(IKposDir(iSubtrials).name, 'Percep02');
    posC(iSubtrials) = contains(IKposDir(iSubtrials).name, 'Percep03');
    posD(iSubtrials) = contains(IKposDir(iSubtrials).name, 'Percep04');
    posE(iSubtrials) = contains(IKposDir(iSubtrials).name, 'Percep05');
    posF(iSubtrials) = contains(IKposDir(iSubtrials).name, 'Percep06');
    posG(iSubtrials) = contains(IKposDir(iSubtrials).name, 'Percep07');
    posH(iSubtrials) = contains(IKposDir(iSubtrials).name, 'Percep08');
end

if numTrials <= 5 
    posA = find(posA == 1); % Indicies for Percep01 in the posTable
    posB = find(posB == 1); % Indicies for Percep02 in the posTable
    posC = find(posC == 1); % Indicies for Percep03 in the posTable
    posD = find(posD == 1); % Indicies for Percep04 in the posTable
    posE = find(posE == 1);
else % Need to figure out how to adjust for more trials IE if there are bad trials and we recorded up through Percep06 or something 
end

% This loop finds the indicies of the velocity table of the subsections of
% each perception trial 
for iSubtrials = 1:size(IKvelDir,1)
    velA(iSubtrials) = contains(IKvelDir(iSubtrials).name, 'Percep01');
    velB(iSubtrials) = contains(IKvelDir(iSubtrials).name, 'Percep02');
    velC(iSubtrials) = contains(IKvelDir(iSubtrials).name, 'Percep03');
    velD(iSubtrials) = contains(IKvelDir(iSubtrials).name, 'Percep04');
    velE(iSubtrials) = contains(IKvelDir(iSubtrials).name, 'Percep05');
    velF(iSubtrials) = contains(IKvelDir(iSubtrials).name, 'Percep06');
    velG(iSubtrials) = contains(IKvelDir(iSubtrials).name, 'Percep07');
    velH(iSubtrials) = contains(IKvelDir(iSubtrials).name, 'Percep08');
end

if numTrials <= 5 
    velA = find(velA == 1); % Indicies for Percep01 in the velTable
    velB = find(velB == 1); % Indicies for Percep02 in the velTable
    velC = find(velC == 1); % Indicies for Percep03 in the velTable
    velD = find(velD == 1); % Indicies for Percep04 in the velTable
    velE = find(velE == 1); 
else % Need to figure out how to adjust for more trials IE if there are bad trials and we recorded up through Percep06 or something 
end

% This loop finds the indicies of the velocity table of the subsections of
% each perception trial 
for iSubtrials = 1:size(IKaccDir,1)
    accA(iSubtrials) = contains(IKaccDir(iSubtrials).name, 'Percep01');
    accB(iSubtrials) = contains(IKaccDir(iSubtrials).name, 'Percep02');
    accC(iSubtrials) = contains(IKaccDir(iSubtrials).name, 'Percep03');
    accD(iSubtrials) = contains(IKaccDir(iSubtrials).name, 'Percep04');
    accE(iSubtrials) = contains(IKaccDir(iSubtrials).name, 'Percep05');
    accF(iSubtrials) = contains(IKaccDir(iSubtrials).name, 'Percep06');
    accG(iSubtrials) = contains(IKaccDir(iSubtrials).name, 'Percep07');
    accH(iSubtrials) = contains(IKaccDir(iSubtrials).name, 'Percep08');
end

if numTrials <= 5 
    accA = find(accA == 1); % Indicies for Percep01 in the velTable
    accB = find(accB == 1); % Indicies for Percep02 in the velTable
    accC = find(accC == 1); % Indicies for Percep03 in the velTable
    accD = find(accD == 1); % Indicies for Percep04 in the velTable
    accE = find(accE == 1); 
else % Need to figure out how to adjust for more trials IE if there are bad trials and we recorded up through Percep06 or something 
end

% Combining all the subtrials of position to one matrix 
idxPos = {posA; posB; posC; posD; posE};

% Combining all the indicies of the velocity to one matrix
idxVel = {velA; velB; velC; velD; velE};

% Combining all the indices of the acceleration to one matrix
idxAcc = {accA; accB; accC; accD; accE};

%% Creating names for the tables 
% Preallocated names to pull from later in loops for Treadmill Trials 
nameTreadmill = {'Treadmill01'; 'Treadmill02'; 'Treadmill03'; 'Treadmill04'; 'Treadmill05'; 'Treadmill06'};

% Preallocated names to pull from later in loops for Perception Trials 
namePercep = {'Percep01'; 'Percep02'; 'Percep03'; 'Percep04'; 'Percep05'; 'Percep06'; 'Percep07'; 'Percep08';}; %


%% Looping and saving the data into structures for Perception trials 

for iTrial = 1:numTrials % This loops for all the subjects Perception trials
    for iSubtrials = 1:size(idxPos{iTrial},2) % This loops through each of the sub segements that were broken up in vicon for each perception trial
        [tempPos] = Osim.readSTO([IKposDir(idxPos{iTrial}(iSubtrials)).name]); % This function makes a Table of all the position values from a subjects .sto file 
        [tempVel] = Osim.readSTO([IKvelDir(idxVel{iTrial}(iSubtrials)).name]); % This function makes a Table of all the Velocity values from a subjects .sto file 
        [tempAcc] = Osim.readSTO([IKaccDir(idxAcc{iTrial}(iSubtrials)).name]); % This function makes a Table of all the position values from a subjects .sto file 
        if iSubtrials ~= 1 % Concatenating the data back into 1 single table stored in a structure for now 
            posTempTab.(namePercep{iTrial}) = [posTempTab.(namePercep{iTrial}); tempPos(2:end,:)];
            velTempTab.(namePercep{iTrial}) = [velTempTab.(namePercep{iTrial}); tempVel(2:end,:)];
            accTempTab.(namePercep{iTrial}) = [accTempTab.(namePercep{iTrial}); tempAcc(2:end,:)];
        else % Creating the temp structure that all the concatenated data will be in 
            posTempTab.(namePercep{iTrial}) = tempPos;
            velTempTab.(namePercep{iTrial}) = tempVel;
            accTempTab.(namePercep{iTrial}) = tempAcc;
        end
    end  
end

% This loop finds the indicies of the position CoM table of the subsections of
% each perception trial 
for iTreadtrials = 1:size(IKposDir,1)
    A(iTreadtrials) = contains(IKposDir(iTreadtrials).name, 'Treadmill');
end

if numTreadmillTrials <= 4 
    Tread1 = find(A == 1); % Indicies for Treadmill trials in the trialTable
else                                                                    % Need to figure out how to adjust for more trials IE if there are bad trials and we recorded up through Percep06 or something 
end

% Adding the treadmill trials to the temporary structure 
for iTrial = 1:size(Tread1,2)
    [tempPos] = Osim.readSTO([IKposDir(Tread1(iTrial)).name]); % This function makes a Table of all the position values from a subjects .sto file 
    [tempVel] = Osim.readSTO([IKvelDir(Tread1(iTrial)).name]); % This function makes a Table of all the Velocity values from a subjects .sto file 
    [tempAcc] = Osim.readSTO([IKaccDir(Tread1(iTrial)).name]); % This function makes a Table of all the position values from a subjects .sto file 
    posTempTab.(nameTreadmill{iTrial}) = tempPos;
    velTempTab.(nameTreadmill{iTrial}) = tempVel;
    accTempTab.(nameTreadmill{iTrial}) = tempAcc;  
    clear tempPos tempVel tempAcc
end


% Creating the tables that will be used in WBAM 
posSegmentsTemp =size(posTempTab.Percep02,2);
posSegmentsEmpty=cell(size(fieldnames(posTempTab),1),posSegmentsTemp);
posSegmentsTable = cell2table(posSegmentsEmpty,'VariableNames',posTempTab.Percep02.Properties.VariableNames);
posSegmentsTable.Properties.VariableNames{1} = 'Trial';
velSegmentsTable = posSegmentsTable; 
accSegmentsTable = posSegmentsTable; 

% Segment names for the model used for all Perception study subject
% Model gait2392 
segName = {'pelvis'; 'femur_r'; 'tibia_r'; 'talus_r'; 'calcn_r'; 'toes_r'; ...
    'femur_l'; 'tibia_l'; 'talus_l'; 'calcn_l'; 'toes_l'; 'torso';...
    'center_of_mass'};

% Trial names for all the trials the subject participated in for the study
trialNames = fieldnames(posTempTab);
%%

for iTrial = 1:size(fieldnames(posTempTab),1)
    posSegmentsTable.Trial{iTrial} = trialNames{iTrial}; 
    velSegmentsTable.Trial{iTrial} = trialNames{iTrial};
    accSegmentsTable.Trial{iTrial} = trialNames{iTrial};
    for iSeg = 1:size(segName,1)
        % Placing the values for the posSegments table (all the positions
        % and orientations 
        posSegmentsTable.([segName{iSeg} '_X']){iTrial} = posTempTab.(trialNames{iTrial}).([segName{iSeg} '_X']);
        posSegmentsTable.([segName{iSeg} '_Y']){iTrial} = posTempTab.(trialNames{iTrial}).([segName{iSeg} '_Y']);
        posSegmentsTable.([segName{iSeg} '_Z']){iTrial} = posTempTab.(trialNames{iTrial}).([segName{iSeg} '_Z']);
    
        if iSeg ~= 13
            posSegmentsTable.([segName{iSeg} '_Ox']){iTrial} = posTempTab.(trialNames{iTrial}).([segName{iSeg} '_Ox']);
            posSegmentsTable.([segName{iSeg} '_Oy']){iTrial} = posTempTab.(trialNames{iTrial}).([segName{iSeg} '_Oy']);
            posSegmentsTable.([segName{iSeg} '_Oz']){iTrial} = posTempTab.(trialNames{iTrial}).([segName{iSeg} '_Oz']);
        end
        % Placing the values for the velSegments table (all the velocities
        % and angular velocities) 
        velSegmentsTable.([segName{iSeg} '_X']){iTrial} = velTempTab.(trialNames{iTrial}).([segName{iSeg} '_X']);
        velSegmentsTable.([segName{iSeg} '_Y']){iTrial} = velTempTab.(trialNames{iTrial}).([segName{iSeg} '_Y']);
        velSegmentsTable.([segName{iSeg} '_Z']){iTrial} = velTempTab.(trialNames{iTrial}).([segName{iSeg} '_Z']);
        
        if iSeg ~= 13
            velSegmentsTable.([segName{iSeg} '_Ox']){iTrial} = velTempTab.(trialNames{iTrial}).([segName{iSeg} '_Ox']);
            velSegmentsTable.([segName{iSeg} '_Oy']){iTrial} = velTempTab.(trialNames{iTrial}).([segName{iSeg} '_Oy']);
            velSegmentsTable.([segName{iSeg} '_Oz']){iTrial} = velTempTab.(trialNames{iTrial}).([segName{iSeg} '_Oz']);
        end
        % Placing the values for the velSegments table (all the velocities
        % and angular velocities) 
        accSegmentsTable.([segName{iSeg} '_X']){iTrial} = accTempTab.(trialNames{iTrial}).([segName{iSeg} '_X']);
        accSegmentsTable.([segName{iSeg} '_Y']){iTrial} = accTempTab.(trialNames{iTrial}).([segName{iSeg} '_Y']);
        accSegmentsTable.([segName{iSeg} '_Z']){iTrial} = accTempTab.(trialNames{iTrial}).([segName{iSeg} '_Z']);
        if iSeg ~= 13
        accSegmentsTable.([segName{iSeg} '_Ox']){iTrial} = accTempTab.(trialNames{iTrial}).([segName{iSeg} '_Ox']);
        accSegmentsTable.([segName{iSeg} '_Oy']){iTrial} = accTempTab.(trialNames{iTrial}).([segName{iSeg} '_Oy']);
        accSegmentsTable.([segName{iSeg} '_Oz']){iTrial} = accTempTab.(trialNames{iTrial}).([segName{iSeg} '_Oz']);
        end
        
    end
end

clearvars -except posSegmentsTable velSegmentsTable accSegmentsTable subject1
%% 
% Setting the location to the subjects' data folder 
if ispc
    subLoc = ['G:\Shared drives\NeuroMobLab\Projects\Perception\Processed Data\Dan\OpenSim\YAPercep Outputs\' subject1];
elseif ismac %%%% Need to add the part for a mac 
    subLoc = [''];
else
    subLoc = input('Please enter the location where the tables should be saved.' ,'s');
end


% Checking to see if a data table folder exists for each subject. If it
% does not exist this will create a folder in the correct location. 
if exist([subLoc 'Data Tables'], 'dir') ~= 7
    mkdir(subLoc, 'Data Tables');
end

% Setting the location to save the data tables for each subject 
if ispc
    tabLoc = ['G:\Shared drives\NeuroMobLab\Projects\Perception\Processed Data\Dan\OpenSim\YAPercep Outputs\' subject1 filesep 'Data Tables' filesep];
elseif ismac
    tabLoc = [''];
else
    tabLoc = input('Please enter the location where the tables should be saved.' ,'s');
end


% Saving the position, velocity, acceleration, and angular accelerations table to be saved for each subject. 
save([tabLoc 'SegmentsTables_' subject1], 'posSegmentsTable', 'velSegmentsTable', 'accSegmentsTable', '-v7.3');

disp(['Tables saved for ' subject1]);
    
end

