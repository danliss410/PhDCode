function spatioTemporalTable = spatioTemporalParameters(subject)
%
% spatioTemporalTable will contain step length, step width, swing time,
% stance time, double support time, MoS in AP, MoS in ML, CoM deviation of
% position. 
%
% This function calculates spatiotemporal parameters listed above as well
% as dynamic stability paramters (MoS and CoM deviation) for each subject
% and saves them in a table. 
%
% INPUTS: subject - string of the subject number 
%
% OUPUT: 
%
%
%
%
% Created: 7 August, 2020 DJL 
% Modified: (format: date, initials, change made)

%% Create subject name to load the necessary files for the subject 
% Naming convention for each log file "YAPercep##_" + YesNo or 2AFC or Cog

subjectYesNo                                = ['YAPercep' subject '_YesNo'];

subject2AFC                                 = ['YAPercep' subject '_2AFC'];

subjectCog                                  = ['YAPercep' subject '_Cog'];

subject1                                    = ['YAPercep' subject];


%% Setting the file location based on which computer is running the code
if ispc
    fileLocation                            = 'G:\Shared drives\NeuroMobLab\Experimental Data\Vicon Matlab Processed\Pilot Experiments\WVCTSI_Perception2019\';
elseif ismac
    fileLocation                            = '/Volumes/GoogleDrive/Shared drives/NeuroMobLab/Experimental Data/Vicon Matlab Processed/Pilot Experiments/WVCTSI_Perception2019/';
else
    fileLocation                            = input('Please enter the file location:' );
end

startLocation                               = 'G:\My Drive\MATLAB\Perception'; %Location where all the functions and matlab scripts are 

fileLocation                                = [fileLocation subject1 filesep 'session1']; % Creating new location based on the subject that is being processed 

cd(fileLocation)

% Create directory of files that need to be loaded for each subject
dataDir                                     = dir(fileLocation);
dataDir                                     = dataDir(3:end);

for iDirLength                              = 1:length(dataDir)
    subjectID{iDirLength,1} = subject1;
end

% Looping through all the length of the data file to load all the trials
% collected for each subject into a table

for iTrials = 1:length(dataDir)
    load(dataDir(iTrials).name)
    
    if iTrials                                          == 1
        trialTable                                      = table(subjectID(iTrials),{dataDir(iTrials).name}, rawData, 'VariableNames', {'Subject';'Trial Name';'Data';});
    else
        trialTable.Subject(iTrials)                     = subjectID(iTrials);
        trialTable.('Trial Name')(iTrials)              = {dataDir(iTrials).name};
        trialTable.('Data')(iTrials)                    = rawData;
    end
end

% Getting rid of the calibration trials 
A                                                       = contains(trialTable.("Trial Name"), 'Cal');
B                                                       = find(A == 1);

% Creating a new table with only the perception trials and treadmill
% trials 
trialTable = trialTable(B(length(B))+1:size(trialTable,1),:);

clear A B


keyboard
% Input the number of treadmill trials that the subject performed 
numTreadmill                                            = str2double(cell2mat(inputdlg('Please enter the number of treadmill trials: ')));

nameTreadmill                                           = {'Treadmill01'; 'Treadmill02'; 'Treadmill03'; 'Treadmill04'; 'Treadmill05'; 'Treadmill06'};

% Input the number of perception trials that the subject performed 
numPercep = str2double(cell2mat(inputdlg('Please enter the number of perception trials: ')));

namePercep = {'Percep01'; 'Percep02'; 'Percep03'; 'Percep04'; 'Percep05'; 'Percep06'; 'Percep07'; 'Percep08';};
% Input the number of divisions the trial was split into to aid processing
% in vicon.
for iPercep = 1:numPercep
    num1File = str2double(cell2mat(inputdlg('Please enter the number of sections for the trial: ')));
    numFile(iPercep) = num1File;
end

nameTrial = {'One'; 'Two'; 'Three'; 'Four'; 'Five'; 'Six'; 'Seven'; 'Eight'; 'Nine'; 'Ten'};

%% Create a table with perception trials concatonated with all subtrials 

% This loop finds the indicies of the trial table of the subsections of
% each perception trial 
for iSub = 1:length(trialTable.('Trial Name'))
    A(iSub) = contains(trialTable.('Trial Name'){iSub}, 'Percep01');
    B(iSub) = contains(trialTable.('Trial Name'){iSub}, 'Percep02');
    C(iSub) = contains(trialTable.('Trial Name'){iSub}, 'Percep03');
    D(iSub) = contains(trialTable.('Trial Name'){iSub}, 'Percep04');
    E(iSub) = contains(trialTable.('Trial Name'){iSub}, 'Percep05');
    F(iSub) = contains(trialTable.('Trial Name'){iSub}, 'Percep06');
    G(iSub) = contains(trialTable.('Trial Name'){iSub}, 'Percep07');
    H(iSub) = contains(trialTable.('Trial Name'){iSub}, 'Percep08');
