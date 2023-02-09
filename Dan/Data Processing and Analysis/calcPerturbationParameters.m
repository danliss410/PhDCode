function [pertTable] = calcPerturbationParameters(strSubject)
%
% [pertTable] = calcPerturbationParameters(subject)
%
% This function will calculate the perturbation parameters for walking perturbations during the 
%  perception study. The table will have the information from the log file
%  for each subject such as perturbation number, perturbation original
%  speed, leg the perturbation occured on, and if the perturbation was
%  perceived or not. The table will have information from other subject
%  tables such as IKTable, gaitEventsTable, and analogTable.
%  The table will have magnitude of peak speed for Perturbation, peak perturbation
%  timing, 
%
% INPUTS: subject               - a string of the subjects unique identifier for the
%                                   Perception study.
%
%
% OUPUT: pertTable            - a table that has for each leg perturbation number, perturbation original speed
%                               , if the perturbation was perceived,
%                               magnitude of the perturbation sent, peak
%                               perturbation timing, gait cycle
%                               perturbation occured on 
% 
% 
% 
% 
% 
%
% Created: 1 September 2020, DJL
% Modified: (format: date, initials, change made)
%   1 -  12/17/2020, DJL, Fixed the lines where it was grabbing the wrong
%   gait cycle for large perutbations 
%   2 - 9/28/2021, DJL, Changed the tables being called and the portions of
%   the table to have underscores.
% Things that need to be added 
%   1 - Cognitive or 2AFC trials 





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
%% Loading the remaining tables for the subject 
% This section will load analogTable, gaitEventsTable,
% BodyAnalysisTable, and videoTable(This will not be used)

