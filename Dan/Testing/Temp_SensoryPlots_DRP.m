strSubject = '13';

subject1 = 'YAPercep13';

colors2 = uint8([211 211 211]); 
for i = 1:5
    colors{i,1} = (colors2);
end
colors{6,1} = 'k';

load(['G:\Shared drives\NeuroMobLab\Projects\Perception\Processed Data\Dan\OpenSim\YAPercep Outputs\' subject1 '\Data Tables\IKTable_' subject1 '.mat'])
load(['G:\Shared drives\NeuroMobLab\Projects\Perception\Processed Data\Dan\OpenSim\YAPercep Outputs\' subject1 '\Data Tables\MuscleTable_' subject1 '.mat'])
load(['G:\Shared drives\NeuroMobLab\Projects\Perception\Processed Data\Dan\Matlab Analysis\' subject1 '\Data Tables\SepTables_' subject1 '.mat'])
load(['G:\Shared drives\NeuroMobLab\Projects\Perception\Processed Data\Dan\Matlab Analysis\' subject1 '\Data Tables\pertTable_' subject1 '.mat'])
load(['G:\Shared drives\NeuroMobLab\Projects\Perception\Processed Data\Dan\Matlab Analysis\' subject1 '\Data Tables\pertCycleStruc_' subject1 '.mat'])
load(['G:\Shared drives\NeuroMobLab\Projects\Perception\Processed Data\Dan\OpenSim\YAPercep Outputs\' subject1 '\Data Tables\jointAnglesTable_' subject1 '.mat'])
load(['G:\Shared drives\NeuroMobLab\Projects\Perception\Processed Data\Dan\OpenSim\YAPercep Outputs\' subject1 '\Data Tables\SpatiotemporalTable_' subject1 '.mat'])
load(['G:\Shared drives\NeuroMobLab\Projects\Perception\Processed Data\Dan\OpenSim\YAPercep Outputs\' subject1 '\Data Tables\headCalcStruc_' subject1 '.mat'])

nameFrames = {'Pre5Frames'; 'Pre4Frames'; 'Pre3Frames'; 'Pre2Frames'; 'Pre1Frames'; 'OnsetFrames'; 'Post1Frames'; 'Post2Frames'; 'Post3Frames'; 'Post4Frames'; 'Post5Frames';}; % -5 cycles before perturbation, Onset, and +5 cycles after perturbation
namePercep = {'Percep01'; 'Percep02'; 'Percep03'; 'Percep04'; 'Percep05'; 'Percep06';}; % name of the potential perception trials for each subject 
speeds = {'sp1'; 'sp2'; 'sp3'; 'sp4'; 'sp5'; 'sp6'; 'sp7'; 'sp8';}; % Speeds in order as above 0, -0.02, -0.5, -0.1, -0.15, -0.2, -0.3, -0.4
pertSpeed = {'0'; '-0.02'; '-0.05'; '-0.10'; '-0.15'; '-0.2'; '-0.3'; '-0.4';}; % Perturbation speeds for the table
namePert = {'Catch'; 'Neg02'; 'Neg05'; 'Neg10'; 'Neg15'; 'Neg20'; 'Neg30'; 'Neg40';}; %Name of the perts to save the files
leg = {'L';'R'}; % Leg

for iLeg = 2 % Each leg
    for iSpeeds = 4 % The 8 different perturbation speeds as described in speeds
        for iTrial = 1 % The perturbation trials, ie Percep01-PercepXX
            temp4 = size(pertCycleStruc.(leg{iLeg}).(speeds{iSpeeds}).(namePercep{iTrial}).Perceived,1); % Getting the amount of perturbations sent at a specific speed per Perception trial
            for iPerts = 1:temp4 % -5 cycles before Pert, Onset, and +5 cycles after
                h2 = figure('Name', ['Sensory ' subject1 ' ' leg{iLeg} ' ' namePert{iSpeeds} ' ' namePercep{iTrial} ' ' num2str(iPerts)], 'NumberTitle', 'off');
                filename2 = ['Sensory_' subject1 '_' leg{iLeg} '_' namePert{iSpeeds} '_' namePercep{iTrial} '_' num2str(iPerts)];
                filenamePDF2 = strcat(filename2, '.pdf');
                for iCycle = 1:6
                    temp1 = pertCycleStruc.(leg{iLeg}).(speeds{iSpeeds}).(namePercep{iTrial}).(nameFrames{iCycle}){1,iPerts}(1); % first heel strike of gait cycle 
                    temp2 = pertCycleStruc.(leg{iLeg}).(speeds{iSpeeds}).(namePercep{iTrial}).(nameFrames{iCycle}){1,iPerts}(5); % ending heel strike of gait cycle
                    temp4 = pertCycleStruc.(leg{iLeg}).(speeds{iSpeeds}).(namePercep{iTrial}).(nameFrames{iCycle}){1,iPerts}(4); % Toe off for the leg of the first heel strike of the gait cycle 
                    temp3 = temp2 - temp1; % Getting length of gait cycle as elasped frames
                    
                    temp5 = temp1 * 10; 
                    temp6 = temp4 * 10;
                    temp7 = temp6-temp5;                        
                        perceived = pertCycleStruc.(leg{iLeg}).(speeds{iSpeeds}).(namePercep{iTrial}).Perceived(iPerts);
                        tRHM_AP = videoTable.("Marker Data"){iTrial,1}(temp1:temp4,30,1); % Right Heel Marker for AP 
                        tRHM_ML = videoTable.("Marker Data"){iTrial,1}(temp1:temp4,30,2); % Right Heel Marker for ML 
                        ext_RHM_AP = interp(tRHM_AP, 10);
                        ext_RHM_ML = interp(tRHM_ML, 10);
                        RHM_AP = ext_RHM_AP(1:length(analogTable.COP{iTrial,1}(temp5:temp6,4)));
                        RHM_ML = ext_RHM_ML(1:length(analogTable.COP{iTrial,1}(temp5:temp6,5)));
                            if perceived == 1
                                namePerceived = 'Perceived';
                            else
                                namePerceived = 'Not Perceived';
                            end

                            subplot(5,2,3); plot((0:temp3)/temp3, jointAnglesTable.("R Ankle Angle (Degrees)"){iTrial,1}(temp1:temp2),'color', colors{iCycle}); title('Right Ankle Angle'); % Plotting the cycle for the right ankle angle 
                            hold on;
                            subplot(5,2,5); plot((0:temp3)/temp3, jointAnglesTable.("R Knee Angle (D)"){iTrial,1}(temp1:temp2),'color', colors{iCycle}); title('Right Knee Angle'); % Plotting the cycle for the right knee angle
                            hold on;
                            subplot(5,2,7); plot((0:temp3)/temp3, jointAnglesTable.("R Hip Flexion Angle (D)"){iTrial,1}(temp1:temp2),'color', colors{iCycle}); title('Right Hip Flexion Angle'); % Plotting the cycle for the right hip flexion angle
                            hold on;
                            subplot(5,2,4); plot((0:temp3)/temp3, headCalcStruc.(namePercep{iTrial}).headAngle(temp1:temp2,1), 'color', colors{iCycle}); title('Head Angle (degree)'); %Plotting the cycle for the head angle deviation 
                            hold on; 
                            subplot(5,2,6); plot((0:temp3)/temp3, headCalcStruc.(namePercep{iTrial}).headAngularVelocity(temp1:temp2,1), 'color', colors{iCycle}); title('Head Angular Velocity (degree/s)'); % Plotting the cycle for head angular velocity deviation
                            hold on; 
                            subplot(5,2,8); plot((0:temp7)/temp7*0.6, analogTable.COP{iTrial,1}(temp5:temp6,4)- RHM_AP, 'color', colors{iCycle}); title('X CoP'); % Plotting the X direction CoP for the cycle
                            hold on;
                            subplot(5,2,10); plot((0:temp7)/temp7*0.6, analogTable.COP{iTrial,1}(temp5:temp6,5)- RHM_ML, 'color', colors{iCycle}); title('Y CoP'); % Plotting the Y direction CoP for the cycle
                            hold on;
                end
            end
        end
    end
end