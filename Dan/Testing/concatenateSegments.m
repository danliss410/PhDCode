
function [posSegmentsTable, velSegmentsTable, accSegmentsTable, angVelSegmentsTable] = concatenateSegments(strSubject,numTrials,numTreadmillTrials)
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
%                                 Tibia_l, Talus_l, Calcn_l, Toes_l.
%
%
%       velSegmentsTable        - a table that has the processed body analysis OpenSim data for all trials the subject
%                                 participated in during the experiment.
%                                 This table has all the linear velocity data for
%                                 the segments listed below. For each
%                                 segment is a nX3 for X-Y-Z. 
%                                 The data is concatenated for all subtrials
%                                 in this table includes: time, CoM position (X, Y, Z), Torso, Pelvis, Femur_r, Tibia_r, Talus_r, Calcn_r, Toes_r, Femur_l,
%                                 Tibia_l, Talus_l, Calcn_l, Toes_l.
%
%
%       accSegmentsTable        - a table that has the processed body analysis OpenSim data for all trials the subject
%                                 participated in during the experiment.
%                                 This table has all the acceleration data for
%                                 the segments listed below. For each
%                                 segment is a nX3 for X-Y-Z. 
%                                 The data is concatenated for all subtrials
%                                 in this table includes: time, CoM (X, Y, Z), Torso, Pelvis, Femur_r, Tibia_r, Talus_r, Calcn_r, Toes_r, Femur_l,
%                                 Tibia_l, Talus_l, Calcn_l, Toes_l.
%
%
%
%       angVelSegmentsTable     - a table that has the processed body analysis OpenSim data for all trials the subject
%                                 participated in during the experiment.
%                                 This table has all the angular velocity data for
%                                 the segments listed below. For each
%                                 segment is a nX3 for X-Y-Z. 
%                                 The data is concatenated for all subtrials
%                                 in this table includes: time, Torso, Pelvis, Femur_r, Tibia_r, Talus_r, Calcn_r, Toes_r, Femur_l,
%                                 Tibia_l, Talus_l, Calcn_l, Toes_l.

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

subjectYesNo = ['YAPercep' strSubject '_YesNo'];

subject2AFC = ['YAPercep' strSubject '_2AFC'];

subjectCog = ['YAPercep' strSubject '_Cog'];

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

IKLoc = [fileLocation filesep subject1 filesep 'Test IKResults and Analysis Output' filesep]; % Creating new location based on the subject that is being processed for IK data

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

%% Running loops to put all the position, velocity, and acceleration data into temporary tables 

% Indices for the position and velocity tables 
% order: Torso, Pelvis, Femur_r, Tibia_r, Talus_r, Calcn_r, Toes_r, Femur_l,
% Tibia_l, Talus_l, Calcn_l, Toes_l
% idxPV = {(68:70); (2:4); (8:10); (14:16); (20:22); (26:28); (32:34);...
%     (38:40); (44:46); (50:52); (56:58); (62:64);};
% Indices for the angular velocity table same order as listed above.
% idxAV = {(71:73); (5:7); (11:13); (17:19); (23:25); (29:31); (35:37);...
%     (41:43); (47:49); (53:55); (59:61); (65:67)};

% Placing all the position data into a temporary table 
for iTrials = 1:length(IKposDir)
    pos = importdata(IKposDir(iTrials).name);
    
    if iTrials == 1 % Creating the table for CoM position based calculations
        posTable1 = table({IKposDir(iTrials).name}, {pos.data(:,1)}, {pos.data(:,74:76)},...
            {pos.data(:,68:70)}, {pos.data(:,2:4)}, {pos.data(:,8:10)},...
            {pos.data(:,14:16)}, {pos.data(:,20:22)}, {pos.data(:,26:28)}, {pos.data(:,32:34)},...
            {pos.data(:,38:40)},{pos.data(:,44:46)}, {pos.data(:,50:52)}, {pos.data(:,56:58)},...
            {pos.data(:,62:64)}, 'VariableNames', {'Trial Name';'Time (s)'; 'CoM'; 'Torso';...
            'Pelvis'; 'r_Femur'; 'r_Tibia'; 'r_Talus'; 'r_Calc'; 'r_Toes'; 'l_Femur'; 'l_Tibia'; 'l_Talus';...
            'l_Calc'; 'l_Toes';});
    else % Filling the table with the remaining values
        posTable1.('Trial Name')(iTrials) = {IKposDir(iTrials).name};
        posTable1.('Time (s)')(iTrials) = {pos.data(:,1)};
        posTable1.('CoM')(iTrials) = {pos.data(:,74:76)};
        posTable1.('Torso')(iTrials) = {pos.data(:,68:70)};
        posTable1.('Pelvis')(iTrials) = {pos.data(:,2:4)};
        posTable1.('r_Femur')(iTrials) = {pos.data(:,8:10)};
        posTable1.('r_Tibia')(iTrials) = {pos.data(:,14:16)};
        posTable1.('r_Talus')(iTrials) = {pos.data(:,20:22)};
        posTable1.('r_Calc')(iTrials) = {pos.data(:,26:28)};
        posTable1.('r_Toes')(iTrials) = {pos.data(:,32:34)};
        posTable1.('l_Femur')(iTrials) = {pos.data(:,38:40)};
        posTable1.('l_Tibia')(iTrials) = {pos.data(:,44:46)};
        posTable1.('l_Talus')(iTrials) = {pos.data(:,50:52)};
        posTable1.('l_Calc')(iTrials) = {pos.data(:,56:58)};
        posTable1.('l_Toes')(iTrials) = {pos.data(:,62:64)};
    end
end

% Placing all the velocity data into a temporary table 
for iTrials = 1:length(IKvelDir)
    vel = importdata(IKvelDir(iTrials).name);
    
    if iTrials == 1 % Creating the table for velocity based calculations
        velTable1 = table({IKvelDir(iTrials).name}, {vel.data(:,1)}, {vel.data(:,74:76)},...
            {vel.data(:,68:70)}, {vel.data(:,2:4)}, {vel.data(:,8:10)},...
            {vel.data(:,14:16)}, {vel.data(:,20:22)}, {vel.data(:,26:28)}, {vel.data(:,32:34)},...
            {vel.data(:,38:40)},{vel.data(:,44:46)}, {vel.data(:,50:52)}, {vel.data(:,56:58)},...
            {vel.data(:,62:64)}, 'VariableNames', {'Trial Name';'Time (s)'; 'CoM'; 'Torso';...
            'Pelvis'; 'r_Femur'; 'r_Tibia'; 'r_Talus'; 'r_Calc'; 'r_Toes'; 'l_Femur'; 'l_Tibia'; 'l_Talus';...
            'l_Calc'; 'l_Toes';});
    else % Filling the table with the remaining values
        velTable1.('Trial Name')(iTrials) = {IKvelDir(iTrials).name};
        velTable1.('Time (s)')(iTrials) = {vel.data(:,1)};
        velTable1.('CoM')(iTrials) = {vel.data(:,74:76)};
        velTable1.('Torso')(iTrials) = {vel.data(:,68:70)};
        velTable1.('Pelvis')(iTrials) = {vel.data(:,2:4)};
        velTable1.('r_Femur')(iTrials) = {vel.data(:,8:10)};
        velTable1.('r_Tibia')(iTrials) = {vel.data(:,14:16)};
        velTable1.('r_Talus')(iTrials) = {vel.data(:,20:22)};
        velTable1.('r_Calc')(iTrials) = {vel.data(:,26:28)};
        velTable1.('r_Toes')(iTrials) = {vel.data(:,32:34)};
        velTable1.('l_Femur')(iTrials) = {vel.data(:,38:40)};
        velTable1.('l_Tibia')(iTrials) = {vel.data(:,44:46)};
        velTable1.('l_Talus')(iTrials) = {vel.data(:,50:52)};
        velTable1.('l_Calc')(iTrials) = {vel.data(:,56:58)};
        velTable1.('l_Toes')(iTrials) = {vel.data(:,62:64)};
    end
end

