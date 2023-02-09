function [MTJTable] = calcMTJLength(subID, trials, domLeg)
% This function will take all 20 trials surrounding a subjects threshold
% and calculate the MTJ position in the lab GCS. The function produces one
% table that has the overall musculotendon length, and the individual
% components as well. This function calculates the MTJ position using a
% rotation matrix. 

% INPUTS: subID               - a string of the subjects unique identifier for the
%                                   Perception study.
%
%         trials              - a matrix of doubles that contains the
%                               the perception trials that are surrounding
%                               the subject's positive and negative
%                               perception threshold. 
%
%         domLeg                - a string with the subject's dominant leg                                   average leg length in mm. 
%
% OUPUT: MTJTable               - a table that contains trial names, analog time,
%                                 ultrasound time, overall musculotendon length,
%                                 medial gastroc length, and achilles tendon length. 
%                                 Timings are in seconds and lengths are in 
%                                 mm. 
%
%
% Created: 1 November 2022, DJL
% Modified: (format: date, initials, change made)
%   1 -  


%% There were some video to vicon number mismatch for 2 subjects so will be hardcoding these changes in the beginning
if strcmp(subID,'08')
    usTrials = trials - 26; % This was due to running left legged perturbations for the first 26, but these were excluded when making the video names 
    usTrials(7:end) = usTrials(7:end) + 1;
elseif strcmp(subID, '02')
    % The numbers are different than vicon due to misclicks during the
    % experimental paradigm that were not accurately written down.
    usTrials = [2	9	13	18	27	31	49	56	59	71	72	78	87	91	95	97	102	127	139	152];
end


%% This loop will go through every perception trial surrounding the subjects
% threshold and create a table with the muscletendon length for each trial


for iTrial = 1:length(trials)
    trial = trials(iTrial);
    trialNum = num2str(trial);
    if trial < 10 
        trialNum = ['0' trialNum];
    end
    % Loading a rawData struct to test % Will need to loop through this section
    % for the data 
    load(['G:\Shared drives\Perception Project\Ultrasound\OpenSim\YAUSPercep' ...
        subID '\MatFiles\YNPercep' trialNum '.mat']);
    
    
    % Loading the Muscle Data from OpenSim file 
    if subID == '03'
    mtLengthData = Osim.readSTO(['G:\Shared drives\Perception Project\Ultrasound\OpenSim\YAUSPercep' subID...
        '\IKResults and Analysis Output\YNPercep' trialNum ...
        '_markers_rotated_wrtOrigin_ik_MuscleAnalysis_Length.sto']);
    else
    
    mtLengthData = Osim.readSTO(['G:\Shared drives\Perception Project\Ultrasound\OpenSim\YAUSPercep' subID...
        '\IKResults and Analysis Output\YNPercep' trialNum ...
        '_markers_rotated_wrtOrigin_ik_MuscleAnalysis_Length.sto']);
    end
    if strcmp(subID, '02') || strcmp(subID,'08')
        ustrialNum = num2str(usTrials(iTrial));
        if usTrials(iTrial) < 10 
            ustrialNum = ['0' ustrialNum];
        end
        % Loading the fixed x,y data from the csv 
        usData = readmatrix(['G:\Shared drives\Perception Project\videos\'...
            'YAUSPercep' subID '_YNPercep' ustrialNum '.csv']);
    else
        % Loading the fixed x,y data from the csv 
        usData = readmatrix(['G:\Shared drives\Perception Project\videos\'...
            'YAUSPercep' subID '_YNPercep' trialNum '.csv']);
    end
    
    
    %% This section finds the Ultrasound Video Frames and upsamples the heel marker for the Dom leg and Ultrasound LCS points
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
    
    if domLeg == 'R'
        % Upsampling the OpenSim calculated full musculotendon length for the mgas
        mgasLength = interp1(mtime,mtLengthData.med_gas_r,atime,'spline');
        % Upsampling the heel marker data 
        RHEEval = squeeze(rawData.video.markers(:,strmatch('RHEE',rawData.video.markersid),:));
        RHEEval = interp1(mtime,RHEEval,atime);
    else
        % Upsampling the OpenSim calculated full musculotendon length for the
        % mgas
        mgasLength = interp1(mtime, mtLengthData.med_gas_l, atime, 'spline');
        % Upsampling the heel marker data
        LHEEval = squeeze(rawData.video.markers(:, strmatch('LHEE', rawData.video.markersid),:));
        LHEEval = interp1(mtime, LHEEval, atime);
    end
    
    % grab all four points of the holder
    Ultrasound1 = squeeze(rawData.video.markers(:,strmatch('Ultrasound1',rawData.video.markersid),:)); 
    Ultrasound1 = interp1(mtime,Ultrasound1,atime,'spline');
    Ultrasound2 = squeeze(rawData.video.markers(:,strmatch('Ultrasound2',rawData.video.markersid),:)); 
    Ultrasound2 = interp1(mtime,Ultrasound2,atime,'spline');
    Ultrasound3 = squeeze(rawData.video.markers(:,strmatch('Ultrasound3',rawData.video.markersid),:));
    Ultrasound3 = interp1(mtime,Ultrasound3,atime,'spline');
    Ultrasound4 = squeeze(rawData.video.markers(:,strmatch('Ultrasound4',rawData.video.markersid),:)); 
    Ultrasound4 = interp1(mtime,Ultrasound4,atime,'spline');
    
    
    
    %%
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
        if domLeg == 'R'
            tendon_length(usInd) = norm(m1-RHEEval(aInd,:)');
            muscle_length(usInd) = mgasLength(aInd)*1000 - tendon_length(usInd);
        else
            tendon_length(usInd) = norm(m1-LHEEval(aInd,:)');
            muscle_length(usInd) = mgasLength(aInd)*1000 - tendon_length(usInd);
        end
        
    end
     if iTrial == 1
        MTJTable = table({['YNPercep' trialNum]}, {atime}, {usTime}, {mgasLength*1000}, ...
        {muscle_length}, {tendon_length}, 'VariableNames', {'Trial'; 'Analog_Time_(s)';...
        'US_Time_(s)'; 'MT_len_(mm)'; 'MG_len_(mm)'; 'AT_len_(mm)'});
     else
         MTJTable.Trial(iTrial) = {['YNPercep' trialNum]};
         MTJTable.("Analog_Time_(s)")(iTrial) = {atime};
         MTJTable.("US_Time_(s)")(iTrial) = {usTime};
         MTJTable.("MT_len_(mm)")(iTrial) = {mgasLength*1000};
         MTJTable.("MG_len_(mm)")(iTrial) = {muscle_length};
         MTJTable.("AT_len_(mm)")(iTrial) = {tendon_length};
     end
     clearvars -except MTJTable subID trials domLeg iTrial ustrialNum usTrials
end


%% Save the table to the subjects folder 
% Changing the directory to save the gaitevents table in the subjects
% folder
saveLoc = ['G:\Shared drives\Perception Project\Ultrasound\OpenSim\YAUSPercep' subID '\Tables\'];
% Creating the subject1 name
subject1 = ['YAUSPercep' subID];
% Saving the gaitEvents table in the subject folder 
save([saveLoc 'MTJTable_' subject1], 'MTJTable', '-v7.3');
end