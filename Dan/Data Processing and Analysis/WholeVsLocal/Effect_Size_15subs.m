%%
% Running effect size calculations for the 15 subjects for the manuscript

clear 
home
subjects = {'01'; '02'; '03'; '04'; '05'; '09'; '10'; '11'; '12'; '13'; '14'; '15'; '16'; '17'; '18';}; % 
speedLows = [-0.05; -0.05; -0.05; -0.05; -0.05; -0.02; -0.10; -0.05; -0.05; -0.10; -0.10; -0.02; -0.05; -0.05; -0.10];
speedHighs = [-0.10; -0.10; -0.10; -0.10; -0.10; -0.05; -0.15; -0.10; -0.10; -0.15; -0.15; -0.05; -0.10; -0.10; -0.15];
for iSub = 1%:length(subjects) %1:
    strSubject = subjects{iSub};
%     [prepdata, d] = Effect_SizeDynamicStability(strSubject, speedLows(iSub), speedHighs(iSub));
    [prepdata2, d2] = Effect_SizeLocalSense(strSubject, speedLows(iSub), speedHighs(iSub));
    disp(['finished ' strSubject]);
end

%% Whole Body 
for iSub = 1:length(subjects)
    strSubject = subjects{iSub};
    fn = ['D:\Github\Perception-Project\Dan\Data Processing and Analysis\WholeVsLocal\Data\effectSizeWhole_YAPercep' strSubject '.mat'];
    load(fn)
    sub.(['YAPercep' strSubject]) = d;
    clear d prepData fn
end

%% Local 
for iSub = 1:length(subjects)
    strSubject = subjects{iSub};
    fn2 = ['D:\Github\Perception-Project\Dan\Data Processing and Analysis\WholeVsLocal\Data\effectSizeLocal_YAPercep' strSubject '.mat'];
    load(fn2)
    sub3.(['YAPercep' strSubject]) = d;
    clear d prepData fn
end
    
%% Calculating the Whole Body Sensing contributions 

speeds = {'sp2'; 'sp3'; 'sp4'; 'sp5';};
dynamicNames = fieldnames(sub.YAPercep05.Neg05);

for iSub = 1:length(subjects)
    strSubject = subjects{iSub};
    subID = ['YAPercep' strSubject];
    speedNames = fieldnames(sub.(subID));
    for iSpeeds = 1:2
        for iSens = 1:length(dynamicNames)-1
            sub2.(subID).(speedNames{iSpeeds}).(dynamicNames{iSens}).stance = nanmean(abs(sub.(subID).(speedNames{iSpeeds}).(dynamicNames{iSens}).onset2pre(20:61,:)),1)';
%             sub2.(subID).(speedNames{iSpeeds}).(dynamicNames{iSens}).swing = mean(abs(sub.(subID).(speedNames{iSpeeds}).(dynamicNames{iSens}).onset2pre(61:101,:)),1)';
            sub2.(subID).(speedNames{iSpeeds}).(dynamicNames{iSens}).fullgc = nanmean(abs(sub.(subID).(speedNames{iSpeeds}).(dynamicNames{iSens}).onset2pre(:,:)),1)';
%             sub2.(subID).(speedNames{iSpeeds}).(dynamicNames{iSens}).maxfullgc = max(abs(sub.(subID).(speedNames{iSpeeds}).(dynamicNames{iSens}).onset2pre(:,:)),[],1)';
        end
    end
end

%% Calculating the Local Sensory Feedback contributions 
speeds = {'sp2'; 'sp3'; 'sp4'; 'sp5';};
sensoryNames = fieldnames(sub3.YAPercep05.Neg05);

for iSub = 1:length(subjects)
    strSubject = subjects{iSub};
    subID = ['YAPercep' strSubject];
    speedNames = fieldnames(sub3.(subID));
    for iSpeeds = 1:2
        for iSens = 1:length(sensoryNames)-1
            sub4.(subID).(speedNames{iSpeeds}).(sensoryNames{iSens}).stance = mean(abs(sub3.(subID).(speedNames{iSpeeds}).(sensoryNames{iSens}).onset2pre(20:61,:)),1)';
            sub4.(subID).(speedNames{iSpeeds}).(sensoryNames{iSens}).fullgc = mean(abs(sub3.(subID).(speedNames{iSpeeds}).(sensoryNames{iSens}).onset2pre(:,:)),1)';
        end
    end
end




%% Creating Matrix for Whole Body Stats 

temp2 = [];
temp3 = [];
temp4 = [];

localStance = [];
localGC = [];
for iSub = 1:length(subjects) 
    strSubject = subjects{iSub};
    subID = ['YAPercep' strSubject];
    speedNames = fieldnames(sub.(subID));
    for iLevels = 1:2      
        for iDyn = 1:length(dynamicNames)-1
            % Whole Body Stance Values
            temp = sub2.(subID).(speedNames{iLevels}).(dynamicNames{iDyn}).stance;
            % Whole body Full GC Values 
            temp5 = sub2.(subID).(speedNames{iLevels}).(dynamicNames{iDyn}).fullgc;
            % Temp Storage of Stance 
            temp2(:,iDyn) = temp;
            % Temp Storage of Full GC
            temp4(:,iDyn) = temp5;

        end
        localStance = [localStance; temp2;];
        localGC = [localGC; temp4;];

        clear temp2 temp temp1 temp5 temp3 temp4 temp6 temp7
    end

end

%% Creating Matrix for Local Stats 

temp2 = [];
temp3 = [];
temp4 = [];

localStance = [];
localGC = [];
for iSub = 1:length(subjects) 
    strSubject = subjects{iSub};
    subID = ['YAPercep' strSubject];
    speedNames = fieldnames(sub.(subID));
    for iLevels = 1:2      
        for iSensory = 1:length(sensoryNames)-1
            % Whole Body Stance Values
            temp = sub4.(subID).(speedNames{iLevels}).(sensoryNames{iSensory}).stance;
            % Whole body Full GC Values 
            temp5 = sub4.(subID).(speedNames{iLevels}).(sensoryNames{iSensory}).fullgc;
            % Temp Storage of Stance 
            temp2(:,iSensory) = temp;
            % Temp Storage of Full GC
            temp4(:,iSensory) = temp5;

        end
        localStance = [localStance; temp2;];
        localGC = [localGC; temp4;];

        clear temp2 temp temp1 temp5 temp3 temp4 temp6 temp7
    end

end
            
            
        
