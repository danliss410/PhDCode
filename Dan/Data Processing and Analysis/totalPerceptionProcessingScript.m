%% Overall Perception Processing Script
clear 
home
subjects = {'01'; '02'; '03'; '04'; '05'; '09';'10';'11';'12';'13';'14';'15'; '16'; '17'; '18';};
numTrials = [4; 5; 4; 4; 4; 4; 4; 4; 4; 4; 5; 4; 4; 4; 4;]; % Subject 2 has 5 trials but 2-5 were the ones that were actual perception trials and processed. Subject 8 has 6 trials but only 3-6 were the actual perception trials. Subject 14 has 5 trials.
numTreadmillTrials = [2; 3; 3; 2; 2; 2; 2; 3; 3; 3; 3; 3; 3; 3; 3;]; %Subject 13 has 2 trials only used 2&3 not 1. Subject 7 has 4 trials but 3 and 4 are used. 
SSWS = [1.25; 1.25; 1.15; 1.2; 1.15; 1.05; 1.1; 1; 0.95; 1.25; 1; 1.2; 1.2; 1.3; 1.05;];
isRBHD = [0]; %0];
domLeg = {'R'; 'R'; 'L'; 'R'; 'R'; 'R'; 'R'; 'R'; 'R'; 'R';'R'; 'R'; 'R';'R'; 'R';}; % Insert all the subjects dominant legs
leg = [841; 827.5; 865.5; 928.5; 896; 786; 873; 899; 957.5; 934; 873.5; 965; 962; 1028.5; 977;];
    %[896; 916.5; 873; 899; 957.5; 934; 873.5; 965; 962; 1028.5; 977]; % Average Leg length for each subject
markerOpsF = [2; 0; 0; 0; 2; 0; 0; 2; 1; 0; 2; 0; 0; 0; 0;]; % 2 codes for CLAV only, 1 codes for C7 only, and 0 codes for all markers in the calibration trial


for iSubject = 1:size(subjects,1)   
    strSubject = subjects{iSubject};
%     markerOps = markerOpsF(iSubject);
    legLength = leg(iSubject);

%     [analogTable,videoTable,gaitEventsTable] = concatenateData(strSubject,numTrials(iSubject),numTreadmillTrials(iSubject));
%     batchIKnBAprocessingOS(strSubject, markerOps);
%     [BodyAnalysisTable] = concatenateOpenSim(strSubject,numTrials(iSubject),numTreadmillTrials(iSubject), SSWS(iSubject));
%     pertTable = calcPerturbationParameters(strSubject);
%     pertCycleStruc = calcPertCycleNFrames(strSubject);
%     [LpertGC,RpertGC] = calcPertGCTables(strSubject);


%     [spatTempTable,jointAnglesTable, headCalcStruc] = calcSpatTempNJointAngles(strSubject, numTrials(iSubject),numTreadmillTrials(iSubject), isRBHD);
%     plotBAResultsNJointAngles(strSubject); 
%     [pEmgStruct,npEmgStruct]  =  proc_EMG_Perception(strSubject, domLeg);
%     checkNplotEMG(strSubject, domLeg);
%     [posSegmentsTable, velSegmentsTable, accSegmentsTable] = concatenateSegments2(strSubject,numTrials(iSubject),numTreadmillTrials(iSubject));
%     [inertiaTensor] = translateInertia(strSubject);
    dynamicStabilityTable = calcDynamicStability(strSubject, legLength);


%     plotDynamicStabilityResults(strSubject)
    saveSubject(strSubject);
clear strSubject legLength
end

disp('Finished Processing')
beep