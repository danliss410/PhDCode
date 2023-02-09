%% Temp Script to Calculate WBAM
% Treadmill data
temp = importdata('G:\Shared drives\NeuroMobLab\Projects\Perception\Processed Data\Dan\WBAM\WBAM_Test.xlsx');
% 
% temp = importdata('G:\Shared drives\NeuroMobLab\Projects\Perception\Processed Data\Dan\WBAM\WBAM_Perturbations2.xls');
load('G:\Shared drives\NeuroMobLab\Projects\Perception\Processed Data\Dan\Matlab Analysis\YAPercep15\Data Tables\SepTables_YAPercep15.mat');
%% Start grabbing the different segments needed for WBAM 
% All units from opensim are SI units 
% Inertia is kg/m2
% Angular Vel is deg/s

m = temp.data.MassAndInertia(:,1); %Order of masses 
% Torso, Pelvis, Femur_r, Tibia_r, Talus_r, Calcn_r, Toes_r, Femur_l,
% Tibia_l, Talus_l, Calcn_l, Toes_l
tempI = zeros(3,3,12);
% Creating the Inertia Matrix
for iSeg = 1:size(m,1)
    tempI(1,1,iSeg) = temp.data.MassAndInertia(iSeg, 2);
    tempI(2,2,iSeg) = temp.data.MassAndInertia(iSeg, 3);
    tempI(3,3,iSeg) = temp.data.MassAndInertia(iSeg, 4);
end

%Grabbing the whole body CoM position and velocity data for the trial
CM_pos = temp.data.Positions(:,74:76);
CM_vel = temp.data.Velocities(:,74:76);

% Creating empty matrices to fill for each segment CoM position, velocity,
% and angular velocity 
CMs_pos = zeros(length(temp.data.Positions(:,1)), 3, size(m,1));
CMs_vel = zeros(length(temp.data.Velocities(:,1)), 3, size(m,1));
ang_vel = zeros(length(temp.data.Velocities(:,1)), 3, size(m,1));
% Loop through the length of segments and place the data for the empty
% matrices made above
idxPV = {(68:70); (2:4); (8:10); (14:16); (20:22); (26:28); (32:34);...
    (38:40); (44:46); (50:52); (56:58); (62:64);};
idxAV = {(71:73); (5:7); (11:13); (17:19); (23:25); (29:31); (35:37);...
    (41:43); (47:49); (53:55); (59:61); (65:67)};
% Placing each segment as a vector in the preallocated matrices for the
% correct segment for CoM position, velocity, and angular velocity
for iSeg = 1:size(m,1)
    CMs_pos(:,:,iSeg) = temp.data.Positions(:,idxPV{iSeg});
    CMs_vel(:,:,iSeg) = temp.data.Velocities(:,idxPV{iSeg});
    ang_vel(:,:,iSeg) = temp.data.Velocities(:,idxAV{iSeg});
end
% Converting ang_vel from degrees per second to radians per second 

%% Calculate the values for each segment and section of whole body angular momentum 

%% This is doing a temporary calculation for the torso 
% rcm_t = CMs_pos(:,:,1); 
% v_t = CMs_vel(:,:,1);
% w_t = ang_vel(:,:,1);
% int_t = tempI(:,:,1);
% m_t = m(1);
% 
% pos = rcm_t- CM_pos;
% vel = v_t - CM_vel;
% 
% 
% m_vel = m_t *vel; 
% 
% for i = 1:length(CM_pos)
%     cp(i,:) = cross(pos(i,:), m_vel(i,:)); 
%     inert(i,:) = int_t * w_t(i,:)';
%     inert2 = inert;
%     WBAM(i,:) = cp(i,:) + inert2(i,:);
% end