% Placing all the acceleration data into a temporary table 
for iTrials = 1:length(IKaccDir)
    acc = importdata(IKaccDir(iTrials).name);
    
    if iTrials == 1 % Creating the table for acceleration based calculations
        accTable1 = table({IKaccDir(iTrials).name}, {acc.data(:,1)}, {acc.data(:,74:76)},...
            {acc.data(:,68:70)}, {acc.data(:,2:4)}, {acc.data(:,8:10)},...
            {acc.data(:,14:16)}, {acc.data(:,20:22)}, {acc.data(:,26:28)}, {acc.data(:,32:34)},...
            {acc.data(:,38:40)},{acc.data(:,44:46)}, {acc.data(:,50:52)}, {acc.data(:,56:58)},...
            {acc.data(:,62:64)}, 'VariableNames', {'Trial Name';'Time (s)'; 'CoM'; 'Torso';...
            'Pelvis'; 'r_Femur'; 'r_Tibia'; 'r_Talus'; 'r_Calc'; 'r_Toes'; 'l_Femur'; 'l_Tibia'; 'l_Talus';...
            'l_Calc'; 'l_Toes';});
    else % Filling the table with the remaining values
        accTable1.('Trial Name')(iTrials) = {IKaccDir(iTrials).name};
        accTable1.('Time (s)')(iTrials) = {acc.data(:,1)};
        accTable1.('CoM')(iTrials) = {acc.data(:,74:76)};
        accTable1.('Torso')(iTrials) = {acc.data(:,68:70)};
        accTable1.('Pelvis')(iTrials) = {acc.data(:,2:4)};
        accTable1.('r_Femur')(iTrials) = {acc.data(:,8:10)};
        accTable1.('r_Tibia')(iTrials) = {acc.data(:,14:16)};
        accTable1.('r_Talus')(iTrials) = {acc.data(:,20:22)};
        accTable1.('r_Calc')(iTrials) = {acc.data(:,26:28)};
        accTable1.('r_Toes')(iTrials) = {acc.data(:,32:34)};
        accTable1.('l_Femur')(iTrials) = {acc.data(:,38:40)};
        accTable1.('l_Tibia')(iTrials) = {acc.data(:,44:46)};
        accTable1.('l_Talus')(iTrials) = {acc.data(:,50:52)};
        accTable1.('l_Calc')(iTrials) = {acc.data(:,56:58)};
        accTable1.('l_Toes')(iTrials) = {acc.data(:,62:64)};
    end
end

% Placing all the angular velocity data into a temporary table 
for iTrials = 1:length(IKvelDir)
    angvel = importdata(IKvelDir(iTrials).name);
    
    if iTrials == 1 % Creating the table for angular velocity based calculations
        angvelTable1 = table({IKvelDir(iTrials).name}, {angvel.data(:,1)},...
            {angvel.data(:,71:73)}, {angvel.data(:,5:7)}, {angvel.data(:,11:13)}, {angvel.data(:,17:19)},...
            {angvel.data(:,23:25)}, {angvel.data(:,29:31)}, {angvel.data(:,35:37)}, {angvel.data(:,41:43)},...
            {angvel.data(:,47:49)},{angvel.data(:,53:55)}, {angvel.data(:,59:61)}, {angvel.data(:,65:67)},...
             'VariableNames', {'Trial Name';'Time (s)'; 'Torso';...
            'Pelvis'; 'r_Femur'; 'r_Tibia'; 'r_Talus'; 'r_Calc'; 'r_Toes'; 'l_Femur'; 'l_Tibia'; 'l_Talus';...
            'l_Calc'; 'l_Toes';});
    else % Filling the table with the remaining values
        angvelTable1.('Trial Name')(iTrials) = {IKvelDir(iTrials).name};
        angvelTable1.('Time (s)')(iTrials) = {angvel.data(:,1)};
        angvelTable1.('Torso')(iTrials) = {angvel.data(:,71:73)};
        angvelTable1.('Pelvis')(iTrials) = {angvel.data(:,5:7)};
        angvelTable1.('r_Femur')(iTrials) = {angvel.data(:,11:13)};
        angvelTable1.('r_Tibia')(iTrials) = {angvel.data(:,17:19)};
        angvelTable1.('r_Talus')(iTrials) = {angvel.data(:,23:25)};
        angvelTable1.('r_Calc')(iTrials) = {angvel.data(:,29:31)};
        angvelTable1.('r_Toes')(iTrials) = {angvel.data(:,35:37)};
        angvelTable1.('l_Femur')(iTrials) = {angvel.data(:,41:43)};
        angvelTable1.('l_Tibia')(iTrials) = {angvel.data(:,47:49)};
        angvelTable1.('l_Talus')(iTrials) = {angvel.data(:,53:55)};
        angvelTable1.('l_Calc')(iTrials) = {angvel.data(:,59:61)};
        angvelTable1.('l_Toes')(iTrials) = {angvel.data(:,65:67)};
    end
end

%% Creating names for the tables 
% Preallocated names to pull from later in loops for Treadmill Trials 
nameTreadmill = {'Treadmill01'; 'Treadmill02'; 'Treadmill03'; 'Treadmill04'; 'Treadmill05'; 'Treadmill06'};

% Preallocated names to pull from later in loops for Perception Trials 
namePercep = {'Percep01'; 'Percep02'; 'Percep03'; 'Percep04'; 'Percep05'; 'Percep06'; 'Percep07'; 'Percep08';};

%% Finding all the indices in the temporary tables to combine the data to loop through 

% This loop finds the indicies of the position table of the subsections of
% each perception trial 
for iSubtrials = 1:size(posTable1.('Trial Name'),1)
    posA(iSubtrials) = contains(posTable1.('Trial Name'){iSubtrials}, 'Percep01');
    posB(iSubtrials) = contains(posTable1.('Trial Name'){iSubtrials}, 'Percep02');
    posC(iSubtrials) = contains(posTable1.('Trial Name'){iSubtrials}, 'Percep03');
    posD(iSubtrials) = contains(posTable1.('Trial Name'){iSubtrials}, 'Percep04');
    posE(iSubtrials) = contains(posTable1.('Trial Name'){iSubtrials}, 'Percep05');
    posF(iSubtrials) = contains(posTable1.('Trial Name'){iSubtrials}, 'Percep06');
    posG(iSubtrials) = contains(posTable1.('Trial Name'){iSubtrials}, 'Percep07');
    posH(iSubtrials) = contains(posTable1.('Trial Name'){iSubtrials}, 'Percep08');
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
for iSubtrials = 1:size(velTable1.('Trial Name'),1)
    velA(iSubtrials) = contains(velTable1.('Trial Name'){iSubtrials}, 'Percep01');
    velB(iSubtrials) = contains(velTable1.('Trial Name'){iSubtrials}, 'Percep02');
    velC(iSubtrials) = contains(velTable1.('Trial Name'){iSubtrials}, 'Percep03');
    velD(iSubtrials) = contains(velTable1.('Trial Name'){iSubtrials}, 'Percep04');
    velE(iSubtrials) = contains(velTable1.('Trial Name'){iSubtrials}, 'Percep05');
    velF(iSubtrials) = contains(velTable1.('Trial Name'){iSubtrials}, 'Percep06');
    velG(iSubtrials) = contains(velTable1.('Trial Name'){iSubtrials}, 'Percep07');
    velH(iSubtrials) = contains(velTable1.('Trial Name'){iSubtrials}, 'Percep08');
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
for iSubtrials = 1:size(accTable1.('Trial Name'),1)
    accA(iSubtrials) = contains(accTable1.('Trial Name'){iSubtrials}, 'Percep01');
    accB(iSubtrials) = contains(accTable1.('Trial Name'){iSubtrials}, 'Percep02');
    accC(iSubtrials) = contains(accTable1.('Trial Name'){iSubtrials}, 'Percep03');
    accD(iSubtrials) = contains(accTable1.('Trial Name'){iSubtrials}, 'Percep04');
    accE(iSubtrials) = contains(accTable1.('Trial Name'){iSubtrials}, 'Percep05');
    accF(iSubtrials) = contains(accTable1.('Trial Name'){iSubtrials}, 'Percep06');
    accG(iSubtrials) = contains(accTable1.('Trial Name'){iSubtrials}, 'Percep07');
    accH(iSubtrials) = contains(accTable1.('Trial Name'){iSubtrials}, 'Percep08');
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
temp1 = {posA; posB; posC; posD; posE};

% Combining all the indicies of the velocity to one matrix
temp2 = {velA; velB; velC; velD; velE};

% Combining all the indices of the acceleration to one matrix
temp3 = {accA; accB; accC; accD; accE};

