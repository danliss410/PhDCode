% This will be the total processing script for the ultrasound experiment
close all
clear 
home 


subjects = {'01';'02'; '03'; '04'; '05'; '06'; '07'; '08'; '09'; '10'; '11'; '12';}; % Place the subject numbers here 
legs = {'R';'R';'R';'R';'R';'R';'L';'R';'R';'R';'R';'L';}; % Place the subjects preferred legs in here
markerOpsF = [0; 1; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0;]; % 2 codes for CLAV only, 1 codes for C7 only, and 0 codes for all markers in the calibration trial
SSWS = [0.95; 1; 1; 1; 0.95; 1.05; 0.95; 1.05; 1.1; 1; 1.1; 0.9;]; % Self selected walking speed for the young adults
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
speedPNTot = {[1, 2, 3, 4, 1, 3, 1, 2, 2, 4, 3, 4, 2, 4, 3, 2, 1, 1, 3,4]; ... % YAUS01
    [2, 1, 3, 4, 3, 1, 2, 1, 4, 3, 4, 1, 2, 4, 3, 1, 2, 3, 4, 2];... % YAUS02
    [4, 1, 3, 2, 3, 4, 1, 3, 2, 2, 1, 4, 4, 2, 3, 1, 2, 3, 4, 1];... % YAUS03
    [4, 3, 2, 1, 2, 3, 4, 3, 2, 1, 1, 2, 4, 4, 4, 1, 2, 3, 1, 3];... % YAUS04
    [4, 1, 3, 2, 3, 4, 1, 3, 2, 2, 1, 4, 1, 4, 4, 2, 3, 1, 2, 3];... % YAUS05
    [4, 1, 3, 2, 3, 4, 1, 3, 2, 2, 1, 4, 1, 4, 4, 2, 3, 1, 2, 3];... % YAUS06
    [4, 2, 3, 3, 1, 4, 2, 3, 1, 1, 1, 2, 4, 2, 4, 1, 4, 3, 2, 3];... % YAUS07
    [4, 2, 3, 3, 1, 4, 2, 3, 1, 1, 1, 2, 4, 2, 4, 1, 4, 3, 2, 3];... % YAUS08
    [1, 4, 2, 1, 2, 2, 4, 1, 1, 3, 3, 3, 4, 3, 3, 2, 4, 1, 2, 4];... % YAUS09
    [4, 1, 3, 2, 3, 4, 1, 3, 2, 2, 1, 4, 1, 4, 4, 2, 3, 1, 2, 3];... % YAUS10
    [2, 4, 3, 3, 3, 4, 2, 4, 3, 1, 1, 1, 2, 2, 1, 3, 4, 2, 3, 1];}; % YAUS11
perceivedTot = {[1, 1, 0, 1, 0, 1, 0, 1, 1, 1, 0, 1, 1, 0, 0, 1, 0, 0, 0, 1]; ... % YAUS01
    [1, 0, 1, 1, 0, 1, 1, 0, 1, 0, 0, 0, 1, 1, 0, 1, 1, 0, 0, 0]; ... % YAUS02
    [1, 1, 0, 1, 0, 1, 0, 0, 1, 1, 0, 1, 1, 1, 1, 0, 1, 0, 1, 0];... % YAUS03
    [0, 0, 1, 0, 1, 1, 1, 0, 1, 0, 0, 1, 0, 1, 0, 0, 1, 0, 0, 0];... % YAUS04
    [1, 0, 0, 1, 0, 1, 0, 0, 0, 1, 0, 1, 0, 0, 1, 0, 0, 0, 1, 0];... % YAUS05
    [0, 0, 0, 1, 0, 1, 0, 0, 1, 0, 0, 1, 1, 1, 1, 0, 0, 0, 1, 0];... % YAUS06
    [1, 1, 0, 1, 0, 1, 1, 1, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0];... % YAUS07
    [1, 0, 0, 1, 0, 1, 1, 0, 1, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 0];... % YAUS08
    [0, 1, 1, 0, 1, 1, 0, 0, 0, 0, 1, 0, 1, 1, 1, 1, 1, 0, 1, 1];... % YAUS09
    [1, 1, 0, 1, 0, 1, 0, 0, 1, 1, 0, 1, 1, 1, 1, 0, 0, 1, 1, 0];... % YAUS10
    [0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, 1, 0];}; % YAUS11



tempSub = [1,2,3,5,8,9,10,11]; % 1, 2, 3, 5, 8, 9, 10
for iSub = 4%:length(tempSub)%2:length(subjects)-2
    subject1 = [subjects{iSub}];
    markerOps = markerOpsF(iSub);
    domLeg = legs{iSub};
%     trials = sort([pertPos{iSub}, pertNeg{iSub}]);
trials = 7;
    speeds = speedPNTot{iSub};
    perceived = perceivedTot{iSub};

%     perceptionThresholdUS(subject1, legs{iSub});
%     batchIKnBAprocessingOS_US(subject1, markerOps)
%     GETableFull = createGETables(subject1, domLeg, pertPos, pertNeg);
    [MTJTable] = calcMTJLength(subject1, trials, domLeg);
%     effectsizeUSTab = effectSizeUS(subject1, trials, domLeg, speeds, perceived);
    clear GETableFull MTJTable
end

%% Older adults subjects 
% subjects = {'01'; '02'};
% legs = {'R'; 'R';};
% SSWS = [0.85; 1.1];
% pertPos = {[0.1; 0.15]; [0.1; 0.15];};
% 
% for iSub = 1:length(subjects)
%     subject1 = [subjects{iSub}];
%     OAperceptionThresholdUS(subject1, legs{iSub});
% end
% 
% %% Putting all the values in 1 table 
% 
% for iSub = 1:length(subjects)
%     subject1 = [subjects{iSub}];
%     load(['G:\Shared drives\NeuroMobLab\Projects\Perception\Ultrasound\Thresholds\ThresholdTables\YAUSPercep' subject1 '.mat']);
%     if iSub == 1 
%         tableFullPercep = tablePercep;
%     else
%         tableFullPercep = [tableFullPercep;tablePercep];
%     end
% end