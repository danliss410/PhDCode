function [pEmgStruct,npEmgStruct]  =  proc_EMG_Perception(strSubject, domLeg)
%[pEmgStruct,npEmgStruct]  =  proc_EMG_Perception(strSubject)
% This function will create a processed EMG structure and a normalized
% processed EMG structure. 


% Inputs: 
% strSubject - string of the subject number (e.g. '10')
% Outputs: 
% pEmgStruct - structure that has all muscles that are processed by a high
% pass filter, demeaned, rectified, and low passed filtered by a 4th order
% buttersworth. The structure has subsections that is the emg data for each
% trial. Each of these are the size of the data collection in 1000 hz by 32
% emg possibilities. There will only be 12 channels that contain useful EMG
% data dependent on the subjects leg. 
% 
% npEmgStruct - structure that has all muscles normalized to the maximum
% value across all trials for each muscle. The structure maintains the the
% trails and is collected at 1000 hz from the experiment. 
% 

%% Create subject name to load the necessary files for the subject 

subject1 = ['YAPercep' strSubject];
%% Loading the tables for the subject 
% This section will load muscleTable, analogTable, gaitEventsTable,
% IKTable, pertTable, pertCycleStruc and videoTable(This will not be used)

load(['G:\Shared drives\NeuroMobLab\Projects\Perception\Processed Data\Dan\Matlab Analysis\' subject1 '\Data Tables\SepTables_' subject1 '.mat'])




%% Setting up the filters for EMG processing 

emgid = {'EMG_TA-R';'EMG_LGAS-R';'EMG_VLAT-R';'EMG_RFEM-R';'EMG_BFLH-R';'EMG_ADD-R';'EMG_TFL-R';'EMG_GMED-R';'EMG_TA-L';'EMG_LGAS-L';'EMG_VLAT-L';'EMG_RFEM-L';'EMG_BFLH-L';'EMG_ADD-L';'EMG_TFL-L';'EMG_GMED-L';'EMG_SOL-R';'EMG_PERO-R';'EMG_MGAS-R';'EMG_GMAX-R';'EMG_SOL-L';'EMG_PERO-L';'EMG_MGAS-L';'EMG_GMAX-L';'25';'26';'27';'28';'29';'30';'31';'32'};

SampleRate = 1000;    
nyquist_frequency = SampleRate/2;
% Create filters
% High pass filter at 35 Hz
[filt_high_B,filt_high_A] = butter(4,35/nyquist_frequency,'high');
% Low pass filter at 10 Hz
[filt_low_B,filt_low_A] = butter(4,10/nyquist_frequency,'low');

%% EMG processing 
tempName = analogTable.Trial;

for iTable = 1:size(analogTable,1)
    EMG = analogTable.EMG{iTable,1};
    % Filter EMG signals
    % High pass filter 
    emg = filtfilt(filt_high_B, filt_high_A,EMG);
    % Demean and rectify
    try
        emg_mean = repmat(mean(emg(1:SampleRate,:),1),size(emg,1),1);
    catch ME
        keyboard
    end
    emg = abs(emg-emg_mean);
    % Low pass filter 
    emg = filtfilt(filt_low_B, filt_low_A,emg);
    
    %Placing EMG into a structure 
    pEMG.(tempName{iTable}) = emg;
    clear emg EMG emg_mean
end
%Putting labels in the EMG structure
pEMG.('emgID') = emgid;

%% Finding the max EMG signal for all muscles across all trials and normalizing the processed EMG
% This loop will grab all the max EMG values for all muscles across the
% trial types
% for iTable = 1:size(analogTable,1)
%     tEmax(:,iTable) = max(pEMG.(tempName{iTable}),[], 1);
% end
% 
% % Find the max EMG signal value across all trial types from the temporary
% % value created 
% tEmg.max = max(tEmax, [], 2);
% 
% % Create conversion matrix for normalized EMG 
% normalized_mat = diag(1./tEmg.max);
% 
% % Create normalized EMG matix 
% for iTable = 1:size(analogTable,1)
%     npEmgStruct.(tempName{iTable}) = pEMG.(tempName{iTable})*normalized_mat;
% end
% 
% % Putting labels in the normalized emg structure
% npEmgStruct.('emgID') = emgid;


%% 2nd Normalization method of normalizing to the averaged max EMG per gait cycle seen in self selected treadmill walking trails 
% This will allow us to see if there is a positive or negative trend shown
% in emg signals across the various walking perturbation perception trials
% Find the amount of treadmill trials 
A = contains(gaitEventsTable.Trial, 'Treadmill');
treadCount = sum(A);
tempName2 = gaitEventsTable.Trial(A);

% Calculating the max EMG for each gait cycle of all treadmill trials 
for iTread = 1:treadCount % How many treadmill trials the subject has 
    % Getting the Right leg gait cycles for the treadmill trials 
    treadGC.R = gaitEventsTable.("Gait_Events_Right")(A);
    % Getting the Left leg gait cycles for the treadmill trials 
    treadGC.L = gaitEventsTable.("Gait_Events_Left")(A);
    % Find the max EMG for each gait cycle on the right leg 
    for iGC = 1:size(treadGC.R{iTread},1)
        sHS = treadGC.R{iTread}(iGC,1)*10; %Starting HS of GC multiplied by 10 to put into analog signal collection at 1000 HZ 
        fHS = treadGC.R{iTread}(iGC,5)*10; %Finishing HS of GC 
        tEmax.R{iTread}(iGC, :) = max(pEMG.(tempName{iTread})(sHS:fHS, :), [], 1); %Getting the max EMG for each GC across all muscles 
    end
    
    % Find the max EMG for each gait cycle on the left leg 
    for iGCL = 1:size(treadGC.L{iTread},1)
        sHSL = treadGC.L{iTread}(iGCL,1)*10; %Starting HS of GC multiplied by 10 to put into analog signal collection at 1000 Hz 
        fHSL = treadGC.L{iTread}(iGCL,1)*10; %Finishing HS of GC
        tEmax.L{iTread}(iGCL, :) = max(pEMG.(tempName{iTread})(sHSL:fHSL,:), [], 1); %Getting the max EMG for each left GC across all muscles 
    end 
end 

t2Emax.R = [];
t2Emax.L = [];
% Rearrange the matrix so that all the max values for each GC of the
% treadmill trials are in 1 long matrix 
for iTread = 1:treadCount
    t2Emax.R = [t2Emax.R; tEmax.R{iTread}];
    t2Emax.L = [t2Emax.L; tEmax.L{iTread}];
end

% Take the average across all gait cycles 
aEmax.R = mean(t2Emax.R, 1);
aEmax.L = mean(t2Emax.L, 1);
    

domLeg = cell2mat(domLeg);
% Create conversion matrix for normalized EMG 
if domLeg == 'R'
    normalized_mat = diag(1./aEmax.R);
else
    normalized_mat = diag(1./aEmax.L);
end

% Create normalized EMG matix 
for iTable = 1:size(analogTable,1)
    npEmgStruct.(tempName{iTable}) = pEMG.(tempName{iTable})*normalized_mat;
end
    

%% Saving the emg structure

% Creating the output structure
pEmgStruct = pEMG; 

% Setting the location to save the emg structure for each subject 
if ispc
    tabLoc = ['G:\Shared drives\NeuroMobLab\Projects\Perception\Processed Data\Dan\Matlab Analysis\' subject1 filesep 'Data Tables' filesep];
elseif ismac
    tabLoc = [''];
else
    tabLoc = input('Please enter the location where the tables should be saved.' ,'s');
end

% Saving the processed and normalized emg structure
save([tabLoc 'pEmgStruct_' subject1], 'pEmgStruct', 'npEmgStruct', '-v7.3');




disp(['EMG structure saved for ' subject1]);
end

