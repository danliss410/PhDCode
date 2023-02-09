clear all


subID = '04';
trialNum = '04';


% Loading the Vicon Data for the trial
load(['G:\Shared drives\Perception Project\Ultrasound\OpenSim\YAUSPercep' subID...
    '\MatFiles\YNPercep' trialNum '.mat']);

USIndex = [36,37,38,39]-4;
% Loading the OpenSim muscle length data 
mtLengthData = Osim.readSTO(['G:\Shared drives\Perception Project\Ultrasound\OpenSim\YAUSPercep' subID...
    '\IKResults and Analysis Output\YNPercep' trialNum ...
    '_markers_rotated_wrtOrigin_ik_MuscleAnalysis_Length.sto']);

% Loading the fixed x,y data from the csv 
usData = readmatrix(['G:\Shared drives\Perception Project\videos\'...
    'YAUSPercep' subID '_YNPercep' trialNum '.csv']);

% load('C:\Users\jessal\Downloads\YNPercep05.mat')

% usData = csvread('C:\Users\jessal\Downloads\YAUSPercep09_YNPercep05.csv');

temp1=diff(rawData.analog.other);
temp2 = find(temp1>4.5);
temp2 = temp2(2:end);
usTime = atime(temp2);

clear temp1 temp2

% [mtLengthData]=Osim.readSTO(['C:\Users\jessal\Downloads\YNPercep05_markers_rotated_wrtOrigin_ik_MuscleAnalysis_Length.sto']);

mgasLength = interp1(mtime,mtLengthData.med_gas_r,atime,'spline');

RHEEval = squeeze(rawData.video.markers(:,strmatch('RHEE',rawData.video.markersid),:));
RHEEval = interp1(mtime,RHEEval,atime);

% grab the three points of the holder
Ultrasound4 = squeeze(rawData.video.markers(:,strmatch('Ultrasound4',rawData.video.markersid),:)); % top
Ultrasound4 = interp1(mtime,Ultrasound4,atime,'spline');
Ultrasound2 = squeeze(rawData.video.markers(:,strmatch('Ultrasound2',rawData.video.markersid),:)); % middle
Ultrasound2 = interp1(mtime,Ultrasound2,atime,'spline');
Ultrasound3 = squeeze(rawData.video.markers(:,strmatch('Ultrasound3',rawData.video.markersid),:)); % bottom
Ultrasound3 = interp1(mtime,Ultrasound3,atime,'spline');


for usInd=1:length(usTime)
    
    aInd = find(atime==usTime(usInd));
   
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%% Define local coordinate system of the ultrasound holder and create  %%%
    %%% rotation matrix                                                     %%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % (1) grab the three points of the holder that will define the
    % coordinate system
    A = Ultrasound3(aInd,:)';
    B = Ultrasound4(aInd,:)';
    C = Ultrasound2(aInd,:)';
    
    % (2) define vectors connecting the points in the direction we want the
    % coordinate system to point
    BA = A-B;
    BC = C-B;
    
    % (3) define unit vectors for the coordinate system
    j = BA./norm(BA);
    k = cross(BC,BA)./norm(cross(BC,BA)); %negative to get a right-hand coordinate system
    i = cross(j,k)./norm(cross(j,k));
    
    % (4) create rotation matrix from unit vectors
    R=[i,j,k];
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%% Find location of MTJ in global (aka vicon) coordinate system        %%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % (1) define location of ultrasound holder (middle)
    u2 = [-95.2;-94.1;-36.5]; % with respect to local coordinate system centered at point A
    u1 = R*u2+A; % respect to global (vicon) coordinate system
    
    % (2) define location of MTJ
    uM = [0;(usData(usInd,2)-574);-(usData(usInd,3)-45)]*40/806; % pixel location from DLC results, wrt to top center of US image (u2)
    M = uM+u2; % add to location of u2 above, to get wrt to local coordinate system centered at point A
    m1 = R*M+A; % use rotation matrix to get wrt to global (vicon) coordinate system
    MTJ(:,usInd) = m1;
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%% Calculate tendon and muscle lengths                                 %%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
    
    tendon_length(usInd) = norm(m1-RHEEval(aInd,:)');
    muscle_length(usInd) = mgasLength(aInd)*1000 - tendon_length(usInd);
    
end
% Smoothing the data from the calculations to account for noise and
% upsampling 
tendon_length = smoothdata(tendon_length, 'movmean', 10 );
muscle_length = smoothdata(muscle_length, 'movmean', 10 );
mgasLength = smoothdata(mgasLength, 'movmean', 10);


figure
hold on
plot(atime,mgasLength*1000)
plot(usTime,tendon_length)
plot(usTime,muscle_length)
for i=1:length(rawData.video.GaitEvents.RHStime)
    xline(rawData.video.GaitEvents.RHStime(i))
end
title('Jessica Rotation Method')
ylabel('length (mm)')
xlabel('time (s)')
legend('MT','Tendon','Muscle')