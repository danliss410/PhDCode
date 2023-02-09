function [LpertGC,RpertGC] = calcPertGCTables(strSubject)
%This function creates two tables, one for each leg about the perturbation
%information that happens for each subject so information can be accessed
%more easily. 
%%%%%%%%%%%%%%%%%%%%%%%%% Example Call 
% [LpertGC,RpertGC] = calcPertGCTables('15')

% INPUTS: subject               - a string of the subjects unique identifier for the
%                                   Perception study.
%
%
% OUPUT: LpertGC/RpertGC      - a table that has all information about the
%                               perturbations a subject receives. The table
%                               has all GCs, what GCs have perturbations
%                               for either leg, the leg the perturbation
%                               was on, the speed, whether it was
%                               perceived, and all the frames for
%                               gaitevents. There is a table saved for each
%                               leg and the gait cycles correspond to what
%                               leg table it is saved in. 


%
% Created: 1 October 2021, DJL
% Modified: (format: date, initials, change made)
%   1 -  
%   2 - 


%%%%%%%%%%%%%%%% THINGS THAT STILL NEED TO BE ADDED %%%%%%%%%%%%%%%%%%%%%%
% 1 - 


%% Create subject name to load the necessary files for the subject 
% Naming convention for each log file "YAPercep##_" + YesNo or 2AFC or Cog

subjectYesNo = ['YAPercep' strSubject '_YesNo'];

subject2AFC = ['YAPercep' strSubject '_2AFC'];

subjectCog = ['YAPercep' strSubject '_Cog'];

subject1 = ['YAPercep' strSubject];

namePercep = {'Percep01'; 'Percep02'; 'Percep03'; 'Percep04'; 'Percep05'; 'Percep06';}; %

%% Loading the necessary log file for the subject
fileLocation = 'G:\Shared drives\NeuroMobLab\Experimental Data\Log Files\Pilot Experiments\PerceptionStudy\';
data1 = readtable([fileLocation subjectYesNo]);
Percep = data1(:,[1,2,3,6,9]); % Grabbing specific columns from table: Trial number, Perturbation number, Leg, dV, perceived 

clear data1 fileLocation
%% This will load the necessary workspace 
% for now this just has the necessary tables that are 
% This section will load analogTable, gaitEventsTable,
% BodyAnalysisTable, and videoTable(This will not be used)

