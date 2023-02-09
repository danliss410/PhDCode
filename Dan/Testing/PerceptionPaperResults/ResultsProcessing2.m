%% New results Script for perception Threshold paper results 

load('G:\Shared drives\NeuroMobLab\Projects\Perception\Processed Data\Dan\Matlab Analysis\Thresholds\Results2.mat')

h = figure;
bar(avg)
xticklabels({'Normal'; 'Cognitive'; 'Normal'; 'Cognitive'})
ylim([0 0.16]);