for iNumTrials = 1:numTrials 
    % Creating blank matrices for all the position data 
    tempPos.("Time").(namePercep{iNumTrials}) = []; tempPos.("Torso").(namePercep{iNumTrials}) = [];
    tempPos.("Pelvis").(namePercep{iNumTrials}) = []; tempPos.("r_Femur").(namePercep{iNumTrials}) = [];
    tempPos.("r_Tibia").(namePercep{iNumTrials}) = []; tempPos.("r_Talus").(namePercep{iNumTrials}) = [];
    tempPos.("r_Calc").(namePercep{iNumTrials}) = []; tempPos.("r_Toes").(namePercep{iNumTrials}) = [];
    tempPos.("l_Femur").(namePercep{iNumTrials}) = []; tempPos.("l_Tibia").(namePercep{iNumTrials}) = [];
    tempPos.("l_Talus").(namePercep{iNumTrials}) = []; tempPos.("l_Calc").(namePercep{iNumTrials}) = [];
    tempPos.("l_Toes").(namePercep{iNumTrials}) = []; tempPos.("CoM").(namePercep{iNumTrials}) = [];
    % Creating blank matrices for all the velocity data 
    tempVel.("Time").(namePercep{iNumTrials}) = []; tempVel.("Torso").(namePercep{iNumTrials}) = [];
    tempVel.("Pelvis").(namePercep{iNumTrials}) = []; tempVel.("r_Femur").(namePercep{iNumTrials}) = [];
    tempVel.("r_Tibia").(namePercep{iNumTrials}) = []; tempVel.("r_Talus").(namePercep{iNumTrials}) = [];
    tempVel.("r_Calc").(namePercep{iNumTrials}) = []; tempVel.("r_Toes").(namePercep{iNumTrials}) = [];
    tempVel.("l_Femur").(namePercep{iNumTrials}) = []; tempVel.("l_Tibia").(namePercep{iNumTrials}) = [];
    tempVel.("l_Talus").(namePercep{iNumTrials}) = []; tempVel.("l_Calc").(namePercep{iNumTrials}) = [];
    tempVel.("l_Toes").(namePercep{iNumTrials}) = []; tempVel.("CoM").(namePercep{iNumTrials}) = [];
    % Creating blank matrices for all the acceleration data 
    tempAcc.("Time").(namePercep{iNumTrials}) = []; tempAcc.("Torso").(namePercep{iNumTrials}) = [];
    tempAcc.("Pelvis").(namePercep{iNumTrials}) = []; tempAcc.("r_Femur").(namePercep{iNumTrials}) = [];
    tempAcc.("r_Tibia").(namePercep{iNumTrials}) = []; tempAcc.("r_Talus").(namePercep{iNumTrials}) = [];
    tempAcc.("r_Calc").(namePercep{iNumTrials}) = []; tempAcc.("r_Toes").(namePercep{iNumTrials}) = [];
    tempAcc.("l_Femur").(namePercep{iNumTrials}) = []; tempAcc.("l_Tibia").(namePercep{iNumTrials}) = [];
    tempAcc.("l_Talus").(namePercep{iNumTrials}) = []; tempAcc.("l_Calc").(namePercep{iNumTrials}) = [];
    tempAcc.("l_Toes").(namePercep{iNumTrials}) = [];  tempAcc.("CoM").(namePercep{iNumTrials}) = [];
    % Creating blank matrices for all the angular velocity data 
    tempAngVel.("Time").(namePercep{iNumTrials}) = []; tempAngVel.("Torso").(namePercep{iNumTrials}) = [];
    tempAngVel.("Pelvis").(namePercep{iNumTrials}) = []; tempAngVel.("r_Femur").(namePercep{iNumTrials}) = [];
    tempAngVel.("r_Tibia").(namePercep{iNumTrials}) = []; tempAngVel.("r_Talus").(namePercep{iNumTrials}) = [];
    tempAngVel.("r_Calc").(namePercep{iNumTrials}) = []; tempAngVel.("r_Toes").(namePercep{iNumTrials}) = [];
    tempAngVel.("l_Femur").(namePercep{iNumTrials}) = []; tempAngVel.("l_Tibia").(namePercep{iNumTrials}) = [];
    tempAngVel.("l_Talus").(namePercep{iNumTrials}) = []; tempAngVel.("l_Calc").(namePercep{iNumTrials}) = [];
    tempAngVel.("l_Toes").(namePercep{iNumTrials}) = [];
    % This loop puts all the position data into a structure 
    for iSectPercep = 1:size(temp1{iNumTrials},2)
        % Creating a temporary structure filled with the concatenated data
        % for each perception trial
        if iSectPercep == 1 
            tempPos.("Time").(namePercep{iNumTrials}) = [posTable1.("Time (s)"){temp1{iNumTrials}(iSectPercep)}];
            tempPos.("CoM").(namePercep{iNumTrials}) = [posTable1.("CoM"){temp1{iNumTrials}(iSectPercep)}];
            tempPos.("Torso").(namePercep{iNumTrials}) = [posTable1.("Torso"){temp1{iNumTrials}(iSectPercep)}];
            tempPos.("Pelvis").(namePercep{iNumTrials}) = [posTable1.("Pelvis"){temp1{iNumTrials}(iSectPercep)}];
            tempPos.("r_Femur").(namePercep{iNumTrials}) = [posTable1.("r_Femur"){temp1{iNumTrials}(iSectPercep)}];
            tempPos.("r_Tibia").(namePercep{iNumTrials}) = [posTable1.("r_Tibia"){temp1{iNumTrials}(iSectPercep)}];
            tempPos.("r_Talus").(namePercep{iNumTrials}) = [posTable1.("r_Talus"){temp1{iNumTrials}(iSectPercep)}];
            tempPos.("r_Calc").(namePercep{iNumTrials}) = [posTable1.("r_Calc"){temp1{iNumTrials}(iSectPercep)}];
            tempPos.("r_Toes").(namePercep{iNumTrials}) = [posTable1.("r_Toes"){temp1{iNumTrials}(iSectPercep)}];
            tempPos.("l_Femur").(namePercep{iNumTrials}) = [posTable1.("l_Femur"){temp1{iNumTrials}(iSectPercep)}];
            tempPos.("l_Tibia").(namePercep{iNumTrials}) = [posTable1.("l_Tibia"){temp1{iNumTrials}(iSectPercep)}];
            tempPos.("l_Talus").(namePercep{iNumTrials}) = [posTable1.("l_Talus"){temp1{iNumTrials}(iSectPercep)}];
            tempPos.("l_Calc").(namePercep{iNumTrials}) = [posTable1.("l_Calc"){temp1{iNumTrials}(iSectPercep)}];
            tempPos.("l_Toes").(namePercep{iNumTrials}) = [posTable1.("l_Toes"){temp1{iNumTrials}(iSectPercep)}];
        else
            tempPos.("Time").(namePercep{iNumTrials}) = [tempPos.("Time").(namePercep{iNumTrials}); posTable1.("Time (s)"){temp1{iNumTrials}(iSectPercep)}(2:end)];
            tempPos.("CoM").(namePercep{iNumTrials}) = [tempPos.("CoM").(namePercep{iNumTrials}); posTable1.("CoM"){temp1{iNumTrials}(iSectPercep)}(2:end,:)];
            tempPos.("Torso").(namePercep{iNumTrials}) = [tempPos.("Torso").(namePercep{iNumTrials}); posTable1.("Torso"){temp1{iNumTrials}(iSectPercep)}(2:end,:)];
            tempPos.("Pelvis").(namePercep{iNumTrials}) = [tempPos.("Pelvis").(namePercep{iNumTrials}); posTable1.("Pelvis"){temp1{iNumTrials}(iSectPercep)}(2:end,:)];
            tempPos.("r_Femur").(namePercep{iNumTrials}) = [tempPos.("r_Femur").(namePercep{iNumTrials}); posTable1.("r_Femur"){temp1{iNumTrials}(iSectPercep)}(2:end,:)];
            tempPos.("r_Tibia").(namePercep{iNumTrials}) = [tempPos.("r_Tibia").(namePercep{iNumTrials}); posTable1.("r_Tibia"){temp1{iNumTrials}(iSectPercep)}(2:end,:)];
            tempPos.("r_Talus").(namePercep{iNumTrials}) = [tempPos.("r_Talus").(namePercep{iNumTrials}); posTable1.("r_Talus"){temp1{iNumTrials}(iSectPercep)}(2:end,:)];
            tempPos.("r_Calc").(namePercep{iNumTrials}) = [tempPos.("r_Calc").(namePercep{iNumTrials}); posTable1.("r_Calc"){temp1{iNumTrials}(iSectPercep)}(2:end,:)];
            tempPos.("r_Toes").(namePercep{iNumTrials}) = [tempPos.("r_Toes").(namePercep{iNumTrials}); posTable1.("r_Toes"){temp1{iNumTrials}(iSectPercep)}(2:end,:)];
            tempPos.("l_Femur").(namePercep{iNumTrials}) = [tempPos.("l_Femur").(namePercep{iNumTrials}); posTable1.("l_Femur"){temp1{iNumTrials}(iSectPercep)}(2:end,:)];
            tempPos.("l_Tibia").(namePercep{iNumTrials}) = [tempPos.("l_Tibia").(namePercep{iNumTrials}); posTable1.("l_Tibia"){temp1{iNumTrials}(iSectPercep)}(2:end,:)];
            tempPos.("l_Talus").(namePercep{iNumTrials}) = [tempPos.("l_Talus").(namePercep{iNumTrials}); posTable1.("l_Talus"){temp1{iNumTrials}(iSectPercep)}(2:end,:)];
            tempPos.("l_Calc").(namePercep{iNumTrials}) = [tempPos.("l_Calc").(namePercep{iNumTrials}); posTable1.("l_Calc"){temp1{iNumTrials}(iSectPercep)}(2:end,:)];
            tempPos.("l_Toes").(namePercep{iNumTrials}) = [tempPos.("l_Toes").(namePercep{iNumTrials}); posTable1.("l_Toes"){temp1{iNumTrials}(iSectPercep)}(2:end,:)];
        end
    end
    
    % This loop puts all the Velocity data into a structure 
    for iSectPercep = 1:size(temp2{iNumTrials},2)
        % Creating a temporary structure filled with the concatenated data
        % for each perception trial
        if iSectPercep == 1 
            tempVel.("Time").(namePercep{iNumTrials}) = [velTable1.("Time (s)"){temp2{iNumTrials}(iSectPercep)}];
            tempVel.("CoM").(namePercep{iNumTrials}) = [velTable1.("CoM"){temp2{iNumTrials}(iSectPercep)}];
            tempVel.("Torso").(namePercep{iNumTrials}) = [velTable1.("Torso"){temp2{iNumTrials}(iSectPercep)}];
            tempVel.("Pelvis").(namePercep{iNumTrials}) = [velTable1.("Pelvis"){temp2{iNumTrials}(iSectPercep)}];
            tempVel.("r_Femur").(namePercep{iNumTrials}) = [velTable1.("r_Femur"){temp2{iNumTrials}(iSectPercep)}];
            tempVel.("r_Tibia").(namePercep{iNumTrials}) = [velTable1.("r_Tibia"){temp2{iNumTrials}(iSectPercep)}];
            tempVel.("r_Talus").(namePercep{iNumTrials}) = [velTable1.("r_Talus"){temp2{iNumTrials}(iSectPercep)}];
            tempVel.("r_Calc").(namePercep{iNumTrials}) = [velTable1.("r_Calc"){temp2{iNumTrials}(iSectPercep)}];
            tempVel.("r_Toes").(namePercep{iNumTrials}) = [velTable1.("r_Toes"){temp2{iNumTrials}(iSectPercep)}];
            tempVel.("l_Femur").(namePercep{iNumTrials}) = [velTable1.("l_Femur"){temp2{iNumTrials}(iSectPercep)}];
            tempVel.("l_Tibia").(namePercep{iNumTrials}) = [velTable1.("l_Tibia"){temp2{iNumTrials}(iSectPercep)}];
            tempVel.("l_Talus").(namePercep{iNumTrials}) = [velTable1.("l_Talus"){temp2{iNumTrials}(iSectPercep)}];
            tempVel.("l_Calc").(namePercep{iNumTrials}) = [velTable1.("l_Calc"){temp2{iNumTrials}(iSectPercep)}];
            tempVel.("l_Toes").(namePercep{iNumTrials}) = [velTable1.("l_Toes"){temp2{iNumTrials}(iSectPercep)}];
        else
            tempVel.("Time").(namePercep{iNumTrials}) = [tempVel.("Time").(namePercep{iNumTrials}); velTable1.("Time (s)"){temp2{iNumTrials}(iSectPercep)}(2:end)];
            tempVel.("CoM").(namePercep{iNumTrials}) = [tempVel.("CoM").(namePercep{iNumTrials}); velTable1.("CoM"){temp2{iNumTrials}(iSectPercep)}(2:end,:)];
            tempVel.("Torso").(namePercep{iNumTrials}) = [tempVel.("Torso").(namePercep{iNumTrials}); velTable1.("Torso"){temp2{iNumTrials}(iSectPercep)}(2:end,:)];
            tempVel.("Pelvis").(namePercep{iNumTrials}) = [tempVel.("Pelvis").(namePercep{iNumTrials}); velTable1.("Pelvis"){temp2{iNumTrials}(iSectPercep)}(2:end,:)];
            tempVel.("r_Femur").(namePercep{iNumTrials}) = [tempVel.("r_Femur").(namePercep{iNumTrials}); velTable1.("r_Femur"){temp2{iNumTrials}(iSectPercep)}(2:end,:)];
            tempVel.("r_Tibia").(namePercep{iNumTrials}) = [tempVel.("r_Tibia").(namePercep{iNumTrials}); velTable1.("r_Tibia"){temp2{iNumTrials}(iSectPercep)}(2:end,:)];
            tempVel.("r_Talus").(namePercep{iNumTrials}) = [tempVel.("r_Talus").(namePercep{iNumTrials}); velTable1.("r_Talus"){temp2{iNumTrials}(iSectPercep)}(2:end,:)];
            tempVel.("r_Calc").(namePercep{iNumTrials}) = [tempVel.("r_Calc").(namePercep{iNumTrials}); velTable1.("r_Calc"){temp2{iNumTrials}(iSectPercep)}(2:end,:)];
            tempVel.("r_Toes").(namePercep{iNumTrials}) = [tempVel.("r_Toes").(namePercep{iNumTrials}); velTable1.("r_Toes"){temp2{iNumTrials}(iSectPercep)}(2:end,:)];
            tempVel.("l_Femur").(namePercep{iNumTrials}) = [tempVel.("l_Femur").(namePercep{iNumTrials}); velTable1.("l_Femur"){temp2{iNumTrials}(iSectPercep)}(2:end,:)];
            tempVel.("l_Tibia").(namePercep{iNumTrials}) = [tempVel.("l_Tibia").(namePercep{iNumTrials}); velTable1.("l_Tibia"){temp2{iNumTrials}(iSectPercep)}(2:end,:)];
            tempVel.("l_Talus").(namePercep{iNumTrials}) = [tempVel.("l_Talus").(namePercep{iNumTrials}); velTable1.("l_Talus"){temp2{iNumTrials}(iSectPercep)}(2:end,:)];
            tempVel.("l_Calc").(namePercep{iNumTrials}) = [tempVel.("l_Calc").(namePercep{iNumTrials}); velTable1.("l_Calc"){temp2{iNumTrials}(iSectPercep)}(2:end,:)];
            tempVel.("l_Toes").(namePercep{iNumTrials}) = [tempVel.("l_Toes").(namePercep{iNumTrials}); velTable1.("l_Toes"){temp2{iNumTrials}(iSectPercep)}(2:end,:)];
        end
    end
    
    % This loop puts all the angular Velocity data into a structure 
    for iSectPercep = 1:size(temp2{iNumTrials},2)
        % Creating a temporary structure filled with the concatenated data
        % for each perception trial
        if iSectPercep == 1 
            tempAngVel.("Time").(namePercep{iNumTrials}) = [angvelTable1.("Time (s)"){temp2{iNumTrials}(iSectPercep)}];
            tempAngVel.("Torso").(namePercep{iNumTrials}) = [angvelTable1.("Torso"){temp2{iNumTrials}(iSectPercep)}];
            tempAngVel.("Pelvis").(namePercep{iNumTrials}) = [angvelTable1.("Pelvis"){temp2{iNumTrials}(iSectPercep)}];
            tempAngVel.("r_Femur").(namePercep{iNumTrials}) = [angvelTable1.("r_Femur"){temp2{iNumTrials}(iSectPercep)}];
            tempAngVel.("r_Tibia").(namePercep{iNumTrials}) = [angvelTable1.("r_Tibia"){temp2{iNumTrials}(iSectPercep)}];
            tempAngVel.("r_Talus").(namePercep{iNumTrials}) = [angvelTable1.("r_Talus"){temp2{iNumTrials}(iSectPercep)}];
            tempAngVel.("r_Calc").(namePercep{iNumTrials}) = [angvelTable1.("r_Calc"){temp2{iNumTrials}(iSectPercep)}];
            tempAngVel.("r_Toes").(namePercep{iNumTrials}) = [angvelTable1.("r_Toes"){temp2{iNumTrials}(iSectPercep)}];
            tempAngVel.("l_Femur").(namePercep{iNumTrials}) = [angvelTable1.("l_Femur"){temp2{iNumTrials}(iSectPercep)}];
            tempAngVel.("l_Tibia").(namePercep{iNumTrials}) = [angvelTable1.("l_Tibia"){temp2{iNumTrials}(iSectPercep)}];
            tempAngVel.("l_Talus").(namePercep{iNumTrials}) = [angvelTable1.("l_Talus"){temp2{iNumTrials}(iSectPercep)}];
            tempAngVel.("l_Calc").(namePercep{iNumTrials}) = [angvelTable1.("l_Calc"){temp2{iNumTrials}(iSectPercep)}];
            tempAngVel.("l_Toes").(namePercep{iNumTrials}) = [angvelTable1.("l_Toes"){temp2{iNumTrials}(iSectPercep)}];
        else
            tempAngVel.("Time").(namePercep{iNumTrials}) = [tempAngVel.("Time").(namePercep{iNumTrials}); angvelTable1.("Time (s)"){temp2{iNumTrials}(iSectPercep)}(2:end)];
            tempAngVel.("Torso").(namePercep{iNumTrials}) = [tempAngVel.("Torso").(namePercep{iNumTrials}); angvelTable1.("Torso"){temp2{iNumTrials}(iSectPercep)}(2:end,:)];
            tempAngVel.("Pelvis").(namePercep{iNumTrials}) = [tempAngVel.("Pelvis").(namePercep{iNumTrials}); angvelTable1.("Pelvis"){temp2{iNumTrials}(iSectPercep)}(2:end,:)];
            tempAngVel.("r_Femur").(namePercep{iNumTrials}) = [tempAngVel.("r_Femur").(namePercep{iNumTrials}); angvelTable1.("r_Femur"){temp2{iNumTrials}(iSectPercep)}(2:end,:)];
            tempAngVel.("r_Tibia").(namePercep{iNumTrials}) = [tempAngVel.("r_Tibia").(namePercep{iNumTrials}); angvelTable1.("r_Tibia"){temp2{iNumTrials}(iSectPercep)}(2:end,:)];
            tempAngVel.("r_Talus").(namePercep{iNumTrials}) = [tempAngVel.("r_Talus").(namePercep{iNumTrials}); angvelTable1.("r_Talus"){temp2{iNumTrials}(iSectPercep)}(2:end,:)];
            tempAngVel.("r_Calc").(namePercep{iNumTrials}) = [tempAngVel.("r_Calc").(namePercep{iNumTrials}); angvelTable1.("r_Calc"){temp2{iNumTrials}(iSectPercep)}(2:end,:)];
            tempAngVel.("r_Toes").(namePercep{iNumTrials}) = [tempAngVel.("r_Toes").(namePercep{iNumTrials}); angvelTable1.("r_Toes"){temp2{iNumTrials}(iSectPercep)}(2:end,:)];
            tempAngVel.("l_Femur").(namePercep{iNumTrials}) = [tempAngVel.("l_Femur").(namePercep{iNumTrials}); angvelTable1.("l_Femur"){temp2{iNumTrials}(iSectPercep)}(2:end,:)];
            tempAngVel.("l_Tibia").(namePercep{iNumTrials}) = [tempAngVel.("l_Tibia").(namePercep{iNumTrials}); angvelTable1.("l_Tibia"){temp2{iNumTrials}(iSectPercep)}(2:end,:)];
            tempAngVel.("l_Talus").(namePercep{iNumTrials}) = [tempAngVel.("l_Talus").(namePercep{iNumTrials}); angvelTable1.("l_Talus"){temp2{iNumTrials}(iSectPercep)}(2:end,:)];
            tempAngVel.("l_Calc").(namePercep{iNumTrials}) = [tempAngVel.("l_Calc").(namePercep{iNumTrials}); angvelTable1.("l_Calc"){temp2{iNumTrials}(iSectPercep)}(2:end,:)];
            tempAngVel.("l_Toes").(namePercep{iNumTrials}) = [tempAngVel.("l_Toes").(namePercep{iNumTrials}); angvelTable1.("l_Toes"){temp2{iNumTrials}(iSectPercep)}(2:end,:)];
        end
    end
    
    % This loop puts all the acceleration data into a structure 
    for iSectPercep = 1:size(temp3{iNumTrials},2)       
        % Creating a temporary structure filled with the concatenated data
        % for each perception trial
        if iSectPercep == 1 
            tempAcc.("Time").(namePercep{iNumTrials}) = [accTable1.("Time (s)"){temp3{iNumTrials}(iSectPercep)}];
            tempAcc.("CoM").(namePercep{iNumTrials}) = [accTable1.("CoM"){temp3{iNumTrials}(iSectPercep)}];
            tempAcc.("Torso").(namePercep{iNumTrials}) = [accTable1.("Torso"){temp3{iNumTrials}(iSectPercep)}];
            tempAcc.("Pelvis").(namePercep{iNumTrials}) = [accTable1.("Pelvis"){temp3{iNumTrials}(iSectPercep)}];
            tempAcc.("r_Femur").(namePercep{iNumTrials}) = [accTable1.("r_Femur"){temp3{iNumTrials}(iSectPercep)}];
            tempAcc.("r_Tibia").(namePercep{iNumTrials}) = [accTable1.("r_Tibia"){temp3{iNumTrials}(iSectPercep)}];
            tempAcc.("r_Talus").(namePercep{iNumTrials}) = [accTable1.("r_Talus"){temp3{iNumTrials}(iSectPercep)}];
            tempAcc.("r_Calc").(namePercep{iNumTrials}) = [accTable1.("r_Calc"){temp3{iNumTrials}(iSectPercep)}];
            tempAcc.("r_Toes").(namePercep{iNumTrials}) = [accTable1.("r_Toes"){temp3{iNumTrials}(iSectPercep)}];
            tempAcc.("l_Femur").(namePercep{iNumTrials}) = [accTable1.("l_Femur"){temp3{iNumTrials}(iSectPercep)}];
            tempAcc.("l_Tibia").(namePercep{iNumTrials}) = [accTable1.("l_Tibia"){temp3{iNumTrials}(iSectPercep)}];
            tempAcc.("l_Talus").(namePercep{iNumTrials}) = [accTable1.("l_Talus"){temp3{iNumTrials}(iSectPercep)}];
            tempAcc.("l_Calc").(namePercep{iNumTrials}) = [accTable1.("l_Calc"){temp3{iNumTrials}(iSectPercep)}];
            tempAcc.("l_Toes").(namePercep{iNumTrials}) = [accTable1.("l_Toes"){temp3{iNumTrials}(iSectPercep)}];
        else
            tempAcc.("Time").(namePercep{iNumTrials}) = [tempAcc.("Time").(namePercep{iNumTrials}); accTable1.("Time (s)"){temp3{iNumTrials}(iSectPercep)}(2:end)];
            tempAcc.("CoM").(namePercep{iNumTrials}) = [tempAcc.("CoM").(namePercep{iNumTrials}); accTable1.("CoM"){temp3{iNumTrials}(iSectPercep)}(2:end,:)];
            tempAcc.("Torso").(namePercep{iNumTrials}) = [tempAcc.("Torso").(namePercep{iNumTrials}); accTable1.("Torso"){temp3{iNumTrials}(iSectPercep)}(2:end,:)];
            tempAcc.("Pelvis").(namePercep{iNumTrials}) = [tempAcc.("Pelvis").(namePercep{iNumTrials}); accTable1.("Pelvis"){temp3{iNumTrials}(iSectPercep)}(2:end,:)];
            tempAcc.("r_Femur").(namePercep{iNumTrials}) = [tempAcc.("r_Femur").(namePercep{iNumTrials}); accTable1.("r_Femur"){temp3{iNumTrials}(iSectPercep)}(2:end,:)];
            tempAcc.("r_Tibia").(namePercep{iNumTrials}) = [tempAcc.("r_Tibia").(namePercep{iNumTrials}); accTable1.("r_Tibia"){temp3{iNumTrials}(iSectPercep)}(2:end,:)];
            tempAcc.("r_Talus").(namePercep{iNumTrials}) = [tempAcc.("r_Talus").(namePercep{iNumTrials}); accTable1.("r_Talus"){temp3{iNumTrials}(iSectPercep)}(2:end,:)];
            tempAcc.("r_Calc").(namePercep{iNumTrials}) = [tempAcc.("r_Calc").(namePercep{iNumTrials}); accTable1.("r_Calc"){temp3{iNumTrials}(iSectPercep)}(2:end,:)];
            tempAcc.("r_Toes").(namePercep{iNumTrials}) = [tempAcc.("r_Toes").(namePercep{iNumTrials}); accTable1.("r_Toes"){temp3{iNumTrials}(iSectPercep)}(2:end,:)];
            tempAcc.("l_Femur").(namePercep{iNumTrials}) = [tempAcc.("l_Femur").(namePercep{iNumTrials}); accTable1.("l_Femur"){temp3{iNumTrials}(iSectPercep)}(2:end,:)];
            tempAcc.("l_Tibia").(namePercep{iNumTrials}) = [tempAcc.("l_Tibia").(namePercep{iNumTrials}); accTable1.("l_Tibia"){temp3{iNumTrials}(iSectPercep)}(2:end,:)];
            tempAcc.("l_Talus").(namePercep{iNumTrials}) = [tempAcc.("l_Talus").(namePercep{iNumTrials}); accTable1.("l_Talus"){temp3{iNumTrials}(iSectPercep)}(2:end,:)];
            tempAcc.("l_Calc").(namePercep{iNumTrials}) = [tempAcc.("l_Calc").(namePercep{iNumTrials}); accTable1.("l_Calc"){temp3{iNumTrials}(iSectPercep)}(2:end,:)];
            tempAcc.("l_Toes").(namePercep{iNumTrials}) = [tempAcc.("l_Toes").(namePercep{iNumTrials}); accTable1.("l_Toes"){temp3{iNumTrials}(iSectPercep)}(2:end,:)];
        end
    end
    
    % Setting up the tables from the structures 
    if iNumTrials == 1
        % Setting up the position segments table that will have each full
        % perception trial as a row 
        posSegmentsTable = table(namePercep(iNumTrials), {tempPos.("Time").(namePercep{iNumTrials})}, {tempPos.("CoM").(namePercep{iNumTrials})}, {tempPos.("Torso").(namePercep{iNumTrials})},...
            {tempPos.("Pelvis").(namePercep{iNumTrials})}, {tempPos.("r_Femur").(namePercep{iNumTrials})}, {tempPos.("r_Tibia").(namePercep{iNumTrials})},...
            {tempPos.("r_Talus").(namePercep{iNumTrials})}, {tempPos.("r_Calc").(namePercep{iNumTrials})}, {tempPos.("r_Toes").(namePercep{iNumTrials})},...
            {tempPos.("l_Femur").(namePercep{iNumTrials})}, {tempPos.("l_Tibia").(namePercep{iNumTrials})}, {tempPos.("l_Talus").(namePercep{iNumTrials})},...
            {tempPos.("l_Calc").(namePercep{iNumTrials})}, {tempPos.("l_Toes").(namePercep{iNumTrials})}, 'VariableNames', {'Trial', 'Time', 'CoM_X-Y-Z', 'Torso', 'Pelvis',...
            'r_Femur', 'r_Tibia', 'r_Talus', 'r_Calc', 'r_Toes', 'l_Femur', 'l_Tibia', 'l_Talus', 'l_Calc', 'l_Toes'});
        
        % Setting up the velocity segments table that will ahve each full
        % perception trial as a row 
        velSegmentsTable = table(namePercep(iNumTrials), {tempVel.("Time").(namePercep{iNumTrials})}, {tempVel.("CoM").(namePercep{iNumTrials})}, {tempVel.("Torso").(namePercep{iNumTrials})},...
            {tempVel.("Pelvis").(namePercep{iNumTrials})}, {tempVel.("r_Femur").(namePercep{iNumTrials})}, {tempVel.("r_Tibia").(namePercep{iNumTrials})},...
            {tempVel.("r_Talus").(namePercep{iNumTrials})}, {tempVel.("r_Calc").(namePercep{iNumTrials})}, {tempVel.("r_Toes").(namePercep{iNumTrials})},...
            {tempVel.("l_Femur").(namePercep{iNumTrials})}, {tempVel.("l_Tibia").(namePercep{iNumTrials})}, {tempVel.("l_Talus").(namePercep{iNumTrials})},...
            {tempVel.("l_Calc").(namePercep{iNumTrials})}, {tempVel.("l_Toes").(namePercep{iNumTrials})}, 'VariableNames', {'Trial', 'Time', 'CoM_X-Y-Z', 'Torso', 'Pelvis',...
            'r_Femur', 'r_Tibia', 'r_Talus', 'r_Calc', 'r_Toes', 'l_Femur', 'l_Tibia', 'l_Talus', 'l_Calc', 'l_Toes'});
        
        % Setting up the angular velocity segments table that will ahve each full
        % perception trial as a row 
        angVelSegmentsTable = table(namePercep(iNumTrials), {tempAngVel.("Time").(namePercep{iNumTrials})}, {tempAngVel.("Torso").(namePercep{iNumTrials})},...
            {tempAngVel.("Pelvis").(namePercep{iNumTrials})}, {tempAngVel.("r_Femur").(namePercep{iNumTrials})}, {tempAngVel.("r_Tibia").(namePercep{iNumTrials})},...
            {tempAngVel.("r_Talus").(namePercep{iNumTrials})}, {tempAngVel.("r_Calc").(namePercep{iNumTrials})}, {tempAngVel.("r_Toes").(namePercep{iNumTrials})},...
            {tempAngVel.("l_Femur").(namePercep{iNumTrials})}, {tempAngVel.("l_Tibia").(namePercep{iNumTrials})}, {tempAngVel.("l_Talus").(namePercep{iNumTrials})},...
            {tempAngVel.("l_Calc").(namePercep{iNumTrials})}, {tempAngVel.("l_Toes").(namePercep{iNumTrials})}, 'VariableNames', {'Trial', 'Time', 'Torso_X-Y-Z', 'Pelvis',...
            'r_Femur', 'r_Tibia', 'r_Talus', 'r_Calc', 'r_Toes', 'l_Femur', 'l_Tibia', 'l_Talus', 'l_Calc', 'l_Toes'});
        
        % Setting up the accelerations segments table that will ahve each full
        % perception trial as a row 
        accSegmentsTable = table(namePercep(iNumTrials), {tempAcc.("Time").(namePercep{iNumTrials})}, {tempAcc.("CoM").(namePercep{iNumTrials})}, {tempAcc.("Torso").(namePercep{iNumTrials})},...
            {tempAcc.("Pelvis").(namePercep{iNumTrials})}, {tempAcc.("r_Femur").(namePercep{iNumTrials})}, {tempAcc.("r_Tibia").(namePercep{iNumTrials})},...
            {tempAcc.("r_Talus").(namePercep{iNumTrials})}, {tempAcc.("r_Calc").(namePercep{iNumTrials})}, {tempAcc.("r_Toes").(namePercep{iNumTrials})},...
            {tempAcc.("l_Femur").(namePercep{iNumTrials})}, {tempAcc.("l_Tibia").(namePercep{iNumTrials})}, {tempAcc.("l_Talus").(namePercep{iNumTrials})},...
            {tempAcc.("l_Calc").(namePercep{iNumTrials})}, {tempAcc.("l_Toes").(namePercep{iNumTrials})}, 'VariableNames', {'Trial', 'Time', 'CoM_X-Y-Z', 'Torso', 'Pelvis',...
            'r_Femur', 'r_Tibia', 'r_Talus', 'r_Calc', 'r_Toes', 'l_Femur', 'l_Tibia', 'l_Talus', 'l_Calc', 'l_Toes'});
        
    else
        % Setting up the remaining portion of Perception trials to be added to the position segments Table 
        posSegmentsTable.("Trial")(iNumTrials) = namePercep(iNumTrials);
        posSegmentsTable.("Time")(iNumTrials) = {tempPos.("Time").(namePercep{iNumTrials})};
        posSegmentsTable.("CoM_X-Y-Z")(iNumTrials) = {tempPos.("CoM").(namePercep{iNumTrials})};
        posSegmentsTable.("Torso")(iNumTrials) = {tempPos.("Torso").(namePercep{iNumTrials})};
        posSegmentsTable.("Pelvis")(iNumTrials) = {tempPos.("Pelvis").(namePercep{iNumTrials})};
        posSegmentsTable.("r_Femur")(iNumTrials) = {tempPos.("r_Femur").(namePercep{iNumTrials})};
        posSegmentsTable.("r_Tibia")(iNumTrials) = {tempPos.("r_Tibia").(namePercep{iNumTrials})};
        posSegmentsTable.("r_Talus")(iNumTrials) = {tempPos.("r_Talus").(namePercep{iNumTrials})};
        posSegmentsTable.("r_Calc")(iNumTrials) = {tempPos.("r_Calc").(namePercep{iNumTrials})};
        posSegmentsTable.("r_Toes")(iNumTrials) = {tempPos.("r_Toes").(namePercep{iNumTrials})};
        posSegmentsTable.("l_Femur")(iNumTrials) = {tempPos.("l_Femur").(namePercep{iNumTrials})};
        posSegmentsTable.("l_Tibia")(iNumTrials) = {tempPos.("l_Tibia").(namePercep{iNumTrials})};
        posSegmentsTable.("l_Talus")(iNumTrials) = {tempPos.("l_Talus").(namePercep{iNumTrials})};
        posSegmentsTable.("l_Calc")(iNumTrials) = {tempPos.("l_Calc").(namePercep{iNumTrials})};
        posSegmentsTable.("l_Toes")(iNumTrials) = {tempPos.("l_Toes").(namePercep{iNumTrials})};
        
        % Setting up the remaining portion of the perception trials to be
        % added to the velocity segments Table 
        velSegmentsTable.("Trial")(iNumTrials) = namePercep(iNumTrials);
        velSegmentsTable.("Time")(iNumTrials) = {tempVel.("Time").(namePercep{iNumTrials})};
        velSegmentsTable.("CoM_X-Y-Z")(iNumTrials) = {tempVel.("CoM").(namePercep{iNumTrials})};
        velSegmentsTable.("Torso")(iNumTrials) = {tempVel.("Torso").(namePercep{iNumTrials})};
        velSegmentsTable.("Pelvis")(iNumTrials) = {tempVel.("Pelvis").(namePercep{iNumTrials})};
        velSegmentsTable.("r_Femur")(iNumTrials) = {tempVel.("r_Femur").(namePercep{iNumTrials})};
        velSegmentsTable.("r_Tibia")(iNumTrials) = {tempVel.("r_Tibia").(namePercep{iNumTrials})};
        velSegmentsTable.("r_Talus")(iNumTrials) = {tempVel.("r_Talus").(namePercep{iNumTrials})};
        velSegmentsTable.("r_Calc")(iNumTrials) = {tempVel.("r_Calc").(namePercep{iNumTrials})};
        velSegmentsTable.("r_Toes")(iNumTrials) = {tempVel.("r_Toes").(namePercep{iNumTrials})};
        velSegmentsTable.("l_Femur")(iNumTrials) = {tempVel.("l_Femur").(namePercep{iNumTrials})};
        velSegmentsTable.("l_Tibia")(iNumTrials) = {tempVel.("l_Tibia").(namePercep{iNumTrials})};
        velSegmentsTable.("l_Talus")(iNumTrials) = {tempVel.("l_Talus").(namePercep{iNumTrials})};
        velSegmentsTable.("l_Calc")(iNumTrials) = {tempVel.("l_Calc").(namePercep{iNumTrials})};
        velSegmentsTable.("l_Toes")(iNumTrials) = {tempVel.("l_Toes").(namePercep{iNumTrials})}; 
        
        % Setting up the remaining portion of the perception trials to be
        % added to the accelerations segments Table 
        accSegmentsTable.("Trial")(iNumTrials) = namePercep(iNumTrials);
        accSegmentsTable.("Time")(iNumTrials) = {tempAcc.("Time").(namePercep{iNumTrials})};
        accSegmentsTable.("CoM_X-Y-Z")(iNumTrials) = {tempAcc.("CoM").(namePercep{iNumTrials})};
        accSegmentsTable.("Torso")(iNumTrials) = {tempAcc.("Torso").(namePercep{iNumTrials})};
        accSegmentsTable.("Pelvis")(iNumTrials) = {tempAcc.("Pelvis").(namePercep{iNumTrials})};
        accSegmentsTable.("r_Femur")(iNumTrials) = {tempAcc.("r_Femur").(namePercep{iNumTrials})};
        accSegmentsTable.("r_Tibia")(iNumTrials) = {tempAcc.("r_Tibia").(namePercep{iNumTrials})};
        accSegmentsTable.("r_Talus")(iNumTrials) = {tempAcc.("r_Talus").(namePercep{iNumTrials})};
        accSegmentsTable.("r_Calc")(iNumTrials) = {tempAcc.("r_Calc").(namePercep{iNumTrials})};
        accSegmentsTable.("r_Toes")(iNumTrials) = {tempAcc.("r_Toes").(namePercep{iNumTrials})};
        accSegmentsTable.("l_Femur")(iNumTrials) = {tempAcc.("l_Femur").(namePercep{iNumTrials})};
        accSegmentsTable.("l_Tibia")(iNumTrials) = {tempAcc.("l_Tibia").(namePercep{iNumTrials})};
        accSegmentsTable.("l_Talus")(iNumTrials) = {tempAcc.("l_Talus").(namePercep{iNumTrials})};
        accSegmentsTable.("l_Calc")(iNumTrials) = {tempAcc.("l_Calc").(namePercep{iNumTrials})};
        accSegmentsTable.("l_Toes")(iNumTrials) = {tempAcc.("l_Toes").(namePercep{iNumTrials})}; 
        
        % Setting up the remaining portion of the perception trials to be
        % added to the angular velocity segments Table 
        angVelSegmentsTable.("Trial")(iNumTrials) = namePercep(iNumTrials);
        angVelSegmentsTable.("Time")(iNumTrials) = {tempAngVel.("Time").(namePercep{iNumTrials})};
        angVelSegmentsTable.("Torso_X-Y-Z")(iNumTrials) = {tempAngVel.("Torso").(namePercep{iNumTrials})};
        angVelSegmentsTable.("Pelvis")(iNumTrials) = {tempAngVel.("Pelvis").(namePercep{iNumTrials})};
        angVelSegmentsTable.("r_Femur")(iNumTrials) = {tempAngVel.("r_Femur").(namePercep{iNumTrials})};
        angVelSegmentsTable.("r_Tibia")(iNumTrials) = {tempAngVel.("r_Tibia").(namePercep{iNumTrials})};
        angVelSegmentsTable.("r_Talus")(iNumTrials) = {tempAngVel.("r_Talus").(namePercep{iNumTrials})};
        angVelSegmentsTable.("r_Calc")(iNumTrials) = {tempAngVel.("r_Calc").(namePercep{iNumTrials})};
        angVelSegmentsTable.("r_Toes")(iNumTrials) = {tempAngVel.("r_Toes").(namePercep{iNumTrials})};
        angVelSegmentsTable.("l_Femur")(iNumTrials) = {tempAngVel.("l_Femur").(namePercep{iNumTrials})};
        angVelSegmentsTable.("l_Tibia")(iNumTrials) = {tempAngVel.("l_Tibia").(namePercep{iNumTrials})};
        angVelSegmentsTable.("l_Talus")(iNumTrials) = {tempAngVel.("l_Talus").(namePercep{iNumTrials})};
        angVelSegmentsTable.("l_Calc")(iNumTrials) = {tempAngVel.("l_Calc").(namePercep{iNumTrials})};
        angVelSegmentsTable.("l_Toes")(iNumTrials) = {tempAngVel.("l_Toes").(namePercep{iNumTrials})}; 
    end
    
    
