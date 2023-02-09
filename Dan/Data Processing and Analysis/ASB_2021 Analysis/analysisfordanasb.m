% filename = '/Users/jla0024/Documents/Research/Conferences/2021 - ASB/Dan/DataFormatForStats.xlsx';
% filename = 'D:\Github\Perception-Project\Dan\Data Processing and Analysis\ASB_2021 Analysis\Stats Files\DataFormatForStats.xlsx';

filename = 'D:\Github\Perception-Project\Dan\Data Processing and Analysis\ASB_2021 Analysis\Stats Files\DataFormatForStats_ISPGR.xlsx';
sheet = 'Avg ES';

% create table 
dataTable = readtable(filename,'Sheet',sheet);

% number of percieved perturbations per subject
for i=1:11
    numPerceived(i) = sum(dataTable.Perceived(dataTable.SubjectNum==i));
end
% [data, columnNames] = xlsread(filename,sheet);

perceived = dataTable.Perceived==1;
data_perceived = dataTable(perceived,3:6);
data_notperceived = dataTable(~perceived,3:6);

%% t-tests
sigAlpha = 0.05/4;
for i=1:4
    p1(i) = ranksum(data_perceived{:,i},data_notperceived{:,i});
    [~,p2(i)] = ttest2(data_perceived{:,i},data_notperceived{:,i});
end
p1>sigAlpha
p2>sigAlpha

names = {'AnkleESAvg','KneeESAvg','HipESAvg','COPxESAvg'};
figure;
for i=1:4
    subplot(1,4,i)
    boxplot(dataTable.(names{i}),perceived,'notch','on','outliersize',2,'ColorGroup',perceived)
    title({names{i},'p = ' num2str(round(p1(i),3))})
    ylim([0 7])
end



%% generlized mixed effets model

ankle = fitglme(dataTable, ...
    'Perceived ~ 1 + AnkleESAvg + (1 + AnkleESAvg|SubjectNum)',...
    'Distribution','Binomial','Link','logit');

knee = fitglme(dataTable, ...
    'Perceived ~ 1 + KneeESAvg + (1 + KneeESAvg|SubjectNum)',...
    'Distribution','Binomial','Link','logit');

hip = fitglme(dataTable, ...
    'Perceived ~ 1 + HipESAvg + (1 + HipESAvg|SubjectNum)',...
    'Distribution','Binomial','Link','logit');

cop = fitglme(dataTable, ...
    'Perceived ~ 1 + COPxESAvg + (1 + COPxESAvg|SubjectNum)',...
    'Distribution','Binomial','Link','logit');

figure
hold on
line([1 1],[0 5],'linestyle','--','color','k')
temp = ankle.coefCI;
temp2 = ankle.fixedEffects;
line([exp(temp(2,1)) exp(temp(2,2))],[1 1],'linewidth',10,'color',[0.7 0.7 0.7])
plot(exp(temp2(2)),1,'.','MarkerSize',30,'color','k')
temp = knee.coefCI;
temp2 = knee.fixedEffects;
line([exp(temp(2,1)) exp(temp(2,2))],[2 2],'linewidth',10,'color',[0.7 0.7 0.7])
plot(exp(temp2(2)),2,'.','MarkerSize',30,'color','k')
temp = hip.coefCI;
temp2 = hip.fixedEffects;
line([exp(temp(2,1)) exp(temp(2,2))],[3 3],'linewidth',10,'color',[0.7 0.7 0.7])
plot(exp(temp2(2)),3,'.','MarkerSize',30,'color','k')
temp = cop.coefCI;
temp2 = cop.fixedEffects;
line([exp(temp(2,1)) exp(temp(2,2))],[4 4],'linewidth',10,'color',[0.7 0.7 0.7])
plot(exp(temp2(2)),4,'.','MarkerSize',30,'color','k')
set(gca,'YTick',[1 2 3 4],'YTickLabel',{'Ankle','Knee','Hip','COPx'},'YLim',[0.5 4.5])
title('Odds Ratios')


%% generlized mixed effets model - linear

ankle = fitglme(dataTable, ...
    'AnkleESAvg ~ 1 + Perceived + (1 + Perceived|SubjectNum)');
pLME1(1) = ankle.coefTest; % grabs the p-value for coefficient of the variable
temp = ankle.coefCI;
coeffCI1(1,:) = temp(2,:);

knee = fitglme(dataTable, ...
    'KneeESAvg ~ 1 + Perceived + (1 + Perceived|SubjectNum)');
pLME1(2) = knee.coefTest; % grabs the p-value for coefficient of the variable
temp = knee.coefCI;
coeffCI1(2,:) = temp(2,:);

hip = fitglme(dataTable, ...
    'HipESAvg ~ 1 + Perceived + (1 + Perceived|SubjectNum)');
pLME1(3) = hip.coefTest; % grabs the p-value for coefficient of the variable
temp = hip.coefCI;
coeffCI1(3,:) = temp(2,:);

cop = fitglme(dataTable, ...
    'COPxESAvg ~ 1 + Perceived + (1 + Perceived|SubjectNum)');
pLME1(4) = hip.coefTest; % grabs the p-value for coefficient of the variable
temp = hip.coefCI;
coeffCI1(4,:) = temp(2,:);

pLME1
coeffCI1

% what happens if you do this with no random effects? (e.g., kinda like the
% t-test)

ankle2 = fitglme(dataTable, ...
    'AnkleESAvg ~ 1 + Perceived');
pLME2(1) = ankle2.coefTest; % grabs the p-value for coefficient of the variable
temp = ankle2.coefCI;
coeffCI2(1,:) = temp(2,:);

knee2 = fitglme(dataTable, ...
    'KneeESAvg ~ 1 + Perceived');
pLME2(2) = knee2.coefTest; % grabs the p-value for coefficient of the variable
temp = knee2.coefCI;
coeffCI2(2,:) = temp(2,:);

hip2 = fitglme(dataTable, ...
    'HipESAvg ~ 1 + Perceived');
pLME2(3) = hip2.coefTest; % grabs the p-value for coefficient of the variable
temp = hip2.coefCI;
coeffCI2(3,:) = temp(2,:);

cop2 = fitglme(dataTable, ...
    'COPxESAvg ~ 1 + Perceived');
pLME2(4) = cop2.coefTest; % grabs the p-value for coefficient of the variable
temp = cop2.coefCI;
coeffCI2(4,:) = temp(2,:);

pLME2
coeffCI2




