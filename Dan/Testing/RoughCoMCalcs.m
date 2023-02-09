%% Original file Created by ZMM Feb 2020
% Edited by DJL April 2020

% Need to add in the log file so I can tell which perturbation levels are
% occuring 


%% This section loads in all the data and formats it for use
clc 
clear 

% Enter Subject Numbver 
subject = inputdlg('Please enter the Subject number: ');

% SSWS of the subject 

SSWS = str2double(cell2mat(inputdlg('Please enter the self selected walking speed for the subject: ')));

% Input the number of divisions the trial was split into to aid processing
% in vicon.
numFile = str2double(cell2mat(inputdlg('Please enter the of sections for the trial: ')));

nameTrial = {'One'; 'Two'; 'Three'; 'Four'; 'Five'; 'Six'; 'Seven'; 'Eight'; 'Nine'; 'Ten'};
for iFile = 1:numFile
    % Loading the Vicon Processed Matlab file that has Marker, EMG, and
    % Forceplate data
        [file, path] = uigetfile('*mat', 'Pick the .MAT Trial file');
        load([path,file])
        trial.(nameTrial{iFile}) = rawData;
        clearvars -except trial nameTrial iFile numFile SSWS subject
end

%Import the perception log 
fileLocation                                = 'G:\Shared drives\NeuroMobLab\Experimental Data\Log Files\Pilot Experiments\PerceptionStudy\';
subjectYesNo                                = cell2mat(['YAPercep' subject '_YesNo']);
data1                                       = readtable([fileLocation subjectYesNo]);
Percep                                      = data1(:,[1,2,3,6,9]);

% CoM data calculated in OpenSim based on Marker data collected in Vicon
for iFile = 1:numFile
    
% Picking the file of position data from BodyKinematics analysis in
% OpenSim
        [file, path] = uigetfile('*sto', 'Pick the position .STO Trial file');
        Pos = importdata(strcat(path,file));
        position.(nameTrial{iFile}).posTime = Pos.data(:,1);
        position.(nameTrial{iFile}).CoMX = Pos.data(:,74);
        position.(nameTrial{iFile}).CoMY = Pos.data(:,75);
        position.(nameTrial{iFile}).CoMZ = Pos.data(:,76);
%  Picking the file of velocity data from BodyKinematics analysis in
%  OpenSim
        [file,path] = uigetfile('*sto', 'Pick the velocity .STO Trial file');
        Vel = importdata(strcat(path,file));
        velocity.(nameTrial{iFile}).RCalcX = Vel.data(:,26);
        velocity.(nameTrial{iFile}).RCalcY = Vel.data(:,27);
        velocity.(nameTrial{iFile}).RCalcZ = Vel.data(:,28);
        velocity.(nameTrial{iFile}).smoothR = smooth((-Vel.data(:,28)-SSWS),20); % Subtracting the SSWS so we can easily tell when the perturbation occurs from the walking data for the Right foot

        velocity.(nameTrial{iFile}).LCalcX = Vel.data(:,56);
        velocity.(nameTrial{iFile}).LCalcY = Vel.data(:,57);
        velocity.(nameTrial{iFile}).LCalcZ = Vel.data(:,58);
        velocity.(nameTrial{iFile}).smoothL = smooth((-Vel.data(:,58) - SSWS), 20); % Subtracting the SSWS so we can easily tell when the pertubation occurs on the left foot.
        clearvars -except trial nameTrial iFile numFile position velocity SSWS subject Percep
end

%%

% Find the perturbaton signal & its timing sent to Vicon during the
% experiment. Also, finding the GaitEvents timing on each trial.
for iFile = 1:numFile
    
%     Find all the electric potential peaks in the trail 
        tempPeaks = find(trial.(nameTrial{iFile}).analog.other > 1.5);
        
        figure; plot(trial.(nameTrial{iFile}).analog.other) 
        
%       Finding the time for all the electric potential spikes sent during
%       the perturbation trial
        peaktime = trial.(nameTrial{iFile}).analog.time(tempPeaks);
        
        peaktime2 = round(peaktime,2);
        
        
        if iFile > 1
            peaktime3.(nameTrial{iFile}) = unique(peaktime2 - (50* iFile));
            Pert.(nameTrial{iFile}).number = Pert.(nameTrial{iFile-1}).number+1:1:Pert.number.(nameTrial{iFile-1})+1+length(unique(round(peaktime3.(nameTrial{iFile}))));
            Pert.(nameTrial{iFile}).speed = Percep.('dV')(Pert.(nameTrial{iFile}).number);
            Pert.(nameTrial{iFile}).leg = Percep.('LegIn')(Pert.(nameTrial{iFile}).number);
        else
            peaktime3.(nameTrial{iFile})  = unique(peaktime2);
            Pert.(nameTrial{iFile}).number = 1:1:length(unique(round(peaktime3.(nameTrial{iFile}))));
            Pert.(nameTrial{iFile}).speed = Percep.('dV')(Pert.(nameTrial{iFile}).number);
            Pert.(nameTrial{iFile}).leg = Percep.('LegIn')(Pert.(nameTrial{iFile}).number);
        end
        