end

%% This section will do the addition of all the treadmill trials to the tables 

% This loop finds the indicies of the position CoM table of the subsections of
% each perception trial 
for iTreadtrials = 1:size(posTable1.('Trial Name'),1)
    A(iTreadtrials) = contains(posTable1.('Trial Name'){iTreadtrials}, 'Treadmill');
end

if numTreadmillTrials <= 4 
    Tread1 = find(A == 1); % Indicies for Treadmill trials in the trialTable
else                                                                    % Need to figure out how to adjust for more trials IE if there are bad trials and we recorded up through Percep06 or something 
end

% Adding the treadmill trials to the position table for all the segments
for iTread1 = 1:size(Tread1,2)
    tempRow = size(posSegmentsTable,1) + 1;
    posSegmentsTable.("Trial")(tempRow) = nameTreadmill(iTread1);
    posSegmentsTable.("Time")(tempRow) = posTable1.("Time (s)")(Tread1(iTread1));
    posSegmentsTable.("CoM_X-Y-Z")(tempRow) = posTable1.("CoM")(Tread1(iTread1));
    posSegmentsTable.("Torso")(tempRow) = posTable1.("Torso")(Tread1(iTread1));
    posSegmentsTable.("Pelvis")(tempRow) = posTable1.("Pelvis")(Tread1(iTread1));
    posSegmentsTable.("r_Femur")(tempRow) = posTable1.("r_Femur")(Tread1(iTread1));
    posSegmentsTable.("r_Tibia")(tempRow) = posTable1.("r_Tibia")(Tread1(iTread1));
    posSegmentsTable.("r_Talus")(tempRow) = posTable1.("r_Talus")(Tread1(iTread1));
    posSegmentsTable.("r_Calc")(tempRow) = posTable1.("r_Calc")(Tread1(iTread1));
    posSegmentsTable.("r_Toes")(tempRow) = posTable1.("r_Toes")(Tread1(iTread1));
    posSegmentsTable.("l_Femur")(tempRow) = posTable1.("l_Femur")(Tread1(iTread1));
    posSegmentsTable.("l_Tibia")(tempRow) = posTable1.("l_Tibia")(Tread1(iTread1));
    posSegmentsTable.("l_Talus")(tempRow) = posTable1.("l_Talus")(Tread1(iTread1));
    posSegmentsTable.("l_Calc")(tempRow) = posTable1.("l_Calc")(Tread1(iTread1));
    posSegmentsTable.("l_Toes")(tempRow) = posTable1.("l_Toes")(Tread1(iTread1));  
