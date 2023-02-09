% Test Script of calculation for final chapter 
% Subject ID 
subID = '03';
% trial number % This will go into a loop lower after test
trialNum = '02';
domLeg = 'R';

% Loading the log file for the subject 
logLoc = 'G:\Shared drives\NeuroMobLab\Experimental Data\Log Files\Pilot Experiments\USPerception2022\';
perts = readtable([logLoc 'YAUSPercep' subID '_US.txt']);

% Loading the perturbed gait cycle table 
load(['G:\Shared drives\Perception Project\Ultrasound\OpenSim\YAUSPercep' subID...
    '\Tables\gaitEventsTable_YAUSPercep' subID '.mat']);



% Loading a rawData struct to test % Will need to loop through this section
% for the data 
load(['G:\Shared drives\Perception Project\Ultrasound\OpenSim\YAUSPercep' ...
    subID '\MatFiles\YNPercep' trialNum '.mat']);


% Loading the Muscle Data from OpenSim file 
if subID == '03'
mtLengthData = Osim.readSTO(['G:\Shared drives\Perception Project\Ultrasound\OpenSim\YAUSPercep' subID...
    '\IKResults and Analysis Output\YNPercep' trialNum ...
    '_markers_rotatedwrtOrigin_ik_MuscleAnalysis_Length.sto']);
else

mtLengthData = Osim.readSTO(['G:\Shared drives\Perception Project\Ultrasound\OpenSim\YAUSPercep' subID...
    '\IKResults and Analysis Output\YNPercep' trialNum ...
    '_markers_rotated_wrtOrigin_ik_MuscleAnalysis_Length.sto']);
end

% Loading the fixed x,y data from the csv 
usData = readmatrix(['G:\Shared drives\Perception Project\videos\'...
    'YAUSPercep' subID '_YNPercep' trialNum '.csv']);


% Finding the 5V peaks in the analog data that correspond with the
% individual frames of the ultrasound data collection 
temp1=diff(rawData.analog.other);
temp2 = find(temp1>4.5); % finding differences greater than 4.5 V 
temp2 = temp2(2:end); 
if length(temp2) > length(usData)
    frameDiff = length(temp2) - length(usData);
    temp2 = temp2(1+frameDiff:end);
end
usTime = atime(temp2); % Getting the corresponding analog time values for the frames 

clear temp1 temp2

% Upsampling the OpenSim calculated full musculotendon length for the mgas 
if domLeg == 'R'
    mgasLength = interp1(mtime,mtLengthData.med_gas_r,atime,'spline');

    RHEEval = squeeze(rawData.video.markers(:,strmatch('RHEE',rawData.video.markersid),:));
    RHEEval = interp1(mtime,RHEEval,atime);
else
    mgasLength = interp1(mtime, mtLengthData.med_gas_l, atime, 'spline');

    LHEEval = squeeze(rawData.video.marker(:, strmatch('LHEE', rawData.video.markersid),:));
    LHEEval = interp1(mtime, LHEEval, atime);
end

% grab all four points of the holder
Ultrasound1 = squeeze(rawData.video.markers(:,strmatch('Ultrasound1',rawData.video.markersid),:)); % top
Ultrasound1 = interp1(mtime,Ultrasound1,atime,'spline');
Ultrasound2 = squeeze(rawData.video.markers(:,strmatch('Ultrasound2',rawData.video.markersid),:)); % middle
Ultrasound2 = interp1(mtime,Ultrasound2,atime,'spline');
Ultrasound3 = squeeze(rawData.video.markers(:,strmatch('Ultrasound3',rawData.video.markersid),:)); % bottom
Ultrasound3 = interp1(mtime,Ultrasound3,atime,'spline');
Ultrasound4 = squeeze(rawData.video.markers(:,strmatch('Ultrasound4',rawData.video.markersid),:)); % bottom
Ultrasound4 = interp1(mtime,Ultrasound4,atime,'spline');


for usInd=1:length(usTime)
    
    aInd = find(atime==usTime(usInd));
   
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%% Define local coordinate system of the ultrasound holder and create  %%%
    %%% rotation matrix                                                     %%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % (1) grab the three points of the holder that will define the
    % coordinate system
    if strcmp(subID, '01') || strcmp(subID, '05')
        A = Ultrasound3(aInd,:)';
        B = Ultrasound1(aInd,:)';
        C = Ultrasound4(aInd,:)';
    elseif strcmp(subID, '02') || strcmp(subID, '04')
        A = Ultrasound3(aInd,:)';
        B = Ultrasound4(aInd,:)';
        C = Ultrasound2(aInd,:)';
    elseif strcmp(subID, '03') || strcmp(subID, '11')
        A = Ultrasound1(aInd,:)';
        B = Ultrasound4(aInd,:)';
        C = Ultrasound3(aInd,:)';
    elseif strcmp(subID, '09')
        A = Ultrasound1(aInd,:)';
        B = Ultrasound3(aInd,:)';
        C = Ultrasound2(aInd,:)';
    elseif strcmp(subID, '10')
        A = Ultrasound3(aInd,:)';
        B = Ultrasound2(aInd,:)';
        C = Ultrasound4(aInd,:)';
    else
        A = Ultrasound1(aInd,:)';
        B = Ultrasound4(aInd,:)';
        C = Ultrasound2(aInd,:)';
    end
    
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