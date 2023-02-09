
% filename = '/Users/jla0024/Documents/Research/Grants/InProgress/NIH_r15/TIGRR_Review/SitToStandPertData/TreadmillPert01.csv';
filename  = 'G:\Shared drives\NeuroMobLab\Experimental Data\Vicon Matlab Processed\Pilot Experiments\WVCTSI_Perception2019\YAPercep13\Session1\Percep01_1.mat';

load(filename)


% vertGRF_right = dlmread(filename,'\t',[5 4 20114 4]);
SampleRate = 1000;

vertGRF.right = rawData.analog.plateforces(:,9);
vertGRF.left = rawData.analog.plateforces(:,3);
% Remove spikes from platform force data
num_stdev = 1; % threshold for spike detection
plate_data = proc_process_removespikes(vertGRF.right,SampleRate/50,num_stdev);

% Low-pass filter plate signals at 50 Hz 
line([6 9.3],[20 20],'color','k')
xlim([6 9.3])

newX = (1/100):(1/100):length(vertGRF_right_processed)/100;
newY = interp1(x,vertGRF_right_processed,newX);


% RHEE = dlmread(filename,'\t',[20121 89 22131 89]); % RHEE
RHEE = dlmread(filename,'\t',[20121 92 22131 92]); % RTOE

speed = 0.90; 
RHEE_velocity = proc_process_smoothderivative(RHEE,100,1);
RHEE_velocity(abs(newY)<400)=NaN;
subplot(2,1,2)
x=(1/100):(1/100):length(RHEE_velocity)/100;
plot(x,-RHEE_velocity./10)
hold on
line([6 9.3],[0.9 0.9],'color','k')
line([6 9.3],[1.3 1.3],'color','k')
xlim([6 9.3])
ylim([0 1.5])