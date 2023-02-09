subjects = {'01'; '02'; '03'; '04'; '05'; '09';'10';'11';'12';'13';'14';'15'; '16'; '17'; '18';};
numTrials = [4; 5; 4; 4; 4; 4; 4; 4; 4; 4; 5; 4; 4; 4; 4;]; % Subject 2 has 5 trials but 2-5 were the ones that were actual perception trials and processed. Subject 8 has 6 trials but only 3-6 were the actual perception trials. Subject 14 has 5 trials.
domLeg = {'R'; 'R'; 'L'; 'R'; 'R'; 'R'; 'R'; 'R'; 'R'; 'R';'R'; 'R'; 'R';'R'; 'R';}; % Insert all the subjects dominant legs



for iSub = 1:length(subjects)
    subject1 = subjects{iSub}; 
    leg = domLeg{iSub};

    load(['G:\Shared drives\NeuroMobLab\Projects\Perception\Processed Data\Dan\Matlab Analysis\YAPercep'...
    subject1 '\Data Tables\pertCycleStruc_YAPercep' subject1 '.mat']);


    names = fieldnames(pertCycleStruc.(leg).sp1);
    tspeed = fieldnames(pertCycleStruc.(leg));
    speeds = tspeed(2:5);

    for iSpeeds = 1:size(speeds,1)
        for iNames = 1:size(names,1)
               totalPerceived.(['YAP' subject1]).(speeds{iSpeeds})(iNames) = ...
                   sum(pertCycleStruc.(leg).(speeds{iSpeeds}).(names{iNames}).Perceived);

               totalPerceived.(['YAP' subject1]).([speeds{iSpeeds} 'Tot'])(iNames) = ...
                   length(pertCycleStruc.(leg).(speeds{iSpeeds}).(names{iNames}).Perceived);
               
               totalPerceived.(['YAP' subject1]).([speeds{iSpeeds} 'Percent'])(iNames) = ...
                   sum(pertCycleStruc.(leg).(speeds{iSpeeds}).(names{iNames}).Perceived)/...
                   length(pertCycleStruc.(leg).(speeds{iSpeeds}).(names{iNames}).Perceived) * 100;
        end

    end
end
%%
Neg002 = NaN(15,5);
Neg005 = NaN(15,5);
Neg010 = NaN(15,5);
Neg015 = NaN(15,5);
for iSub = 1:length(subjects)
    subject1 = subjects{iSub};
    if size(Neg002(iSub,:)) == size(totalPerceived.(['YAP' subject1]).sp2Percent)
        Neg002(iSub,:) = totalPerceived.(['YAP' subject1]).sp2Percent;
        Neg005(iSub,:) = totalPerceived.(['YAP' subject1]).sp3Percent;
        Neg010(iSub,:) = totalPerceived.(['YAP' subject1]).sp4Percent;
        Neg015(iSub,:) = totalPerceived.(['YAP' subject1]).sp5Percent;
    else
        Neg002(iSub,:) = [totalPerceived.(['YAP' subject1]).sp2Percent, NaN];
        Neg005(iSub,:) = [totalPerceived.(['YAP' subject1]).sp3Percent, NaN];
        Neg010(iSub,:) = [totalPerceived.(['YAP' subject1]).sp4Percent, NaN];
        Neg015(iSub,:) = [totalPerceived.(['YAP' subject1]).sp5Percent, NaN];
    end
%     Neg005 = [Neg005; totalPerceived.(['YAP' subject1]).sp3Percent];
end


%% 

figure; subplot(4,1,1); bar([1, 2 3, 4], Neg002);
title('% Perceived Across Subjects per Block for -0.02 m/s perturbations')
ylabel('% Perceived')
subplot(4,1,2); bar([1, 2, 3, 4], Neg005); 
title('% Perceived Across Subjects per Block for -0.05 m/s perturbations')
ylabel('% Perceived')
subplot(4,1,3); bar([1, 2 ,3 ,4], Neg010);
title('% Perceived Across Subjects per Block for -0.10 m/s perturbations')
ylabel('% Perceived')
subplot(4,1,4); bar([1, 2, 3 ,4], Neg015); 
title('% Perceived Across Subjects per Block for -0.15 m/s perturbations')
ylabel('% Perceived')
xlabel('Block')
legend