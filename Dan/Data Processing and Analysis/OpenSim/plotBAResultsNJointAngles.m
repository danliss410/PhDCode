function plotBAResultsNJointAngles(strSubject)
% This function uses the inverse kinematics results generated from opensim
% for all the trials to create plots for calcaneous velocity, joint angles, 
% head variables, and COP for -5 cycles before perturbation, onset of perturbation
% and +5 cycles after the perturbation. It will save the plots in the
% Plots_IKResults and Joint Angles folder for each individual subject. It
% will also create joined plots where all repeats of the perturbation are
% on the plot for each leg and then individual perturbations. 
%
%
%
% INPUTS: subject               - string of the subject number 
%
% OUPUT: No technical output but saves plots to the individual subjects
% folder. 
%
%
%
% Created: 25 February, 2021 DJL 
% Modified: (format: date, initials, change made)
%   1 -   
%   2 - 
% Things that need to be added 
%   1 - Cognitive or 2AFC trials 
%% Create subject name to load the necessary files for the subject 

subject1 = ['YAPercep' strSubject];

%% Creating the folder to save the plots for each subject

% Setting the location to the subjects' OpenSim Analysis folder 
if ispc
    subLoc = ['G:\Shared drives\NeuroMobLab\Projects\Perception\Processed Data\Dan\OpenSim\YAPercep Outputs\' subject1];
elseif ismac
    subLoc = [''];
else
    subLoc = input('Please enter the location where the tables should be saved.' ,'s');
end


% Checking to see if an overall plotting folder exists in the subjects OpenSim results. 
% If it does not exist it will make one. 
if exist([subLoc filesep 'Plots_BAResults and Joint Angles'], 'dir') ~= 7
    mkdir(subLoc, 'Plots_BAResults and Joint Angles');
end

% Checking to see if a subfolder for the individual perturbation plots
% exist. 
if exist([subLoc filesep 'Plots_BAResults and Joint Angles' filesep 'Individual Perts' ], 'dir') ~= 7
    mkdir([subLoc filesep 'Plots_BAResults and Joint Angles'], 'Individual Perts')
end

% Setting the location to save the plots for each subject 
if ispc
    plotLoc1 = ['G:\Shared drives\NeuroMobLab\Projects\Perception\Processed Data\Dan\OpenSim\YAPercep Outputs\' subject1 filesep 'Plots_BAResults and Joint Angles' filesep];
elseif ismac
    plotLoc1 = [''];
else
    plotLoc1 = input('Please enter the location where the tables should be saved.' ,'s');
end

% Setting the location to save the plots for each subject 
if ispc
    plotLoc2 = ['G:\Shared drives\NeuroMobLab\Projects\Perception\Processed Data\Dan\OpenSim\YAPercep Outputs\' subject1 '\Plots_BAResults and Joint Angles\Individual Perts' filesep];
elseif ismac
    plotLoc2 = [''];
else
    plotLoc2 = input('Please enter the location where the tables should be saved.' ,'s');
end
%% Loading the remaining tables for the subject 
% This section will load tables for the subject

load(['G:\Shared drives\NeuroMobLab\Projects\Perception\Processed Data\Dan\OpenSim\YAPercep Outputs\' subject1 '\Data Tables\BodyAnalysisTable_' subject1 '.mat'])
% load(['G:\Shared drives\NeuroMobLab\Projects\Perception\Processed Data\Dan\OpenSim\YAPercep Outputs\' subject1 '\Data Tables\MuscleTable_' subject1 '.mat'])
load(['G:\Shared drives\NeuroMobLab\Projects\Perception\Processed Data\Dan\Matlab Analysis\' subject1 '\Data Tables\SepTables_' subject1 '.mat'])
load(['G:\Shared drives\NeuroMobLab\Projects\Perception\Processed Data\Dan\Matlab Analysis\' subject1 '\Data Tables\pertTable_' subject1 '.mat'])
load(['G:\Shared drives\NeuroMobLab\Projects\Perception\Processed Data\Dan\Matlab Analysis\' subject1 '\Data Tables\pertCycleStruc_' subject1 '.mat'])
load(['G:\Shared drives\NeuroMobLab\Projects\Perception\Processed Data\Dan\OpenSim\YAPercep Outputs\' subject1 '\Data Tables\jointAnglesTable_' subject1 '.mat'])
load(['G:\Shared drives\NeuroMobLab\Projects\Perception\Processed Data\Dan\OpenSim\YAPercep Outputs\' subject1 '\Data Tables\SpatiotemporalTable_' subject1 '.mat'])
load(['G:\Shared drives\NeuroMobLab\Projects\Perception\Processed Data\Dan\OpenSim\YAPercep Outputs\' subject1 '\Data Tables\headCalcStruc_' subject1 '.mat'])


%% This section creates plots from -5 cycles before perturbation, Onset, +5 cycles after perturbation
nameFrames = {'Pre5Frames'; 'Pre4Frames'; 'Pre3Frames'; 'Pre2Frames'; 'Pre1Frames'; 'OnsetFrames'; 'Post1Frames'; 'Post2Frames'; 'Post3Frames'; 'Post4Frames'; 'Post5Frames';}; % -5 cycles before perturbation, Onset, and +5 cycles after perturbation
namePercep = {'Percep01';'Percep02'; 'Percep03'; 'Percep04'; 'Percep05'; 'Percep06';};%   % name of the potential perception trials for each subject 
speeds = {'sp1'; 'sp2'; 'sp3'; 'sp4'; 'sp5'; 'sp6'; 'sp7'; 'sp8';}; % Speeds in order as above 0, -0.02, -0.5, -0.1, -0.15, -0.2, -0.3, -0.4
pertSpeed = {'0'; '-0.02'; '-0.05'; '-0.10'; '-0.15'; '-0.2'; '-0.3'; '-0.4';}; % Perturbation speeds for the table
namePert = {'Catch'; 'Neg02'; 'Neg05'; 'Neg10'; 'Neg15'; 'Neg20'; 'Neg30'; 'Neg40';}; %Name of the perts to save the files
leg = {'L';'R'}; % Leg

pTrials = contains(pertTable.Trial, 'Percep'); % Finding which rows in the table contain the Perception Trials

pTrials = pTrials(pTrials == 1); %Selecting only the indicies that have Perception trials
colors = {'#00876c'; '#4f9971'; '#7bab79'; '#a3bd86'; '#c9ce98'; '#000000' ; '#e8c48b'; '#e5a76f'; '#e2885b'; '#dd6551'; '#d43d51'}; % Setting the colors to be chosen for each cycle plotted


% cd(plotLoc1)
% This loops makes figures that contain all the perturbation repeats on 1
% plot. -5 to +5 cycles on each leg are plotted as long as there is
% information for these. The top subplot is the perturbed leg calc velocity
% -SSWS, subplot2 is the leg's angle ankle, subplot3 is the knee angle,
% subplot4 is the hip flexion angle. Perturbed step is indicated in black.
% -5 starts green and progress lighter. After the perturbed step it turns
% yellow and ends red at +5.
% for iLeg = 1:size(leg,1) % Each leg
%     for iSpeeds = 1:size(speeds,1) % The 8 different perturbation speeds as described in speeds
%         h1 = figure('Name', [subject1 ' ' leg{iLeg} ' ' namePert{iSpeeds} ' All'], 'NumberTitle', 'off');
%         filename1 = [subject1 '_' leg{iLeg} '_' namePert{iSpeeds} '_All'];
%         filenamePDF1 = strcat(filename1, '.pdf');
%         for iTrial = 1:size(pTrials,1) % The perturbation trials, ie Percep01-PercepXX
%             temp4 = size(pertCycleStruc.(leg{iLeg}).(speeds{iSpeeds}).(namePercep{iTrial}).Perceived,1); % Getting the amount of perturbations sent at a specific speed per Perception trial
%             for iPerts = 1:temp4 % -5 cycles before Pert, Onset, and +5 cycles after
%                 for iCycle = 1:size(nameFrames,1)
%                     temp1 = pertCycleStruc.(leg{iLeg}).(speeds{iSpeeds}).(namePercep{iTrial}).(nameFrames{iCycle}){1,iPerts}(1); % first heel strike of gait cycle 
%                     temp2 = pertCycleStruc.(leg{iLeg}).(speeds{iSpeeds}).(namePercep{iTrial}).(nameFrames{iCycle}){1,iPerts}(5); % ending heel strike of gait cycle
%                     temp3 = temp2 - temp1; % Getting length of gait cycle as elasped frames
%                     if isnan(temp1) || isnan(temp2) || isnan(temp3)
%         
%                     else  
%                         if iLeg == 1 % When the leg is left
%                             subplot(4,1,1); plot((0:temp3)/temp3, IKTable.("L Calc Smooth Z"){iTrial,1}(temp1:temp2),'color', colors{iCycle}); title(['YAP' strSubject ' ' leg{iLeg} ' ' pertSpeed{iSpeeds}]); % Plotting the cycle for Left Calc Velocity - SSWS
%                             hold on;
%                             subplot(4,1,2); plot((0:temp3)/temp3, jointAnglesTable.("L Ankle Angle (D)"){iTrial,1}(temp1:temp2),'color', colors{iCycle}); title('Left Ankle Angle'); % Plotting the cycle for the Left ankle angle 
%                             hold on;
%                             subplot(4,1,3); plot((0:temp3)/temp3, jointAnglesTable.("L Knee Angle (D)"){iTrial,1}(temp1:temp2),'color', colors{iCycle}); title('Left Knee Angle'); %Plotting the cycle for the left knee angle 
%                             hold on;
%                             subplot(4,1,4); plot((0:temp3)/temp3, jointAnglesTable.("L Hip Flexion Angle (D)"){iTrial,1}(temp1:temp2),'color', colors{iCycle}); title('Left Hip Flexion Angle'); % Plotting the cycle for the left hip flexion angle
%                             hold on;
%                             legend(nameFrames);
%                         else
%                             subplot(4,1,1); plot((0:temp3)/temp3, IKTable.("R Calc Smooth Z"){iTrial,1}(temp1:temp2),'color', colors{iCycle}); title(['YAP' strSubject ' ' leg{iLeg} ' ' pertSpeed{iSpeeds}]); % Plotting the cycle for Right Calc Velocity - SSWS
%                             hold on;
%                             subplot(4,1,2); plot((0:temp3)/temp3, jointAnglesTable.("R Ankle Angle (Degrees)"){iTrial,1}(temp1:temp2),'color', colors{iCycle}); title('Right Ankle Angle'); % Plotting the cycle for the right ankle angle 
%                             hold on;
%                             subplot(4,1,3); plot((0:temp3)/temp3, jointAnglesTable.("R Knee Angle (D)"){iTrial,1}(temp1:temp2),'color', colors{iCycle}); title('Right Knee Angle'); % Plotting the cycle for the right knee angle
%                             hold on;
%                             subplot(4,1,4); plot((0:temp3)/temp3, jointAnglesTable.("R Hip Flexion Angle (D)"){iTrial,1}(temp1:temp2),'color', colors{iCycle}); title('Right Hip Flexion Angle'); % Plotting the cycle for the right hip flexion angle
%                             hold on;
%                             legend(nameFrames);
%                         end
%                         clear temp1 temp2 temp 3
%                     end
%                 end
%             end
%         end
%         saveas(h1, filename1);
%         print(filenamePDF1, '-dpdf', '-bestfit');
%         close(h1)
%     end
% end


%% This section plots the individual perturbations 

cd(plotLoc2)
% This loops makes figures that for each individual perturbation. 
% -5 to +5 cycles on each leg are plotted as long as there is
% information for these. The top subplot is the perturbed leg calc velocity
% -SSWS, subplot2 is the leg's angle ankle, subplot3 is the knee angle,
% subplot4 is the hip flexion angle. Perturbed step is indicated in black.
% -5 starts green and progress lighter. After the perturbed step it turns
% yellow and ends red at +5.
for iLeg = 1:size(leg,1) % Each leg
    for iSpeeds = 1:size(speeds,1) % The 8 different perturbation speeds as described in speeds
        for iTrial = 1:size(pTrials,1) % The perturbation trials, ie Percep01-PercepXX
            temp4 = size(pertCycleStruc.(leg{iLeg}).(speeds{iSpeeds}).(namePercep{iTrial}).Perceived,1); % Getting the amount of perturbations sent at a specific speed per Perception trial
            for iPerts = 1:temp4 % -5 cycles before Pert, Onset, and +5 cycles after
                h2 = figure('Name', ['Sensory ' subject1 ' ' leg{iLeg} ' ' namePert{iSpeeds} ' ' namePercep{iTrial} ' ' num2str(iPerts)], 'NumberTitle', 'off');
                filename2 = ['Sensory_' subject1 '_' leg{iLeg} '_' namePert{iSpeeds} '_' namePercep{iTrial} '_' num2str(iPerts)];
                filenamePDF2 = strcat(filename2, '.pdf');
                for iCycle = 1:size(nameFrames,1)
                    temp1 = pertCycleStruc.(leg{iLeg}).(speeds{iSpeeds}).(namePercep{iTrial}).(nameFrames{iCycle}){1,iPerts}(1); % first heel strike of gait cycle 
                    temp2 = pertCycleStruc.(leg{iLeg}).(speeds{iSpeeds}).(namePercep{iTrial}).(nameFrames{iCycle}){1,iPerts}(5); % ending heel strike of gait cycle
                    temp4 = pertCycleStruc.(leg{iLeg}).(speeds{iSpeeds}).(namePercep{iTrial}).(nameFrames{iCycle}){1,iPerts}(4); % Toe off for the leg of the first heel strike of the gait cycle 
                    temp3 = temp2 - temp1; % Getting length of gait cycle as elasped frames
                    
                    temp5 = temp1 * 10; 
                    temp6 = temp4 * 10;
                    temp7 = temp6-temp5;
                    
                    if isnan(temp1) || isnan(temp2) || isnan(temp3)
        
                    else  
                        if iLeg == 1 % When the leg is left
                            perceived = pertCycleStruc.(leg{iLeg}).(speeds{iSpeeds}).(namePercep{iTrial}).Perceived(iPerts);
                            tLHM_AP = videoTable.("Marker_Data"){iTrial,1}(temp1:temp4,22,1); % Left Heel Marker for AP 
                            tLHM_ML = videoTable.("Marker_Data"){iTrial,1}(temp1:temp4,22,2); % Left Heel Marker for ML
                            ext_LHM_AP = interp(tLHM_AP, 10);
                            ext_LHM_ML = interp(tLHM_ML, 10);
                            LHM_AP = ext_LHM_AP(1:length(analogTable.COP{iTrial,1}(temp5:temp6,1)));
                            LHM_ML = ext_LHM_ML(1:length(analogTable.COP{iTrial,1}(temp5:temp6,2)));
                            if perceived == 1
                                namePerceived = 'Perceived';
                            else
                                namePerceived = 'Not Perceived';
                            end
                            subplot(5,2,[1 2]); plot((0:temp3)/temp3, BodyAnalysisTable.("L_Calc_Smooth"){iTrial,1}(temp1:temp2),'color', colors{iCycle}); title(['YAP' strSubject ' ' leg{iLeg} ' ' pertSpeed{iSpeeds} ' ' namePerceived]); % Plotting the cycle for Left Calc Velocity - SSWS
                            hold on;
                            subplot(5,2,3); plot((0:temp3)/temp3, jointAnglesTable.("L_Ankle_Angle_(D)"){iTrial,1}(temp1:temp2),'color', colors{iCycle}); title('Left Ankle Angle'); % Plotting the cycle for the Left ankle angle 
                            hold on;
                            subplot(5,2,5); plot((0:temp3)/temp3, jointAnglesTable.("L_Knee_Angle_(D)"){iTrial,1}(temp1:temp2),'color', colors{iCycle}); title('Left Knee Angle'); %Plotting the cycle for the left knee angle 
                            hold on;
                            subplot(5,2,7); plot((0:temp3)/temp3, jointAnglesTable.("L_Hip_Flexion_Angle_(D)"){iTrial,1}(temp1:temp2),'color', colors{iCycle}); title('Left Hip Flexion Angle'); % Plotting the cycle for the left hip flexion angle
                            hold on;
                            legend(nameFrames, 'Location', 'SouthOutside');
                            subplot(5,2,4); plot((0:temp3)/temp3, headCalcStruc.(namePercep{iTrial}).headAngle(temp1:temp2,1), 'color', colors{iCycle}); title('Head Angle (degree)'); %Plotting the cycle for the head angle deviation 
                            hold on; 
                            subplot(5,2,6); plot((0:temp3)/temp3, headCalcStruc.(namePercep{iTrial}).headAngularVelocity(temp1:temp2,1), 'color', colors{iCycle}); title('Head Angular Velocity (degree/s)'); % Plotting the cycle for head angular velocity deviation
                            hold on; 
                            subplot(5,2,8); plot((0:temp7)/temp7*0.6, analogTable.COP{iTrial,1}(temp5:temp6,1)- LHM_AP , 'color', colors{iCycle}); title('X CoP'); % Plotting the X direction CoP for the cycle
                            hold on;                                    % To get the heel marker data to subtract from you will need to use interp and then make it the same size as the COP data. 
                            subplot(5,2,10); plot((0:temp7)/temp7*0.6, analogTable.COP{iTrial,1}(temp5:temp6,2) - LHM_ML , 'color', colors{iCycle}); title('Y CoP'); % Plotting the Y direction CoP for the cycle
                            hold on;
                        else
                        perceived = pertCycleStruc.(leg{iLeg}).(speeds{iSpeeds}).(namePercep{iTrial}).Perceived(iPerts);
                        tRHM_AP = videoTable.("Marker_Data"){iTrial,1}(temp1:temp4,30,1); % Right Heel Marker for AP 
                        tRHM_ML = videoTable.("Marker_Data"){iTrial,1}(temp1:temp4,30,2); % Right Heel Marker for ML 
                        ext_RHM_AP = interp(tRHM_AP, 10);
                        ext_RHM_ML = interp(tRHM_ML, 10);
                        RHM_AP = ext_RHM_AP(1:length(analogTable.COP{iTrial,1}(temp5:temp6,4)));
                        RHM_ML = ext_RHM_ML(1:length(analogTable.COP{iTrial,1}(temp5:temp6,5)));
                            if perceived == 1
                                namePerceived = 'Perceived';
                            else
                                namePerceived = 'Not Perceived';
                            end
                            subplot(5,2,[1 2]); plot((0:temp3)/temp3, BodyAnalysisTable.("R_Calc_Smooth"){iTrial,1}(temp1:temp2),'color', colors{iCycle}); title(['YAP' strSubject ' ' leg{iLeg} ' ' pertSpeed{iSpeeds} ' ' namePerceived]); % Plotting the cycle for Right Calc Velocity - SSWS
                            hold on;
                            subplot(5,2,3); plot((0:temp3)/temp3, jointAnglesTable.("R_Ankle_Angle_(Degrees)"){iTrial,1}(temp1:temp2),'color', colors{iCycle}); title('Right Ankle Angle'); % Plotting the cycle for the right ankle angle 
                            hold on;
                            subplot(5,2,5); plot((0:temp3)/temp3, jointAnglesTable.("R_Knee_Angle_(D)"){iTrial,1}(temp1:temp2),'color', colors{iCycle}); title('Right Knee Angle'); % Plotting the cycle for the right knee angle
                            hold on;
                            subplot(5,2,7); plot((0:temp3)/temp3, jointAnglesTable.("R_Hip_Flexion_Angle_(D)"){iTrial,1}(temp1:temp2),'color', colors{iCycle}); title('Right Hip Flexion Angle'); % Plotting the cycle for the right hip flexion angle
                            hold on;
                            legend(nameFrames, 'Location', 'SouthOutside');
                            subplot(5,2,4); plot((0:temp3)/temp3, headCalcStruc.(namePercep{iTrial}).headAngle(temp1:temp2,1), 'color', colors{iCycle}); title('Head Angle (degree)'); %Plotting the cycle for the head angle deviation 
                            hold on; 
                            subplot(5,2,6); plot((0:temp3)/temp3, headCalcStruc.(namePercep{iTrial}).headAngularVelocity(temp1:temp2,1), 'color', colors{iCycle}); title('Head Angular Velocity (degree/s)'); % Plotting the cycle for head angular velocity deviation
                            hold on; 
                            subplot(5,2,8); plot((0:temp7)/temp7*0.6, analogTable.COP{iTrial,1}(temp5:temp6,4)- RHM_AP, 'color', colors{iCycle}); title('X CoP'); % Plotting the X direction CoP for the cycle
                            hold on;
                            subplot(5,2,10); plot((0:temp7)/temp7*0.6, analogTable.COP{iTrial,1}(temp5:temp6,5)- RHM_ML, 'color', colors{iCycle}); title('Y CoP'); % Plotting the Y direction CoP for the cycle
                            hold on;
                        end
                        clear temp1 temp2 temp 3 perceived namePerceived
                    end
                end
                saveas(h2, filename2);
                print(filenamePDF2, '-dpdf', '-bestfit');
                close(h2)
            end
        end
    end
end


end

