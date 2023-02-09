function [prepData, d] = Effect_SizeDynamicStability(strSubject, speedLow, speedHigh)
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
% namePercep = {'Percep01'; 'Percep02'; 'Percep03'; 'Percep04'; 'Percep05'; 'Percep06';}; % name of the potential perception trials for each subject 
speeds = {'sp1'; 'sp2'; 'sp3'; 'sp4'; 'sp5'; 'sp6'; 'sp7'; 'sp8';}; % Speeds in order as above 0, -0.02, -0.5, -0.1, -0.15, -0.2, -0.3, -0.4
pertSpeed = {'0'; '-0.02'; '-0.05'; '-0.10'; '-0.15'; '-0.2'; '-0.3'; '-0.4';}; % Perturbation speeds for the table
npertSpeed = [0; -0.02; -0.05; -0.10; -0.15; -0.2; -0.3; -0.4;]; % Perturbation speeds for the table

namePert = {'Catch'; 'Neg02'; 'Neg05'; 'Neg10'; 'Neg15'; 'Neg20'; 'Neg30'; 'Neg40';}; %Name of the perts to save the files
leg = {'R';}; % Leg

pTrials = contains(pertTable.Trial, 'Percep'); % Finding which rows in the table contain the Perception Trials

pTrials = pTrials(pTrials == 1); %Selecting only the indicies that have Perception trials

namePercep = pertTable.Trial; % name of the perception trials for the subject

if strcmp('14', strSubject) == 1
    pertCount = {'one'; 'two'; 'three'; 'four'; 'five';'six'};
else
    pertCount = {'one'; 'two'; 'three'; 'four'; 'five';};
end
% Preallocating spaces for the calculations 
 
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

pertCount2 = 1;
for iTrial = 1:size(trialsL,2) % The perturbation trials for the lower speed, i.e. Percep01-PercepXX
    tempTrials = trialsL(iTrial);
    perts = rPerts{tempTrials}(SpL{tempTrials});
    for iPerts = 1:size(perts,1) % The amount of R leg perturbations sent during the perception trial
        tempA = contains(pertSpeed, num2str(speedLow));
        nameP = namePert{tempA};
        perceived = perL{tempTrials}{iPerts};
        if perceived == 1
            namePerceived = 'Perceived';
        else
            namePerceived = 'Not Perceived';
        end
        % Getting the GCs for each perturbation 
        if perts(iPerts) <= 5
            cycles = perts(iPerts)-4:1:perts(iPerts)+5;
        else
            cycles = perts(iPerts)-5:1:perts(iPerts)+5;
        end
        for iCycle = 1:size(cycles,2) % Looping through the -5 cycles, onset, and +5 cycles after perturbation
            gcStart = RpertGC.RHS{tempTrials}(cycles(iCycle));
            gcMid = RpertGC.RTO{tempTrials}(cycles(iCycle));
            gcFin = RpertGC.RHS_2{tempTrials}(cycles(iCycle));
            gcLen = RpertGC.RHS_2{tempTrials}(cycles(iCycle)) - RpertGC.RHS{tempTrials}(cycles(iCycle));
            gcHalf = gcMid - gcStart;
            if iCycle == 1 
                tempStore.(nameP).WBAMx.(pertCount{pertCount2}) = nan(2*gcLen,size(nameFrames,1));
                tempStore.(nameP).WBAMy.(pertCount{pertCount2}) = nan(2*gcLen,size(nameFrames,1)); 
                tempStore.(nameP).WBAMz.(pertCount{pertCount2}) = nan(2*gcLen,size(nameFrames,1)); 
                tempStore.(nameP).CoMPosx.(pertCount{pertCount2}) = nan(2*gcLen,size(nameFrames,1));
                tempStore.(nameP).CoMPosy.(pertCount{pertCount2}) = nan(2*gcLen,size(nameFrames,1));
                tempStore.(nameP).CoMPosz.(pertCount{pertCount2}) = nan(2*gcLen,size(nameFrames,1));
                tempStore.(nameP).CoMVelx.(pertCount{pertCount2}) = nan(2*gcLen, size(nameFrames,1));
                tempStore.(nameP).CoMVely.(pertCount{pertCount2}) = nan(2*gcLen, size(nameFrames,1));
                tempStore.(nameP).CoMVelz.(pertCount{pertCount2}) = nan(2*gcLen, size(nameFrames,1));
                tempStore.(nameP).CoMAccx.(pertCount{pertCount2}) = nan(2*gcLen, size(nameFrames,1));
                tempStore.(nameP).CoMAccy.(pertCount{pertCount2}) = nan(2*gcLen, size(nameFrames,1));
                tempStore.(nameP).CoMAccz.(pertCount{pertCount2}) = nan(2*gcLen, size(nameFrames,1));
