% filename = '/Users/jla0024/Documents/Research/Conferences/2021 - ASB/Dan/DataFormatForStats.xlsx';
% filename = 'D:\Github\Perception-Project\Dan\Data Processing and Analysis\ASB_2021 Analysis\Stats Files\DataFormatForStats.xlsx';
% D is on the laptop E drive for the work computer
filename = 'D:\Github\Perception-Project\Dan\Data Processing and Analysis\ASB_2021 Analysis\Stats Files\DataFormatForStats_NACOB_DJL2.xlsx';
sheet = 'Avg GC ES';

% Sheet names 'Avg Stance ES' 'Avg Stance ES 10 sub' 'Avg Swing ES' 
% 'Avg Swing ES 10 sub' 'Avg GC ES' 'Avg GC ES 10 sub'

% create table 
dataTable = readtable(filename,'Sheet',sheet);

% number of percieved perturbations per subject
for i=1:11
    numPerceived(i) = sum(dataTable.Perceived(dataTable.SubjectNum==i));
end
% [data, columnNames] = xlsread(filename,sheet);

perceived = dataTable.Perceived==1;
data_perceived = dataTable(perceived,3:11);
data_notperceived = dataTable(~perceived,3:11);

%% t-tests
sigAlpha = 0.05/3;
for i=1:3
    p1(i) = ranksum(data_perceived{:,i},data_notperceived{:,i});
    [~,p2(i)] = ttest2(data_perceived{:,i},data_notperceived{:,i});
end
p1>sigAlpha
p2>sigAlpha

names = {'WBAMFront','WBAMTrans','WBAMSag',}; %'CoMPosx','CoMPosy','CoMPosz', 'CoMVelx', 'CoMVely', 'CoMVelz', 'MoSAP', 'MoSML'};
% names2 = {'WBAMFront','WBAMTrans','WBAMSag','MoSAP', 'MoSML'};
figure;
for i=1:3
    subplot(1,3,i)
    boxplot(dataTable.(names{i}),perceived,'notch','on','outliersize',5,'ColorGroup',perceived)
%     title({names{i},'p = ' num2str(round(p1(i),3))})
    ylim([0 8])
end

% figure;
% for i=5:9
%     subplot(1,5,i-4)
%     boxplot(dataTable.(names{i}),perceived,'notch','on','outliersize',2,'ColorGroup',perceived)
%     title({names{i},'p = ' num2str(round(p1(i),3))})
% %     ylim([0 7])
% end

% figure;
% for i=9:11
%     subplot(1,4,i-8)
%     boxplot(dataTable.(names{i}),perceived,'notch','on','outliersize',2,'ColorGroup',perceived)
%     title({names{i},'p = ' num2str(round(p1(i),3))})
% %     ylim([0 7])
% end


%% generlized mixed effets model

WBAMFront = fitglme(dataTable, ...
    'Perceived ~ 1 + WBAMFront + (1 + WBAMFront|SubjectNum)',...
    'Distribution','Binomial','Link','logit');

WBAMTrans = fitglme(dataTable, ...
    'Perceived ~ 1 + WBAMTrans + (1 + WBAMTrans|SubjectNum)',...
    'Distribution','Binomial','Link','logit');

WBAMSag = fitglme(dataTable, ...
    'Perceived ~ 1 + WBAMSag + (1 + WBAMSag|SubjectNum)',...
    'Distribution','Binomial','Link','logit');

% cop = fitglme(dataTable, ...
%     'Perceived ~ 1 + COPxESAvg + (1 + COPxESAvg|SubjectNum)',...
%     'Distribution','Binomial','Link','logit');

figure
hold on
line([1 1],[0 5],'linestyle','--','color','k')
temp = WBAMFront.coefCI;
temp2 = WBAMFront.fixedEffects;
line([exp(temp(2,1)) exp(temp(2,2))],[1 1],'linewidth',10,'color',[0.7 0.7 0.7])
plot(exp(temp2(2)),1,'.','MarkerSize',30,'color','k')
temp = WBAMTrans.coefCI;
temp2 = WBAMTrans.fixedEffects;
line([exp(temp(2,1)) exp(temp(2,2))],[2 2],'linewidth',10,'color',[0.7 0.7 0.7])
plot(exp(temp2(2)),2,'.','MarkerSize',30,'color','k')
temp = WBAMSag.coefCI;
temp2 = WBAMSag.fixedEffects;
line([exp(temp(2,1)) exp(temp(2,2))],[3 3],'linewidth',10,'color',[0.7 0.7 0.7])
plot(exp(temp2(2)),3,'.','MarkerSize',30,'color','k')
% temp = cop.coefCI;
% temp2 = cop.fixedEffects;
% line([exp(temp(2,1)) exp(temp(2,2))],[4 4],'linewidth',10,'color',[0.7 0.7 0.7])
% plot(exp(temp2(2)),4,'.','MarkerSize',30,'color','k')
set(gca,'YTick',[1 2 3],'YTickLabel',{'WBAMFront','WBAMTrans','WBAMSag'},'YLim',[0.5 4.5])
title('Odds Ratios')
xlim([0 5])


%% generlized mixed effets model - linear

 WBAMFront = fitglme(dataTable, ...
    'AnkleESAvg ~ 1 + Perceived + (1 + Perceived|SubjectNum)');
pLME1(1) = WBAMFront.coefTest; % grabs the p-value for coefficient of the variable
temp = WBAMFront.coefCI;
coeffCI1(1,:) = temp(2,:);

WBAMTrans = fitglme(dataTable, ...
    'KneeESAvg ~ 1 + Perceived + (1 + Perceived|SubjectNum)');
pLME1(2) = WBAMTrans.coefTest; % grabs the p-value for coefficient of the variable
temp = WBAMTrans.coefCI;
coeffCI1(2,:) = temp(2,:);

WBAMSag = fitglme(dataTable, ...
    'HipESAvg ~ 1 + Perceived + (1 + Perceived|SubjectNum)');
pLME1(3) = WBAMSag.coefTest; % grabs the p-value for coefficient of the variable
temp = WBAMSag.coefCI;
coeffCI1(3,:) = temp(2,:);

% cop = fitglme(dataTable, ...
%     'COPxESAvg ~ 1 + Perceived + (1 + Perceived|SubjectNum)');
% pLME1(4) = WBAMSag.coefTest; % grabs the p-value for coefficient of the variable
% temp = WBAMSag.coefCI;
% coeffCI1(4,:) = temp(2,:);

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