end

% This loop finds the indicies of the position CoM table of the subsections of
% each perception trial 
for iTreadtrials = 1:size(velTable1.('Trial Name'),1)
    B(iTreadtrials) = contains(velTable1.('Trial Name'){iTreadtrials}, 'Treadmill');
end

if numTreadmillTrials <= 4 
    Tread2 = find(B == 1); % Indicies for Treadmill trials in the trialTable
else                                                                    % Need to figure out how to adjust for more trials IE if there are bad trials and we recorded up through Percep06 or something 
end

% Adding the treadmill trials to velSegments Table 
for iTread2 = 1:size(Tread2,2)
    tempRow = size(velSegmentsTable,1) + 1;
    velSegmentsTable.("Trial")(tempRow) = nameTreadmill(iTread2);
    velSegmentsTable.("Time")(tempRow) = velTable1.("Time (s)")(Tread2(iTread2));
    velSegmentsTable.("CoM_X-Y-Z")(tempRow) = velTable1.("CoM")(Tread2(iTread2));
    velSegmentsTable.("Torso")(tempRow) = velTable1.("Torso")(Tread2(iTread2));
    velSegmentsTable.("Pelvis")(tempRow) = velTable1.("Pelvis")(Tread2(iTread2));
    velSegmentsTable.("r_Femur")(tempRow) = velTable1.("r_Femur")(Tread2(iTread2));
    velSegmentsTable.("r_Tibia")(tempRow) = velTable1.("r_Tibia")(Tread2(iTread2));
    velSegmentsTable.("r_Talus")(tempRow) = velTable1.("r_Talus")(Tread2(iTread2));
    velSegmentsTable.("r_Calc")(tempRow) = velTable1.("r_Calc")(Tread2(iTread2));
    velSegmentsTable.("r_Toes")(tempRow) = velTable1.("r_Toes")(Tread2(iTread2));
    velSegmentsTable.("l_Femur")(tempRow) = velTable1.("l_Femur")(Tread2(iTread2));
    velSegmentsTable.("l_Tibia")(tempRow) = velTable1.("l_Tibia")(Tread2(iTread2));
    velSegmentsTable.("l_Talus")(tempRow) = velTable1.("l_Talus")(Tread2(iTread2));
    velSegmentsTable.("l_Calc")(tempRow) = velTable1.("l_Calc")(Tread2(iTread2));
    velSegmentsTable.("l_Toes")(tempRow) = velTable1.("l_Toes")(Tread2(iTread2));  
