%% Analysis for Excursion Timing 
filename = 'C:\Github\Perception-Project\Dan\USPercep Analysis\Analysis\DataFormatForStats_US2.xlsx';
% sheet = 'SlipsEx';
sheet = 'SlipsTime';
% sheet2 = 'TripsEx';
sheet2 = 'TripsTime';

% create table for Slips
dataTable = readtable(filename,'Sheet',sheet);

% create table for Trips
dataTable2 = readtable(filename, 'Sheet', sheet2);

% Making a table of labels for MG, AT, MTU excursions
% I believe this is for the repeated measures
labels = table([1 2 3]', 'VariableNames', {'Excursions'});

% Creating the table for the rm model
slipsTab = dataTable(:,[2:5]);
% Creating the table for the rm model
tripsTab = dataTable2(:,[2:5]);
%% Running a repeated measure anova for comparison 
% Measurements 3 excursions: MG, AT, MTU, 
% Predicting Speeds 
% Had to create a repeated measure model? 
% This is for slips 
rmsTime = fitrm(slipsTab, 'tMG-tMTU ~ Speeds', 'WithinDesign',labels);
% Running repeated measure anova on my data for slips 
slipsTime = ranova(rmsTime);

% Measurements 3 excursions: MG, AT, MTU, 
% Predicting Speeds 
% Had to create a repeated measure model? 
rmtTime = fitrm(tripsTab, 'tMG-tMTU ~ Speeds', 'WithinDesign',labels);
% Running repeated measure anova on my data for slips 
tripsTime = ranova(rmtTime);



% I think this means there was a significant interaction effect for speed
% for slips but not for trips with the peak excursion timing during the
% gait cycle. 

%% Analysis for peak Excursion Distance in mm 
filename = 'C:\Github\Perception-Project\Dan\USPercep Analysis\Analysis\DataFormatForStats_US2.xlsx';
sheet = 'SlipsEx';
% sheet = 'SlipsTime';
sheet2 = 'TripsEx';
% sheet2 = 'TripsTime';

% create table for Slips
dataTable = readtable(filename,'Sheet',sheet);

% create table for Trips
dataTable2 = readtable(filename, 'Sheet', sheet2);

% Making a table of labels for MG, AT, MTU excursions
% I believe this is for the repeated measures
labels = table([1 2 3]', 'VariableNames', {'Excursions'});

% Creating the table for the rm model
slipsTab = dataTable(:,[2:5]);
% Creating the table for the rm model
tripsTab = dataTable2(:,[2:5]);

%% Running a repeated measure anova for Excursion Distance
% Measurements 3 excursions: MG, AT, MTU, 
% Predicting Speeds 
% Had to create a repeated measure model? 
% This is for slips 
rmsEx = fitrm(slipsTab, 'ExMG-ExMTU ~ Speeds', 'WithinDesign',labels);
% Running repeated measure anova on my data for slips 
slipsEx = ranova(rmsEx);

% Measurements 3 excursions: MG, AT, MTU, 
% Predicting Speeds 
% Had to create a repeated measure model? 
rmtEx = fitrm(tripsTab, 'ExMG-ExMTU ~ Speeds', 'WithinDesign',labels);
% Running repeated measure anova on my data for slips 
tripsEx = ranova(rmtEx);


% I think this means there was a significant interaction effect for speed
% for peak trip excursion but not for slips. 