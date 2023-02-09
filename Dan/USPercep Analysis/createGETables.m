function GETableFull = createGETables(strSub, domLeg, pertPos, pertNeg)
% This function creates the gaitcycle matrices and finds the perturbed gait
% cycle for the ultrasound perception experiment. 
% INPUTS: strSub               - a string of the subjects unique identifier for the
%                                   Perception study.
%         domLeg                - a string with the subject's dominant leg
%
%
%         pertPos               - matrix of the positive perturbations
%                                 surrounding
%                                 each subject's perception threshold. 
%
%       pertNeg                 - matrix of the negative perturbation
%                               speeds surrounding each subject's
%                               perception threshold.
%
%
%
% OUPUT: GETableFull            - a table that gaitcycle tables for both legs.
%                                Also, contains the gait cycle that is perturbed.  
%
%
% Created: 1 November 2022, DJL
% Modified: (format: date, initials, change made)
%   1 - 

%% Creating a directory of the mat files to load to create gaitEvents tables 
subLoc = dir(['G:\Shared drives\Perception Project\Ultrasound\OpenSim\YAUSPercep' strSub '\MatFiles']);
% Making the directory for just perturbation trials 
subLoc = subLoc(4:end);

%% Creating Gait Events Table from Vicon Data 
for iDir = 1:length(subLoc)
    % Changing the folder to load the files 
    cd(subLoc(1).folder);
    load(subLoc(iDir).name); 
    % Creating a GaitEventsMatrix for the right leg events 
    GaitEvents_Right = createGaitEventsMatrix(rawData.video.GaitEvents.RHSframe,...
        rawData.video.GaitEvents.RTOframe, rawData.video.GaitEvents.LHSframe,...
        rawData.video.GaitEvents.LTOframe);
    
    % Converting the matrix to a table to be saved 
    GETable_Right = array2table(GaitEvents_Right);
    % Making the correct gait event labels for the table
    GETable_Right.Properties.VariableNames = {'RHS'; 'LTO'; 'LHS'; 'RTO'; 'RHS_2'};
    
    % Creating a GaitEventsMatrix for the left leg events
    GaitEvents_Left = createGaitEventsMatrix(rawData.video.GaitEvents.LHSframe,...
        rawData.video.GaitEvents.LTOframe, rawData.video.GaitEvents.RHSframe,...
        rawData.video.GaitEvents.RTOframe);
    
    % Converting the matrix to a table to be saved 
    GETable_Left = array2table(GaitEvents_Left);
    % Making the correct gait event labels for the table
    GETable_Left.Properties.VariableNames = {'LHS'; 'RTO'; 'RHS'; 'LTO'; 'LHS_2'};

    % Creating a new table full of gaitevents for all trials for a subject
    if iDir == 1
        GETableFull = table({subLoc(iDir).name}, {GETable_Right}, ...
        {GETable_Left}, [0], 'VariableNames', {'Trial'; 'GETable_Right';...
        'GETable_Left'; 'Pert_Cycle';});
    else
        GETableFull.Trial(iDir) = {subLoc(iDir).name};
        GETableFull.GETable_Right(iDir) = {GETable_Right};
        GETableFull.GETable_Left(iDir) = {GETable_Left};
        GETableFull.Pert_Cycle(iDir) = [0];
    end
end

% Changing the string passed to a number so that the correct perturbation
% numbers can be used
sub = str2double(strSub);
% Getting the correct positive perturbations for the subject
posPerts = pertPos{sub,1};
% Getting the correct negative perturbations for the subject
negPerts = pertNeg{sub,1};

