% %% Create subject name to load the necessary files for the subject 
% 
% subject1 = ['YAPercep' strSubject];
% 
% %% Loading the remaining tables for the subject 
% % This section will load tables for the subject
% 
% load(['G:\Shared drives\NeuroMobLab\Projects\Perception\Processed Data\Dan\OpenSim\YAPercep Outputs\' subject1 '\Data Tables\IKTable_' subject1 '.mat'])
% load(['G:\Shared drives\NeuroMobLab\Projects\Perception\Processed Data\Dan\Matlab Analysis\' subject1 '\Data Tables\SepTables_' subject1 '.mat'])
% load(['G:\Shared drives\NeuroMobLab\Projects\Perception\Processed Data\Dan\Matlab Analysis\' subject1 '\Data Tables\pertTable_' subject1 '.mat'])
% load(['G:\Shared drives\NeuroMobLab\Projects\Perception\Processed Data\Dan\Matlab Analysis\' subject1 '\Data Tables\pertCycleStruc_' subject1 '.mat'])
% load(['G:\Shared drives\NeuroMobLab\Projects\Perception\Processed Data\Dan\OpenSim\YAPercep Outputs\' subject1 '\Data Tables\jointAnglesTable_' subject1 '.mat'])
% load(['G:\Shared drives\NeuroMobLab\Projects\Perception\Processed Data\Dan\OpenSim\YAPercep Outputs\' subject1 '\Data Tables\SpatiotemporalTable_' subject1 '.mat'])
% load(['G:\Shared drives\NeuroMobLab\Projects\Perception\Processed Data\Dan\OpenSim\YAPercep Outputs\' subject1 '\Data Tables\headCalcStruc_' subject1 '.mat'])


%% This section creates plots from -5 cycles before perturbation, Onset, +5 cycles after perturbation
nameFrames = {'Pre5Frames'; 'Pre4Frames'; 'Pre3Frames'; 'Pre2Frames'; 'Pre1Frames'; 'OnsetFrames';};% 'Post1Frames'; 'Post2Frames'; 'Post3Frames'; 'Post4Frames'; 'Post5Frames';}; % -5 cycles before perturbation, Onset, and +5 cycles after perturbation
namePercep = {'Percep01'; 'Percep02'; 'Percep03'; 'Percep04'; 'Percep05'; 'Percep06';}; % name of the potential perception trials for each subject 
speeds = 'sp4'; % Speeds in order as above 0, -0.02, -0.5, -0.1, -0.15, -0.2, -0.3, -0.4
pertSpeed = {'0'; '-0.02'; '-0.05'; '-0.10'; '-0.15'; '-0.2'; '-0.3'; '-0.4';}; % Perturbation speeds for the table
namePert = {'Catch'; 'Neg02'; 'Neg05'; 'Neg10'; 'Neg15'; 'Neg20'; 'Neg30'; 'Neg40';}; %Name of the perts to save the files
leg = 'R'; % Leg

pertCount = {'one'; 'two'; 'three'; 'four'; 'five';};

pTrials = contains(pertTable.Trial, 'Percep'); % Finding which rows in the table contain the Perception Trials

pTrials = pTrials(pTrials == 1); %Selecting only the indicies that have Perception trials

pertCount2 = 1;
for iTrial = 1:size(pTrials,1) % The perturbation trials, ie Percep01-PercepXX
    temp4 = size(pertCycleStruc.(leg).(speeds).(namePercep{iTrial}).Perceived,1); % Getting the amount of perturbations sent at a specific speed per Perception trial
    for iPerts = 1:temp4 % -5 cycles before Pert to Onset
        for iCycle = 1:size(nameFrames,1)
            temp1 = pertCycleStruc.(leg).(speeds).(namePercep{iTrial}).(nameFrames{iCycle}){1,iPerts}(1); % first heel strike of gait cycle 
            temp2 = pertCycleStruc.(leg).(speeds).(namePercep{iTrial}).(nameFrames{iCycle}){1,iPerts}(5); % ending heel strike of gait cycle
            temp4 = pertCycleStruc.(leg).(speeds).(namePercep{iTrial}).(nameFrames{iCycle}){1,iPerts}(4); % Toe off for the leg of the first heel strike of the gait cycle 
            temp3 = temp2 - temp1; % Getting length of gait cycle as elasped frames

            temp5 = temp1 * 10; 
            temp6 = temp4 * 10;
            temp7 = temp6-temp5;

            if isnan(temp1) || isnan(temp2) || isnan(temp3)

            else  
                perceived = pertCycleStruc.(leg).(speeds).(namePercep{iTrial}).Perceived(iPerts);
                tRHM_AP = videoTable.("Marker Data"){iTrial,1}(temp1:temp4,30,1); % Right Heel Marker for AP 
                tRHM_ML = videoTable.("Marker Data"){iTrial,1}(temp1:temp4,30,2); % Right Heel Marker for ML 
                ext_RHM_AP = interp(tRHM_AP, 10);
                ext_RHM_ML = interp(tRHM_ML, 10);
                RHM_AP = ext_RHM_AP(1:length(analogTable.COP{iTrial,1}(temp5:temp6,4)));
                RHM_ML = ext_RHM_ML(1:length(analogTable.COP{iTrial,1}(temp5:temp6,5)));
                if iCycle == 1
                
                    tempStore.ankle.(pertCount{pertCount2}) = nan(2*temp3,6);
                    tempStore.knee.(pertCount{pertCount2}) = nan(2*temp3,6);
                    tempStore.hip.(pertCount{pertCount2}) = nan(2*temp3,6);
                    tempStore.headA.(pertCount{pertCount2}) = nan(2*temp3,6);
                    tempStore.headV.(pertCount{pertCount2}) = nan(2*temp3,6);

                    tempStore.COPx.(pertCount{pertCount2}) = nan(2*temp7,6);
                    tempStore.COPy.(pertCount{pertCount2}) = nan(2*temp7,6);
                end
                if perceived == 1
                    namePerceived = 'Perceived';
                else
                    namePerceived = 'Not Perceived';
                end
                for i = 1:temp3
                    tempStore.ankle.(pertCount{pertCount2})(i,iCycle) = jointAnglesTable.("R Ankle Angle (Degrees)"){iTrial,1}(temp1+i -1);
                    tempStore.knee.(pertCount{pertCount2})(i,iCycle) = jointAnglesTable.("R Knee Angle (D)"){iTrial,1}(temp1+i -1);
                    tempStore.hip.(pertCount{pertCount2})(i,iCycle) = jointAnglesTable.("R Hip Flexion Angle (D)"){iTrial,1}(temp1+i -1);
                    tempStore.headA.(pertCount{pertCount2})(i,iCycle) = headCalcStruc.(namePercep{iTrial}).headAngle(temp1+i -1);
                    tempStore.headV.(pertCount{pertCount2})(i,iCycle) = headCalcStruc.(namePercep{iTrial}).headAngularVelocity(temp1+i -1);
                end
                
                for j = 1:temp7
                    tempStore.COPx.(pertCount{pertCount2})(j,iCycle) = analogTable.COP{iTrial,1}(temp5+j-1,4)- RHM_AP(j);
                    tempStore.COPy.(pertCount{pertCount2})(j,iCycle) = analogTable.COP{iTrial,1}(temp5+j-1,5)- RHM_ML(j);
                end
                tempStore.perceived(pertCount2) = perceived;
            end
            
                clear temp1 temp2 temp 3 perceived namePerceived
        end
        pertCount2 = pertCount2 + 1;
    end
end


%% Resizing all the data so that it goes from 0-100% of the gait cycle 
sensoryNames = {'ankle'; 'knee'; 'hip'; 'headA'; 'headV'; 'COPx'; 'COPy';};

for iPert = 1:length(pertCount)
    for iCycle = 1:length(nameFrames)
        for iSensory = 1:length(sensoryNames)
            tempPrep = tempStore.(sensoryNames{iSensory}).(pertCount{iPert})(:,iCycle);
            prepData.(sensoryNames{iSensory}).(pertCount{iPert})(:,iCycle) = interp1(tempStore.(sensoryNames{iSensory}).(pertCount{iPert})(~isnan(tempPrep), iCycle), 1:1:101);
            prepData.perceived = tempStore.perceived;
            clear tempPrep
        end
    end
end

for iPert = 1:length(pertCount)
    for iCycle = 1:length(nameFrames)
        for iSensory = 1:length(sensoryNames)
            for iGait = 1:101
                d.(sensoryNames{iSensory})(iGait,iPert) = computeCohen_d(prepData.(sensoryNames{iSensory}).(pertCount{iPert})(iGait,1:5), prepData.(sensoryNames{iSensory}).(pertCount{iPert})(iGait,6));
            end
        end
    end
end