load(['G:\Shared drives\NeuroMobLab\Projects\Perception\Processed Data\Dan\OpenSim\YAPercep Outputs\' subject1 '\Data Tables\BodyAnalysisTable_' subject1 '.mat'])
load(['G:\Shared drives\NeuroMobLab\Projects\Perception\Processed Data\Dan\Matlab Analysis\' subject1 '\Data Tables\SepTables_' subject1 '.mat'])

%% Finding Perturbation Timing
pTrials = contains(analogTable.Trial, 'Percep'); % Finding which rows in the table contain the Perception Trials

pTrials = pTrials(pTrials == 1); %Selecting only the indicies that have Perception trials


for iTrials = 1:size(pTrials,1)
    clear tempPeaks peaktime A iPeaks B C 
    tempPeaks = analogTable.("EP_Signal"){iTrials,1} > 1.5; % Finding indicies the electric potential signal is greater than 1.5 V (This is the signal sent when we click run perturbation)
    peaktime = analogTable.("Time_(s)"){iTrials,1}(tempPeaks == 1); % Finding the time where the electric potential signal is greater than 1.5 V
    
    % Find where the peak timings are more than 0.01 seconds different from
    % each other to tell where there are actual signal differences. 
    A = {};
    for iPeaks = 1:length(peaktime)-1
        A{1} = 1; % The first value will always be true to have the signal time there.
        A{iPeaks+1} = find(peaktime(iPeaks+1)-peaktime(iPeaks) > 0.01); % Finding the difference in indicies that is greater than 0.01 seconds
        if isempty(A{iPeaks+1})
            A{iPeaks+1} = 0;
        end
    end
    % Convert the peak timings for the perturbations from a cell to a
    % matrix
    B = cell2mat(A);
    % Convert the matrix into a logical array to get finalized peaktimes
    C = logical(B);
    % Call logical array to get perturbation signal timings rounded to 2
    % decimal places. 
    peaktime2{iTrials} = round(peaktime(C),2); % Getting the seconds that the EP signal was sent
    frametime{iTrials} = peaktime2{iTrials}*100; % Getting the frames that the EP signal was sent
end
clear A B C tempPeaks peaktime iPeaks

%% Find the perturbation information 
% This section will find the vicon frame the perturbation occurs on, the HS respective to the leg the perturbation
% happens on, the gait cycle the perturbation occurs on, magnitude of the
% perturbation based on OpenSim, and timing of that peak perturbation speed


for iTrials = 1:size(pTrials,1)
    clear tempPeaksL tempLocsL tempPeaksR tempLocsR
    [tempPeaksL, tempLocsL] = findpeaks(BodyAnalysisTable.("L_Calc_Smooth"){iTrials,1}, 'MinPeakDistance', 30);
    [tempPeaksR, tempLocsR] = findpeaks(BodyAnalysisTable.("R_Calc_Smooth"){iTrials,1}, 'MinPeakDistance', 30);
    
    
%   Finding what values in the perception table correspond with each trial
    T1 = Percep.Trial == 1; 
    T2 = Percep.Trial == 2;
    T3 = Percep.Trial == 3;
    T4 = Percep.Trial == 4;
    T5 = Percep.Trial == 5;
    
    T = {T1;T2;T3;T4; T5;};
%     T = {T2; T3; T4; T5};
%   Finding which leg corresponds with each perturbation in the trail
    for iPertNum = 1:size(T,1)
        leftPerts{iPertNum} = contains(Percep.LegIn(T{iPertNum}), 'L');
        rightPerts{iPertNum} = contains(Percep.LegIn(T{iPertNum}), 'R');
        
        % Getting the actual number of the perturbation in each trial
        tempPertNums{iPertNum} = Percep.Perturbation(T{iPertNum}); 
        leftPertNums{iPertNum} = tempPertNums{iPertNum}(leftPerts{iPertNum});
        rightPertNums{iPertNum} = tempPertNums{iPertNum}(rightPerts{iPertNum});
        
        % Getting the perceived or not perceived data 
        tempPertPerceived{iPertNum} = Percep.perceived(T{iPertNum});
        leftPertPerceived{iPertNum} = tempPertPerceived{iPertNum}(leftPerts{iPertNum});
        rightPertPerceived{iPertNum} = tempPertPerceived{iPertNum}(rightPerts{iPertNum});
        
        % Getting the sent change in velocity for each perturbation 
        tempSpeed{iPertNum} = Percep.dV(T{iPertNum});
        leftSpeed{iPertNum} = tempSpeed{iPertNum}(leftPerts{iPertNum});
        rightSpeed{iPertNum} = tempSpeed{iPertNum}(rightPerts{iPertNum});
        
        % Making frametime variables for each leg 
        frametimeL{iTrials} = frametime{1,iTrials}(leftPerts{iTrials});
        frametimeR{iTrials} = frametime{1,iTrials}(rightPerts{iTrials});
    end
    
    clear tempL tempR
    for iSignal = 1:size(frametimeL{iTrials},2) % This loops finds the location of the left leg perturbations 
        tempL{iSignal} = find(tempLocsL > frametimeL{1,iTrials}(iSignal), 1, 'first');
    end
    
    for iSignal = 1:size(frametimeR{iTrials},2) % This loops finds the location of the right leg perturbations 
        tempR{iSignal} = find(tempLocsR > frametimeR{1,iTrials}(iSignal), 1, 'first');
    end
    
    % Finding the peak perturbation speed 
    peakPertL{iTrials} = tempPeaksL(cell2mat(tempL));
    peakPertR{iTrials} = tempPeaksR(cell2mat(tempR));
    
    % Check to make sure the values grabbed from peak pert L is the correct
    % speed
    for iSignal2 = 1:size(peakPertL{iTrials},1)
        if peakPertL{iTrials}(iSignal2) >= leftSpeed{1,iTrials}(iSignal2)+0.05
            if peakPertL{iTrials}(iSignal2) < -0.30
                
            else
                tempL{iSignal2} = tempL{iSignal2}-1;
            end
        end
    end
    
    % Check to make sure the values grabbed from peak pert R is the correct
    % speed
    for iSignal3 = 1:size(peakPertR{iTrials},1)
        if peakPertR{iTrials}(iSignal3) >= rightSpeed{1,iTrials}(iSignal3)+0.05
            if peakPertR{iTrials}(iSignal3) < -0.30 % Cheating so that this doesn't replace the higher perturbations that may be larger than 0.05 m/s
                
            else
                tempR{iSignal3} = tempR{iSignal3} -1;
            end
        end
    end
    
    % Fixing values of the peak perturbation speed
    peakPertL{iTrials} = tempPeaksL(cell2mat(tempL));
    peakPertR{iTrials} = tempPeaksR(cell2mat(tempR));
    
    % Finding the frame indicies of the peak perturbation speed 
    framePertL{iTrials} = tempLocsL(cell2mat(tempL));
    framePertR{iTrials} = tempLocsR(cell2mat(tempR));
    
    % Find the gait cycle the perturbation happens on for the Left leg 
    for iPerts = 1:size(framePertL{iTrials},1)
        LGCPertNum{iTrials}(iPerts) = find(gaitEventsTable.("Gait_Events_Left"){iTrials,1}(:,1) < framePertL{iTrials}(iPerts), 1, 'last');
    end
    
    % Find the gait cycle the perturbation happens on for the right leg
    for iPerts = 1:size(framePertR{iTrials},1)
        RGCPertNum{iTrials}(iPerts) = find(gaitEventsTable.("Gait_Events_Right"){iTrials,1}(:,1) < framePertR{iTrials}(iPerts), 1, 'last');
    end
end


%% Place all the perturbation information into a table 

for iTrials = 1:size(pTrials,1)
    if iTrials == 1 
        pertTable = table(namePercep(iTrials), {leftPertNums{iTrials}}, {leftSpeed{iTrials}}, {peakPertL{iTrials}}, {framePertL{iTrials}}, {LGCPertNum{iTrials}},...
            {leftPertPerceived{iTrials}}, {rightPertNums{iTrials}}, {rightSpeed{iTrials}}, {peakPertR{iTrials}}, {framePertR{iTrials}}, {RGCPertNum{iTrials}},...
            {rightPertPerceived{iTrials}},'VariableNames', {'Trial'; 'Left_Leg_Pert_Num'; 'Left_Pert_Speed'; 'Left_Pert_Magnitude'; 'Left_Pert_Frame';...
            'Left_Gait_Cycle_Num'; 'Left_Pert_Perceived';...
            'Right_Leg_Pert_Num'; 'Right_Pert_Speed'; 'Right_Pert_Magnitude'; 'Right_Pert_Frame'; 'Right_Gait_Cycle_Num'; 'Right_Pert_Perceived';});
    else 
        pertTable.Trial(iTrials) = namePercep(iTrials);
        pertTable.("Left_Leg_Pert_Num")(iTrials) = {leftPertNums{iTrials}};
        pertTable.("Left_Pert_Speed")(iTrials) = {leftSpeed{iTrials}};
        pertTable.("Left_Pert_Magnitude")(iTrials) = {peakPertL{iTrials}};
        pertTable.("Left_Pert_Frame")(iTrials) = {framePertL{iTrials}};
        pertTable.("Left_Gait_Cycle_Num")(iTrials) = {LGCPertNum{iTrials}};
        pertTable.("Left_Pert_Perceived")(iTrials) = {leftPertPerceived{iTrials}};
        pertTable.("Right_Leg_Pert_Num")(iTrials) = {rightPertNums{iTrials}};
        pertTable.("Right_Pert_Speed")(iTrials) = {rightSpeed{iTrials}};
        pertTable.("Right_Pert_Magnitude")(iTrials) = {peakPertR{iTrials}};
        pertTable.("Right_Pert_Frame")(iTrials) = {framePertR{iTrials}};
        pertTable.("Right_Gait_Cycle_Num")(iTrials) = {RGCPertNum{iTrials}};
        pertTable.("Right_Pert_Perceived")(iTrials) = {rightPertPerceived{iTrials}};
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

% Saving the pertTable
save([tabLoc 'pertTable_' subject1], 'pertTable', '-v7.3');


disp(['Tables saved for ' subject1]);
end