%%
% Making a loop to indetify the gait cycle the perturbation happened for
% positive perturbations  
for iPos = 1:length(posPerts)
    if posPerts(iPos) < 10
        tempPosPertNum = ['0' num2str(posPerts(iPos))];
    else
        tempPosPertNum = num2str(posPerts(iPos));
    end
    % Loading the indivdiual Positive Perturbation rawData struct
    load(['YNPercep' tempPosPertNum '.mat']); 

    % Finding the correct gaitevents table 
    tempC = contains(GETableFull.Trial, ['YNPercep' tempPosPertNum '.mat']);
    
    if domLeg == 'R'
        % Getting the gait events for right leg dominant subjects
        tempGE = GETableFull.GETable_Right{tempC};
        GE_RHS = table2array(tempGE(:,1));
       
        % Finding the perturbation speed in the treadmill speed data 
        tempPert = min(rawData.treadmill.right(GE_RHS(1):GE_RHS(end)));
        % Getting the perturbation location in the treadmill frame data
        pertLoc = find(tempPert == rawData.treadmill.right);
        % Getting the gaitEvent id 
        gaitEvent = find(GE_RHS < pertLoc, 1, 'last');
    else
        % Getting the gait events for left leg dominant subjects
        tempGE = GETableFull.GETable_Left{tempC};
        GE_LHS = table2array(tempGE(:,1));

        % Finding the perturbation speed in the treadmill speed data 
        tempPert = min(rawData.treadmill.left(GE_LHS(1):GE_LHS(end)));
        % Getting the perturbation location in the treadmill frame data
        pertLoc = find(tempPert == rawData.treadmill.left);
        % Getting the gaitEvent id 
        gaitEvent = find(GE_LHS < pertLoc, 1, 'last');
    end
    % Placing the perturbed gait cycle into the table 
    GETableFull.Pert_Cycle(tempC) = gaitEvent;
  
end



% Making a loop to indetify the gait cycle the perturbation happened for
% positive perturbations  
for iNeg = 1:length(negPerts)
    if negPerts(iNeg) < 10
        tempNegPertNum = ['0' num2str(negPerts(iNeg))];
    else
        tempNegPertNum = num2str(negPerts(iNeg));
    end
    % Loading the indivdiual Positive Perturbation rawData struct
    load(['YNPercep' tempNegPertNum '.mat']); 

    % Finding the correct gaitevents table 
    tempC = contains(GETableFull.Trial, ['YNPercep' tempNegPertNum '.mat']);
    
    if domLeg == 'R'
        % Getting the gait events for right leg dominant subjects
        tempGE = GETableFull.GETable_Right{tempC};
        GE_RHS = table2array(tempGE(:,1));
        if GE_RHS(1) < 10
            % Finding the perturbation speed in the treadmill speed data 
            tempPert = max(rawData.treadmill.right(GE_RHS(2):GE_RHS(end)));
        else
            % Finding the perturbation speed in the treadmill speed data 
            tempPert = max(rawData.treadmill.right(GE_RHS(1):GE_RHS(end)));
        end
        % Getting the perturbation location in the treadmill frame data
        pertLoc = find(tempPert == rawData.treadmill.right);
        % Getting the gaitEvent id 
        gaitEvent = find(GE_RHS < pertLoc, 1, 'last');
    else
        % Getting the gait events for left leg dominant subjects
        tempGE = GETableFull.GETable_Left{tempC};
        GE_LHS = table2array(tempGE(:,1));
        
        if GE_LHS(1) < 10
            % Finding the perturbation speed in the treadmill speed data 
            tempPert = max(rawData.treadmill.left(GE_LHS(2):GE_LHS(end)));
        else
            % Finding the perturbation speed in the treadmill speed data 
            tempPert = max(rawData.treadmill.left(GE_LHS(1):GE_LHS(end)));
        end
        % Getting the perturbation location in the treadmill frame data
        pertLoc = find(tempPert == rawData.treadmill.left);
        % Getting the gaitEvent id 
        gaitEvent = find(GE_LHS < pertLoc, 1, 'last');
    end
    % Placing the perturbed gait cycle into the table 
    GETableFull.Pert_Cycle(tempC) = gaitEvent;
  
end

%% Save the table to the subjects folder 
% Changing the directory to save the gaitevents table in the subjects
% folder
saveLoc = ['G:\Shared drives\Perception Project\Ultrasound\OpenSim\YAUSPercep' strSub '\Tables\'];
% Creating the subject1 name
subject1 = ['YAUSPercep' strSub];
keyboard
% Saving the gaitEvents table in the subject folder 
save([saveLoc 'gaitEventsTable_' subject1], 'GETableFull', '-v7.3');



end