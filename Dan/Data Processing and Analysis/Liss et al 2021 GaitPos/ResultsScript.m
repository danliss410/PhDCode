%% Calculating the results for the Perception Project

% Calculating all the means for the results table
% YNFR - YesNo Full Right  % YNFL - YesNo Full Left % YNSR - YesNo Short
% Right % YNSL - YesNo Short Left % CR - Cog Right % CL - Cog Left % YNDL -
% YesNo Dom Leg % YNSDL - YesNo Short Dom Leg % CDL - Cog Dom Leg % YNPD -
% YesNo Percent Dom % DCN - Difference btw Cog - YesNo

%% loading the full Threshold table
load(['G:\Shared drives\NeuroMobLab\LabMemberFolders\Dan\Perception Study\YAPercep Data Plots\Thresholds' filesep 'FullThresholdTable.mat']);

load(['G:\Shared drives\NeuroMobLab\Projects\Perception\Processed Data\Dan\Matlab Analysis\Thresholds' filesep 'Results.mat'])
keyboard

save(['G:\Shared drives\NeuroMobLab\Projects\Perception\Processed Data\Dan\Matlab Analysis\Thresholds' filesep 'Results.mat'], 'resultsTable', 'Tab2AFC', 'TabCog', 'TabYesNo', 'TabYesNoShort')

%% Calculating for YesNo Full
avg.YNFR = mean(thresholdTableFull_2DJL.('Neg Right'));
avg.YNFL = mean(thresholdTableFull_2DJL.('Neg Left'));

med.YNFR = median(thresholdTableFull_2DJL.('Neg Right'));
med.YNFL = median(thresholdTableFull_2DJL.('Neg Left'));

sd.YNFR = std(thresholdTableFull_2DJL.('Neg Right'));
sd.YNFL = std(thresholdTableFull_2DJL.('Neg Left'));

rg.YNFR = range(thresholdTableFull_2DJL.('Neg Right'));
rg.YNFL = range(thresholdTableFull_2DJL.('Neg Left'));

%% Calculating for YesNo Short
avg.YNSR = mean(TabYesNoShort.('Neg Right'));
avg.YNSL = mean(TabYesNoShort.('Neg Left'));

med.YNSR = median(TabYesNoShort.('Neg Right'));
med.YNSL = median(TabYesNoShort.('Neg Left'));

sd.YNSR = std(TabYesNoShort.('Neg Right'));
sd.YNSL = std(TabYesNoShort.('Neg Left'));

rg.YNSR = range(TabYesNoShort.('Neg Right'));
rg.YNSL = range(TabYesNoShort.('Neg Left'));


%% Calculating for Cog 

avg.CR = mean(TabCog.('Neg Right'));
avg.CL = mean(TabCog.('Neg Left'));

med.CR = median(TabCog.('Neg Right'));
med.CL = median(TabCog.('Neg Left'));

sd.CR = std(TabCog.('Neg Right'));
sd.CL = std(TabCog.('Neg Left'));

rg.CR = range(TabCog.('Neg Right'));
rg.CL = range(TabCog.('Neg Left'));

%% Calculating for Dominant Leg

% Calculating for full set
avg.YNDL = mean(TabYesNo.('DomThres'));

med.YNDL = median(TabYesNo.('DomThres'));

sd.YNDL = std(TabYesNo.('DomThres'));

rg.YNDL = range(TabYesNo.('DomThres'));

% Calculating for short set 
avg.YNSDL = mean(TabYesNoShort.('DomThres'));

med.YNSDL = median(TabYesNoShort.('DomThres'));

sd.YNSDL = std(TabYesNoShort.('DomThres'));

rg.YNSDL = range(TabYesNoShort.('DomThres'));

% Calculating for cog set 
avg.CDL = mean(TabCog.('DomThres'));

med.CDL = median(TabCog.('DomThres'));

sd.CDL = std(TabCog.('DomThres'));

rg.CDL = range(TabCog.('DomThres'));

% Calculating for percentage dom leg 
avg.YNPD = mean(TabYesNo.('PercentThres'));

med.YNPD = median(TabYesNo.('PercentThres'));

sd.YNPD = std(TabYesNo.('PercentThres'));

rg.YNPD = range(TabYesNo.('PercentThres'));

% Calculating difference between Cog
avg.DCN = mean(TabCog.('Difference'));

med.DCN = median(TabCog.('Difference'));

sd.DCN = std(TabCog.('Difference'));

rg.DCN = range(TabCog.('Difference'));

%% Calculating for NonDominant Leg

% Calculating dom threshold for cog set 
avg.CPD = mean(TabCog.('PercentThres'));

med.CPD = median(TabCog.('PercentThres'));

sd.CPD = std(TabCog.('PercentThres'));

rg.CPD = range(TabCog.('PercentThres'));

% Calculating for short YesNo set NonDom Leg
avg.YNSND = mean(TabYesNoShort.('NonDomThres'));

med.YNSND = median(TabYesNoShort.('NonDomThres'));

sd.YNSND = std(TabYesNoShort.('NonDomThres'));

rg.YNSND = range(TabYesNoShort.('NonDomThres'));

% Calculating for cog set non dom leg
avg.CND = mean(TabCog.('NonDomThres'));

med.CND = median(TabCog.('NonDomThres'));

sd.CND = std(TabCog.('NonDomThres'));

rg.CND = range(TabCog.('NonDomThres'));

% Calculating for percentage nondom leg 
avg.YNSPND = mean(TabYesNoShort.('NDPercentThres'));

med.YNSPND = median(TabYesNoShort.('NDPercentThres'));

sd.YNSPND = std(TabYesNoShort.('NDPercentThres'));

rg.YNSPND = range(TabYesNoShort.('NDPercentThres'));


% Calculating for percentage nondom leg cog
avg.CPND = mean(TabCog.('NDPercentThres'));

med.CPND = median(TabCog.('NDPercentThres'));

sd.CPND = std(TabCog.('NDPercentThres'));

rg.CPND = range(TabCog.('NDPercentThres'));


%% 

name = {'YNFR'; 'YNFL'; 'YNSR'; 'YNSL'; 'CR'; 'CL'; 'YNDL'; 'YNSDL'; 'CDL'; 'YNPD'; 'DCN'; 'CPD'; 'YNSND'; 'CND'; 'YNSPND';  'CPND';};

for iCalc = 1:length(name)
    resultsTable.Average(iCalc) = avg.(name{iCalc});
    resultsTable.Median(iCalc) = med.(name{iCalc});
    resultsTable.Std(iCalc) = sd.(name{iCalc});
    resultsTable.Range(iCalc) = rg.(name{iCalc});
end



save(['G:\Shared drives\NeuroMobLab\Projects\Perception\Processed Data\Dan\Matlab Analysis\Thresholds' filesep 'Results.mat'], 'resultsTable', 'Tab2AFC', 'TabCog', 'TabYesNo', 'TabYesNoShort')

