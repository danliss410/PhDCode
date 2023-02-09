%% Ultrasound Processing Dan 
% close all
% clear 
% home

subjects = {'01';'02'; '08'; '09'; '10'; '11';}; % Place the subject numbers here 
 

% trialsFix = {[12, 16, 20, 24, 29, 61, 73,74, 93, 97, 99, 108, 141];... %YAUS01
%     [2, 100, 125, 136, 149, 17, 48, 55, 69, 89, 26];... %YAUS02
%     [78];... %YAUS03
%     [1, 2, 18, 24, 29, 37, 44, 54, 56, 61, 68, 78, 84, 86, 87, 89];...% YAUS05
%     [112, 117, 27, 28, 29, 30, 53, 57, 58, 60, 67, 71, 77, 80, 82, 89, 91, 96];...% YAUS08
%     [5, 18, 20, 32, 39, 46, 52, 58, 60, 67, 71, 72, 76, 78, 80, 81, 88, 89];...% YAUS09
%     [32, 37, 52, 86];...%YAUS10
%     [3, 14, 25, 43, 49, 52, 56, 64, 89];}; % YAUS11
% 
% tabID = {[4, 7, 8, 9, 10, 14, 15, 16, 18, 19, 20, 3, 6];... %YAUS01
%     [1, 3, 4, 6, 7, 8, 11, 12, 14, 18, 9];...% YAUS02
%     [15];...%YAUS03
%     [1, 2, 4, 5, 6, 9, 10, 12, 13, 14, 15, 16, 17, 18, 19, 20];...%YAUS05
%     [1, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 18, 19, 20];...%YAUS08
%     [1, 2, 3, 4, 5, 6, 7, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19];...% YAUS09
%     [8, 9, 11, 18];... % YAUS10
%     [2, 5, 7, 12, 13, 14, 15, 17, 20];}; % YAUS11
trialsFix = {[29];...
    [18];...%YAUS02
    [89-25];...%YAUS08
    [81];...%YAUS09
    [86];...%YAUS10
    [14,25,43,49,52,56,89];}; % YAUS11
tabID = {[10];...
    [4];...
    [16];...
    [17];...
    [18];...
    [ 5, 7, 12, 13, 14, 15, 20];};

% trialName = ['YAUSPercep' subID '_YNPercep' trialNum];

dlcLocation = 'G:\Shared drives\Perception Project\videos\';
%%
% load data from DLC

for iSub = 1% :length(subjects)
    subID = subjects{iSub}; % string of subject ID
    trials = trialsFix{iSub}; % subject trials
    idxMat = tabID{iSub}; % table idx 

    load(['G:\Shared drives\Perception Project\Ultrasound\OpenSim\YAUSPercep' ...
    subID '\Tables\gaitEventsTable_YAUSPercep' subID '.mat']);

    % Loading the MTJTable for all trials 
    load(['G:\Shared drives\Perception Project\Ultrasound\OpenSim\YAUSPercep' ...
    subID '\Tables\MTJTable_YAUSPercep' subID '.mat']);

    for iTrial = 1%:size(trials,2)
        trialNum = trials(iTrial);
        idx = idxMat(iTrial);
        if trialNum < 10
            trialNum = ['0' num2str(trialNum)];
        else
            trialNum = num2str(trialNum);
        end
        % Making the trial name
        trialName = ['YAUSPercep' subjects{iSub} '_YNPercep' num2str(trialNum)];
        % Loading the filtered data matrix 
        estimatedData = csvread([dlcLocation trialName '.csv'],0,0);
        % Finding the closest ending gc index
        atime = MTJTable.("Analog_Time_(s)"){idx};
        usTime = MTJTable.("US_Time_(s)"){idx};
        pc = GETableFull.Pert_Cycle(idx); 
        pf = GETableFull.GETable_Right{idx}.("RHS_2")(pc);
        pf = pf * 10; 

        [idc,closestIndex] = min(abs(atime(pf)-usTime));



        badDist = estimatedData(:,2)*40/804; 
        badFrames = find(abs(diff(badDist)) > 1); 
        badFrames = badFrames';
        badFramesEx = [];
        for i = 1:length(badFrames)
            badFrames2 = badFrames(i)-2:1:badFrames(i) + 2;
            badFramesEx = [badFramesEx; badFrames2';];
        end
        clear badFrames 
        temp = unique(badFramesEx);
        tempIDX = find(temp > 1);
        temp2 = temp(tempIDX);
        tempIDX2 = find(temp2 < closestIndex);

        badFrames = temp2(tempIDX2);
        keyboard
        badFrames = 70:1:570;
        estimatedData(:,2) = smoothdata(estimatedData(:,2), 'movmean', 10);
        estimatedData(:,3) = smoothdata(estimatedData(:,3), 'movmean', 10);
        [fixedData2] = fixLabels(trialName,estimatedData, badFrames);
        
        keyboard 


        writematrix(fixedData2, [dlcLocation trialName '.csv'])
        fprintf('Created new csv file for Subject%s and trial %s\n\n', subjects{iSub}, num2str(trialNum))
        clearvars -except trials iSub iTrial subjects pertNeg pertPos dlcLocation idxMat MTJTable GETableFull
        close all
    end
    
end
disp('Finished')
%%




% % trialName = 'USPert31';
% 
% fixUSVideos(trialName);
% disp('Finished')