%% This is to do the calculation for each segment 
%rcm = zeros(length(temp.data.Positions(:,1)), 3, size(m,1));
%vel = zeros(length(temp.data.Positions(:,1)), 3, size(m,1));
rcm = CMs_pos - CM_pos;
vcm = CMs_vel - CM_vel;
m_vcm = nan(length(temp.data.Velocities(:,1)), 3, size(m,1));
iw = zeros(length(temp.data.Positions(:,1)), 3, size(m,1));
inert = zeros(length(temp.data.Positions(:,1)), 3, size(m,1));
for iSegs = 1:size(m,1)
    m_vcm(:,:,iSegs) = m(iSegs) * vcm(:,:,iSegs);
    for iTrial = 1:size(CM_pos,1)
        cp(iTrial, :, iSegs) = cross(rcm(iTrial, :,iSegs), m_vcm(iTrial, :,iSegs));
        inert(iTrial, :, iSegs) = tempI(:,:,iSegs) * (ang_vel(iTrial, :, iSegs).* (pi/180))';
        WBAMs(iTrial, :, iSegs) = cp(iTrial,:, iSegs) + inert(iTrial, :, iSegs); 
    end
end

WBAM = sum(WBAMs, 3); 
nWBAM = WBAM./(63.9*1.762*1.2);

%% Plotting summed WBAM over entire trial 
figure; 
subplot(3,1,1); plot(WBAM(:,1)); xlabel('Frames'); ylabel('L_x');
subplot(3,1,2); plot(WBAM(:,2)); xlabel('Frames'); ylabel('L_y');
subplot(3,1,3); plot(WBAM(:,3)); xlabel('Frames'); ylabel('L_z');

%% Plotting WBAM per GC GCs = [15, 24, 48, 74, 81, 89, 96, 103, 142, 149, 158];
pertS = {'-0.1'; '-0.2'; '-0.15'; '-0.15'; '-0.2'; '0'; '-0.2'; '0'; '-0.3'; '-0.02'; '-0.02'};
for iGC = 1:size(gaitEventsTable.("Gait Events Right"){4,1},1)
    figure;
    bHS = gaitEventsTable.("Gait Events Right"){4,1}(iGC,1);
    eHS = gaitEventsTable.("Gait Events Right"){4,1}(iGC,5);
    gc = eHS-bHS; 
    
    subplot(3,1,1); plot((0:gc)/gc, nWBAM(bHS:eHS, 1)); 
    xlabel('% of Gait Cycle'); ylabel('L_x');
    title(['Right Leg ' pertS(iGC)])
    ylim([-0.6 0.6]);
    hold on;
    
    subplot(3,1,2); plot((0:gc)/gc, nWBAM(bHS:eHS, 2));
    xlabel('% of Gait Cycle'); ylabel('L_y');
    ylim([-0.6 0.6]);
    hold on; 
    
    subplot(3,1,3); plot((0:gc)/gc, nWBAM(bHS:eHS, 3));
    xlabel('% of Gait Cycle'); ylabel('L_z');
    ylim([-0.6 0.6]);
    hold on;
    clear bHS eHS gc
end
    
    
%% Plotting for the treadmill 

figure;
for iGC = 1:size(gaitEventsTable.("Gait Events Right"){5,1},1)
    
    bHS = gaitEventsTable.("Gait Events Right"){5,1}(iGC,1);
    eHS = gaitEventsTable.("Gait Events Right"){5,1}(iGC,5);
    gc = eHS-bHS; 
    
    subplot(3,1,1); plot((0:gc)/gc, WBAM(bHS:eHS, 1)); 
    xlabel('% of Gait Cycle'); ylabel('L_x');
    title(['Treadmill walking 1.2 m/s'])
%     ylim([-0.6 0.6]);
    hold on;
    
    subplot(3,1,2); plot((0:gc)/gc, WBAM(bHS:eHS, 2));
    xlabel('% of Gait Cycle'); ylabel('L_y');
%     ylim([-0.6 0.6]);
    hold on; 
    
    subplot(3,1,3); plot((0:gc)/gc, WBAM(bHS:eHS, 3));
    xlabel('% of Gait Cycle'); ylabel('L_z');
%     ylim([-0.6 0.6]);
    hold on;
    clear bHS eHS gc
end

