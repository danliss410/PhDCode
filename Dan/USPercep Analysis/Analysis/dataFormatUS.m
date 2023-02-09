% Creating the data matrix for each subject to be placed in the excel file
% for kruskal wallis tests and logistical modeling 

subjects = {'01';'02'; '03'; '04'; '05'; '06'; '07'; '08'; '09'; '10'; '11'; '12';}; % Place the subject numbers here 
legs = {'R';'R';'R';'R';'R';'R';'L';'R';'R';'R';'R';'L';}; % Place the subjects preferred legs in here
markerOpsF = [0; 1; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0;]; % 2 codes for CLAV only, 1 codes for C7 only, and 0 codes for all markers in the calibration trial
SSWS = [0.95; 1; 1; 1; 0.95; 1.05; 0.95; 1.05; 1.1; 1; 1.1; 0.9;]; % Self selected walking speed for the young adults

%% 
for iSub = 1:length(subjects)-1
    subID = subjects{iSub};
    load(['G:\Shared drives\Perception Project\Ultrasound\OpenSim\YAUSPercep' subID '\Tables\'...
        'effectsizeUSTable_YAUSPercep' subID '.mat'])

    for iTrial = 1:size(effectsizeUSTab, 1)
        % averaging the effect size for the full gait cycle 
        esFGC_MGL(iTrial) = nanmean(abs(effectsizeUSTab.esMGL{iTrial}));
        esFGC_MTU(iTrial) = nanmean(abs(effectsizeUSTab.esMTL{iTrial}));
        esFGC_ATL(iTrial) = nanmean(abs(effectsizeUSTab.esATL{iTrial}));
        % averaging the effect size for the late stance gait cycle 
        [esP_MGL(iTrial), tesP_MGL(iTrial)]  = max(abs(effectsizeUSTab.esMGL{iTrial}), [], 2);
        [esP_MTU(iTrial), tesP_MTU(iTrial)] = max(abs(effectsizeUSTab.esMTL{iTrial}), [], 2);
        [esP_ATL(iTrial), tesP_ATL(iTrial)] = max(abs(effectsizeUSTab.esATL{iTrial}), [], 2);
    end
    if iSub == 1 
        avgESTab = table(iSub*ones(size(effectsizeUSTab,1),1), esFGC_MGL', esFGC_ATL', esFGC_MTU',...
            esP_MGL', esP_ATL', esP_MTU', tesP_MGL', tesP_ATL', tesP_MTU', ...
            effectsizeUSTab.Speeds, effectsizeUSTab.Perceived, ...
            'VariableNames', {'SubjectNum', 'Fullgc_MGL', 'Fullgc_ATL', 'Fullgc_MTL',...
            'PeakES_MGL', 'PeakES_ATL', 'PeakES_MTU', 'PeakIdx_MGL', 'PeakIdx_ATL', 'PeakIdx_MTU',...
            'Level', 'Perceived'});
    else
        tempTab = table(iSub*ones(size(effectsizeUSTab,1),1), esFGC_MGL', esFGC_ATL', esFGC_MTU',...
            esP_MGL', esP_ATL', esP_MTU', tesP_MGL', tesP_ATL', tesP_MTU', ...
            effectsizeUSTab.Speeds, effectsizeUSTab.Perceived, ...
            'VariableNames', {'SubjectNum', 'Fullgc_MGL', 'Fullgc_ATL', 'Fullgc_MTL',...
            'PeakES_MGL', 'PeakES_ATL', 'PeakES_MTU', 'PeakIdx_MGL', 'PeakIdx_ATL', 'PeakIdx_MTU',...
            'Level', 'Perceived'});
        avgESTab = [avgESTab; tempTab];
    end
    clear esFGC_MGL esFGC_MTL esFGC_ATL esP_ATL esP_MTL esP_MGL tesP_MGL tesP_ATL tesP_MTU
end
%% 

% 
% for iSub = 1:length(subjects)-1 
%     subID = subjects{iSub};
%     load(['G:\Shared drives\Perception Project\Ultrasound\OpenSim\YAUSPercep' subID '\Tables\'...
%         'lenMTUTable_YAUSPercep' subID '.mat'])
%     for iTrial = 1:size(lengthUSTab,1)
%         tempMG_len = lengthUSTab.MG_Length{iTrial}(:,:)-lengthUSTab.MG_Length{iTrial}(1,:);
%         tempAT_len = lengthUSTab.AT_Length{iTrial}(:,:)-lengthUSTab.AT_Length{iTrial}(1,:);
%         tempMTU_len = lengthUSTab.MTU_Length{iTrial}(:,:)-lengthUSTab.MTU_Length{iTrial}(1,:);
% %         keyboard;
% 
% 
%        [mMG_LEx, iMG_LEx] = min(tempMG_len, [], 1);
%        [mAT_LEx, iAT_LEx] = max(tempAT_len, [], 1);
%        [mMT_LEx, iMT_LEx] = min(tempMTU_len, [], 1);
%         % Accounting for some subjects having weird starting and ending
%         % values so adding the 29 values missing before
% %        iMG_LEx = iMG_LEx +29; 
% %        iAT_LEx = iAT_LEx + 29; 
% %        iMT_LEx = iMT_LEx + 29;
%        % Placing the excursion values into a cell to be place in a table
%        % later
%        exMG{iTrial,1} = mean(mMG_LEx(1:size(mMG_LEx,2)-1)); 
%        exMG{iTrial,2} = mMG_LEx(size(mMG_LEx,2));
% 
%        exAT{iTrial,1} = mean(mAT_LEx(1:size(mAT_LEx,2)-1)); 
%        exAT{iTrial,2} = mAT_LEx(size(mAT_LEx,2));
% 
%        exMTU{iTrial,1} = mean(mMT_LEx(1:size(mMT_LEx,2))); 
%        exMTU{iTrial,2} = mMT_LEx(size(mMT_LEx,2));
% 
%        tMG{iTrial,1} = mean(iMG_LEx(1:size(iMG_LEx,2)));
%        tMG{iTrial,2} = iMG_LEx(size(iMG_LEx,2));
% 
%        tAT{iTrial,1} = mean(iAT_LEx(1:size(iAT_LEx,2)));
%        tAT{iTrial,2} = iAT_LEx(size(iAT_LEx,2));
% 
%        tMTU{iTrial,1} = mean(iMT_LEx(1:size(iMT_LEx,2)));
%        tMTU{iTrial,2} = iMT_LEx(size(iMT_LEx,2));
%     end
%     if iSub == 1
%         excursTab = table(iSub*ones(size(lengthUSTab,1),1), exMG, tMG, exAT, tAT,...
%         exMTU, tMTU, 'VariableNames', {'SubjectNum'; 'excur_MG'; 'id_excur_MG';...
%         'excur_AT'; 'id_excur_AT'; 'excur_MTU'; 'id_excut_MTU'});
%     else
%         tempTab2 = table(iSub*ones(size(lengthUSTab,1),1), exMG, tMG, exAT, tAT,...
%         exMTU, tMTU, 'VariableNames', {'SubjectNum'; 'excur_MG'; 'id_excur_MG';...
%         'excur_AT'; 'id_excur_AT'; 'excur_MTU'; 'id_excut_MTU'});
% 
%         excursTab = [excursTab;tempTab2];
%     end
%     clearvars -except iSub iTrial excursTab subjects
% end

