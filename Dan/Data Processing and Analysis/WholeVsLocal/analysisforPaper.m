% filename = '/Users/jla0024/Documents/Research/Conferences/2021 - ASB/Dan/DataFormatForStats.xlsx';
% filename = 'D:\Github\Perception-Project\Dan\Data Processing and Analysis\ASB_2021 Analysis\Stats Files\DataFormatForStats.xlsx';
% D is on the laptop E drive for the work computer
filename = 'C:\Github\Perception-Project\Dan\Data Processing and Analysis\WholeVsLocal\DataFormatForStats_WholeVLocal.xlsx';
% sheet = 'Whole Avg ES Late Stance'; % Whole Avg ES Full GC
sheet = 'Whole Avg ES Late Stance';
% sheet2 = 'Local Avg ES Late Stance'; % Local Avg ES Full GC
sheet2 = 'Local Avg ES Late Stance';


% create table for Whole
dataTable = readtable(filename,'Sheet',sheet);

% create table for Local
dataTable2 = readtable(filename, 'Sheet', sheet2);

% number of percieved perturbations per subject
for i=1:15
    numPerceived(i) = sum(dataTable.Perceived(dataTable.SubjectNum==i));
    numPerceived2(i) = sum(dataTable2.Perceived(dataTable2.SubjectNum==i));
end
% [data, columnNames] = xlsread(filename,sheet);

perceivedW = dataTable.Perceived==1;
data_perceivedW = dataTable(perceivedW,3:14);
data_notperceivedW = dataTable(~perceivedW,3:14);

perceivedL = dataTable2.Perceived==1;
data_perceivedL = dataTable2(perceivedL,3:9);
data_notperceivedL = dataTable2(~perceivedL,3:9);

%% Doing the SSWS to Perception threshold analysis
Temp = [1.25	0.0958
1.25	0.0547
1.15	0.0547
1.2	0.0878
1.15	0.086
1.05	0.0421
1.1	0.1061
1	0.0547
0.95	0.068
1.25	0.1
1	0.1278
1.2	0.0494
1.2	0.0749
1.3	0.0759
1.05	0.115]; 

[r, p] = corr(Temp)


%% Running kruskal wallis tests and Tukeys post hoc tests 
x = table2array(dataTable(:,3:14));
y = table2array(dataTable2(:,3:9));
group2 = dataTable2.Perceived;
group = dataTable.Perceived;


for i = 1:size(x,2)
    [p2, WTable, Wstats] = ranksum(x(group==1,i), x(group==0, i));
    pW(i) = p2;
end

for j = 1:size(y,2)
    [p,~, ~] = ranksum(y(group2==1,j), y(group2==0,j));
    pL(j) = p;
