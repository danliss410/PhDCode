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


% Saved subject 5s need to do 6-12 
for iSub = 7:length(subjects)
    subject1 = [subjects{iSub}];
    domLeg = legs{iSub};


   pertTiming = treadmillPertTiming(subject1, domLeg, pertPos, pertNeg);
end

%%
totalTiming = [];
pertSpeed = [];
for iSub = 1:11
    subject1 = [subjects{iSub}];
    load(['G:\Shared drives\Perception Project\Ultrasound\OpenSim\YAUSPercep' ...
    subject1 '\Tables\gaitEventsTable_YAUSPercep' subject1 '.mat']);

    pertSpeed = [pertSpeed; GETableFull.PertSpeed];
    totalTiming = [totalTiming; GETableFull.Pert_Timing];
    clear GETableFull
end


%% 
for iLen = 1:length(totalTiming)
    initTiming(iLen) = totalTiming(iLen) - ((pertSpeed(iLen)/5)*1000);
end