end

if numPercep <= 4 
    A = find(A == 1); % Indicies for Percep01 in the trialTable
    B = find(B == 1); % Indicies for Percep02 in the trialTable
    C = find(C == 1); % Indicies for Percep03 in the trialTable
    D = find(D == 1); % Indicies for Percep04 in the trialTable
else % Need to figure out how to adjust for more trials IE if there are bad trials and we recorded up through Percep06 or something 
end

% Creating empty matricies to be filled by the gait events 
RHS.('Percep01') = []; RTO.('Percep01') = []; LTO.('Percep01') = []; LHS.('Percep01') = [];
RHS.('Percep02') = []; RTO.('Percep02') = []; LTO.('Percep02') = []; LHS.('Percep02') = [];
RHS.('Percep03') = []; RTO.('Percep03') = []; LTO.('Percep03') = []; LHS.('Percep03') = [];
RHS.('Percep04') = []; RTO.('Percep04') = []; LTO.('Percep04') = []; LHS.('Percep04') = [];

for iSectPercep1 = 1:length(A) % Find the gait events for Percep01
    RHS.('Percep01') = [RHS.('Percep01'), trialTable.Data(iSectPercep1,1).video.GaitEvents.RHSframe];
    RTO.('Percep01') = [RTO.('Percep01'), trialTable.Data(iSectPercep1,1).video.GaitEvents.RTOframe];
    LTO.('Percep01') = [LTO.('Percep01'), trialTable.Data(iSectPercep1,1).video.GaitEvents.LTOframe];
    LHS.('Percep01') = [LHS.('Percep01'), trialTable.Data(iSectPercep1,1).video.GaitEvents.LHSframe];
end

for iSectPercep2 = 1:length(B) % Find the gait events for Percep02
    RHS.('Percep02') = [RHS.('Percep02'), trialTable.Data(iSectPercep2,1).video.GaitEvents.RHSframe];
    RTO.('Percep02') = [RTO.('Percep02'), trialTable.Data(iSectPercep2,1).video.GaitEvents.RTOframe];
    LTO.('Percep02') = [LTO.('Percep02'), trialTable.Data(iSectPercep2,1).video.GaitEvents.LTOframe];
    LHS.('Percep02') = [LHS.('Percep02'), trialTable.Data(iSectPercep2,1).video.GaitEvents.LHSframe];
end

for iSectPercep3 = 1:length(C) % Find the gait events for Percep03
    RHS.('Percep03') = [RHS.('Percep03'), trialTable.Data(iSectPercep3,1).video.GaitEvents.RHSframe];
    RTO.('Percep03') = [RTO.('Percep03'), trialTable.Data(iSectPercep3,1).video.GaitEvents.RTOframe];
    LTO.('Percep03') = [LTO.('Percep03'), trialTable.Data(iSectPercep3,1).video.GaitEvents.LTOframe];
    LHS.('Percep03') = [LHS.('Percep03'), trialTable.Data(iSectPercep3,1).video.GaitEvents.LHSframe];
end

for iSectPercep4 = 1:length(D) % Find the gait events for Percep04
    RHS.('Percep04') = [RHS.('Percep04'), trialTable.Data(iSectPercep4,1).video.GaitEvents.RHSframe];
    RTO.('Percep04') = [RTO.('Percep04'), trialTable.Data(iSectPercep4,1).video.GaitEvents.RTOframe];
    LTO.('Percep04') = [LTO.('Percep04'), trialTable.Data(iSectPercep4,1).video.GaitEvents.LTOframe];
    LHS.('Percep04') = [LHS.('Percep04'), trialTable.Data(iSectPercep4,1).video.GaitEvents.LHSframe];
end


for iNumPercep = 1:numPercep % Creating gait event cycles for left and right for each perception trial
    GaitEvents_Right = createGaitEventsMatrix(RHS.(namePercep{iNumPercep}), RTO.(namePercep{iNumPercep}), LHS.(namePercep{iNumPercep}), LTO.(namePercep{iNumPercep}));
    GaitEvents_Left =  createGaitEventsMatrix(LHS.(namePercep{iNumPercep}), LTO.(namePercep{iNumPercep}), RHS.(namePercep{iNumPercep}), RTO.(namePercep{iNumPercep}));
    GaitEvents.(namePercep{iNumPercep}).Right = GaitEvents_Right;
    GaitEvents.(namePercep{iNumPercep}).Left = GaitEvents_Left;
end 