load(['G:\Shared drives\NeuroMobLab\Projects\Perception\Processed Data\Dan\OpenSim\YAPercep Outputs\' subject1 '\Data Tables\BodyAnalysisTable_' subject1 '.mat'])
% load(['G:\Shared drives\NeuroMobLab\Projects\Perception\Processed Data\Dan\OpenSim\YAPercep Outputs\' subject1 '\Data Tables\IKTable_' subject1 '.mat'])
load(['G:\Shared drives\NeuroMobLab\Projects\Perception\Processed Data\Dan\Matlab Analysis\' subject1 '\Data Tables\SepTables_' subject1 '.mat'])
load(['G:\Shared drives\NeuroMobLab\Projects\Perception\Processed Data\Dan\Matlab Analysis\' subject1 '\Data Tables\pertCycleStruc_' subject1 '.mat'])
load(['G:\Shared drives\NeuroMobLab\Projects\Perception\Processed Data\Dan\Matlab Analysis\' subject1 '\Data Tables\pertTable_' subject1 '.mat'])


%% Building the tables for each segment of the perception trial 
% Table should read 
% 1 - Perception trial Number, 2- Cell of GC for that, 3 - Cell of Logical
% for Pert or not, 4- Cell of string of leg the pert happened on, 5- Speed
% of the perturbation, 6 to w/e - Gait Events frames for whatever side

loopLen = length(pertTable.Trial);


for iTrial = 1:loopLen
    % Grabbing all the left leg information 
    leftGC.(pertTable.Trial{iTrial}) = (1:1:length(gaitEventsTable.("Gait_Events_Left"){iTrial}))'; % Creating an array that counts from 1 to the number of GCs for the left leg on a given perception trial
    leftGCNum.(pertTable.Trial{iTrial}) = pertTable.("Left_Gait_Cycle_Num"){iTrial}; % Grabbing the gait cycle numbers that the perturbation occurred on the left leg 
    leftPerceived.(pertTable.Trial{iTrial}) = pertTable.("Left_Pert_Perceived"){iTrial}; % Grabbing whether the perturbation was percieved or not 
    leftSpeed.(pertTable.Trial{iTrial}) = pertTable.("Left_Pert_Speed"){iTrial}; % Getting the speed of each of the perturbations 
    
    % Grabbing all the right leg information 
    rightGC.(pertTable.Trial{iTrial}) = (1:1:length(gaitEventsTable.("Gait_Events_Right"){iTrial}))'; % Creating an array that counts from 1 to the number of GCs for the right leg on a given perception trial
    rightGCNum.(pertTable.Trial{iTrial}) = pertTable.("Right_Gait_Cycle_Num"){iTrial}; % Getting the GCNum the right leg perturbations occurred on 
    rightPerceived.(pertTable.Trial{iTrial}) = pertTable.("Right_Pert_Perceived"){iTrial}; % Getting whether the perturbation was perceived or not 
    rightSpeed.(pertTable.Trial{iTrial}) = pertTable.("Right_Pert_Speed"){iTrial}; %Grabbing the speed of each of the right perturbations  
end

%% Creating additional variables that will be used in the tables 

for iTrial = 1:loopLen
    % Making empty cell or double arrays to be filled with the GC the
    % perturbations occurr on 
    tempLeftLeg.(pertTable.Trial{iTrial}) = cell(size(leftGC.(pertTable.Trial{iTrial})));
    tempLeftPert.(pertTable.Trial{iTrial}) = zeros(size(leftGC.(pertTable.Trial{iTrial})));
    tempLeftSpeed.(pertTable.Trial{iTrial}) = NaN(size(leftGC.(pertTable.Trial{iTrial})));
    tempLeftPerceived.(pertTable.Trial{iTrial}) = cell(size(leftGC.(pertTable.Trial{iTrial})));
    % Making empty cell or double arrays to be filled with the GC the
    % perturbations occurr on 
    tempRightLeg.(pertTable.Trial{iTrial}) = cell(size(rightGC.(pertTable.Trial{iTrial})));
    tempRightPert.(pertTable.Trial{iTrial}) = zeros(size(rightGC.(pertTable.Trial{iTrial})));
    tempRightSpeed.(pertTable.Trial{iTrial}) = NaN(size(rightGC.(pertTable.Trial{iTrial})));
    tempRightPerceived.(pertTable.Trial{iTrial}) = cell(size(rightGC.(pertTable.Trial{iTrial})));
    % This is for the left leg perturbations 
    for ileftPert = 1:size(leftGCNum.(pertTable.Trial{iTrial}),2) % This will run for each of the left leg perturbations in the subsection 
        tempLeftPert.(pertTable.Trial{iTrial})(leftGCNum.(pertTable.Trial{iTrial})(ileftPert)) = 1; % Labeling the GC that the perturbations happen on 
        tempLeftLeg.(pertTable.Trial{iTrial}){leftGCNum.(pertTable.Trial{iTrial})(ileftPert)} = 'L'; % Labeling the left leg for the GC
        tempLeftSpeed.(pertTable.Trial{iTrial})(leftGCNum.(pertTable.Trial{iTrial})(ileftPert)) = leftSpeed.(pertTable.Trial{iTrial})(ileftPert); % Labeling the speed of the perturbation for the GC
        tempLeftPerceived.(pertTable.Trial{iTrial}){leftGCNum.(pertTable.Trial{iTrial})(ileftPert)} = leftPerceived.(pertTable.Trial{iTrial})(ileftPert); % labeling whether or not the perturbation was perceived 
        % This section is for the right GC table including the left leg
        % perturbations
        tempRightPert.(pertTable.Trial{iTrial})(leftGCNum.(pertTable.Trial{iTrial})(ileftPert)) = 1;
        tempRightLeg.(pertTable.Trial{iTrial}){leftGCNum.(pertTable.Trial{iTrial})(ileftPert)} = 'L';
        tempRightSpeed.(pertTable.Trial{iTrial})(leftGCNum.(pertTable.Trial{iTrial})(ileftPert)) = leftSpeed.(pertTable.Trial{iTrial})(ileftPert);
        tempRightPerceived.(pertTable.Trial{iTrial}){leftGCNum.(pertTable.Trial{iTrial})(ileftPert)} = leftPerceived.(pertTable.Trial{iTrial})(ileftPert);
    end
    
    % This is for the right leg perturbations 
    for iRightPert = 1:size(rightGCNum.(pertTable.Trial{iTrial}),2)
        tempRightPert.(pertTable.Trial{iTrial})(rightGCNum.(pertTable.Trial{iTrial})(iRightPert)) = 1; 
        tempRightLeg.(pertTable.Trial{iTrial}){rightGCNum.(pertTable.Trial{iTrial})(iRightPert)} = 'R';
        tempRightSpeed.(pertTable.Trial{iTrial})(rightGCNum.(pertTable.Trial{iTrial})(iRightPert)) = rightSpeed.(pertTable.Trial{iTrial})(iRightPert); 
        tempRightPerceived.(pertTable.Trial{iTrial}){rightGCNum.(pertTable.Trial{iTrial})(iRightPert)} = rightPerceived.(pertTable.Trial{iTrial})(iRightPert); 
        % This is for left leg 
        tempLeftPert.(pertTable.Trial{iTrial})(rightGCNum.(pertTable.Trial{iTrial})(iRightPert)) = 1; 
        tempLeftLeg.(pertTable.Trial{iTrial}){rightGCNum.(pertTable.Trial{iTrial})(iRightPert)} = 'R';
        tempLeftSpeed.(pertTable.Trial{iTrial})(rightGCNum.(pertTable.Trial{iTrial})(iRightPert)) = rightSpeed.(pertTable.Trial{iTrial})(iRightPert); 
        tempLeftPerceived.(pertTable.Trial{iTrial}){rightGCNum.(pertTable.Trial{iTrial})(iRightPert)} = rightPerceived.(pertTable.Trial{iTrial})(iRightPert); 
    end
end


%% This section will be building the table 
% Tables will be created for both the right and left legs 

for iTrial = 1:loopLen
    if iTrial == 1 
        LpertGC = table({pertTable.Trial{iTrial}}, {leftGC.(pertTable.Trial{iTrial})}, {tempLeftPert.(pertTable.Trial{iTrial})},...
            {tempLeftLeg.(pertTable.Trial{iTrial})}, {tempLeftSpeed.(pertTable.Trial{iTrial})}, {tempLeftPerceived.(pertTable.Trial{iTrial})}, ...
            {gaitEventsTable.("Gait_Events_Left"){iTrial,1}(:,1)}, {gaitEventsTable.("Gait_Events_Left"){iTrial,1}(:,2)},...
            {gaitEventsTable.("Gait_Events_Left"){iTrial,1}(:,3)}, {gaitEventsTable.("Gait_Events_Left"){iTrial,1}(:,4)},...
            {gaitEventsTable.("Gait_Events_Left"){iTrial,1}(:,5)}, ...
            'VariableNames', {'Trial'; 'Left_GCs'; 'Perts'; 'Leg'; 'Speed'; 'Perceived'; 'LHS'; 'RTO'; 'RHS'; 'LTO'; 'LHS_2';});
        
        RpertGC = table({pertTable.Trial{iTrial}}, {rightGC.(pertTable.Trial{iTrial})}, {tempRightPert.(pertTable.Trial{iTrial})},...
            {tempRightLeg.(pertTable.Trial{iTrial}) }, {tempRightSpeed.(pertTable.Trial{iTrial})}, {tempRightPerceived.(pertTable.Trial{iTrial})}, ...
            {gaitEventsTable.("Gait_Events_Right"){iTrial,1}(:,1)}, {gaitEventsTable.("Gait_Events_Right"){iTrial,1}(:,2)},...
            {gaitEventsTable.("Gait_Events_Right"){iTrial,1}(:,3)}, {gaitEventsTable.("Gait_Events_Right"){iTrial,1}(:,4)},...
            {gaitEventsTable.("Gait_Events_Right"){iTrial,1}(:,5)}, ...
            'VariableNames', {'Trial'; 'Right_GCs'; 'Perts'; 'Leg'; 'Speed'; 'Perceived'; 'RHS'; 'LTO'; 'LHS'; 'RTO'; 'RHS_2';});
    else
        %Filling the left GC table 
        LpertGC.Trial{iTrial} = pertTable.Trial{iTrial};
        LpertGC.Left_GCs{iTrial} = leftGC.(pertTable.Trial{iTrial});
        LpertGC.Perts{iTrial} = tempLeftPert.(pertTable.Trial{iTrial});
        LpertGC.Leg{iTrial} = tempLeftLeg.(pertTable.Trial{iTrial}); 
        LpertGC.Speed{iTrial} = tempLeftSpeed.(pertTable.Trial{iTrial});
        LpertGC.Perceived{iTrial} = tempLeftPerceived.(pertTable.Trial{iTrial});
        LpertGC.('LHS'){iTrial} = gaitEventsTable.("Gait_Events_Left"){iTrial,1}(:,1);
        LpertGC.RTO{iTrial} = gaitEventsTable.("Gait_Events_Left"){iTrial,1}(:,2);
        LpertGC.RHS{iTrial} = gaitEventsTable.("Gait_Events_Left"){iTrial,1}(:,3);
        LpertGC.LTO{iTrial} = gaitEventsTable.("Gait_Events_Left"){iTrial,1}(:,4);
        LpertGC.('LHS_2'){iTrial} = gaitEventsTable.("Gait_Events_Left"){iTrial,1}(:,5);
        
        %Filling the right GC table
        RpertGC.Trial{iTrial} = pertTable.Trial{iTrial};
        RpertGC.Right_GCs{iTrial} = rightGC.(pertTable.Trial{iTrial});
        RpertGC.Perts{iTrial} = tempRightPert.(pertTable.Trial{iTrial});
        RpertGC.Leg{iTrial} = tempRightLeg.(pertTable.Trial{iTrial}); 
        RpertGC.Speed{iTrial} = tempRightSpeed.(pertTable.Trial{iTrial});
        RpertGC.Perceived{iTrial} = tempRightPerceived.(pertTable.Trial{iTrial});
        RpertGC.('RHS'){iTrial} = gaitEventsTable.("Gait_Events_Right"){iTrial,1}(:,1);
        RpertGC.LTO{iTrial} = gaitEventsTable.("Gait_Events_Right"){iTrial,1}(:,2);
        RpertGC.LHS{iTrial} = gaitEventsTable.("Gait_Events_Right"){iTrial,1}(:,3);
        RpertGC.RTO{iTrial} = gaitEventsTable.("Gait_Events_Right"){iTrial,1}(:,4);
        RpertGC.('RHS_2'){iTrial} = gaitEventsTable.("Gait_Events_Right"){iTrial,1}(:,5);        
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

% Saving the right and left GC information tables about all perturbations
save([tabLoc 'GCTables_' subject1], 'RpertGC', 'LpertGC', '-v7.3');