%                 tempStore.(nameP).MoSAP.(pertCount{pertCount2}) = nan(2*gcHalf,size(nameFrames,1)); 
%                 tempStore.(nameP).MoSML.(pertCount{pertCount2}) = nan(2*gcHalf,size(nameFrames,1)); 

            end

            for i = 1:gcLen
                tempStore.(nameP).WBAMx.(pertCount{pertCount2})(i,iCycle) = dynamicStabilityTable.WBAM{tempTrials}(gcStart+i -1,1);
                tempStore.(nameP).WBAMy.(pertCount{pertCount2})(i,iCycle) = dynamicStabilityTable.WBAM{tempTrials}(gcStart+i -1,2); 
                tempStore.(nameP).WBAMz.(pertCount{pertCount2})(i,iCycle) = dynamicStabilityTable.WBAM{tempTrials}(gcStart+i -1,3); 
                
                tempStore.(nameP).CoMPosx.(pertCount{pertCount2})(i,iCycle) = dynamicStabilityTable.Sum_CoM_Pos{tempTrials}(gcStart+i -1,1)-dynamicStabilityTable.Sum_CoM_Pos{tempTrials}(gcStart,1);
                tempStore.(nameP).CoMPosy.(pertCount{pertCount2})(i,iCycle) = dynamicStabilityTable.Sum_CoM_Pos{tempTrials}(gcStart+i -1,2)-dynamicStabilityTable.Sum_CoM_Pos{tempTrials}(gcStart,2);
                tempStore.(nameP).CoMPosz.(pertCount{pertCount2})(i,iCycle) = dynamicStabilityTable.Sum_CoM_Pos{tempTrials}(gcStart+i -1,3)-dynamicStabilityTable.Sum_CoM_Pos{tempTrials}(gcStart,3);
                tempStore.(nameP).CoMVelx.(pertCount{pertCount2})(i,iCycle) = dynamicStabilityTable.Sum_CoM_Vel{tempTrials}(gcStart+i -1,1);
                tempStore.(nameP).CoMVely.(pertCount{pertCount2})(i,iCycle) = dynamicStabilityTable.Sum_CoM_Vel{tempTrials}(gcStart+i -1,2);
                tempStore.(nameP).CoMVelz.(pertCount{pertCount2})(i,iCycle) = dynamicStabilityTable.Sum_CoM_Vel{tempTrials}(gcStart+i -1,3);
                tempStore.(nameP).CoMAccx.(pertCount{pertCount2})(i,iCycle) = dynamicStabilityTable.Sum_CoM_Acc{tempTrials}(gcStart+i -1,1);
                tempStore.(nameP).CoMAccy.(pertCount{pertCount2})(i,iCycle) = dynamicStabilityTable.Sum_CoM_Acc{tempTrials}(gcStart+i -1,2);
                tempStore.(nameP).CoMAccz.(pertCount{pertCount2})(i,iCycle) = dynamicStabilityTable.Sum_CoM_Acc{tempTrials}(gcStart+i -1,3);
                

            end
            
%             for j = 1:gcHalf 
%                 tempStore.(nameP).MoSAP.(pertCount{pertCount2})(j,iCycle) = dynamicStabilityTable.APMoS_R{tempTrials}(gcStart+j -1); 
%                 tempStore.(nameP).MoSML.(pertCount{pertCount2})(j,iCycle) = dynamicStabilityTable.MLMoS_R{tempTrials}(gcStart+j -1); 
%             end
            tempStore.(nameP).perceived(pertCount2) = perceived;
        end
        pertCount2 = pertCount2 + 1;
    end
end



