
home 
clear 
% leg = [   ]; % Average Leg length for each subject

%% 
strSubject = '18'; 
subject1 = ['YAPercep' strSubject];
legLength = 977;
%% Loading Data tables 

load(['G:\Shared drives\NeuroMobLab\Projects\Perception\Processed Data\Dan\Full Sub Data\' subject1 '_Tables.mat']);


%% Creating position, velocity, and angular velocity matrices for all trials 

% Trial names 
trials = posSegmentsTable.Trial;
% List of segments to be called for the tables 
segments = {'Torso'; 'Pelvis'; 'r_Femur'; 'r_Tibia'; 'r_Talus'; 'r_Calc'; 'r_Toes';...
    'l_Femur'; 'l_Tibia'; 'l_Talus'; 'l_Calc'; 'l_Toes'};
% List of segments to be called for the angular velocity table 
segments2 = {'Torso_X-Y-Z'; 'Pelvis'; 'r_Femur'; 'r_Tibia'; 'r_Talus'; 'r_Calc'; 'r_Toes';...
    'l_Femur'; 'l_Tibia'; 'l_Talus'; 'l_Calc'; 'l_Toes'};
for iTrial = 1:size(trials,1)
    CM_pos.(trials{iTrial}) = posSegmentsTable.("CoM_X-Y-Z"){iTrial}; 
    CM_vel.(trials{iTrial}) = velSegmentsTable.("CoM_X-Y-Z"){iTrial};
    CM_acc.(trials{iTrial}) = accSegmentsTable.("CoM_X-Y-Z"){iTrial};
    for iSeg = 1:size(segments,1)
        CMs_pos.(trials{iTrial})(:,:,iSeg) = posSegmentsTable.(segments{iSeg}){iTrial,:};
        CMs_vel.(trials{iTrial})(:,:,iSeg) = velSegmentsTable.(segments{iSeg}){iTrial,:};
        ang_vel.(trials{iTrial})(:,:,iSeg) = angVelSegmentsTable.(segments2{iSeg}){iTrial,:} .* (pi/180);
    end
end
%% MoS Calculations 

% X-CoM = pos + vel/ sqrt(g/l)
% l is leg length 
% g is gravity 
% MoS = | umax - (xCoM)|
% umax should be the toe marker in AP 
% Leg length grab and average the values between both legs for the given
% subject (is an input) 
l = legLength/1000; % Converting leg length from mm to m
g = 9.8; % m/s2 for gravity 

% Toe marker for umax in AP 
for iTrial = 1:size(trials,1)
    % Toe marker right side values 
    umaxAP_R.(trials{iTrial}) = videoTable.("Marker_Data"){iTrial,1}(:,31,1);
    % Toe marker left side values 
    umaxAP_L.(trials{iTrial}) = videoTable.("Marker_Data"){iTrial,1}(:,23,1);
    % Ankle marker right side values 
    % These values might need to change the column chosen 
    umaxML_R.(trials{iTrial}) = videoTable.("Marker_Data"){iTrial,1}(:,29,2);
    % Ankle marker left side values 
    umaxML_L.(trials{iTrial}) = videoTable.("Marker_Data"){iTrial,1}(:,21,2);
    
    % Calculating AP MoS for Right side 
    bAP_R.(trials{iTrial}) = abs(umaxAP_R.(trials{iTrial}) ./1000 - (CM_pos.(trials{iTrial})(:,1) + (CM_vel.(trials{iTrial})(:,1)/sqrt(g/l))));
    % Calculating AP MoS for the left side
    bAP_L.(trials{iTrial}) = abs(umaxAP_L.(trials{iTrial}) ./1000 - (CM_pos.(trials{iTrial})(:,1) + (CM_vel.(trials{iTrial})(:,1)/sqrt(g/l))));
    
    % Calculating ML MoS for the Right side 
    % Might have to change the column being called can't figure out if Y
    % from open sim is ML or vertical
    bML_R.(trials{iTrial}) = abs(umaxML_R.(trials{iTrial}) ./1000 - (CM_pos.(trials{iTrial})(:,3) + (CM_vel.(trials{iTrial})(:,3)/sqrt(g/l))));
    % Calculating ML MoS for the left side 
    bML_L.(trials{iTrial}) = abs(umaxML_L.(trials{iTrial}) ./1000 - (CM_pos.(trials{iTrial})(:,3) + (CM_vel.(trials{iTrial})(:,3)/sqrt(g/l))));
end

%% Placing the new values in the table 

for iTrial = 1:size(trials,1)
    dynamicStabilityTable.APMoS_R{iTrial} = bAP_R.(trials{iTrial});
    dynamicStabilityTable.APMoS_L{iTrial} = bAP_L.(trials{iTrial});
    dynamicStabilityTable.MLMoS_R{iTrial} = bML_R.(trials{iTrial});
    dynamicStabilityTable.MLMoS_L{iTrial} = bML_L.(trials{iTrial});
end

%% Saving dynamic Stability Table 

tabLoc = ['G:\Shared drives\NeuroMobLab\Projects\Perception\Processed Data\Dan\OpenSim\YAPercep Outputs\' subject1 filesep 'Data Tables' filesep];

save([tabLoc 'dynamicStabilityTable_' subject1], 'dynamicStabilityTable', '-v7.3');

disp('Done');

