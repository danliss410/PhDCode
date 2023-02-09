% function checkIndividualEMG_April2019(Folder, trialname,
% muscle)forExtractions
% clear all
% close all
% load('D:\Research\ExperimentalData\AgingStudy\Pilots\YAPilot08\Session1\TUG14.mat')
% load('G:\My Drive\Research\AgingPilotsAnalysis\TUGAnalysis\TUGvsTUGC_forPaper\Data\matfiles\forExtractionsWithAdductors\YAPilot14\TUG20.mat')
EMG = analogTable.EMG{2,1};
emgid = {'EMG_TA-R';'EMG_LGAS-R';'EMG_VLAT-R';'EMG_RFEM-R';'EMG_BFLH-R';'EMG_ADD-R';'EMG_TFL-R';'EMG_GMED-R';'EMG_TA-L';'EMG_LGAS-L';'EMG_VLAT-L';'EMG_RFEM-L';'EMG_BFLH-L';'EMG_ADD-L';'EMG_TFL-L';'EMG_GMED-L';'EMG_SOL-R';'EMG_PERO_R';'EMG_MGAS-R';'EMG_GMAX-R';'EMG_SOL-L';'EMG_PERO_L';'EMG_MGAS-L';'EMG_GMAX-L';'25';'26';'27';'28';'29';'30';'31';'32'};
    
% Hamstring
muscle = 'BFLH-R';
muscleToPlot = strcat('EMG_', muscle)
muscleInd = find(strcmpi(emgid, muscleToPlot));
time = analogTable.("Time (s)"){2,1};
emgid(muscleInd)

SampleRate = 1000;    
nyquist_frequency = SampleRate/2;
% Create filters
% High pass filter at 35 Hz
[filt_high_B,filt_high_A] = butter(4,35/nyquist_frequency,'high');
% Low pass filter at 10 Hz
[filt_low_B,filt_low_A] = butter(4,10/nyquist_frequency,'low');

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

figure
subplot(4,2,1)
hold on
plot(time, EMG(:,muscleInd))
% xlim([0 0.64])
hold on
% xline(2.04)
% xline(1.08)
xline(31.32);
xline(32.42);
xline(58.50);
xline(59.60);
xline(79.46);
xline(80.63);
xline(302.25);
xline(303.64);
title(char(emgid(muscleInd)))

