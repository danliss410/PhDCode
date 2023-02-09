% Creating Plotting Script to check all the subject data 
subjects = {'01';'02'; '03'; '04'; '05'; '06'; '07'; '08'; '09'; '10'; '11'; '12';}; % Place the subject numbers here 

% Subjects that are fully processed and checked 
% I found an error where it wasn't saving my checked file. Subject 11 still
% looks weird for a couple trials, but I checked the video and the MTJ
% location is correct

close all
for iSub = 4%:length(subjects)-1 
    subID = subjects{iSub};
    % Grabbing my MTJ calculation table for the subject
    load(['G:\Shared drives\Perception Project\Ultrasound\OpenSim\YAUSPercep' subID '\Tables\'...
        'lenMTUTable_YAUSPercep' subID '.mat'])
    for iTrial = 3%:size(lengthUSTab,1)
        ls = size(lengthUSTab.MG_Length{iTrial},2);
        figure; 
        for i = 1:ls
            if i < ls
                % Plotting MG excursion per gait cycle
%                 subplot(3,1,1); plot(lengthUSTab.MG_Length{iTrial}(:,i)-lengthUSTab.MG_Length{iTrial}(1,i), 'color', [.5 .5 .5]); hold on;
%                 title(['MG Length per GC for ' lengthUSTab.Trial{iTrial}]);
%                 xlabel('% of GC'); ylabel('MG Length (mm)');
%                 
%                 % Plotting AT excursion per gait cycle 
%                 subplot(3,1,2); plot(lengthUSTab.AT_Length{iTrial}(:,i)-lengthUSTab.AT_Length{iTrial}(1,i), 'k'); hold on;
%                 title('AT Length per GC'); xlabel('% of GC'); ylabel('AT Length (mm)');
                % Plotting MTU excursion per gait cycle
                plot(0:1:100, lengthUSTab.MTU_Length{iTrial}(:,i)-lengthUSTab.MTU_Length{iTrial}(1,i), 'color', [.5 .5 .5], 'LineWidth', 3); hold on;
                title('MTU Length per GC'); xlabel('% of GC'); ylabel('MTU Length (mm)');
                
            else
                % Plotting MG excursion per gait cycle
%                 subplot(3,1,1); plot(lengthUSTab.MG_Length{iTrial}(:,i)-lengthUSTab.MG_Length{iTrial}(1,i), 'r'); hold on;
%                 title(['MG Length per GC for ' lengthUSTab.Trial{iTrial}]);
%                 xlabel('% of GC'); ylabel('MG Length (mm)');
%                 ylim([-30 30])
%                 % Plotting AT excursion per gait cycle 
%                 subplot(3,1,2); plot(lengthUSTab.AT_Length{iTrial}(:,i)-lengthUSTab.AT_Length{iTrial}(1,i), 'r'); hold on;
%                 title('AT Length per GC'); xlabel('% of GC'); ylabel('AT Length (mm)');
%                 ylim([-30 30])
                % Plotting MTU excursion per gait cycle
                plot(0:1:100, lengthUSTab.MTU_Length{iTrial}(:,i)-lengthUSTab.MTU_Length{iTrial}(1,i), 'k', 'LineWidth', 3); hold on;
                title('MTU Length per GC'); xlabel('% of GC'); ylabel('MTU Length (mm)');
                ylim([-30 30])
                plot(0:1:100, temp2, 'r','LineWidth', 3); hold on;
            end
        end
    end
end



% %% 
% domLeg = 'R';
% 
% iTrial = 15; 
% tempMTL = MTJTable.("MT_len_(mm)"){iTrial}; 
% tempMGL = MTJTable.("MG_len_(mm)"){iTrial};
% tempATL = MTJTable.("AT_len_(mm)"){iTrial};
% atime = MTJTable.("Analog_Time_(s)"){iTrial};
% usTime = MTJTable.("US_Time_(s)"){iTrial};
% 
% idxTrial = 18; 
%     if domLeg == 'R'
%         GER = GETableFull.GETable_Right{idxTrial}; % Table with RHS based gait events
%         pc = GETableFull.Pert_Cycle(idxTrial); % perturbed cycle
%         % Getting the cycles before the perturbation. Subject 1 only has 4
%         % cycles before some of their perturbations so adjusted their
%         % comparison
%         if pc >=6
%             % Getting the 5 gait cycles before the perturbation 
%             cbp = GER.RHS(pc-5:pc+1);
%         else
%             cbp = GER.RHS(pc-4:pc+1); % This is for subject 1
%         end
%         % upsampling the 5 gait cycles preceding the perturbation to be in analog
%         % time and in 1000 hz collection rate 
%         cbp = cbp.*10;
%         % This loop finds the closest index of the HS in regards to the usTime
%         for iRHS = 1:length(cbp)
%             [minValue(iRHS),closestIndex] = min(abs(atime(cbp(iRHS))-usTime));
%             usInd(iRHS) = closestIndex; 
%         % Figure out if you should upsample the ultrasound data to be 1000 Hz
%         % but for right now there is ~ 5ms error using the ultrasound frame
%         % rate
%         end
%     else
%         GEL = GETableFull.GETable_Left{idxTrial}; % Table with LHS based gait events
%         pc = GETableFull.Pert_Cycle(idxTrial); % perturbed cycle
%         % Getting the cycles before the perturbation
%         cbp = GEL.LHS(pc-5:pc+1); % This is for the left legged subject 7
%         % upsampling the 5 gait cycles preceding the perturbation to be in analog
%         % time and in 1000 hz collection rate 
%         cbp = cbp.*10;
%         for iLHS = 1:length(cbp)
%             [minValue(iLHS),closestIndex] = min(abs(atime(cbp(iLHS))-usTime));
%             usInd(iLHS) = closestIndex; 
%         % Figure out if you should upsample the ultrasound data to be 1000 Hz
%         % but for right now there is ~ 5ms error using the ultrasound frame
%         % rate
%         end
%     end
% 
% 
%     %% 
%         % Making the data for the gait cycles be in % of gait cycle instead of
%     % a random number of frames
%     for i = 1:length(cbp)-1
%         FMGL = griddedInterpolant(usTime(usInd(i):usInd(i+1)),tempMGL(usInd(i):usInd(i+1)), 'linear', 'spline');
%         FATL = griddedInterpolant(usTime(usInd(i):usInd(i+1)),tempATL(usInd(i):usInd(i+1)), 'linear', 'spline');
%         FMTL = griddedInterpolant(atime(cbp(i):cbp(i+1)),tempMTL(cbp(i):cbp(i+1)), 'linear', 'spline');
%         % Change in time for atime as a percentage 
%         dt2 = (atime(cbp(i+1))- atime(cbp(i)))/100;
%         % Time matrix to interpolate or extrapolate for MTU length 
%         idx2 = atime(cbp(i)):dt2:atime(cbp(i+1));
%         % Change in time as a percentage
%         dt = (usTime(usInd(i+1))-usTime(usInd(i)))/100;
%         % Time matrix to interpolate or extrapolate 
%         idx = usTime(usInd(i)):dt:usTime(usInd(i+1)); 
%         
%         % Creating a new matrix that is for the 5 gait cycles preperturbation
%         % and the perturbed cycle for the MG length, AT length, MT length for %
%         % of gait cycle
%         MGL(:,i) = FMGL(idx);
%         % AT length as % of gait cycle 
%         ATL(:,i) = FATL(idx);
%         % MT length as % of gait cycle 
%         MTL(:,i) = FMTL(idx2);   
%     end
