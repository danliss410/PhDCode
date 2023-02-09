subjects = {'01';'02'; '03'; '04'; '05'; '06'; '07'; '08'; '09'; '10'; '11'; '12';}; % Place the subject numbers here 
legs = {'R';'R';'R';'R';'R';'R';'L';'R';'R';'R';'R';'L';}; % Place the subjects preferred legs in here
pertPos = {[16,20,29,61,73,74,93,97,129,141]; [13,17,26,58,69,70,89,93,125,136];...
    [1,3,24,29,32,54,61,84,89,94]; [1,4,25,30,33,55,61,68,84,89];...
    [1,3,24,29,32,54,61,68,84,89]; [1,3,24,29,32,54,61,68,84,89];...
    [1,3,24,29,32,55,64,71,87,92]; [27,29, 30, 57,60, 82,89,96,112,117];...
    [18,52,60,67,71,72,76,78,81,90]; [1,3,24,29,32,54,61,68,84,89];...
    [3,4,11,14,24,32,38,64,84,89]; [3,24,29,32,54,61,68,84,89];};
pertNeg = {[10,12,24,31,33,58,80,99,102,108]; [2,9,30,48,55,76,85,95,100,149];...
    [2,18,30,37,44,52,56,78,86,87]; [7,19,20,35,38,45,46,78,80,87];...
    [2,18,30,37,44,52,56,78,86,87]; [2,18,30,37,44,52,56,78,86,87];...
    [2,25,30,39,43,50,53,57,66,89]; [28,53,58,67,71,77,80,84,91,114];...
    [5,20,32,39,46,54,58,80,88,89]; [2,18,30,37,44,52,56,78,86,87];...
    [2,25,30,39,43,49,52,56,63,86]; [17,20,25,28,39,43,46,49,59,63];};

%% 
subnum = 1; 
strSub = subjects{subnum};
domLeg = legs{subnum};


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
            close all
        end
    end
    % Putting the Pert Onset timing in ms. Multiplied by 10 because values
    % are recorded in 100 Hz
    GETableFull.PertSpeed(tempC) = input("Input the Pert Speed level:");
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
            close all 
        end
    end
    GETableFull.PertSpeed(tempC) = input("Input the Pert Speed level:");
  
end
