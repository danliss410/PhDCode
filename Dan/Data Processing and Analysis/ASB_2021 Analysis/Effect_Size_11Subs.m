% Running effect size calculations for the 11 subjects for the ISPGR
% abstract
subjects = {'05'; '07'; '10';'11';'12';'13';'14';'15'; '16'; '17'; '18';}; % 

for iSub = 7%:length(subjects)
    strSubject = subjects{iSub};
    [prepData, d] = Effect_Size(strSubject);
    disp(['finished ' strSubject]);
end


for iSub = 7%1:length(subjects)
    strSubject = subjects{iSub};
    fn = ['G:\Shared drives\NeuroMobLab\Projects\Perception\Processed Data\Dan\OpenSim\YAPercep Outputs\YAPercep' strSubject '\Data Tables\effectSize_YAPercep' strSubject];
    load(fn)
    sub.(['YAPercep' strSubject]) = d; 
    clear d prepData fn
    fn = ['G:\Shared drives\NeuroMobLab\Projects\Perception\Processed Data\Dan\Matlab Analysis\YAPercep' strSubject '\Data Tables\GCTables_YAPercep' strSubject];
    load(fn)
    sub.(['YAPercep' strSubject]).RpertGC = RpertGC;
end
    

sensoryNames = {'ankle'; 'knee'; 'hip'; 'headA'; 'headV'; 'COPx'; 'COPy';};
speeds = {'sp2'; 'sp3'; 'sp4'; 'sp5';};
Leg = {'R'};

for iSub = 1:length(subjects)
    strSubject = subjects{iSub};
    subID = ['YAPercep' strSubject];
    for iSpeeds = 1:length(speeds)
        for iSens = 1:length(sensoryNames)
            sub2.(subID).(speeds{iSpeeds}).(sensoryNames{iSens}) = mean(abs(sub.(subID).R.(speeds{iSpeeds}).(sensoryNames{iSens}).onset2pre(20:61,:)),1)';
        end
    end
end


for iSub = 1:length(subjects)
    strSubject = subjects{iSub};
    subID = ['YAPercep' strSubject];
    fn = ['G:\Shared drives\NeuroMobLab\Projects\Perception\Processed Data\Dan\Matlab Analysis\YAPercep' strSubject '\Data Tables\pertCycleStruc_YAPercep' strSubject];
    load(fn);
    per.(subID) = pertCycleStruc.R; 
    clear pertCycleStruc
end 


%% 
temp = [sub2.YAPercep05.sp3.ankle, sub2.YAPercep05.sp3.knee, sub2.YAPercep05.sp3.hip, sub2.YAPercep05.sp3.COPx];
temp2 = [temp; sub2.YAPercep05.sp4.ankle, sub2.YAPercep05.sp4.knee, sub2.YAPercep05.sp4.hip, sub2.YAPercep05.sp4.COPx];
clear temp

temp3 = [temp2; sub2.YAPercep07.sp2.ankle, sub2.YAPercep07.sp2.knee, sub2.YAPercep07.sp2.hip, sub2.YAPercep07.sp2.COPx];
temp = [temp3; sub2.YAPercep07.sp3.ankle, sub2.YAPercep07.sp3.knee, sub2.YAPercep07.sp3.hip, sub2.YAPercep07.sp3.COPx];
clear temp2 temp3 

temp2 = [temp; sub2.YAPercep10.sp4.ankle, sub2.YAPercep10.sp4.knee, sub2.YAPercep10.sp4.hip, sub2.YAPercep10.sp4.COPx];
temp3 = [temp2; sub2.YAPercep10.sp5.ankle, sub2.YAPercep10.sp5.knee, sub2.YAPercep10.sp5.hip, sub2.YAPercep10.sp5.COPx];
clear temp temp2

temp = [temp3; sub2.YAPercep11.sp3.ankle, sub2.YAPercep11.sp3.knee, sub2.YAPercep11.sp3.hip, sub2.YAPercep11.sp3.COPx];
temp2 = [temp; sub2.YAPercep11.sp4.ankle, sub2.YAPercep11.sp4.knee, sub2.YAPercep11.sp4.hip, sub2.YAPercep11.sp4.COPx];
clear temp3 temp 

temp3 = [temp2; sub2.YAPercep12.sp3.ankle, sub2.YAPercep12.sp3.knee, sub2.YAPercep12.sp3.hip, sub2.YAPercep12.sp3.COPx];
temp = [temp3; sub2.YAPercep12.sp4.ankle, sub2.YAPercep12.sp4.knee, sub2.YAPercep12.sp4.hip, sub2.YAPercep12.sp4.COPx];
clear temp3 temp2 

temp2 = [temp; sub2.YAPercep13.sp4.ankle, sub2.YAPercep13.sp4.knee, sub2.YAPercep13.sp4.hip, sub2.YAPercep13.sp4.COPx];
temp3 = [temp2; sub2.YAPercep13.sp5.ankle, sub2.YAPercep13.sp5.knee, sub2.YAPercep13.sp5.hip, sub2.YAPercep13.sp5.COPx];
clear temp temp2

temp = [temp3; sub2.YAPercep14.sp4.ankle, sub2.YAPercep14.sp4.knee, sub2.YAPercep14.sp4.hip, sub2.YAPercep14.sp4.COPx];
temp2 = [temp; sub2.YAPercep14.sp5.ankle, sub2.YAPercep14.sp5.knee, sub2.YAPercep14.sp5.hip, sub2.YAPercep14.sp5.COPx];
clear temp temp3

temp3 = [temp2; sub2.YAPercep15.sp2.ankle, sub2.YAPercep15.sp2.knee, sub2.YAPercep15.sp2.hip, sub2.YAPercep15.sp2.COPx];
temp = [temp3; sub2.YAPercep15.sp3.ankle, sub2.YAPercep15.sp3.knee, sub2.YAPercep15.sp3.hip, sub2.YAPercep15.sp3.COPx];
clear temp2 temp3 

temp2 = [temp; sub2.YAPercep16.sp3.ankle, sub2.YAPercep16.sp3.knee, sub2.YAPercep16.sp3.hip, sub2.YAPercep16.sp3.COPx];
temp3 = [temp2; sub2.YAPercep16.sp4.ankle, sub2.YAPercep16.sp4.knee, sub2.YAPercep16.sp4.hip, sub2.YAPercep16.sp4.COPx];
clear temp2 temp 

temp = [temp3; sub2.YAPercep17.sp3.ankle, sub2.YAPercep17.sp3.knee, sub2.YAPercep17.sp3.hip, sub2.YAPercep17.sp3.COPx];
temp2 = [temp; sub2.YAPercep17.sp4.ankle, sub2.YAPercep17.sp4.knee, sub2.YAPercep17.sp4.hip, sub2.YAPercep17.sp4.COPx];
clear temp3 temp 

temp3 = [temp2; sub2.YAPercep18.sp4.ankle, sub2.YAPercep18.sp4.knee, sub2.YAPercep18.sp4.hip, sub2.YAPercep18.sp4.COPx];
temp = [temp3; sub2.YAPercep18.sp5.ankle, sub2.YAPercep18.sp5.knee, sub2.YAPercep18.sp5.hip, sub2.YAPercep18.sp5.COPx];
clear temp3 temp2