pertCount2 = 1;
for iTrial = 1:size(trialsH,2) % The perturbation trials for the lower speed, i.e. Percep01-PercepXX
    tempTrials = trialsH(iTrial);
    perts = rPerts{tempTrials}(SpH{tempTrials});
    for iPerts = 1:size(perts,1) % The amount of R leg perturbations sent during the perception trial
        tempA = contains(pertSpeed, num2str(speedHigh));
        nameP = namePert{tempA};
        perceived = perH{tempTrials}{iPerts};
        if perceived == 1
            namePerceived = 'Perceived';
        else
            namePerceived = 'Not Perceived';
        end
        % Getting the GCs for each perturbation 
        cycles = perts(iPerts)-5:1:perts(iPerts)+5;
        for iCycle = 1:size(cycles,2) % Looping through the -5 cycles, onset, and +5 cycles after perturbation
            gcStart = RpertGC.RHS{tempTrials}(cycles(iCycle));
            gcMid = RpertGC.RTO{tempTrials}(cycles(iCycle));
            gcFin = RpertGC.RHS_2{tempTrials}(cycles(iCycle));
            gcLen = RpertGC.RHS_2{tempTrials}(cycles(iCycle)) - RpertGC.RHS{tempTrials}(cycles(iCycle));
            gcHalf = gcMid - gcStart;
            if iCycle == 1 
                tempStore.(nameP).WBAMx.(pertCount{pertCount2}) = nan(2*gcLen,size(nameFrames,1));
                tempStore.(nameP).WBAMy.(pertCount{pertCount2}) = nan(2*gcLen,size(nameFrames,1)); 
                tempStore.(nameP).WBAMz.(pertCount{pertCount2}) = nan(2*gcLen,size(nameFrames,1)); 
                tempStore.(nameP).CoMPosx.(pertCount{pertCount2}) = nan(2*gcLen,size(nameFrames,1));
                tempStore.(nameP).CoMPosy.(pertCount{pertCount2}) = nan(2*gcLen,size(nameFrames,1));
                tempStore.(nameP).CoMPosz.(pertCount{pertCount2}) = nan(2*gcLen,size(nameFrames,1));
                tempStore.(nameP).CoMVelx.(pertCount{pertCount2}) = nan(2*gcLen, size(nameFrames,1));
                tempStore.(nameP).CoMVely.(pertCount{pertCount2}) = nan(2*gcLen, size(nameFrames,1));
                tempStore.(nameP).CoMVelz.(pertCount{pertCount2}) = nan(2*gcLen, size(nameFrames,1));
                tempStore.(nameP).CoMAccx.(pertCount{pertCount2}) = nan(2*gcLen, size(nameFrames,1));
                tempStore.(nameP).CoMAccy.(pertCount{pertCount2}) = nan(2*gcLen, size(nameFrames,1));
                tempStore.(nameP).CoMAccz.(pertCount{pertCount2}) = nan(2*gcLen, size(nameFrames,1));
%                 tempStore.(nameP).MoSAP.(pertCount{pertCount2}) = nan(2*gcHalf,size(nameFrames,1)); 
%                 tempStore.(nameP).MoSML.(pertCount{pertCount2}) = nan(2*gcHalf,size(nameFrames,1)); 

            end

            for i = 1:gcLen
                tempStore.(nameP).WBAMx.(pertCount{pertCount2})(i,iCycle) = dynamicStabilityTable.WBAM{tempTrials}(gcStart+i -1,1);
                tempStore.(nameP).WBAMy.(pertCount{pertCount2})(i,iCycle) = dynamicStabilityTable.WBAM{tempTrials}(gcStart+i -1,2); 
                tempStore.(nameP).WBAMz.(pertCount{pertCount2})(i,iCycle) = dynamicStabilityTable.WBAM{tempTrials}(gcStart+i -1,3); 
                
                tempStore.(nameP).CoMPosx.(pertCount{pertCount2})(i,iCycle) = dynamicStabilityTable.Sum_CoM_Pos{tempTrials}(gcStart+i -1,1) - dynamicStabilityTable.Sum_CoM_Pos{tempTrials}(gcStart,1);
                tempStore.(nameP).CoMPosy.(pertCount{pertCount2})(i,iCycle) = dynamicStabilityTable.Sum_CoM_Pos{tempTrials}(gcStart+i -1,2) - dynamicStabilityTable.Sum_CoM_Pos{tempTrials}(gcStart,2);
                tempStore.(nameP).CoMPosz.(pertCount{pertCount2})(i,iCycle) = dynamicStabilityTable.Sum_CoM_Pos{tempTrials}(gcStart+i -1,3) - dynamicStabilityTable.Sum_CoM_Pos{tempTrials}(gcStart,3);
                tempStore.(nameP).CoMVelx.(pertCount{pertCount2})(i,iCycle) = dynamicStabilityTable.Sum_CoM_Vel{tempTrials}(gcStart+i -1,1);
                tempStore.(nameP).CoMVely.(pertCount{pertCount2})(i,iCycle) = dynamicStabilityTable.Sum_CoM_Vel{tempTrials}(gcStart+i -1,2);
                tempStore.(nameP).CoMVelz.(pertCount{pertCount2})(i,iCycle) = dynamicStabilityTable.Sum_CoM_Vel{tempTrials}(gcStart+i -1,3);
                tempStore.(nameP).CoMAccx.(pertCount{pertCount2})(i,iCycle) = dynamicStabilityTable.Sum_CoM_Acc{tempTrials}(gcStart+i -1,1);
                tempStore.(nameP).CoMAccy.(pertCount{pertCount2})(i,iCycle) = dynamicStabilityTable.Sum_CoM_Acc{tempTrials}(gcStart+i -1,2);
                tempStore.(nameP).CoMAccz.(pertCount{pertCount2})(i,iCycle) = dynamicStabilityTable.Sum_CoM_Acc{tempTrials}(gcStart+i -1,3);

            end
            
