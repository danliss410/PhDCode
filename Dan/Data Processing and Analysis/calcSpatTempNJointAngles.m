function [spatTempTable,jointAnglesTable, headCalcStruc] = calcSpatTempNJointAngles(strSubject, numTrials,numTreadmillTrials, isRBHD)
%
% This function calculates spatiotemporal parameters listed above as well
% as joint angles (ankle, knee, hip) for each subject
% and saves them in a table. 
%
% INPUTS: subject               - string of the subject number 
%
%         numTrials             - number (double) of whole perception trials (Should be 4,
%                                   but may be more or less depending on if recording was messed up)
%         numTreamillTrials     - number (double) of treadmill trials (Should be 2-3,
%                                   but may be more depending on if recording was messed up)
%         isRBHD                - binary 0 if LBHD is in most trials or 1
%                                 if RBHD is in most trials for the head
%                                 calculations.
%
% OUPUT: spatTempTable - spatioTemporalTable will contain step length, step width, swing time,
%                       stance time, double support time for each leg.
%
%        jointAnglesTable - contains the ankle, hip, and knee joint angles
%                           for each leg for all trials concatenated from OpenSim IKResult files. 
% 
% 
%       sensoryFeedbackTable - contains head deviation
%
% Calculated SPT based on this website http://www.optogait.com/Gait-Phases
%
%
% Created: 12 September, 2020 DJL 
% Modified: (format: date, initials, change made)
%   1 -  16th Feb. 2021, DJL, updated to get rid of dynamic stability table
%   and contain the joint angles (ankle, hip, knee). 
%   2 - 
% Things that need to be added 
%   1 - Cognitive or 2AFC trials 

%% Create subject name to load the necessary files for the subject 
% Naming convention for each log file "YAPercep##_" + YesNo or 2AFC or Cog

subjectYesNo = ['YAPercep' strSubject '_YesNo'];

subject2AFC = ['YAPercep' strSubject '_2AFC'];

subjectCog = ['YAPercep' strSubject '_Cog'];

subject1 = ['YAPercep' strSubject];

namePercep = {'Percep02'; 'Percep03'; 'Percep04'; 'Percep05'; 'Percep06';}; %'Percep01'; 
%% Loading the remaining tables for the subject 
% This section will load muscleTable, analogTable, gaitEventsTable,
% IKTable, pertTable, and videoTable(This will not be used)