%% Plotting CoM position and Velocity treadmill walking 
figure;
for iGC = 1:size(gaitEventsTable.("Gait Events Right"){5,1},1)
    
    bHS = gaitEventsTable.("Gait Events Right"){5,1}(iGC,1);
    eHS = gaitEventsTable.("Gait Events Right"){5,1}(iGC,5);
    gc = eHS-bHS; 
    
    subplot(3,1,1); plot((0:gc)/gc, CM_pos(bHS:eHS, 1)); 
    xlabel('% of Gait Cycle'); ylabel('Meters');
    title(['CoM Position Treadmill walking 1.2 m/s'])
    ylim([0.5 0.65]);
    hold on;
    
    subplot(3,1,2); plot((0:gc)/gc, CM_pos(bHS:eHS, 2));
    xlabel('% of Gait Cycle'); ylabel('Meters');
    ylim([0.95 1]);
    hold on; 
    
    subplot(3,1,3); plot((0:gc)/gc, CM_pos(bHS:eHS, 3));
    xlabel('% of Gait Cycle'); ylabel('Meters');
    ylim([0.9 1.2]);
    hold on;
    clear bHS eHS gc
end
    
figure;
for iGC = 1:size(gaitEventsTable.("Gait Events Right"){5,1},1)
    
    bHS = gaitEventsTable.("Gait Events Right"){5,1}(iGC,1);
    eHS = gaitEventsTable.("Gait Events Right"){5,1}(iGC,5);
    gc = eHS-bHS; 
    
    subplot(3,1,1); plot((0:gc)/gc, CM_vel(bHS:eHS, 1)); 
    xlabel('% of Gait Cycle'); ylabel('M/s');
    title(['CoM Velocity Treadmill walking 1.2 m/s'])
    ylim([-0.6 0.6]);
    hold on;
    
    subplot(3,1,2); plot((0:gc)/gc, CM_vel(bHS:eHS, 2));
    xlabel('% of Gait Cycle'); ylabel('M/s');
    ylim([-0.6 0.6]);
    hold on; 
    
    subplot(3,1,3); plot((0:gc)/gc, CM_vel(bHS:eHS, 3));
    xlabel('% of Gait Cycle'); ylabel('M/s');
    ylim([-0.6 0.6]);
    hold on;
    clear bHS eHS gc
end
%% Plotting pre perturbation steps and post perturbations steps 
figure; 
GCs = (10:1:20);
colors = {'#00876c'; '#4f9971'; '#7bab79'; '#a3bd86'; '#c9ce98'; '#000000' ; '#e8c48b'; '#e5a76f'; '#e2885b'; '#dd6551'; '#d43d51'}; % Setting the colors to be chosen for each cycle plotted
for iGC = 1:size(GCs,2)%size(gaitEventsTable.("Gait Events Right"){4,1},1)
    bHS = gaitEventsTable.("Gait Events Right"){4,1}(GCs(iGC),1);
    eHS = gaitEventsTable.("Gait Events Right"){4,1}(GCs(iGC),5);
    gc = eHS-bHS; 
    
    subplot(3,1,1); plot((0:gc)/gc, nWBAM(bHS:eHS, 1), 'color', colors{iGC}); 
    xlabel('% of Gait Cycle'); ylabel('L_x');
    title(['Right Leg ' pertS(1)])
    ylim([-0.6 0.6]);
    hold on;
    
    subplot(3,1,2); plot((0:gc)/gc, nWBAM(bHS:eHS, 2), 'color', colors{iGC});
    xlabel('% of Gait Cycle'); ylabel('L_y');
    ylim([-0.6 0.6]);
    hold on; 
    
    subplot(3,1,3); plot((0:gc)/gc, nWBAM(bHS:eHS, 3), 'color', colors{iGC});
    xlabel('% of Gait Cycle'); ylabel('L_z');
    ylim([-0.6 0.6]);
    hold on;
    clear bHS eHS gc
end
    

