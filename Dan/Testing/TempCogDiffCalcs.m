%% This script will calculate the differences for the subjects that completed the Normal Perception task vs the cognitive perception task first 

% This will load the tables of all the subjects threshold results 
load('G:\Shared drives\NeuroMobLab\Projects\Perception\Processed Data\Dan\Matlab Analysis\Thresholds\Results.mat')

%% Calculating the averages and standard deviations for the two different subsets of the subjects 

% Legs = {'L';'R'}; % This will be used to label the structure 
% name = {'Norm'; 'Cog'}; % Naming the two task types being analyzed 
% 
% for iTask = 1:length(name)
%     for iLeg = 1:length(Legs)
%         if name == 'Norm'
       
% Calculating means 
Norm1.Cog = TabCog.("DomThres")(1:7);
Norm1.Norm = TabYesNoShort.("DomThres")(1:7);
Cog1.Cog = TabCog.("DomThres")(8:end);
Cog1.Norm = TabYesNoShort.("DomThres")(8:end);




cogComparison = table(Cog1.Cog, Cog1.Cog,'VariableNames', {'Average Dom Threshold'; 'Std Dom Threshold'}, 'RowNames', {'Cog1st Cog'})
cogComparison.("Average Dom Threshold")(4) = Norm1.Cog.m;
cogComparison.("Std Dom Threshold")(4) = Norm1.Cog.std;
cogComparison.Row(4) = {'Norm 1st Cog'};

save(['G:\Shared drives\NeuroMobLab\Projects\Perception\Processed Data\Dan\Matlab Analysis\Thresholds' filesep 'cogComparison.mat'], 'cogComparison')


