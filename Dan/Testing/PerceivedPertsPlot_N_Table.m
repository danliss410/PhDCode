% This script will get all the subjects data on the YesNo Perception
% Experiment and plot the distribution of which subjects perceived what
% disturbtion 

Subjects = {'01'; '02'; '03'; '04'; '05'; '06'; '07'; '08'; '09'; '10'; '11'; '12'; '13'; '14'; '15';};

% Pulling all the YesNo Perception trial data for all subjects into a
% structure with each subject individually in the next layer 
for i = 1:length(Subjects)
    strSubject = Subjects{i};
    subjectYesNo = ['YAPercep' strSubject '_YesNo'];
%% Loading the necessary log file for the subject
    fileLocation = 'G:\Shared drives\NeuroMobLab\Experimental Data\Log Files\Pilot Experiments\PerceptionStudy\';
    data1 = readtable([fileLocation subjectYesNo]);
    Percep.(subjectYesNo) = data1(:,[1,2,3,6,9]); % Grabbing specific columns from table: Trial number, Perturbation number, Leg, dV, perceived 

    clear data1 fileLocation subjectYesNo strSubject
end


% Find the logical matrices for each speed then get the leg and everything
% else 
count = 1;
for iSub = 1:size(Subjects,1)
    strSubject = Subjects{iSub};
    subjectYesNo = ['YAPercep' strSubject '_YesNo'];
    if iSub == 1
        subTab = Percep.(subjectYesNo);
        numSub = count*ones(size(Percep.(subjectYesNo),1),1);
        subTab.Subject = numSub;
    else
        tempTab1 = Percep.(subjectYesNo);
        numSub = count*ones(size(Percep.(subjectYesNo),1),1);
    
        tempTab1.Subject = numSub;
    
        subTab = [subTab; tempTab1];
    end
    count = count + 1; 
    clear numSub tempTab1
end

% Got rid of the positive perturbation values for the 1st 3 subjects so
% this table will hold catch trials and slips 
tempLoc = find(subTab.dV <=0);
subTab1 = subTab(tempLoc,:);

% Creating logistical arrays 
perceivedLog = subTab1.perceived == 1;
sLog.sp1 = subTab1.dV == 0;
sLog.sp2 = subTab1.dV == -0.02;
sLog.sp3 = subTab1.dV == -0.05;
sLog.sp4 = subTab1.dV == -0.1;
sLog.sp5 = subTab1.dV == -0.15;
sLog.sp6 = subTab1.dV == -0.2;
sLog.sp7 = subTab1.dV == -0.3;
sLog.sp8 = subTab1.dV == -0.4;
legLog = contains(subTab1.LegIn, 'L');

% Creating structure of all the perceived and not perceived speeds and for
% each leg
subjectName = {'YAP01'; 'YAP02'; 'YAP03'; 'YAP04'; 'YAP05'; 'YAP06'; 'YAP07'; 'YAP08'; 'YAP09'; 'YAP10'; 'YAP11'; 'YAP12'; 'YAP13'; 'YAP14'; 'YAP15';};
speeds = {'sp1'; 'sp2'; 'sp3'; 'sp4'; 'sp5'; 'sp6'; 'sp7'; 'sp8'};
count = 1;
for iSub = 1:size(subjectName,1)
    for iSpeed = 1:size(speeds,1)
        subStruct.(subjectName{iSub}).(speeds{iSpeed}).perceived = sum(perceivedLog == 1 & sLog.(speeds{iSpeed}) == 1 & subTab1.Subject == count);
        subStruct.(subjectName{iSub}).(speeds{iSpeed}).missed = sum(perceivedLog == 0 & sLog.(speeds{iSpeed}) == 1 & subTab1.Subject == count);
        subStruct.(subjectName{iSub}).(speeds{iSpeed}).L.perceived = sum(perceivedLog == 1 & sLog.(speeds{iSpeed}) == 1 & subTab1.Subject == count & legLog == 1);
        subStruct.(subjectName{iSub}).(speeds{iSpeed}).L.missed = sum(perceivedLog == 0 & sLog.(speeds{iSpeed}) == 1 & subTab1.Subject == count & legLog == 1);
        subStruct.(subjectName{iSub}).(speeds{iSpeed}).R.perceived = sum(perceivedLog == 1 & sLog.(speeds{iSpeed}) == 1 & subTab1.Subject == count & legLog ~= 1);
        subStruct.(subjectName{iSub}).(speeds{iSpeed}).R.missed = sum(perceivedLog == 0 & sLog.(speeds{iSpeed}) == 1 & subTab1.Subject == count & legLog ~= 1);        
    end
    count = count+1;