load(['G:\Shared drives\NeuroMobLab\Projects\Perception\Processed Data\Dan\OpenSim\YAPercep Outputs\' subject1 '\Data Tables\BodyAnalysisTable_' subject1 '.mat'])
load(['G:\Shared drives\NeuroMobLab\Projects\Perception\Processed Data\Dan\Matlab Analysis\' subject1 '\Data Tables\SepTables_' subject1 '.mat'])
load(['G:\Shared drives\NeuroMobLab\Projects\Perception\Processed Data\Dan\Matlab Analysis\' subject1 '\Data Tables\pertTable_' subject1 '.mat'])

%% Calculating the Spatiotemporal parameters for Perception Trials 
% The following spatiotemporal paramters will be calculated as defined
% here from websites:  
% - http://www.optogait.com/Gait-Phases
% - https://www.tekscan.com/blog/medical/gait-cycle-phases-parameters-evaluate-technology#:~:text=Some%20typical%20spatial%20gait%20parameters,of%20the%20current%20opposing%20footfall.
% Stride length - the distance between the heel of two subsequent negative
% becasue of loss of reference to treadmill and foot movement 

% footprints of the same foot 
% Step length (m) - the distance between the heel of two subsequent feet
% Double Support Time (s) - The sum of the 2 times where both feet are on the
% ground. 
% Step Width (m) - the distance between the two feet at HS (measured from
% ankles)
% Swing Time (s) - the time between when the tip of the foot leaves the ground
% to when the same foot's heel strikes the ground
% Stance Time (s) - the time between when the foot's heel strikes the ground to
% when the same foot's toe leaves the ground
% Step length (m) - Calc from Toe off to HS for the same foot

% Making a matrix of legs for dynamic naming
Legs = {'L'; 'R'};

% Getting the trial names to loop through 
trialName = videoTable.Trial;

% Finding the number of trials both Perception and Treadmill trials for the
% subject
trials = size(trialName,1);

% This loop will calculate the spatial temporal parameters for each trial
% and each leg when necessary 
for iTrials = 1:trials
    for iLeg = 1:length(Legs)
        if Legs{iLeg} == 'L'
            sptCalc.(Legs{iLeg}).strideL{iTrials} = videoTable.("Marker_Data"){iTrials}(gaitEventsTable.("Gait_Events_Left"){iTrials}(:,5),22,1)-videoTable.("Marker_Data"){iTrials}(gaitEventsTable.("Gait_Events_Left"){iTrials}(:,1),22,1);
            sptCalc.(Legs{iLeg}).stepL{iTrials} = videoTable.("Marker_Data"){iTrials}(gaitEventsTable.("Gait_Events_Left"){iTrials}(:,3),30,1) - videoTable.("Marker_Data"){iTrials}(gaitEventsTable.("Gait_Events_Left"){iTrials}(:,1),22,1);
            sptCalc.(Legs{iLeg}).dblSupT{iTrials} = ((gaitEventsTable.("Gait_Events_Left"){iTrials}(:,2)-gaitEventsTable.("Gait_Events_Left"){iTrials}(:,1))+ (gaitEventsTable.("Gait_Events_Left"){iTrials}(:,4)-gaitEventsTable.("Gait_Events_Left"){iTrials}(:,3)))/100;
            sptCalc.(Legs{iLeg}).stepW{iTrials} = videoTable.("Marker_Data"){iTrials}(gaitEventsTable.("Gait_Events_Left"){iTrials}(:,5),21,2) - videoTable.("Marker_Data"){iTrials}(gaitEventsTable.("Gait_Events_Left"){iTrials}(:,1),29,2);   
            sptCalc.(Legs{iLeg}).swingT{iTrials} = (gaitEventsTable.("Gait_Events_Left"){iTrials}(:,5) - gaitEventsTable.("Gait_Events_Left"){iTrials}(:,4))/100;
            sptCalc.(Legs{iLeg}).stanceT{iTrials} = (gaitEventsTable.("Gait_Events_Left"){iTrials}(:,4) - gaitEventsTable.("Gait_Events_Left"){iTrials}(:,1))/100;
        else
            sptCalc.(Legs{iLeg}).strideL{iTrials} = videoTable.("Marker_Data"){iTrials}(gaitEventsTable.("Gait_Events_Right"){iTrials}(:,5),30,1)-videoTable.("Marker_Data"){iTrials}(gaitEventsTable.("Gait_Events_Right"){iTrials}(:,1),30,1);
            sptCalc.(Legs{iLeg}).stepL{iTrials} = videoTable.("Marker_Data"){iTrials}(gaitEventsTable.("Gait_Events_Right"){iTrials}(:,3),22,1) - videoTable.("Marker_Data"){iTrials}(gaitEventsTable.("Gait_Events_Right"){iTrials}(:,1),30,1);
            sptCalc.(Legs{iLeg}).dblSupT{iTrials} = ((gaitEventsTable.("Gait_Events_Right"){iTrials}(:,2)-gaitEventsTable.("Gait_Events_Right"){iTrials}(:,1))+ (gaitEventsTable.("Gait_Events_Right"){iTrials}(:,4)-gaitEventsTable.("Gait_Events_Right"){iTrials}(:,3)))/100;
            sptCalc.(Legs{iLeg}).stepW{iTrials} = videoTable.("Marker_Data"){iTrials}(gaitEventsTable.("Gait_Events_Right"){iTrials}(:,5),29,2) - videoTable.("Marker_Data"){iTrials}(gaitEventsTable.("Gait_Events_Right"){iTrials}(:,1),21,2);          
            sptCalc.(Legs{iLeg}).swingT{iTrials} = (gaitEventsTable.("Gait_Events_Right"){iTrials}(:,5) - gaitEventsTable.("Gait_Events_Right"){iTrials}(:,4))/100;
            sptCalc.(Legs{iLeg}).stanceT{iTrials} = (gaitEventsTable.("Gait_Events_Right"){iTrials}(:,4) - gaitEventsTable.("Gait_Events_Right"){iTrials}(:,1))/100;
        end
    end
end
    

%% Placing values in a table for the spt parameters 


for iNumTrials = 1:trials % Creating a joint angle table for each subject with all knee, hip, and ankle angles for each perception trial
   if iNumTrials == 1
        spatTempTable = table(trialName(iNumTrials),{sptCalc.L.strideL{iNumTrials}}, {sptCalc.L.stepL{iNumTrials}}, {sptCalc.L.stepW{iNumTrials}}, {sptCalc.L.dblSupT{iNumTrials}},...
            {sptCalc.L.swingT{iNumTrials}}, {sptCalc.L.stanceT{iNumTrials}},...
            {sptCalc.R.strideL{iNumTrials}},{sptCalc.R.stepL{iNumTrials}}, {sptCalc.R.stepW{iNumTrials}},{sptCalc.R.dblSupT{iNumTrials}},{sptCalc.R.swingT{iNumTrials}}, {sptCalc.R.stanceT{iNumTrials}},...
            'VariableNames', {'Trial';'L_Stride_Length_(m)'; 'L_Step_Length_(m)'; 'L_Step_Width_(m)'; 'L_Double_Support_Time_(s)'; 'L_Swing_Time_(s)'; 'L_Stance_Time_(s)';...
            'R_Stride_Length_(m)'; 'R_Step_Length_(m)'; 'R_Step_Width_(m)'; 'R_Double_Support_Time_(s)'; 'R_Swing_Time_(s)'; 'R_Stance_Time_(s)';});
    else
        spatTempTable.Trial(iNumTrials) = trialName(iNumTrials);
        spatTempTable.('L_Stride_Length_(m)')(iNumTrials) = {sptCalc.L.strideL{iNumTrials}};
        spatTempTable.('L_Step_Length_(m)')(iNumTrials) = {sptCalc.L.stepL{iNumTrials}};
        spatTempTable.('L_Step_Width_(m)')(iNumTrials) = {sptCalc.L.stepW{iNumTrials}};
        spatTempTable.('L_Double_Support_Time_(s)')(iNumTrials) = {sptCalc.L.dblSupT{iNumTrials}};
        spatTempTable.('L_Swing_Time_(s)')(iNumTrials) = {sptCalc.L.swingT{iNumTrials}};
        spatTempTable.('L_Stance_Time_(s)')(iNumTrials) = {sptCalc.L.stanceT{iNumTrials}};
        spatTempTable.('R_Stride_Length_(m)')(iNumTrials) = {sptCalc.R.strideL{iNumTrials}};
        spatTempTable.('R_Step_Length_(m)')(iNumTrials) = {sptCalc.R.stepL{iNumTrials}};
        spatTempTable.('R_Step_Width_(m)')(iNumTrials) = {sptCalc.R.stepW{iNumTrials}};
        spatTempTable.('R_Double_Support_Time_(s)')(iNumTrials) = {sptCalc.R.dblSupT{iNumTrials}};
        spatTempTable.('R_Swing_Time_(s)')(iNumTrials) = {sptCalc.R.swingT{iNumTrials}};
        spatTempTable.('R_Stance_Time_(s)')(iNumTrials) = {sptCalc.R.stanceT{iNumTrials}};
   end   
end

%% Load IK Results to get Joint Angles 
if ispc
    fileLocation = 'G:\Shared drives\NeuroMobLab\Projects\Perception\Processed Data\Dan\OpenSim\YAPercep Outputs\';
elseif ismac %################# Need to add the spots for a mac
%     fileLocation = '/Volumes/GoogleDrive/Shared drives/NeuroMobLab/Experimental Data/Vicon Matlab Processed/Pilot Experiments/WVCTSI_Perception2019/';
else
    fileLocation = input('Please enter the file location:' );
end


startLocation = 'D:\Github\Perception-Project\Dan\Data Processing and Analysis\'; %Location where all the functions and matlab scripts are 

IKLoc = [fileLocation subject1 filesep 'IKResults and Analysis Output' filesep]; % Creating new location based on the subject that is being processed for IK data

cd(IKLoc)

% Create directory of files that need to be loaded for each subject for IK 
IKDir = dir(IKLoc);
IKDir = IKDir(3:end);

% This gives you the indicies of all the open sim data IK results. 
for i = 1:size(IKDir,1)
    IKResults1(i) = contains(IKDir(i).('name'), "_ik.mot");
end

% This will create the directory where the joint angles will be pulled
IKRDir = IKDir(IKResults1);
IKRDir = IKRDir(2:end);

% Importing the joint angles for each trial name and putting them into a
% table 
for iTrials = 1:length(IKRDir)
    ANG = importdata(IKRDir(iTrials).name); % opening the file
    
    t = ANG.data(:,1); % time 
        
    ank_r = ANG.data(:,12); % Right Ankle Angle 
    knee_r = ANG.data(:,11); % Right Knee Angle 
    hip_r = ANG.data(:,8); % Right Hip Flexion Angle 
        
    ank_l = ANG.data(:,19); % Right Ankle Angle 
    knee_l = ANG.data(:,18); % Right Knee Angle 
    hip_l = ANG.data(:,15); % Right Hip Flexion Angle 
            
    if iTrials == 1 % Creating the table for tendon length for 4 musculotendons on each leg
        angleTable1 = table({IKRDir(iTrials).name}, {t}, {ank_r}, {knee_r}, {hip_r},...
            {ank_l}, {knee_l}, {hip_l}, 'VariableNames',{'Trial Name';'Time (s)';...
            'R Ankle Angle (Degrees)'; 'R Knee Angle (D)';'R Hip Flexion Angle (D)';...
            'L Ankle Angle (D)'; 'L Knee Angle (D)';'L Hip Flexion Angle (D)';});
    else % Filling the table with the remaining values
        angleTable1.('Trial Name')(iTrials) = {IKRDir(iTrials).name};
        angleTable1.('Time (s)')(iTrials) = {t};
        angleTable1.('R Ankle Angle (Degrees)')(iTrials) = {ank_r};
        angleTable1.('R Knee Angle (D)')(iTrials) = {knee_r};
        angleTable1.('R Hip Flexion Angle (D)')(iTrials) = {hip_r};
        angleTable1.('L Ankle Angle (D)')(iTrials) = {ank_l};
        angleTable1.('L Knee Angle (D)')(iTrials) = {knee_l};
        angleTable1.('L Hip Flexion Angle (D)')(iTrials) = {hip_l};
    end
end

clearvars -except angleTable1 subjectYesNo subject2AFC subjectCog subject1 numTrials numTreadmillTrials spatTempTable trials videoTable isRBHD

% Preallocated names to pull from later in loops for Treadmill Trials 
nameTreadmill = {'Treadmill01'; 'Treadmill02'; 'Treadmill03'; 'Treadmill04'; 'Treadmill05'; 'Treadmill06'};

% Preallocated names to pull from later in loops for Perception Trials 
namePercep = {'Percep01'; 'Percep02'; 'Percep03'; 'Percep04'; 'Percep05'; 'Percep06'; 'Percep07'; 'Percep08';}; % 

%% This will concatenate all the joint angles for each subtrial into a trial 
% This loop finds the indicies of the position table of the subsections of
% each perception trial 
for iSubtrials = 1:size(angleTable1.('Trial Name'),1)
    angA(iSubtrials) = contains(angleTable1.('Trial Name'){iSubtrials}, 'Percep01');
    angB(iSubtrials) = contains(angleTable1.('Trial Name'){iSubtrials}, 'Percep02');
    angC(iSubtrials) = contains(angleTable1.('Trial Name'){iSubtrials}, 'Percep03');
    angD(iSubtrials) = contains(angleTable1.('Trial Name'){iSubtrials}, 'Percep04');
    angE(iSubtrials) = contains(angleTable1.('Trial Name'){iSubtrials}, 'Percep05');
    angF(iSubtrials) = contains(angleTable1.('Trial Name'){iSubtrials}, 'Percep06');
    angG(iSubtrials) = contains(angleTable1.('Trial Name'){iSubtrials}, 'Percep07');
    angH(iSubtrials) = contains(angleTable1.('Trial Name'){iSubtrials}, 'Percep08');
end

if numTrials <= 5 
    angA = find(angA == 1); % Indicies for Percep01 in the posTable
    angB = find(angB == 1); % Indicies for Percep02 in the posTable
    angC = find(angC == 1); % Indicies for Percep03 in the posTable
    angD = find(angD == 1); % Indicies for Percep04 in the posTable
    angE = find(angE == 1); 
else % Need to figure out how to adjust for more trials IE if there are bad trials and we recorded up through Percep06 or something 
end

% Combining all the subtrials of position CoM to one matrix 
temp1 = {angA;angB; angC; angD; angE}; % 


for iNumTrials = 1:numTrials
%     Creating empty matricies for preallocating space for later in the
%     loop
    jAng.('R_Ankle_Angle').(namePercep{iNumTrials}) = []; 
    jAng.("R_Knee_Angle").(namePercep{iNumTrials}) = []; 
    jAng.("R_Hip_Flexion_Angle").(namePercep{iNumTrials}) = []; 
    jAng.("L_Ankle_Angle").(namePercep{iNumTrials}) = []; 
    jAng.("L_Knee_Angle").(namePercep{iNumTrials}) = []; 
    jAng.("L_Hip_Flexion_Angle").(namePercep{iNumTrials}) = []; 
    jAng.('Time').(namePercep{iNumTrials}) = [];
    for iSectPercep = 1:size(temp1{iNumTrials},2) % Concatenate all the joint angles for the subtrials of the Perception trials
        if iSectPercep > 1 
            jAng.('R_Ankle_Angle').(namePercep{iNumTrials}) = [jAng.('R_Ankle_Angle').(namePercep{iNumTrials}); angleTable1.('R Ankle Angle (Degrees)'){temp1{iNumTrials}(iSectPercep)}(2:end)]; 
            jAng.("R_Knee_Angle").(namePercep{iNumTrials}) = [jAng.("R_Knee_Angle").(namePercep{iNumTrials}); angleTable1.("R Knee Angle (D)"){temp1{iNumTrials}(iSectPercep)}(2:end)]; 
            jAng.("R_Hip_Flexion_Angle").(namePercep{iNumTrials}) = [jAng.("R_Hip_Flexion_Angle").(namePercep{iNumTrials}); angleTable1.("R Hip Flexion Angle (D)"){temp1{iNumTrials}(iSectPercep)}(2:end)]; 
            jAng.('L_Ankle_Angle').(namePercep{iNumTrials}) = [jAng.('L_Ankle_Angle').(namePercep{iNumTrials}); angleTable1.('L Ankle Angle (D)'){temp1{iNumTrials}(iSectPercep)}(2:end)]; 
            jAng.("L_Knee_Angle").(namePercep{iNumTrials}) = [jAng.("L_Knee_Angle").(namePercep{iNumTrials}); angleTable1.("L Knee Angle (D)"){temp1{iNumTrials}(iSectPercep)}(2:end)]; 
            jAng.("L_Hip_Flexion_Angle").(namePercep{iNumTrials}) = [jAng.("L_Hip_Flexion_Angle").(namePercep{iNumTrials}); angleTable1.("L Hip Flexion Angle (D)"){temp1{iNumTrials}(iSectPercep)}(2:end)];
            jAng.('Time').(namePercep{iNumTrials}) = [jAng.('Time').(namePercep{iNumTrials}); jAng.('Time').(namePercep{iNumTrials})(end)+ angleTable1.("Time (s)"){temp1{iNumTrials}(iSectPercep)}(2:end)];
        else
            jAng.('R_Ankle_Angle').(namePercep{iNumTrials}) = [angleTable1.('R Ankle Angle (Degrees)'){temp1{iNumTrials}(iSectPercep)};]; 
            jAng.("R_Knee_Angle").(namePercep{iNumTrials}) = [angleTable1.("R Knee Angle (D)"){temp1{iNumTrials}(iSectPercep)};]; 
            jAng.("R_Hip_Flexion_Angle").(namePercep{iNumTrials}) = [angleTable1.("R Hip Flexion Angle (D)"){temp1{iNumTrials}(iSectPercep)}]; 
            jAng.('L_Ankle_Angle').(namePercep{iNumTrials}) = [angleTable1.('L Ankle Angle (D)'){temp1{iNumTrials}(iSectPercep)};]; 
            jAng.("L_Knee_Angle").(namePercep{iNumTrials}) = [angleTable1.("L Knee Angle (D)"){temp1{iNumTrials}(iSectPercep)};]; 
            jAng.("L_Hip_Flexion_Angle").(namePercep{iNumTrials}) = [angleTable1.("L Hip Flexion Angle (D)"){temp1{iNumTrials}(iSectPercep)}]; 
            jAng.('Time').(namePercep{iNumTrials}) = [angleTable1.("Time (s)"){temp1{iNumTrials}(iSectPercep)}];        
        end     
    end  
end


for iNumTrials = 1:numTrials % Creating a joint angle table for each subject with all knee, hip, and ankle angles for each perception trial
   if iNumTrials == 1
        jointAnglesTable = table(namePercep(iNumTrials),{jAng.Time.(namePercep{iNumTrials})}, {jAng.('R_Ankle_Angle').(namePercep{iNumTrials})}, {jAng.('R_Knee_Angle').(namePercep{iNumTrials})},...
            {jAng.('R_Hip_Flexion_Angle').(namePercep{iNumTrials})}, {jAng.('L_Ankle_Angle').(namePercep{iNumTrials})},{jAng.('L_Knee_Angle').(namePercep{iNumTrials})},...
            {jAng.('L_Hip_Flexion_Angle').(namePercep{iNumTrials})},...
            'VariableNames', {'Trial';'Time_(s)'; 'R_Ankle_Angle_(Degrees)'; 'R_Knee_Angle_(D)'; 'R_Hip_Flexion_Angle_(D)'; 'L_Ankle_Angle_(D)'; 'L_Knee_Angle_(D)';...
            'L_Hip_Flexion_Angle_(D)';});
    else
        jointAnglesTable.Trial(iNumTrials) = namePercep(iNumTrials);
        jointAnglesTable.('Time_(s)')(iNumTrials) = {jAng.Time.(namePercep{iNumTrials})};
        jointAnglesTable.('R_Ankle_Angle_(Degrees)')(iNumTrials) = {jAng.('R_Ankle_Angle').(namePercep{iNumTrials})};
        jointAnglesTable.('R_Knee_Angle_(D)')(iNumTrials) = {jAng.('R_Knee_Angle').(namePercep{iNumTrials})};
        jointAnglesTable.('R_Hip_Flexion_Angle_(D)')(iNumTrials) = {jAng.('R_Hip_Flexion_Angle').(namePercep{iNumTrials})};
        jointAnglesTable.('L_Ankle_Angle_(D)')(iNumTrials) = {jAng.('L_Ankle_Angle').(namePercep{iNumTrials})};
        jointAnglesTable.('L_Knee_Angle_(D)')(iNumTrials) = {jAng.('L_Knee_Angle').(namePercep{iNumTrials})};
        jointAnglesTable.('L_Hip_Flexion_Angle_(D)')(iNumTrials) = {jAng.('L_Hip_Flexion_Angle').(namePercep{iNumTrials})};
   end   
end

%% Adding the treadmill trials to the IK table 

% This loop finds the indicies of the position CoM table of the subsections of
% each perception trial 
for iTreadtrials = 1:size(angleTable1.('Trial Name'),1)
    A(iTreadtrials) = contains(angleTable1.('Trial Name'){iTreadtrials}, 'Treadmill');
end

if numTreadmillTrials <= 4 
    Tread1 = find(A == 1); % Indicies for Treadmill trials in the trialTable
else                                                                    % Need to figure out how to adjust for more trials IE if there are bad trials and we recorded up through Percep06 or something 
end


for iTread1 = 1:size(Tread1,2) % Concatenate all the position CoM calculations for the Treadmill trials
    jAng.("R_Ankle_Angle").(nameTreadmill{iTread1}) = [angleTable1.('R Ankle Angle (Degrees)'){Tread1(iTread1)};]; 
    jAng.("R_Knee_Angle").(nameTreadmill{iTread1}) = [angleTable1.('R Knee Angle (D)'){Tread1(iTread1)};]; 
    jAng.("R_Hip_Flexion_Angle").(nameTreadmill{iTread1}) = [angleTable1.('R Hip Flexion Angle (D)'){Tread1(iTread1)}];
    jAng.("L_Ankle_Angle").(nameTreadmill{iTread1}) = [angleTable1.('L Ankle Angle (D)'){Tread1(iTread1)};]; 
    jAng.("L_Knee_Angle").(nameTreadmill{iTread1}) = [angleTable1.('L Knee Angle (D)'){Tread1(iTread1)};]; 
    jAng.("L_Hip_Flexion_Angle").(nameTreadmill{iTread1}) = [angleTable1.('L Hip Flexion Angle (D)'){Tread1(iTread1)}]; 
    jAng.('Time').(nameTreadmill{iTread1}) = [angleTable1.("Time (s)"){Tread1(iTread1)}]; 
end

  

for iNumTrials = 1:numTreadmillTrials % Creating a IK table for each subject with all CoM data for each treadmill trial
    tempRow = size(jointAnglesTable,1) + 1;
    jointAnglesTable.Trial(tempRow) = nameTreadmill(iNumTrials);
    jointAnglesTable.('Time_(s)')(tempRow) = {jAng.Time.(nameTreadmill{iNumTrials})};
    jointAnglesTable.('R_Ankle_Angle_(Degrees)')(tempRow) = {jAng.('R_Ankle_Angle').(nameTreadmill{iNumTrials})};
    jointAnglesTable.('R_Knee_Angle_(D)')(tempRow) = {jAng.('R_Knee_Angle').(nameTreadmill{iNumTrials})};
    jointAnglesTable.('R_Hip_Flexion_Angle_(D)')(tempRow) = {jAng.('R_Hip_Flexion_Angle').(nameTreadmill{iNumTrials})};
    jointAnglesTable.('L_Ankle_Angle_(D)')(tempRow) = {jAng.('L_Ankle_Angle').(nameTreadmill{iNumTrials})};
    jointAnglesTable.('L_Knee_Angle_(D)')(tempRow) = {jAng.('L_Knee_Angle').(nameTreadmill{iNumTrials})};
    jointAnglesTable.('L_Hip_Flexion_Angle_(D)')(tempRow) = {jAng.('L_Hip_Flexion_Angle').(nameTreadmill{iNumTrials})};
end


%% Calculating head variables for visual and vestibular feedback contributions 

for iTrials = 1:trials
    marker_data = videoTable.("Marker_Data"){iTrials,1};
    SampleRate = 100; % Sample rate of markers collected through Vicon is 100 Hz 
    isSplitTrial = 0; % Saying that all the trials are concatenated already
    [headAngle, headAngularVelocity,headAngularAcceleration] =  calcAngleOfHead(marker_data, SampleRate, isSplitTrial, isRBHD);
    headCalcStruc.(videoTable.Trial{iTrials}).headAngle = headAngle;
    headCalcStruc.(videoTable.Trial{iTrials}).headAngularVelocity = headAngularVelocity;
    headCalcStruc.(videoTable.Trial{iTrials}).headAngularAcceleration = headAngularAcceleration;
    clear headAngle headAngularVelocity headAngularAcceleration markerData
end
    


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

% Saving the head calculations structure for each
% subject 
save([tabLoc 'headCalcStruc_' subject1], 'headCalcStruc', '-v7.3');

% Saving the Joint Angle table to be saved for each subject
save([tabLoc 'jointAnglesTable_' subject1], 'jointAnglesTable', '-v7.3');

% Saving the Spatiotemporal Parameters table to be saved for each subject. 
save([tabLoc 'SpatiotemporalTable_' subject1], 'spatTempTable', '-v7.3');

disp(['Tables saved for ' subject1]);

end