%% Plotting nWBAM for perturbation steps 
GC2s = [15, 24, 48, 74, 81, 89, 96, 103, 142, 149, 158];
pertS = {'-0.1'; '-0.2'; '-0.15'; '-0.15'; '-0.2'; '0'; '-0.2'; '0'; '-0.3'; '-0.02'; '-0.02'};
for iGC2s = 1:size(GC2s,2)

    figure; 
    bGC = GC2s(iGC2s)-5;
    eGC = GC2s(iGC2s)+5;
    GCs = (bGC:1:eGC);
    colors = {'#00876c'; '#4f9971'; '#7bab79'; '#a3bd86'; '#c9ce98'; '#000000' ; '#e8c48b'; '#e5a76f'; '#e2885b'; '#dd6551'; '#d43d51'}; % Setting the colors to be chosen for each cycle plotted
    for iGC = 1:size(GCs,2)%size(gaitEventsTable.("Gait Events Right"){4,1},1)
        bHS = gaitEventsTable.("Gait Events Right"){4,1}(GCs(iGC),1);
        eHS = gaitEventsTable.("Gait Events Right"){4,1}(GCs(iGC),5);
        gc = eHS-bHS; 

        subplot(3,1,1); plot((0:gc)/gc, WBAM(bHS:eHS, 1), 'color', colors{iGC}); 
        xlabel('% of Gait Cycle'); ylabel('L_x');
        title(['Right Leg ' pertS(iGC2s)])
%         ylim([-0.6 0.6]);
        hold on;

        subplot(3,1,2); plot((0:gc)/gc, WBAM(bHS:eHS, 2), 'color', colors{iGC});
        xlabel('% of Gait Cycle'); ylabel('L_y');
%         ylim([-0.6 0.6]);
        hold on; 

        subplot(3,1,3); plot((0:gc)/gc, WBAM(bHS:eHS, 3), 'color', colors{iGC});
        xlabel('% of Gait Cycle'); ylabel('L_z');
%         ylim([-0.6 0.6]);
        hold on;
        clear bHS eHS gc
    end
end

%% Plotting CoM position and Velocity for Perturbations 
% tLHM_AP = videoTable.("Marker_Data"){iTrial,1}(temp1:temp4,22,1); % Left Heel Marker for AP 
% tLHM_ML = videoTable.("Marker_Data"){iTrial,1}(temp1:temp4,22,2); % Left Heel Marker for ML
% tRHM_AP = videoTable.("Marker_Data"){iTrial,1}(temp1:temp4,30,1); % Right Heel Marker for AP 
% tRHM_ML = videoTable.("Marker_Data"){iTrial,1}(temp1:temp4,30,2); % Right Heel Marker for ML 
figure;
for iGC = 1:size(gaitEventsTable.("Gait Events Right"){4,1},1)
    
    bHS = gaitEventsTable.("Gait Events Right"){4,1}(iGC,1);
    eHS = gaitEventsTable.("Gait Events Right"){4,1}(iGC,5);
    tRHM_AP = videoTable.("Marker Data"){4,1}(bHS:eHS,30,1); % Right Heel Marker for AP 
    tRHM_ML = videoTable.("Marker Data"){4,1}(bHS:eHS,30,2); % Right Heel Marker for ML
    gc = eHS-bHS; 
    
    subplot(3,1,1); plot((0:gc)/gc, CM_pos(bHS:eHS, 1)-tRHM_AP); 
    xlabel('% of Gait Cycle'); ylabel('Meters');
    title(['CoM Position Treadmill walking 1.2 m/s'])
%     ylim([0.5 0.65]);
    hold on;
    
    subplot(3,1,2); plot((0:gc)/gc, CM_pos(bHS:eHS, 2)-tRHM_ML);
    xlabel('% of Gait Cycle'); ylabel('Meters');
%     ylim([0.95 1]);
    hold on; 
    
    subplot(3,1,3); plot((0:gc)/gc, CM_pos(bHS:eHS, 3));
    xlabel('% of Gait Cycle'); ylabel('Meters');
%     ylim([0.9 1.2]);
    hold on;
    clear bHS eHS gc
end
    