end

load('G:\Shared drives\NeuroMobLab\Projects\Perception\Processed Data\Dan\Matlab Analysis\Thresholds\Results.mat')

% Creating table of all the perceived totals and the subjects thresholds 
for iSub = 1:size(subjectName,1)
    if iSub == 1 
        percepTable = table({subjectName{iSub}}, subStruct.(subjectName{iSub}).sp1.perceived, subStruct.(subjectName{iSub}).sp1.missed,...
            subStruct.(subjectName{iSub}).sp2.perceived, subStruct.(subjectName{iSub}).sp2.missed, subStruct.(subjectName{iSub}).sp3.perceived,subStruct.(subjectName{iSub}).sp3.missed, ...
            subStruct.(subjectName{iSub}).sp4.perceived, subStruct.(subjectName{iSub}).sp4.missed, subStruct.(subjectName{iSub}).sp5.perceived,subStruct.(subjectName{iSub}).sp5.missed,...
            subStruct.(subjectName{iSub}).sp6.perceived, subStruct.(subjectName{iSub}).sp6.missed, subStruct.(subjectName{iSub}).sp7.perceived, subStruct.(subjectName{iSub}).sp7.missed,...
            subStruct.(subjectName{iSub}).sp8.perceived, subStruct.(subjectName{iSub}).sp8.missed,...
            subStruct.(subjectName{iSub}).sp1.L.perceived, subStruct.(subjectName{iSub}).sp1.L.missed,subStruct.(subjectName{iSub}).sp1.R.perceived, subStruct.(subjectName{iSub}).sp1.R.missed,...
            subStruct.(subjectName{iSub}).sp2.L.perceived, subStruct.(subjectName{iSub}).sp2.L.missed,subStruct.(subjectName{iSub}).sp2.R.perceived, subStruct.(subjectName{iSub}).sp2.R.missed,...
            subStruct.(subjectName{iSub}).sp3.L.perceived, subStruct.(subjectName{iSub}).sp3.L.missed,subStruct.(subjectName{iSub}).sp3.R.perceived, subStruct.(subjectName{iSub}).sp3.R.missed,...
            subStruct.(subjectName{iSub}).sp4.L.perceived, subStruct.(subjectName{iSub}).sp4.L.missed,subStruct.(subjectName{iSub}).sp4.R.perceived, subStruct.(subjectName{iSub}).sp4.R.missed,...
            subStruct.(subjectName{iSub}).sp5.L.perceived, subStruct.(subjectName{iSub}).sp5.L.missed,subStruct.(subjectName{iSub}).sp5.R.perceived, subStruct.(subjectName{iSub}).sp5.R.missed,...
            subStruct.(subjectName{iSub}).sp6.L.perceived, subStruct.(subjectName{iSub}).sp6.L.missed,subStruct.(subjectName{iSub}).sp6.R.perceived, subStruct.(subjectName{iSub}).sp6.R.missed,...
            subStruct.(subjectName{iSub}).sp7.L.perceived, subStruct.(subjectName{iSub}).sp7.L.missed,subStruct.(subjectName{iSub}).sp7.R.perceived, subStruct.(subjectName{iSub}).sp7.R.missed,...
            subStruct.(subjectName{iSub}).sp8.L.perceived, subStruct.(subjectName{iSub}).sp8.L.missed,subStruct.(subjectName{iSub}).sp8.R.perceived, subStruct.(subjectName{iSub}).sp8.R.missed,...
            TabYesNo.DomThres(iSub), TabYesNo.NonDomThres(iSub),...
            'VariableNames', {'Subject ID'; 'Total Perceived(TP) Catch Trials'; 'Total Missed(TM) Catch Trials'; 'TP -0.02 m/s'; 'TM -0.02 m/s';...
            'TP -0.05 m/s'; 'TM -0.05 m/s'; 'TP -0.10 m/s'; 'TM -0.10 m/s'; 'TP -0.15 m/s'; 'TM -0.15 m/s'; 'TP -0.20 m/s'; 'TM -0.20 m/s'; 'TP -0.30 m/s'; 'TM -0.30 m/s';...
            'TP -0.40 m/s'; 'TM -0.40 m/s'; 'TP Left(L) Catch Trials'; 'TM L Catch Trials'; 'TP Right(R) Catch Trials'; 'TM R Catch Trials'; 'TP L -0.02 m/s'; 'TM L -0.02 m/s';...
            'TP R -0.02 m/s'; 'TM R -0.02 m/s'; 'TP L -0.05 m/s'; 'TM L -0.05 m/s'; 'TP R -0.05 m/s'; 'TM R -0.05 m/s'; 'TP L -0.10 m/s'; 'TM L -0.10 m/s'; 'TP R -0.10 m/s';...
            'TM R -0.10 m/s'; 'TP L -0.15 m/s'; 'TM L -0.15 m/s'; 'TP R -0.15 m/s'; 'TM R -0.15 m/s'; 'TP L -0.20 m/s'; 'TM L -0.20 m/s'; 'TP R -0.20 m/s'; 'TM R -0.20 m/s';...
            'TP L -0.30 m/s'; 'TM L -0.30 m/s'; 'TP R -0.30 m/s'; 'TM R -0.30 m/s'; 'TP L -0.40 m/s'; 'TM L -0.40 m/s'; 'TP R -0.40 m/s'; 'TM R -0.40 m/s';...
            'Dominant Leg Threshold'; 'NonDominant Leg Threshold';});
    else
        percepTable.("Subject ID"){iSub} = {subjectName{iSub}};
        percepTable.("Total Perceived(TP) Catch Trials")(iSub) = subStruct.(subjectName{iSub}).sp1.perceived;
        percepTable.("Total Missed(TM) Catch Trials")(iSub) = subStruct.(subjectName{iSub}).sp1.missed;
        percepTable.('TP -0.02 m/s')(iSub) = subStruct.(subjectName{iSub}).sp2.perceived;
        percepTable.("TM -0.02 m/s")(iSub) = subStruct.(subjectName{iSub}).sp2.missed;
        percepTable.("TP -0.05 m/s")(iSub) = subStruct.(subjectName{iSub}).sp3.perceived;
        percepTable.("TM -0.05 m/s")(iSub) = subStruct.(subjectName{iSub}).sp3.missed;
        percepTable.("TP -0.10 m/s")(iSub) = subStruct.(subjectName{iSub}).sp4.perceived;
        percepTable.("TM -0.10 m/s")(iSub)= subStruct.(subjectName{iSub}).sp4.missed;
        percepTable.("TP -0.15 m/s")(iSub)= subStruct.(subjectName{iSub}).sp5.perceived;
        percepTable.("TM -0.15 m/s")(iSub)= subStruct.(subjectName{iSub}).sp5.missed;
        percepTable.("TP -0.20 m/s")(iSub)= subStruct.(subjectName{iSub}).sp6.perceived;
        percepTable.("TM -0.20 m/s")(iSub)= subStruct.(subjectName{iSub}).sp6.missed;
        percepTable.("TP -0.30 m/s")(iSub)= subStruct.(subjectName{iSub}).sp7.perceived;
        percepTable.("TM -0.30 m/s")(iSub) = subStruct.(subjectName{iSub}).sp7.missed;
        percepTable.("TP -0.40 m/s")(iSub) = subStruct.(subjectName{iSub}).sp8.perceived;
        percepTable.("TM -0.40 m/s")(iSub) = subStruct.(subjectName{iSub}).sp8.missed;
        percepTable.("TP Left(L) Catch Trials")(iSub) = subStruct.(subjectName{iSub}).sp1.L.perceived;
        percepTable.("TM L Catch Trials")(iSub) = subStruct.(subjectName{iSub}).sp1.L.missed;
        percepTable.("TP Right(R) Catch Trials")(iSub) = subStruct.(subjectName{iSub}).sp1.R.perceived;
        percepTable.("TM R Catch Trials")(iSub) = subStruct.(subjectName{iSub}).sp1.R.missed;
        percepTable.("TP L -0.02 m/s")(iSub) = subStruct.(subjectName{iSub}).sp2.L.perceived;
        percepTable.("TM L -0.02 m/s")(iSub) = subStruct.(subjectName{iSub}).sp2.L.missed;
        percepTable.("TP R -0.02 m/s")(iSub) = subStruct.(subjectName{iSub}).sp2.R.perceived;
        percepTable.("TM R -0.02 m/s")(iSub) = subStruct.(subjectName{iSub}).sp2.R.missed;
        percepTable.("TP L -0.05 m/s")(iSub) = subStruct.(subjectName{iSub}).sp3.L.perceived;
        percepTable.("TM L -0.05 m/s")(iSub) = subStruct.(subjectName{iSub}).sp3.L.missed;
        percepTable.("TP R -0.05 m/s")(iSub) = subStruct.(subjectName{iSub}).sp3.R.perceived;
        percepTable.("TM R -0.05 m/s")(iSub) = subStruct.(subjectName{iSub}).sp3.R.missed;
        percepTable.("TP L -0.10 m/s")(iSub) = subStruct.(subjectName{iSub}).sp4.L.perceived;
        percepTable.("TM L -0.10 m/s")(iSub) = subStruct.(subjectName{iSub}).sp4.L.missed;
        percepTable.("TP R -0.10 m/s")(iSub) = subStruct.(subjectName{iSub}).sp4.R.perceived;
        percepTable.("TM R -0.10 m/s")(iSub) = subStruct.(subjectName{iSub}).sp4.R.missed;
        percepTable.("TP L -0.15 m/s")(iSub) = subStruct.(subjectName{iSub}).sp5.L.perceived;
        percepTable.("TM L -0.15 m/s")(iSub) = subStruct.(subjectName{iSub}).sp5.L.missed;
        percepTable.("TP R -0.15 m/s")(iSub) = subStruct.(subjectName{iSub}).sp5.R.perceived;
        percepTable.("TM R -0.15 m/s")(iSub) = subStruct.(subjectName{iSub}).sp5.R.missed;
        percepTable.("TP L -0.20 m/s")(iSub) = subStruct.(subjectName{iSub}).sp6.L.perceived;
        percepTable.("TM L -0.20 m/s")(iSub) = subStruct.(subjectName{iSub}).sp6.L.missed;
        percepTable.("TP R -0.20 m/s")(iSub) = subStruct.(subjectName{iSub}).sp6.R.perceived;
        percepTable.("TM R -0.20 m/s")(iSub) = subStruct.(subjectName{iSub}).sp6.R.missed;
        percepTable.("TP L -0.30 m/s")(iSub) = subStruct.(subjectName{iSub}).sp7.L.perceived;
        percepTable.("TM L -0.30 m/s")(iSub) = subStruct.(subjectName{iSub}).sp7.L.missed;
        percepTable.("TP R -0.30 m/s")(iSub) = subStruct.(subjectName{iSub}).sp7.R.perceived;
        percepTable.("TM R -0.30 m/s")(iSub) = subStruct.(subjectName{iSub}).sp7.R.missed;
        percepTable.("TP L -0.40 m/s")(iSub) = subStruct.(subjectName{iSub}).sp8.L.perceived;
        percepTable.("TM L -0.40 m/s")(iSub) = subStruct.(subjectName{iSub}).sp8.L.missed;
        percepTable.("TP R -0.40 m/s")(iSub) = subStruct.(subjectName{iSub}).sp8.R.perceived;
        percepTable.("TM R -0.40 m/s")(iSub) = subStruct.(subjectName{iSub}).sp8.R.missed;
        percepTable.("Dominant Leg Threshold")(iSub) = TabYesNo.DomThres(iSub);
        percepTable.("NonDominant Leg Threshold")(iSub) = TabYesNo.NonDomThres(iSub);
    end
