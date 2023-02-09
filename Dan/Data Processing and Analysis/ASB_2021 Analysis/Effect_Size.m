function [prepData, d] = Effect_Size(strSubject)
%This function will load each subjects data and calculate the cohen's d
%effect size for each percent of the gait cycle from 0-100% for all sensory
%feedback modalities. (joint angle changes, head calculations, and COP
%differences)
%   Detailed explanation goes here

%% Create subject name to load the necessary files for the subject 

subject1 = ['YAPercep' strSubject];

%% Loading the remaining tables for the subject 
% This section will load tables for the subject

load(['G:\Shared drives\NeuroMobLab\Projects\Perception\Processed Data\Dan\Full Sub Data\' subject1 '_Tables.mat']);

%% This section creates plots from -5 cycles before perturbation, Onset, +5 cycles after perturbation
nameFrames = {'Pre5Frames'; 'Pre4Frames'; 'Pre3Frames'; 'Pre2Frames'; 'Pre1Frames'; 'OnsetFrames'; 'Post1Frames'; 'Post2Frames'; 'Post3Frames'; 'Post4Frames'; 'Post5Frames';}; % -5 cycles before perturbation, Onset, and +5 cycles after perturbation
namePercep = {'Percep01'; 'Percep02'; 'Percep03'; 'Percep04'; 'Percep05'; 'Percep06';}; % name of the potential perception trials for each subject 
speeds = {'sp1'; 'sp2'; 'sp3'; 'sp4'; 'sp5'; }; %'sp6'; 'sp7'; 'sp8'}; % Speeds in order as above 0, -0.02, -0.5, -0.1, -0.15, -0.2, -0.3, -0.4
pertSpeed = {'0'; '-0.02'; '-0.05'; '-0.10'; '-0.15'; '-0.2'; '-0.3'; '-0.4';}; % Perturbation speeds for the table
namePert = {'Catch'; 'Neg02'; 'Neg05'; 'Neg10'; 'Neg15'; 'Neg20'; 'Neg30'; 'Neg40';}; %Name of the perts to save the files
leg = {'L';'R';}; % Leg

pTrials = contains(pertTable.Trial, 'Percep'); % Finding which rows in the table contain the Perception Trials

pTrials = pTrials(pTrials == 1); %Selecting only the indicies that have Perception trials

if strcmp('14', strSubject) == 1
    pertCount = {'one'; 'two'; 'three'; 'four'; 'five';'six'};
else
    pertCount = {'one'; 'two'; 'three'; 'four'; 'five';};
end

%% Getting all the values needed for the subjects levels 
for iTrial = 1:size(pTrials,1)
    rPerts{iTrial} = find(strcmp(RpertGC.Leg{iTrial}, 'R'));
    Sp{iTrial} = RpertGC.Speed{iTrial}(rPerts{iTrial});
end

for iTrial = 1:size(pTrials, 1)
    SpL{iTrial} = find(Sp{iTrial} == speedLow);
    SpH{iTrial} = find(Sp{iTrial} == speedHigh);
    perL{iTrial} = RpertGC.Perceived{iTrial}(rPerts{iTrial}(SpL{iTrial}));
    perH{iTrial} = RpertGC.Perceived{iTrial}(rPerts{iTrial}(SpH{iTrial}));
end

trialsL = find(~cellfun(@isempty,SpL)); 
trialsH = find(~cellfun(@isempty,SpH));


for iLeg = 1:size(leg,1) % Each leg
    for iSpeeds = 2:size(speeds,1)
        pertCount2 = 1;
        for iTrial = 1:size(pTrials,1) % The perturbation trials, ie Percep01-PercepXX
            temp8 = size(pertCycleStruc.(leg{iLeg}).(speeds{iSpeeds}).(namePercep{iTrial}).Perceived,1); % Getting the amount of perturbations sent at a specific speed per Perception trial
            for iPerts = 1:temp8 % -5 cycles before Pert to Onset
                for iCycle = 1:size(nameFrames,1)
                    temp1 = pertCycleStruc.(leg{iLeg}).(speeds{iSpeeds}).(namePercep{iTrial}).(nameFrames{iCycle}){1,iPerts}(1); % first heel strike of gait cycle 
                    temp2 = pertCycleStruc.(leg{iLeg}).(speeds{iSpeeds}).(namePercep{iTrial}).(nameFrames{iCycle}){1,iPerts}(5); % ending heel strike of gait cycle
                    temp4 = pertCycleStruc.(leg{iLeg}).(speeds{iSpeeds}).(namePercep{iTrial}).(nameFrames{iCycle}){1,iPerts}(4); % Toe off for the leg of the first heel strike of the gait cycle 
                    temp3 = temp2 - temp1; % Getting length of gait cycle as elasped frames

                    temp5 = temp1 * 10; 
                    temp6 = temp4 * 10;
                    temp7 = temp6-temp5;

                    if isnan(temp1) || isnan(temp2) || isnan(temp3)

                    else  
                        perceived = pertCycleStruc.(leg{iLeg}).(speeds{iSpeeds}).(namePercep{iTrial}).Perceived(iPerts);
                        tRHM_AP = videoTable.("Marker_Data"){iTrial,1}(temp1:temp4,30,1); % Right Heel Marker for AP 
                        tRHM_ML = videoTable.("Marker_Data"){iTrial,1}(temp1:temp4,30,2); % Right Heel Marker for ML 
                        ext_RHM_AP = interp(tRHM_AP, 10);
                        ext_RHM_ML = interp(tRHM_ML, 10);
                        RHM_AP = ext_RHM_AP(1:length(analogTable.COP{iTrial,1}(temp5:temp6,4))); % Making the same size as the COP data to subtract
                        RHM_ML = ext_RHM_ML(1:length(analogTable.COP{iTrial,1}(temp5:temp6,5))); % making the same size as the COP data to subtract 
                        if iCycle == 1

                            tempStore.(leg{iLeg}).(speeds{iSpeeds}).ankle.(pertCount{pertCount2}) = nan(2*temp3,size(nameFrames,1)); %Pre allocating nan space for all the sensory feedback mechanisms 
                            tempStore.(leg{iLeg}).(speeds{iSpeeds}).knee.(pertCount{pertCount2}) = nan(2*temp3,size(nameFrames,1));
                            tempStore.(leg{iLeg}).(speeds{iSpeeds}).hip.(pertCount{pertCount2}) = nan(2*temp3,size(nameFrames,1));
                            tempStore.(leg{iLeg}).(speeds{iSpeeds}).headA.(pertCount{pertCount2}) = nan(2*temp3, size(nameFrames,1));
                            tempStore.(leg{iLeg}).(speeds{iSpeeds}).headV.(pertCount{pertCount2}) = nan(2*temp3,size(nameFrames,1));

                            tempStore.(leg{iLeg}).(speeds{iSpeeds}).COPx.(pertCount{pertCount2}) = nan(2*temp7, size(nameFrames,1));
                            tempStore.(leg{iLeg}).(speeds{iSpeeds}).COPy.(pertCount{pertCount2}) = nan(2*temp7, size(nameFrames,1));
                        end
                        for i = 1:temp3
                            tempStore.(leg{iLeg}).(speeds{iSpeeds}).ankle.(pertCount{pertCount2})(i,iCycle) = jointAnglesTable.("R_Ankle_Angle_(Degrees)"){iTrial,1}(temp1+i -1); % Placing the values in a structure for -5 steps before to onset (column 1 is -5 steps and column 6 is onset).
                            tempStore.(leg{iLeg}).(speeds{iSpeeds}).knee.(pertCount{pertCount2})(i,iCycle) = jointAnglesTable.("R_Knee_Angle_(D)"){iTrial,1}(temp1+i -1);
                            tempStore.(leg{iLeg}).(speeds{iSpeeds}).hip.(pertCount{pertCount2})(i,iCycle) = jointAnglesTable.("R_Hip_Flexion_Angle_(D)"){iTrial,1}(temp1+i -1);
                            tempStore.(leg{iLeg}).(speeds{iSpeeds}).headA.(pertCount{pertCount2})(i,iCycle) = headCalcStruc.(namePercep{iTrial}).headAngle(temp1+i -1);
                            tempStore.(leg{iLeg}).(speeds{iSpeeds}).headV.(pertCount{pertCount2})(i,iCycle) = headCalcStruc.(namePercep{iTrial}).headAngularVelocity(temp1+i -1);
                        end

                        % COP data is sampled at 1000 hz not 100 so had to run in
                        % it's own loop
                        for j = 1:temp7
                            tempStore.(leg{iLeg}).(speeds{iSpeeds}).COPx.(pertCount{pertCount2})(j,iCycle) = analogTable.COP{iTrial,1}(temp5+j-1,4)- RHM_AP(j); 
                            tempStore.(leg{iLeg}).(speeds{iSpeeds}).COPy.(pertCount{pertCount2})(j,iCycle) = analogTable.COP{iTrial,1}(temp5+j-1,5)- RHM_ML(j);
                        end
                        tempStore.(leg{iLeg}).(speeds{iSpeeds}).perceived(pertCount2) = perceived;
                    end
                        clear temp1 temp2 temp 3 perceived namePerceived
                end
                pertCount2 = pertCount2 + 1;
            end
        end
    end
end

disp(['Finished pulling data for ' subject1])
%% Resizing all the data so that it goes from 0-100% of the gait cycle 
sensoryNames = {'ankle'; 'knee'; 'hip'; 'headA'; 'headV'; 'COPx'; 'COPy';};

for iLeg = 1:size(leg,1) % Each leg
    for iSpeeds = 2:size(speeds,1)
        temp9 = length(tempStore.(leg{iLeg}).(speeds{iSpeeds}).perceived);
        for iPert = 1:temp9
            for iCycle = 1:length(nameFrames)
                for iSensory = 1:length(sensoryNames)
                    tempPrep = tempStore.(leg{iLeg}).(speeds{iSpeeds}).(sensoryNames{iSensory}).(pertCount{iPert})(:,iCycle);
                    if length(tempStore.(leg{iLeg}).(speeds{iSpeeds}).(sensoryNames{iSensory}).(pertCount{iPert})(~isnan(tempPrep), iCycle)) < 101 
                        tempLength = length(tempStore.(leg{iLeg}).(speeds{iSpeeds}).(sensoryNames{iSensory}).(pertCount{iPert})(~isnan(tempPrep), iCycle));
                        if tempLength == 0
                            prepData.(leg{iLeg}).(speeds{iSpeeds}).(sensoryNames{iSensory}).(pertCount{iPert})(:,iCycle) = NaN(101,1);
                        else
                            tempData = interp1(1:1:tempLength,tempStore.(leg{iLeg}).(speeds{iSpeeds}).(sensoryNames{iSensory}).(pertCount{iPert})(~isnan(tempPrep), iCycle), tempLength:101, 'linear', 'extrap');
                            tempData2 =  tempStore.(leg{iLeg}).(speeds{iSpeeds}).(sensoryNames{iSensory}).(pertCount{iPert})(~isnan(tempPrep), iCycle);
                            tempData2(tempLength:101) = tempData';
                            prepData.(leg{iLeg}).(speeds{iSpeeds}).(sensoryNames{iSensory}).(pertCount{iPert})(:, iCycle) = tempData2;
                        end
                    else
                        prepData.(leg{iLeg}).(speeds{iSpeeds}).(sensoryNames{iSensory}).(pertCount{iPert})(:,iCycle) = interp1(tempStore.(leg{iLeg}).(speeds{iSpeeds}).(sensoryNames{iSensory}).(pertCount{iPert})(~isnan(tempPrep), iCycle), 1:1:101);
                        prepData.(leg{iLeg}).(speeds{iSpeeds}).perceived = tempStore.(leg{iLeg}).(speeds{iSpeeds}).perceived;
                        clear tempPrep tempLength
                    end
                end
            end
        end
    end
end

disp(['Finished resizing data ' subject1])
%% Calculating the Cohen's d effect size for each sensory feedback modality

for iLeg = 1:size(leg,1) % Each leg
    for iSpeeds = 2:size(speeds,1)
        temp9 = length(tempStore.(leg{iLeg}).(speeds{iSpeeds}).perceived);
        for iPert = 1:temp9
            for iCycle = 1:length(nameFrames)
                for iSensory = 1:length(sensoryNames)
                    for iGait = 1:101
                        d.(leg{iLeg}).(speeds{iSpeeds}).(sensoryNames{iSensory}).onset2pre(iGait,iPert) = computeCohen_d(prepData.(leg{iLeg}).(speeds{iSpeeds}).(sensoryNames{iSensory}).(pertCount{iPert})(iGait,6),prepData.(leg{iLeg}).(speeds{iSpeeds}).(sensoryNames{iSensory}).(pertCount{iPert})(iGait,1:5));
                        d.(leg{iLeg}).(speeds{iSpeeds}).(sensoryNames{iSensory}).post2pre(iGait,iPert) = computeCohen_d(prepData.(leg{iLeg}).(speeds{iSpeeds}).(sensoryNames{iSensory}).(pertCount{iPert})(iGait,7),prepData.(leg{iLeg}).(speeds{iSpeeds}).(sensoryNames{iSensory}).(pertCount{iPert})(iGait,1:5));
                        d.(leg{iLeg}).(speeds{iSpeeds}).(sensoryNames{iSensory}).onset2post(iGait,iPert) = computeCohen_d(prepData.(leg{iLeg}).(speeds{iSpeeds}).(sensoryNames{iSensory}).(pertCount{iPert})(iGait,6),prepData.(leg{iLeg}).(speeds{iSpeeds}).(sensoryNames{iSensory}).(pertCount{iPert})(iGait,7:11));
                    end
                end
            end
        end
    end
end

disp(['Cohens d calculated ' subject1])
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
save([tabLoc 'effectSize_' subject1], 'prepData', 'd', '-v7.3');


disp(['Structures saved for ' subject1]);

end

