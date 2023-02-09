function checkNplotEMG(strSubject, domLeg)
% This function will create plots of unprocessed and processed emg side by
% side for the dominant leg for each individual perturbation during the perception experiment. 
% Each plot will be have the EMG signals broken down for the 12 muscles we
% collect by -5 gait cycles before the perturbation, the perturbed step,
% and +5 gait cycles after the perturbation. 
%  
%
%
%
% Inputs: 
% strSubject - string of the subject number (e.g. '10')
% domLeg - string of the dominant leg of the subject (e.g. 'R')

%
% Outputs: 
% None





%% Create subject name to load the necessary files for the subject 

subject1 = ['YAPercep' strSubject];

namePercep = {'Percep01'; 'Percep02'; 'Percep03'; 'Percep04'; 'Percep05'; 'Percep06';};

%% Creating the folder to save the plots for each subject

% Setting the location to the subjects' OpenSim Analysis folder 
if ispc
    subLoc = ['G:\Shared drives\NeuroMobLab\Projects\Perception\Processed Data\Dan\Matlab Analysis\' subject1];
elseif ismac
    subLoc = [''];
else
    subLoc = input('Please enter the location where the tables should be saved.' ,'s');
end


% Checking to see if an overall plotting folder exists in the subjects OpenSim results. 
% If it does not exist it will make one. 
if exist([subLoc filesep 'EMG Analysis'], 'dir') ~= 7
    mkdir(subLoc, 'EMG Analysis');
end

% Checking to see if a subfolder for the individual perturbation plots
% exist. 
if exist([subLoc filesep 'EMG Analysis' filesep 'Individual Perts' ], 'dir') ~= 7
    mkdir([subLoc filesep 'EMG Analysis'], 'Individual Perts')
end

% Setting the location to save the plots for each subject 
if ispc
    plotLoc1 = ['G:\Shared drives\NeuroMobLab\Projects\Perception\Processed Data\Dan\Matlab Analysis\' subject1 filesep 'EMG Analysis' filesep 'Individual Perts'];
elseif ismac
    plotLoc1 = [''];
else
    plotLoc1 = input('Please enter the location where the tables should be saved.' ,'s');
end

% Checking to see if a subfolder for the individual perturbation plots
% exist. 
if exist([subLoc filesep 'EMG Analysis' filesep 'Normalized EMG' ], 'dir') ~= 7
    mkdir([subLoc filesep 'EMG Analysis'], 'Normalized EMG')
end

% Setting the location to save the plots for each subject 
if ispc
    plotLoc2 = ['G:\Shared drives\NeuroMobLab\Projects\Perception\Processed Data\Dan\Matlab Analysis\' subject1 filesep 'EMG Analysis' filesep 'Normalized EMG'];
elseif ismac
    plotLoc2 = [''];
else
    plotLoc2 = input('Please enter the location where the tables should be saved.' ,'s');
end

%% Loading the necessary tables and structures
load(['G:\Shared drives\NeuroMobLab\Projects\Perception\Processed Data\Dan\Matlab Analysis\' subject1 '\Data Tables\SepTables_' subject1 '.mat'])
load(['G:\Shared drives\NeuroMobLab\Projects\Perception\Processed Data\Dan\Matlab Analysis\' subject1 '\Data Tables\pertTable_' subject1 '.mat'])
load(['G:\Shared drives\NeuroMobLab\Projects\Perception\Processed Data\Dan\Matlab Analysis\' subject1 '\Data Tables\pEmgStruct_' subject1 '.mat'])
load(['G:\Shared drives\NeuroMobLab\Projects\Perception\Processed Data\Dan\Matlab Analysis\' subject1 '\Data Tables\pertCycleStruc_' subject1 '.mat'])


%% Plot unprocessed EMG from -5 cycles before perturbation, Onset, +5 cycles after perturbation
tempName = analogTable.Trial; % Get the names of all trials from the subject
emgid = {'EMG_TA-R';'EMG_LGAS-R';'EMG_VLAT-R';'EMG_RFEM-R';'EMG_BFLH-R';'EMG_ADD-R';'EMG_TFL-R';'EMG_GMED-R';'EMG_TA-L';'EMG_LGAS-L';'EMG_VLAT-L';'EMG_RFEM-L';'EMG_BFLH-L';'EMG_ADD-L';'EMG_TFL-L';'EMG_GMED-L';'EMG_SOL-R';'EMG_PERO-R';'EMG_MGAS-R';'EMG_GMAX-R';'EMG_SOL-L';'EMG_PERO-L';'EMG_MGAS-L';'EMG_GMAX-L';'25';'26';'27';'28';'29';'30';'31';'32'};
nameFrames = {'Pre5Frames'; 'Pre4Frames'; 'Pre3Frames'; 'Pre2Frames'; 'Pre1Frames'; 'OnsetFrames'; 'Post1Frames'; 'Post2Frames'; 'Post3Frames'; 'Post4Frames'; 'Post5Frames';}; % -5 cycles before perturbation, Onset, and +5 cycles after perturbation
namePercep = {'Percep01'; 'Percep02'; 'Percep03'; 'Percep04'; 'Percep05'; 'Percep06';}; % name of the potential perception trials for each subject 
speeds = {'sp1'; 'sp2'; 'sp3'; 'sp4'; 'sp5'; 'sp6'; 'sp7'; 'sp8';}; % Speeds in order as above 0, -0.02, -0.5, -0.1, -0.15, -0.2, -0.3, -0.4
namePert = {'Catch'; 'Neg02'; 'Neg05'; 'Neg10'; 'Neg15'; 'Neg20'; 'Neg30'; 'Neg40';}; %Name of the perts to save the files
leg = {'L';'R'}; % Leg

pTrials = contains(pertTable.Trial, 'Percep'); % Finding which rows in the table contain the Perception Trials

pTrials = pTrials(pTrials == 1); %Selecting only the indicies that have Perception trials
colors = {'#00876c'; '#4f9971'; '#7bab79'; '#a3bd86'; '#c9ce98'; '#000000' ; '#e8c48b'; '#e5a76f'; '#e2885b'; '#dd6551'; '#d43d51'}; % Setting the colors to be chosen for each cycle plotted

% Finding the indices of the left and right emgs from emgid to be used to
% plot the muscles in the loop below
A = contains(emgid, '-L');
B = contains(emgid, '-R'); % Have to do this line because we have extra emg slots 25-32
emgL = emgid(A);
emgLidx = find(A);
emgR = emgid(B);
emgRidx = find(B);

% Picking the dominant leg for the subject based on what is fed into the
% function 
if contains(domLeg, 'L') 
    iLeg = 1; 
    cd(plotLoc1)

    % This loop will plot all the left leg muscles for the 5 cycles before, the
    % perturbed cycle, and the 5 cycles after the perturbation 
    for iSpeeds = 1:size(speeds,1) % The 8 different perturbation speeds as described in speeds
        for iTrial = 1:size(pTrials,1) % The perturbation trials, ie Percep01-PercepXX
            temp5 = size(pertCycleStruc.(leg{iLeg}).(speeds{iSpeeds}).(namePercep{iTrial}).Perceived,1); % Getting the amount of perturbations sent at a specific speed per Perception trial
            temgL = size(emgL,1)/4;
            for iEmgL = 1:temgL % This loop plots all the emgs collected on the Right leg for 1 subject 
                for iPerts = 1:temp5 % -5 cycles before Pert, Onset, and +5 cycles after
                    for iCycle = 1:size(nameFrames,1)
                        temp1 = pertCycleStruc.(leg{iLeg}).(speeds{iSpeeds}).(namePercep{iTrial}).(nameFrames{iCycle}){1,iPerts}(1); % first heel strike of gait cycle 
                        temp2 = pertCycleStruc.(leg{iLeg}).(speeds{iSpeeds}).(namePercep{iTrial}).(nameFrames{iCycle}){1,iPerts}(5); % ending heel strike of gait cycle
                        temp4 = pertCycleStruc.(leg{iLeg}).(speeds{iSpeeds}).(namePercep{iTrial}).(nameFrames{iCycle}){1,iPerts}(4); % Toe off for the leg of the first heel strike of the gait cycle 
                        temp1 = temp1*10; %Putting the sample rate back into 1000 Hz from 100 Hz
                        temp2 = temp2*10;
                        temp3 = temp2 - temp1; % Getting length of gait cycle as elasped frames

                        if isnan(temp1) || isnan(temp2) || isnan(temp3)

                        else  
                            perceived = pertCycleStruc.(leg{iLeg}).(speeds{iSpeeds}).(namePercep{iTrial}).Perceived(iPerts);
                            if perceived == 1
                                namePerceived = 'Perceived';
                            else
                                namePerceived = 'Not Perceived';
                            end
                            if iEmgL == 1 && iCycle == 1
                                h = figure('Name', ['EMG_1 ' subject1 ' ' leg{iLeg} ' ' namePert{iSpeeds} ' ' namePercep{iTrial} ' ' num2str(iPerts) ' ' namePerceived], 'NumberTitle', 'off', 'visible', 'off');
                                filename = ['EMG_1' subject1 '_' leg{iLeg} '_' namePert{iSpeeds} '_' namePercep{iTrial} '_' num2str(iPerts) '_' namePerceived];
                                filenamePDF = strcat(filename, '.pdf');
                                % Hardcoded the emgRidx numbers to
                                % correspond with the EMG ID that I want to
                                % plot as the label and to plot based on
                                % the leg. 12 muscles per leg
                                % INSERT LABELS OF MUSCLES HERE 
                                % ODD numbered subplots (left hand side)
                                % will be unprocessed EMG 
                                subplot(4,2,1); plot((0:temp3)/temp3, analogTable.EMG{iTrial,1}(temp1:temp2, emgLidx(1)),'color', colors{iCycle}); title(emgid(emgLidx(1))); 
                                hold on;
                                subplot(4,2,2); plot((0:temp3)/temp3, pEmgStruct.(tempName{iTrial})(temp1:temp2, emgLidx(1)), 'color', colors{iCycle}); title(emgid(emgLidx(1)));
                                hold on;
                                subplot(4,2,3); plot((0:temp3)/temp3, analogTable.EMG{iTrial,1}(temp1:temp2,emgLidx(2)), 'color', colors{iCycle}); title(emgid(emgLidx(2)));
                                hold on;
                                subplot(4,2,4); plot((0:temp3)/temp3, pEmgStruct.(tempName{iTrial})(temp1:temp2, emgLidx(2)), 'color', colors{iCycle}); title(emgid(emgLidx(2)));
                                hold on;
                                subplot(4,2,5); plot((0:temp3)/temp3, analogTable.EMG{iTrial,1}(temp1:temp2, emgLidx(3)), 'color', colors{iCycle}); title(emgid(emgLidx(3)));
                                hold on;
                                subplot(4,2,6); plot((0:temp3)/temp3, pEmgStruct.(tempName{iTrial})(temp1:temp2, emgLidx(3)), 'color', colors{iCycle}); title(emgid(emgLidx(3)));
                                hold on;
                                subplot(4,2,7); plot((0:temp3)/temp3, analogTable.EMG{iTrial,1}(temp1:temp2, emgLidx(4)), 'color', colors{iCycle}); title(emgid(emgLidx(4)));
                                hold on;
                                subplot(4,2,8); plot((0:temp3)/temp3, pEmgStruct.(tempName{iTrial})(temp1:temp2, emgLidx(4)), 'color', colors{iCycle}); title(emgid(emgLidx(4)));
                                hold on;
                            elseif iEmgL == 1 && iCycle ~= 1 
                                subplot(4,2,1); plot((0:temp3)/temp3, analogTable.EMG{iTrial,1}(temp1:temp2, emgLidx(1)),'color', colors{iCycle}); title(emgid(emgLidx(1))); 
                                hold on;
                                subplot(4,2,2); plot((0:temp3)/temp3, pEmgStruct.(tempName{iTrial})(temp1:temp2, emgLidx(1)), 'color', colors{iCycle}); title(emgid(emgLidx(1)));
                                hold on;
                                subplot(4,2,3); plot((0:temp3)/temp3, analogTable.EMG{iTrial,1}(temp1:temp2,emgLidx(2)), 'color', colors{iCycle}); title(emgid(emgLidx(2)));
                                hold on;
                                subplot(4,2,4); plot((0:temp3)/temp3, pEmgStruct.(tempName{iTrial})(temp1:temp2, emgLidx(2)), 'color', colors{iCycle}); title(emgid(emgLidx(2)));
                                hold on;
                                subplot(4,2,5); plot((0:temp3)/temp3, analogTable.EMG{iTrial,1}(temp1:temp2, emgLidx(3)), 'color', colors{iCycle}); title(emgid(emgLidx(3)));
                                hold on;
                                subplot(4,2,6); plot((0:temp3)/temp3, pEmgStruct.(tempName{iTrial})(temp1:temp2, emgLidx(3)), 'color', colors{iCycle}); title(emgid(emgLidx(3)));
                                hold on;
                                subplot(4,2,7); plot((0:temp3)/temp3, analogTable.EMG{iTrial,1}(temp1:temp2, emgLidx(4)), 'color', colors{iCycle}); title(emgid(emgLidx(4)));
                                hold on;
                                subplot(4,2,8); plot((0:temp3)/temp3, pEmgStruct.(tempName{iTrial})(temp1:temp2, emgLidx(4)), 'color', colors{iCycle}); title(emgid(emgLidx(4)));
                                hold on;
                            elseif iEmgL == 2 && iCycle == 1 
                                h2 = figure('Name', ['EMG_2 ' subject1 ' ' leg{iLeg} ' ' namePert{iSpeeds} ' ' namePercep{iTrial} ' ' num2str(iPerts) ' ' namePerceived], 'NumberTitle', 'off', 'visible', 'off');
                                filename2 = ['EMG_2' subject1 '_' leg{iLeg} '_' namePert{iSpeeds} '_' namePercep{iTrial} '_' num2str(iPerts) '_' namePerceived];
                                filenamePDF2 = strcat(filename2, '.pdf');
                                subplot(4,2,1); plot((0:temp3)/temp3, analogTable.EMG{iTrial,1}(temp1:temp2, emgLidx(5)),'color', colors{iCycle}); title(emgid(emgLidx(5))); 
                                hold on;
                                subplot(4,2,2); plot((0:temp3)/temp3, pEmgStruct.(tempName{iTrial})(temp1:temp2, emgLidx(5)), 'color', colors{iCycle}); title(emgid(emgLidx(5)));
                                hold on;
                                subplot(4,2,3); plot((0:temp3)/temp3, analogTable.EMG{iTrial,1}(temp1:temp2,emgLidx(6)), 'color', colors{iCycle}); title(emgid(emgLidx(6)));
                                hold on;
                                subplot(4,2,4); plot((0:temp3)/temp3, pEmgStruct.(tempName{iTrial})(temp1:temp2, emgLidx(6)), 'color', colors{iCycle}); title(emgid(emgLidx(6)));
                                hold on;
                                subplot(4,2,5); plot((0:temp3)/temp3, analogTable.EMG{iTrial,1}(temp1:temp2, emgLidx(7)), 'color', colors{iCycle}); title(emgid(emgLidx(7)));
                                hold on;
                                subplot(4,2,6); plot((0:temp3)/temp3, pEmgStruct.(tempName{iTrial})(temp1:temp2, emgLidx(7)), 'color', colors{iCycle}); title(emgid(emgLidx(7)));
                                hold on;
                                subplot(4,2,7); plot((0:temp3)/temp3, analogTable.EMG{iTrial,1}(temp1:temp2, emgLidx(8)), 'color', colors{iCycle}); title(emgid(emgLidx(8)));
                                hold on;
                                subplot(4,2,8); plot((0:temp3)/temp3, pEmgStruct.(tempName{iTrial})(temp1:temp2, emgLidx(8)), 'color', colors{iCycle}); title(emgid(emgLidx(8)));
                                hold on;
                            elseif iEmgL == 2 && iCycle ~= 1
                                subplot(4,2,1); plot((0:temp3)/temp3, analogTable.EMG{iTrial,1}(temp1:temp2, emgLidx(5)),'color', colors{iCycle}); title(emgid(emgLidx(5))); 
                                hold on;
                                subplot(4,2,2); plot((0:temp3)/temp3, pEmgStruct.(tempName{iTrial})(temp1:temp2, emgLidx(5)), 'color', colors{iCycle}); title(emgid(emgLidx(5)));
                                hold on;
                                subplot(4,2,3); plot((0:temp3)/temp3, analogTable.EMG{iTrial,1}(temp1:temp2,emgLidx(6)), 'color', colors{iCycle}); title(emgid(emgLidx(6)));
                                hold on;
                                subplot(4,2,4); plot((0:temp3)/temp3, pEmgStruct.(tempName{iTrial})(temp1:temp2, emgLidx(6)), 'color', colors{iCycle}); title(emgid(emgLidx(6)));
                                hold on;
                                subplot(4,2,5); plot((0:temp3)/temp3, analogTable.EMG{iTrial,1}(temp1:temp2, emgLidx(7)), 'color', colors{iCycle}); title(emgid(emgLidx(7)));
                                hold on;
                                subplot(4,2,6); plot((0:temp3)/temp3, pEmgStruct.(tempName{iTrial})(temp1:temp2, emgLidx(7)), 'color', colors{iCycle}); title(emgid(emgLidx(7)));
                                hold on;
                                subplot(4,2,7); plot((0:temp3)/temp3, analogTable.EMG{iTrial,1}(temp1:temp2, emgLidx(8)), 'color', colors{iCycle}); title(emgid(emgLidx(8)));
                                hold on;
                                subplot(4,2,8); plot((0:temp3)/temp3, pEmgStruct.(tempName{iTrial})(temp1:temp2, emgLidx(8)), 'color', colors{iCycle}); title(emgid(emgLidx(8)));
                                hold on;
                            elseif iEmgL == 3 && iCycle == 1
                                h3 = figure('Name', ['EMG_3 ' subject1 ' ' leg{iLeg} ' ' namePert{iSpeeds} ' ' namePercep{iTrial} ' ' num2str(iPerts) ' ' namePerceived], 'NumberTitle', 'off', 'visible', 'off');
                                filename3 = ['EMG_3' subject1 '_' leg{iLeg} '_' namePert{iSpeeds} '_' namePercep{iTrial} '_' num2str(iPerts) '_' namePerceived];
                                filenamePDF3 = strcat(filename3, '.pdf');
                                subplot(4,2,1); plot((0:temp3)/temp3, analogTable.EMG{iTrial,1}(temp1:temp2, emgLidx(9)),'color', colors{iCycle}); title(emgid(emgLidx(9))); 
                                hold on;
                                subplot(4,2,2); plot((0:temp3)/temp3, pEmgStruct.(tempName{iTrial})(temp1:temp2, emgLidx(9)), 'color', colors{iCycle}); title(emgid(emgLidx(9)));
                                hold on;
                                subplot(4,2,3); plot((0:temp3)/temp3, analogTable.EMG{iTrial,1}(temp1:temp2,emgLidx(10)), 'color', colors{iCycle}); title(emgid(emgLidx(10)));
                                hold on;
                                subplot(4,2,4); plot((0:temp3)/temp3, pEmgStruct.(tempName{iTrial})(temp1:temp2, emgLidx(10)), 'color', colors{iCycle}); title(emgid(emgLidx(10)));
                                hold on;
                                subplot(4,2,5); plot((0:temp3)/temp3, analogTable.EMG{iTrial,1}(temp1:temp2, emgLidx(11)), 'color', colors{iCycle}); title(emgid(emgLidx(11)));
                                hold on;
                                subplot(4,2,6); plot((0:temp3)/temp3, pEmgStruct.(tempName{iTrial})(temp1:temp2, emgLidx(11)), 'color', colors{iCycle}); title(emgid(emgLidx(11)));
                                hold on;
                                subplot(4,2,7); plot((0:temp3)/temp3, analogTable.EMG{iTrial,1}(temp1:temp2, emgLidx(12)), 'color', colors{iCycle}); title(emgid(emgLidx(12)));
                                hold on;
                                subplot(4,2,8); plot((0:temp3)/temp3, pEmgStruct.(tempName{iTrial})(temp1:temp2, emgLidx(12)), 'color', colors{iCycle}); title(emgid(emgLidx(12)));
                                hold on;
                            else 
                                subplot(4,2,1); plot((0:temp3)/temp3, analogTable.EMG{iTrial,1}(temp1:temp2, emgLidx(9)),'color', colors{iCycle}); title(emgid(emgLidx(9))); 
                                hold on;
                                subplot(4,2,2); plot((0:temp3)/temp3, pEmgStruct.(tempName{iTrial})(temp1:temp2, emgLidx(9)), 'color', colors{iCycle}); title(emgid(emgLidx(9)));
                                hold on;
                                subplot(4,2,3); plot((0:temp3)/temp3, analogTable.EMG{iTrial,1}(temp1:temp2,emgLidx(10)), 'color', colors{iCycle}); title(emgid(emgLidx(10)));
                                hold on;
                                subplot(4,2,4); plot((0:temp3)/temp3, pEmgStruct.(tempName{iTrial})(temp1:temp2, emgLidx(10)), 'color', colors{iCycle}); title(emgid(emgLidx(10)));
                                hold on;
                                subplot(4,2,5); plot((0:temp3)/temp3, analogTable.EMG{iTrial,1}(temp1:temp2, emgLidx(11)), 'color', colors{iCycle}); title(emgid(emgLidx(11)));
                                hold on;
                                subplot(4,2,6); plot((0:temp3)/temp3, pEmgStruct.(tempName{iTrial})(temp1:temp2, emgLidx(11)), 'color', colors{iCycle}); title(emgid(emgLidx(11)));
                                hold on;
                                subplot(4,2,7); plot((0:temp3)/temp3, analogTable.EMG{iTrial,1}(temp1:temp2, emgLidx(12)), 'color', colors{iCycle}); title(emgid(emgLidx(12)));
                                hold on;
                                subplot(4,2,8); plot((0:temp3)/temp3, pEmgStruct.(tempName{iTrial})(temp1:temp2, emgLidx(12)), 'color', colors{iCycle}); title(emgid(emgLidx(12)));
                                hold on;
                            end                    
                        end
                        clear temp1 temp2 temp 3 perceived namePerceived
                    end
                    if iEmgL == 1
                        set(h, 'visible', 'on');
                        saveas(h, filename);
                        print(filenamePDF, '-dpdf', '-bestfit');
                        close(h)
                        % This figure has TA, LGAS, VLAT, RFEM
                    elseif iEmgL == 2
                        set(h2, 'visible', 'on');
                        saveas(h2, filename2);
                        print(filenamePDF2, '-dpdf', '-bestfit');
                        close(h2)
                        % This figure has BFLH, ADD, TFL, GMED
                    else 
                        set(h3, 'visible', 'on');
                        saveas(h3, filename3);
                        print(filenamePDF3, '-dpdf', '-bestfit');
                        close(h3)
                        % This figure has SOL, PERO, MGAS, GMAX
                    end
                end

            end
        end
    end

else
    iLeg = 2;
    cd(plotLoc1)

    % This loop will plot all the Right leg muscles for the 5 cycles before, the
    % perturbed cycle, and the 5 cycles after the perturbation 
    for iSpeeds = 1:size(speeds,1) % The 8 different perturbation speeds as described in speeds
        for iTrial = 1:size(pTrials,1) % The perturbation trials, ie Percep01-PercepXX
            temp5 = size(pertCycleStruc.(leg{iLeg}).(speeds{iSpeeds}).(namePercep{iTrial}).Perceived,1); % Getting the amount of perturbations sent at a specific speed per Perception trial
            temgR = size(emgR,1)/4;
            for iEmgR = 1:temgR % This loop plots all the emgs collected on the Right leg for 1 subject 
                for iPerts = 1:temp5 % -5 cycles before Pert, Onset, and +5 cycles after
                    for iCycle = 1:size(nameFrames,1)
                        temp1 = pertCycleStruc.(leg{iLeg}).(speeds{iSpeeds}).(namePercep{iTrial}).(nameFrames{iCycle}){1,iPerts}(1); % first heel strike of gait cycle 
                        temp2 = pertCycleStruc.(leg{iLeg}).(speeds{iSpeeds}).(namePercep{iTrial}).(nameFrames{iCycle}){1,iPerts}(5); % ending heel strike of gait cycle
                        temp4 = pertCycleStruc.(leg{iLeg}).(speeds{iSpeeds}).(namePercep{iTrial}).(nameFrames{iCycle}){1,iPerts}(4); % Toe off for the leg of the first heel strike of the gait cycle 
                        temp1 = temp1* 10;
                        temp2 = temp2* 10;
                        temp3 = temp2 - temp1; % Getting length of gait cycle as elasped frames

                        if isnan(temp1) || isnan(temp2) || isnan(temp3)

                        else  
                            perceived = pertCycleStruc.(leg{iLeg}).(speeds{iSpeeds}).(namePercep{iTrial}).Perceived(iPerts);
                            if perceived == 1
                                namePerceived = 'Perceived';
                            else
                                namePerceived = 'Not Perceived';
                            end
                            if iEmgR == 1 && iCycle == 1
                                h = figure('Name', ['EMG_1 ' subject1 ' ' leg{iLeg} ' ' namePert{iSpeeds} ' ' namePercep{iTrial} ' ' num2str(iPerts) ' ' namePerceived], 'NumberTitle', 'off', 'visible', 'off');
                                filename = ['EMG_1' subject1 '_' leg{iLeg} '_' namePert{iSpeeds} '_' namePercep{iTrial} '_' num2str(iPerts) '_' namePerceived];
                                filenamePDF = strcat(filename, '.pdf');
                                % Hardcoded the emgRidx numbers to
                                % correspond with the EMG ID that I want to
                                % plot as the label and to plot based on
                                % the leg. 12 muscles per leg
                                % INSERT LABELS OF MUSCLES HERE 
                                % ODD numbered subplots (left hand side)
                                % will be unprocessed EMG 
                                subplot(4,2,1); plot((0:temp3)/temp3, analogTable.EMG{iTrial,1}(temp1:temp2, emgRidx(1)),'color', colors{iCycle}); title(emgid(emgRidx(1))); 
                                hold on;
                                subplot(4,2,2); plot((0:temp3)/temp3, pEmgStruct.(tempName{iTrial})(temp1:temp2, emgRidx(1)), 'color', colors{iCycle}); title(emgid(emgRidx(1)));
                                hold on;
                                subplot(4,2,3); plot((0:temp3)/temp3, analogTable.EMG{iTrial,1}(temp1:temp2,emgRidx(2)), 'color', colors{iCycle}); title(emgid(emgRidx(2)));
                                hold on;
                                subplot(4,2,4); plot((0:temp3)/temp3, pEmgStruct.(tempName{iTrial})(temp1:temp2, emgRidx(2)), 'color', colors{iCycle}); title(emgid(emgRidx(2)));
                                hold on;
                                subplot(4,2,5); plot((0:temp3)/temp3, analogTable.EMG{iTrial,1}(temp1:temp2, emgRidx(3)), 'color', colors{iCycle}); title(emgid(emgRidx(3)));
                                hold on;
                                subplot(4,2,6); plot((0:temp3)/temp3, pEmgStruct.(tempName{iTrial})(temp1:temp2, emgRidx(3)), 'color', colors{iCycle}); title(emgid(emgRidx(3)));
                                hold on;
                                subplot(4,2,7); plot((0:temp3)/temp3, analogTable.EMG{iTrial,1}(temp1:temp2, emgRidx(4)), 'color', colors{iCycle}); title(emgid(emgRidx(4)));
                                hold on;
                                subplot(4,2,8); plot((0:temp3)/temp3, pEmgStruct.(tempName{iTrial})(temp1:temp2, emgRidx(4)), 'color', colors{iCycle}); title(emgid(emgRidx(4)));
                                hold on;
                            elseif iEmgR == 1 && iCycle ~= 1 
                                subplot(4,2,1); plot((0:temp3)/temp3, analogTable.EMG{iTrial,1}(temp1:temp2, emgRidx(1)),'color', colors{iCycle}); title(emgid(emgRidx(1))); 
                                hold on;
                                subplot(4,2,2); plot((0:temp3)/temp3, pEmgStruct.(tempName{iTrial})(temp1:temp2, emgRidx(1)), 'color', colors{iCycle}); title(emgid(emgRidx(1)));
                                hold on;
                                subplot(4,2,3); plot((0:temp3)/temp3, analogTable.EMG{iTrial,1}(temp1:temp2,emgRidx(2)), 'color', colors{iCycle}); title(emgid(emgRidx(2)));
                                hold on;
                                subplot(4,2,4); plot((0:temp3)/temp3, pEmgStruct.(tempName{iTrial})(temp1:temp2, emgRidx(2)), 'color', colors{iCycle}); title(emgid(emgRidx(2)));
                                hold on;
                                subplot(4,2,5); plot((0:temp3)/temp3, analogTable.EMG{iTrial,1}(temp1:temp2, emgRidx(3)), 'color', colors{iCycle}); title(emgid(emgRidx(3)));
                                hold on;
                                subplot(4,2,6); plot((0:temp3)/temp3, pEmgStruct.(tempName{iTrial})(temp1:temp2, emgRidx(3)), 'color', colors{iCycle}); title(emgid(emgRidx(3)));
                                hold on;
                                subplot(4,2,7); plot((0:temp3)/temp3, analogTable.EMG{iTrial,1}(temp1:temp2, emgRidx(4)), 'color', colors{iCycle}); title(emgid(emgRidx(4)));
                                hold on;
                                subplot(4,2,8); plot((0:temp3)/temp3, pEmgStruct.(tempName{iTrial})(temp1:temp2, emgRidx(4)), 'color', colors{iCycle}); title(emgid(emgRidx(4)));
                                hold on;
                            elseif iEmgR == 2 && iCycle == 1 
                                h2 = figure('Name', ['EMG_2 ' subject1 ' ' leg{iLeg} ' ' namePert{iSpeeds} ' ' namePercep{iTrial} ' ' num2str(iPerts) ' ' namePerceived], 'NumberTitle', 'off', 'visible', 'off');
                                filename2 = ['EMG_2' subject1 '_' leg{iLeg} '_' namePert{iSpeeds} '_' namePercep{iTrial} '_' num2str(iPerts) '_' namePerceived];
                                filenamePDF2 = strcat(filename2, '.pdf');
                                subplot(4,2,1); plot((0:temp3)/temp3, analogTable.EMG{iTrial,1}(temp1:temp2, emgRidx(5)),'color', colors{iCycle}); title(emgid(emgRidx(5))); 
                                hold on;
                                subplot(4,2,2); plot((0:temp3)/temp3, pEmgStruct.(tempName{iTrial})(temp1:temp2, emgRidx(5)), 'color', colors{iCycle}); title(emgid(emgRidx(5)));
                                hold on;
                                subplot(4,2,3); plot((0:temp3)/temp3, analogTable.EMG{iTrial,1}(temp1:temp2,emgRidx(6)), 'color', colors{iCycle}); title(emgid(emgRidx(6)));
                                hold on;
                                subplot(4,2,4); plot((0:temp3)/temp3, pEmgStruct.(tempName{iTrial})(temp1:temp2, emgRidx(6)), 'color', colors{iCycle}); title(emgid(emgRidx(6)));
                                hold on;
                                subplot(4,2,5); plot((0:temp3)/temp3, analogTable.EMG{iTrial,1}(temp1:temp2, emgRidx(7)), 'color', colors{iCycle}); title(emgid(emgRidx(7)));
                                hold on;
                                subplot(4,2,6); plot((0:temp3)/temp3, pEmgStruct.(tempName{iTrial})(temp1:temp2, emgRidx(7)), 'color', colors{iCycle}); title(emgid(emgRidx(7)));
                                hold on;
                                subplot(4,2,7); plot((0:temp3)/temp3, analogTable.EMG{iTrial,1}(temp1:temp2, emgRidx(8)), 'color', colors{iCycle}); title(emgid(emgRidx(8)));
                                hold on;
                                subplot(4,2,8); plot((0:temp3)/temp3, pEmgStruct.(tempName{iTrial})(temp1:temp2, emgRidx(8)), 'color', colors{iCycle}); title(emgid(emgRidx(8)));
                                hold on;
                            elseif iEmgR == 2 && iCycle ~= 1
                                subplot(4,2,1); plot((0:temp3)/temp3, analogTable.EMG{iTrial,1}(temp1:temp2, emgRidx(5)),'color', colors{iCycle}); title(emgid(emgRidx(5))); 
                                hold on;
                                subplot(4,2,2); plot((0:temp3)/temp3, pEmgStruct.(tempName{iTrial})(temp1:temp2, emgRidx(5)), 'color', colors{iCycle}); title(emgid(emgRidx(5)));
                                hold on;
                                subplot(4,2,3); plot((0:temp3)/temp3, analogTable.EMG{iTrial,1}(temp1:temp2,emgRidx(6)), 'color', colors{iCycle}); title(emgid(emgRidx(6)));
                                hold on;
                                subplot(4,2,4); plot((0:temp3)/temp3, pEmgStruct.(tempName{iTrial})(temp1:temp2, emgRidx(6)), 'color', colors{iCycle}); title(emgid(emgRidx(6)));
                                hold on;
                                subplot(4,2,5); plot((0:temp3)/temp3, analogTable.EMG{iTrial,1}(temp1:temp2, emgRidx(7)), 'color', colors{iCycle}); title(emgid(emgRidx(7)));
                                hold on;
                                subplot(4,2,6); plot((0:temp3)/temp3, pEmgStruct.(tempName{iTrial})(temp1:temp2, emgRidx(7)), 'color', colors{iCycle}); title(emgid(emgRidx(7)));
                                hold on;
                                subplot(4,2,7); plot((0:temp3)/temp3, analogTable.EMG{iTrial,1}(temp1:temp2, emgRidx(8)), 'color', colors{iCycle}); title(emgid(emgRidx(8)));
                                hold on;
                                subplot(4,2,8); plot((0:temp3)/temp3, pEmgStruct.(tempName{iTrial})(temp1:temp2, emgRidx(8)), 'color', colors{iCycle}); title(emgid(emgRidx(8)));
                                hold on;
                            elseif iEmgR == 3 && iCycle == 1
                                h3 = figure('Name', ['EMG_3 ' subject1 ' ' leg{iLeg} ' ' namePert{iSpeeds} ' ' namePercep{iTrial} ' ' num2str(iPerts) ' ' namePerceived], 'NumberTitle', 'off', 'visible', 'off');
                                filename3 = ['EMG_3' subject1 '_' leg{iLeg} '_' namePert{iSpeeds} '_' namePercep{iTrial} '_' num2str(iPerts) '_' namePerceived];
                                filenamePDF3 = strcat(filename3, '.pdf');
                                subplot(4,2,1); plot((0:temp3)/temp3, analogTable.EMG{iTrial,1}(temp1:temp2, emgRidx(9)),'color', colors{iCycle}); title(emgid(emgRidx(9))); 
                                hold on;
                                subplot(4,2,2); plot((0:temp3)/temp3, pEmgStruct.(tempName{iTrial})(temp1:temp2, emgRidx(9)), 'color', colors{iCycle}); title(emgid(emgRidx(9)));
                                hold on;
                                subplot(4,2,3); plot((0:temp3)/temp3, analogTable.EMG{iTrial,1}(temp1:temp2,emgRidx(10)), 'color', colors{iCycle}); title(emgid(emgRidx(10)));
                                hold on;
                                subplot(4,2,4); plot((0:temp3)/temp3, pEmgStruct.(tempName{iTrial})(temp1:temp2, emgRidx(10)), 'color', colors{iCycle}); title(emgid(emgRidx(10)));
                                hold on;
                                subplot(4,2,5); plot((0:temp3)/temp3, analogTable.EMG{iTrial,1}(temp1:temp2, emgRidx(11)), 'color', colors{iCycle}); title(emgid(emgRidx(11)));
                                hold on;
                                subplot(4,2,6); plot((0:temp3)/temp3, pEmgStruct.(tempName{iTrial})(temp1:temp2, emgRidx(11)), 'color', colors{iCycle}); title(emgid(emgRidx(11)));
                                hold on;
                                subplot(4,2,7); plot((0:temp3)/temp3, analogTable.EMG{iTrial,1}(temp1:temp2, emgRidx(12)), 'color', colors{iCycle}); title(emgid(emgRidx(12)));
                                hold on;
                                subplot(4,2,8); plot((0:temp3)/temp3, pEmgStruct.(tempName{iTrial})(temp1:temp2, emgRidx(12)), 'color', colors{iCycle}); title(emgid(emgRidx(12)));
                                hold on;
                            else 
                                subplot(4,2,1); plot((0:temp3)/temp3, analogTable.EMG{iTrial,1}(temp1:temp2, emgRidx(9)),'color', colors{iCycle}); title(emgid(emgRidx(9))); 
                                hold on;
                                subplot(4,2,2); plot((0:temp3)/temp3, pEmgStruct.(tempName{iTrial})(temp1:temp2, emgRidx(9)), 'color', colors{iCycle}); title(emgid(emgRidx(9)));
                                hold on;
                                subplot(4,2,3); plot((0:temp3)/temp3, analogTable.EMG{iTrial,1}(temp1:temp2,emgRidx(10)), 'color', colors{iCycle}); title(emgid(emgRidx(10)));
                                hold on;
                                subplot(4,2,4); plot((0:temp3)/temp3, pEmgStruct.(tempName{iTrial})(temp1:temp2, emgRidx(10)), 'color', colors{iCycle}); title(emgid(emgRidx(10)));
                                hold on;
                                subplot(4,2,5); plot((0:temp3)/temp3, analogTable.EMG{iTrial,1}(temp1:temp2, emgRidx(11)), 'color', colors{iCycle}); title(emgid(emgRidx(11)));
                                hold on;
                                subplot(4,2,6); plot((0:temp3)/temp3, pEmgStruct.(tempName{iTrial})(temp1:temp2, emgRidx(11)), 'color', colors{iCycle}); title(emgid(emgRidx(11)));
                                hold on;
                                subplot(4,2,7); plot((0:temp3)/temp3, analogTable.EMG{iTrial,1}(temp1:temp2, emgRidx(12)), 'color', colors{iCycle}); title(emgid(emgRidx(12)));
                                hold on;
                                subplot(4,2,8); plot((0:temp3)/temp3, pEmgStruct.(tempName{iTrial})(temp1:temp2, emgRidx(12)), 'color', colors{iCycle}); title(emgid(emgRidx(12)));
                                hold on;
                            end                    
                        end
                        clear temp1 temp2 temp 3 perceived namePerceived
                    end
                    if iEmgR == 1
                        set(h, 'visible', 'on');
                        saveas(h, filename);
                        print(filenamePDF, '-dpdf', '-bestfit');
                        close(h)
                        % This figure has TA, LGAS, VLAT, RFEM
                    elseif iEmgR == 2
                        set(h2, 'visible', 'on');
                        saveas(h2, filename2);
                        print(filenamePDF2, '-dpdf', '-bestfit');
                        close(h2)
                        % This figure has BFLH, ADD, TFL, GMED
                    else 
                        set(h3, 'visible', 'on');
                        saveas(h3, filename3);
                        print(filenamePDF3, '-dpdf', '-bestfit');
                        close(h3)
                        % This figure has SOL, PERO, MGAS, GMAX
                    end
                end

            end
        end
    end
end
    

%% Plot Normalized EMG from -5 cycles before perturbation, Onset, +5 cycles after perturbation
nameFrames = {'Pre5Frames'; 'Pre4Frames'; 'Pre3Frames'; 'Pre2Frames'; 'Pre1Frames'; 'OnsetFrames'; 'Post1Frames'; 'Post2Frames'; 'Post3Frames'; 'Post4Frames'; 'Post5Frames';}; % -5 cycles before perturbation, Onset, and +5 cycles after perturbation
namePercep = {'Percep01'; 'Percep02'; 'Percep03'; 'Percep04'; 'Percep05'; 'Percep06';}; % name of the potential perception trials for each subject 
speeds = {'sp1'; 'sp2'; 'sp3'; 'sp4'; 'sp5'; 'sp6'; 'sp7'; 'sp8';}; % Speeds in order as above 0, -0.02, -0.5, -0.1, -0.15, -0.2, -0.3, -0.4
pertSpeed = {'0'; '-0.02'; '-0.05'; '-0.10'; '-0.15'; '-0.2'; '-0.3'; '-0.4';}; % Perturbation speeds for the table
namePert = {'Catch'; 'Neg02'; 'Neg05'; 'Neg10'; 'Neg15'; 'Neg20'; 'Neg30'; 'Neg40';}; %Name of the perts to save the files
leg = {'L';'R'}; % Leg

pTrials = contains(pertTable.Trial, 'Percep'); % Finding which rows in the table contain the Perception Trials

pTrials = pTrials(pTrials == 1); %Selecting only the indicies that have Perception trials
colors = {'#00876c'; '#4f9971'; '#7bab79'; '#a3bd86'; '#c9ce98'; '#000000' ; '#e8c48b'; '#e5a76f'; '#e2885b'; '#dd6551'; '#d43d51'}; % Setting the colors to be chosen for each cycle plotted

% Finding the indices of the left and right emgs from emgid to be used to
% plot the muscles in the loop below
A = contains(emgid, '-L');
B = contains(emgid, '-R'); % Have to do this line because we have extra emg slots 25-32
emgL = emgid(A);
emgLidx = find(A);
emgR = emgid(B);
emgRidx = find(B);

% Picking the dominant leg for the subject based on what is fed into the
% function 
if contains(domLeg, 'L') 
    iLeg = 1; 
    cd(plotLoc2)

    % This loop will plot all the left leg muscles for the 5 cycles before, the
    % perturbed cycle, and the 5 cycles after the perturbation 
    for iSpeeds = 1:size(speeds,1) % The 8 different perturbation speeds as described in speeds
        for iTrial = 1:size(pTrials,1) % The perturbation trials, ie Percep01-PercepXX
            temp5 = size(pertCycleStruc.(leg{iLeg}).(speeds{iSpeeds}).(namePercep{iTrial}).Perceived,1); % Getting the amount of perturbations sent at a specific speed per Perception trial
            temgL = size(emgL,1)/4;
            for iEmgL = 1:temgL % This loop plots all the emgs collected on the Right leg for 1 subject 
                for iPerts = 1:temp5 % -5 cycles before Pert, Onset, and +5 cycles after
                    for iCycle = 1:size(nameFrames,1)
                        temp1 = pertCycleStruc.(leg{iLeg}).(speeds{iSpeeds}).(namePercep{iTrial}).(nameFrames{iCycle}){1,iPerts}(1); % first heel strike of gait cycle 
                        temp2 = pertCycleStruc.(leg{iLeg}).(speeds{iSpeeds}).(namePercep{iTrial}).(nameFrames{iCycle}){1,iPerts}(5); % ending heel strike of gait cycle
                        temp4 = pertCycleStruc.(leg{iLeg}).(speeds{iSpeeds}).(namePercep{iTrial}).(nameFrames{iCycle}){1,iPerts}(4); % Toe off for the leg of the first heel strike of the gait cycle 
                        temp1 = temp1*10;
                        temp2 = temp2*10;
                        temp3 = temp2 - temp1; % Getting length of gait cycle as elasped frames
                        

                        if isnan(temp1) || isnan(temp2) || isnan(temp3)

                        else  
                            perceived = pertCycleStruc.(leg{iLeg}).(speeds{iSpeeds}).(namePercep{iTrial}).Perceived(iPerts);
                            if perceived == 1
                                namePerceived = 'Perceived';
                            else
                                namePerceived = 'Not Perceived';
                            end
                            if iEmgL == 1 && iCycle == 1
                                h = figure('Name', ['Norm_EMG_1 ' subject1 ' ' leg{iLeg} ' ' namePert{iSpeeds} ' ' namePercep{iTrial} ' ' num2str(iPerts) ' ' namePerceived], 'NumberTitle', 'off', 'visible', 'off');
                                filename = ['Norm_EMG_1' subject1 '_' leg{iLeg} '_' namePert{iSpeeds} '_' namePercep{iTrial} '_' num2str(iPerts) '_' namePerceived];
                                filenamePDF = strcat(filename, '.pdf');
                                % Hardcoded the emgRidx numbers to
                                % correspond with the EMG ID that I want to
                                % plot as the label and to plot based on
                                % the leg. 12 muscles per leg
                                % INSERT LABELS OF MUSCLES HERE  
                                subplot(4,1,1); plot((0:temp3)/temp3, npEmgStruct.(tempName{iTrial})(temp1:temp2, emgLidx(1)), 'color', colors{iCycle}); title(emgid(emgLidx(1)));
                                hold on;
                                subplot(4,1,2); plot((0:temp3)/temp3, npEmgStruct.(tempName{iTrial})(temp1:temp2, emgLidx(2)), 'color', colors{iCycle}); title(emgid(emgLidx(2)));
                                hold on;
                                subplot(4,1,3); plot((0:temp3)/temp3, npEmgStruct.(tempName{iTrial})(temp1:temp2, emgLidx(3)), 'color', colors{iCycle}); title(emgid(emgLidx(3)));
                                hold on;
                                subplot(4,1,4); plot((0:temp3)/temp3, npEmgStruct.(tempName{iTrial})(temp1:temp2, emgLidx(4)), 'color', colors{iCycle}); title(emgid(emgLidx(4)));
                                hold on;
                            elseif iEmgL == 1 && iCycle ~= 1 
                                subplot(4,1,1); plot((0:temp3)/temp3, npEmgStruct.(tempName{iTrial})(temp1:temp2, emgLidx(1)), 'color', colors{iCycle}); title(emgid(emgLidx(1)));
                                hold on;
                                subplot(4,1,2); plot((0:temp3)/temp3, npEmgStruct.(tempName{iTrial})(temp1:temp2, emgLidx(2)), 'color', colors{iCycle}); title(emgid(emgLidx(2)));
                                hold on;
                                subplot(4,1,3); plot((0:temp3)/temp3, npEmgStruct.(tempName{iTrial})(temp1:temp2, emgLidx(3)), 'color', colors{iCycle}); title(emgid(emgLidx(3)));
                                hold on;
                                subplot(4,1,4); plot((0:temp3)/temp3, npEmgStruct.(tempName{iTrial})(temp1:temp2, emgLidx(4)), 'color', colors{iCycle}); title(emgid(emgLidx(4)));
                                hold on;
                            elseif iEmgL == 2 && iCycle == 1 
                                h2 = figure('Name', ['Norm_EMG_2 ' subject1 ' ' leg{iLeg} ' ' namePert{iSpeeds} ' ' namePercep{iTrial} ' ' num2str(iPerts) ' ' namePerceived], 'NumberTitle', 'off', 'visible', 'off');
                                filename2 = ['Norm_EMG_2 ' subject1 '_' leg{iLeg} '_' namePert{iSpeeds} '_' namePercep{iTrial} '_' num2str(iPerts) '_' namePerceived];
                                filenamePDF2 = strcat(filename2, '.pdf');
                                subplot(4,1,1); plot((0:temp3)/temp3, npEmgStruct.(tempName{iTrial})(temp1:temp2, emgLidx(5)), 'color', colors{iCycle}); title(emgid(emgLidx(5)));
                                hold on;
                                subplot(4,1,2); plot((0:temp3)/temp3, npEmgStruct.(tempName{iTrial})(temp1:temp2, emgLidx(6)), 'color', colors{iCycle}); title(emgid(emgLidx(6)));
                                hold on;
                                subplot(4,1,3); plot((0:temp3)/temp3, npEmgStruct.(tempName{iTrial})(temp1:temp2, emgLidx(7)), 'color', colors{iCycle}); title(emgid(emgLidx(7)));
                                hold on;
                                subplot(4,1,4); plot((0:temp3)/temp3, npEmgStruct.(tempName{iTrial})(temp1:temp2, emgLidx(8)), 'color', colors{iCycle}); title(emgid(emgLidx(8)));
                                hold on;
                            elseif iEmgL == 2 && iCycle ~= 1
                                subplot(4,1,1); plot((0:temp3)/temp3, npEmgStruct.(tempName{iTrial})(temp1:temp2, emgLidx(5)), 'color', colors{iCycle}); title(emgid(emgLidx(5)));
                                hold on;
                                subplot(4,1,2); plot((0:temp3)/temp3, npEmgStruct.(tempName{iTrial})(temp1:temp2, emgLidx(6)), 'color', colors{iCycle}); title(emgid(emgLidx(6)));
                                hold on;
                                subplot(4,1,3); plot((0:temp3)/temp3, npEmgStruct.(tempName{iTrial})(temp1:temp2, emgLidx(7)), 'color', colors{iCycle}); title(emgid(emgLidx(7)));
                                hold on;
                                subplot(4,1,4); plot((0:temp3)/temp3, npEmgStruct.(tempName{iTrial})(temp1:temp2, emgLidx(8)), 'color', colors{iCycle}); title(emgid(emgLidx(8)));
                                hold on;
                            elseif iEmgL == 3 && iCycle == 1
                                h3 = figure('Name', ['EMG_3 ' subject1 ' ' leg{iLeg} ' ' namePert{iSpeeds} ' ' namePercep{iTrial} ' ' num2str(iPerts) ' ' namePerceived], 'NumberTitle', 'off', 'visible', 'off');
                                filename3 = ['EMG_3' subject1 '_' leg{iLeg} '_' namePert{iSpeeds} '_' namePercep{iTrial} '_' num2str(iPerts) '_' namePerceived];
                                filenamePDF3 = strcat(filename3, '.pdf');
                                subplot(4,1,1); plot((0:temp3)/temp3, npEmgStruct.(tempName{iTrial})(temp1:temp2, emgLidx(9)), 'color', colors{iCycle}); title(emgid(emgLidx(9)));
                                hold on;
                                subplot(4,1,2); plot((0:temp3)/temp3, npEmgStruct.(tempName{iTrial})(temp1:temp2, emgLidx(10)), 'color', colors{iCycle}); title(emgid(emgLidx(10)));
                                hold on;
                                subplot(4,1,3); plot((0:temp3)/temp3, npEmgStruct.(tempName{iTrial})(temp1:temp2, emgLidx(11)), 'color', colors{iCycle}); title(emgid(emgLidx(11)));
                                hold on;
                                subplot(4,1,4); plot((0:temp3)/temp3, npEmgStruct.(tempName{iTrial})(temp1:temp2, emgLidx(12)), 'color', colors{iCycle}); title(emgid(emgLidx(12)));
                                hold on;
                            else 
                                subplot(4,1,1); plot((0:temp3)/temp3, npEmgStruct.(tempName{iTrial})(temp1:temp2, emgLidx(9)), 'color', colors{iCycle}); title(emgid(emgLidx(9)));
                                hold on;
                                subplot(4,1,2); plot((0:temp3)/temp3, npEmgStruct.(tempName{iTrial})(temp1:temp2, emgLidx(10)), 'color', colors{iCycle}); title(emgid(emgLidx(10)));
                                hold on;
                                subplot(4,1,3); plot((0:temp3)/temp3, npEmgStruct.(tempName{iTrial})(temp1:temp2, emgLidx(11)), 'color', colors{iCycle}); title(emgid(emgLidx(11)));
                                hold on;
                                subplot(4,1,4); plot((0:temp3)/temp3, npEmgStruct.(tempName{iTrial})(temp1:temp2, emgLidx(12)), 'color', colors{iCycle}); title(emgid(emgLidx(12)));
                                hold on;
                            end                    
                        end
                        clear temp1 temp2 temp 3 perceived namePerceived
                    end
                    if iEmgL == 1
                        set(h, 'visible', 'on');
                        saveas(h, filename);
                        print(filenamePDF, '-dpdf', '-bestfit');
                        close(h)
                        % This figure has plots of TA, LGAS, VLAT, RFEM
                    elseif iEmgL == 2
                        set(h2, 'visible', 'on');
                        saveas(h2, filename2);
                        print(filenamePDF2, '-dpdf', '-bestfit');
                        close(h2)
                        % This figure has plots of BFLH, ADD, TFL, GMED
                    else 
                        set(h3, 'visible', 'on');
                        saveas(h3, filename3);
                        print(filenamePDF3, '-dpdf', '-bestfit');
                        close(h3)
                        % This figure has plots for SOL, PERO, MGAS, GMAX
                    end
                end

            end
        end
    end

else
    iLeg = 2;
    cd(plotLoc2)

    % This loop will plot all the left leg muscles for the 5 cycles before, the
    % perturbed cycle, and the 5 cycles after the perturbation 
    for iSpeeds = 1:size(speeds,1) % The 8 different perturbation speeds as described in speeds
        for iTrial = 1:size(pTrials,1) % The perturbation trials, ie Percep01-PercepXX
            temp5 = size(pertCycleStruc.(leg{iLeg}).(speeds{iSpeeds}).(namePercep{iTrial}).Perceived,1); % Getting the amount of perturbations sent at a specific speed per Perception trial
            temgR = size(emgR,1)/4;
            for iEmgR = 1:temgR % This loop plots all the emgs collected on the Right leg for 1 subject 
                for iPerts = 1:temp5 % -5 cycles before Pert, Onset, and +5 cycles after
                    for iCycle = 1:size(nameFrames,1)
                        temp1 = pertCycleStruc.(leg{iLeg}).(speeds{iSpeeds}).(namePercep{iTrial}).(nameFrames{iCycle}){1,iPerts}(1); % first heel strike of gait cycle 
                        temp2 = pertCycleStruc.(leg{iLeg}).(speeds{iSpeeds}).(namePercep{iTrial}).(nameFrames{iCycle}){1,iPerts}(5); % ending heel strike of gait cycle
                        temp4 = pertCycleStruc.(leg{iLeg}).(speeds{iSpeeds}).(namePercep{iTrial}).(nameFrames{iCycle}){1,iPerts}(4); % Toe off for the leg of the first heel strike of the gait cycle 
                        temp1 = temp1* 10;
                        temp2 = temp2* 10;
                        temp3 = temp2 - temp1; % Getting length of gait cycle as elasped frames

                        if isnan(temp1) || isnan(temp2) || isnan(temp3)

                        else  
                            perceived = pertCycleStruc.(leg{iLeg}).(speeds{iSpeeds}).(namePercep{iTrial}).Perceived(iPerts);
                            if perceived == 1
                                namePerceived = 'Perceived';
                            else
                                namePerceived = 'Not Perceived';
                            end
                            if iEmgR == 1 && iCycle == 1
                                h = figure('Name', ['Norm_EMG_1 ' subject1 ' ' leg{iLeg} ' ' namePert{iSpeeds} ' ' namePercep{iTrial} ' ' num2str(iPerts) ' ' namePerceived], 'NumberTitle', 'off', 'visible', 'off');
                                filename = ['Norm_EMG_1' subject1 '_' leg{iLeg} '_' namePert{iSpeeds} '_' namePercep{iTrial} '_' num2str(iPerts) '_' namePerceived];
                                filenamePDF = strcat(filename, '.pdf');
                                % Hardcoded the emgRidx numbers to
                                % correspond with the EMG ID that I want to
                                % plot as the label and to plot based on
                                % the leg. 12 muscles per leg
                                % INSERT LABELS OF MUSCLES HERE 
                                % ODD numbered subplots (left hand side)
                                % will be unprocessed EMG 
                                subplot(4,1,1); plot((0:temp3)/temp3, npEmgStruct.(tempName{iTrial})(temp1:temp2, emgRidx(1)), 'color', colors{iCycle}); title(emgid(emgRidx(1)));
                                hold on;
                                subplot(4,1,2); plot((0:temp3)/temp3, npEmgStruct.(tempName{iTrial})(temp1:temp2, emgRidx(2)), 'color', colors{iCycle}); title(emgid(emgRidx(2)));
                                hold on;
                                subplot(4,1,3); plot((0:temp3)/temp3, npEmgStruct.(tempName{iTrial})(temp1:temp2, emgRidx(3)), 'color', colors{iCycle}); title(emgid(emgRidx(3)));
                                hold on;
                                subplot(4,1,4); plot((0:temp3)/temp3, npEmgStruct.(tempName{iTrial})(temp1:temp2, emgRidx(4)), 'color', colors{iCycle}); title(emgid(emgRidx(4)));
                                hold on;
                            elseif iEmgR == 1 && iCycle ~= 1 
                                subplot(4,1,1); plot((0:temp3)/temp3, npEmgStruct.(tempName{iTrial})(temp1:temp2, emgRidx(1)), 'color', colors{iCycle}); title(emgid(emgRidx(1)));
                                hold on;
                                subplot(4,1,2); plot((0:temp3)/temp3, npEmgStruct.(tempName{iTrial})(temp1:temp2, emgRidx(2)), 'color', colors{iCycle}); title(emgid(emgRidx(2)));
                                hold on;
                                subplot(4,1,3); plot((0:temp3)/temp3, npEmgStruct.(tempName{iTrial})(temp1:temp2, emgRidx(3)), 'color', colors{iCycle}); title(emgid(emgRidx(3)));
                                hold on;
                                subplot(4,1,4); plot((0:temp3)/temp3, npEmgStruct.(tempName{iTrial})(temp1:temp2, emgRidx(4)), 'color', colors{iCycle}); title(emgid(emgRidx(4)));
                                hold on;
                            elseif iEmgR == 2 && iCycle == 1 
                                h2 = figure('Name', ['Norm_EMG_2 ' subject1 ' ' leg{iLeg} ' ' namePert{iSpeeds} ' ' namePercep{iTrial} ' ' num2str(iPerts) ' ' namePerceived], 'NumberTitle', 'off', 'visible', 'off');
                                filename2 = ['Norm_EMG_2' subject1 '_' leg{iLeg} '_' namePert{iSpeeds} '_' namePercep{iTrial} '_' num2str(iPerts) '_' namePerceived];
                                filenamePDF2 = strcat(filename2, '.pdf');
                                subplot(4,1,1); plot((0:temp3)/temp3, npEmgStruct.(tempName{iTrial})(temp1:temp2, emgRidx(5)), 'color', colors{iCycle}); title(emgid(emgRidx(5)));
                                hold on;
                                subplot(4,1,2); plot((0:temp3)/temp3, npEmgStruct.(tempName{iTrial})(temp1:temp2, emgRidx(6)), 'color', colors{iCycle}); title(emgid(emgRidx(6)));
                                hold on;
                                subplot(4,1,3); plot((0:temp3)/temp3, npEmgStruct.(tempName{iTrial})(temp1:temp2, emgRidx(7)), 'color', colors{iCycle}); title(emgid(emgRidx(7)));
                                hold on;
                                subplot(4,1,4); plot((0:temp3)/temp3, npEmgStruct.(tempName{iTrial})(temp1:temp2, emgRidx(8)), 'color', colors{iCycle}); title(emgid(emgRidx(8)));
                                hold on;
                            elseif iEmgR == 2 && iCycle ~= 1
                                subplot(4,1,1); plot((0:temp3)/temp3, npEmgStruct.(tempName{iTrial})(temp1:temp2, emgRidx(5)), 'color', colors{iCycle}); title(emgid(emgRidx(5)));
                                hold on;
                                subplot(4,1,2); plot((0:temp3)/temp3, npEmgStruct.(tempName{iTrial})(temp1:temp2, emgRidx(6)), 'color', colors{iCycle}); title(emgid(emgRidx(6)));
                                hold on;
                                subplot(4,1,3); plot((0:temp3)/temp3, npEmgStruct.(tempName{iTrial})(temp1:temp2, emgRidx(7)), 'color', colors{iCycle}); title(emgid(emgRidx(7)));
                                hold on;
                                subplot(4,1,4); plot((0:temp3)/temp3, npEmgStruct.(tempName{iTrial})(temp1:temp2, emgRidx(8)), 'color', colors{iCycle}); title(emgid(emgRidx(8)));
                                hold on;
                            elseif iEmgR == 3 && iCycle == 1
                                h3 = figure('Name', ['Norm_EMG_3 ' subject1 ' ' leg{iLeg} ' ' namePert{iSpeeds} ' ' namePercep{iTrial} ' ' num2str(iPerts) ' ' namePerceived], 'NumberTitle', 'off', 'visible', 'off');
                                filename3 = ['Norm_EMG_3' subject1 '_' leg{iLeg} '_' namePert{iSpeeds} '_' namePercep{iTrial} '_' num2str(iPerts) '_' namePerceived];
                                filenamePDF3 = strcat(filename3, '.pdf');
                                subplot(4,1,1); plot((0:temp3)/temp3, npEmgStruct.(tempName{iTrial})(temp1:temp2, emgRidx(9)), 'color', colors{iCycle}); title(emgid(emgRidx(9)));
                                hold on;
                                subplot(4,1,2); plot((0:temp3)/temp3, npEmgStruct.(tempName{iTrial})(temp1:temp2, emgRidx(10)), 'color', colors{iCycle}); title(emgid(emgRidx(10)));
                                hold on;
                                subplot(4,1,3); plot((0:temp3)/temp3, npEmgStruct.(tempName{iTrial})(temp1:temp2, emgRidx(11)), 'color', colors{iCycle}); title(emgid(emgRidx(11)));
                                hold on;
                                subplot(4,1,4); plot((0:temp3)/temp3, npEmgStruct.(tempName{iTrial})(temp1:temp2, emgRidx(12)), 'color', colors{iCycle}); title(emgid(emgRidx(12)));
                                hold on;
                            else 
                                subplot(4,1,1); plot((0:temp3)/temp3, npEmgStruct.(tempName{iTrial})(temp1:temp2, emgRidx(9)), 'color', colors{iCycle}); title(emgid(emgRidx(9)));
                                hold on;
                                subplot(4,1,2); plot((0:temp3)/temp3, npEmgStruct.(tempName{iTrial})(temp1:temp2, emgRidx(10)), 'color', colors{iCycle}); title(emgid(emgRidx(10)));
                                hold on;
                                subplot(4,1,3); plot((0:temp3)/temp3, npEmgStruct.(tempName{iTrial})(temp1:temp2, emgRidx(11)), 'color', colors{iCycle}); title(emgid(emgRidx(11)));
                                hold on;
                                subplot(4,1,4); plot((0:temp3)/temp3, npEmgStruct.(tempName{iTrial})(temp1:temp2, emgRidx(12)), 'color', colors{iCycle}); title(emgid(emgRidx(12)));
                                hold on;
                            end                    
                        end
                        clear temp1 temp2 temp 3 perceived namePerceived
                    end
                    if iEmgR == 1
                        set(h, 'visible', 'on');
                        saveas(h, filename);
                        print(filenamePDF, '-dpdf', '-bestfit');
                        close(h)
                        % This figure has plots for TA, LGAS, VLAT, RFEM
                    elseif iEmgR == 2
                        set(h2, 'visible', 'on');
                        saveas(h2, filename2);
                        print(filenamePDF2, '-dpdf', '-bestfit');
                        close(h2)
                        % This figure has plots for BFLH, ADD, TFL, GMED
                    else 
                        set(h3, 'visible', 'on');
                        saveas(h3, filename3);
                        print(filenamePDF3, '-dpdf', '-bestfit');
                        close(h3)
                        % This figure has plots for SOL, PERO, MGAS, GMAX
                    end
                end

            end
        end
    end
end



end