for iNumPercep = 1:numPercep % Creating a gait events table for each subject with all the gait cycles and information for each perception trial
   if iNumPercep                                       == 1
        gaitEventsTable = table(namePercep(iNumPercep),{RHS.(namePercep{iNumPercep})}, {RTO.(namePercep{iNumPercep})}, {LTO.(namePercep{iNumPercep})}, {LHS.(namePercep{iNumPercep})}, {GaitEvents.(namePercep{iNumPercep}).Right}, {GaitEvents.(namePercep{iNumPercep}).Left}, 'VariableNames', {'Trial';'RHS';'RTO';'LTO';'LHS';'Gait Events Right';'Gait Events Left';});
    else
        gaitEventsTable.Trial(iNumPercep)                     = {namePercep(iNumPercep)};
        gaitEventsTable.RHS(iNumPercep)                       = {RHS.(namePercep{iNumPercep})};
        gaitEventsTable.RTO(iNumPercep)                       = {RTO.(namePercep{iNumPercep})};
        gaitEventsTable.LTO(iNumPercep)                       = {LTO.(namePercep{iNumPercep})};
        gaitEventsTable.LHS(iNumPercep)                       = {LHS.(namePercep{iNumPercep})};
        gaitEventsTable.('Gait Events Right')(iNumPercep)     = {GaitEvents.(namePercep{iNumPercep}).Right};
        gaitEventsTable.('Gait Events Left')(iNumPercep)      = {GaitEvents.(namePercep{iNumPercep}).Left};
   end   
end

%%
% Find the perturbaton signal & its timing sent to Vicon during the
% experiment. Also, finding the GaitEvents timing on each trial.
for iPercep = 1:numPercep
    for iFile = 1:numFile(iPercep)
        
        %   Find all the electric potential peaks in the trail
        tempPeaks = find(trial.(namePercep{iPercep}).(nameTrial{iFile}).analog.other > 1.5);
        figure; plot(trial.(namePercep{iPercep}).(nameTrial{iFile}).analog.other);
        %     Finding the time for all the electric potential spikes sent 
        %     during the perturbation trial
        peaktime = trial.(namePercep{iPercep}).(nameTrial{iFile}).analog.time(tempPeaks);
        peaktime2 = round(peaktime,2); % round to 0.01 so that it is consistent with marker data (100 Hz collected)
        [C,IA,IC] = unique(round(peaktime2,1)); % find unique indiced, but do so on data rounded to 0.1, to prevent both 1.00 and 1.01 from being "unique" perturbations
        peaktime3 = peaktime2(IA); % now grab the actual perturbation times from peaktime2 (the data rounded to 0.01)
        clear C IA IC
        
        % now find and store the index of marker data where the
        % perturbation occurs
        if ~isempty(peaktime3)
            for iTime = 1:length(peaktime3)
                indices1(iTime) = find(peaktime3(iTime) == round(rawData.video.time,2)); % find the index for the marker data = perturbation (peakTime3) as identified above
            end
            PertIndicesAll = [PertIndicesAll, indices1];
            clear iTime 
        end
        
        

        
     end
end




%% Calculating the spatiotemporal parameters for each perturbation 

fileLocation                                = 'G:\Shared drives\NeuroMobLab\Experimental Data\Log Files\Pilot Experiments\PerceptionStudy\';
data1.(subjectYesNo)                        = readtable([fileLocation subjectYesNo]);


% Calculating step length & step width for each perturbation onset
for iFile = 1:numFile %Number of sections for each perturbation trial
   for i = 1:length(T.(nameTrial{iFile}).LHS) % Calcualting the step length for left belt perturbations 
       SL.(nameTrial{iFile}).LeftPert(i) = trial.(nameTrial{iFile}).video.markers(T.(nameTrial{iFile}).LHS{i}, 22, 1) - trial.(nameTrial{iFile}).video.markers(T.(nameTrial{iFile}).LHS{i}, 30, 1); % Subtracting the Heel markers from left minus right in the AP direction
       SW.(nameTrial{iFile}).LeftPert(i) = trial.(nameTrial{iFile}).video.markers(T.(nameTrial{iFile}).LHS{i}, 21, 2) - trial.(nameTrial{iFile}).video.markers(T.(nameTrial{iFile}).LHS{i}, 29, 2); % Subtracting the ankle markers from left minus right in the ML direction
   end
   
   for i = 1:length(T.(nameTrial{iFile}).RHS) % Caculating the step length and width for the right belt perturbations
       SL.(nameTrial{iFile}).RightPert(i) = trial.(nameTrial{iFile}).video.markers(T.(nameTrial{iFile}).RHS{i}, 30, 1) - trial.(nameTrial{iFile}).video.markers(T.(nameTrial{iFile}).RHS{i}, 22, 1); % Subtracting the heel markers from right minus left in the AP direction
       SW.(nameTrial{iFile}).RightPert(i) = trial.(nameTrial{iFile}).video.markers(T.(nameTrial{iFile}).RHS{i}, 29, 1) - trial.(nameTrial{iFile}).video.markers(T.(nameTrial{iFile}).RHS{i}, 21, 1); % Subtracting the ankle markers from right minus right in the ML direction 
   end
end
%%
disp('stop')

end