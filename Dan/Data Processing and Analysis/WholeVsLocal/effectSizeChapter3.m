%% Compute Effect Sizes for Whole-body and Local Sensory Feedback Variables
filename = 'C:\Github\Perception-Project\Dan\Data Processing and Analysis\WholeVsLocal\DataFormatForStats_WholeVLocal.xlsx';
% sheet = 'Whole Avg ES Late Stance'; % Whole Avg ES Full GC
sheet = 'Whole Avg ES Full GC';
% sheet2 = 'Local Avg ES Late Stance'; % Local Avg ES Full GC
sheet2 = 'Local Avg ES Full GC';


% create table for Whole
dataTable = readtable(filename,'Sheet',sheet);

% create table for Local
dataTable2 = readtable(filename, 'Sheet', sheet2);

% number of percieved perturbations per subject
for i=1:15
    numPerceived(i) = sum(dataTable.Perceived(dataTable.SubjectNum==i));
    numPerceived2(i) = sum(dataTable2.Perceived(dataTable2.SubjectNum==i));
end
% [data, columnNames] = xlsread(filename,sheet);

perceivedW = dataTable.Perceived==1;
data_perceivedW = dataTable(perceivedW,3:14);
data_notperceivedW = dataTable(~perceivedW,3:14);

perceivedL = dataTable2.Perceived==1;
data_perceivedL = dataTable2(perceivedL,3:9);
data_notperceivedL = dataTable2(~perceivedL,3:9);
%% Calculate Effect Sizes for Whole Body 

WvarNames = data_perceivedW.Properties.VariableNames; 

for iWhole = 1:size(WvarNames,2)
    [d.(WvarNames{iWhole}), meanDiff.(WvarNames{iWhole}), s.(WvarNames{iWhole})] = ...
        computeCohen_d(data_perceivedW.(WvarNames{iWhole}), data_notperceivedW.(WvarNames{iWhole})); 
end

%% Calculate Effect Sizes for Local Sensory Feedback Modalities 

LvarNames = data_perceivedL.Properties.VariableNames; 

for iLocal = 1:size(LvarNames,2)
        [d.(LvarNames{iLocal}), meanDiff.(LvarNames{iLocal}), s.(LvarNames{iLocal})] = ...
        computeCohen_d(data_perceivedL.(LvarNames{iLocal}), data_notperceivedL.(LvarNames{iLocal})); 
end