%             for j = 1:gcHalf 
%                 tempStore.(nameP).MoSAP.(pertCount{pertCount2})(j,iCycle) = dynamicStabilityTable.APMoS_R{tempTrials}(gcStart+j -1); 
%                 tempStore.(nameP).MoSML.(pertCount{pertCount2})(j,iCycle) = dynamicStabilityTable.MLMoS_R{tempTrials}(gcStart+j -1); 
%             end
            tempStore.(nameP).perceived(pertCount2) = perceived;
        end
        pertCount2 = pertCount2 + 1;
    end
end
disp(['Finished pulling data for ' subject1])
%% Resizing all the data so that it goes from 0-100% of the gait cycle 
dynamicNames = fieldnames(tempStore.(nameP));
speedNames = fieldnames(tempStore);

for iSpeeds = 1:size(speedNames,1)
    perts = length(tempStore.(speedNames{iSpeeds}).perceived);
    for idynamic = 1:length(dynamicNames)-1
        for iCycle = 1:length(nameFrames)
            for iPert = 1:perts
                if iSpeeds == 1 && perts == 1 && strSubject == '04'
                    nameFrames = {'Pre4Frames'; 'Pre3Frames'; 'Pre2Frames'; 'Pre1Frames'; 'OnsetFrames'; 'Post1Frames'; 'Post2Frames'; 'Post3Frames'; 'Post4Frames'; 'Post5Frames';}; % -5 cycles before perturbation, Onset, and +5 cycles after perturbation
                else
                    nameFrames = {'Pre5Frames'; 'Pre4Frames'; 'Pre3Frames'; 'Pre2Frames'; 'Pre1Frames'; 'OnsetFrames'; 'Post1Frames'; 'Post2Frames'; 'Post3Frames'; 'Post4Frames'; 'Post5Frames';}; % -5 cycles before perturbation, Onset, and +5 cycles after perturbation
                end
                tempPrep = tempStore.(speedNames{iSpeeds}).(dynamicNames{idynamic}).(pertCount{iPert})(:,iCycle);
                if idynamic > 15 
                    if length(tempStore.(speedNames{iSpeeds}).(dynamicNames{idynamic}).(pertCount{iPert})(~isnan(tempPrep), iCycle)) < 61 
                        tempLength = length(tempStore.(speedNames{iSpeeds}).(dynamicNames{idynamic}).(pertCount{iPert})(~isnan(tempPrep), iCycle));
                        if tempLength == 0
                            prepData.(speedNames{iSpeeds}).(dynamicNames{idynamic}).(pertCount{iPert})(:,iCycle) = NaN(101,1);
                        else
                            tempData = interp1(1:1:tempLength,tempStore.(speedNames{iSpeeds}).(dynamicNames{idynamic}).(pertCount{iPert})(~isnan(tempPrep), iCycle), tempLength:61, 'linear', 'extrap');
                            tempData2 =  tempStore.(speedNames{iSpeeds}).(dynamicNames{idynamic}).(pertCount{iPert})(~isnan(tempPrep), iCycle);
                            tempData2(tempLength:61) = tempData';
                            prepData.(speedNames{iSpeeds}).(dynamicNames{idynamic}).(pertCount{iPert})(:, iCycle) = tempData2;
                        end
                    else
                        prepData.(speedNames{iSpeeds}).(dynamicNames{idynamic}).(pertCount{iPert})(:,iCycle) = interp1(tempStore.(speedNames{iSpeeds}).(dynamicNames{idynamic}).(pertCount{iPert})(~isnan(tempPrep), iCycle), 1:1:61);
                        prepData.(speedNames{iSpeeds}).perceived = tempStore.(speedNames{iSpeeds}).perceived;
                        clear tempPrep tempLength
                
                    end
                else
                
                    if length(tempStore.(speedNames{iSpeeds}).(dynamicNames{idynamic}).(pertCount{iPert})(~isnan(tempPrep), iCycle)) < 101 
                        tempLength = length(tempStore.(speedNames{iSpeeds}).(dynamicNames{idynamic}).(pertCount{iPert})(~isnan(tempPrep), iCycle));
                        if tempLength == 0
                            prepData.(speedNames{iSpeeds}).(dynamicNames{idynamic}).(pertCount{iPert})(:,iCycle) = NaN(101,1);
                        else
                            tempData = interp1(1:1:tempLength,tempStore.(speedNames{iSpeeds}).(dynamicNames{idynamic}).(pertCount{iPert})(~isnan(tempPrep), iCycle), tempLength:101, 'linear', 'extrap');
                            tempData2 =  tempStore.(speedNames{iSpeeds}).(dynamicNames{idynamic}).(pertCount{iPert})(~isnan(tempPrep), iCycle);
                            tempData2(tempLength:101) = tempData';
                            prepData.(speedNames{iSpeeds}).(dynamicNames{idynamic}).(pertCount{iPert})(:, iCycle) = tempData2;
                        end
                    else
                        prepData.(speedNames{iSpeeds}).(dynamicNames{idynamic}).(pertCount{iPert})(:,iCycle) = interp1(tempStore.(speedNames{iSpeeds}).(dynamicNames{idynamic}).(pertCount{iPert})(~isnan(tempPrep), iCycle), 1:1:101);
                        prepData.(speedNames{iSpeeds}).perceived = tempStore.(speedNames{iSpeeds}).perceived;
                        clear tempPrep tempLength
                    end
                end
            end
        end
    end
