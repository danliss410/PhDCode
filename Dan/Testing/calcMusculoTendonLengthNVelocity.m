function calcMusculoTendonLengthNVelocity(strSubject)
%
% calcMusculoTendonLengthNVelocity(Subject)
%
% This function will create a table for each muscle on each leg that holds
% all the musculotendon length and velocity values for the gait cycle before the
% perturbation, perturbation onset, and +1-3 gait cycles after the
% perturbation. This has all the repeats of the perturbation saved in one
% row. This function also creates a "pertCycleTable" that saves all the
% gait cycles for each perturbation repeat for each of those gait cycle
% instances as well. 
%
% INPUTS: subject               - a string of the subjects unique identifier for the
%                                   Perception study.
%
%
% OUPUT: 
%        
%
%
%       "muscle name" Table     - This will not be a direct output
%                               since the number of muscles will vary
%                               depending on the input. The muscle tables
%                               will be saved to the subjects folder and
%                               will be loaded at the same time. 
%               EX) Naming - lmgTable -> This table will have all the MTL
%               and MTV lengths for -1 step before perturbation,
%               perturbation onset, and +1-3 after perturbation.
% 
% 
%  ################### WILL NEED TO ADAPT THIS FOR WHATEVER MUSCLES YOU
%  ################### NEED - Search the line below and change table names
%  ################### to correspond to what muscles you need. Also you
%  ################### will need to change the names of the tables in the
%  ################### save portion of the code. 
% %% Placing all MTL and MTV values into a table for repeat perturbation values 
% 
%
% Created: 6 September 2020, DJL
% Modified: (format: date, initials, change made)
%   1 -  
%   2 - 
% Things that need to be added 
%   1 - Cognitive or 2AFC trials 

%% Create subject name to load the necessary files for the subject 
% Naming convention for each log file "YAPercep##_" + YesNo or 2AFC or Cog

subjectYesNo = ['YAPercep' strSubject '_YesNo'];

subject2AFC = ['YAPercep' strSubject '_2AFC'];

subjectCog = ['YAPercep' strSubject '_Cog'];

subject1 = ['YAPercep' strSubject];

namePercep = {'Percep01'; 'Percep02'; 'Percep03'; 'Percep04'; 'Percep05'; 'Percep06';};
%% Loading the remaining tables for the subject 
% This section will load muscleTable, analogTable, gaitEventsTable,
% IKTable, pertTable, and videoTable(This will not be used)