end

    
%% Plotting the results 
speedsN = {'0.02'; '0.05'; '0.10'; '0.15'; '0.20'; '0.30'; '0.40';};

for iSpeed = 1:7 
    figure;
    subplot(2,1,1); bar(percepTable.(strcat("TP -",speedsN{iSpeed}," m/s"))); title(strcat("TP -",speedsN{iSpeed}," m/s")); ylabel('Total Perceived Both Legs');
    subplot(2,1,2); bar(percepTable.(strcat("TM -",speedsN{iSpeed}," m/s"))); title(strcat("TM -",speedsN{iSpeed}," m/s")); ylabel('Total Missed Both Legs'); xlabel('Subject Number');
    figure;
    subplot(4,1,1); bar(percepTable.(strcat("TP L -",speedsN{iSpeed}, " m/s"))); title(strcat("TP L -",speedsN{iSpeed}, " m/s")); ylabel('Total Perceived L');
    subplot(4,1,2); bar(percepTable.(strcat("TM L -", speedsN{iSpeed}, " m/s"))); title(strcat("TM L -", speedsN{iSpeed}, " m/s")); ylabel('Total Missed L')
    subplot(4,1,3); bar(percepTable.(strcat("TP R -", speedsN{iSpeed}, " m/s"))); title(strcat("TP R -", speedsN{iSpeed}, " m/s")); ylabel('Total Perceived R');
    subplot(4,1,4); bar(percepTable.(strcat("TM R -", speedsN{iSpeed}, " m/s"))); title(strcat("TM R -", speedsN{iSpeed}, " m/s"));xlabel('Subject Number'); ylabel('Total Missed R');
end


    
 