end

% Adding the treadmill trials to the angular velocity segments table 
for iTread2 = 1:size(Tread2,2)
    tempRow = size(angVelSegmentsTable,1) + 1;
    angVelSegmentsTable.("Trial")(tempRow) = nameTreadmill(iTread2);
    angVelSegmentsTable.("Time")(tempRow) = angvelTable1.("Time (s)")(Tread2(iTread2));
    angVelSegmentsTable.("Torso_X-Y-Z")(tempRow) = angvelTable1.("Torso")(Tread2(iTread2));
    angVelSegmentsTable.("Pelvis")(tempRow) = angvelTable1.("Pelvis")(Tread2(iTread2));
    angVelSegmentsTable.("r_Femur")(tempRow) = angvelTable1.("r_Femur")(Tread2(iTread2));
    angVelSegmentsTable.("r_Tibia")(tempRow) = angvelTable1.("r_Tibia")(Tread2(iTread2));
    angVelSegmentsTable.("r_Talus")(tempRow) = angvelTable1.("r_Talus")(Tread2(iTread2));
    angVelSegmentsTable.("r_Calc")(tempRow) = angvelTable1.("r_Calc")(Tread2(iTread2));
    angVelSegmentsTable.("r_Toes")(tempRow) = angvelTable1.("r_Toes")(Tread2(iTread2));
    angVelSegmentsTable.("l_Femur")(tempRow) = angvelTable1.("l_Femur")(Tread2(iTread2));
    angVelSegmentsTable.("l_Tibia")(tempRow) = angvelTable1.("l_Tibia")(Tread2(iTread2));
    angVelSegmentsTable.("l_Talus")(tempRow) = angvelTable1.("l_Talus")(Tread2(iTread2));
    angVelSegmentsTable.("l_Calc")(tempRow) = angvelTable1.("l_Calc")(Tread2(iTread2));
    angVelSegmentsTable.("l_Toes")(tempRow) = angvelTable1.("l_Toes")(Tread2(iTread2));  
