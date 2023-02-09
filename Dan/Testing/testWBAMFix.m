%% Temp WBAM calculation 

<<<<<<< Updated upstream
strSubject = '12';
=======
strSubject = '05';
>>>>>>> Stashed changes
subject1 = ['YAPercep' strSubject];
% Loading all the tables 
load(['G:\Shared drives\NeuroMobLab\Projects\Perception\Processed Data\Dan\Full Sub Data\' subject1 '_Tables.mat']);
load(['G:\Shared drives\NeuroMobLab\Projects\Perception\Processed Data\Dan\OpenSim\YAPercep Outputs\' subject1 '\Data Tables\inertiaTensor_' subject1 '.mat']);
temp = importdata('G:\Shared drives\NeuroMobLab\Projects\Perception\Processed Data\Dan\OpenSim\YAPercep Outputs\MassAndInertia\massAndInertia.xlsx');

m = temp.data.(subject1)(:,1);

%% Test running some IK and Body analysis in here 



%% Global calculations 
clear segPos segVel CM_pos2 CM_vel2 angVel rcm2 vcm2 mvcm inert2 cp2 WBAMs2 WBAM2 gcs gcstart gcfin
<<<<<<< Updated upstream
globalPos = importdata(['G:\Shared drives\NeuroMobLab\Projects\Perception\Processed Data\Dan\OpenSim\YAPercep Outputs\' subject1 '\IKResults and Analysis Output\Treadmill02_markers_rotated_ik_BodyKinematics_pos_global.sto']);
globalVel = importdata(['G:\Shared drives\NeuroMobLab\Projects\Perception\Processed Data\Dan\OpenSim\YAPercep Outputs\' subject1 '\IKResults and Analysis Output\Treadmill02_markers_rotated_ik_BodyKinematics_vel_global.sto']);
=======
% globalPos = importdata(['G:\Shared drives\NeuroMobLab\Projects\Perception\Processed Data\Dan\OpenSim\YAPercep Outputs\' subject1 '\Scaled Model\3DGaitModel2392-scaled_BodyKinematics_pos_global.sto']);
% globalVel = importdata(['G:\Shared drives\NeuroMobLab\Projects\Perception\Processed Data\Dan\OpenSim\YAPercep Outputs\' subject1 '\Scaled Model\3DGaitModel2392-scaled_BodyKinematics_pos_global.sto']);

% globalPos1 = importdata(['G:\Shared drives\NeuroMobLab\Projects\Perception\Processed Data\Dan\OpenSim\YAPercep Outputs\' subject1 '\IKResults and Analysis Output\Percep01_1_markers_rotated_ik_BodyKinematics_pos_global.sto']);
% globalVel1 = importdata(['G:\Shared drives\NeuroMobLab\Projects\Perception\Processed Data\Dan\OpenSim\YAPercep Outputs\' subject1 '\IKResults and Analysis Output\Percep01_1_markers_rotated_ik_BodyKinematics_vel_global.sto']);


globalPos = importdata(['G:\Shared drives\NeuroMobLab\Projects\Perception\Processed Data\Dan\OpenSim\YAPercep Outputs\YAPercep05\Treadmill02_BodyKinematics_pos_global.sto']);
globalVel = importdata(['G:\Shared drives\NeuroMobLab\Projects\Perception\Processed Data\Dan\OpenSim\YAPercep Outputs\YAPercep05\Treadmill02_BodyKinematics_vel_global.sto']);



% globalPos2 = importdata(['G:\Shared drives\NeuroMobLab\Projects\Perception\Processed Data\Dan\OpenSim\YAPercep Outputs\' subject1 '\IKResults and Analysis Output\Percep01_2_markers_rotated_ik_BodyKinematics_pos_global.sto']);
% globalVel2 = importdata(['G:\Shared drives\NeuroMobLab\Projects\Perception\Processed Data\Dan\OpenSim\YAPercep Outputs\' subject1 '\IKResults and Analysis Output\Percep01_2_markers_rotated_ik_BodyKinematics_vel_global.sto']);


% globalPos3 = importdata(['G:\Shared drives\NeuroMobLab\Projects\Perception\Processed Data\Dan\OpenSim\YAPercep Outputs\' subject1 '\IKResults and Analysis Output\Percep01_3_markers_rotated_ik_BodyKinematics_pos_global.sto']);
% globalVel3 = importdata(['G:\Shared drives\NeuroMobLab\Projects\Perception\Processed Data\Dan\OpenSim\YAPercep Outputs\' subject1 '\IKResults and Analysis Output\Percep01_3_markers_rotated_ik_BodyKinematics_vel_global.sto']);


% globalPos4 = importdata(['G:\Shared drives\NeuroMobLab\Projects\Perception\Processed Data\Dan\OpenSim\YAPercep Outputs\' subject1 '\IKResults and Analysis Output\Percep01_4_markers_rotated_ik_BodyKinematics_pos_global.sto']);
% globalVel4 = importdata(['G:\Shared drives\NeuroMobLab\Projects\Perception\Processed Data\Dan\OpenSim\YAPercep Outputs\' subject1 '\IKResults and Analysis Output\Percep01_4_markers_rotated_ik_BodyKinematics_vel_global.sto']);


% globalPos5 = importdata(['G:\Shared drives\NeuroMobLab\Projects\Perception\Processed Data\Dan\OpenSim\YAPercep Outputs\' subject1 '\IKResults and Analysis Output\Percep01_5_markers_rotated_ik_BodyKinematics_pos_global.sto']);
% globalVel5 = importdata(['G:\Shared drives\NeuroMobLab\Projects\Perception\Processed Data\Dan\OpenSim\YAPercep Outputs\' subject1 '\IKResults and Analysis Output\Percep01_5_markers_rotated_ik_BodyKinematics_vel_global.sto']);



% globalPos = [globalPos1.data; globalPos2.data(2:end,:); globalPos3.data(2:end,:); globalPos4.data(2:end,:); globalPos5.data(2:end,:)];
% globalVel = [globalVel1.data; globalVel2.data(2:end,:); globalVel3.data(2:end,:); globalVel4.data(2:end,:); globalVel5.data(2:end,:)];
% Grabbing the CoM position and velocity in XYZ
% CM_pos2 = [globalPos1.data(:,74:76); globalPos2.data(2:end,74:76); globalPos3.data(2:end,74:76); globalPos4.data(2:end,74:76); globalPos5.data(2:end,74:76)];
% CM_vel2 = [globalVel1.data(:, 74:76); globalVel2.data(2:end,74:76); globalVel3.data(2:end,74:76); globalVel4.data(2:end,74:76); globalVel5.data(2:end,74:76)];
CM_pos2 = globalPos.data(:,74:76);
CM_vel2 = globalVel.data(:,74:76);
>>>>>>> Stashed changes

% Indices for the position and velocity values 
% order: Torso, Pelvis, Femur_r, Tibia_r, Talus_r, Calcn_r, Toes_r, Femur_l,
% Tibia_l, Talus_l, Calcn_l, Toes_l
idxPV = {(68:70); (2:4); (8:10); (14:16); (20:22); (26:28); (32:34);...
    (38:40); (44:46); (50:52); (56:58); (62:64);};

for i = 1:length(idxPV)
    segPos(:,:,i) = globalPos.data(:,idxPV{i});
    segVel(:,:,i) = globalVel.data(:,idxPV{i});
end


% Indices for the angular velocity table same order as listed above.
idxAV = {(71:73); (5:7); (11:13); (17:19); (23:25); (29:31); (35:37);...
    (41:43); (47:49); (53:55); (59:61); (65:67)};
% Grabbing the angular velocities for each segment listed in the order
% above 
for j = 1:length(idxAV)
    angVel(:,:,j) = globalVel.data(:,idxAV{j});
end

% angVel = angVel .* (pi/180);

% Calculating the position for each segment in reference to the CoM 
rcm2 = segPos - CM_pos2; 
% Calculating the velocity for each segment in reference to the CoM vel
vcm2 = segVel - CM_vel2;

% Multiplying the mass by the velocity for each segment 
for iSeg = 1:12 
    mvcm(:,:,iSeg) = m(iSeg) * vcm2(:,:,iSeg);
end

% Taking the cross product between the segments and the mass * velocity of
% the segments 
cp2 = cross(rcm2, mvcm,2);

% Calculating the inertia * angular velocity 
for iSeg = 1:12 
    inert2(:,:,iSeg) = angVel(:,:,iSeg) * inertiaTensor(:,:,iSeg);
end

WBAMs2 = cp2 +inert2; 

WBAM2 = sum(WBAMs2, 3);

figure; 
gcs = gaitEventsTable.Gait_Events_Right{6,1};
for i = 1:length(gcs)
    gcstart = gcs(i,1);
    gcfin = gcs(i,5);
    subplot(3,1,1); plot(WBAM2(gcstart:gcfin,1)); title('WBAM Frontal');
    hold on;
    subplot(3,1,2); plot(WBAM2(gcstart:gcfin,2)); title('WBAM Transverse');
    hold on;
    subplot(3,1,3); plot(WBAM2(gcstart:gcfin,3)); title('WBAM Saggital');
    hold on;
end


%% Testing the inertia component to see what's different 
% subjects = {'05'; '07'; '10';'11';'12'; '13';'14';'15'; '16'; '17'; '18';};
% for i = 1:11
%     
%     load(['G:\Shared drives\NeuroMobLab\Projects\Perception\Processed Data\Dan\OpenSim\YAPercep Outputs\' subject1 '\Data Tables\inertiaTensor_' subject1 '.mat']);

%% Testing to figure out what values are different 

% A = find(trcm ~= rcm2); 
% [x, y, z] = ind2sub(size(trcm), A); % Not equal l Talus, l Calc, and l Toes in segment position 
% 
% tvcm = vcm.Treadmill03; 
% clear A x y z 
% A = find(tvcm ~= vcm2); 
% [x, y, z] = ind2sub(size(tvcm), A); % Not equal l Talus, l Calc, and l Toes in segment position 
% 
% 
figure; 
gcs = gaitEventsTable.Gait_Events_Right{7,1};
for i = 1:length(gcs)
    gcstart = gcs(i,1);
    gcfin = gcs(i,5);
    subplot(3,1,1); plot(WBAM.Treadmill03(gcstart:gcfin,1)); title('WBAM Frontal');
    hold on;
    subplot(3,1,2); plot(WBAM.Treadmill03(gcstart:gcfin,2)); title('WBAM Transverse');
    hold on;
    subplot(3,1,3); plot(WBAM.Treadmill03(gcstart:gcfin,3)); title('WBAM Saggital');
    hold on;
end


%% Body Calculations 

bodyPos = importdata('G:\Shared drives\NeuroMobLab\Projects\Perception\Processed Data\Dan\WBAM\Results\YAPercep15_Treadmill01_Body_BodyKinematics_pos_global.sto');
bodyVel = importdata('G:\Shared drives\NeuroMobLab\Projects\Perception\Processed Data\Dan\WBAM\Results\YAPercep15_Treadmill01_Body_BodyKinematics_vel_bodyLocal.sto');


% Indices for the position and velocity values 
% order: Torso, Pelvis, Femur_r, Tibia_r, Talus_r, Calcn_r, Toes_r, Femur_l,
% Tibia_l, Talus_l, Calcn_l, Toes_l
idxPV = {(68:70); (2:4); (8:10); (14:16); (20:22); (26:28); (32:34);...
    (38:40); (44:46); (50:52); (56:58); (62:64);};

for i = 1:length(idxPV)
    segPos(:,:,i) = bodyPos.data(:,idxPV{i});
    segVel(:,:,i) = bodyVel.data(:,idxPV{i});
end

% Grabbing the CoM position and velocity in XYZ
CM_pos = bodyPos.data(:, 74:76);
CM_vel = bodyVel.data(:, 74:76);
% Indices for the angular velocity table same order as listed above.
idxAV = {(71:73); (5:7); (11:13); (17:19); (23:25); (29:31); (35:37);...
    (41:43); (47:49); (53:55); (59:61); (65:67)};
% Grabbing the angular velocities for each segment listed in the order
% above 
for j = 1:length(idxAV)
    angVel(:,:,j) = bodyVel.data(:,idxAV{j});
end

angVel = angVel .* (pi/180);
% Calculating the position for each segment in reference to the CoM 
rcm = segPos - CM_pos; 
% Calculating the velocity for each segment in reference to the CoM vel
vcm = segVel - CM_vel;

% Multiplying the mass by the velocity for each segment 
for iSeg = 1:12 
    mvcm(:,:,iSeg) = m(iSeg) * vcm(:,:,iSeg);
end

% Taking the cross product between the segments and the mass * velocity of
% the segments 
cp = cross(rcm, mvcm);

% Calculating the inertia * angular velocity 
for iSeg = 1:12 
    inert(:,:,iSeg) = angVel(:,:,iSeg) * inertiaTensor(:,:,iSeg);
end

WBAMs = cp +inert; 

WBAM = sum(WBAMs, 3);

figure; 
gcs = gaitEventsTable.Gait_Events_Right{7,1};
for i = 1:length(gcs)
    gcstart = gcs(i,1);
    gcfin = gcs(i,5);
    subplot(3,1,1); plot(WBAM(gcstart:gcfin,1)); title('WBAM Frontal');
    hold on;
    subplot(3,1,2); plot(WBAM(gcstart:gcfin,2)); title('WBAM Transverse');
    hold on;
    subplot(3,1,3); plot(WBAM(gcstart:gcfin,3)); title('WBAM Saggital');
    hold on;
end