load(['G:\Shared drives\NeuroMobLab\Projects\Perception\Processed Data\Dan\OpenSim\YAPercep Outputs\' subject1 '\Data Tables\IKTable_' subject1 '.mat'])
load(['G:\Shared drives\NeuroMobLab\Projects\Perception\Processed Data\Dan\OpenSim\YAPercep Outputs\' subject1 '\Data Tables\MuscleTable_' subject1 '.mat'])
load(['G:\Shared drives\NeuroMobLab\Projects\Perception\Processed Data\Dan\Matlab Analysis\' subject1 '\Data Tables\SepTables_' subject1 '.mat'])
load(['G:\Shared drives\NeuroMobLab\Projects\Perception\Processed Data\Dan\Matlab Analysis\' subject1 '\Data Tables\pertTable_' subject1 '.mat'])

%% Find the gait cycles and frames for the perturbation information 

pTrials = contains(pertTable.Trial, 'Percep'); % Finding which rows in the table contain the Perception Trials

pTrials = pTrials(pTrials == 1); %Selecting only the indicies that have Perception trials

pertSpeed = {'0'; '-0.02'; '-0.05'; '-0.10'; '-0.15'; '-0.2'; '-0.3'; '-0.4';}; % Perturbation speeds for the table

% This loop gets the gait cycle numbers for the gait cycle before
% perturbation and 1-3 gait cycles after the perturbation 
for iTrials = 1:size(pTrials,1)
    Lgc.b42{iTrials} = pertTable.("Left Gait Cycle Num"){iTrials}-2; % Left gait cycle 2 steps before perturbation
    Lgc.b4{iTrials} = pertTable.("Left Gait Cycle Num"){iTrials}-1; % Left gait cycle before perturbation
    Lgc.P0{iTrials} = pertTable.("Left Gait Cycle Num"){iTrials}; % Left gait cycle the perturbation occurs on 
    Lgc.P1{iTrials} = pertTable.("Left Gait Cycle Num"){iTrials}+1; % Left gait cycle one after perturbation
    Lgc.P2{iTrials} = pertTable.("Left Gait Cycle Num"){iTrials}+2; % Left gait cycle 2 after perturbation 
    Lgc.P3{iTrials} = pertTable.("Left Gait Cycle Num"){iTrials}+3; % Left gait cycle 3 after perturabtion 
    Lgc.P4{iTrials} = pertTable.("Left Gait Cycle Num"){iTrials}+4; % Left gait cycle 4 after perturbation
    %Lgc.P5{iTrials} = pertTable.("Left Gait Cycle Num"){iTrials}+5; % Left gait cycel 5 after perturbation
    
    Rgc.b42{iTrials} = pertTable.("Right Gait Cycle Num"){iTrials}-2; % Right gait cycle 2 before perturbation
    Rgc.b4{iTrials} = pertTable.("Right Gait Cycle Num"){iTrials}-1; % Right gait cycle before perturbation
    Rgc.P0{iTrials} = pertTable.("Right Gait Cycle Num"){iTrials}; % Right gait cycle that the perturbation occurs on
    Rgc.P1{iTrials} = pertTable.("Right Gait Cycle Num"){iTrials}+1; % Right gait cycle one after perturbation 
    Rgc.P2{iTrials} = pertTable.("Right Gait Cycle Num"){iTrials}+2; % Right gait cycle 2 after perturbation 
    Rgc.P3{iTrials} = pertTable.("Right Gait Cycle Num"){iTrials}+3; % Right gait cycle 3 after perturbation
    Rgc.P4{iTrials} = pertTable.("Right Gait Cycle Num"){iTrials}+4; % Right gait cycle 4 after perturbation 
    %Rgc.P5{iTrials} = pertTable.("Right Gait Cycle Num"){iTrials}+5; % Right gait cycle 5 after perturbation
    
    for iLP4 = 1:size(Lgc.P4{iTrials},2)
        if Lgc.P4{iTrials}(iLP4) > size(gaitEventsTable.("Gait Events Left"){iTrials},1)
            temp = Lgc.P4{iTrials} > size(gaitEventsTable.("Gait Events Left"){iTrials},1);
            Lgc.P4{iTrials}(temp) = NaN;
        end
    end
    
%     for iLP5 = 1:size(Lgc.P5{iTrials},2)
%         if Lgc.P5{iTrials}(iLP5) > size(gaitEventsTable.("Gait Events Left"){iTrials},1)
%             temp2 = Lgc.P5{iTrials} > size(gaitEventsTable.("Gait Events Left"){iTrials},1);
%             Lgc.P5{iTrials}(temp2) = NaN;
%         end
%     end
    
    for iRP4 = 1:size(Rgc.P4{iTrials},2)
        if Rgc.P4{iTrials}(iRP4) > size(gaitEventsTable.("Gait Events Right"){iTrials},1)
            temp3 = Rgc.P4{iTrials} > size(gaitEventsTable.("Gait Events Right"){iTrials},1);
            Rgc.P4{iTrials}(temp3) = NaN;
        end
    end
    
%     for iRP5 = 1:size(Rgc.P5{iTrials},2)
%         if Rgc.P5{iTrials}(iRP5) > size(gaitEventsTable.("Gait Events Right"){iTrials},1)
%             temp4 = Rgc.P5{iTrials} > size(gaitEventsTable.("Gait Events Right"){iTrials},1);
%             Rgc.P5{iTrials}(temp4) = NaN;
%         end
%     end
%         
end

% This loop gets the frames for the perturbation steps (-2, to plus 5)
for iTrials = 1:size(pTrials,1)
    for iPerts = 1:size(pertTable.("Left Gait Cycle Num"){iTrials},2)
        Lgc.b42F{iTrials}{iPerts} = gaitEventsTable.("Gait Events Left"){iTrials,1}(Lgc.b42{iTrials}(iPerts),:); % Getting frames for Left Gait cycle 2 before perturbation 
        Lgc.b4F{iTrials}{iPerts} = gaitEventsTable.("Gait Events Left"){iTrials,1}(Lgc.b4{iTrials}(iPerts),:); % Getting frames for Left Gait cycle before perturbation 
        Lgc.P0F{iTrials}{iPerts} = gaitEventsTable.("Gait Events Left"){iTrials,1}(Lgc.P0{iTrials}(iPerts),:); % Frames for Left gait cycle the perturbation occurs on 
        Lgc.P1F{iTrials}{iPerts} = gaitEventsTable.("Gait Events Left"){iTrials,1}(Lgc.P1{iTrials}(iPerts),:); % Frames for Left gait cycle one after perturbation
        Lgc.P2F{iTrials}{iPerts} = gaitEventsTable.("Gait Events Left"){iTrials,1}(Lgc.P2{iTrials}(iPerts),:); % Frames for Left gait cycle 2 after perturbation 
        Lgc.P3F{iTrials}{iPerts} = gaitEventsTable.("Gait Events Left"){iTrials,1}(Lgc.P3{iTrials}(iPerts),:); % Frames for Left gait cycle 3 after perturabtion 
        Lgc.P4F{iTrials}{iPerts} = gaitEventsTable.("Gait Events Left"){iTrials,1}(Lgc.P4{iTrials}(iPerts),:); % Frames for Left gait cycle 4 after perturbation 
%         try
%             Lgc.P5F{iTrials}{iPerts} = gaitEventsTable.("Gait Events Left"){iTrials,1}(Lgc.P5{iTrials}(iPerts),:); % Frames for Left gait cycle 5 after perturabtion 
%         catch
%         end
    end
    
    for iPerts = 1:size(pertTable.("Right Gait Cycle Num"){iTrials},2)
        Rgc.b42F{iTrials}{iPerts} = gaitEventsTable.("Gait Events Right"){iTrials,1}(Rgc.b42{iTrials}(iPerts),:); % Frames for Right gait cycle 2 before perturbation
        Rgc.b4F{iTrials}{iPerts} = gaitEventsTable.("Gait Events Right"){iTrials,1}(Rgc.b4{iTrials}(iPerts),:); % Frames for Right gait cycle before perturbation
        Rgc.P0F{iTrials}{iPerts} = gaitEventsTable.("Gait Events Right"){iTrials,1}(Rgc.P0{iTrials}(iPerts),:); % Frames for Right gait cycle that the perturbation occurs on
        Rgc.P1F{iTrials}{iPerts} = gaitEventsTable.("Gait Events Right"){iTrials,1}(Rgc.P1{iTrials}(iPerts),:); % Frames for Right gait cycle one after perturbation 
        Rgc.P2F{iTrials}{iPerts} = gaitEventsTable.("Gait Events Right"){iTrials,1}(Rgc.P2{iTrials}(iPerts),:); % Frames for Right gait cycle 2 after perturbation 
        Rgc.P3F{iTrials}{iPerts} = gaitEventsTable.("Gait Events Right"){iTrials,1}(Rgc.P3{iTrials}(iPerts),:); % Frames for Right gait cycle 3 after perturbation
        Rgc.P4F{iTrials}{iPerts} = gaitEventsTable.("Gait Events Right"){iTrials,1}(Rgc.P4{iTrials}(iPerts),:); % Frames for Right gait cycle 4 after perturbation 
%         Rgc.P5F{iTrials}{iPerts} = gaitEventsTable.("Gait Events Right"){iTrials,1}(Rgc.P5{iTrials}(iPerts),:); % Frames for Right gait cycle 5 after perturbation
    end
end
        
% This loop will get the values of the MTL and MTV for each perturbation 
perts = {'b42F';'b4F'; 'P0F'; 'P1F'; 'P2F'; 'P3F';'P4F';}; %'P5F'};
for iTrials = 1:size(pTrials,1)
    for iPerts = 1:size(pertTable.("Left Gait Cycle Num"){iTrials}, 2)
        for iCycle = 1:length(perts)
            % getting musculotendon lengths and velocity 
            % values for Medial Gastroc, Lateral Gastroc, Soleus,
            % and Tib Ant for the left leg 
            MTL.lmg.(perts{iCycle}){iTrials}{iPerts} = muscleTable.("L Med Gastroc Length"){iTrials,1}(Lgc.(perts{iCycle}){iTrials}{1,iPerts}(1):Lgc.(perts{iCycle}){iTrials}{1,iPerts}(5));
            MTL.llg.(perts{iCycle}){iTrials}{iPerts} = muscleTable.("L Lat Gastroc Length"){iTrials,1}(Lgc.(perts{iCycle}){iTrials}{1,iPerts}(1):Lgc.(perts{iCycle}){iTrials}{1,iPerts}(5));
            MTL.lsol.(perts{iCycle}){iTrials}{iPerts} = muscleTable.("L Soleus Length"){iTrials,1}(Lgc.(perts{iCycle}){iTrials}{1,iPerts}(1):Lgc.(perts{iCycle}){iTrials}{1,iPerts}(5));
            MTL.lta.(perts{iCycle}){iTrials}{iPerts} = muscleTable.("L Tib Ant Length"){iTrials,1}(Lgc.(perts{iCycle}){iTrials}{1,iPerts}(1):Lgc.(perts{iCycle}){iTrials}{1,iPerts}(5));
            
            MTV.lmg.(perts{iCycle}){iTrials}{iPerts} = muscleTable.("L Med Gastroc Velocity"){iTrials,1}(Lgc.(perts{iCycle}){iTrials}{1,iPerts}(1):Lgc.(perts{iCycle}){iTrials}{1,iPerts}(5));
            MTV.llg.(perts{iCycle}){iTrials}{iPerts} = muscleTable.("L Lat Gastroc Velocity"){iTrials,1}(Lgc.(perts{iCycle}){iTrials}{1,iPerts}(1):Lgc.(perts{iCycle}){iTrials}{1,iPerts}(5));
            MTV.lsol.(perts{iCycle}){iTrials}{iPerts} = muscleTable.("L Soleus Velocity"){iTrials,1}(Lgc.(perts{iCycle}){iTrials}{1,iPerts}(1):Lgc.(perts{iCycle}){iTrials}{1,iPerts}(5));
            MTV.lta.(perts{iCycle}){iTrials}{iPerts} = muscleTable.("L Tib Ant Velocity"){iTrials,1}(Lgc.(perts{iCycle}){iTrials}{1,iPerts}(1):Lgc.(perts{iCycle}){iTrials}{1,iPerts}(5));

        end
    end
    
    for iPerts2 = 1:size(pertTable.("Right Gait Cycle Num"){iTrials},2)
        for iCycle2 = 1:length(perts)
            % getting musculotendon lengths and velocity 
            % values for Medial Gastroc, Lateral Gastroc, Soleus,
            % and Tib Ant for the right leg 
            MTL.rmg.(perts{iCycle2}){iTrials}{iPerts2} = muscleTable.("R Med Gastroc Length"){iTrials,1}(Rgc.(perts{iCycle2}){iTrials}{1,iPerts2}(1):Rgc.(perts{iCycle2}){iTrials}{1,iPerts2}(5));
            MTL.rlg.(perts{iCycle2}){iTrials}{iPerts2} = muscleTable.("R Lat Gastroc Length"){iTrials,1}(Rgc.(perts{iCycle2}){iTrials}{1,iPerts2}(1):Rgc.(perts{iCycle2}){iTrials}{1,iPerts2}(5));
            MTL.rsol.(perts{iCycle2}){iTrials}{iPerts2} = muscleTable.("R Soleus Length"){iTrials,1}(Rgc.(perts{iCycle2}){iTrials}{1,iPerts2}(1):Rgc.(perts{iCycle2}){iTrials}{1,iPerts2}(5));
            MTL.rta.(perts{iCycle2}){iTrials}{iPerts2} = muscleTable.("R Tib Ant Length"){iTrials,1}(Rgc.(perts{iCycle2}){iTrials}{1,iPerts2}(1):Rgc.(perts{iCycle2}){iTrials}{1,iPerts2}(5));
            
            MTV.rmg.(perts{iCycle2}){iTrials}{iPerts2} = muscleTable.("R Med Gastroc Velocity"){iTrials,1}(Rgc.(perts{iCycle2}){iTrials}{1,iPerts2}(1):Rgc.(perts{iCycle2}){iTrials}{1,iPerts2}(5));
            MTV.rlg.(perts{iCycle2}){iTrials}{iPerts2} = muscleTable.("R Lat Gastroc Velocity"){iTrials,1}(Rgc.(perts{iCycle2}){iTrials}{1,iPerts2}(1):Rgc.(perts{iCycle2}){iTrials}{1,iPerts2}(5));
            MTV.rsol.(perts{iCycle2}){iTrials}{iPerts2} = muscleTable.("R Soleus Velocity"){iTrials,1}(Rgc.(perts{iCycle2}){iTrials}{1,iPerts2}(1):Rgc.(perts{iCycle2}){iTrials}{1,iPerts2}(5));
            MTV.rta.(perts{iCycle2}){iTrials}{iPerts2} = muscleTable.("R Tib Ant Velocity"){iTrials,1}(Rgc.(perts{iCycle2}){iTrials}{1,iPerts2}(1):Rgc.(perts{iCycle2}){iTrials}{1,iPerts2}(5));

        end
    end
    
end
clear iCycle iCycle2 iPerts iPerts2




%% Put all the repeat perturbation information into the necessary table slots 
speeds = {'sp1'; 'sp2'; 'sp3'; 'sp4'; 'sp5'; 'sp6'; 'sp7'; 'sp8';}; % Speeds in order as above 0, -0.02, -0.5, -0.1, -0.15, -0.2, -0.3, -0.4
musclesLeft = {'lmg'; 'llg'; 'lsol'; 'lta';}; % Muscles for the left leg

musclesRight = {'rmg'; 'rlg'; 'rsol'; 'rta'}; % Muscles for the right leg

% This loop finds all the indicies for each speed for all repeats for all
% muscles for the step before, perturbed step, and +1-3 steps after for
% both legs
for iTrial = 1:size(pTrials, 1)
    for iSpeeds = 1:length(speeds)
        for iMuscles1 = 1:length(musclesLeft)
            for iPerts = 1:length(perts)
                temp = {MTL.(musclesLeft{iMuscles1}).(perts{iPerts}){1,iTrial}{1,LeftSpeed.(speeds{iSpeeds}){iTrial}}};
                temp2 = {MTV.(musclesLeft{iMuscles1}).(perts{iPerts}){1,iTrial}{1,LeftSpeed.(speeds{iSpeeds}){iTrial}}};
                pertInfo.(speeds{iSpeeds}).(musclesLeft{iMuscles1}).MTL.(perts{iPerts}){iTrial} = temp;
                pertInfo.(speeds{iSpeeds}).(musclesLeft{iMuscles1}).MTV.(perts{iPerts}){iTrial} = temp2;
            end
        end
        for iMuscles2 = 1:length(musclesRight)
            for iPerts2 = 1:length(perts)
                temp3 = {MTL.(musclesRight{iMuscles2}).(perts{iPerts2}){1,iTrial}{1,RightSpeed.(speeds{iSpeeds}){iTrial}}};
                temp4 = {MTV.(musclesRight{iMuscles2}).(perts{iPerts2}){1,iTrial}{1,RightSpeed.(speeds{iSpeeds}){iTrial}}};
                pertInfo.(speeds{iSpeeds}).(musclesRight{iMuscles2}).MTL.(perts{iPerts2}){iTrial} = temp3;
                pertInfo.(speeds{iSpeeds}).(musclesRight{iMuscles2}).MTV.(perts{iPerts2}){iTrial} = temp4;
            end
        end
    end
end

clear iPerts iPerts2 iMuscles1 iMuscles2
% Getting rid of the empty values in the structures from no matches in the
% perception trials 
for iSpeeds = 1:length(speeds)
    for iMuscles1 = 1:length(musclesLeft)
        for iPerts = 1:length(perts) 
            pertInfo.(speeds{iSpeeds}).(musclesLeft{iMuscles1}).MTL.(perts{iPerts}) = pertInfo.(speeds{iSpeeds}).(musclesLeft{iMuscles1}).MTL.(perts{iPerts})(~cellfun(@isempty, pertInfo.(speeds{iSpeeds}).(musclesLeft{iMuscles1}).MTL.(perts{iPerts})));
            pertInfo.(speeds{iSpeeds}).(musclesLeft{iMuscles1}).MTV.(perts{iPerts}) = pertInfo.(speeds{iSpeeds}).(musclesLeft{iMuscles1}).MTV.(perts{iPerts})(~cellfun(@isempty, pertInfo.(speeds{iSpeeds}).(musclesLeft{iMuscles1}).MTV.(perts{iPerts})));
        end
    end
    for iMuscles2 = 1:length(musclesRight)
        for iPerts2 = 1:length(perts)
            pertInfo.(speeds{iSpeeds}).(musclesRight{iMuscles2}).MTL.(perts{iPerts2}) = pertInfo.(speeds{iSpeeds}).(musclesRight{iMuscles2}).MTL.(perts{iPerts2})(~cellfun(@isempty, pertInfo.(speeds{iSpeeds}).(musclesRight{iMuscles2}).MTL.(perts{iPerts2})));
            pertInfo.(speeds{iSpeeds}).(musclesRight{iMuscles2}).MTV.(perts{iPerts2}) = pertInfo.(speeds{iSpeeds}).(musclesRight{iMuscles2}).MTV.(perts{iPerts2})(~cellfun(@isempty, pertInfo.(speeds{iSpeeds}).(musclesRight{iMuscles2}).MTV.(perts{iPerts2})));
        end
    end
end

% Reshaping the structures so that the values are in 1x5 cells of the
% repeated values 
for iSpeeds = 1:length(speeds)
    % This part of the loop handles the left leg for both MTL and MTV
    % values
    for iMuscles1 = 1:length(musclesLeft)
        for iPerts = 1:length(perts)
            iPlace = 1;
            for iRepeats = 1:size(pertInfo.(speeds{iSpeeds}).(musclesLeft{iMuscles1}).MTL.(perts{iPerts}),2)
                for iValues = 1:size(pertInfo.(speeds{iSpeeds}).(musclesLeft{iMuscles1}).MTL.(perts{iPerts}){iRepeats},2)
                    tpertInfo.(speeds{iSpeeds}).(musclesLeft{iMuscles1}).MTL.(perts{iPerts}){1,iPlace} = pertInfo.(speeds{iSpeeds}).(musclesLeft{iMuscles1}).MTL.(perts{iPerts}){1,iRepeats}{iValues};
                    tpertInfo.(speeds{iSpeeds}).(musclesLeft{iMuscles1}).MTV.(perts{iPerts}){1,iPlace} = pertInfo.(speeds{iSpeeds}).(musclesLeft{iMuscles1}).MTV.(perts{iPerts}){1,iRepeats}{iValues};
                    iPlace = iPlace + 1;
                end
            end
            clear iPlace
        end
    end
    % This part of the loop handles the right leg for both MTL and MTV
    % values for reshaping
    for iMuscles2 = 1:length(musclesLeft)
        for iPerts2 = 1:length(perts)
            iPlace2 = 1;
            for iRepeats2 = 1:size(pertInfo.(speeds{iSpeeds}).(musclesRight{iMuscles2}).MTL.(perts{iPerts2}),2)
                for iValues2 = 1:size(pertInfo.(speeds{iSpeeds}).(musclesRight{iMuscles2}).MTL.(perts{iPerts2}){iRepeats2},2)
                    tpertInfo.(speeds{iSpeeds}).(musclesRight{iMuscles2}).MTL.(perts{iPerts2}){1,iPlace2} = pertInfo.(speeds{iSpeeds}).(musclesRight{iMuscles2}).MTL.(perts{iPerts2}){1,iRepeats2}{iValues2};
                    tpertInfo.(speeds{iSpeeds}).(musclesRight{iMuscles2}).MTV.(perts{iPerts2}){1,iPlace2} = pertInfo.(speeds{iSpeeds}).(musclesRight{iMuscles2}).MTV.(perts{iPerts2}){1,iRepeats2}{iValues2};
                    iPlace2 = iPlace2 + 1;
                end
            end
            clear iPlace2
        end
    end
end
clear temp temp2 temp3 temp4 iMuscles1 iMuscles2 iPerts iPerts2 iRepeats iRepeats2 iSpeeds iTrial iTrials iValues iValues2 pertInfo
%% Placing all MTL and MTV values into a table for repeat perturbation values 
% #### This section needs to be edited for whatever muscles you need 
% This table will contain the 5 repeats of each perturbation value for 4 different MTL and MTV values for each leg 

% This loop creates a table of all the Left Medial Gastroc Values for MTV and MTL
% the step before perturbation, the onset step, and +1-3 steps after
% perturbation
for iSpeeds = 1:size(pertSpeed,1)
    if iSpeeds == 1 
        lmgTable = table(pertSpeed(iSpeeds),{tpertInfo.sp1.lmg.MTL.b4F}, {tpertInfo.sp1.lmg.MTL.P0F}, {tpertInfo.sp1.lmg.MTL.P1F}, {tpertInfo.sp1.lmg.MTL.P2F}, {tpertInfo.sp1.lmg.MTL.P3F},...
    {tpertInfo.sp1.lmg.MTV.b4F}, {tpertInfo.sp1.lmg.MTV.P0F}, {tpertInfo.sp1.lmg.MTV.P1F}, {tpertInfo.sp1.lmg.MTV.P2F}, {tpertInfo.sp1.lmg.MTV.P3F},...
    'VariableNames', {'dV';'Length -1 Cycle'; 'Length Onset'; 'Length +1 Cycle'; 'Length +2 Cycle'; 'Length +3 Cycle';...
    'Velocity -1 Cycle'; 'Velocity Onset'; 'Velocity +1 Cycle'; 'Velocity +2 Cycle'; 'Velocity +3 Cycle'});
    else 
        lmgTable.dV(iSpeeds) = pertSpeed(iSpeeds);
        lmgTable.("Length -1 Cycle")(iSpeeds) = {tpertInfo.(speeds{iSpeeds}).lmg.MTL.b4F};
        lmgTable.("Length Onset")(iSpeeds) = {tpertInfo.(speeds{iSpeeds}).lmg.MTL.P0F};
        lmgTable.("Length +1 Cycle")(iSpeeds) = {tpertInfo.(speeds{iSpeeds}).lmg.MTL.P1F};
        lmgTable.("Length +2 Cycle")(iSpeeds) = {tpertInfo.(speeds{iSpeeds}).lmg.MTL.P2F};
        lmgTable.("Length +3 Cycle")(iSpeeds) = {tpertInfo.(speeds{iSpeeds}).lmg.MTL.P3F};
        lmgTable.("Velocity -1 Cycle")(iSpeeds) = {tpertInfo.(speeds{iSpeeds}).lmg.MTV.b4F};
        lmgTable.("Velocity Onset")(iSpeeds) = {tpertInfo.(speeds{iSpeeds}).lmg.MTV.P0F};
        lmgTable.("Velocity +1 Cycle")(iSpeeds) = {tpertInfo.(speeds{iSpeeds}).lmg.MTV.P1F};
        lmgTable.("Velocity +2 Cycle")(iSpeeds) = {tpertInfo.(speeds{iSpeeds}).lmg.MTV.P2F};
        lmgTable.("Velocity +3 Cycle")(iSpeeds) = {tpertInfo.(speeds{iSpeeds}).lmg.MTV.P3F};
    end
end

% This loop creates a table of all the Left Lateral Gastroc Values for MTV and MTL
% the step before perturbation, the onset step, and +1-3 steps after
% perturbation
for iSpeeds = 1:size(pertSpeed,1)
    if iSpeeds == 1 
        llgTable = table(pertSpeed(iSpeeds),{tpertInfo.sp1.llg.MTL.b4F}, {tpertInfo.sp1.llg.MTL.P0F}, {tpertInfo.sp1.llg.MTL.P1F}, {tpertInfo.sp1.llg.MTL.P2F}, {tpertInfo.sp1.llg.MTL.P3F},...
    {tpertInfo.sp1.llg.MTV.b4F}, {tpertInfo.sp1.llg.MTV.P0F}, {tpertInfo.sp1.llg.MTV.P1F}, {tpertInfo.sp1.llg.MTV.P2F}, {tpertInfo.sp1.llg.MTV.P3F},...
    'VariableNames', {'dV';'Length -1 Cycle'; 'Length Onset'; 'Length +1 Cycle'; 'Length +2 Cycle'; 'Length +3 Cycle';...
    'Velocity -1 Cycle'; 'Velocity Onset'; 'Velocity +1 Cycle'; 'Velocity +2 Cycle'; 'Velocity +3 Cycle'});
    else 
        llgTable.dV(iSpeeds) = pertSpeed(iSpeeds);
        llgTable.("Length -1 Cycle")(iSpeeds) = {tpertInfo.(speeds{iSpeeds}).llg.MTL.b4F};
        llgTable.("Length Onset")(iSpeeds) = {tpertInfo.(speeds{iSpeeds}).llg.MTL.P0F};
        llgTable.("Length +1 Cycle")(iSpeeds) = {tpertInfo.(speeds{iSpeeds}).llg.MTL.P1F};
        llgTable.("Length +2 Cycle")(iSpeeds) = {tpertInfo.(speeds{iSpeeds}).llg.MTL.P2F};
        llgTable.("Length +3 Cycle")(iSpeeds) = {tpertInfo.(speeds{iSpeeds}).llg.MTL.P3F};
        llgTable.("Velocity -1 Cycle")(iSpeeds) = {tpertInfo.(speeds{iSpeeds}).llg.MTV.b4F};
        llgTable.("Velocity Onset")(iSpeeds) = {tpertInfo.(speeds{iSpeeds}).llg.MTV.P0F};
        llgTable.("Velocity +1 Cycle")(iSpeeds) = {tpertInfo.(speeds{iSpeeds}).llg.MTV.P1F};
        llgTable.("Velocity +2 Cycle")(iSpeeds) = {tpertInfo.(speeds{iSpeeds}).llg.MTV.P2F};
        llgTable.("Velocity +3 Cycle")(iSpeeds) = {tpertInfo.(speeds{iSpeeds}).llg.MTV.P3F};
    end
end

% This loop creates a table of all the Left Soleus Values for MTV and MTL
% the step before perturbation, the onset step, and +1-3 steps after
% perturbation
for iSpeeds = 1:size(pertSpeed,1)
    if iSpeeds == 1 
        lsolTable = table(pertSpeed(iSpeeds),{tpertInfo.sp1.lsol.MTL.b4F}, {tpertInfo.sp1.lsol.MTL.P0F}, {tpertInfo.sp1.lsol.MTL.P1F}, {tpertInfo.sp1.lsol.MTL.P2F}, {tpertInfo.sp1.lsol.MTL.P3F},...
    {tpertInfo.sp1.lsol.MTV.b4F}, {tpertInfo.sp1.lsol.MTV.P0F}, {tpertInfo.sp1.lsol.MTV.P1F}, {tpertInfo.sp1.lsol.MTV.P2F}, {tpertInfo.sp1.lsol.MTV.P3F},...
    'VariableNames', {'dV';'Length -1 Cycle'; 'Length Onset'; 'Length +1 Cycle'; 'Length +2 Cycle'; 'Length +3 Cycle';...
    'Velocity -1 Cycle'; 'Velocity Onset'; 'Velocity +1 Cycle'; 'Velocity +2 Cycle'; 'Velocity +3 Cycle'});
    else 
        lsolTable.dV(iSpeeds) = pertSpeed(iSpeeds);
        lsolTable.("Length -1 Cycle")(iSpeeds) = {tpertInfo.(speeds{iSpeeds}).lsol.MTL.b4F};
        lsolTable.("Length Onset")(iSpeeds) = {tpertInfo.(speeds{iSpeeds}).lsol.MTL.P0F};
        lsolTable.("Length +1 Cycle")(iSpeeds) = {tpertInfo.(speeds{iSpeeds}).lsol.MTL.P1F};
        lsolTable.("Length +2 Cycle")(iSpeeds) = {tpertInfo.(speeds{iSpeeds}).lsol.MTL.P2F};
        lsolTable.("Length +3 Cycle")(iSpeeds) = {tpertInfo.(speeds{iSpeeds}).lsol.MTL.P3F};
        lsolTable.("Velocity -1 Cycle")(iSpeeds) = {tpertInfo.(speeds{iSpeeds}).lsol.MTV.b4F};
        lsolTable.("Velocity Onset")(iSpeeds) = {tpertInfo.(speeds{iSpeeds}).lsol.MTV.P0F};
        lsolTable.("Velocity +1 Cycle")(iSpeeds) = {tpertInfo.(speeds{iSpeeds}).lsol.MTV.P1F};
        lsolTable.("Velocity +2 Cycle")(iSpeeds) = {tpertInfo.(speeds{iSpeeds}).lsol.MTV.P2F};
        lsolTable.("Velocity +3 Cycle")(iSpeeds) = {tpertInfo.(speeds{iSpeeds}).lsol.MTV.P3F};
    end
end

% This loop creates a table of all the Left Tib Ant Values for MTV and MTL
% the step before perturbation, the onset step, and +1-3 steps after
% perturbation
for iSpeeds = 1:size(pertSpeed,1)
    if iSpeeds == 1 
        ltaTable = table(pertSpeed(iSpeeds),{tpertInfo.sp1.lta.MTL.b4F}, {tpertInfo.sp1.lta.MTL.P0F}, {tpertInfo.sp1.lta.MTL.P1F}, {tpertInfo.sp1.lta.MTL.P2F}, {tpertInfo.sp1.lta.MTL.P3F},...
    {tpertInfo.sp1.lta.MTV.b4F}, {tpertInfo.sp1.lta.MTV.P0F}, {tpertInfo.sp1.lta.MTV.P1F}, {tpertInfo.sp1.lta.MTV.P2F}, {tpertInfo.sp1.lta.MTV.P3F},...
    'VariableNames', {'dV';'Length -1 Cycle'; 'Length Onset'; 'Length +1 Cycle'; 'Length +2 Cycle'; 'Length +3 Cycle';...
    'Velocity -1 Cycle'; 'Velocity Onset'; 'Velocity +1 Cycle'; 'Velocity +2 Cycle'; 'Velocity +3 Cycle'});
    else 
        ltaTable.dV(iSpeeds) = pertSpeed(iSpeeds);
        ltaTable.("Length -1 Cycle")(iSpeeds) = {tpertInfo.(speeds{iSpeeds}).lta.MTL.b4F};
        ltaTable.("Length Onset")(iSpeeds) = {tpertInfo.(speeds{iSpeeds}).lta.MTL.P0F};
        ltaTable.("Length +1 Cycle")(iSpeeds) = {tpertInfo.(speeds{iSpeeds}).lta.MTL.P1F};
        ltaTable.("Length +2 Cycle")(iSpeeds) = {tpertInfo.(speeds{iSpeeds}).lta.MTL.P2F};
        ltaTable.("Length +3 Cycle")(iSpeeds) = {tpertInfo.(speeds{iSpeeds}).lta.MTL.P3F};
        ltaTable.("Velocity -1 Cycle")(iSpeeds) = {tpertInfo.(speeds{iSpeeds}).lta.MTV.b4F};
        ltaTable.("Velocity Onset")(iSpeeds) = {tpertInfo.(speeds{iSpeeds}).lta.MTV.P0F};
        ltaTable.("Velocity +1 Cycle")(iSpeeds) = {tpertInfo.(speeds{iSpeeds}).lta.MTV.P1F};
        ltaTable.("Velocity +2 Cycle")(iSpeeds) = {tpertInfo.(speeds{iSpeeds}).lta.MTV.P2F};
        ltaTable.("Velocity +3 Cycle")(iSpeeds) = {tpertInfo.(speeds{iSpeeds}).lta.MTV.P3F};
    end
end


% This loop creates a table of all the Right Medial Gastroc Values for MTV and MTL
% the step before perturbation, the onset step, and +1-3 steps after
% perturbation
for iSpeeds = 1:size(pertSpeed,1)
    if iSpeeds == 1 
        rmgTable = table(pertSpeed(iSpeeds),{tpertInfo.sp1.rmg.MTL.b4F}, {tpertInfo.sp1.rmg.MTL.P0F}, {tpertInfo.sp1.rmg.MTL.P1F}, {tpertInfo.sp1.rmg.MTL.P2F}, {tpertInfo.sp1.rmg.MTL.P3F},...
    {tpertInfo.sp1.rmg.MTV.b4F}, {tpertInfo.sp1.rmg.MTV.P0F}, {tpertInfo.sp1.rmg.MTV.P1F}, {tpertInfo.sp1.rmg.MTV.P2F}, {tpertInfo.sp1.rmg.MTV.P3F},...
    'VariableNames', {'dV';'Length -1 Cycle'; 'Length Onset'; 'Length +1 Cycle'; 'Length +2 Cycle'; 'Length +3 Cycle';...
    'Velocity -1 Cycle'; 'Velocity Onset'; 'Velocity +1 Cycle'; 'Velocity +2 Cycle'; 'Velocity +3 Cycle'});
    else 
        rmgTable.dV(iSpeeds) = pertSpeed(iSpeeds);
        rmgTable.("Length -1 Cycle")(iSpeeds) = {tpertInfo.(speeds{iSpeeds}).rmg.MTL.b4F};
        rmgTable.("Length Onset")(iSpeeds) = {tpertInfo.(speeds{iSpeeds}).rmg.MTL.P0F};
        rmgTable.("Length +1 Cycle")(iSpeeds) = {tpertInfo.(speeds{iSpeeds}).rmg.MTL.P1F};
        rmgTable.("Length +2 Cycle")(iSpeeds) = {tpertInfo.(speeds{iSpeeds}).rmg.MTL.P2F};
        rmgTable.("Length +3 Cycle")(iSpeeds) = {tpertInfo.(speeds{iSpeeds}).rmg.MTL.P3F};
        rmgTable.("Velocity -1 Cycle")(iSpeeds) = {tpertInfo.(speeds{iSpeeds}).rmg.MTV.b4F};
        rmgTable.("Velocity Onset")(iSpeeds) = {tpertInfo.(speeds{iSpeeds}).rmg.MTV.P0F};
        rmgTable.("Velocity +1 Cycle")(iSpeeds) = {tpertInfo.(speeds{iSpeeds}).rmg.MTV.P1F};
        rmgTable.("Velocity +2 Cycle")(iSpeeds) = {tpertInfo.(speeds{iSpeeds}).rmg.MTV.P2F};
        rmgTable.("Velocity +3 Cycle")(iSpeeds) = {tpertInfo.(speeds{iSpeeds}).rmg.MTV.P3F};
    end
end

% This loop creates a table of all the Right Lateral Gastroc Values for MTV and MTL
% the step before perturbation, the onset step, and +1-3 steps after
% perturbation
for iSpeeds = 1:size(pertSpeed,1)
    if iSpeeds == 1 
        rlgTable = table(pertSpeed(iSpeeds),{tpertInfo.sp1.rlg.MTL.b4F}, {tpertInfo.sp1.rlg.MTL.P0F}, {tpertInfo.sp1.rlg.MTL.P1F}, {tpertInfo.sp1.rlg.MTL.P2F}, {tpertInfo.sp1.rlg.MTL.P3F},...
    {tpertInfo.sp1.rlg.MTV.b4F}, {tpertInfo.sp1.rlg.MTV.P0F}, {tpertInfo.sp1.rlg.MTV.P1F}, {tpertInfo.sp1.rlg.MTV.P2F}, {tpertInfo.sp1.rlg.MTV.P3F},...
    'VariableNames', {'dV';'Length -1 Cycle'; 'Length Onset'; 'Length +1 Cycle'; 'Length +2 Cycle'; 'Length +3 Cycle';...
    'Velocity -1 Cycle'; 'Velocity Onset'; 'Velocity +1 Cycle'; 'Velocity +2 Cycle'; 'Velocity +3 Cycle'});
    else 
        rlgTable.dV(iSpeeds) = pertSpeed(iSpeeds);
        rlgTable.("Length -1 Cycle")(iSpeeds) = {tpertInfo.(speeds{iSpeeds}).rlg.MTL.b4F};
        rlgTable.("Length Onset")(iSpeeds) = {tpertInfo.(speeds{iSpeeds}).rlg.MTL.P0F};
        rlgTable.("Length +1 Cycle")(iSpeeds) = {tpertInfo.(speeds{iSpeeds}).rlg.MTL.P1F};
        rlgTable.("Length +2 Cycle")(iSpeeds) = {tpertInfo.(speeds{iSpeeds}).rlg.MTL.P2F};
        rlgTable.("Length +3 Cycle")(iSpeeds) = {tpertInfo.(speeds{iSpeeds}).rlg.MTL.P3F};
        rlgTable.("Velocity -1 Cycle")(iSpeeds) = {tpertInfo.(speeds{iSpeeds}).rlg.MTV.b4F};
        rlgTable.("Velocity Onset")(iSpeeds) = {tpertInfo.(speeds{iSpeeds}).rlg.MTV.P0F};
        rlgTable.("Velocity +1 Cycle")(iSpeeds) = {tpertInfo.(speeds{iSpeeds}).rlg.MTV.P1F};
        rlgTable.("Velocity +2 Cycle")(iSpeeds) = {tpertInfo.(speeds{iSpeeds}).rlg.MTV.P2F};
        rlgTable.("Velocity +3 Cycle")(iSpeeds) = {tpertInfo.(speeds{iSpeeds}).rlg.MTV.P3F};
    end
end

% This loop creates a table of all the Right Soleus Values for MTV and MTL
% the step before perturbation, the onset step, and +1-3 steps after
% perturbation
for iSpeeds = 1:size(pertSpeed,1)
    if iSpeeds == 1 
        rsolTable = table(pertSpeed(iSpeeds),{tpertInfo.sp1.rsol.MTL.b4F}, {tpertInfo.sp1.lsol.MTL.P0F}, {tpertInfo.sp1.rsol.MTL.P1F}, {tpertInfo.sp1.rsol.MTL.P2F}, {tpertInfo.sp1.rsol.MTL.P3F},...
    {tpertInfo.sp1.rsol.MTV.b4F}, {tpertInfo.sp1.rsol.MTV.P0F}, {tpertInfo.sp1.rsol.MTV.P1F}, {tpertInfo.sp1.rsol.MTV.P2F}, {tpertInfo.sp1.rsol.MTV.P3F},...
    'VariableNames', {'dV';'Length -1 Cycle'; 'Length Onset'; 'Length +1 Cycle'; 'Length +2 Cycle'; 'Length +3 Cycle';...
    'Velocity -1 Cycle'; 'Velocity Onset'; 'Velocity +1 Cycle'; 'Velocity +2 Cycle'; 'Velocity +3 Cycle'});
    else 
        rsolTable.dV(iSpeeds) = pertSpeed(iSpeeds);
        rsolTable.("Length -1 Cycle")(iSpeeds) = {tpertInfo.(speeds{iSpeeds}).rsol.MTL.b4F};
        rsolTable.("Length Onset")(iSpeeds) = {tpertInfo.(speeds{iSpeeds}).rsol.MTL.P0F};
        rsolTable.("Length +1 Cycle")(iSpeeds) = {tpertInfo.(speeds{iSpeeds}).rsol.MTL.P1F};
        rsolTable.("Length +2 Cycle")(iSpeeds) = {tpertInfo.(speeds{iSpeeds}).rsol.MTL.P2F};
        rsolTable.("Length +3 Cycle")(iSpeeds) = {tpertInfo.(speeds{iSpeeds}).rsol.MTL.P3F};
        rsolTable.("Velocity -1 Cycle")(iSpeeds) = {tpertInfo.(speeds{iSpeeds}).rsol.MTV.b4F};
        rsolTable.("Velocity Onset")(iSpeeds) = {tpertInfo.(speeds{iSpeeds}).rsol.MTV.P0F};
        rsolTable.("Velocity +1 Cycle")(iSpeeds) = {tpertInfo.(speeds{iSpeeds}).rsol.MTV.P1F};
        rsolTable.("Velocity +2 Cycle")(iSpeeds) = {tpertInfo.(speeds{iSpeeds}).rsol.MTV.P2F};
        rsolTable.("Velocity +3 Cycle")(iSpeeds) = {tpertInfo.(speeds{iSpeeds}).rsol.MTV.P3F};
    end
end

% This loop creates a table of all the Left Tib Ant Values for MTV and MTL
% the step before perturbation, the onset step, and +1-3 steps after
% perturbation
for iSpeeds = 1:size(pertSpeed,1)
    if iSpeeds == 1 
        rtaTable = table(pertSpeed(iSpeeds),{tpertInfo.sp1.rta.MTL.b4F}, {tpertInfo.sp1.rta.MTL.P0F}, {tpertInfo.sp1.rta.MTL.P1F}, {tpertInfo.sp1.rta.MTL.P2F}, {tpertInfo.sp1.rta.MTL.P3F},...
    {tpertInfo.sp1.rta.MTV.b4F}, {tpertInfo.sp1.rta.MTV.P0F}, {tpertInfo.sp1.rta.MTV.P1F}, {tpertInfo.sp1.rta.MTV.P2F}, {tpertInfo.sp1.rta.MTV.P3F},...
    'VariableNames', {'dV';'Length -1 Cycle'; 'Length Onset'; 'Length +1 Cycle'; 'Length +2 Cycle'; 'Length +3 Cycle';...
    'Velocity -1 Cycle'; 'Velocity Onset'; 'Velocity +1 Cycle'; 'Velocity +2 Cycle'; 'Velocity +3 Cycle'});
    else 
        rtaTable.dV(iSpeeds) = pertSpeed(iSpeeds);
        rtaTable.("Length -1 Cycle")(iSpeeds) = {tpertInfo.(speeds{iSpeeds}).rta.MTL.b4F};
        rtaTable.("Length Onset")(iSpeeds) = {tpertInfo.(speeds{iSpeeds}).rta.MTL.P0F};
        rtaTable.("Length +1 Cycle")(iSpeeds) = {tpertInfo.(speeds{iSpeeds}).rta.MTL.P1F};
        rtaTable.("Length +2 Cycle")(iSpeeds) = {tpertInfo.(speeds{iSpeeds}).rta.MTL.P2F};
        rtaTable.("Length +3 Cycle")(iSpeeds) = {tpertInfo.(speeds{iSpeeds}).rta.MTL.P3F};
        rtaTable.("Velocity -1 Cycle")(iSpeeds) = {tpertInfo.(speeds{iSpeeds}).rta.MTV.b4F};
        rtaTable.("Velocity Onset")(iSpeeds) = {tpertInfo.(speeds{iSpeeds}).rta.MTV.P0F};
        rtaTable.("Velocity +1 Cycle")(iSpeeds) = {tpertInfo.(speeds{iSpeeds}).rta.MTV.P1F};
        rtaTable.("Velocity +2 Cycle")(iSpeeds) = {tpertInfo.(speeds{iSpeeds}).rta.MTV.P2F};
        rtaTable.("Velocity +3 Cycle")(iSpeeds) = {tpertInfo.(speeds{iSpeeds}).rta.MTV.P3F};
    end
end



%% Saving the data tables in the individual subjects folder 

% Setting the location to the subjects' data folder 
if ispc
    subLoc = ['G:\Shared drives\NeuroMobLab\Projects\Perception\Processed Data\Dan\OpenSim\YAPercep Outputs\' subject1];
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
     tabLoc = ['G:\Shared drives\NeuroMobLab\Projects\Perception\Processed Data\Dan\OpenSim\YAPercep Outputs\' subject1 filesep 'Data Tables' filesep];
elseif ismac
    tabLoc = [''];
else
    tabLoc = input('Please enter the location where the tables should be saved.' ,'s');
end

% Saving the MTL and MTV Table per muscle 
save([tabLoc 'MTLNVTables_' subject1], 'lmgTable', 'llgTable', 'lsolTable', 'ltaTable', 'rmgTable', 'rlgTable', 'rsolTable', 'rtaTable', '-v7.3');


disp(['Tables saved for ' subject1]);
end

