% close all 
clear
home

subID = '09';
trialNum = '05';
USFrames = 1349; 

% Loading the Vicon Data for the trial
load(['G:\Shared drives\Perception Project\Ultrasound\OpenSim\YAUSPercep' subID...
    '\MatFiles\YNPercep' trialNum '.mat']);

USIndex = [36,37,38,39]-4;
% Loading the OpenSim muscle length data 
muscleLen = Osim.readSTO(['G:\Shared drives\Perception Project\Ultrasound\OpenSim\YAUSPercep' subID...
    '\IKResults and Analysis Output\YNPercep' trialNum ...
    '_markers_rotated_wrtOrigin_ik_MuscleAnalysis_Length.sto']);

% Loading the fixed x,y data from the csv 
fixedData = readmatrix(['G:\Shared drives\Perception Project\videos\'...
    'YAUSPercep' subID '_YNPercep' trialNum '.csv']);




% Labeling the coordinate system for the rotation 
tm1 = squeeze(rawData.video.markers(:,USIndex(1),:));
tm2 = squeeze(rawData.video.markers(:,USIndex(3),:));
tm3 = squeeze(rawData.video.markers(:,USIndex(2),:));

% Upsampling the marker data and OpenSim data 
m1(:,1) = interp(tm1(:,1), 10); % Upsampling the x components 
m1(:,2) = interp(tm1(:,2), 10); % Upsampling the y components 
m1(:,3) = interp(tm1(:,3), 10); % Upsampling the z components 

m2(:,1) = interp(tm2(:,1), 10); % Upsampling the x components 
m2(:,2) = interp(tm2(:,2), 10); % Upsampling the y components 
m2(:,3) = interp(tm2(:,3), 10); % Upsampling the z components 

m3(:,1) = interp(tm3(:,1), 10); % Upsampling the x components 
m3(:,2) = interp(tm3(:,2), 10); % Upsampling the y components 
m3(:,3) = interp(tm3(:,3), 10); % Upsampling the z components 

% Extracting the MG Length from the OpenSim table 
tmg = muscleLen.med_gas_r; 

mgLen = interp(tmg, 10);

% Getting US Frames in Vicon Frames 
[pks, locs] = findpeaks(rawData.analog.other, 'MinPeakHeight',4.9);
stIdx = size(locs,2) - size(fixedData,1) + 1; 

% US frames in Vicon analog time 
usF = locs(stIdx:end); 
usTime = atime(usF);

% Converting pixels to mm for the US data 
USData(:,1) = (fixedData(:,2) - 574) .* 40/804; % 40 mm per 804 pixels % 574 is the rotation to the midpoint of the US video 
USData(:,2) = (fixedData(:,3) - 45) .* 40/804; % 45 pixels is the y axis down to the video 


% Grabbing the Right heel marker data 
tRHM = squeeze(rawData.video.markers(:,30,:));
% Upsampling the data to match the rest of the results
RHM(:,1) = interp(tRHM(:,1), 10);
RHM(:,2) = interp(tRHM(:,2), 10);
RHM(:,3) = interp(tRHM(:,3), 10);


%m2 is the marker on the bottom (this is our origin)
%m1 is the top one
%m3 is the middle marker
% a is local position of center of probe w.r.t marker 2
a=[95.2, 3.6, -36.5];

for usIdx = 1:length(usTime)
    % Finding the index where 
    aInd = find(atime==usTime(usIdx));

    %l is the cos between x local and x global
    l=(m1(aInd,1)-m3(aInd,1))/37;   
    %m is the cos between y local and y global
    m=(m2(aInd,2)-m1(aInd,2))/90.2;
    %n is the cos between z local and z global
    tempM = (m1(aInd,:)-m3(aInd,:)); 
    tempM2 = (m2(aInd,:)-m1(aInd,:));
    
    % Taking the cross product of the 2 axises  
    tempZ = cross(tempM, tempM2);
    % Getting the magnitude 
%     lZ = sqrt(tempZ(1).^2 + tempZ(2).^2 + tempZ(3).^2);
    lZ = norm(tempZ);
    % Calculating the z inverse cosine 
    z = tempZ/lZ; 
    % Grabbing the z component of the rotation matrix 
    n = z(3);
    % Putting the rotation matrix together 
    T=[l; m; n];
    % u is position of mtj in you video
    % up direction of the video is positive x in local coordinate
    % left of your video is positive y in local coordinate
    %the third component of u is always 0

    % MTJ Image coordiantes 
    u=[USData(usIdx,1),USData(usIdx,2),0];

    %%% Converting MTJ image coordinates to the local coordinate frames in
    %%% mm
    mtj_l= a+u;
    %%% Rotating the MTJ local data to put it in global coordinates 
    Tmtj_g= cross(T,mtj_l)+m2(aInd,:);
    
    % Saving the overall 3D matrix of MTJ location in global coordinates 
    MTJ_MG(:,usIdx) = Tmtj_g; 


    
end


% Calculating the Tendon length 
for i = 1:size(MTJ_MG,2)
    aInd = find(atime==usTime(i)); % Finds the index in atime equal to the USFrame
    diff2(i) = norm(MTJ_MG(:,i) - RHM(aInd,:)'); % Calculating AT length between the Right heel marker and the MTJ position in global frames
    
end

% Converting the length to m from mm 
calcATLen = diff2'./1000; 

% Calculating the muscle fiber length
for i = 1:size(MTJ_MG,2)
    aInd = find(atime==usTime(i)); % Finds the index in atime equal to the USFrame
    calcMGLen(i) = mgLen(aInd) - calcATLen(i); % Calculating the muscle fiber length between the overall muscle length and the AT length calculated 
end


% Creating plots for the overall muscle length, the MG length, and the AT
% length with xlines at right heel strikes 
figure
hold on
plot(atime,mgLen*1000)
plot(usTime,calcATLen*1000)
plot(usTime,calcMGLen*1000)
for i=1:length(rawData.video.GaitEvents.RHStime)
    xline(rawData.video.GaitEvents.RHStime(i))
end
title('Dan & Mo Rotation Method')
ylabel('length (mm)')
xlabel('time (s)')
legend('MT','Tendon','Muscle')
