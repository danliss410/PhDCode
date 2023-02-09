% Temp Results script to create struct with all subject info in it and 
% perform an area under the curve analysis 

% Need to either use trapz or cumtrapz to do AUC

%% Load all the subjects' data and put them into a subject structure 
subName = {'05'; '07'; '10'; '11'; '12'; '13'; '14'; '15';};

for iSubjects = 1:8 
    subject1 = ['YAPercep' subName{iSubjects}];
    load(['G:\Shared drives\NeuroMobLab\Projects\Perception\Processed Data\Dan\Matlab Analysis\' subject1 '\Data Tables\SepTables_' subject1 '.mat'])
    load(['G:\Shared drives\NeuroMobLab\Projects\Perception\Processed Data\Dan\Matlab Analysis\' subject1 '\Data Tables\pertTable_' subject1 '.mat'])
    load(['G:\Shared drives\NeuroMobLab\Projects\Perception\Processed Data\Dan\Matlab Analysis\' subject1 '\Data Tables\pEmgStruct_' subject1 '.mat'])
    load(['G:\Shared drives\NeuroMobLab\Projects\Perception\Processed Data\Dan\Matlab Analysis\' subject1 '\Data Tables\pertCycleStruc_' subject1 '.mat'])
    subjects.(subject1).analogTable = analogTable;
    subjects.(subject1).gaitEventsTable = gaitEventsTable; 
    subjects.(subject1).npEmgStruct = npEmgStruct;
    subjects.(subject1).pEmgStruct = pEmgStruct;
    subjects.(subject1).videoTable = videoTable;
    subjects.(subject1).pertCycleStruc = pertCycleStruc;
    subjects.(subject1).pertTable = pertTable;
    clearvars -except subjects subName iSubjects
end

save('Emg_subs.mat', 'subjects', '-v7.3')



%% Won't need to run the top part unless I get the other two subjects done 
% This will load the subjects structure to do data manipulation on 
load('G:\Shared drives\NeuroMobLab\Projects\Perception\Processed Data\Dan\Results\Emg Sub Structure\Emg_subs.mat')

%% Calculating the area under the curve for each perturbation in each subject
emgid = {'EMG_TA-R';'EMG_LGAS-R';'EMG_VLAT-R';'EMG_RFEM-R';'EMG_BFLH-R';'EMG_ADD-R';'EMG_TFL-R';'EMG_GMED-R';'EMG_TA-L';'EMG_LGAS-L';'EMG_VLAT-L';'EMG_RFEM-L';'EMG_BFLH-L';'EMG_ADD-L';'EMG_TFL-L';'EMG_GMED-L';'EMG_SOL-R';'EMG_PERO-R';'EMG_MGAS-R';'EMG_GMAX-R';'EMG_SOL-L';'EMG_PERO-L';'EMG_MGAS-L';'EMG_GMAX-L';'25';'26';'27';'28';'29';'30';'31';'32'};
nameFrames = {'Pre5Frames'; 'Pre4Frames'; 'Pre3Frames'; 'Pre2Frames'; 'Pre1Frames'; 'OnsetFrames'; 'Post1Frames'; 'Post2Frames'; 'Post3Frames'; 'Post4Frames'; 'Post5Frames';}; % -5 cycles before perturbation, Onset, and +5 cycles after perturbation
namePercep = {'Percep01'; 'Percep02'; 'Percep03'; 'Percep04'; 'Percep05'; 'Percep06';}; % name of the potential perception trials for each subject 
speeds = {'sp1'; 'sp2'; 'sp3'; 'sp4'; 'sp5'; 'sp6'; 'sp7'; 'sp8';}; % Speeds in order as above 0, -0.02, -0.5, -0.1, -0.15, -0.2, -0.3, -0.4
namePert = {'Catch'; 'Neg02'; 'Neg05'; 'Neg10'; 'Neg15'; 'Neg20'; 'Neg30'; 'Neg40';}; %Name of the perts to save the files
% Finding the indices of the left and right emgs from emgid to be used to
% plot the muscles in the loop below
B = contains(emgid, '-R'); % Have to do this line because we have extra emg slots 25-32
emgR = emgid(B); %Gets the names of EMGs 
emgRidx = find(B); % Gets the indicies of EMGs

speeds2 = {{'sp3'; 'sp4'}, {'sp2'; 'sp3'}, {'sp4'; 'sp5'}, {'sp3'; 'sp4'}, {'sp3'; 'sp4'}, {'sp4'; 'sp5'}, {'sp4'; 'sp5'}, {'sp2'; 'sp3'}};

% Resizing matrixes to be from 0-100% of the GC not some random amount
for iSubjects = 1:8 % 8 subjects 
    subject1 = ['YAPercep' subName{iSubjects}];
    for iSpeeds = 1:2 % The two speed levels for each subject from speeds2 that correspond with NamePert
        pertCount = 1; % Counting so that all the perturbaitons are put into 1 matrix
        pTrials = length(fieldnames(tSub2.(subject1).(speeds2{iSubjects}{iSpeeds}))); % Number of perception trials that have perturbations in it
        for iTrial = 1:pTrials % How many perception trials have the perturbation in it
            tempName = fieldnames(tSub2.(subject1).(speeds2{iSubjects}{iSpeeds})); % Getting the actual names of the perception trials 
            temp5 = size(tSub2.(subject1).(speeds2{iSubjects}{iSpeeds}).(tempName{iTrial}).Perceived,1); % Getting the amount of perturbations sent at a specific speed per Perception trial
            for iPerts = 1:temp5 % Looping for the number of perturbations in whatever perception trial
                for iCycles = 1:6 % Corresponds with the 5 steps pre perturbation and 1 perturbed step 
                    for iEmgR = 1:size(emgRidx,1)  % 12 muscles on the right leg               
                        temp1 = subjects.(subject1).pertCycleStruc.R.(speeds2{iSubjects}{iSpeeds}).(tempName{iTrial}).(nameFrames{iCycles}){1,iPerts}(1); % first heel strike of gait cycle 
                        temp2 = subjects.(subject1).pertCycleStruc.R.(speeds2{iSubjects}{iSpeeds}).(tempName{iTrial}).(nameFrames{iCycles}){1,iPerts}(5); % ending heel strike of gait cycle
                        temp4 = subjects.(subject1).pertCycleStruc.R.(speeds2{iSubjects}{iSpeeds}).(tempName{iTrial}).(nameFrames{iCycles}){1,iPerts}(4); % Toe off for the leg of the first heel strike of the gait cycle 
                        temp1 = temp1* 10; % Multiplying to get into the right frequency for EMG (video data is 100 hz)
                        temp2 = temp2* 10; % Multiplying to get into the right frequency for EMG (video data is 100 hz)
                        temp3 = temp2 - temp1; % Getting length of gait cycle as elasped frames
                        temp7 = temp4* 10; % Multiplying to get into the right frequency for EMG (video data is 100 hz)
                        temp6 = temp7-temp1; % Getting the length of stance as elasped frames 
                        % Changing the dash to an underscore for the
                        % structure 
                        nEmgR = strrep(emgR{iEmgR}, '-R', '');
                        % Creating blank nan matricies to preallocate sizes
                        % and space 
                        tempStore.(subject1).(speeds2{iSubjects}{iSpeeds}).(nEmgR){iCycles}(:, pertCount) = nan(61,1);
                        AUCStance.(subject1).(speeds2{iSubjects}{iSpeeds}).cumtrap.(nEmgR){iCycles}(:,pertCount) = nan(61,1); 
                        AUCStance.(subject1).(speeds2{iSubjects}{iSpeeds}).trap.(nEmgR){iCycles}(pertCount) = nan(1,1);
                        AUCStance.(subject1).(speeds2{iSubjects}{iSpeeds}).Perceived(pertCount) = nan(1,1);
                        
                        tempEMG = subjects.(subject1).npEmgStruct.(tempName{iTrial})(temp1:temp7, emgRidx(iEmgR));
                        x = 1:length(tempEMG);
                        newX = linspace(x(1), x(end),61);
%                         tempEMG2 = interp1(x,tempEMG,newX);
                        % Making the data into 60 points from stance 
                        tempStore.(subject1).(speeds2{iSubjects}{iSpeeds}).(nEmgR){iCycles}(:,pertCount) = interp1(x,tempEMG,newX);
                        % Calculating the cumulative trapzoid integral from
                        % the stance data for each subject and their 2
                        % speeds across all cycles 
                        AUCStance.(subject1).(speeds2{iSubjects}{iSpeeds}).cumtrap.(nEmgR){iCycles}(:,pertCount) = cumtrapz(newX, tempStore.(subject1).(speeds2{iSubjects}{iSpeeds}).(nEmgR){iCycles}(:,pertCount));  
                        % Calculating the ending result of the trapzoid
                        % integral for stance data 
                        AUCStance.(subject1).(speeds2{iSubjects}{iSpeeds}).trap.(nEmgR){iCycles}(pertCount) = trapz(newX, tempStore.(subject1).(speeds2{iSubjects}{iSpeeds}).(nEmgR){iCycles}(:,pertCount));
                        % Putting perceived information in the AUC
                        % structure to be found more easily 
                        AUCStance.(subject1).(speeds2{iSubjects}{iSpeeds}).Perceived(pertCount) = subjects.(subject1).pertCycleStruc.R.(speeds2{iSubjects}{iSpeeds}).(tempName{iTrial}).Perceived(iPerts);
                        
                    end
                end
                % Increasing the perturbation count until the next speed
                pertCount = pertCount +1; 
            end
        end
    end
end
%%
%% Calculating the area under the curve for each perturbation in each subject
emgid = {'EMG_TA-R';'EMG_LGAS-R';'EMG_VLAT-R';'EMG_RFEM-R';'EMG_BFLH-R';'EMG_ADD-R';'EMG_TFL-R';'EMG_GMED-R';'EMG_TA-L';'EMG_LGAS-L';'EMG_VLAT-L';'EMG_RFEM-L';'EMG_BFLH-L';'EMG_ADD-L';'EMG_TFL-L';'EMG_GMED-L';'EMG_SOL-R';'EMG_PERO-R';'EMG_MGAS-R';'EMG_GMAX-R';'EMG_SOL-L';'EMG_PERO-L';'EMG_MGAS-L';'EMG_GMAX-L';'25';'26';'27';'28';'29';'30';'31';'32'};
nameFrames = {'Pre5Frames'; 'Pre4Frames'; 'Pre3Frames'; 'Pre2Frames'; 'Pre1Frames'; 'OnsetFrames'; 'Post1Frames'; 'Post2Frames'; 'Post3Frames'; 'Post4Frames'; 'Post5Frames';}; % -5 cycles before perturbation, Onset, and +5 cycles after perturbation
namePercep = {'Percep01'; 'Percep02'; 'Percep03'; 'Percep04'; 'Percep05'; 'Percep06';}; % name of the potential perception trials for each subject 
speeds = {'sp1'; 'sp2'; 'sp3'; 'sp4'; 'sp5'; 'sp6'; 'sp7'; 'sp8';}; % Speeds in order as above 0, -0.02, -0.5, -0.1, -0.15, -0.2, -0.3, -0.4
namePert = {'Catch'; 'Neg02'; 'Neg05'; 'Neg10'; 'Neg15'; 'Neg20'; 'Neg30'; 'Neg40';}; %Name of the perts to save the files
% Finding the indices of the left and right emgs from emgid to be used to
% plot the muscles in the loop below
B = contains(emgid, '-R'); % Have to do this line because we have extra emg slots 25-32
emgR = emgid(B); %Gets the names of EMGs 
emgRidx = find(B); % Gets the indicies of EMGs

% speeds2 = {{'sp3'; 'sp4'}, {'sp2'; 'sp3'}, {'sp4'; 'sp5'}, {'sp3'; 'sp4'}, {'sp3'; 'sp4'}, {'sp4'; 'sp5'}, {'sp4'; 'sp5'}, {'sp2'; 'sp3'}};
speeds3 = {'sp8'};
% Resizing matrixes to be from 0-100% of the GC not some random amount
for iSubjects = 8 % 8 subjects 
    subject1 = ['YAPercep' subName{iSubjects}];
    for iSpeeds = 1 % The two speed levels for each subject from speeds2 that correspond with NamePert
        pertCount = 1; % Counting so that all the perturbaitons are put into 1 matrix
        pTrials = {'Percep02';'Percep03'}; % Number of perception trials that have perturbations in it
        for iTrial = 1:length(pTrials) % How many perception trials have the perturbation in it
            tempName = pTrials; % Getting the actual names of the perception trials 
            temp5 = size(subjects.(subject1).pertCycleStruc.R.(speeds3{iSpeeds}).(tempName{iTrial}).Perceived,1); % Getting the amount of perturbations sent at a specific speed per Perception trial
            for iPerts = 1:temp5 % Looping for the number of perturbations in whatever perception trial
                for iCycles = 1:6 % Corresponds with the 5 steps pre perturbation and 1 perturbed step 
                    for iEmgR = 1:size(emgRidx,1)  % 12 muscles on the right leg               
                        temp1 = subjects.(subject1).pertCycleStruc.R.(speeds3{iSpeeds}).(tempName{iTrial}).(nameFrames{iCycles}){1,iPerts}(1); % first heel strike of gait cycle 
                        temp2 = subjects.(subject1).pertCycleStruc.R.(speeds3{iSpeeds}).(tempName{iTrial}).(nameFrames{iCycles}){1,iPerts}(5); % ending heel strike of gait cycle
                        temp4 = subjects.(subject1).pertCycleStruc.R.(speeds3{iSpeeds}).(tempName{iTrial}).(nameFrames{iCycles}){1,iPerts}(4); % Toe off for the leg of the first heel strike of the gait cycle 
                        temp1 = temp1* 10; % Multiplying to get into the right frequency for EMG (video data is 100 hz)
                        temp2 = temp2* 10; % Multiplying to get into the right frequency for EMG (video data is 100 hz)
                        temp3 = temp2 - temp1; % Getting length of gait cycle as elasped frames
                        temp7 = temp4* 10; % Multiplying to get into the right frequency for EMG (video data is 100 hz)
                        temp6 = temp7-temp1; % Getting the length of stance as elasped frames 
                        % Changing the dash to an underscore for the
                        % structure 
                        nEmgR = strrep(emgR{iEmgR}, '-R', '');
                        % Creating blank nan matricies to preallocate sizes
                        % and space 
                        tempStore.(subject1).(speeds3{iSpeeds}).(nEmgR){iCycles}(:, pertCount) = nan(61,1);
                        AUCStance2.(subject1).(speeds3{iSpeeds}).cumtrap.(nEmgR){iCycles}(:,pertCount) = nan(61,1); 
                        AUCStance2.(subject1).(speeds3{iSpeeds}).trap.(nEmgR){iCycles}(pertCount) = nan(1,1);
                        AUCStance2.(subject1).(speeds3{iSpeeds}).Perceived(pertCount) = nan(1,1);
                        
                        tempEMG = subjects.(subject1).npEmgStruct.(tempName{iTrial})(temp1:temp7, emgRidx(iEmgR));
                        x = 1:length(tempEMG);
                        newX = linspace(x(1), x(end),61);
%                         tempEMG2 = interp1(x,tempEMG,newX);
                        % Making the data into 60 points from stance 
                        tempStore.(subject1).(speeds3{iSpeeds}).(nEmgR){iCycles}(:,pertCount) = interp1(x,tempEMG,newX);
                        % Calculating the cumulative trapzoid integral from
                        % the stance data for each subject and their 2
                        % speeds across all cycles 
                        AUCStance2.(subject1).(speeds3{iSpeeds}).cumtrap.(nEmgR){iCycles}(:,pertCount) = cumtrapz(newX, tempStore.(subject1).(speeds3{iSpeeds}).(nEmgR){iCycles}(:,pertCount));  
                        % Calculating the ending result of the trapzoid
                        % integral for stance data 
                        AUCStance2.(subject1).(speeds3{iSpeeds}).trap.(nEmgR){iCycles}(pertCount) = trapz(newX, tempStore.(subject1).(speeds3{iSpeeds}).(nEmgR){iCycles}(:,pertCount));
                        % Putting perceived information in the AUC
                        % structure to be found more easily 
                        AUCStance2.(subject1).(speeds3{iSpeeds}).Perceived(pertCount) = subjects.(subject1).pertCycleStruc.R.(speeds3{iSpeeds}).(tempName{iTrial}).Perceived(iPerts);
                        
                    end
                end
                % Increasing the perturbation count until the next speed
                pertCount = pertCount +1; 
            end
        end
    end
end

%%




for iSubjects = 1:8
    subject1 = ['YAPercep' subName{iSubjects}];
    pTrials = contains(subjects.(subject1).pertTable.Trial, 'Percep'); % Finding which rows in the table contain the Perception Trials
    for iSpeeds = 1:size(speeds,1) % The 8 different perturbation speeds as described in speeds
            for iTrial = 1:size(pTrials,1) % The perturbation trials, ie Percep01-PercepXX
                temp5 = size(subjects.(subject1).pertCycleStruc.R.(speeds{iSpeeds}).(namePercep{iTrial}).Perceived,1); % Getting the amount of perturbations sent at a specific speed per Perception trial
                for iEmgR = 1:size(emgRidx,1) % This loop plots all the emgs collected on the Right leg for 1 subject 
                    for iPerts = 1:temp5 % -5 cycles before Pert, Onset, and +5 cycles after
                        for iCycle = 1:size(nameFrames,1)
                            temp1 = subjects.(subject1).pertCycleStruc.R.(speeds{iSpeeds}).(namePercep{iTrial}).(nameFrames{iCycle}){1,iPerts}(1); % first heel strike of gait cycle 
                            temp2 = subjects.(subject1).pertCycleStruc.R.(speeds{iSpeeds}).(namePercep{iTrial}).(nameFrames{iCycle}){1,iPerts}(5); % ending heel strike of gait cycle
                            temp4 = subjects.(subject1).pertCycleStruc.R.(speeds{iSpeeds}).(namePercep{iTrial}).(nameFrames{iCycle}){1,iPerts}(4); % Toe off for the leg of the first heel strike of the gait cycle 
                            temp1 = temp1* 10;
                            temp2 = temp2* 10;
                            temp3 = temp2 - temp1; % Getting length of gait cycle as elasped frames
                            temp7 = temp4* 10;
                            temp6 = temp7-temp1;
                            % Changing the dash to an underscore for the
                            % structure 
                            nEmgR = strrep(emgR{iEmgR}, '-R', '');
                            % Calc the AUC for full gait cycle
%                             subjects.(subject1).AUCStruct.(speeds{iSpeeds}).(namePercep{iTrial}).(nameFrames{iCycle}).(nEmgR){1,iPerts} = trapz(subjects.(subject1).npEmgStruct.(namePercep{iTrial})(temp1:temp2, emgRidx(iEmgR)));  
%                             % Putting perceived information in the AUC
%                             % structure to be found more easily 
%                             subjects.(subject1).AUCStruct.(speeds{iSpeeds}).(namePercep{iTrial}).Perceived = subjects.(subject1).pertCycleStruc.R.(speeds{iSpeeds}).(namePercep{iTrial}).Perceived;
%                             % Calc the AUC for stance of gait cycle
                            subjects.(subject1).AUCStance.(speeds{iSpeeds}).(namePercep{iTrial}).(nameFrames{iCycle}).(nEmgR){1,iPerts} = trapz(subjects.(subject1).npEmgStruct.(namePercep{iTrial})(temp1:temp7, emgRidx(iEmgR)));  
                            % Putting perceived information in the AUC
                            % structure to be found more easily 
                            subjects.(subject1).AUCStance.(speeds{iSpeeds}).(namePercep{iTrial}).Perceived = subjects.(subject1).pertCycleStruc.R.(speeds{iSpeeds}).(namePercep{iTrial}).Perceived;
                        end
                    end
                end
            end
    end
end

% Saves the structure of subejcts that have the area under the curve
% calculation for stance and the full gait cycle 
save('AUC_subs.mat', 'subjects', '-v7.3')
%%

% Loading the AUC_subs.mat
load('G:\Shared drives\NeuroMobLab\Projects\Perception\Processed Data\Dan\Results\Emg Sub Structure\AUC_subs.mat')

%% Putting all 5 perturbations into the same row 
subName = {'05'; '07'; '10'; '11'; '12'; '13'; '14'; '15';};
emgid = {'EMG_TA-R';'EMG_LGAS-R';'EMG_VLAT-R';'EMG_RFEM-R';'EMG_BFLH-R';'EMG_ADD-R';'EMG_TFL-R';'EMG_GMED-R';'EMG_TA-L';'EMG_LGAS-L';'EMG_VLAT-L';'EMG_RFEM-L';'EMG_BFLH-L';'EMG_ADD-L';'EMG_TFL-L';'EMG_GMED-L';'EMG_SOL-R';'EMG_PERO-R';'EMG_MGAS-R';'EMG_GMAX-R';'EMG_SOL-L';'EMG_PERO-L';'EMG_MGAS-L';'EMG_GMAX-L';'25';'26';'27';'28';'29';'30';'31';'32'};
nameFrames = {'Pre5Frames'; 'Pre4Frames'; 'Pre3Frames'; 'Pre2Frames'; 'Pre1Frames'; 'OnsetFrames'; 'Post1Frames'; 'Post2Frames'; 'Post3Frames'; 'Post4Frames'; 'Post5Frames';}; % -5 cycles before perturbation, Onset, and +5 cycles after perturbation
namePercep = {'Percep01'; 'Percep02'; 'Percep03'; 'Percep04'; 'Percep05'; 'Percep06';}; % name of the potential perception trials for each subject 
speeds = {'sp1'; 'sp2'; 'sp3'; 'sp4'; 'sp5'; 'sp6'; 'sp7'; 'sp8';}; % Speeds in order as above 0, -0.02, -0.5, -0.1, -0.15, -0.2, -0.3, -0.4
namePert = {'Catch'; 'Neg02'; 'Neg05'; 'Neg10'; 'Neg15'; 'Neg20'; 'Neg30'; 'Neg40';}; %Name of the perts to save the files
% Finding the indices of the left and right emgs from emgid to be used to
% plot the muscles in the loop below
B = contains(emgid, '-R'); % Have to do this line because we have extra emg slots 25-32
emgR = emgid(B);
emgRidx = find(B);
speeds2 = {{'sp3'; 'sp4'}, {'sp2'; 'sp3'}, {'sp4'; 'sp5'}, {'sp3'; 'sp4'}, {'sp3'; 'sp4'}, {'sp4'; 'sp5'}, {'sp4'; 'sp5'}, {'sp2'; 'sp3'}};
% pertCount = 1;
for iSubjects = 1:8
    subject1 = ['YAPercep' subName{iSubjects}];
    for iSpeeds = 1:2
        pertCount = 1;
        pTrials = length(fieldnames(tSub2.(subject1).(speeds2{iSubjects}{iSpeeds}))); % Finding which rows in the table contain the Perception Trials
        for iTrial = 1:pTrials
            tempName = fieldnames(tSub2.(subject1).(speeds2{iSubjects}{iSpeeds}));
            temp5 = size(tSub2.(subject1).(speeds2{iSubjects}{iSpeeds}).(tempName{iTrial}).Perceived,1); % Getting the amount of perturbations sent at a specific speed per Perception trial
            for iPerts = 1:temp5
                for iCycles = 1:6
                    for iEmgR = 1:size(emgRidx,1) 
                        nEmgR = strrep(emgR{iEmgR}, '-R', '');
%                         disp(['works for ' subject1])
                        tempAUC.(subject1).(speeds2{iSubjects}{iSpeeds}).(nameFrames{iCycles}).(nEmgR)(pertCount) = tSub2.(subject1).(speeds2{iSubjects}{iSpeeds}).(tempName{iTrial}).(nameFrames{iCycles}).(nEmgR){1,iPerts};
                        tempAUC.(subject1).(speeds2{iSubjects}{iSpeeds}).perceived(pertCount) = tSub2.(subject1).(speeds2{iSubjects}{iSpeeds}).(tempName{iTrial}).Perceived(iPerts);
%                         tSub2.(subject1).(speeds2{iSubjects}{iSpeed}).(namePercep{iTrial}).(nameFrames{iCycle}).(nEmgR
                    end
                end
                pertCount = pertCount + 1;
            end
        end
%         pertCount = 1;
    end
end

%% Temp Fix to get shit to Jessica 



% figure; subplot(3,2,1); bar(tempAUC.YAPercep11.sp3.Pre5Frames.EMG_TA);
% subplot(3,2,2); bar(tempAUC.YAPercep11.sp3.Pre5Frames.EMG_LGAS);
% subplot(3,2,3); bar(tempAUC.YAPercep11.sp3.Pre5Frames.EMG_MGAS);
% subplot(3,2,4); bar(tempAUC.YAPercep11.sp3.Pre5Frames.EMG_SOL);


figure; subplot(3,2,1); bar([tempAUC.YAPercep11.sp3.Pre5Frames.EMG_TA; tempAUC.YAPercep11.sp3.OnsetFrames.EMG_TA]);
subplot(3,2,2); bar([tempAUC.YAPercep11.sp4.Pre5Frames.EMG_TA; tempAUC.YAPercep11.sp4.OnsetFrames.EMG_TA]);
subplot(3,2,3); bar([tempAUC.YAPercep13.sp4.Pre5Frames.EMG_TA; tempAUC.YAPercep13.sp4.OnsetFrames.EMG_TA]);
subplot(3,2,4); bar([tempAUC.YAPercep13.sp5.Pre5Frames.EMG_TA; tempAUC.YAPercep13.sp5.OnsetFrames.EMG_TA]);
subplot(3,2,5); bar([tempAUC.YAPercep15.sp2.Pre5Frames.EMG_TA; tempAUC.YAPercep15.sp2.OnsetFrames.EMG_TA]);
subplot(3,2,6); bar([tempAUC.YAPercep15.sp3.Pre5Frames.EMG_TA; tempAUC.YAPercep15.sp3.OnsetFrames.EMG_TA]);
%% Calculating the mean and SD 


subName = {'05'; '07'; '10'; '11'; '12'; '13'; '14'; '15';};
emgid = {'EMG_TA-R';'EMG_LGAS-R';'EMG_VLAT-R';'EMG_RFEM-R';'EMG_BFLH-R';'EMG_ADD-R';'EMG_TFL-R';'EMG_GMED-R';'EMG_TA-L';'EMG_LGAS-L';'EMG_VLAT-L';'EMG_RFEM-L';'EMG_BFLH-L';'EMG_ADD-L';'EMG_TFL-L';'EMG_GMED-L';'EMG_SOL-R';'EMG_PERO-R';'EMG_MGAS-R';'EMG_GMAX-R';'EMG_SOL-L';'EMG_PERO-L';'EMG_MGAS-L';'EMG_GMAX-L';'25';'26';'27';'28';'29';'30';'31';'32'};
nameFrames = {'Pre5Frames'; 'Pre4Frames'; 'Pre3Frames'; 'Pre2Frames'; 'Pre1Frames'; 'OnsetFrames'; 'Post1Frames'; 'Post2Frames'; 'Post3Frames'; 'Post4Frames'; 'Post5Frames';}; % -5 cycles before perturbation, Onset, and +5 cycles after perturbation
namePercep = {'Percep01'; 'Percep02'; 'Percep03'; 'Percep04'; 'Percep05'; 'Percep06';}; % name of the potential perception trials for each subject 
speeds = {'sp1'; 'sp2'; 'sp3'; 'sp4'; 'sp5'; 'sp6'; 'sp7'; 'sp8';}; % Speeds in order as above 0, -0.02, -0.5, -0.1, -0.15, -0.2, -0.3, -0.4
namePert = {'Catch'; 'Neg02'; 'Neg05'; 'Neg10'; 'Neg15'; 'Neg20'; 'Neg30'; 'Neg40';}; %Name of the perts to save the files
% Finding the indices of the left and right emgs from emgid to be used to
% plot the muscles in the loop below
B = contains(emgid, '-R'); % Have to do this line because we have extra emg slots 25-32
emgR = emgid(B);
emgRidx = find(B);
speeds2 = {{'sp3'; 'sp4'}, {'sp2'; 'sp3'}, {'sp4'; 'sp5'}, {'sp3'; 'sp4'}, {'sp3'; 'sp4'}, {'sp4'; 'sp5'}, {'sp4'; 'sp5'}, {'sp2'; 'sp3'}};

% pertCount = 1;
for iSubjects = 1:8
    subject1 = ['YAPercep' subName{iSubjects}];
    for iSpeeds = 1:2
        for iPerts = 1:5
                for iEmgR = 1:size(emgRidx,1) 
                    nEmgR = strrep(emgR{iEmgR}, '-R', '');
                    tempOnsetcum = AUCStance.(subject1).(speeds2{iSubjects}{iSpeeds}).cumtrap.(nEmgR){1,6}(:,iPerts);
                    tempOnsettrap = AUCStance.(subject1).(speeds2{iSubjects}{iSpeeds}).trap.(nEmgR){1,6}(iPerts);
                    tempPrecum = [AUCStance.(subject1).(speeds2{iSubjects}{iSpeeds}).cumtrap.(nEmgR){1,1}(:,iPerts), AUCStance.(subject1).(speeds2{iSubjects}{iSpeeds}).cumtrap.(nEmgR){1,2}(:,iPerts), AUCStance.(subject1).(speeds2{iSubjects}{iSpeeds}).cumtrap.(nEmgR){1,3}(:,iPerts), AUCStance.(subject1).(speeds2{iSubjects}{iSpeeds}).cumtrap.(nEmgR){1,4}(:,iPerts), AUCStance.(subject1).(speeds2{iSubjects}{iSpeeds}).cumtrap.(nEmgR){1,5}(:,iPerts)];
                    tempPretrap = [AUCStance.(subject1).(speeds2{iSubjects}{iSpeeds}).trap.(nEmgR){1,1}(iPerts), AUCStance.(subject1).(speeds2{iSubjects}{iSpeeds}).trap.(nEmgR){1,2}(iPerts), AUCStance.(subject1).(speeds2{iSubjects}{iSpeeds}).trap.(nEmgR){1,3}(iPerts), AUCStance.(subject1).(speeds2{iSubjects}{iSpeeds}).trap.(nEmgR){1,4}(iPerts), AUCStance.(subject1).(speeds2{iSubjects}{iSpeeds}).trap.(nEmgR){1,5}(iPerts)];
                    for iGait = 1:61
                        AUCStance.(subject1).(speeds2{iSubjects}{iSpeeds}).cumtrap.onset2pre.(nEmgR)(iGait,iPerts) = computeCohen_d(tempOnsetcum(iGait),tempPrecum(iGait,:));
                    end
                    AUCStance.(subject1).(speeds2{iSubjects}{iSpeeds}).trap.onset2pre.(nEmgR)(iPerts) = computeCohen_d(tempOnsettrap, tempPretrap);
                    
                    %                     tempPrecum = [AUCStance.(subject1).(speeds2{iSubjects}{iSpeeds}).Pre5Frames.cumtrap.(nEmgR)(:,iPerts), AUCStance.(subject1).(speeds2{iSubjects}{iSpeeds}).Pre4Frames.(nEmgR).cumtrap(:,iPerts),AUCStance.(subject1).(speeds2{iSubjects}{iSpeeds}).Pre3Frames.(nEmgR).cumtrap(:,iPerts),AUCStance.(subject1).(speeds2{iSubjects}{iSpeeds}).Pre2Frames.(nEmgR).cumtrap(:,iPerts),AUCStance.(subject1).(speeds2{iSubjects}{iSpeeds}).Pre1Frames.(nEmgR).cumtrap(:,iPerts)];
%                     tempPretrap = [AUCStance.(subject1).(speeds2{iSubjects}{iSpeeds}).Pre5Frames.(nEmgR).trap(iPerts), AUCStance.(subject1).(speeds2{iSubjects}{iSpeeds}).Pre4Frames.(nEmgR).trap(iPerts),AUCStance.(subject1).(speeds2{iSubjects}{iSpeeds}).Pre3Frames.(nEmgR).trap(iPerts),AUCStance.(subject1).(speeds2{iSubjects}{iSpeeds}).Pre2Frames.(nEmgR).trap(iPerts),AUCStance.(subject1).(speeds2{iSubjects}{iSpeeds}).Pre1Frames.(nEmgR).trap(iPerts)];
% %                     AUCStance.(subject1).(speeds2{iSubjects}{iSpeeds}).avgPrecum.(nEmgR)(:,iPerts) = mean(tempPrecum,2);
% %                     AUCStance.(subject1).(speeds2{iSubjects}{iSpeeds}).avgPretrap.(nEmgR)(iPerts) = mean(tempPretrap,2);
%                     AUCStance.(subject1).(speeds2{iSubjects}{iSpeeds}).stdPrecum.(nEmgR)(:,iPerts) = std(tempPrecum,0,2);
%                     AUCStance.(subject1).(speeds2{iSubjects}{iSpeeds}).stdPretrap.(nEmgR)(iPerts) = std(tempPretrap,0,2);
                    clear tempPrecum tempPretrap tempOnsetcum tempOnsettrap
                end
        end
    end
end

%%
speeds2 = {'sp8'};
subName = {'05'; '07'; '10'; '11'; '12'; '13'; '14'; '15';};
emgid = {'EMG_TA-R';'EMG_LGAS-R';'EMG_VLAT-R';'EMG_RFEM-R';'EMG_BFLH-R';'EMG_ADD-R';'EMG_TFL-R';'EMG_GMED-R';'EMG_TA-L';'EMG_LGAS-L';'EMG_VLAT-L';'EMG_RFEM-L';'EMG_BFLH-L';'EMG_ADD-L';'EMG_TFL-L';'EMG_GMED-L';'EMG_SOL-R';'EMG_PERO-R';'EMG_MGAS-R';'EMG_GMAX-R';'EMG_SOL-L';'EMG_PERO-L';'EMG_MGAS-L';'EMG_GMAX-L';'25';'26';'27';'28';'29';'30';'31';'32'};
nameFrames = {'Pre5Frames'; 'Pre4Frames'; 'Pre3Frames'; 'Pre2Frames'; 'Pre1Frames'; 'OnsetFrames'; 'Post1Frames'; 'Post2Frames'; 'Post3Frames'; 'Post4Frames'; 'Post5Frames';}; % -5 cycles before perturbation, Onset, and +5 cycles after perturbation
namePercep = {'Percep01'; 'Percep02'; 'Percep03'; 'Percep04'; 'Percep05'; 'Percep06';}; % name of the potential perception trials for each subject 
speeds = {'sp1'; 'sp2'; 'sp3'; 'sp4'; 'sp5'; 'sp6'; 'sp7'; 'sp8';}; % Speeds in order as above 0, -0.02, -0.5, -0.1, -0.15, -0.2, -0.3, -0.4
namePert = {'Catch'; 'Neg02'; 'Neg05'; 'Neg10'; 'Neg15'; 'Neg20'; 'Neg30'; 'Neg40';}; %Name of the perts to save the files
% Finding the indices of the left and right emgs from emgid to be used to
% plot the muscles in the loop below
B = contains(emgid, '-R'); % Have to do this line because we have extra emg slots 25-32
emgR = emgid(B);
emgRidx = find(B);

%% Finding the percent difference EMG 
for iSubjects = 1:8
    subject1 = ['YAPercep' subName{iSubjects}];
    for iSpeeds = 1:2
        for iPerts = 1:5
                for iEmgR = 1:size(emgRidx,1) 
                    nEmgR = strrep(emgR{iEmgR}, '-R', '');
                    tempOnsettrap = AUCStance.(subject1).(speeds2{iSubjects}{iSpeeds}).trap.(nEmgR){1,6}(iPerts);
%                     tempPrecum = [AUCStance.(subject1).(speeds2{iSubjects}{iSpeeds}).cumtrap.(nEmgR){1,1}(:,iPerts), AUCStance.(subject1).(speeds2{iSubjects}{iSpeeds}).cumtrap.(nEmgR){1,2}(:,iPerts), AUCStance.(subject1).(speeds2{iSubjects}{iSpeeds}).cumtrap.(nEmgR){1,3}(:,iPerts), AUCStance.(subject1).(speeds2{iSubjects}{iSpeeds}).cumtrap.(nEmgR){1,4}(:,iPerts), AUCStance.(subject1).(speeds2{iSubjects}{iSpeeds}).cumtrap.(nEmgR){1,5}(:,iPerts)];
                    tempPretrap = [AUCStance.(subject1).(speeds2{iSubjects}{iSpeeds}).trap.(nEmgR){1,1}(iPerts), AUCStance.(subject1).(speeds2{iSubjects}{iSpeeds}).trap.(nEmgR){1,2}(iPerts), AUCStance.(subject1).(speeds2{iSubjects}{iSpeeds}).trap.(nEmgR){1,3}(iPerts), AUCStance.(subject1).(speeds2{iSubjects}{iSpeeds}).trap.(nEmgR){1,4}(iPerts), AUCStance.(subject1).(speeds2{iSubjects}{iSpeeds}).trap.(nEmgR){1,5}(iPerts)];
                    
                    AUCStance.(subject1).(speeds2{iSubjects}{iSpeeds}).trap.percentC.(nEmgR)(iPerts) = ((tempOnsettrap -mean(tempPretrap))/mean(tempPretrap))*100;
                    
                    %                     tempPrecum = [AUCStance.(subject1).(speeds2{iSubjects}{iSpeeds}).Pre5Frames.cumtrap.(nEmgR)(:,iPerts), AUCStance.(subject1).(speeds2{iSubjects}{iSpeeds}).Pre4Frames.(nEmgR).cumtrap(:,iPerts),AUCStance.(subject1).(speeds2{iSubjects}{iSpeeds}).Pre3Frames.(nEmgR).cumtrap(:,iPerts),AUCStance.(subject1).(speeds2{iSubjects}{iSpeeds}).Pre2Frames.(nEmgR).cumtrap(:,iPerts),AUCStance.(subject1).(speeds2{iSubjects}{iSpeeds}).Pre1Frames.(nEmgR).cumtrap(:,iPerts)];
%                     tempPretrap = [AUCStance.(subject1).(speeds2{iSubjects}{iSpeeds}).Pre5Frames.(nEmgR).trap(iPerts), AUCStance.(subject1).(speeds2{iSubjects}{iSpeeds}).Pre4Frames.(nEmgR).trap(iPerts),AUCStance.(subject1).(speeds2{iSubjects}{iSpeeds}).Pre3Frames.(nEmgR).trap(iPerts),AUCStance.(subject1).(speeds2{iSubjects}{iSpeeds}).Pre2Frames.(nEmgR).trap(iPerts),AUCStance.(subject1).(speeds2{iSubjects}{iSpeeds}).Pre1Frames.(nEmgR).trap(iPerts)];
% %                     AUCStance.(subject1).(speeds2{iSubjects}{iSpeeds}).avgPrecum.(nEmgR)(:,iPerts) = mean(tempPrecum,2);
% %                     AUCStance.(subject1).(speeds2{iSubjects}{iSpeeds}).avgPretrap.(nEmgR)(iPerts) = mean(tempPretrap,2);
%                     AUCStance.(subject1).(speeds2{iSubjects}{iSpeeds}).stdPrecum.(nEmgR)(:,iPerts) = std(tempPrecum,0,2);
%                     AUCStance.(subject1).(speeds2{iSubjects}{iSpeeds}).stdPretrap.(nEmgR)(iPerts) = std(tempPretrap,0,2);
                    clear tempPrecum tempPretrap tempOnsetcum tempOnsettrap
                end
        end
    end
end
%% Flipping values for Excel and plotting 
for iSubjects = 1:8
    subject1 = ['YAPercep' subName{iSubjects}];
    for iSpeeds = 1:2
        AUCStance.(subject1).(speeds2{iSubjects}{iSpeeds}).trap.onset2pre = structfun(@transpose, AUCStance.(subject1).(speeds2{iSubjects}{iSpeeds}).trap.onset2pre, 'UniformOutput', 0);

        AUCStance.(subject1).(speeds2{iSubjects}{iSpeeds}).Perceived = AUCStance.(subject1).(speeds2{iSubjects}{iSpeeds}).Perceived';
    end
end

%%
tempSub = nan(80,15);
counter = 1;
for iSubjects = 1:8
    subject1 = ['YAPercep' subName{iSubjects}];
    for iSpeeds = 1:2
        for iPerts = 1:5 
            tempSub(counter,1) = iSubjects; % Subject ID 
            tempSub(counter,2) = iSpeeds; % Speed Level
            tempSub(counter,3) = AUCStance.(subject1).(speeds2{iSubjects}{iSpeeds}).Perceived(iPerts); % Perceived or not
            tempSub(counter,4) = AUCStance.(subject1).(speeds2{iSubjects}{iSpeeds}).trap.onset2pre.EMG_TA(iPerts); % ES for TA over stance 
            tempSub(counter,5) = AUCStance.(subject1).(speeds2{iSubjects}{iSpeeds}).trap.onset2pre.EMG_LGAS(iPerts); % ES for EMG_LGAS over stance 
            tempSub(counter,6) = AUCStance.(subject1).(speeds2{iSubjects}{iSpeeds}).trap.onset2pre.EMG_VLAT(iPerts); % ES for EMG_VLAT over stance 
            tempSub(counter,7) = AUCStance.(subject1).(speeds2{iSubjects}{iSpeeds}).trap.onset2pre.EMG_RFEM(iPerts); % ES for EMG_RFEM over stance 
            tempSub(counter,8) = AUCStance.(subject1).(speeds2{iSubjects}{iSpeeds}).trap.onset2pre.EMG_BFLH(iPerts); % ES for EMG_BFLH over stance 
            tempSub(counter,9) = AUCStance.(subject1).(speeds2{iSubjects}{iSpeeds}).trap.onset2pre.EMG_ADD(iPerts); % ES for EMG_ADD over stance 
            tempSub(counter,10) = AUCStance.(subject1).(speeds2{iSubjects}{iSpeeds}).trap.onset2pre.EMG_TFL(iPerts); % ES for EMG_TFL over stance 
            tempSub(counter,11) = AUCStance.(subject1).(speeds2{iSubjects}{iSpeeds}).trap.onset2pre.EMG_GMED(iPerts); % ES for EMG_GMED over stance 
            tempSub(counter,12) = AUCStance.(subject1).(speeds2{iSubjects}{iSpeeds}).trap.onset2pre.EMG_SOL(iPerts); % ES for EMG_SOL over stance 
            tempSub(counter,13) = AUCStance.(subject1).(speeds2{iSubjects}{iSpeeds}).trap.onset2pre.EMG_PERO(iPerts); % ES for EMG_PERO over stance 
            tempSub(counter,14) = AUCStance.(subject1).(speeds2{iSubjects}{iSpeeds}).trap.onset2pre.EMG_MGAS(iPerts); % ES for EMG_MGAS over stance 
            tempSub(counter,15) = AUCStance.(subject1).(speeds2{iSubjects}{iSpeeds}).trap.onset2pre.EMG_GMAX(iPerts); % ES for EMG_GMAX over stance 
            counter = counter + 1;
        end
    end
end
%%
tempSub2 = nan(80,15);
counter = 1;
for iSubjects = 1:8
    subject1 = ['YAPercep' subName{iSubjects}];
    for iSpeeds = 1:2
        for iPerts = 1:5 
            tempSub2(counter,1) = iSubjects; % Subject ID 
            tempSub2(counter,2) = iSpeeds; % Speed Level
            tempSub2(counter,3) = AUCStance.(subject1).(speeds2{iSubjects}{iSpeeds}).Perceived(iPerts); % Perceived or not
            tempSub2(counter,4) = AUCStance.(subject1).(speeds2{iSubjects}{iSpeeds}).trap.percentC.EMG_TA(iPerts); % ES for TA over stance 
            tempSub2(counter,5) = AUCStance.(subject1).(speeds2{iSubjects}{iSpeeds}).trap.percentC.EMG_LGAS(iPerts); % ES for EMG_LGAS over stance 
            tempSub2(counter,6) = AUCStance.(subject1).(speeds2{iSubjects}{iSpeeds}).trap.percentC.EMG_VLAT(iPerts); % ES for EMG_VLAT over stance 
            tempSub2(counter,7) = AUCStance.(subject1).(speeds2{iSubjects}{iSpeeds}).trap.percentC.EMG_RFEM(iPerts); % ES for EMG_RFEM over stance 
            tempSub2(counter,8) = AUCStance.(subject1).(speeds2{iSubjects}{iSpeeds}).trap.percentC.EMG_BFLH(iPerts); % ES for EMG_BFLH over stance 
            tempSub2(counter,9) = AUCStance.(subject1).(speeds2{iSubjects}{iSpeeds}).trap.percentC.EMG_ADD(iPerts); % ES for EMG_ADD over stance 
            tempSub2(counter,10) = AUCStance.(subject1).(speeds2{iSubjects}{iSpeeds}).trap.percentC.EMG_TFL(iPerts); % ES for EMG_TFL over stance 
            tempSub2(counter,11) = AUCStance.(subject1).(speeds2{iSubjects}{iSpeeds}).trap.percentC.EMG_GMED(iPerts); % ES for EMG_GMED over stance 
            tempSub2(counter,12) = AUCStance.(subject1).(speeds2{iSubjects}{iSpeeds}).trap.percentC.EMG_SOL(iPerts); % ES for EMG_SOL over stance 
            tempSub2(counter,13) = AUCStance.(subject1).(speeds2{iSubjects}{iSpeeds}).trap.percentC.EMG_PERO(iPerts); % ES for EMG_PERO over stance 
            tempSub2(counter,14) = AUCStance.(subject1).(speeds2{iSubjects}{iSpeeds}).trap.percentC.EMG_MGAS(iPerts); % ES for EMG_MGAS over stance 
            tempSub2(counter,15) = AUCStance.(subject1).(speeds2{iSubjects}{iSpeeds}).trap.percentC.EMG_GMAX(iPerts); % ES for EMG_GMAX over stance 
            counter = counter + 1;
        end
    end
end
                 