figure;
for iGC = 1:size(gaitEventsTable.("Gait Events Right"){5,1},1)
    
    bHS = gaitEventsTable.("Gait Events Right"){5,1}(iGC,1);
    eHS = gaitEventsTable.("Gait Events Right"){5,1}(iGC,5);
    gc = eHS-bHS; 
    
    subplot(3,1,1); plot((0:gc)/gc, CM_vel(bHS:eHS, 1)); 
    xlabel('% of Gait Cycle'); ylabel('M/s');
    title(['CoM Velocity Treadmill walking 1.2 m/s'])
    ylim([-0.6 0.6]);
    hold on;
    
    subplot(3,1,2); plot((0:gc)/gc, CM_vel(bHS:eHS, 2));
    xlabel('% of Gait Cycle'); ylabel('M/s');
    ylim([-0.6 0.6]);
    hold on; 
    
    subplot(3,1,3); plot((0:gc)/gc, CM_vel(bHS:eHS, 3));
    xlabel('% of Gait Cycle'); ylabel('M/s');
    ylim([-0.6 0.6]);
    hold on;
    clear bHS eHS gc
end

%% MoS Calculations 

% X-CoM = pos + vel/ sqrt(g/l)
% l is leg length 
% g is gravity 
% MoS = | umax - (xCoM)|
% umax should be the toe marker in AP 
% Leg length 
l = 0.970; % leg length in m
g = 9.8; % m/s2 for gravity 
umaxAP_R = videoTable.("Marker Data"){4,1}(:,31,1) - videoTable.("Marker Data"){4,1}(:,30,1);
umaxAP_L = videoTable.("Marker Data"){4,1}(:,23,1) - videoTable.("Marker Data"){4,1}(:,22,1);

umaxML_R = videoTable.("Marker Data"){4,1}(:,31,2) - videoTable.("Marker Data"){4,1}(:,30,2);
umaxML_L = videoTable.("Marker Data"){4,1}(:,23,2) - videoTable.("Marker Data"){4,1}(:,22,2);

umaxML = umaxML_R - umaxML_L;
% umaxML = videoTable.("Marker Data"){4,1}(:,31,2)-videoTable.("Marker Data"){4,1}(:,23,2);

bAP = abs(umaxAP_R./1000 - (CM_pos(:,1) + (CM_vel(:,1)/sqrt(g/l))));
bML = abs(umaxML./1000 -(CM_pos(:,2) + (CM_vel(:,2)/sqrt(g/l))));

GC2s = [15, 24, 48, 74, 81, 89, 96, 103, 142, 149, 158];
pertS = {'-0.1'; '-0.2'; '-0.15'; '-0.15'; '-0.2'; '0'; '-0.2'; '0'; '-0.3'; '-0.02'; '-0.02'};
for iGC2s = 1:size(GC2s,2)

    figure; 
    bGC = GC2s(iGC2s)-5;
    eGC = GC2s(iGC2s)+5;
    GCs = (bGC:1:eGC);
    colors = {'#00876c'; '#4f9971'; '#7bab79'; '#a3bd86'; '#c9ce98'; '#000000' ; '#e8c48b'; '#e5a76f'; '#e2885b'; '#dd6551'; '#d43d51'}; % Setting the colors to be chosen for each cycle plotted
    
    for iGC = 1:size(GCs,2)
    
        bHS = gaitEventsTable.("Gait Events Right"){4,1}(GCs(iGC),1);
        eHS = gaitEventsTable.("Gait Events Right"){4,1}(GCs(iGC),5);
        gc = eHS-bHS; 

        subplot(2,1,1); plot((0:gc)/gc, bAP(bHS:eHS), 'color', colors{iGC}); 
        xlabel('% of Gait Cycle'); ylabel('MoS_x');
        title(['Right Leg ' pertS(iGC2s)])
    %     ylim([-0.6 0.6]);
        hold on;

        subplot(2,1,2); plot((0:gc)/gc, bML(bHS:eHS), 'color', colors{iGC});
        xlabel('% of Gait Cycle'); ylabel('MoS_y');
    %     ylim([-0.6 0.6]);
        hold on; 

        clear bHS eHS gc
    end
end