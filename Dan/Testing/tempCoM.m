%% Weighted sum of positions 
% Potential Subject strings 
% {'05'; '07'; '10'; '11'; '12'; '13'; '14'; '15'; '16'; '17'; '18'};
strSubject = '12';
subject1 = ['YAPercep' strSubject];

if ispc 
    load(['G:\Shared drives\NeuroMobLab\Projects\Perception\Processed Data\Dan\Full Sub Data\' subject1 '_Tables.mat']);

    temp = importdata('G:\Shared drives\NeuroMobLab\Projects\Perception\Processed Data\Dan\OpenSim\YAPercep Outputs\MassAndInertia\massAndInertia.xlsx');
elseif ismac 
    % I think this will load it on your mac but I'm not sure 
    load(['/Volumes/GoogleDrive/Shared drives/NeuroMobLab/Projects/Perception/Processed Data/Dan/Full Sub Data/' subject1 '_Tables.mat']);
    temp = importdata('/Volumes/GoogleDrive/Shared drives/NeuroMobLab/Projects/Perception/Processed Data/Dan/Opensim/YAPercep Outputs/MassAndInertia/massAndInertia.xlsx');
end


m = temp.data.(subject1)(:,1);


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
        CMs_acc.(trials{iTrial})(:,:,iSeg) = accSegmentsTable.(segments{iSeg}){iTrial,:};
    end
end

%%
% Calculating the weighted sum for CoM position, velocity, and acceleration
for iTrial = 1:size(trials,1)
    for iDir = 1:3
        pos1 = squeeze(CMs_pos.(trials{iTrial})(:,iDir,:));
        pos2.(trials{iTrial})(:,iDir) = pos1*m;
        
        vel1 = squeeze(CMs_vel.(trials{iTrial})(:,iDir,:));
        vel2.(trials{iTrial})(:,iDir) = vel1*m;
        
        acc1 = squeeze(CMs_acc.(trials{iTrial})(:,iDir,:));
        acc2.(trials{iTrial})(:,iDir) = acc1*m;
        clear pos1 vel1 
    end
end

% Plot Comparison for CoM position OpenSim to weighted sum method
for iTrial = 1:size(trials,1)
    figure; 
    subplot(3,1,1); plot(CM_pos.(trials{iTrial})(:,1)*sum(m));
    hold on; plot(pos2.(trials{iTrial})(:,1)); title(['CoM position X ' trials{iTrial}]); legend({'OpenSim Data'; 'Weighted Sum Method'});
    subplot(3,1,2); plot(CM_pos.(trials{iTrial})(:,2)*sum(m));
    hold on; plot(pos2.(trials{iTrial})(:,2)); title(['CoM position Y']);
    subplot(3,1,3); plot(CM_pos.(trials{iTrial})(:,3)*sum(m));
    hold on; plot(pos2.(trials{iTrial})(:,3)); title('CoM position Z'); ylabel('kg*m'); xlabel('Frames')
end
    
    
% Plot comparison for CoM velocity OpenSim to weighted sum method
for iTrial = 1:size(trials,1)
    figure; 
    subplot(3,1,1); plot(CM_vel.(trials{iTrial})(:,1)*sum(m));
    hold on; plot(vel2.(trials{iTrial})(:,1)); title(['CoM velocity X ' trials{iTrial}]); legend({'OpenSim Data'; 'Weighted Sum Method'});
    subplot(3,1,2); plot(CM_vel.(trials{iTrial})(:,2)*sum(m));
    hold on; plot(vel2.(trials{iTrial})(:,2)); title('CoM velocity Y');
    subplot(3,1,3); plot(CM_vel.(trials{iTrial})(:,3)*sum(m));
    hold on; plot(vel2.(trials{iTrial})(:,3)); title('CoM velocity Z'); ylabel('kg*m'); xlabel('Frames')
end

% Plot comparison for CoM acceleration Opensim to weighted sum method
for iTrial = 1:size(trials,1)
    figure; 
    subplot(3,1,1); plot(CM_acc.(trials{iTrial})(:,1)*sum(m));
    hold on; plot(acc2.(trials{iTrial})(:,1)); title(['CoM Acceleration X ' trials{iTrial}]); legend({'OpenSim Data'; 'Weighted Sum Method'});
    subplot(3,1,2); plot(CM_acc.(trials{iTrial})(:,2)*sum(m));
    hold on; plot(acc2.(trials{iTrial})(:,2)); title('CoM acceleration Y');
    subplot(3,1,3); plot(CM_acc.(trials{iTrial})(:,3)*sum(m));
    hold on; plot(acc2.(trials{iTrial})(:,3)); title('CoM acceleration Z'); ylabel('kg*m'); xlabel('Frames');
end