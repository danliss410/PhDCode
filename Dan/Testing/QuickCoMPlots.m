clear 
% close all
clc
home

subject1 = 'YAPercep03';

% Loading the Dynamic Stability Table and Right Legged Perturbation GC
% Table.
load(['G:\Shared drives\NeuroMobLab\Projects\Perception\Processed Data\Dan\OpenSim\YAPercep Outputs\' subject1 '\Data Tables\dynamicStabilityTable_' subject1 '.mat'])
load(['G:\Shared drives\NeuroMobLab\Projects\Perception\Processed Data\Dan\Matlab Analysis\' subject1 '\Data Tables\GCTables_' subject1 '.mat'])
% Setting the location to the subjects' OpenSim Analysis folder 
if ispc
    subLoc = ['G:\Shared drives\NeuroMobLab\LabMemberFolders\Dan\PlotsToLookAt\PerceptionPlots\' subject1];
elseif ismac
    subLoc = [''];
else
    subLoc = input('Please enter the location where the tables should be saved.' ,'s');
end

% Checking to see if a subfolder for the CoM indiv. perts plots
% exist. 
if exist([subLoc filesep 'CoM' ], 'dir') ~= 7
    mkdir([subLoc filesep], 'CoM')
end

plotLoc = [subLoc filesep 'CoM'];
%% CoM Pos Dev 
nameFrames = {'Pre5Frames'; 'Pre4Frames'; 'Pre3Frames'; 'Pre2Frames'; 'Pre1Frames'; 'OnsetFrames';};% 'Post1Frames'; 'Post2Frames'; 'Post3Frames'; 'Post4Frames'; 'Post5Frames';}; % -5 cycles before perturbation, Onset, and +5 cycles after perturbation
namePercep = {'Percep02'; 'Percep03'; 'Percep04'; 'Percep05'; 'Percep06';}; %'Percep01';  % name of the potential perception trials for each subject 
speeds = {'sp1'; 'sp2'; 'sp3'; 'sp4'; 'sp5'; 'sp6'; 'sp7'; 'sp8';}; % Speeds in order as above 0, -0.02, -0.5, -0.1, -0.15, -0.2, -0.3, -0.4
pertSpeed = {'0'; '-0.02'; '-0.05'; '-0.10'; '-0.15'; '-0.2'; '-0.3'; '-0.4';}; % Perturbation speeds for the table
namePert = {'Catch'; 'Neg02'; 'Neg05'; 'Neg10'; 'Neg15'; 'Neg20'; 'Neg30'; 'Neg40';}; %Name of the perts to save the files

pTrials = contains(LpertGC.Trial, 'Percep'); % Finding which rows in the table contain the Perception Trials

pTrials = pTrials(pTrials == 1); %Selecting only the indicies that have Perception trials
colors = {'#00876c'; '#4f9971'; '#7bab79'; '#a3bd86'; '#c9ce98'; '#000000' ;};% '#e8c48b'; '#e5a76f'; '#e2885b'; '#dd6551'; '#d43d51'}; % Setting the colors to be chosen for each cycle plotted


cd(plotLoc);
for iTrial = 1:size(pTrials,1) % The perturbation trials, i.e. Percep01-PercepXX
    rPerts = find(strcmp(LpertGC.Leg{iTrial}, 'L')); % Finding where the right leg perturbations are in the table for all GCs 
    Sp = LpertGC.Speed{iTrial}(rPerts); % Finding the perturbation speeds in each trial 
    per = LpertGC.Perceived{iTrial}(rPerts); % Getting whether or not the perturbations were perceived 
    for iPerts = 1:size(rPerts,1) % The amount of R leg perturbations sent during the perception trial
        perceived = per{iPerts};
        if perceived == 1
            namePerceived = 'Perceived';
        else
            namePerceived = 'Not Perceived';
        end
        tempA = contains(pertSpeed, num2str(Sp(iPerts)));
        nameP = namePert{tempA};

        h = figure('Name', ['CoM Pos Dev ' subject1 ' L leg ' nameP ' ' namePerceived ' ' namePercep{iTrial} ' ' num2str(iPerts)], 'NumberTitle', 'off');
        filename = ['CoM Pos Dev ' subject1 ' L leg ' nameP ' ' namePercep{iTrial} ' ' num2str(iPerts)];
        filenamePDF = strcat(filename, '.pdf');
        
% 
%         if iTrial == 1  && iPerts == 1
%             cycles = rPerts(iPerts)-4:1:rPerts(iPerts);
%             colors = colors(2:end);
%         elseif iTrial == 2 && iPerts == 1
%             cycles = rPerts(iPerts)-4:1:rPerts(iPerts);
%             colors = colors(2:end);
%         elseif iTrial == 3 && iPerts == 1
%             cycles = rPerts(iPerts)-4:1:rPerts(iPerts);
%             colors = colors(3:end);
%         else
%             Getting the GCs for each perturbation 
            cycles = rPerts(iPerts)-5:1:rPerts(iPerts);
            colors = {'#00876c'; '#4f9971'; '#7bab79'; '#a3bd86'; '#c9ce98'; '#000000' ;};
%         end
        for iCycle = 1:size(cycles,2) % Looping through the -5 cycles, onset,  %####Took this out for now can add back in and +5 cycles after perturbation
            gcStart = LpertGC.LHS{iTrial}(cycles(iCycle));
            gcFin = LpertGC.LHS_2{iTrial}(cycles(iCycle));
            gcLen = LpertGC.LHS_2{iTrial}(cycles(iCycle)) - LpertGC.LHS{iTrial}(cycles(iCycle));
% 
            subplot(3,1,1);
            plot((0:gcLen)/gcLen, dynamicStabilityTable.Sum_CoM_Pos{iTrial,1}(gcStart:gcFin,1)-dynamicStabilityTable.Sum_CoM_Pos{iTrial,1}(gcStart,1) ,'color', colors{iCycle});
            hold on;
            xlabel('% of Gait Cycle');
            ylabel('Meters'); 
            title('CoM AP Pos Dev'); 

            subplot(3,1,2); 
            plot((0:gcLen)/gcLen, dynamicStabilityTable.Sum_CoM_Pos{iTrial,1}(gcStart:gcFin,3)-dynamicStabilityTable.Sum_CoM_Pos{iTrial,1}(gcStart,3), 'color', colors{iCycle});
            hold on;
            xlabel('% of Gait Cycle');
            ylabel('Meters'); 
            title('CoM ML Pos Dev'); 
            
            subplot(3,1,3); 
            plot((0:gcLen)/gcLen, dynamicStabilityTable.Sum_CoM_Pos{iTrial,1}(gcStart:gcFin,2)-dynamicStabilityTable.Sum_CoM_Pos{iTrial,1}(gcStart,2), 'color', colors{iCycle});
            hold on;
            ylabel('Meters'); xlabel('% of Gait Cycle');
            title('CoM Vert Pos Dev');
            hold on;             
            clear gcStart gcFin gcLen

        end
        saveas(h, filename);
        print(filenamePDF, '-dpdf', '-bestfit');
        close(h)
    end
end


%% CoM Vel 
for iTrial = 1:size(pTrials,1) % The perturbation trials, i.e. Percep01-PercepXX
    rPerts = find(strcmp(LpertGC.Leg{iTrial}, 'L')); % Finding where the right leg perturbations are in the table for all GCs 
    Sp = LpertGC.Speed{iTrial}(rPerts); % Finding the perturbation speeds in each trial 
    per = LpertGC.Perceived{iTrial}(rPerts); % Getting whether or not the perturbations were perceived 
    for iPerts = 1:size(rPerts,1) % The amount of R leg perturbations sent during the perception trial
        perceived = per{iPerts};
        if perceived == 1
            namePerceived = 'Perceived';
        else
            namePerceived = 'Not Perceived';
        end
        tempA = contains(pertSpeed, num2str(Sp(iPerts)));
        nameP = namePert{tempA};

        h = figure('Name', ['CoM Vel ' subject1 ' L leg ' nameP ' ' namePerceived ' ' namePercep{iTrial} ' ' num2str(iPerts)], 'NumberTitle', 'off');
        filename = ['CoM Vel ' subject1 ' L leg ' nameP ' ' namePercep{iTrial} ' ' num2str(iPerts)];
        filenamePDF = strcat(filename, '.pdf');
        

%         if iTrial == 1  && iPerts == 1
%             cycles = rPerts(iPerts)-4:1:rPerts(iPerts);
%             colors = colors(2:end);
%         elseif iTrial == 2 && iPerts == 1
%             cycles = rPerts(iPerts)-4:1:rPerts(iPerts);
%             colors = colors(2:end);
%         elseif iTrial == 3 && iPerts == 1
%             cycles = rPerts(iPerts)-4:1:rPerts(iPerts);
%             colors = colors(2:end);
%         else
%             Getting the GCs for each perturbation 
            cycles = rPerts(iPerts)-5:1:rPerts(iPerts);
            colors = {'#00876c'; '#4f9971'; '#7bab79'; '#a3bd86'; '#c9ce98'; '#000000' ;};
%         end
        for iCycle = 1:size(cycles,2) % Looping through the -5 cycles, onset,  %####Took this out for now can add back in and +5 cycles after perturbation
            gcStart = LpertGC.LHS{iTrial}(cycles(iCycle));
            gcFin = LpertGC.LHS_2{iTrial}(cycles(iCycle));
            gcLen = LpertGC.LHS_2{iTrial}(cycles(iCycle)) - LpertGC.LHS{iTrial}(cycles(iCycle));
% 
            subplot(3,1,1);
            plot((0:gcLen)/gcLen, dynamicStabilityTable.Sum_CoM_Vel{iTrial,1}(gcStart:gcFin,1),'color', colors{iCycle});
            hold on;
            xlabel('% of Gait Cycle');
            ylabel('Meters'); 
            title('CoM AP Vel'); 

            subplot(3,1,2); 
            plot((0:gcLen)/gcLen, dynamicStabilityTable.Sum_CoM_Vel{iTrial,1}(gcStart:gcFin,3), 'color', colors{iCycle});
            hold on;
            xlabel('% of Gait Cycle');
            ylabel('Meters'); 
            title('CoM ML Vel'); 
            
            subplot(3,1,3); 
            plot((0:gcLen)/gcLen, dynamicStabilityTable.Sum_CoM_Vel{iTrial,1}(gcStart:gcFin,2), 'color', colors{iCycle});
            hold on;
            ylabel('Meters'); xlabel('% of Gait Cycle');
            title('CoM Vert Vel');
            hold on;             
            clear gcStart gcFin gcLen

        end
        saveas(h, filename);
        print(filenamePDF, '-dpdf', '-bestfit');
        close(h)
    end
end