end
% names = fieldnames(dataTable(:,3:14));
% names2 = names(1:12);
% 
% names3 = fieldnames(dataTable2(:,3:9));
% names4 = names3(1:7);
% 
% for i = 1:9 
%     alpha(i) = 0.05/(9+1-i);
% end
% alphaidx = [4;5; 6; 2; 1; 3; 8; 9; 7;];
% for i = 1:3
%     alphaWBAM(i) = 0.05/(3+1-i);
% end
% alphaWBAMidx = [3; 1; 2;]; 
% 
% for i = 1:size(y,2)
%     alpha2(i) = 0.05/(7+1-i);
% end
% alpha2idx = [1; 5; 2; 4; 3; 6; 7];
% clear i 
% 
% for i = 1:size(x,2)
%     [p2, WTable, Wstats] = kruskalwallis(x(:,i), group, 'off');
% %     [p2, W2Table, W2stats] = ranksum(x(group==1,i), x(group==0,i));
%     pW2(i) = p2;
% %     pW(i) = p1;
%     
% 
% %     % Setting stuff up for the Dunn Tests
% %     np = data_notperceivedW(:,i);
% %     p = data_perceivedW(:,i); 
% %     tot = [np;p];
% %     tot = table2array(tot);
% %     tot = tot';
% %     g = [ones(1, size(np,1)), repmat(2,1,size(p,1))];
% %     fprintf(['Dunn Comparison Test Results for ' names2{i} '\n'])
% %     dunn(tot, g)
% %     
%     
%     if i <= 3
%         figure;
%         c = multcompare(Wstats, 'ctype', 'dunn-sidak');
%         title(names2{i});
%         compareW.(names2{i}) = c;
%     else
%         figure;
%         c = multcompare(Wstats, 'ctype', 'dunn-sidak');
%         title(names2{i});
%         compareW.(names2{i}) = c;
%     end
% %         
%     clear p1 WTable Wstats c tot np p g
% end
%%
% for j = 1:size(y,2)
% %     [p2, LTable, Lstats] = kruskalwallis(y(:,j), group2, 'off');
%     [p3, W2Table, W2stats] = ranksum(y(group2==1,j), y(group2==0,j));
%     pL(j) = p3;
% %     
% % Setting stuff up for the Dunn Tests
%     if j < 4
%         np = data_notperceivedL(:,j);
%         p = data_perceivedL(:,j); 
%         tot = [np;p];
%         tot = table2array(tot);
%         tot = tot';
%         g = [ones(1, size(np,1)), repmat(2,1,size(p,1))];
%         fprintf(['Dunn Comparison Test Results for ' names4{j} '\n'])
%         dunn(tot, g)
%     elseif j > 5 
%         np = data_notperceivedL(:,j);
%         p = data_perceivedL(:,j); 
%         tot = [np;p];
%         tot = table2array(tot);
%         tot = tot';
%         g = [ones(1, size(np,1)), repmat(2,1,size(p,1))];
%         fprintf(['Dunn Comparison Test Results for ' names4{j} '\n'])
%         dunn(tot, g)
%     end
% 
% %     figure; 
% %     
% %     c2 = multcompare(Lstats, 'ctype', 'tukey-kramer', 'Alpha', alpha2(1));
% %     title(names4{j});
% %     compareL.(names4{j}) = c2; 
% %     
%     clear p2 c2 LTable Lstats tot np p g
% end



%% t-tests
% sigAlpha = 0.05/3;
% for i=1:12
%     pW(i) = ranksum(data_perceivedW{:,i},data_notperceivedW{:,i});
% %     [~,p2(i)] = ttest2(data_perceived{:,i},data_notperceived{:,i});
%     if i <= 3
%         sigAlphaWBAM(i) = 0.05/(3-i+1);
%     end
% end
% 
% pWBAM = pW(1:3); 
% pCoM = pW(4:end);
% 
% for i = 1:7 
%     pL(i) = ranksum(data_perceivedL{:,i},data_notperceivedL{:,i});
% end
% 
% 
% 
% keyboard
% for j = 1:9
%     sigAlphaCoM(j) = 0.05/(9-j+1);
%     pCoM(j) = p1(3+j);
% end

% p1>sigAlpha
% p2>sigAlpha

names = {'WBAMFront','WBAMTrans','WBAMSag','CoMPosx','CoMPosy','CoMPosz', 'CoMVelx', 'CoMVely', 'CoMVelz', 'CoMAccx', 'CoMAccy', 'CoMAccz'};
% names2 = {'WBAMFront','WBAMTrans','WBAMSag','MoSAP', 'MoSML'};
figure;
for i=1:3
    subplot(1,3,i)
    boxplot(dataTable.(names{i}),perceivedW,'notch','on','outliersize',5,'ColorGroup',perceivedW)
    title({names{i},'p = ' num2str(round(pW(i),3))})
    ylim([0 7])
end

figure;
for i=4:8
    subplot(1,5,i-3)
    boxplot(dataTable.(names{i}),perceivedW,'notch','on','outliersize',2,'ColorGroup',perceivedW)
    title({names{i},'p = ' num2str(round(pW(i),3))})
    ylim([0 7])
