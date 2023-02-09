% Loading the file
% C is on the laptop E drive for the work computer
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

% Separating out the whole body perceived vs not perceived results
perceivedW = dataTable.Perceived==1;
data_perceivedW = dataTable(perceivedW,3:14);
data_notperceivedW = dataTable(~perceivedW,3:14);

% Separating out the local sensory feedback perceived vs not perceived
% results 
perceivedL = dataTable2.Perceived==1;
data_perceivedL = dataTable2(perceivedL,3:9);
data_notperceivedL = dataTable2(~perceivedL,3:9);


%% Data distribution tests 

% Grabbing the WholeBody Variable Names
WvarNames = data_perceivedW.Properties.VariableNames; 
% Grabbing the Local sensory feedback Variable Names 
LvarNames = data_perceivedL.Properties.VariableNames;

% Making a loop for all whole body variables 
for iWhole = 1:size(WvarNames,2)
    LILperW.(WvarNames{iWhole}) = lillietest(data_perceivedW.(WvarNames{iWhole}));
    LILnotperW.(WvarNames{iWhole}) = lillietest(data_notperceivedW.(WvarNames{iWhole}));
end


% Making a loop for all the local variables 
for iLocal = 1:size(LvarNames,2)
    LILperL.(LvarNames{iLocal}) = lillietest(data_perceivedL.(LvarNames{iLocal}));
    LILnotperL.(LvarNames{iLocal}) = lillietest(data_notperceivedL.(LvarNames{iLocal}));
end
%% Testing the data distribution with a different test 


% Grabbing the WholeBody Variable Names
WvarNames = data_perceivedW.Properties.VariableNames; 
% Grabbing the Local sensory feedback Variable Names 
LvarNames = data_perceivedL.Properties.VariableNames;

% Making a loop for all whole body variables 
for iWhole = 1:size(WvarNames,2)
    ADperW.(WvarNames{iWhole}) = adtest(data_perceivedW.(WvarNames{iWhole}));
    ADnotperW.(WvarNames{iWhole}) = adtest(data_notperceivedW.(WvarNames{iWhole}));
end


% Making a loop for all the local variables 
for iLocal = 1:size(LvarNames,2)
    ADperL.(LvarNames{iLocal}) = adtest(data_perceivedL.(LvarNames{iLocal}));
    ADnotperL.(LvarNames{iLocal}) = adtest(data_notperceivedL.(LvarNames{iLocal}));
end