%       Find the Gait events for each trial with correct frames
%       Gaitevents struct has the following order LHS, RTO, RHS, LTO
        if iFile > 1 
            RHS = trial.(nameTrial{iFile}).video.GaitEvents.RHSframe - 5000*iFile ;
            RTO = trial.(nameTrial{iFile}).video.GaitEvents.RTOframe - 5000*iFile ;
            LTO = trial.(nameTrial{iFile}).video.GaitEvents.LTOframe - 5000*iFile ;
            LHS = trial.(nameTrial{iFile}).video.GaitEvents.LHSframe - 5000*iFile ;
        else 
            RHS = trial.(nameTrial{iFile}).video.GaitEvents.RHSframe;
            RTO = trial.(nameTrial{iFile}).video.GaitEvents.RTOframe;
            LTO = trial.(nameTrial{iFile}).video.GaitEvents.LTOframe;
            LHS = trial.(nameTrial{iFile}).video.GaitEvents.LHSframe;
        end
        GaitEvents.(nameTrial{iFile}) = nan(length(LHS),4);

        GaitEvents.(nameTrial{iFile})(1,1) = LHS(1);    
        i=1;
        while i<length(LHS)
            try
                % find and store first LTO > most recent RHS
                temp = find(RTO>GaitEvents.(nameTrial{iFile})(i,1));
                GaitEvents.(nameTrial{iFile})(i,2) = RTO(temp(1));
                % find and store first LHS > most recent LTO
                temp = find(RHS>GaitEvents.(nameTrial{iFile})(i,2));
                GaitEvents.(nameTrial{iFile})(i,3) = RHS(temp(1));
                % find and store first RTO > most recent LHS
                temp = find(LTO>GaitEvents.(nameTrial{iFile})(i,3));
                GaitEvents.(nameTrial{iFile})(i,4) = LTO(temp(1));
                % find and store first RHS > most recent RHS
                temp = find(LHS>GaitEvents.(nameTrial{iFile})(i,4));
                i=i+1;
                if ~isempty(temp)
                    GaitEvents.(nameTrial{iFile})(i,1) = LHS(temp(1));
                else
                    break
                end
            catch
                break
            end
        end
        GaitEvents.(nameTrial{iFile})(:,5) = nan(size(GaitEvents.(nameTrial{iFile}),1),1);
        GaitEvents.(nameTrial{iFile})(:,6) = nan(size(GaitEvents.(nameTrial{iFile}),1),1);
        for i = 1:size(GaitEvents.(nameTrial{iFile}),1)-1
            GaitEvents.(nameTrial{iFile})(i,5) = GaitEvents.(nameTrial{iFile})(i+1,1);
            GaitEvents.(nameTrial{iFile})(i,6) = GaitEvents.(nameTrial{iFile})(i+1,3);
        end
end

