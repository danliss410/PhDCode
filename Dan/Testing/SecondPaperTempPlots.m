strSubject = '10';
subject1 = ['YAPercep' strSubject];

%% Loading the subject's full workspace 

% load(['G:\Shared drives\NeuroMobLab\Projects\Perception\Processed Data\Dan\Full Sub Data\' subject1 '_Tables.mat']);

load(['G:\Shared drives\NeuroMobLab\Projects\Perception\Processed Data\Dan\Matlab Analysis\' subject1 '\Data Tables\SepTables_' subject1 '.mat'])
load(['G:\Shared drives\NeuroMobLab\Projects\Perception\Processed Data\Dan\OpenSim\YAPercep Outputs\' subject1 '\Data Tables\dynamicStabilityTable_' subject1 '.mat'])
load(['G:\Shared drives\NeuroMobLab\Projects\Perception\Processed Data\Dan\Matlab Analysis\' subject1 '\Data Tables\GCTables_' subject1 '.mat'])

%%
iTrial = 1;
namePerceived = 'Not Perceived';
rPerts = find(strcmp(RpertGC.Leg{iTrial}, 'R')); % Finding where the right leg perturbations are in the table for all GCs 
Sp = RpertGC.Speed{iTrial}(rPerts); % Finding the perturbation speeds in each trial 
per = RpertGC.Perceived{iTrial}(rPerts); % Getting whether or not the perturbations were perceived 
iPerts = 2;
cycles = rPerts(iPerts)-5:1:rPerts(iPerts);

colors = {'#00876c'; '#4f9971'; '#7bab79'; '#a3bd86'; '#c9ce98'; '#000000' ;};
h = figure; 


for iCycle = 1:size(cycles,2) % Looping through the -5 cycles, onset,  %####Took this out for now can add back in and +5 cycles after perturbation
    filename = ['CoMPos ' subject1 ' ' 'Neg10' namePerceived];
    filenamePDF = strcat(filename, '.pdf');
    gcStart = RpertGC.RHS{iTrial}(cycles(iCycle));
    gcFin = RpertGC.RHS_2{iTrial}(cycles(iCycle));
    gcLen = RpertGC.RHS_2{iTrial}(cycles(iCycle)) - RpertGC.RHS{iTrial}(cycles(iCycle));
    subplot(3,1,1); plot((0:gcLen)/gcLen, dynamicStabilityTable.CoM_Pos{iTrial}(gcStart:gcFin,1),...
        'color', colors{iCycle}); title(['YAP' strSubject ' CoM Pos AP' ' ' num2str(Sp(iPerts)) ' ' namePerceived]); % Plotting the WBAM in the Frontal plane
    ylabel('m'); ylim([0.9 1.1])
    hold on; 
    
    subplot(3,1,2); plot((0:gcLen)/gcLen, dynamicStabilityTable.CoM_Pos{iTrial}(gcStart:gcFin,2),...
        'color', colors{iCycle}); title(['YAP' strSubject ' CoM Pos ML']); % Plotting the WBAM in the Transverse plane
    ylabel('m'); ylim([0.8 1])
    hold on; 
    
    subplot(3,1,3); plot((0:gcLen)/gcLen, dynamicStabilityTable.CoM_Pos{iTrial}(gcStart:gcFin,3),...
        'color', colors{iCycle}); title(['YAP' strSubject ' CoM Pos VT']); % Plotting the WBAM in the saggital plane 
    ylabel('m'); xlabel('% of Gait Cycle'); ylim([-0.65 -0.45])
    hold on;             
    clear gcStart gcFin gcLen
end
saveas(h, filename);
print(filenamePDF, '-dpdf', '-bestfit');
close(h)
h = figure;

for iCycle = 1:size(cycles,2) % Looping through the -5 cycles, onset,  %####Took this out for now can add back in and +5 cycles after perturbation
    filename = ['CoMVel ' subject1 ' ' 'Neg10' namePerceived];
    filenamePDF = strcat(filename, '.pdf');
    gcStart = RpertGC.RHS{iTrial}(cycles(iCycle));
    gcFin = RpertGC.RHS_2{iTrial}(cycles(iCycle));
    gcLen = RpertGC.RHS_2{iTrial}(cycles(iCycle)) - RpertGC.RHS{iTrial}(cycles(iCycle));
    subplot(3,1,1); plot((0:gcLen)/gcLen, dynamicStabilityTable.CoM_Vel{iTrial}(gcStart:gcFin,1),...
        'color', colors{iCycle}); title(['YAP' strSubject ' CoM Vel AP' ' ' num2str(Sp(iPerts)) ' ' namePerceived]); % Plotting the WBAM in the Frontal plane
    ylabel('m/s'); ylim([-0.2 0.2])
    hold on; 
    
    subplot(3,1,2); plot((0:gcLen)/gcLen, dynamicStabilityTable.CoM_Vel{iTrial}(gcStart:gcFin,2),...
        'color', colors{iCycle}); title(['YAP' strSubject ' CoM Vel ML']); % Plotting the WBAM in the Transverse plane
    ylabel('m/s'); ylim([-0.3 0.3])
    hold on; 
    
    subplot(3,1,3); plot((0:gcLen)/gcLen, dynamicStabilityTable.CoM_Vel{iTrial}(gcStart:gcFin,3),...
        'color', colors{iCycle}); title(['YAP' strSubject ' CoM Vel VT']); % Plotting the WBAM in the saggital plane 
    ylabel('m/s'); xlabel('% of Gait Cycle'); ylim([-0.3 0.3])
    hold on;             
    clear gcStart gcFin gcLen
end
saveas(h, filename);
print(filenamePDF, '-dpdf', '-bestfit');
close(h)

h = figure; 

for iCycle = 1:size(cycles,2) % Looping through the -5 cycles, onset,  %####Took this out for now can add back in and +5 cycles after perturbation
    filename = ['CoMAcc ' subject1 ' ' 'Neg10' namePerceived];
    filenamePDF = strcat(filename, '.pdf');
    gcStart = RpertGC.RHS{iTrial}(cycles(iCycle));
    gcFin = RpertGC.RHS_2{iTrial}(cycles(iCycle));
    gcLen = RpertGC.RHS_2{iTrial}(cycles(iCycle)) - RpertGC.RHS{iTrial}(cycles(iCycle));
    subplot(3,1,1); plot((0:gcLen)/gcLen, dynamicStabilityTable.Sum_CoM_Acc{iTrial}(gcStart:gcFin,1),...
        'color', colors{iCycle}); title(['YAP' strSubject ' CoM Acc AP' ' ' num2str(Sp(iPerts)) ' ' namePerceived]); % Plotting the WBAM in the Frontal plane
    ylabel('m/s^2'); ylim([-0.01 0.01])
    hold on; 
    
    subplot(3,1,2); plot((0:gcLen)/gcLen, dynamicStabilityTable.Sum_CoM_Acc{iTrial}(gcStart:gcFin,2),...
        'color', colors{iCycle}); title(['YAP' strSubject ' CoM Acc ML']); % Plotting the WBAM in the Transverse plane
    ylabel('m/s^2'); ylim([-0.02 0.02])
    hold on; 
    
    subplot(3,1,3); plot((0:gcLen)/gcLen, dynamicStabilityTable.Sum_CoM_Acc{iTrial}(gcStart:gcFin,3),...
        'color', colors{iCycle}); title(['YAP' strSubject ' CoM Acc VT']); % Plotting the WBAM in the saggital plane 
    ylabel('m/s^2'); xlabel('% of Gait Cycle'); ylim([-0.01 0.01])
    hold on;             
    clear gcStart gcFin gcLen
end
saveas(h, filename);
print(filenamePDF, '-dpdf', '-bestfit');
close(h)


h = figure; 


for iCycle = 1:size(cycles,2) % Looping through the -5 cycles, onset,  %####Took this out for now can add back in and +5 cycles after perturbation
    filename = ['WBAM ' subject1 ' ' 'Neg10' namePerceived];
    filenamePDF = strcat(filename, '.pdf');
    gcStart = RpertGC.RHS{iTrial}(cycles(iCycle));
    gcFin = RpertGC.RHS_2{iTrial}(cycles(iCycle));
    gcLen = RpertGC.RHS_2{iTrial}(cycles(iCycle)) - RpertGC.RHS{iTrial}(cycles(iCycle));
    subplot(3,1,1); plot((0:gcLen)/gcLen, dynamicStabilityTable.WBAM{iTrial}(gcStart:gcFin,1),...
        'color', colors{iCycle}); title(['YAP' strSubject ' WBAM Frontal' ' ' num2str(Sp(iPerts)) ' ' namePerceived]); % Plotting the WBAM in the Frontal plane
    ylabel('kg*m^2 / s^2'); ylim([-5 5])
    hold on; 
    
    subplot(3,1,2); plot((0:gcLen)/gcLen, dynamicStabilityTable.WBAM{iTrial}(gcStart:gcFin,2),...
        'color', colors{iCycle}); title(['YAP' strSubject ' WBAM Transverse']); % Plotting the WBAM in the Transverse plane
    ylabel('kg*m^2 / s^2'); ylim([-5 5])
    hold on; 
    
    subplot(3,1,3); plot((0:gcLen)/gcLen, dynamicStabilityTable.WBAM{iTrial}(gcStart:gcFin,3),...
        'color', colors{iCycle}); title(['YAP' strSubject ' WBAM Sagittal']); % Plotting the WBAM in the saggital plane 
    ylabel('kg*m^2 / s^2'); xlabel('% of Gait Cycle'); ylim([-8 8])
    hold on;             
    clear gcStart gcFin gcLen
end
saveas(h, filename);
print(filenamePDF, '-dpdf', '-bestfit');
close(h)



iTrial = 3;
iPerts = 2;

namePerceived = 'Perceived';
rPerts = find(strcmp(RpertGC.Leg{iTrial}, 'R')); % Finding where the right leg perturbations are in the table for all GCs 
Sp = RpertGC.Speed{iTrial}(rPerts); % Finding the perturbation speeds in each trial 
per = RpertGC.Perceived{iTrial}(rPerts); % Getting whether or not the perturbations were perceived 
cycles = rPerts(iPerts)-5:1:rPerts(iPerts);


h = figure; 
for iCycle = 1:size(cycles,2) % Looping through the -5 cycles, onset,  %####Took this out for now can add back in and +5 cycles after perturbation
    filename = ['CoMPos ' subject1 ' ' 'Neg10' namePerceived];
    filenamePDF = strcat(filename, '.pdf');
    gcStart = RpertGC.RHS{iTrial}(cycles(iCycle));
    gcFin = RpertGC.RHS_2{iTrial}(cycles(iCycle));
    gcLen = RpertGC.RHS_2{iTrial}(cycles(iCycle)) - RpertGC.RHS{iTrial}(cycles(iCycle));
    subplot(3,1,1); plot((0:gcLen)/gcLen, dynamicStabilityTable.CoM_Pos{iTrial}(gcStart:gcFin,1),...
        'color', colors{iCycle}); title(['YAP' strSubject ' CoM Pos AP' ' ' num2str(Sp(iPerts)) ' ' namePerceived]); % Plotting the WBAM in the Frontal plane
    ylabel('m'); ylim([0.9 1.1])
    hold on; 
    
    subplot(3,1,2); plot((0:gcLen)/gcLen, dynamicStabilityTable.CoM_Pos{iTrial}(gcStart:gcFin,2),...
        'color', colors{iCycle}); title(['YAP' strSubject ' CoM Pos ML']); % Plotting the WBAM in the Transverse plane
    ylabel('m'); ylim([0.8 1])
    hold on; 
    
    subplot(3,1,3); plot((0:gcLen)/gcLen, dynamicStabilityTable.CoM_Pos{iTrial}(gcStart:gcFin,3),...
        'color', colors{iCycle}); title(['YAP' strSubject ' CoM Pos VT']); % Plotting the WBAM in the saggital plane 
    ylabel('m'); xlabel('% of Gait Cycle'); ylim([-0.65 -0.45])
    hold on;             
    clear gcStart gcFin gcLen
end

saveas(h, filename);
print(filenamePDF, '-dpdf', '-bestfit');
close(h)

h = figure; 

for iCycle = 1:size(cycles,2) % Looping through the -5 cycles, onset,  %####Took this out for now can add back in and +5 cycles after perturbation
    filename = ['CoMVel ' subject1 ' ' 'Neg10' namePerceived];
    filenamePDF = strcat(filename, '.pdf');
    gcStart = RpertGC.RHS{iTrial}(cycles(iCycle));
    gcFin = RpertGC.RHS_2{iTrial}(cycles(iCycle));
    gcLen = RpertGC.RHS_2{iTrial}(cycles(iCycle)) - RpertGC.RHS{iTrial}(cycles(iCycle));
    subplot(3,1,1); plot((0:gcLen)/gcLen, dynamicStabilityTable.CoM_Vel{iTrial}(gcStart:gcFin,1),...
        'color', colors{iCycle}); title(['YAP' strSubject ' CoM Vel AP' ' ' num2str(Sp(iPerts)) ' ' namePerceived]); % Plotting the WBAM in the Frontal plane
    ylabel('m/s'); ylim([-0.2 0.2])
    hold on; 
    
    subplot(3,1,2); plot((0:gcLen)/gcLen, dynamicStabilityTable.CoM_Vel{iTrial}(gcStart:gcFin,2),...
        'color', colors{iCycle}); title(['YAP' strSubject ' CoM Vel ML']); % Plotting the WBAM in the Transverse plane
    ylabel('m/s'); ylim([-0.3 0.3])
    hold on; 
    
    subplot(3,1,3); plot((0:gcLen)/gcLen, dynamicStabilityTable.CoM_Vel{iTrial}(gcStart:gcFin,3),...
        'color', colors{iCycle}); title(['YAP' strSubject ' CoM Vel VT']); % Plotting the WBAM in the saggital plane 
    ylabel('m/s'); xlabel('% of Gait Cycle');  ylim([-0.3 0.3])
    hold on;             
    clear gcStart gcFin gcLen
end

saveas(h, filename);
print(filenamePDF, '-dpdf', '-bestfit');
close(h)

h = figure; 

for iCycle = 1:size(cycles,2) % Looping through the -5 cycles, onset,  %####Took this out for now can add back in and +5 cycles after perturbation
    filename = ['CoMAcc ' subject1 ' ' 'Neg10' namePerceived];
    filenamePDF = strcat(filename, '.pdf');
    gcStart = RpertGC.RHS{iTrial}(cycles(iCycle));
    gcFin = RpertGC.RHS_2{iTrial}(cycles(iCycle));
    gcLen = RpertGC.RHS_2{iTrial}(cycles(iCycle)) - RpertGC.RHS{iTrial}(cycles(iCycle));
    subplot(3,1,1); plot((0:gcLen)/gcLen, dynamicStabilityTable.Sum_CoM_Acc{iTrial}(gcStart:gcFin,1),...
        'color', colors{iCycle}); title(['YAP' strSubject ' CoM Acc AP' ' ' num2str(Sp(iPerts)) ' ' namePerceived]); % Plotting the WBAM in the Frontal plane
    ylabel('m/s^2'); ylim([-0.01 0.01])
    hold on; 
    
    subplot(3,1,2); plot((0:gcLen)/gcLen, dynamicStabilityTable.Sum_CoM_Acc{iTrial}(gcStart:gcFin,2),...
        'color', colors{iCycle}); title(['YAP' strSubject ' CoM Acc ML']); % Plotting the WBAM in the Transverse plane
    ylabel('m/s^2'); ylim([-0.02 0.02])
    hold on; 
    
    subplot(3,1,3); plot((0:gcLen)/gcLen, dynamicStabilityTable.Sum_CoM_Acc{iTrial}(gcStart:gcFin,3),...
        'color', colors{iCycle}); title(['YAP' strSubject ' CoM Acc VT']); % Plotting the WBAM in the saggital plane 
    ylabel('m/s^2'); xlabel('% of Gait Cycle'); ylim([-0.01 0.01])
    hold on;             
    clear gcStart gcFin gcLen
end

saveas(h, filename);
print(filenamePDF, '-dpdf', '-bestfit');
close(h)

h = figure; 


for iCycle = 1:size(cycles,2) % Looping through the -5 cycles, onset,  %####Took this out for now can add back in and +5 cycles after perturbation
    filename = ['WBAM ' subject1 ' ' 'Neg10' namePerceived];
    filenamePDF = strcat(filename, '.pdf');
    gcStart = RpertGC.RHS{iTrial}(cycles(iCycle));
    gcFin = RpertGC.RHS_2{iTrial}(cycles(iCycle));
    gcLen = RpertGC.RHS_2{iTrial}(cycles(iCycle)) - RpertGC.RHS{iTrial}(cycles(iCycle));
    subplot(3,1,1); plot((0:gcLen)/gcLen, dynamicStabilityTable.WBAM{iTrial}(gcStart:gcFin,1),...
        'color', colors{iCycle}); title(['YAP' strSubject ' WBAM Frontal' ' ' num2str(Sp(iPerts)) ' ' namePerceived]); % Plotting the WBAM in the Frontal plane
    ylabel('m/s^2'); ylim([-5 5])
    hold on; 
    
    subplot(3,1,2); plot((0:gcLen)/gcLen, dynamicStabilityTable.WBAM{iTrial}(gcStart:gcFin,2),...
        'color', colors{iCycle}); title(['YAP' strSubject ' WBAM Transverse']); % Plotting the WBAM in the Transverse plane
    ylabel('m/s^2'); ylim([-5 5])
    hold on; 
    
    subplot(3,1,3); plot((0:gcLen)/gcLen, dynamicStabilityTable.WBAM{iTrial}(gcStart:gcFin,3),...
        'color', colors{iCycle}); title(['YAP' strSubject ' WBAM Sagittal']); % Plotting the WBAM in the saggital plane 
    ylabel('m/s^2'); xlabel('% of Gait Cycle'); ylim([-8 8])
    hold on;             
    clear gcStart gcFin gcLen
end

saveas(h, filename);
print(filenamePDF, '-dpdf', '-bestfit');
close(h)

clear 
home


%% Loading local plots for things 
strSubject = '10';
subject1 = ['YAPercep' strSubject];

load(['G:\Shared drives\NeuroMobLab\Projects\Perception\Processed Data\Dan\OpenSim\YAPercep Outputs\' subject1 '\Data Tables\BodyAnalysisTable_' subject1 '.mat'])
% load(['G:\Shared drives\NeuroMobLab\Projects\Perception\Processed Data\Dan\OpenSim\YAPercep Outputs\' subject1 '\Data Tables\MuscleTable_' subject1 '.mat'])
load(['G:\Shared drives\NeuroMobLab\Projects\Perception\Processed Data\Dan\Matlab Analysis\' subject1 '\Data Tables\SepTables_' subject1 '.mat'])
load(['G:\Shared drives\NeuroMobLab\Projects\Perception\Processed Data\Dan\OpenSim\YAPercep Outputs\' subject1 '\Data Tables\jointAnglesTable_' subject1 '.mat'])
load(['G:\Shared drives\NeuroMobLab\Projects\Perception\Processed Data\Dan\OpenSim\YAPercep Outputs\' subject1 '\Data Tables\headCalcStruc_' subject1 '.mat'])
load(['G:\Shared drives\NeuroMobLab\Projects\Perception\Processed Data\Dan\Matlab Analysis\' subject1 '\Data Tables\GCTables_' subject1 '.mat'])






%% Plotting Local 

iTrial = 3;
namePerceived = 'Perceived';
rPerts = find(strcmp(RpertGC.Leg{iTrial}, 'R')); % Finding where the right leg perturbations are in the table for all GCs 
Sp = RpertGC.Speed{iTrial}(rPerts); % Finding the perturbation speeds in each trial 
per = RpertGC.Perceived{iTrial}(rPerts); % Getting whether or not the perturbations were perceived 
iPerts = 2;
cycles = rPerts(iPerts)-5:1:rPerts(iPerts);

colors = {'#00876c'; '#4f9971'; '#7bab79'; '#a3bd86'; '#c9ce98'; '#000000' ;};
h = figure; 

for iCycle = 1:size(cycles,2)
    filename = ['Vision-Vest-Proprio ' subject1 ' ' 'Neg10' namePerceived];
    filenamePDF = strcat(filename, '.pdf');
    gcStart = RpertGC.RHS{iTrial}(cycles(iCycle));
    gcFin = RpertGC.RHS_2{iTrial}(cycles(iCycle));
    gcLen = RpertGC.RHS_2{iTrial}(cycles(iCycle)) - RpertGC.RHS{iTrial}(cycles(iCycle));
    subplot(3,2,1); plot((0:gcLen)/gcLen, jointAnglesTable.("R_Ankle_Angle_(Degrees)"){iTrial,1}(gcStart:gcFin),'color', colors{iCycle}); title('Right Ankle Angle'); % Plotting the cycle for the right ankle angle 
    hold on; ylim([-10 20]);
    subplot(3,2,2); plot((0:gcLen)/gcLen, jointAnglesTable.("R_Knee_Angle_(D)"){iTrial,1}(gcStart:gcFin),'color', colors{iCycle}); title('Right Knee Angle'); % Plotting the cycle for the right knee angle
    hold on; ylim([-90 15]);
    subplot(3,2,3); plot((0:gcLen)/gcLen, jointAnglesTable.("R_Hip_Flexion_Angle_(D)"){iTrial,1}(gcStart:gcFin),'color', colors{iCycle}); title('Right Hip Flexion Angle'); % Plotting the cycle for the right hip flexion angle
    hold on; ylim([-15 50]);
    subplot(3,2,4); plot((0:gcLen)/gcLen, headCalcStruc.("Percep02").headAngle(gcStart:gcFin,1), 'color', colors{iCycle}); title('Head Angle (degree)'); %Plotting the cycle for the head angle deviation 
    hold on; ylim([10 30]);
    subplot(3,2,5); plot((0:gcLen)/gcLen, headCalcStruc.("Percep02").headAngularVelocity(gcStart:gcFin,1), 'color', colors{iCycle}); title('Head Angular Velocity (degree/s)'); % Plotting the cycle for head angular velocity deviation
    hold on; ylim([-130 130]);
    clear gcStart gcFin gcLen
end

saveas(h, filename);
print(filenamePDF, '-dpdf', '-bestfit');
close(h)

h = figure;


for iCycle = 1:size(cycles,2)
    filename = ['Somatosensory ' subject1 ' ' 'Neg10' namePerceived];
    filenamePDF = strcat(filename, '.pdf');
    gcStart = RpertGC.RHS{iTrial}(cycles(iCycle));
    gcSwing = RpertGC.RTO{iTrial}(cycles(iCycle));
    gcStartA = gcStart*10;
    gcSwingA = gcSwing*10;
    gcLenA = gcSwingA-gcStartA;
    tRHM_AP = videoTable.("Marker_Data"){iTrial,1}(gcStart:gcSwing,30,1); % Right Heel Marker for AP 
    tRHM_ML = videoTable.("Marker_Data"){iTrial,1}(gcStart:gcSwing,30,2); % Right Heel Marker for ML 
    ext_RHM_AP = interp(tRHM_AP, 10);
    ext_RHM_ML = interp(tRHM_ML, 10);
    RHM_AP = ext_RHM_AP(1:length(analogTable.COP{iTrial,1}(gcStartA:gcSwingA,4)));
    RHM_ML = ext_RHM_ML(1:length(analogTable.COP{iTrial,1}(gcStartA:gcSwingA,5)));

    subplot(2,1,1); plot((0:gcLenA)/gcLenA*0.6, analogTable.COP{iTrial,1}(gcStartA:gcSwingA,4)- RHM_AP, 'color', colors{iCycle}); title('X CoP'); % Plotting the X direction CoP for the cycle
    hold on; ylim([-1000 500])
    subplot(2,1,2); plot((0:gcLenA)/gcLenA*0.6, analogTable.COP{iTrial,1}(gcStartA:gcSwingA,5)- RHM_ML, 'color', colors{iCycle}); title('Y CoP'); % Plotting the Y direction CoP for the cycle
    hold on; ylim([-400 100])
end


saveas(h, filename);
print(filenamePDF, '-dpdf', '-bestfit');
close(h)


iTrial = 1;
namePerceived = 'Not Perceived';
rPerts = find(strcmp(RpertGC.Leg{iTrial}, 'R')); % Finding where the right leg perturbations are in the table for all GCs 
Sp = RpertGC.Speed{iTrial}(rPerts); % Finding the perturbation speeds in each trial 
per = RpertGC.Perceived{iTrial}(rPerts); % Getting whether or not the perturbations were perceived 
iPerts = 2;
cycles = rPerts(iPerts)-5:1:rPerts(iPerts);

colors = {'#00876c'; '#4f9971'; '#7bab79'; '#a3bd86'; '#c9ce98'; '#000000' ;};
h = figure; 

for iCycle = 1:size(cycles,2)
    filename = ['Vision-Vest-Proprio ' subject1 ' ' 'Neg10' namePerceived];
    filenamePDF = strcat(filename, '.pdf');
    gcStart = RpertGC.RHS{iTrial}(cycles(iCycle));
    gcFin = RpertGC.RHS_2{iTrial}(cycles(iCycle));
    gcLen = RpertGC.RHS_2{iTrial}(cycles(iCycle)) - RpertGC.RHS{iTrial}(cycles(iCycle));
    subplot(3,2,1); plot((0:gcLen)/gcLen, jointAnglesTable.("R_Ankle_Angle_(Degrees)"){iTrial,1}(gcStart:gcFin),'color', colors{iCycle}); title('Right Ankle Angle'); % Plotting the cycle for the right ankle angle 
    hold on;ylim([-10 20]);
    subplot(3,2,2); plot((0:gcLen)/gcLen, jointAnglesTable.("R_Knee_Angle_(D)"){iTrial,1}(gcStart:gcFin),'color', colors{iCycle}); title('Right Knee Angle'); % Plotting the cycle for the right knee angle
    hold on; ylim([-90 15]);
    subplot(3,2,3); plot((0:gcLen)/gcLen, jointAnglesTable.("R_Hip_Flexion_Angle_(D)"){iTrial,1}(gcStart:gcFin),'color', colors{iCycle}); title('Right Hip Flexion Angle'); % Plotting the cycle for the right hip flexion angle
    hold on; ylim([-15 50]);
    subplot(3,2,4); plot((0:gcLen)/gcLen, headCalcStruc.("Percep03").headAngle(gcStart:gcFin,1), 'color', colors{iCycle}); title('Head Angle (degree)'); %Plotting the cycle for the head angle deviation 
    hold on; ylim([10 30]);
    subplot(3,2,5); plot((0:gcLen)/gcLen, headCalcStruc.("Percep03").headAngularVelocity(gcStart:gcFin,1), 'color', colors{iCycle}); title('Head Angular Velocity (degree/s)'); % Plotting the cycle for head angular velocity deviation
    hold on; ylim([-130 130]);
    clear gcStart gcFin gcLen
end

saveas(h, filename);
print(filenamePDF, '-dpdf', '-bestfit');
close(h)

h = figure;


for iCycle = 1:size(cycles,2)
    filename = ['Somatosensory ' subject1 ' ' 'Neg10' namePerceived];
    filenamePDF = strcat(filename, '.pdf');
    gcStart = RpertGC.RHS{iTrial}(cycles(iCycle));
    gcSwing = RpertGC.RTO{iTrial}(cycles(iCycle));
    gcStartA = gcStart*10;
    gcSwingA = gcSwing*10;
    gcLenA = gcSwingA-gcStartA;
    tRHM_AP = videoTable.("Marker_Data"){iTrial,1}(gcStart:gcSwing,30,1); % Right Heel Marker for AP 
    tRHM_ML = videoTable.("Marker_Data"){iTrial,1}(gcStart:gcSwing,30,2); % Right Heel Marker for ML 
    ext_RHM_AP = interp(tRHM_AP, 10);
    ext_RHM_ML = interp(tRHM_ML, 10);
    RHM_AP = ext_RHM_AP(1:length(analogTable.COP{iTrial,1}(gcStartA:gcSwingA,4)));
    RHM_ML = ext_RHM_ML(1:length(analogTable.COP{iTrial,1}(gcStartA:gcSwingA,5)));

    subplot(2,1,1); plot((0:gcLenA)/gcLenA*0.6, analogTable.COP{iTrial,1}(gcStartA:gcSwingA,4)- RHM_AP, 'color', colors{iCycle}); title('X CoP'); % Plotting the X direction CoP for the cycle
    hold on; ylim([-1000 500])
    subplot(2,1,2); plot((0:gcLenA)/gcLenA*0.6, analogTable.COP{iTrial,1}(gcStartA:gcSwingA,5)- RHM_ML, 'color', colors{iCycle}); title('Y CoP'); % Plotting the Y direction CoP for the cycle
    hold on; ylim([-400 100])
end


saveas(h, filename);
print(filenamePDF, '-dpdf', '-bestfit');
close(h)