end

disp(['Finished resizing data ' subject1])
%% Calculating the Cohen's d effect size for each sensory feedback modality

for iSpeeds = 1:size(speedNames,1)
    perts = length(tempStore.(speedNames{iSpeeds}).perceived);
    if strSubject == '14' 
        perts = 5;
    end
    for idynamic = 1:length(dynamicNames)-1
        for iCycle = 1:length(nameFrames)
            for iPert = 1:perts
                if idynamic >15 
%                     for iGait = 1:61
%                         d.(speedNames{iSpeeds}).(dynamicNames{idynamic}).onset2pre(iGait,iPert) = computeCohen_d(prepData.(speedNames{iSpeeds}).(dynamicNames{idynamic}).(pertCount{iPert})(iGait,6),prepData.(speedNames{iSpeeds}).(dynamicNames{idynamic}).(pertCount{iPert})(iGait,1:5));
%                     end
                else
                    for iGait = 1:101
                        if iSpeeds == 1 && perts == 1 && strSubject == '04'
                            d.(speedNames{iSpeeds}).(dynamicNames{idynamic}).onset2pre(iGait,iPert) = computeCohen_d(prepData.(speedNames{iSpeeds}).(dynamicNames{idynamic}).(pertCount{iPert})(iGait,5),prepData.(speedNames{iSpeeds}).(dynamicNames{idynamic}).(pertCount{iPert})(iGait,1:4));
                        else
                            d.(speedNames{iSpeeds}).(dynamicNames{idynamic}).onset2pre(iGait,iPert) = computeCohen_d(prepData.(speedNames{iSpeeds}).(dynamicNames{idynamic}).(pertCount{iPert})(iGait,6),prepData.(speedNames{iSpeeds}).(dynamicNames{idynamic}).(pertCount{iPert})(iGait,1:5));
                        end
                    end
                end
            end
        end
    end
    d.(speedNames{iSpeeds}).perceived(1:5) = tempStore.(speedNames{iSpeeds}).perceived(1:5);
end


disp(['Cohens d calculated ' subject1])
%% 
% Setting the location to the subjects' data folder 
if ispc
    tabLoc = ['D:\Github\Perception-Project\Dan\Data Processing and Analysis\WholeVsLocal\Data\'];
elseif ismac %%%% Need to add the part for a mac 
    tabLoc = [''];
else
    tabLoc = input('Please enter the location where the tables should be saved.' ,'s');
end



% Saving the head calculations structure for each
% subject 
save([tabLoc 'effectSizeWhole_' subject1], 'prepData', 'd', '-v7.3');


disp(['Structures saved for ' subject1]);

end

