function [pertTiming] = treadmillPertTiming(strSub, domLeg, pertPos, pertNeg)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
%% Creating a directory of the mat files to load 

%% Loading the GETableFull for each subject 
load(['G:\Shared drives\Perception Project\Ultrasound\OpenSim\YAUSPercep' ...
    strSub '\Tables\gaitEventsTable_YAUSPercep' strSub '.mat']);

%% 
% Changing the string passed to a number so that the correct perturbation
% numbers can be used
sub = str2double(strSub);
% Getting the correct positive perturbations for the subject
posPerts = pertPos{sub,1};
% Getting the correct negative perturbations for the subject
negPerts = pertNeg{sub,1};

% Making a loop to indetify the gait cycle the perturbation happened for
% positive perturbations  
for iPos = 1:length(posPerts)
    if posPerts(iPos) < 10
        tempPosPertNum = ['0' num2str(posPerts(iPos))];
    else
        tempPosPertNum = num2str(posPerts(iPos));
    end
    % Loading the indivdiual Positive Perturbation rawData struct
    load(['G:\Shared drives\Perception Project\Ultrasound\OpenSim\YAUSPercep' strSub '\MatFiles\YNPercep' tempPosPertNum '.mat']); 

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
        % Calculating the timing of the perturbations
        tempTiming = pertLoc - GE_RHS(gaitEvent);
        if tempTiming*10 > 180
            figure; plot(rawData.treadmill.right); 
            hold on; 
            xline(GE_RHS(gaitEvent)); 
            keyboard;
            newTiming = input("Enter the actual value of when the perturbation reaches full speed: ");
            tempTiming = newTiming - GE_RHS(gaitEvent);
            close all
        end
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
        % Calculating the timing of the perturbations
        tempTiming = pertLoc - GE_LHS(gaitEvent);
        if tempTiming*10 > 180
            figure; plot(rawData.treadmill.left); 
            hold on; 
            xline(GE_LHS(gaitEvent)); 
            keyboard;
            newTiming = input("Enter the actual value of when the perturbation reaches full speed: ");
            tempTiming = newTiming - GE_LHS(gaitEvent);
            close all
        end
    end
    % Putting the Pert Onset timing in ms. Multiplied by 10 because values
    % are recorded in 100 Hz
    GETableFull.Pert_Timing(tempC) = tempTiming*10;
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
    load(['G:\Shared drives\Perception Project\Ultrasound\OpenSim\YAUSPercep' strSub '\MatFiles\YNPercep' tempNegPertNum '.mat']); 

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
        % Calculating the timing of the perturbations
        tempTiming = pertLoc - GE_RHS(gaitEvent);
        if tempTiming*10 > 180
            figure; plot(rawData.treadmill.right); 
            hold on; 
            xline(GE_RHS(gaitEvent)); 
            keyboard;
            newTiming = input("Enter the actual value of when the perturbation reaches full speed: ");
            tempTiming = newTiming - GE_RHS(gaitEvent);
            close all
        end
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
        % Calculating the timing of the perturbations
        tempTiming = pertLoc - GE_LHS(gaitEvent);
        if tempTiming*10 > 180
            figure; plot(rawData.treadmill.left); 
            hold on; 
            xline(GE_LHS(gaitEvent)); 
            keyboard;
            newTiming = input("Enter the actual value of when the perturbation reaches full speed: ");
            tempTiming = newTiming - GE_LHS(gaitEvent);
            close all 
        end
    end

    % Putting the Pert Onset timing in ms. Multiplied by 10 because values
    % are recorded in 100 Hz
    GETableFull.Pert_Timing(tempC) = tempTiming*10;
  
end


pertTiming = GETableFull.Pert_Timing; 

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