%% Find the perturbation timing and magnitude based on OpenSim data
for iFile = 1:numFile
    [tempPeaksL, tempLocsL] = findpeaks(velocity.(nameTrial{iFile}).smoothL, 'MinPeakDistance', 60); % Finding all peak velocities for the left foot in One Section of the perception trial (i.e. Percep01_1)
    [tempPeaksR, tempLocsR] = findpeaks(velocity.(nameTrial{iFile}).smoothR, 'MinPeakDistance', 60); % Finding all peak velocities for the right foot in One section of the perception trial
    
    tempPertPeaksL = find(tempPeaksL < -0.015 & tempPeaksL > -0.6); % Find peak velocities for the left foot in our Perturbation range
    tempPertPeaksR = find(tempPeaksR < -0.015 & tempPeaksR > -0.6); % Find peak velocities for the right foot in our Perturbation range
    
    framePertPeaksL = tempLocsL(tempPertPeaksL); % Frame indicies for the peak velocities for the left foot
    framePertPeaksR = tempLocsR(tempPertPeaksR); % Frame indicies for the velocity changes for the right foot
    
    for iSignal = 1:size(peaktime3.(nameTrial{iFile}),2) % This loop finds the first peak velocity for Left and Right legs after the EP signal for the perturbation
        tempL{iSignal} = find(framePertPeaksL > peaktime3.(nameTrial{iFile})(iSignal)*100, 1, 'first');
        tempR{iSignal} = find(framePertPeaksR > peaktime3.(nameTrial{iFile})(iSignal)*100, 1, 'first');
    end
    tempCL = cellfun('isempty', tempL); % Find if there are any empty cells for the left side 
    tempCR = cellfun('isempty', tempR); % Find if there are any empty cells for the right side
    
    tempL = tempL(tempCL ~= 1); % Adjust the indicies depending on if there are any empty cells 
    tempR = tempR(tempCR ~= 1); % Adjust the indicies depending on if there are any empty cells 
    
    framePertPeaksL = framePertPeaksL(cell2mat(tempL)); % Finds the OpenSim Frame Indicies for perturbation onset for the left foot
    framePertPeaksR = framePertPeaksR(cell2mat(tempR)); % Finds the OpenSim Frame INdicies for perturbation onset for the right foot
    
    framePertPeaksL = unique(framePertPeaksL); % Finds the unique values of the perturbation onset for the left foot
    framePertPeaksR = unique(framePertPeaksR); % Finds the unique values of the perturbation onset for the right foot
    
    % This statement checks the size of the two previous variables versus
    % the number of perturbations on each leg for this section of the
    % perception trial. If it is larger than the value it identifies the
    % actual values in the matrix that correspond with each leg and each
    % perturbation
    if size(framePertPeaksL,1) > sum(count(Pert.(nameTrial{iFile}).leg, 'L'))
        leftPertLog = strcmp('L', Pert.(nameTrial{iFile}).leg) == 1;
        framePertPeaksL = framePertPeaksL(leftPertLog);
    elseif size(framePertPeaksR,1) > sum(count(Pert.(nameTrial{iFile}).leg, 'R'))
        rightPertLog = strcmp('R', Pert.(nameTrial{iFile}).leg) == 1;
        framePertPeaksR = framePertPeaksR(rightPertLog);
    else
    end

    
    % Finds the Gait Event and Vicon Frame that the LHS happens on the
    % perturbation onset
    for iPerts = 1:size(framePertPeaksL,1)
        LHSPertNumL(iPerts) = find(GaitEvents.(nameTrial{iFile})(:,5) < framePertPeaksL(iPerts),1, 'last');
        LHSPertFrameL(iPerts) = GaitEvents.(nameTrial{iFile})(LHSPertNumL(iPerts),5);
    end
    
    % Finds the Gait Event and Vicon Frame that the LHS happens on the
    % perturbation onset
    for iPerts = 1:size(framePertPeaksR, 1)
        RHSPertNumR(iPerts) = find(GaitEvents.(nameTrial{iFile})(:,2) < framePertPeaksR(iPerts),1, 'last');
        RHSPertFrameR(iPerts) = GaitEvents.(nameTrial{iFile})(RHSPertNumR(iPerts),2);
    end
    
    % Puts the Vicon information and OpenSim data into a the Pert structure
    % for each leg. The following information is passed for both legs:
%   - HS Gait Event number that the perturbation occurs on 
%   - HS Vicon Frame number that the perturbation occurs on 
%   - OpenSim Frame index that the perturbation occurs on 
%   - Perturbation Speed (foot speed calculated from OpenSim)
    Pert.(nameTrial{iFile}).LHSNumL = LHSPertNumL;
    Pert.(nameTrial{iFile}).LHSViconFrameL = LHSPertFrameL;
    Pert.(nameTrial{iFile}).OpenSimFrameL = framePertPeaksL;
    Pert.(nameTrial{iFile}).LeftMagnitude = velocity.(nameTrial{iFile}).smoothL(framePertPeaksL);
    
    Pert.(nameTrial{iFile}).RHSNumR = RHSPertNumR;
    Pert.(nameTrial{iFile}).RHSViconFrameR = RHSPertFrameR;
    Pert.(nameTrial{iFile}).OpenSimFrameR = framePertPeaksR;
    Pert.(nameTrial{iFile}).RightMagnitude = velocity.(nameTrial{iFile}).smoothR(framePertPeaksR);
    
    clearvars -except  GaitEvents nameTrial numFile peaktime3 position SSWS trial velocity subject Pert Percep
end
    
    