end

figure;
for i=9:12
    subplot(1,4,i-8)
    boxplot(dataTable.(names{i}),perceivedW,'notch','on','outliersize',2,'ColorGroup',perceivedW)
    title({names{i},'p = ' num2str(round(pW(i),3))})
    ylim([0 7])
end
%% Local Sensory Plots 
namesL = data_perceivedL.Properties.VariableNames; 
figure;
for i=1:3
    subplot(1,3,i)
    swarmchart(ones(1,length(data_notperceivedL.(namesL{i}))), data_notperceivedL.(namesL{i}), 'filled' )
    hold on; 
    swarmchart(2*ones(1, length(data_perceivedL.(namesL{i}))), data_perceivedL.(namesL{i}), 'filled');
%     
%     boxplot(dataTable2.(names4{i}),perceivedL,'notch','on','outliersize',5,'ColorGroup',perceivedL)
    title({namesL{i}});
    ylim([0 8]);
    xticklabels({'Not Perceived'; ' '; 'Perceived'});
end


%% Violin Plots 
namesL = data_perceivedL.Properties.VariableNames; 
figure;
for i=1:3
    subplot(1,3,i)
    Y1{:,1} = data_notperceivedL.(namesL{i});
    Y1{:,2} = data_perceivedL.(namesL{i});
    violin(Y1, 'xlabel', {'Not Perceived'; ...
        'Perceived'});
%     
%     boxplot(dataTable2.(names4{i}),perceivedL,'notch','on','outliersize',5,'ColorGroup',perceivedL)
    title({namesL{i}});
    ylim([0 8]);
    xticklabels({'Not Perceived'; 'Perceived'});
end

%% 
figure;
for i=4:7
    subplot(1,4,i-3)
    boxplot(dataTable2.(names4{i}),perceivedL,'notch','on','outliersize',2,'ColorGroup',perceivedL)
    title({names4{i},'p = ' num2str(round(pL(i),3))})
    ylim([0 7])
end


%% generlized mixed effects model 
% 
% 
% Ankle = fitglme(dataTable2, ...
%     'Perceived ~ 1 + Ankle + (1+ Ankle|SubjectNum)',...
%     'Distribution','Binomial','Link','logit');
% 
% Knee = fitglme(dataTable2, ...
%     'Perceived ~ 1 + Knee + (1+ Knee|SubjectNum)',...
%     'Distribution','Binomial','Link','logit');
% 
% Hip = fitglme(dataTable2, ...
%     'Perceived ~ 1 + Hip + (1+ Hip|SubjectNum)',...
%     'Distribution','Binomial','Link','logit');
% 
% COPx = fitglme(dataTable2, ....
%     'Perceived ~ 1 + COPx + (1+ COPx|SubjectNum)',...
%     'Distribution','Binomial','Link','logit');
% 
% 
% 
% figure
% hold on
% line([1 1],[0 9],'linestyle','--','color','k')
% temp = Ankle.coefCI;
% temp2 = Ankle.fixedEffects;
% line([exp(temp(2,1)) exp(temp(2,2))],[1 1],'linewidth',10,'color',[0.7 0.7 0.7])
% plot(exp(temp2(2)),1,'.','MarkerSize',30,'color','k')
% temp = Knee.coefCI;
% temp2 = Knee.fixedEffects;
% line([exp(temp(2,1)) exp(temp(2,2))],[2 2],'linewidth',10,'color',[0.7 0.7 0.7])
% plot(exp(temp2(2)),2,'.','MarkerSize',30,'color','k')
% temp = Hip.coefCI;
% temp2 = Hip.fixedEffects;
% line([exp(temp(2,1)) exp(temp(2,2))],[3 3],'linewidth',10,'color',[0.7 0.7 0.7])
% plot(exp(temp2(2)),3,'.','MarkerSize',30,'color','k')
% temp = COPx.coefCI;
% temp2 = COPx.fixedEffects;
% line([exp(temp(2,1)) exp(temp(2,2))],[4 4],'linewidth',10,'color',[0.7 0.7 0.7])
% plot(exp(temp2(2)),4,'.','MarkerSize',30,'color','k')
% set(gca,'YTick',[1 2 3 4],'YTickLabel',{'Ankle', 'Knee', 'Hip', 'CoPx',},'YLim',[0.5 4.5])
% title('Odds Ratios')
% xlim([0 3])

