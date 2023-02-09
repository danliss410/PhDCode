%% Checking EMG for Subjects 5 and 7 since there looks like there is movement artifact in upper leg muscles 

%% Doing this for subject 5 
strSubject = '05';
subject1 = 'YAPercep05';

load(['G:\Shared drives\NeuroMobLab\Projects\Perception\Processed Data\Dan\Matlab Analysis\' subject1 '\Data Tables\SepTables_' subject1 '.mat'])
load(['G:\Shared drives\NeuroMobLab\Projects\Perception\Processed Data\Dan\Matlab Analysis\' subject1 '\Data Tables\pertTable_' subject1 '.mat'])
load(['G:\Shared drives\NeuroMobLab\Projects\Perception\Processed Data\Dan\Matlab Analysis\' subject1 '\Data Tables\pEmgStruct_' subject1 '.mat'])
load(['G:\Shared drives\NeuroMobLab\Projects\Perception\Processed Data\Dan\Matlab Analysis\' subject1 '\Data Tables\pertCycleStruc_' subject1 '.mat'])

YAPercep05.analog = analogTable;
YAPercep05.pertCycleStruct = pertCycleStruc;
YAPercep05.pert = pertTable; 
YAPercep05.pEMG = pEmgStruct;
YAPercep05.npEMG = npEmgStruct;

%% Doing this for subject 7

strSubject = '07';
subject1 = 'YAPercep07';


load(['G:\Shared drives\NeuroMobLab\Projects\Perception\Processed Data\Dan\Matlab Analysis\' subject1 '\Data Tables\SepTables_' subject1 '.mat'])
load(['G:\Shared drives\NeuroMobLab\Projects\Perception\Processed Data\Dan\Matlab Analysis\' subject1 '\Data Tables\pertTable_' subject1 '.mat'])
load(['G:\Shared drives\NeuroMobLab\Projects\Perception\Processed Data\Dan\Matlab Analysis\' subject1 '\Data Tables\pEmgStruct_' subject1 '.mat'])
load(['G:\Shared drives\NeuroMobLab\Projects\Perception\Processed Data\Dan\Matlab Analysis\' subject1 '\Data Tables\pertCycleStruc_' subject1 '.mat'])

YAPercep07.analog = analogTable;
YAPercep07.pertCycleStruct = pertCycleStruc;
YAPercep07.pert = pertTable; 
YAPercep07.pEMG = pEmgStruct;
YAPercep07.npEMG = npEmgStruct;

clearvars -except YAPercep05 YAPercep07


%% Setting up the filters for EMG processing 

emgid = {'EMG_TA-R';'EMG_LGAS-R';'EMG_VLAT-R';'EMG_RFEM-R';'EMG_BFLH-R';'EMG_ADD-R';'EMG_TFL-R';'EMG_GMED-R';'EMG_TA-L';'EMG_LGAS-L';'EMG_VLAT-L';'EMG_RFEM-L';'EMG_BFLH-L';'EMG_ADD-L';'EMG_TFL-L';'EMG_GMED-L';'EMG_SOL-R';'EMG_PERO-R';'EMG_MGAS-R';'EMG_GMAX-R';'EMG_SOL-L';'EMG_PERO-L';'EMG_MGAS-L';'EMG_GMAX-L';'25';'26';'27';'28';'29';'30';'31';'32'};

SampleRate = 1000;    
nyquist_frequency = SampleRate/2;
% Create filters
% High pass filter at 35 Hz
[filt_high_B,filt_high_A] = butter(4,35/nyquist_frequency,'high');
% Low pass filter at 10 Hz
[filt_low_B,filt_low_A] = butter(4,10/nyquist_frequency,'low');

%% EMG processing for YAPercep05
tempName = YAPercep05.analog.Trial;

for iTable = 1:size(YAPercep05.analog,1)
    EMG = YAPercep05.analog.EMG{iTable,1};
    % Filter EMG signals
    % High pass filter 
    emg = filtfilt(filt_high_B, filt_high_A,EMG);
    hEmg.(tempName{iTable}) = emg;
    % Demean and rectify
    try
        emg_mean = repmat(mean(emg(1:SampleRate,:),1),size(emg,1),1);
    catch ME
        keyboard
    end
    emg = abs(emg-emg_mean);
    rect.(tempName{iTable}) = emg;
    % Low pass filter 
    emg = filtfilt(filt_low_B, filt_low_A,emg);
    pEmg.(tempName{iTable}) = emg;
    
    clear emg EMG emg_mean
end

YAPercep05.hEmg = hEmg;
YAPercep05.rect = rect;
YAPercep05.pEmg = pEmg;

%% EMG processing for YAPercep05
tempName = YAPercep07.analog.Trial;

for iTable = 1:size(YAPercep07.analog,1)
    EMG = YAPercep07.analog.EMG{iTable,1};
    % Filter EMG signals
    % High pass filter 
    emg = filtfilt(filt_high_B, filt_high_A,EMG);
    hEmg.(tempName{iTable}) = emg;
    % Demean and rectify
    try
        emg_mean = repmat(mean(emg(1:SampleRate,:),1),size(emg,1),1);
    catch ME
        keyboard
    end
    emg = abs(emg-emg_mean);
    rect.(tempName{iTable}) = emg;
    % Low pass filter 
    emg = filtfilt(filt_low_B, filt_low_A,emg);
    pEmg.(tempName{iTable}) = emg;
    
    clear emg EMG emg_mean
end

YAPercep07.hEmg = hEmg;
YAPercep07.rect = rect;
YAPercep07.pEmg = pEmg;

clearvars -except YAPercep05 YAPercep07 tempName emgid
%% Plots for YAPercep05
plotloc1 = 'G:\Shared drives\NeuroMobLab\Projects\Perception\Processed Data\Dan\Matlab Analysis\YAPercep05\Muscle Check';

cd(plotloc1)
subject1 = 'YAPercep05';

nameFrames = {'Pre5Frames'; 'Pre4Frames'; 'Pre3Frames'; 'Pre2Frames'; 'Pre1Frames'; 'OnsetFrames'; 'Post1Frames'; 'Post2Frames'; 'Post3Frames'; 'Post4Frames'; 'Post5Frames';}; % -5 cycles before perturbation, Onset, and +5 cycles after perturbation
namePercep = {'Percep01'; 'Percep02'; 'Percep03'; 'Percep04'; 'Percep05'; 'Percep06';}; % name of the potential perception trials for each subject 
speeds = {'sp1'; 'sp2'; 'sp3'; 'sp4'; 'sp5'; 'sp6'; 'sp7'; 'sp8';}; % Speeds in order as above 0, -0.02, -0.5, -0.1, -0.15, -0.2, -0.3, -0.4
namePert = {'Catch'; 'Neg02'; 'Neg05'; 'Neg10'; 'Neg15'; 'Neg20'; 'Neg30'; 'Neg40';}; %Name of the perts to save the files
leg = {'L';'R'}; % Leg

pTrials = contains(YAPercep05.pert.Trial, 'Percep'); % Finding which rows in the table contain the Perception Trials

pTrials = pTrials(pTrials == 1); %Selecting only the indicies that have Perception trials
colors = {'#00876c'; '#4f9971'; '#7bab79'; '#a3bd86'; '#c9ce98'; '#000000' ; '#e8c48b'; '#e5a76f'; '#e2885b'; '#dd6551'; '#d43d51'}; % Setting the colors to be chosen for each cycle plotted

% Finding the indices of the left and right emgs from emgid to be used to
% plot the muscles in the loop below
B = contains(emgid, '-R'); % Have to do this line because we have extra emg slots 25-32
emgR = emgid(B);
emgRidx = find(B);
iLeg = 2; 
% This loop will plot all the left leg muscles for the 5 cycles before, the
% perturbed cycle, and the 5 cycles after the perturbation 
for iSpeeds = 1:size(speeds,1) % The 8 different perturbation speeds as described in speeds
    for iTrial = 1:size(pTrials,1) % The perturbation trials, ie Percep01-PercepXX
        temp5 = size(YAPercep05.pertCycleStruct.(leg{iLeg}).(speeds{iSpeeds}).(namePercep{iTrial}).Perceived,1); % Getting the amount of perturbations sent at a specific speed per Perception trial
        temgR = size(emgR,1)/4;
        for iEmgR = 1:temgR % This loop plots all the emgs collected on the Right leg for 1 subject 
            for iPerts = 1:temp5 % -5 cycles before Pert, Onset, and +5 cycles after
                for iCycle = 1:size(nameFrames,1)
                    temp1 = YAPercep05.pertCycleStruct.(leg{iLeg}).(speeds{iSpeeds}).(namePercep{iTrial}).(nameFrames{iCycle}){1,iPerts}(1); % first heel strike of gait cycle 
                    temp2 = YAPercep05.pertCycleStruct.(leg{iLeg}).(speeds{iSpeeds}).(namePercep{iTrial}).(nameFrames{iCycle}){1,iPerts}(5); % ending heel strike of gait cycle
                    temp4 = YAPercep05.pertCycleStruct.(leg{iLeg}).(speeds{iSpeeds}).(namePercep{iTrial}).(nameFrames{iCycle}){1,iPerts}(4); % Toe off for the leg of the first heel strike of the gait cycle 
                    temp1 = temp1* 10;
                    temp2 = temp2* 10;
                    temp3 = temp2 - temp1; % Getting length of gait cycle as elasped frames

                    if isnan(temp1) || isnan(temp2) || isnan(temp3)

                    else  
                        perceived = YAPercep05.pertCycleStruct.(leg{iLeg}).(speeds{iSpeeds}).(namePercep{iTrial}).Perceived(iPerts);
                        if perceived == 1
                            namePerceived = 'Perceived';
                        else
                            namePerceived = 'Not Perceived';
                        end
                        if iEmgR == 1 && iCycle == 1
                            h = figure('Name', ['Check_EMG_1 ' subject1 ' ' leg{iLeg} ' ' namePert{iSpeeds} ' ' namePercep{iTrial} ' ' num2str(iPerts) ' ' namePerceived], 'NumberTitle', 'off', 'visible', 'off');
                            filename = ['Check_EMG_1' subject1 '_' leg{iLeg} '_' namePert{iSpeeds} '_' namePercep{iTrial} '_' num2str(iPerts) '_' namePerceived];
                            filenamePDF = strcat(filename, '.pdf');
                            % Hardcoded the emgRidx numbers to
                            % correspond with the EMG ID that I want to
                            % plot as the label and to plot based on
                            % the leg. 12 muscles per leg
                            % INSERT LABELS OF MUSCLES HERE 
                            % ODD numbered subplots (left hand side)
                            % will be unprocessed EMG 
                            subplot(4,4,1); plot((0:temp3)/temp3, YAPercep05.analog.EMG{iTrial,1}(temp1:temp2, emgRidx(1)), 'color', colors{iCycle}); title(['Raw ' emgid(emgRidx(1))]);
                            hold on;
                            subplot(4,4,5); plot((0:temp3)/temp3, YAPercep05.hEmg.(tempName{iTrial})(temp1:temp2, emgRidx(1)), 'color', colors{iCycle}); title('High Pass Filter');
                            hold on;
                            subplot(4,4,9); plot((0:temp3)/temp3, YAPercep05.rect.(tempName{iTrial})(temp1:temp2, emgRidx(1)), 'color', colors{iCycle}); title('Rectify'); 
                            hold on;
                            subplot(4,4,13); plot((0:temp3)/temp3, YAPercep05.pEMG.(tempName{iTrial})(temp1:temp2, emgRidx(1)), 'color', colors{iCycle}); title('Processed EMG')
                            hold on; 
                            subplot(4,4,2); plot((0:temp3)/temp3, YAPercep05.analog.EMG{iTrial,1}(temp1:temp2, emgRidx(2)), 'color', colors{iCycle}); title(['Raw ' emgid(emgRidx(2))]);
                            hold on;
                            subplot(4,4,6); plot((0:temp3)/temp3, YAPercep05.hEmg.(tempName{iTrial})(temp1:temp2, emgRidx(2)), 'color', colors{iCycle}); title('High Pass Filter');
                            hold on;
                            subplot(4,4,10); plot((0:temp3)/temp3, YAPercep05.rect.(tempName{iTrial})(temp1:temp2, emgRidx(2)), 'color', colors{iCycle}); title('Rectify'); 
                            hold on;
                            subplot(4,4,14); plot((0:temp3)/temp3, YAPercep05.pEMG.(tempName{iTrial})(temp1:temp2, emgRidx(2)), 'color', colors{iCycle}); title('Processed EMG')
                            hold on; 
                            subplot(4,4,3); plot((0:temp3)/temp3, YAPercep05.analog.EMG{iTrial,1}(temp1:temp2, emgRidx(3)), 'color', colors{iCycle}); title(['Raw ' emgid(emgRidx(3))]);
                            hold on;
                            subplot(4,4,7); plot((0:temp3)/temp3, YAPercep05.hEmg.(tempName{iTrial})(temp1:temp2, emgRidx(3)), 'color', colors{iCycle}); title('High Pass Filter');
                            hold on;
                            subplot(4,4,11); plot((0:temp3)/temp3, YAPercep05.rect.(tempName{iTrial})(temp1:temp2, emgRidx(3)), 'color', colors{iCycle}); title('Rectify'); 
                            hold on;
                            subplot(4,4,15); plot((0:temp3)/temp3, YAPercep05.pEMG.(tempName{iTrial})(temp1:temp2, emgRidx(3)), 'color', colors{iCycle}); title('Processed EMG')
                            hold on; 
                            subplot(4,4,4); plot((0:temp3)/temp3, YAPercep05.analog.EMG{iTrial,1}(temp1:temp2, emgRidx(4)), 'color', colors{iCycle}); title(['Raw ' emgid(emgRidx(4))]);
                            hold on;
                            subplot(4,4,8); plot((0:temp3)/temp3, YAPercep05.hEmg.(tempName{iTrial})(temp1:temp2, emgRidx(4)), 'color', colors{iCycle}); title('High Pass Filter');
                            hold on;
                            subplot(4,4,12); plot((0:temp3)/temp3, YAPercep05.rect.(tempName{iTrial})(temp1:temp2, emgRidx(4)), 'color', colors{iCycle}); title('Rectify'); 
                            hold on;
                            subplot(4,4,16); plot((0:temp3)/temp3, YAPercep05.pEMG.(tempName{iTrial})(temp1:temp2, emgRidx(4)), 'color', colors{iCycle}); title('Processed EMG')
                            hold on;
                        elseif iEmgR == 1 && iCycle ~= 1 
                            subplot(4,4,1); plot((0:temp3)/temp3, YAPercep05.analog.EMG{iTrial,1}(temp1:temp2, emgRidx(1)), 'color', colors{iCycle}); title(['Raw ' emgid(emgRidx(1))]);
                            hold on;
                            subplot(4,4,5); plot((0:temp3)/temp3, YAPercep05.hEmg.(tempName{iTrial})(temp1:temp2, emgRidx(1)), 'color', colors{iCycle}); title('High Pass Filter');
                            hold on;
                            subplot(4,4,9); plot((0:temp3)/temp3, YAPercep05.rect.(tempName{iTrial})(temp1:temp2, emgRidx(1)), 'color', colors{iCycle}); title('Rectify'); 
                            hold on;
                            subplot(4,4,13); plot((0:temp3)/temp3, YAPercep05.pEMG.(tempName{iTrial})(temp1:temp2, emgRidx(1)), 'color', colors{iCycle}); title('Processed EMG')
                            hold on; 
                            subplot(4,4,2); plot((0:temp3)/temp3, YAPercep05.analog.EMG{iTrial,1}(temp1:temp2, emgRidx(2)), 'color', colors{iCycle}); title(['Raw ' emgid(emgRidx(2))]);
                            hold on;
                            subplot(4,4,6); plot((0:temp3)/temp3, YAPercep05.hEmg.(tempName{iTrial})(temp1:temp2, emgRidx(2)), 'color', colors{iCycle}); title('High Pass Filter');
                            hold on;
                            subplot(4,4,10); plot((0:temp3)/temp3, YAPercep05.rect.(tempName{iTrial})(temp1:temp2, emgRidx(2)), 'color', colors{iCycle}); title('Rectify'); 
                            hold on;
                            subplot(4,4,14); plot((0:temp3)/temp3, YAPercep05.pEMG.(tempName{iTrial})(temp1:temp2, emgRidx(2)), 'color', colors{iCycle}); title('Processed EMG')
                            hold on; 
                            subplot(4,4,3); plot((0:temp3)/temp3, YAPercep05.analog.EMG{iTrial,1}(temp1:temp2, emgRidx(3)), 'color', colors{iCycle}); title(['Raw ' emgid(emgRidx(3))]);
                            hold on;
                            subplot(4,4,7); plot((0:temp3)/temp3, YAPercep05.hEmg.(tempName{iTrial})(temp1:temp2, emgRidx(3)), 'color', colors{iCycle}); title('High Pass Filter');
                            hold on;
                            subplot(4,4,11); plot((0:temp3)/temp3, YAPercep05.rect.(tempName{iTrial})(temp1:temp2, emgRidx(3)), 'color', colors{iCycle}); title('Rectify'); 
                            hold on;
                            subplot(4,4,15); plot((0:temp3)/temp3, YAPercep05.pEMG.(tempName{iTrial})(temp1:temp2, emgRidx(3)), 'color', colors{iCycle}); title('Processed EMG')
                            hold on; 
                            subplot(4,4,4); plot((0:temp3)/temp3, YAPercep05.analog.EMG{iTrial,1}(temp1:temp2, emgRidx(4)), 'color', colors{iCycle}); title(['Raw ' emgid(emgRidx(4))]);
                            hold on;
                            subplot(4,4,8); plot((0:temp3)/temp3, YAPercep05.hEmg.(tempName{iTrial})(temp1:temp2, emgRidx(4)), 'color', colors{iCycle}); title('High Pass Filter');
                            hold on;
                            subplot(4,4,12); plot((0:temp3)/temp3, YAPercep05.rect.(tempName{iTrial})(temp1:temp2, emgRidx(4)), 'color', colors{iCycle}); title('Rectify'); 
                            hold on;
                            subplot(4,4,16); plot((0:temp3)/temp3, YAPercep05.pEMG.(tempName{iTrial})(temp1:temp2, emgRidx(4)), 'color', colors{iCycle}); title('Processed EMG')
                            hold on;
                        elseif iEmgR == 2 && iCycle == 1 
                            h2 = figure('Name', ['Check_EMG_2 ' subject1 ' ' leg{iLeg} ' ' namePert{iSpeeds} ' ' namePercep{iTrial} ' ' num2str(iPerts) ' ' namePerceived], 'NumberTitle', 'off', 'visible', 'off');
                            filename2 = ['Check_EMG_2' subject1 '_' leg{iLeg} '_' namePert{iSpeeds} '_' namePercep{iTrial} '_' num2str(iPerts) '_' namePerceived];
                            filenamePDF2 = strcat(filename2, '.pdf');
                            subplot(4,4,1); plot((0:temp3)/temp3, YAPercep05.analog.EMG{iTrial,1}(temp1:temp2, emgRidx(5)), 'color', colors{iCycle}); title(['Raw ' emgid(emgRidx(5))]);
                            hold on;
                            subplot(4,4,5); plot((0:temp3)/temp3, YAPercep05.hEmg.(tempName{iTrial})(temp1:temp2, emgRidx(5)), 'color', colors{iCycle}); title('High Pass Filter');
                            hold on;
                            subplot(4,4,9); plot((0:temp3)/temp3, YAPercep05.rect.(tempName{iTrial})(temp1:temp2, emgRidx(5)), 'color', colors{iCycle}); title('Rectify'); 
                            hold on;
                            subplot(4,4,13); plot((0:temp3)/temp3, YAPercep05.pEMG.(tempName{iTrial})(temp1:temp2, emgRidx(5)), 'color', colors{iCycle}); title('Processed EMG')
                            hold on; 
                            subplot(4,4,2); plot((0:temp3)/temp3, YAPercep05.analog.EMG{iTrial,1}(temp1:temp2, emgRidx(6)), 'color', colors{iCycle}); title(['Raw ' emgid(emgRidx(6))]);
                            hold on;
                            subplot(4,4,6); plot((0:temp3)/temp3, YAPercep05.hEmg.(tempName{iTrial})(temp1:temp2, emgRidx(6)), 'color', colors{iCycle}); title('High Pass Filter');
                            hold on;
                            subplot(4,4,10); plot((0:temp3)/temp3, YAPercep05.rect.(tempName{iTrial})(temp1:temp2, emgRidx(6)), 'color', colors{iCycle}); title('Rectify'); 
                            hold on;
                            subplot(4,4,14); plot((0:temp3)/temp3, YAPercep05.pEMG.(tempName{iTrial})(temp1:temp2, emgRidx(6)), 'color', colors{iCycle}); title('Processed EMG')
                            hold on; 
                            subplot(4,4,3); plot((0:temp3)/temp3, YAPercep05.analog.EMG{iTrial,1}(temp1:temp2, emgRidx(7)), 'color', colors{iCycle}); title(['Raw ' emgid(emgRidx(7))]);
                            hold on;
                            subplot(4,4,7); plot((0:temp3)/temp3, YAPercep05.hEmg.(tempName{iTrial})(temp1:temp2, emgRidx(7)), 'color', colors{iCycle}); title('High Pass Filter');
                            hold on;
                            subplot(4,4,11); plot((0:temp3)/temp3, YAPercep05.rect.(tempName{iTrial})(temp1:temp2, emgRidx(7)), 'color', colors{iCycle}); title('Rectify'); 
                            hold on;
                            subplot(4,4,15); plot((0:temp3)/temp3, YAPercep05.pEMG.(tempName{iTrial})(temp1:temp2, emgRidx(7)), 'color', colors{iCycle}); title('Processed EMG')
                            hold on; 
                            subplot(4,4,4); plot((0:temp3)/temp3, YAPercep05.analog.EMG{iTrial,1}(temp1:temp2, emgRidx(8)), 'color', colors{iCycle}); title(['Raw ' emgid(emgRidx(8))]);
                            hold on;
                            subplot(4,4,8); plot((0:temp3)/temp3, YAPercep05.hEmg.(tempName{iTrial})(temp1:temp2, emgRidx(8)), 'color', colors{iCycle}); title('High Pass Filter');
                            hold on;
                            subplot(4,4,12); plot((0:temp3)/temp3, YAPercep05.rect.(tempName{iTrial})(temp1:temp2, emgRidx(8)), 'color', colors{iCycle}); title('Rectify'); 
                            hold on;
                            subplot(4,4,16); plot((0:temp3)/temp3, YAPercep05.pEMG.(tempName{iTrial})(temp1:temp2, emgRidx(8)), 'color', colors{iCycle}); title('Processed EMG')
                            hold on;
                        elseif iEmgR == 2 && iCycle ~= 1
                            subplot(4,4,1); plot((0:temp3)/temp3, YAPercep05.analog.EMG{iTrial,1}(temp1:temp2, emgRidx(5)), 'color', colors{iCycle}); title(['Raw ' emgid(emgRidx(5))]);
                            hold on;
                            subplot(4,4,5); plot((0:temp3)/temp3, YAPercep05.hEmg.(tempName{iTrial})(temp1:temp2, emgRidx(5)), 'color', colors{iCycle}); title('High Pass Filter');
                            hold on;
                            subplot(4,4,9); plot((0:temp3)/temp3, YAPercep05.rect.(tempName{iTrial})(temp1:temp2, emgRidx(5)), 'color', colors{iCycle}); title('Rectify'); 
                            hold on;
                            subplot(4,4,13); plot((0:temp3)/temp3, YAPercep05.pEMG.(tempName{iTrial})(temp1:temp2, emgRidx(5)), 'color', colors{iCycle}); title('Processed EMG')
                            hold on; 
                            subplot(4,4,2); plot((0:temp3)/temp3, YAPercep05.analog.EMG{iTrial,1}(temp1:temp2, emgRidx(6)), 'color', colors{iCycle}); title(['Raw ' emgid(emgRidx(6))]);
                            hold on;
                            subplot(4,4,6); plot((0:temp3)/temp3, YAPercep05.hEmg.(tempName{iTrial})(temp1:temp2, emgRidx(6)), 'color', colors{iCycle}); title('High Pass Filter');
                            hold on;
                            subplot(4,4,10); plot((0:temp3)/temp3, YAPercep05.rect.(tempName{iTrial})(temp1:temp2, emgRidx(6)), 'color', colors{iCycle}); title('Rectify'); 
                            hold on;
                            subplot(4,4,14); plot((0:temp3)/temp3, YAPercep05.pEMG.(tempName{iTrial})(temp1:temp2, emgRidx(6)), 'color', colors{iCycle}); title('Processed EMG')
                            hold on; 
                            subplot(4,4,3); plot((0:temp3)/temp3, YAPercep05.analog.EMG{iTrial,1}(temp1:temp2, emgRidx(7)), 'color', colors{iCycle}); title(['Raw ' emgid(emgRidx(7))]);
                            hold on;
                            subplot(4,4,7); plot((0:temp3)/temp3, YAPercep05.hEmg.(tempName{iTrial})(temp1:temp2, emgRidx(7)), 'color', colors{iCycle}); title('High Pass Filter');
                            hold on;
                            subplot(4,4,11); plot((0:temp3)/temp3, YAPercep05.rect.(tempName{iTrial})(temp1:temp2, emgRidx(7)), 'color', colors{iCycle}); title('Rectify'); 
                            hold on;
                            subplot(4,4,15); plot((0:temp3)/temp3, YAPercep05.pEMG.(tempName{iTrial})(temp1:temp2, emgRidx(7)), 'color', colors{iCycle}); title('Processed EMG')
                            hold on; 
                            subplot(4,4,4); plot((0:temp3)/temp3, YAPercep05.analog.EMG{iTrial,1}(temp1:temp2, emgRidx(8)), 'color', colors{iCycle}); title(['Raw ' emgid(emgRidx(8))]);
                            hold on;
                            subplot(4,4,8); plot((0:temp3)/temp3, YAPercep05.hEmg.(tempName{iTrial})(temp1:temp2, emgRidx(8)), 'color', colors{iCycle}); title('High Pass Filter');
                            hold on;
                            subplot(4,4,12); plot((0:temp3)/temp3, YAPercep05.rect.(tempName{iTrial})(temp1:temp2, emgRidx(8)), 'color', colors{iCycle}); title('Rectify'); 
                            hold on;
                            subplot(4,4,16); plot((0:temp3)/temp3, YAPercep05.pEMG.(tempName{iTrial})(temp1:temp2, emgRidx(8)), 'color', colors{iCycle}); title('Processed EMG')
                            hold on;
                        elseif iEmgR == 3 && iCycle == 1
                            h3 = figure('Name', ['Check_EMG_3 ' subject1 ' ' leg{iLeg} ' ' namePert{iSpeeds} ' ' namePercep{iTrial} ' ' num2str(iPerts) ' ' namePerceived], 'NumberTitle', 'off', 'visible', 'off');
                            filename3 = ['Check_EMG_3' subject1 '_' leg{iLeg} '_' namePert{iSpeeds} '_' namePercep{iTrial} '_' num2str(iPerts) '_' namePerceived];
                            filenamePDF3 = strcat(filename3, '.pdf');
                            subplot(4,4,1); plot((0:temp3)/temp3, YAPercep05.analog.EMG{iTrial,1}(temp1:temp2, emgRidx(9)), 'color', colors{iCycle}); title(['Raw ' emgid(emgRidx(9))]);
                            hold on;
                            subplot(4,4,5); plot((0:temp3)/temp3, YAPercep05.hEmg.(tempName{iTrial})(temp1:temp2, emgRidx(9)), 'color', colors{iCycle}); title('High Pass Filter');
                            hold on;
                            subplot(4,4,9); plot((0:temp3)/temp3, YAPercep05.rect.(tempName{iTrial})(temp1:temp2, emgRidx(9)), 'color', colors{iCycle}); title('Rectify'); 
                            hold on;
                            subplot(4,4,13); plot((0:temp3)/temp3, YAPercep05.pEMG.(tempName{iTrial})(temp1:temp2, emgRidx(9)), 'color', colors{iCycle}); title('Processed EMG')
                            hold on; 
                            subplot(4,4,2); plot((0:temp3)/temp3, YAPercep05.analog.EMG{iTrial,1}(temp1:temp2, emgRidx(10)), 'color', colors{iCycle}); title(['Raw ' emgid(emgRidx(10))]);
                            hold on;
                            subplot(4,4,6); plot((0:temp3)/temp3, YAPercep05.hEmg.(tempName{iTrial})(temp1:temp2, emgRidx(10)), 'color', colors{iCycle}); title('High Pass Filter');
                            hold on;
                            subplot(4,4,10); plot((0:temp3)/temp3, YAPercep05.rect.(tempName{iTrial})(temp1:temp2, emgRidx(10)), 'color', colors{iCycle}); title('Rectify'); 
                            hold on;
                            subplot(4,4,14); plot((0:temp3)/temp3, YAPercep05.pEMG.(tempName{iTrial})(temp1:temp2, emgRidx(10)), 'color', colors{iCycle}); title('Processed EMG')
                            hold on; 
                            subplot(4,4,3); plot((0:temp3)/temp3, YAPercep05.analog.EMG{iTrial,1}(temp1:temp2, emgRidx(11)), 'color', colors{iCycle}); title(['Raw ' emgid(emgRidx(11))]);
                            hold on;
                            subplot(4,4,7); plot((0:temp3)/temp3, YAPercep05.hEmg.(tempName{iTrial})(temp1:temp2, emgRidx(11)), 'color', colors{iCycle}); title('High Pass Filter');
                            hold on;
                            subplot(4,4,11); plot((0:temp3)/temp3, YAPercep05.rect.(tempName{iTrial})(temp1:temp2, emgRidx(11)), 'color', colors{iCycle}); title('Rectify'); 
                            hold on;
                            subplot(4,4,15); plot((0:temp3)/temp3, YAPercep05.pEMG.(tempName{iTrial})(temp1:temp2, emgRidx(11)), 'color', colors{iCycle}); title('Processed EMG')
                            hold on; 
                            subplot(4,4,4); plot((0:temp3)/temp3, YAPercep05.analog.EMG{iTrial,1}(temp1:temp2, emgRidx(12)), 'color', colors{iCycle}); title(['Raw ' emgid(emgRidx(12))]);
                            hold on;
                            subplot(4,4,8); plot((0:temp3)/temp3, YAPercep05.hEmg.(tempName{iTrial})(temp1:temp2, emgRidx(12)), 'color', colors{iCycle}); title('High Pass Filter');
                            hold on;
                            subplot(4,4,12); plot((0:temp3)/temp3, YAPercep05.rect.(tempName{iTrial})(temp1:temp2, emgRidx(12)), 'color', colors{iCycle}); title('Rectify'); 
                            hold on;
                            subplot(4,4,16); plot((0:temp3)/temp3, YAPercep05.pEMG.(tempName{iTrial})(temp1:temp2, emgRidx(12)), 'color', colors{iCycle}); title('Processed EMG')
                            hold on;
                        else 
                            subplot(4,4,1); plot((0:temp3)/temp3, YAPercep05.analog.EMG{iTrial,1}(temp1:temp2, emgRidx(9)), 'color', colors{iCycle}); title(['Raw ' emgid(emgRidx(9))]);
                            hold on;
                            subplot(4,4,5); plot((0:temp3)/temp3, YAPercep05.hEmg.(tempName{iTrial})(temp1:temp2, emgRidx(9)), 'color', colors{iCycle}); title('High Pass Filter');
                            hold on;
                            subplot(4,4,9); plot((0:temp3)/temp3, YAPercep05.rect.(tempName{iTrial})(temp1:temp2, emgRidx(9)), 'color', colors{iCycle}); title('Rectify'); 
                            hold on;
                            subplot(4,4,13); plot((0:temp3)/temp3, YAPercep05.pEMG.(tempName{iTrial})(temp1:temp2, emgRidx(9)), 'color', colors{iCycle}); title('Processed EMG')
                            hold on; 
                            subplot(4,4,2); plot((0:temp3)/temp3, YAPercep05.analog.EMG{iTrial,1}(temp1:temp2, emgRidx(10)), 'color', colors{iCycle}); title(['Raw ' emgid(emgRidx(10))]);
                            hold on;
                            subplot(4,4,6); plot((0:temp3)/temp3, YAPercep05.hEmg.(tempName{iTrial})(temp1:temp2, emgRidx(10)), 'color', colors{iCycle}); title('High Pass Filter');
                            hold on;
                            subplot(4,4,10); plot((0:temp3)/temp3, YAPercep05.rect.(tempName{iTrial})(temp1:temp2, emgRidx(10)), 'color', colors{iCycle}); title('Rectify'); 
                            hold on;
                            subplot(4,4,14); plot((0:temp3)/temp3, YAPercep05.pEMG.(tempName{iTrial})(temp1:temp2, emgRidx(10)), 'color', colors{iCycle}); title('Processed EMG')
                            hold on; 
                            subplot(4,4,3); plot((0:temp3)/temp3, YAPercep05.analog.EMG{iTrial,1}(temp1:temp2, emgRidx(11)), 'color', colors{iCycle}); title(['Raw ' emgid(emgRidx(11))]);
                            hold on;
                            subplot(4,4,7); plot((0:temp3)/temp3, YAPercep05.hEmg.(tempName{iTrial})(temp1:temp2, emgRidx(11)), 'color', colors{iCycle}); title('High Pass Filter');
                            hold on;
                            subplot(4,4,11); plot((0:temp3)/temp3, YAPercep05.rect.(tempName{iTrial})(temp1:temp2, emgRidx(11)), 'color', colors{iCycle}); title('Rectify'); 
                            hold on;
                            subplot(4,4,15); plot((0:temp3)/temp3, YAPercep05.pEMG.(tempName{iTrial})(temp1:temp2, emgRidx(11)), 'color', colors{iCycle}); title('Processed EMG')
                            hold on; 
                            subplot(4,4,4); plot((0:temp3)/temp3, YAPercep05.analog.EMG{iTrial,1}(temp1:temp2, emgRidx(12)), 'color', colors{iCycle}); title(['Raw ' emgid(emgRidx(12))]);
                            hold on;
                            subplot(4,4,8); plot((0:temp3)/temp3, YAPercep05.hEmg.(tempName{iTrial})(temp1:temp2, emgRidx(12)), 'color', colors{iCycle}); title('High Pass Filter');
                            hold on;
                            subplot(4,4,12); plot((0:temp3)/temp3, YAPercep05.rect.(tempName{iTrial})(temp1:temp2, emgRidx(12)), 'color', colors{iCycle}); title('Rectify'); 
                            hold on;
                            subplot(4,4,16); plot((0:temp3)/temp3, YAPercep05.pEMG.(tempName{iTrial})(temp1:temp2, emgRidx(12)), 'color', colors{iCycle}); title('Processed EMG')
                            hold on;
                        end                    
                    end
                    clear temp1 temp2 temp 3 perceived namePerceived
                end
                if iEmgR == 1
                    set(h, 'visible', 'on');
                    saveas(h, filename);
                    print(filenamePDF, '-dpdf', '-bestfit');
                    close(h)
                    % This figure has plots for TA, LGAS, VLAT, RFEM
                elseif iEmgR == 2
                    set(h2, 'visible', 'on');
                    saveas(h2, filename2);
                    print(filenamePDF2, '-dpdf', '-bestfit');
                    close(h2)
                    % This figure has plots for BFLH, ADD, TFL, GMED
                else 
                    set(h3, 'visible', 'on');
                    saveas(h3, filename3);
                    print(filenamePDF3, '-dpdf', '-bestfit');
                    close(h3)
                    % This figure has plots for SOL, PERO, MGAS, GMAX
                end
            end

        end
    end
end

%% Plots for YAPercep05
plotloc1 = 'G:\Shared drives\NeuroMobLab\Projects\Perception\Processed Data\Dan\Matlab Analysis\YAPercep07\Muscle Check';

cd(plotloc1)
subject1 = 'YAPercep07';

nameFrames = {'Pre5Frames'; 'Pre4Frames'; 'Pre3Frames'; 'Pre2Frames'; 'Pre1Frames'; 'OnsetFrames'; 'Post1Frames'; 'Post2Frames'; 'Post3Frames'; 'Post4Frames'; 'Post5Frames';}; % -5 cycles before perturbation, Onset, and +5 cycles after perturbation
namePercep = {'Percep01'; 'Percep02'; 'Percep03'; 'Percep04'; 'Percep05'; 'Percep06';}; % name of the potential perception trials for each subject 
speeds = {'sp1'; 'sp2'; 'sp3'; 'sp4'; 'sp5'; 'sp6'; 'sp7'; 'sp8';}; % Speeds in order as above 0, -0.02, -0.5, -0.1, -0.15, -0.2, -0.3, -0.4
namePert = {'Catch'; 'Neg02'; 'Neg05'; 'Neg10'; 'Neg15'; 'Neg20'; 'Neg30'; 'Neg40';}; %Name of the perts to save the files
leg = {'L';'R'}; % Leg

pTrials = contains(YAPercep05.pert.Trial, 'Percep'); % Finding which rows in the table contain the Perception Trials

pTrials = pTrials(pTrials == 1); %Selecting only the indicies that have Perception trials
colors = {'#00876c'; '#4f9971'; '#7bab79'; '#a3bd86'; '#c9ce98'; '#000000' ; '#e8c48b'; '#e5a76f'; '#e2885b'; '#dd6551'; '#d43d51'}; % Setting the colors to be chosen for each cycle plotted

% Finding the indices of the left and right emgs from emgid to be used to
% plot the muscles in the loop below
B = contains(emgid, '-R'); % Have to do this line because we have extra emg slots 25-32
emgR = emgid(B);
emgRidx = find(B);
iLeg = 2; 
% This loop will plot all the left leg muscles for the 5 cycles before, the
% perturbed cycle, and the 5 cycles after the perturbation 
for iSpeeds = 1:size(speeds,1) % The 8 different perturbation speeds as described in speeds
    for iTrial = 1:size(pTrials,1) % The perturbation trials, ie Percep01-PercepXX
        temp5 = size(YAPercep07.pertCycleStruct.(leg{iLeg}).(speeds{iSpeeds}).(namePercep{iTrial}).Perceived,1); % Getting the amount of perturbations sent at a specific speed per Perception trial
        temgR = size(emgR,1)/4;
        for iEmgR = 1:temgR % This loop plots all the emgs collected on the Right leg for 1 subject 
            for iPerts = 1:temp5 % -5 cycles before Pert, Onset, and +5 cycles after
                for iCycle = 1:size(nameFrames,1)
                    temp1 = YAPercep07.pertCycleStruct.(leg{iLeg}).(speeds{iSpeeds}).(namePercep{iTrial}).(nameFrames{iCycle}){1,iPerts}(1); % first heel strike of gait cycle 
                    temp2 = YAPercep07.pertCycleStruct.(leg{iLeg}).(speeds{iSpeeds}).(namePercep{iTrial}).(nameFrames{iCycle}){1,iPerts}(5); % ending heel strike of gait cycle
                    temp4 = YAPercep07.pertCycleStruct.(leg{iLeg}).(speeds{iSpeeds}).(namePercep{iTrial}).(nameFrames{iCycle}){1,iPerts}(4); % Toe off for the leg of the first heel strike of the gait cycle 
                    temp1 = temp1* 10;
                    temp2 = temp2* 10;
                    temp3 = temp2 - temp1; % Getting length of gait cycle as elasped frames

                    if isnan(temp1) || isnan(temp2) || isnan(temp3)

                    else  
                        perceived = YAPercep05.pertCycleStruct.(leg{iLeg}).(speeds{iSpeeds}).(namePercep{iTrial}).Perceived(iPerts);
                        if perceived == 1
                            namePerceived = 'Perceived';
                        else
                            namePerceived = 'Not Perceived';
                        end
                        if iEmgR == 1 && iCycle == 1
                            h = figure('Name', ['Check_EMG_1 ' subject1 ' ' leg{iLeg} ' ' namePert{iSpeeds} ' ' namePercep{iTrial} ' ' num2str(iPerts) ' ' namePerceived], 'NumberTitle', 'off', 'visible', 'off');
                            filename = ['Check_EMG_1' subject1 '_' leg{iLeg} '_' namePert{iSpeeds} '_' namePercep{iTrial} '_' num2str(iPerts) '_' namePerceived];
                            filenamePDF = strcat(filename, '.pdf');
                            % Hardcoded the emgRidx numbers to
                            % correspond with the EMG ID that I want to
                            % plot as the label and to plot based on
                            % the leg. 12 muscles per leg
                            % INSERT LABELS OF MUSCLES HERE 
                            % ODD numbered subplots (left hand side)
                            % will be unprocessed EMG 
                            subplot(4,4,1); plot((0:temp3)/temp3, YAPercep07.analog.EMG{iTrial,1}(temp1:temp2, emgRidx(1)), 'color', colors{iCycle}); title(['Raw ' emgid(emgRidx(1))]);
                            hold on;
                            subplot(4,4,5); plot((0:temp3)/temp3, YAPercep07.hEmg.(tempName{iTrial})(temp1:temp2, emgRidx(1)), 'color', colors{iCycle}); title('High Pass Filter');
                            hold on;
                            subplot(4,4,9); plot((0:temp3)/temp3, YAPercep07.rect.(tempName{iTrial})(temp1:temp2, emgRidx(1)), 'color', colors{iCycle}); title('Rectify'); 
                            hold on;
                            subplot(4,4,13); plot((0:temp3)/temp3, YAPercep07.pEMG.(tempName{iTrial})(temp1:temp2, emgRidx(1)), 'color', colors{iCycle}); title('Processed EMG')
                            hold on; 
                            subplot(4,4,2); plot((0:temp3)/temp3, YAPercep07.analog.EMG{iTrial,1}(temp1:temp2, emgRidx(2)), 'color', colors{iCycle}); title(['Raw ' emgid(emgRidx(2))]);
                            hold on;
                            subplot(4,4,6); plot((0:temp3)/temp3, YAPercep07.hEmg.(tempName{iTrial})(temp1:temp2, emgRidx(2)), 'color', colors{iCycle}); title('High Pass Filter');
                            hold on;
                            subplot(4,4,10); plot((0:temp3)/temp3, YAPercep07.rect.(tempName{iTrial})(temp1:temp2, emgRidx(2)), 'color', colors{iCycle}); title('Rectify'); 
                            hold on;
                            subplot(4,4,14); plot((0:temp3)/temp3, YAPercep07.pEMG.(tempName{iTrial})(temp1:temp2, emgRidx(2)), 'color', colors{iCycle}); title('Processed EMG')
                            hold on; 
                            subplot(4,4,3); plot((0:temp3)/temp3, YAPercep07.analog.EMG{iTrial,1}(temp1:temp2, emgRidx(3)), 'color', colors{iCycle}); title(['Raw ' emgid(emgRidx(3))]);
                            hold on;
                            subplot(4,4,7); plot((0:temp3)/temp3, YAPercep07.hEmg.(tempName{iTrial})(temp1:temp2, emgRidx(3)), 'color', colors{iCycle}); title('High Pass Filter');
                            hold on;
                            subplot(4,4,11); plot((0:temp3)/temp3, YAPercep07.rect.(tempName{iTrial})(temp1:temp2, emgRidx(3)), 'color', colors{iCycle}); title('Rectify'); 
                            hold on;
                            subplot(4,4,15); plot((0:temp3)/temp3, YAPercep07.pEMG.(tempName{iTrial})(temp1:temp2, emgRidx(3)), 'color', colors{iCycle}); title('Processed EMG')
                            hold on; 
                            subplot(4,4,4); plot((0:temp3)/temp3, YAPercep07.analog.EMG{iTrial,1}(temp1:temp2, emgRidx(4)), 'color', colors{iCycle}); title(['Raw ' emgid(emgRidx(4))]);
                            hold on;
                            subplot(4,4,8); plot((0:temp3)/temp3, YAPercep07.hEmg.(tempName{iTrial})(temp1:temp2, emgRidx(4)), 'color', colors{iCycle}); title('High Pass Filter');
                            hold on;
                            subplot(4,4,12); plot((0:temp3)/temp3, YAPercep07.rect.(tempName{iTrial})(temp1:temp2, emgRidx(4)), 'color', colors{iCycle}); title('Rectify'); 
                            hold on;
                            subplot(4,4,16); plot((0:temp3)/temp3, YAPercep07.pEMG.(tempName{iTrial})(temp1:temp2, emgRidx(4)), 'color', colors{iCycle}); title('Processed EMG')
                            hold on;
                        elseif iEmgR == 1 && iCycle ~= 1 
                            subplot(4,4,1); plot((0:temp3)/temp3, YAPercep07.analog.EMG{iTrial,1}(temp1:temp2, emgRidx(1)), 'color', colors{iCycle}); title(['Raw ' emgid(emgRidx(1))]);
                            hold on;
                            subplot(4,4,5); plot((0:temp3)/temp3, YAPercep07.hEmg.(tempName{iTrial})(temp1:temp2, emgRidx(1)), 'color', colors{iCycle}); title('High Pass Filter');
                            hold on;
                            subplot(4,4,9); plot((0:temp3)/temp3, YAPercep07.rect.(tempName{iTrial})(temp1:temp2, emgRidx(1)), 'color', colors{iCycle}); title('Rectify'); 
                            hold on;
                            subplot(4,4,13); plot((0:temp3)/temp3, YAPercep07.pEMG.(tempName{iTrial})(temp1:temp2, emgRidx(1)), 'color', colors{iCycle}); title('Processed EMG')
                            hold on; 
                            subplot(4,4,2); plot((0:temp3)/temp3, YAPercep07.analog.EMG{iTrial,1}(temp1:temp2, emgRidx(2)), 'color', colors{iCycle}); title(['Raw ' emgid(emgRidx(2))]);
                            hold on;
                            subplot(4,4,6); plot((0:temp3)/temp3, YAPercep07.hEmg.(tempName{iTrial})(temp1:temp2, emgRidx(2)), 'color', colors{iCycle}); title('High Pass Filter');
                            hold on;
                            subplot(4,4,10); plot((0:temp3)/temp3, YAPercep07.rect.(tempName{iTrial})(temp1:temp2, emgRidx(2)), 'color', colors{iCycle}); title('Rectify'); 
                            hold on;
                            subplot(4,4,14); plot((0:temp3)/temp3, YAPercep07.pEMG.(tempName{iTrial})(temp1:temp2, emgRidx(2)), 'color', colors{iCycle}); title('Processed EMG')
                            hold on; 
                            subplot(4,4,3); plot((0:temp3)/temp3, YAPercep07.analog.EMG{iTrial,1}(temp1:temp2, emgRidx(3)), 'color', colors{iCycle}); title(['Raw ' emgid(emgRidx(3))]);
                            hold on;
                            subplot(4,4,7); plot((0:temp3)/temp3, YAPercep07.hEmg.(tempName{iTrial})(temp1:temp2, emgRidx(3)), 'color', colors{iCycle}); title('High Pass Filter');
                            hold on;
                            subplot(4,4,11); plot((0:temp3)/temp3, YAPercep07.rect.(tempName{iTrial})(temp1:temp2, emgRidx(3)), 'color', colors{iCycle}); title('Rectify'); 
                            hold on;
                            subplot(4,4,15); plot((0:temp3)/temp3, YAPercep07.pEMG.(tempName{iTrial})(temp1:temp2, emgRidx(3)), 'color', colors{iCycle}); title('Processed EMG')
                            hold on; 
                            subplot(4,4,4); plot((0:temp3)/temp3, YAPercep07.analog.EMG{iTrial,1}(temp1:temp2, emgRidx(4)), 'color', colors{iCycle}); title(['Raw ' emgid(emgRidx(4))]);
                            hold on;
                            subplot(4,4,8); plot((0:temp3)/temp3, YAPercep07.hEmg.(tempName{iTrial})(temp1:temp2, emgRidx(4)), 'color', colors{iCycle}); title('High Pass Filter');
                            hold on;
                            subplot(4,4,12); plot((0:temp3)/temp3, YAPercep07.rect.(tempName{iTrial})(temp1:temp2, emgRidx(4)), 'color', colors{iCycle}); title('Rectify'); 
                            hold on;
                            subplot(4,4,16); plot((0:temp3)/temp3, YAPercep07.pEMG.(tempName{iTrial})(temp1:temp2, emgRidx(4)), 'color', colors{iCycle}); title('Processed EMG')
                            hold on;
                        elseif iEmgR == 2 && iCycle == 1 
                            h2 = figure('Name', ['Check_EMG_2 ' subject1 ' ' leg{iLeg} ' ' namePert{iSpeeds} ' ' namePercep{iTrial} ' ' num2str(iPerts) ' ' namePerceived], 'NumberTitle', 'off', 'visible', 'off');
                            filename2 = ['Check_EMG_2' subject1 '_' leg{iLeg} '_' namePert{iSpeeds} '_' namePercep{iTrial} '_' num2str(iPerts) '_' namePerceived];
                            filenamePDF2 = strcat(filename2, '.pdf');
                            subplot(4,4,1); plot((0:temp3)/temp3, YAPercep07.analog.EMG{iTrial,1}(temp1:temp2, emgRidx(5)), 'color', colors{iCycle}); title(['Raw ' emgid(emgRidx(5))]);
                            hold on;
                            subplot(4,4,5); plot((0:temp3)/temp3, YAPercep07.hEmg.(tempName{iTrial})(temp1:temp2, emgRidx(5)), 'color', colors{iCycle}); title('High Pass Filter');
                            hold on;
                            subplot(4,4,9); plot((0:temp3)/temp3, YAPercep07.rect.(tempName{iTrial})(temp1:temp2, emgRidx(5)), 'color', colors{iCycle}); title('Rectify'); 
                            hold on;
                            subplot(4,4,13); plot((0:temp3)/temp3, YAPercep07.pEMG.(tempName{iTrial})(temp1:temp2, emgRidx(5)), 'color', colors{iCycle}); title('Processed EMG')
                            hold on; 
                            subplot(4,4,2); plot((0:temp3)/temp3, YAPercep07.analog.EMG{iTrial,1}(temp1:temp2, emgRidx(6)), 'color', colors{iCycle}); title(['Raw ' emgid(emgRidx(6))]);
                            hold on;
                            subplot(4,4,6); plot((0:temp3)/temp3, YAPercep07.hEmg.(tempName{iTrial})(temp1:temp2, emgRidx(6)), 'color', colors{iCycle}); title('High Pass Filter');
                            hold on;
                            subplot(4,4,10); plot((0:temp3)/temp3, YAPercep07.rect.(tempName{iTrial})(temp1:temp2, emgRidx(6)), 'color', colors{iCycle}); title('Rectify'); 
                            hold on;
                            subplot(4,4,14); plot((0:temp3)/temp3, YAPercep07.pEMG.(tempName{iTrial})(temp1:temp2, emgRidx(6)), 'color', colors{iCycle}); title('Processed EMG')
                            hold on; 
                            subplot(4,4,3); plot((0:temp3)/temp3, YAPercep07.analog.EMG{iTrial,1}(temp1:temp2, emgRidx(7)), 'color', colors{iCycle}); title(['Raw ' emgid(emgRidx(7))]);
                            hold on;
                            subplot(4,4,7); plot((0:temp3)/temp3, YAPercep07.hEmg.(tempName{iTrial})(temp1:temp2, emgRidx(7)), 'color', colors{iCycle}); title('High Pass Filter');
                            hold on;
                            subplot(4,4,11); plot((0:temp3)/temp3, YAPercep07.rect.(tempName{iTrial})(temp1:temp2, emgRidx(7)), 'color', colors{iCycle}); title('Rectify'); 
                            hold on;
                            subplot(4,4,15); plot((0:temp3)/temp3, YAPercep07.pEMG.(tempName{iTrial})(temp1:temp2, emgRidx(7)), 'color', colors{iCycle}); title('Processed EMG')
                            hold on; 
                            subplot(4,4,4); plot((0:temp3)/temp3, YAPercep07.analog.EMG{iTrial,1}(temp1:temp2, emgRidx(8)), 'color', colors{iCycle}); title(['Raw ' emgid(emgRidx(8))]);
                            hold on;
                            subplot(4,4,8); plot((0:temp3)/temp3, YAPercep07.hEmg.(tempName{iTrial})(temp1:temp2, emgRidx(8)), 'color', colors{iCycle}); title('High Pass Filter');
                            hold on;
                            subplot(4,4,12); plot((0:temp3)/temp3, YAPercep07.rect.(tempName{iTrial})(temp1:temp2, emgRidx(8)), 'color', colors{iCycle}); title('Rectify'); 
                            hold on;
                            subplot(4,4,16); plot((0:temp3)/temp3, YAPercep07.pEMG.(tempName{iTrial})(temp1:temp2, emgRidx(8)), 'color', colors{iCycle}); title('Processed EMG')
                            hold on;
                        elseif iEmgR == 2 && iCycle ~= 1
                            subplot(4,4,1); plot((0:temp3)/temp3, YAPercep07.analog.EMG{iTrial,1}(temp1:temp2, emgRidx(5)), 'color', colors{iCycle}); title(['Raw ' emgid(emgRidx(5))]);
                            hold on;
                            subplot(4,4,5); plot((0:temp3)/temp3, YAPercep07.hEmg.(tempName{iTrial})(temp1:temp2, emgRidx(5)), 'color', colors{iCycle}); title('High Pass Filter');
                            hold on;
                            subplot(4,4,9); plot((0:temp3)/temp3, YAPercep07.rect.(tempName{iTrial})(temp1:temp2, emgRidx(5)), 'color', colors{iCycle}); title('Rectify'); 
                            hold on;
                            subplot(4,4,13); plot((0:temp3)/temp3, YAPercep07.pEMG.(tempName{iTrial})(temp1:temp2, emgRidx(5)), 'color', colors{iCycle}); title('Processed EMG')
                            hold on; 
                            subplot(4,4,2); plot((0:temp3)/temp3, YAPercep07.analog.EMG{iTrial,1}(temp1:temp2, emgRidx(6)), 'color', colors{iCycle}); title(['Raw ' emgid(emgRidx(6))]);
                            hold on;
                            subplot(4,4,6); plot((0:temp3)/temp3, YAPercep07.hEmg.(tempName{iTrial})(temp1:temp2, emgRidx(6)), 'color', colors{iCycle}); title('High Pass Filter');
                            hold on;
                            subplot(4,4,10); plot((0:temp3)/temp3, YAPercep07.rect.(tempName{iTrial})(temp1:temp2, emgRidx(6)), 'color', colors{iCycle}); title('Rectify'); 
                            hold on;
                            subplot(4,4,14); plot((0:temp3)/temp3, YAPercep07.pEMG.(tempName{iTrial})(temp1:temp2, emgRidx(6)), 'color', colors{iCycle}); title('Processed EMG')
                            hold on; 
                            subplot(4,4,3); plot((0:temp3)/temp3, YAPercep07.analog.EMG{iTrial,1}(temp1:temp2, emgRidx(7)), 'color', colors{iCycle}); title(['Raw ' emgid(emgRidx(7))]);
                            hold on;
                            subplot(4,4,7); plot((0:temp3)/temp3, YAPercep07.hEmg.(tempName{iTrial})(temp1:temp2, emgRidx(7)), 'color', colors{iCycle}); title('High Pass Filter');
                            hold on;
                            subplot(4,4,11); plot((0:temp3)/temp3, YAPercep07.rect.(tempName{iTrial})(temp1:temp2, emgRidx(7)), 'color', colors{iCycle}); title('Rectify'); 
                            hold on;
                            subplot(4,4,15); plot((0:temp3)/temp3, YAPercep07.pEMG.(tempName{iTrial})(temp1:temp2, emgRidx(7)), 'color', colors{iCycle}); title('Processed EMG')
                            hold on; 
                            subplot(4,4,4); plot((0:temp3)/temp3, YAPercep07.analog.EMG{iTrial,1}(temp1:temp2, emgRidx(8)), 'color', colors{iCycle}); title(['Raw ' emgid(emgRidx(8))]);
                            hold on;
                            subplot(4,4,8); plot((0:temp3)/temp3, YAPercep07.hEmg.(tempName{iTrial})(temp1:temp2, emgRidx(8)), 'color', colors{iCycle}); title('High Pass Filter');
                            hold on;
                            subplot(4,4,12); plot((0:temp3)/temp3, YAPercep07.rect.(tempName{iTrial})(temp1:temp2, emgRidx(8)), 'color', colors{iCycle}); title('Rectify'); 
                            hold on;
                            subplot(4,4,16); plot((0:temp3)/temp3, YAPercep07.pEMG.(tempName{iTrial})(temp1:temp2, emgRidx(8)), 'color', colors{iCycle}); title('Processed EMG')
                            hold on;
                        elseif iEmgR == 3 && iCycle == 1
                            h3 = figure('Name', ['Check_EMG_3 ' subject1 ' ' leg{iLeg} ' ' namePert{iSpeeds} ' ' namePercep{iTrial} ' ' num2str(iPerts) ' ' namePerceived], 'NumberTitle', 'off', 'visible', 'off');
                            filename3 = ['Check_EMG_3' subject1 '_' leg{iLeg} '_' namePert{iSpeeds} '_' namePercep{iTrial} '_' num2str(iPerts) '_' namePerceived];
                            filenamePDF3 = strcat(filename3, '.pdf');
                            subplot(4,4,1); plot((0:temp3)/temp3, YAPercep07.analog.EMG{iTrial,1}(temp1:temp2, emgRidx(9)), 'color', colors{iCycle}); title(['Raw ' emgid(emgRidx(9))]);
                            hold on;
                            subplot(4,4,5); plot((0:temp3)/temp3, YAPercep07.hEmg.(tempName{iTrial})(temp1:temp2, emgRidx(9)), 'color', colors{iCycle}); title('High Pass Filter');
                            hold on;
                            subplot(4,4,9); plot((0:temp3)/temp3, YAPercep07.rect.(tempName{iTrial})(temp1:temp2, emgRidx(9)), 'color', colors{iCycle}); title('Rectify'); 
                            hold on;
                            subplot(4,4,13); plot((0:temp3)/temp3, YAPercep07.pEMG.(tempName{iTrial})(temp1:temp2, emgRidx(9)), 'color', colors{iCycle}); title('Processed EMG')
                            hold on; 
                            subplot(4,4,2); plot((0:temp3)/temp3, YAPercep07.analog.EMG{iTrial,1}(temp1:temp2, emgRidx(10)), 'color', colors{iCycle}); title(['Raw ' emgid(emgRidx(10))]);
                            hold on;
                            subplot(4,4,6); plot((0:temp3)/temp3, YAPercep07.hEmg.(tempName{iTrial})(temp1:temp2, emgRidx(10)), 'color', colors{iCycle}); title('High Pass Filter');
                            hold on;
                            subplot(4,4,10); plot((0:temp3)/temp3, YAPercep07.rect.(tempName{iTrial})(temp1:temp2, emgRidx(10)), 'color', colors{iCycle}); title('Rectify'); 
                            hold on;
                            subplot(4,4,14); plot((0:temp3)/temp3, YAPercep07.pEMG.(tempName{iTrial})(temp1:temp2, emgRidx(10)), 'color', colors{iCycle}); title('Processed EMG')
                            hold on; 
                            subplot(4,4,3); plot((0:temp3)/temp3, YAPercep07.analog.EMG{iTrial,1}(temp1:temp2, emgRidx(11)), 'color', colors{iCycle}); title(['Raw ' emgid(emgRidx(11))]);
                            hold on;
                            subplot(4,4,7); plot((0:temp3)/temp3, YAPercep07.hEmg.(tempName{iTrial})(temp1:temp2, emgRidx(11)), 'color', colors{iCycle}); title('High Pass Filter');
                            hold on;
                            subplot(4,4,11); plot((0:temp3)/temp3, YAPercep07.rect.(tempName{iTrial})(temp1:temp2, emgRidx(11)), 'color', colors{iCycle}); title('Rectify'); 
                            hold on;
                            subplot(4,4,15); plot((0:temp3)/temp3, YAPercep07.pEMG.(tempName{iTrial})(temp1:temp2, emgRidx(11)), 'color', colors{iCycle}); title('Processed EMG')
                            hold on; 
                            subplot(4,4,4); plot((0:temp3)/temp3, YAPercep07.analog.EMG{iTrial,1}(temp1:temp2, emgRidx(12)), 'color', colors{iCycle}); title(['Raw ' emgid(emgRidx(12))]);
                            hold on;
                            subplot(4,4,8); plot((0:temp3)/temp3, YAPercep07.hEmg.(tempName{iTrial})(temp1:temp2, emgRidx(12)), 'color', colors{iCycle}); title('High Pass Filter');
                            hold on;
                            subplot(4,4,12); plot((0:temp3)/temp3, YAPercep07.rect.(tempName{iTrial})(temp1:temp2, emgRidx(12)), 'color', colors{iCycle}); title('Rectify'); 
                            hold on;
                            subplot(4,4,16); plot((0:temp3)/temp3, YAPercep07.pEMG.(tempName{iTrial})(temp1:temp2, emgRidx(12)), 'color', colors{iCycle}); title('Processed EMG')
                            hold on;
                        else 
                            subplot(4,4,1); plot((0:temp3)/temp3, YAPercep07.analog.EMG{iTrial,1}(temp1:temp2, emgRidx(9)), 'color', colors{iCycle}); title(['Raw ' emgid(emgRidx(9))]);
                            hold on;
                            subplot(4,4,5); plot((0:temp3)/temp3, YAPercep07.hEmg.(tempName{iTrial})(temp1:temp2, emgRidx(9)), 'color', colors{iCycle}); title('High Pass Filter');
                            hold on;
                            subplot(4,4,9); plot((0:temp3)/temp3, YAPercep07.rect.(tempName{iTrial})(temp1:temp2, emgRidx(9)), 'color', colors{iCycle}); title('Rectify'); 
                            hold on;
                            subplot(4,4,13); plot((0:temp3)/temp3, YAPercep07.pEMG.(tempName{iTrial})(temp1:temp2, emgRidx(9)), 'color', colors{iCycle}); title('Processed EMG')
                            hold on; 
                            subplot(4,4,2); plot((0:temp3)/temp3, YAPercep07.analog.EMG{iTrial,1}(temp1:temp2, emgRidx(10)), 'color', colors{iCycle}); title(['Raw ' emgid(emgRidx(10))]);
                            hold on;
                            subplot(4,4,6); plot((0:temp3)/temp3, YAPercep07.hEmg.(tempName{iTrial})(temp1:temp2, emgRidx(10)), 'color', colors{iCycle}); title('High Pass Filter');
                            hold on;
                            subplot(4,4,10); plot((0:temp3)/temp3, YAPercep07.rect.(tempName{iTrial})(temp1:temp2, emgRidx(10)), 'color', colors{iCycle}); title('Rectify'); 
                            hold on;
                            subplot(4,4,14); plot((0:temp3)/temp3, YAPercep07.pEMG.(tempName{iTrial})(temp1:temp2, emgRidx(10)), 'color', colors{iCycle}); title('Processed EMG')
                            hold on; 
                            subplot(4,4,3); plot((0:temp3)/temp3, YAPercep07.analog.EMG{iTrial,1}(temp1:temp2, emgRidx(11)), 'color', colors{iCycle}); title(['Raw ' emgid(emgRidx(11))]);
                            hold on;
                            subplot(4,4,7); plot((0:temp3)/temp3, YAPercep07.hEmg.(tempName{iTrial})(temp1:temp2, emgRidx(11)), 'color', colors{iCycle}); title('High Pass Filter');
                            hold on;
                            subplot(4,4,11); plot((0:temp3)/temp3, YAPercep07.rect.(tempName{iTrial})(temp1:temp2, emgRidx(11)), 'color', colors{iCycle}); title('Rectify'); 
                            hold on;
                            subplot(4,4,15); plot((0:temp3)/temp3, YAPercep07.pEMG.(tempName{iTrial})(temp1:temp2, emgRidx(11)), 'color', colors{iCycle}); title('Processed EMG')
                            hold on; 
                            subplot(4,4,4); plot((0:temp3)/temp3, YAPercep07.analog.EMG{iTrial,1}(temp1:temp2, emgRidx(12)), 'color', colors{iCycle}); title(['Raw ' emgid(emgRidx(12))]);
                            hold on;
                            subplot(4,4,8); plot((0:temp3)/temp3, YAPercep07.hEmg.(tempName{iTrial})(temp1:temp2, emgRidx(12)), 'color', colors{iCycle}); title('High Pass Filter');
                            hold on;
                            subplot(4,4,12); plot((0:temp3)/temp3, YAPercep07.rect.(tempName{iTrial})(temp1:temp2, emgRidx(12)), 'color', colors{iCycle}); title('Rectify'); 
                            hold on;
                            subplot(4,4,16); plot((0:temp3)/temp3, YAPercep07.pEMG.(tempName{iTrial})(temp1:temp2, emgRidx(12)), 'color', colors{iCycle}); title('Processed EMG')
                            hold on;
                        end                    
                    end
                    clear temp1 temp2 temp 3 perceived namePerceived
                end
                if iEmgR == 1
                    set(h, 'visible', 'on');
                    saveas(h, filename);
                    print(filenamePDF, '-dpdf', '-bestfit');
                    close(h)
                    % This figure has plots for TA, LGAS, VLAT, RFEM
                elseif iEmgR == 2
                    set(h2, 'visible', 'on');
                    saveas(h2, filename2);
                    print(filenamePDF2, '-dpdf', '-bestfit');
                    close(h2)
                    % This figure has plots for BFLH, ADD, TFL, GMED
                else 
                    set(h3, 'visible', 'on');
                    saveas(h3, filename3);
                    print(filenamePDF3, '-dpdf', '-bestfit');
                    close(h3)
                    % This figure has plots for SOL, PERO, MGAS, GMAX
                end
            end

        end
    end
end