subplot(4,2,2)
hold on
plot(time', emg(:,muscleInd))
% xlim([0 0.64])
% xline(2.04)
xline(31.32);
xline(32.42);
xline(58.50);
xline(59.60);
xline(79.46);
xline(80.63);
xline(302.25);
xline(303.64);

% Quad Muscle 
muscle = 'VLAT-R';
muscleToPlot = strcat('EMG_', muscle)
muscleInd = find(strcmpi(emgid, muscleToPlot));
time = analogTable.("Time (s)"){2,1};
emgid(muscleInd)

SampleRate = 1000;    
nyquist_frequency = SampleRate/2;
% Create filters
% High pass filter at 35 Hz
[filt_high_B,filt_high_A] = butter(4,35/nyquist_frequency,'high');
% Low pass filter at 10 Hz
[filt_low_B,filt_low_A] = butter(4,10/nyquist_frequency,'low');

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

subplot(4,2,3)
hold on
plot(time, EMG(:,muscleInd))
% xlim([0 0.64])
hold on
% xline(2.04)
xline(31.32);
xline(32.42);
xline(58.50);
xline(59.60);
xline(79.46);
xline(80.63);
xline(302.25);
xline(303.64);
title(char(emgid(muscleInd)))

subplot(4,2,4)
hold on
plot(time', emg(:,muscleInd))
xline(31.32);
xline(32.42);
xline(58.50);
xline(59.60);
xline(79.46);
xline(80.63);
xline(302.25);
xline(303.64);

% Lower shank  
muscle = 'MGAS-R';
muscleToPlot = strcat('EMG_', muscle)
muscleInd = find(strcmpi(emgid, muscleToPlot));
time = analogTable.("Time (s)"){2,1};
emgid(muscleInd)

SampleRate = 1000;    
nyquist_frequency = SampleRate/2;
% Create filters
% High pass filter at 35 Hz
[filt_high_B,filt_high_A] = butter(4,35/nyquist_frequency,'high');
% Low pass filter at 10 Hz
[filt_low_B,filt_low_A] = butter(4,10/nyquist_frequency,'low');

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

subplot(4,2,5)
hold on
plot(time, EMG(:,muscleInd))
% xlim([0 0.64])
hold on
xline(31.32);
xline(32.42);
xline(58.50);
xline(59.60);
xline(79.46);
xline(80.63);
xline(302.25);
xline(303.64);
title(char(emgid(muscleInd)))

subplot(4,2,6)
hold on
plot(time', emg(:,muscleInd))
xline(31.32);
xline(32.42);
xline(58.50);
xline(59.60);
xline(79.46);
xline(80.63);
xline(302.25);
xline(303.64);


% Lower shank  
muscle = 'LGAS-R';
muscleToPlot = strcat('EMG_', muscle)
muscleInd = find(strcmpi(emgid, muscleToPlot));
time = analogTable.("Time (s)"){2,1};
emgid(muscleInd)

SampleRate = 1000;    
nyquist_frequency = SampleRate/2;
% Create filters
% High pass filter at 35 Hz
[filt_high_B,filt_high_A] = butter(4,35/nyquist_frequency,'high');
% Low pass filter at 10 Hz
[filt_low_B,filt_low_A] = butter(4,10/nyquist_frequency,'low');

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

subplot(4,2,7)
hold on
plot(time, EMG(:,muscleInd))
% xlim([0 0.64])
hold on
% xline(2.04)
xline(31.32);
xline(32.42);
xline(58.50);
xline(59.60);
xline(79.46);
xline(80.63);
xline(302.25);
xline(303.64);
title(char(emgid(muscleInd)))

subplot(4,2,8)
hold on
plot(time', emg(:,muscleInd))
xline(31.32);
xline(32.42);
xline(58.50);
xline(59.60);
xline(79.46);
xline(80.63);
xline(302.25);
xline(303.64);


%%

muscle = 'add-r';
muscleToPlot = strcat('EMG_', muscle)
muscleInd = find(strcmpi(emgid, muscleToPlot));
time = atime;
emgid(muscleInd)

SampleRate = rawData.analog.samplerate;    
nyquist_frequency = SampleRate/2;
%%% Create filters
% High pass filter at 35 Hz
[filt_high_B,filt_high_A] = butter(3,35/nyquist_frequency,'high');
% Low pass filter at 10 Hz
[filt_low_B,filt_low_A] = butter(3,10/nyquist_frequency,'low');

%%% Filter EMG signals
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

figure
subplot(4,1,1)
hold on
plot(time, EMG(:,muscleInd))
% xlim([12 20])
title(char(emgid(muscleInd)))

subplot(4,1,2)
hold on
plot(time', emg(:,muscleInd))
% xlim([12 20])

muscle = 'add-l';
muscleToPlot = strcat('EMG_', muscle)
muscleInd = find(strcmpi(emgid, muscleToPlot));
time = atime;
emgid(muscleInd)

SampleRate = rawData.analog.samplerate;    
nyquist_frequency = SampleRate/2;
%%% Create filters
% High pass filter at 35 Hz
[filt_high_B,filt_high_A] = butter(3,35/nyquist_frequency,'high');
% Low pass filter at 10 Hz
[filt_low_B,filt_low_A] = butter(3,10/nyquist_frequency,'low');

%%% Filter EMG signals
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

subplot(4,1,3)
hold on
plot(time, EMG(:,muscleInd))
title(char(emgid(muscleInd)))
% xlim([12 20])

subplot(4,1,4)
hold on
plot(time', emg(:,muscleInd))
% xlim([12 20])