% %%  Find the timing of when the perturbations occur for both legs
% 
% % Find the timing for the frames of when the perturbation occurs. 
% for iFile = 1:numFile
%     
%     for iTime = 1:length(peaktime3.(nameTrial{iFile}))
%         timings1{iTime} = find(peaktime3.(nameTrial{iFile})(iTime) == round(trial.(nameTrial{iFile}).video.time,2)); % find the timings for the marker data to calculate step length and width and other spatiotemporal parameters 
%     end
%     for i = 1:length(timings1)-1
%         if timings1{i} == timings1{i+1}-1
%             timings1{i+1} = timings1{i};
%         end
%     end
%     timings.(nameTrial{iFile}) = unique(cell2mat(timings1));  % Find only the unique times for the peaks 
% end
% 
% % This section finds the GaitEvents that happen at perturbation onset
% for iFile = 1:numFile
%     G1=[];
%     G2=[];
%     G3=[];
%     G4=[];
%     for i = 1:size(peaktime3.(nameTrial{iFile}),2) 
%         G1(i)= find(GaitEvents.(nameTrial{iFile})(:,5)/100 > peaktime3.(nameTrial{iFile})(i),1,'first');
%     end 
%     A = GaitEvents.(nameTrial{iFile})(G1,1);
%     for i = 1:size(peaktime3.(nameTrial{iFile}),2) 
%         G2(i)= find(GaitEvents.(nameTrial{iFile})(:,2) > A(i),1,'first');
%     end
%     B = GaitEvents.(nameTrial{iFile})(G2,2);
%     for i = 1:size(peaktime3.(nameTrial{iFile}),2)
%         G3(i)= find (GaitEvents.(nameTrial{iFile})(:,3) > B(i),1,'first');
%     end 
%     C = GaitEvents.(nameTrial{iFile})(G3,3);
%     for i = 1:size(peaktime3.(nameTrial{iFile}),2) 
%         G4(i)= find (GaitEvents.(nameTrial{iFile})(:,4) > C(i),1,'first');
%     end 
%     D = GaitEvents.(nameTrial{iFile})(G4,4); 
%     G.(nameTrial{iFile}) =[A' ; B' ; C' ; D']';
%     sz.(nameTrial{iFile}) = size(G.(nameTrial{iFile})); 
% 
%     for i = 1:length(G.(nameTrial{iFile})) % Find timing for perturbation onset
%         if ~isnan(G.(nameTrial{iFile})(i,1))  
%             T.(nameTrial{iFile}).LHS{i} = find(round(position.(nameTrial{iFile}).posTime,2) == G.(nameTrial{iFile})(i,1)/100);
%             T.(nameTrial{iFile}).RTO{i} = find(round(position.(nameTrial{iFile}).posTime,2) == G.(nameTrial{iFile})(i,2)/100);
%             T.(nameTrial{iFile}).RHS{i} = find(round(position.(nameTrial{iFile}).posTime,2) == G.(nameTrial{iFile})(i,3)/100);
%             T.(nameTrial{iFile}).LTO{i} = find(round(position.(nameTrial{iFile}).posTime,2) == G.(nameTrial{iFile})(i,4)/100);
%         else
%         end
%     end 
% end
% 
% clearvars -except GaitEvents nameTrial numFile peaktime3 position SSWS trial velocity subject Pert Percep G T timings 

%% Calculating the spatiotemporal parameters for each perturbation 
% 
% fileLocation                                = 'G:\Shared drives\NeuroMobLab\Experimental Data\Log Files\Pilot Experiments\PerceptionStudy\';
% subjectYesNo                                = ['YAPercep' subject '_YesNo'];
% data1.(subjectYesNo)                        = readtable([fileLocation subjectYesNo]);
% 
% 
% % Calculating stride length & step width for each perturbation onset
% for iFile = 1:numFile %Number of sections for each perturbation trial
%    for i = 1:length(T.(nameTrial{iFile}).LHS) % Calcualting the step length for left belt perturbations 
%        SL.(nameTrial{iFile}).LeftPert(i) = trial.(nameTrial{iFile}).video.markers(T.(nameTrial{iFile}).LHS{i}, 22, 1) - trial.(nameTrial{iFile}).video.markers(T.(nameTrial{iFile}).LHS{i}, 30, 1); % Subtracting the Heel markers from left minus right in the AP direction
%        SW.(nameTrial{iFile}).LeftPert(i) = trial.(nameTrial{iFile}).video.markers(T.(nameTrial{iFile}).LHS{i}, 21, 2) - trial.(nameTrial{iFile}).video.markers(T.(nameTrial{iFile}).LHS{i}, 29, 2); % Subtracting the ankle markers from left minus right in the ML direction
%    end
%    
%    for i = 1:length(T.(nameTrial{iFile}).RHS) % Caculating the step length and width for the right belt perturbations
%        SL.(nameTrial{iFile}).RightPert(i) = trial.(nameTrial{iFile}).video.markers(T.(nameTrial{iFile}).RHS{i}, 30, 1) - trial.(nameTrial{iFile}).video.markers(T.(nameTrial{iFile}).RHS{i}, 22, 1); % Subtracting the heel markers from right minus left in the AP direction
%        SW.(nameTrial{iFile}).RightPert(i) = trial.(nameTrial{iFile}).video.markers(T.(nameTrial{iFile}).RHS{i}, 29, 1) - trial.(nameTrial{iFile}).video.markers(T.(nameTrial{iFile}).RHS{i}, 21, 1); % Subtracting the ankle markers from right minus right in the ML direction 
%    end
% end
%     

    
    
    
    