end

% This loop finds the indicies of the position CoM table of the subsections of
% each perception trial 
for iTreadtrials = 1:size(accTable1.('Trial Name'),1)
    C(iTreadtrials) = contains(accTable1.('Trial Name'){iTreadtrials}, 'Treadmill');
end

if numTreadmillTrials <= 4 
    Tread3 = find(C == 1); % Indicies for Treadmill trials in the trialTable
else                                                                    % Need to figure out how to adjust for more trials IE if there are bad trials and we recorded up through Percep06 or something 
end

% Adding the treadmill trials to the accelerations segments table 
for iTread3 = 1:size(Tread3,2)
    tempRow = size(accSegmentsTable,1) + 1;
    accSegmentsTable.("Trial")(tempRow) = nameTreadmill(iTread3);
    accSegmentsTable.("Time")(tempRow) = accTable1.("Time (s)")(Tread3(iTread3));
    accSegmentsTable.("CoM_X-Y-Z")(tempRow) = accTable1.("CoM")(Tread3(iTread3));
    accSegmentsTable.("Torso")(tempRow) = accTable1.("Torso")(Tread3(iTread3));
    accSegmentsTable.("Pelvis")(tempRow) = accTable1.("Pelvis")(Tread3(iTread3));
    accSegmentsTable.("r_Femur")(tempRow) = accTable1.("r_Femur")(Tread3(iTread3));
    accSegmentsTable.("r_Tibia")(tempRow) = accTable1.("r_Tibia")(Tread3(iTread3));
    accSegmentsTable.("r_Talus")(tempRow) = accTable1.("r_Talus")(Tread3(iTread3));
    accSegmentsTable.("r_Calc")(tempRow) = accTable1.("r_Calc")(Tread3(iTread3));
    accSegmentsTable.("r_Toes")(tempRow) = accTable1.("r_Toes")(Tread3(iTread3));
    accSegmentsTable.("l_Femur")(tempRow) = accTable1.("l_Femur")(Tread3(iTread3));
    accSegmentsTable.("l_Tibia")(tempRow) = accTable1.("l_Tibia")(Tread3(iTread3));
    accSegmentsTable.("l_Talus")(tempRow) = accTable1.("l_Talus")(Tread3(iTread3));
    accSegmentsTable.("l_Calc")(tempRow) = accTable1.("l_Calc")(Tread3(iTread3));
    accSegmentsTable.("l_Toes")(tempRow) = accTable1.("l_Toes")(Tread3(iTread3));  
end

clearvars -except posSegmentsTable velSegmentsTable angVelSegmentsTable accSegmentsTable subject1
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
save([tabLoc 'SegmentsTables_' subject1], 'posSegmentsTable', 'velSegmentsTable', 'angVelSegmentsTable', 'accSegmentsTable', '-v7.3');

disp(['Tables saved for ' subject1]);
    
end