%% generlized mixed effets model


WBAMSag = fitglme(dataTable, ...
    'Perceived ~ 1 + WBAMSag + (1 + WBAMSag|SubjectNum)',...
    'Distribution','Binomial','Link','logit');

CoMPosy = fitglme(dataTable, ...
    'Perceived ~ 1 + CoMPosy + (1 + CoMPosy|SubjectNum)',...
    'Distribution','Binomial','Link','logit');

CoMVelx = fitglme(dataTable, ...
    'Perceived ~ 1 + CoMVelx + (1 + CoMVelx|SubjectNum)',...
    'Distribution','Binomial','Link','logit');

CoMVely = fitglme(dataTable, ...
    'Perceived ~ 1 + CoMVely + (1 + CoMVely|SubjectNum)',...
    'Distribution','Binomial','Link','logit');

CoMAccy = fitglme(dataTable, ...
    'Perceived ~ 1 + CoMAccy + (1 + CoMAccy|SubjectNum)',...
    'Distribution','Binomial','Link','logit');

Ankle = fitglme(dataTable2, ...
    'Perceived ~ 1 + Ankle + (1+ Ankle|SubjectNum)',...
    'Distribution','Binomial','Link','logit');



figure
hold on
line([1 1],[0 9],'linestyle','--','color','k')
temp = WBAMSag.coefCI;
temp2 = WBAMSag.fixedEffects;
line([exp(temp(2,1)) exp(temp(2,2))],[1 1],'linewidth',10,'color',[0.7 0.7 0.7])
plot(exp(temp2(2)),1,'.','MarkerSize',30,'color','k')
temp = CoMPosy.coefCI;
temp2 = CoMPosy.fixedEffects;
line([exp(temp(2,1)) exp(temp(2,2))],[2 2],'linewidth',10,'color',[0.7 0.7 0.7])
plot(exp(temp2(2)),2,'.','MarkerSize',30,'color','k')
temp = CoMVelx.coefCI;
temp2 = CoMVelx.fixedEffects;
line([exp(temp(2,1)) exp(temp(2,2))],[3 3],'linewidth',10,'color',[0.7 0.7 0.7])
plot(exp(temp2(2)),3,'.','MarkerSize',30,'color','k')
temp = CoMVely.coefCI;
temp2 = CoMVely.fixedEffects;
line([exp(temp(2,1)) exp(temp(2,2))],[4 4],'linewidth',10,'color',[0.7 0.7 0.7])
plot(exp(temp2(2)),4,'.','MarkerSize',30,'color','k')
temp = CoMAccy.coefCI;
temp2 = CoMAccy.fixedEffects;
line([exp(temp(2,1)) exp(temp(2,2))],[5 5],'linewidth',10,'color',[0.7 0.7 0.7])
plot(exp(temp2(2)),5,'.','MarkerSize',30,'color','k')
temp = Ankle.coefCI;
temp2 = Ankle.fixedEffects;
line([exp(temp(2,1)) exp(temp(2,2))],[6 6],'linewidth',10,'color',[0.7 0.7 0.7])
plot(exp(temp2(2)),6,'.','MarkerSize',30,'color','k')
set(gca,'YTick',[1 2 3 4 5 6],'YTickLabel',{'WBAMSag', 'CoMPosML', 'CoMVelAP', 'CoMVelML', 'CoMAccML', 'Ankle'},'YLim',[0.5 6.5])
title('Odds Ratios')
xlim([0 4])








