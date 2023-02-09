function [pertCycleStruc] = calcPertCycleNFrames(strSubject)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

%% Create subject name to load the necessary files for the subject 
% Naming convention for each log file "YAPercep##_" + YesNo or 2AFC or Cog

subjectYesNo = ['YAPercep' strSubject '_YesNo'];

subject2AFC = ['YAPercep' strSubject '_2AFC'];

subjectCog = ['YAPercep' strSubject '_Cog'];

subject1 = ['YAPercep' strSubject];

namePercep = {'Percep01';'Percep02'; 'Percep03'; 'Percep04'; 'Percep05'; 'Percep06';}; % 
%% Loading the remaining tables for the subject 
% This section will load analogTable, gaitEventsTable,

load(['G:\Shared drives\NeuroMobLab\Projects\Perception\Processed Data\Dan\Matlab Analysis\' subject1 '\Data Tables\SepTables_' subject1 '.mat'])
load(['G:\Shared drives\NeuroMobLab\Projects\Perception\Processed Data\Dan\Matlab Analysis\' subject1 '\Data Tables\pertTable_' subject1 '.mat'])
%% Find the gait cycles and frames for the perturbation information 

pTrials = contains(pertTable.Trial, 'Percep'); % Finding which rows in the table contain the Perception Trials

pTrials = pTrials(pTrials == 1); %Selecting only the indicies that have Perception trials



% This loop gets the gait cycle numbers for the gait cycle before
% perturbation and 1-3 gait cycles after the perturbation 
for iTrials = 1:size(pTrials,1)
    Lgc.b45{iTrials} = pertTable.("Left_Gait_Cycle_Num"){iTrials}-5; % Left gait cycle 5 before perturbation
    Lgc.b44{iTrials} = pertTable.("Left_Gait_Cycle_Num"){iTrials}-4; % Left gait cycle 4 before perturbation
    Lgc.b43{iTrials} = pertTable.("Left_Gait_Cycle_Num"){iTrials}-3; % Left gait cycle 3 before perturbation
    Lgc.b42{iTrials} = pertTable.("Left_Gait_Cycle_Num"){iTrials}-2; % Left gait cycle 2 steps before perturbation
    Lgc.b4{iTrials} = pertTable.("Left_Gait_Cycle_Num"){iTrials}-1; % Left gait cycle before perturbation
    Lgc.P0{iTrials} = pertTable.("Left_Gait_Cycle_Num"){iTrials}; % Left gait cycle the perturbation occurs on 
    Lgc.P1{iTrials} = pertTable.("Left_Gait_Cycle_Num"){iTrials}+1; % Left gait cycle one after perturbation
    Lgc.P2{iTrials} = pertTable.("Left_Gait_Cycle_Num"){iTrials}+2; % Left gait cycle 2 after perturbation 
    Lgc.P3{iTrials} = pertTable.("Left_Gait_Cycle_Num"){iTrials}+3; % Left gait cycle 3 after perturabtion 
    Lgc.P4{iTrials} = pertTable.("Left_Gait_Cycle_Num"){iTrials}+4; % Left gait cycle 4 after perturbation
    Lgc.P5{iTrials} = pertTable.("Left_Gait_Cycle_Num"){iTrials}+5; % Left gait cycel 5 after perturbation
    
    Rgc.b45{iTrials} = pertTable.("Right_Gait_Cycle_Num"){iTrials}-5; % Right gait cycle 5 before perturbation
    Rgc.b44{iTrials} = pertTable.("Right_Gait_Cycle_Num"){iTrials}-4; % Right gait cycle 4 before perturbation
    Rgc.b43{iTrials} = pertTable.("Right_Gait_Cycle_Num"){iTrials}-3; % Right gait cycle 3 before perturbation
    Rgc.b42{iTrials} = pertTable.("Right_Gait_Cycle_Num"){iTrials}-2; % Right gait cycle 2 before perturbation
    Rgc.b4{iTrials} = pertTable.("Right_Gait_Cycle_Num"){iTrials}-1; % Right gait cycle before perturbation
    Rgc.P0{iTrials} = pertTable.("Right_Gait_Cycle_Num"){iTrials}; % Right gait cycle that the perturbation occurs on
    Rgc.P1{iTrials} = pertTable.("Right_Gait_Cycle_Num"){iTrials}+1; % Right gait cycle one after perturbation 
    Rgc.P2{iTrials} = pertTable.("Right_Gait_Cycle_Num"){iTrials}+2; % Right gait cycle 2 after perturbation 
    Rgc.P3{iTrials} = pertTable.("Right_Gait_Cycle_Num"){iTrials}+3; % Right gait cycle 3 after perturbation 
    Rgc.P4{iTrials} = pertTable.("Right_Gait_Cycle_Num"){iTrials}+4; % Right gait cycle 4 after perturbation
    Rgc.P5{iTrials} = pertTable.("Right_Gait_Cycle_Num"){iTrials}+5; % Right gait cycel 5 after perturbation
%         
end

%%
% This loop gets the frames for the perturbation steps (-5, to plus 5)
for iTrials = 1:size(pTrials,1)
    for iPerts = 1:size(pertTable.("Left_Gait_Cycle_Num"){iTrials},2)
        Lgc.b42F{iTrials}{iPerts} = gaitEventsTable.("Gait_Events_Left"){iTrials,1}(Lgc.b42{iTrials}(iPerts),:); % Getting frames for Left Gait cycle 2 before perturbation 
        Lgc.b4F{iTrials}{iPerts} = gaitEventsTable.("Gait_Events_Left"){iTrials,1}(Lgc.b4{iTrials}(iPerts),:); % Getting frames for Left Gait cycle before perturbation 
        Lgc.P0F{iTrials}{iPerts} = gaitEventsTable.("Gait_Events_Left"){iTrials,1}(Lgc.P0{iTrials}(iPerts),:); % Frames for Left gait cycle the perturbation occurs on 
        Lgc.P1F{iTrials}{iPerts} = gaitEventsTable.("Gait_Events_Left"){iTrials,1}(Lgc.P1{iTrials}(iPerts),:); % Frames for Left gait cycle one after perturbation
        Lgc.P2F{iTrials}{iPerts} = gaitEventsTable.("Gait_Events_Left"){iTrials,1}(Lgc.P2{iTrials}(iPerts),:); % Frames for Left gait cycle 2 after perturbation 
        Lgc.P3F{iTrials}{iPerts} = gaitEventsTable.("Gait_Events_Left"){iTrials,1}(Lgc.P3{iTrials}(iPerts),:); % Frames for Left gait cycle 3 after perturabtion 
        
        % This set of 3 try and catch statements attempt to pull the frames
        % from the gait cycle table, but if the gait cycle does not exist
        % in the table it fills the results with a 1x5 NaN matrix. Then it
        % replaces the gait cycle number with a NaN as well. This is for
        % cycles -3 to -5 before the perturbation onset.
        try 
            Lgc.b43F{iTrials}{iPerts} = gaitEventsTable.("Gait_Events_Left"){iTrials,1}(Lgc.b43{iTrials}(iPerts),:); % Getting frames for Left Gait cycle 3 before perturbation
            try
                Lgc.b44F{iTrials}{iPerts} = gaitEventsTable.("Gait_Events_Left"){iTrials,1}(Lgc.b44{iTrials}(iPerts),:); % Getting frames for Left Gait cycle 4 before perturbation
                try
                    Lgc.b45F{iTrials}{iPerts} = gaitEventsTable.("Gait_Events_Left"){iTrials,1}(Lgc.b45{iTrials}(iPerts),:); % Getting frames for Left Gait cycle 5 before perturbation
                catch
                    Lgc.b45F{iTrials}{iPerts} = NaN(1,5);
                    Lgc.b45{iTrials}(iPerts) = NaN;
                end
            catch
                Lgc.b44F{iTrials}{iPerts} = NaN(1,5);
                Lgc.b45F{iTrials}{iPerts} = NaN(1,5);
                Lgc.b44{iTrials}(iPerts) = NaN;
                Lgc.b45{iTrials}(iPerts) = NaN;
            end
        catch
            Lgc.b43F{iTrials}{iPerts} = NaN(1,5);
            Lgc.b44F{iTrials}{iPerts} = NaN(1,5);
            Lgc.b45F{iTrials}{iPerts} = NaN(1,5);
            Lgc.b43{iTrials}(iPerts) = NaN;
            Lgc.b44{iTrials}(iPerts) = NaN;
            Lgc.b45{iTrials}(iPerts) = NaN;
        end
        
        % This set of try and catch statements attempt to pull the gait
        % cycle frames for cycles +4 to +5 post perturbation for the left
        % side. It will fill the structure spots with NaNs or NaN matrices
        % for the non existent gait cycles
        try
            Lgc.P4F{iTrials}{iPerts} = gaitEventsTable.("Gait_Events_Left"){iTrials,1}(Lgc.P4{iTrials}(iPerts),:); % Frames for Left gait cycle 4 after perturbation
            try
                Lgc.P5F{iTrials}{iPerts} = gaitEventsTable.("Gait_Events_Left"){iTrials,1}(Lgc.P5{iTrials}(iPerts),:); % Frames for Left gait cycle 5 after perturabtion 
            catch
                Lgc.P5F{iTrials}{iPerts} = Nan(1,5);
                Lgc.P5{iTrials}(iPerts) = NaN;
            end
        catch
            Lgc.P4F{iTrials}{iPerts} = NaN(1,5);
            Lgc.P5F{iTrials}{iPerts} = NaN(1,5);
            Lgc.P4{iTrials}(iPerts) = NaN;
            Lgc.P5{iTrials}(iPerts) = NaN;
        end
    end
    
    for iPerts = 1:size(pertTable.("Right_Gait_Cycle_Num"){iTrials},2)
        Rgc.b42F{iTrials}{iPerts} = gaitEventsTable.("Gait_Events_Right"){iTrials,1}(Rgc.b42{iTrials}(iPerts),:); % Frames for Right gait cycle 2 before perturbation
        Rgc.b4F{iTrials}{iPerts} = gaitEventsTable.("Gait_Events_Right"){iTrials,1}(Rgc.b4{iTrials}(iPerts),:); % Frames for Right gait cycle before perturbation
        Rgc.P0F{iTrials}{iPerts} = gaitEventsTable.("Gait_Events_Right"){iTrials,1}(Rgc.P0{iTrials}(iPerts),:); % Frames for Right gait cycle that the perturbation occurs on
        Rgc.P1F{iTrials}{iPerts} = gaitEventsTable.("Gait_Events_Right"){iTrials,1}(Rgc.P1{iTrials}(iPerts),:); % Frames for Right gait cycle one after perturbation 
        Rgc.P2F{iTrials}{iPerts} = gaitEventsTable.("Gait_Events_Right"){iTrials,1}(Rgc.P2{iTrials}(iPerts),:); % Frames for Right gait cycle 2 after perturbation 
        Rgc.P3F{iTrials}{iPerts} = gaitEventsTable.("Gait_Events_Right"){iTrials,1}(Rgc.P3{iTrials}(iPerts),:); % Frames for Right gait cycle 3 after perturbation
    
    % This set of 3 try and catch statements attempt to pull the frames
        % from the gait cycle table, but if the gait cycle does not exist
        % in the table it fills the results with a 1x5 NaN matrix. Then it
        % replaces the gait cycle number with a NaN as well. This is for
        % cycles -3 to -5 before the perturbation onset.
        try 
            Rgc.b43F{iTrials}{iPerts} = gaitEventsTable.("Gait_Events_Right"){iTrials,1}(Rgc.b43{iTrials}(iPerts),:); % Getting frames for Right Gait cycle 3 before perturbation
            try
                Rgc.b44F{iTrials}{iPerts} = gaitEventsTable.("Gait_Events_Right"){iTrials,1}(Rgc.b44{iTrials}(iPerts),:); % Getting frames for Right Gait cycle 4 before perturbation
                try
                    Rgc.b45F{iTrials}{iPerts} = gaitEventsTable.("Gait_Events_Right"){iTrials,1}(Rgc.b45{iTrials}(iPerts),:); % Getting frames for Right Gait cycle 5 before perturbation
                catch
                    Rgc.b45F{iTrials}{iPerts} = NaN(1,5);
                    Rgc.b45{iTrials}(iPerts) = NaN;
                end
            catch
                Rgc.b44F{iTrials}{iPerts} = NaN(1,5);
                Rgc.b45F{iTrials}{iPerts} = NaN(1,5);
                Rgc.b44{iTrials}(iPerts) = NaN;
                Rgc.b45{iTrials}(iPerts) = NaN;
            end
        catch
            Rgc.b43F{iTrials}{iPerts} = NaN(1,5);
            Rgc.b44F{iTrials}{iPerts} = NaN(1,5);
            Rgc.b45F{iTrials}{iPerts} = NaN(1,5);
            Rgc.b43{iTrials}(iPerts) = NaN;
            Rgc.b44{iTrials}(iPerts) = NaN;
            Rgc.b45{iTrials}(iPerts) = NaN;
        end
        
        % This set of try and catch statements attempt to pull the gait
        % cycle frames for cycles +4 to +5 post perturbation for the left
        % side. It will fill the structure spots with NaNs or NaN matrices
        % for the non existent gait cycles
        try
            Rgc.P4F{iTrials}{iPerts} = gaitEventsTable.("Gait_Events_Right"){iTrials,1}(Rgc.P4{iTrials}(iPerts),:); % Frames for Left gait cycle 4 after perturbation
            try
                Rgc.P5F{iTrials}{iPerts} = gaitEventsTable.("Gait_Events_Right"){iTrials,1}(Rgc.P5{iTrials}(iPerts),:); % Frames for Left gait cycle 5 after perturabtion 
            catch
                Rgc.P5F{iTrials}{iPerts} = Nan(1,5);
                Rgc.P5{iTrials}(iPerts) = NaN;
            end
        catch
            Rgc.P4F{iTrials}{iPerts} = NaN(1,5);
            Rgc.P5F{iTrials}{iPerts} = NaN(1,5);
            Rgc.P4{iTrials}(iPerts) = NaN;
            Rgc.P5{iTrials}(iPerts) = NaN;
        end
    end    
end


%% Find the repeat perturbation speeds for Left and Right leg
% Creates logical structures for the left and right perturbations for all
% repeats. 
for iTrials = 1:size(pTrials, 1)
    LeftSpeed.sp1{iTrials} = pertTable.("Left_Pert_Speed"){iTrials} == 0;
    LeftSpeed.sp2{iTrials} = pertTable.("Left_Pert_Speed"){iTrials} == -0.02;
    LeftSpeed.sp3{iTrials} = pertTable.("Left_Pert_Speed"){iTrials} == -0.05;
    LeftSpeed.sp4{iTrials} = pertTable.("Left_Pert_Speed"){iTrials} == -0.10;
    LeftSpeed.sp5{iTrials} = pertTable.("Left_Pert_Speed"){iTrials} == -0.15;
    LeftSpeed.sp6{iTrials} = pertTable.("Left_Pert_Speed"){iTrials} == -0.20;
    LeftSpeed.sp7{iTrials} = pertTable.("Left_Pert_Speed"){iTrials} == -0.30;
    LeftSpeed.sp8{iTrials} = pertTable.("Left_Pert_Speed"){iTrials} == -0.40;
    
    RightSpeed.sp1{iTrials} = pertTable.("Right_Pert_Speed"){iTrials} == 0;
    RightSpeed.sp2{iTrials} = pertTable.("Right_Pert_Speed"){iTrials} == -0.02;
    RightSpeed.sp3{iTrials} = pertTable.("Right_Pert_Speed"){iTrials} == -0.05;
    RightSpeed.sp4{iTrials} = pertTable.("Right_Pert_Speed"){iTrials} == -0.10;
    RightSpeed.sp5{iTrials} = pertTable.("Right_Pert_Speed"){iTrials} == -0.15;
    RightSpeed.sp6{iTrials} = pertTable.("Right_Pert_Speed"){iTrials} == -0.20;
    RightSpeed.sp7{iTrials} = pertTable.("Right_Pert_Speed"){iTrials} == -0.30;
    RightSpeed.sp8{iTrials} = pertTable.("Right_Pert_Speed"){iTrials} == -0.40;
end

%% Creating a new gait cycle structure that stores 5 cycles prior, onset, and 5 cycles after the perturbation. Stores values for each leg and in each trial.


pertsGC = {'b45';'b44';'b43';'b42';'b4'; 'P0'; 'P1'; 'P2'; 'P3';'P4';'P5'}; %Names of the stored gait cycle nums in Lgc and Rgc
pertsF = {'b45F';'b44F';'b43F';'b42F';'b4F'; 'P0F'; 'P1F'; 'P2F'; 'P3F';'P4F';'P5F'}; % Frames of the gait cycles stored in Lgc and Rgc
speeds = {'sp1'; 'sp2'; 'sp3'; 'sp4'; 'sp5'; 'sp6'; 'sp7'; 'sp8';}; % Speeds in order as above 0, -0.02, -0.5, -0.1, -0.15, -0.2, -0.3, -0.4
% pertSpeed = {'0'; '-0.02'; '-0.05'; '-0.10'; '-0.15'; '-0.2'; '-0.3'; '-0.4';}; % Perturbation speeds for the table
leg = {'L';'R'}; % Leg

nameFrames = {'Pre5Frames'; 'Pre4Frames'; 'Pre3Frames'; 'Pre2Frames'; 'Pre1Frames'; 'OnsetFrames'; 'Post1Frames'; 'Post2Frames'; 'Post3Frames'; 'Post4Frames'; 'Post5Frames';};
nameGC = {'Pre5CycleNum'; 'Pre4CycleNum'; 'Pre3CycleNum'; 'Pre2CycleNum'; 'Pre1CycleNum'; 'OnsetCycleNum'; 'Post1CycleNum'; 'Post2CycleNum'; 'Post3CycleNum'; 'Post4CycleNum'; 'Post5CycleNum';};

% This loop goes through places the 5 steps prior to the perturbation, the
% onset cycle, and 5 steps after the perturbation. It places the frames in
% each trial for the gait cycle or the number of the gait cycle from
% gaitEventsTable. This makes a table to easily pull the frames from here
% for plotting going forward. 
for iLeg = 1:size(leg,1) % Each leg
    for iSpeeds = 1:size(speeds,1) % The 8 different perturbation speeds as described in speeds 
        for iTrial = 1:size(pTrials,1) % The perturbation trials, ie Percep01-PercepXX
            for iPerts = 1:size(pertsF,1) % Perturbations that occur in each trial for each leg
                if iLeg == 1 % When the leg is left 
                    pertCycleStruc.(leg{iLeg}).(speeds{iSpeeds}).(namePercep{iTrial}).Perceived = pertTable.("Left_Pert_Perceived"){iTrial,1}(LeftSpeed.(speeds{iSpeeds}){iTrial});
                    pertCycleStruc.(leg{iLeg}).(speeds{iSpeeds}).(namePercep{iTrial}).(nameFrames{iPerts}) = Lgc.(pertsF{iPerts}){1,iTrial}(1,LeftSpeed.(speeds{iSpeeds}){iTrial});
                    pertCycleStruc.(leg{iLeg}).(speeds{iSpeeds}).(namePercep{iTrial}).(nameGC{iPerts}) = Lgc.(pertsGC{iPerts}){1,iTrial}(1,LeftSpeed.(speeds{iSpeeds}){iTrial});
                else % When the leg is right 
                    pertCycleStruc.(leg{iLeg}).(speeds{iSpeeds}).(namePercep{iTrial}).Perceived = pertTable.("Right_Pert_Perceived"){iTrial,1}(RightSpeed.(speeds{iSpeeds}){iTrial});
                    pertCycleStruc.(leg{iLeg}).(speeds{iSpeeds}).(namePercep{iTrial}).(nameFrames{iPerts}) = Rgc.(pertsF{iPerts}){1,iTrial}(1,RightSpeed.(speeds{iSpeeds}){iTrial});
                    pertCycleStruc.(leg{iLeg}).(speeds{iSpeeds}).(namePercep{iTrial}).(nameGC{iPerts}) = Rgc.(pertsGC{iPerts}){1,iTrial}(1,RightSpeed.(speeds{iSpeeds}){iTrial});
                end
            end
        end
    end
end
                    


%% Saving the data tables in the individual subjects folder 
% Setting the location to the subjects' data folder 
if ispc
    subLoc = ['G:\Shared drives\NeuroMobLab\Projects\Perception\Processed Data\Dan\Matlab Analysis\' subject1];
elseif ismac
    subLoc = [''];
else
    subLoc = input('Please enter the location where the tables should be saved.' ,'s');
end


% Checking to see if a data table folder exists for each subject. If it
% does not exist this will create a folder in the correct location. 
if exist([subLoc 'Data Tables'], 'dir') ~= 7
    mkdir(subLoc, 'Data Tables');
end

% Setting the location to save the data tables for each subject 
if ispc
    tabLoc = ['G:\Shared drives\NeuroMobLab\Projects\Perception\Processed Data\Dan\Matlab Analysis\' subject1 filesep 'Data Tables' filesep];
elseif ismac
    tabLoc = [''];
else
    tabLoc = input('Please enter the location where the tables should be saved.' ,'s');
end
% Saving the pertCycleStruc that contains the gait cycles and frames around
% all perturations 
save([tabLoc 'pertCycleStruc_' subject1], 'pertCycleStruc', '-v7.3')


disp(['Structure saved for ' subject1]);



end

