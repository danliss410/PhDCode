%%
% Running effect size calculations for the 11 subjects for the ISPGR
% abstract
subjects = {'01'; '02'; '03'; '04'; '05'; '09'; '10'; '11'; '12'; '13'; '14'; '15'; '16'; '17'; '18';}; % 
speedLows = [-0.05; -0.05; -0.05; -0.05; -0.05; -0.02; -0.10; -0.05; -0.05; -0.10; -0.10; -0.02; -0.05; -0.05; -0.10];
speedHighs = [-0.10; -0.10; -0.10; -0.10; -0.10; -0.05; -0.15; -0.10; -0.10; -0.15; -0.15; -0.05; -0.10; -0.10; -0.15];
for iSub = 1:length(subjects)
    strSubject = subjects{iSub};
    [prepdata, d] = Effect_SizeNacob(strSubject, speedLows(iSub), speedHighs(iSub));
    disp(['finished ' strSubject]);
end

%%
for iSub = 1:length(subjects)
    strSubject = subjects{iSub};
    fn = ['G:\Shared drives\NeuroMobLab\Projects\Perception\Processed Data\Dan\Results\NACOB\nacobES_YAPercep' strSubject];
    load(fn)
    sub.(['YAPercep' strSubject]) = d;
    clear d prepData fn
end
    
%%

speeds = {'sp2'; 'sp3'; 'sp4'; 'sp5';};
dynamicNames = fieldnames(sub.YAPercep05.Neg05);

for iSub = 1:length(subjects)
    strSubject = subjects{iSub};
    subID = ['YAPercep' strSubject];
    speedNames = fieldnames(sub.(subID));
    for iSpeeds = 1:2
        for iSens = 1:length(dynamicNames)-3
            sub2.(subID).(speedNames{iSpeeds}).(dynamicNames{iSens}).stance = mean(abs(sub.(subID).(speedNames{iSpeeds}).(dynamicNames{iSens}).onset2pre(20:61,:)),1)';
            sub2.(subID).(speedNames{iSpeeds}).(dynamicNames{iSens}).swing = mean(abs(sub.(subID).(speedNames{iSpeeds}).(dynamicNames{iSens}).onset2pre(61:101,:)),1)';
            sub2.(subID).(speedNames{iSpeeds}).(dynamicNames{iSens}).fullgc = mean(abs(sub.(subID).(speedNames{iSpeeds}).(dynamicNames{iSens}).onset2pre(:,:)),1)';
            sub2.(subID).(speedNames{iSpeeds}).(dynamicNames{iSens}).maxfullgc = max(abs(sub.(subID).(speedNames{iSpeeds}).(dynamicNames{iSens}).onset2pre(:,:)),[],1)';
        end
    end
end




%% Creating Matrix for Stats 

temp2 = [];
temp3 = [];
temp4 = [];
temp6 = [];
statsForNACOB = [];
statsForNACOB2 = [];
statsForNACOB3 = [];
statsForNACOB4 = [];
for iSub = 1:length(subjects) 
    strSubject = subjects{iSub};
    subID = ['YAPercep' strSubject];
    speedNames = fieldnames(sub.(subID));
    for iLevels = 1:2      
        for iSens = 1:length(dynamicNames)-3
            temp = sub2.(subID).(speedNames{iLevels}).(dynamicNames{iSens}).stance;
            temp1 = sub2.(subID).(speedNames{iLevels}).(dynamicNames{iSens}).swing;
            temp5 = sub2.(subID).(speedNames{iLevels}).(dynamicNames{iSens}).fullgc;
            temp7 = sub2.(subID).(speedNames{iLevels}).(dynamicNames{iSens}).maxfullgc;
            temp2(:,iSens) = temp;
            temp3(:,iSens) = temp1;
            temp4(:,iSens) = temp5;
            temp6(:,iSens) = temp7;
        end
        statsForNACOB = [statsForNACOB; temp2;];
        statsForNACOB2 = [statsForNACOB2; temp3;];
        statsForNACOB3 = [statsForNACOB3; temp4;];
        statsForNACOB4 = [statsForNACOB4; temp6;];
        clear temp2 temp temp1 temp5 temp3 temp4 temp6 temp7
    end

end
            
            
        
