% filename = '/Users/jla0024/Documents/Research/Conferences/2021 - ASB/Dan/DataFormatForStats.xlsx';
% filename = 'D:\Github\Perception-Project\Dan\Data Processing and Analysis\ASB_2021 Analysis\Stats Files\DataFormatForStats.xlsx';
% D is on the laptop E drive for the work computer
filename = 'C:\Github\Perception-Project\Dan\Data Processing and Analysis\WholeVsLocal\DataFormatForStats_WholeVLocal.xlsx';
% sheet = 'Whole Avg ES Late Stance'; % Whole Avg ES Full GC
sheet = 'Whole Avg ES Full GC';
% sheet2 = 'Local Avg ES Late Stance'; % Local Avg ES Full GC
sheet2 = 'Local Avg ES Full GC';


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


%% Whole body plots 

cd('G:\My Drive\Graduate Studies\Research\Dissertation\Final\Aim2');
pW = [0.04660, 0.06340, 0.00828, 0.049850, 0.009450, 0.060000, 0.005360, 0.004752, 0.060000, 0.151000, 0.016200, 0.143600];

names = {'WBAMFront','WBAMTrans','WBAMSag','CoMPosx','CoMPosy','CoMPosz', 'CoMVelx', 'CoMVely', 'CoMVelz', 'CoMAccx', 'CoMAccy', 'CoMAccz'};
% names2 = {'WBAMFront','WBAMTrans','WBAMSag','MoSAP', 'MoSML'};
h1 = figure('Name', 'WBAM Plot Comparison PvNP');
for i=1:3
    subplot(1,3,i)
    W1{:,1} = data_notperceivedW.(names{i});
    W1{:,2} = data_perceivedW.(names{i});
    violin(W1, 'xlabel', {'Not Perceived'; ...
        'Perceived'}, 'facecolor', [0.6350 0.0780 0.1840; 0 0.4470 0.7410]);    
    if pW(i) < 0.05
        title({names{i},'p = ' num2str(round(pW(i),3)) '*'})
    else
        title({names{i},'p = ' num2str(round(pW(i),3))})
    end
    ylim([0 12]);
    xticklabels({'Not Perceived'; 'Perceived'});

    swarmchart(ones(1,length(data_notperceivedW.(names{i}))), data_notperceivedW.(names{i}), 36, [110/255 98/255 89/255]);
    hold on; 
    swarmchart(2*ones(1, length(data_perceivedW.(names{i}))), data_perceivedW.(names{i}), 36, [110/255 98/255 89/255]);
    clear W1
end
filename2 = 'WBAM Plot Comparison';
filenamePDF2 = strcat(filename2, '.pdf');
saveas(h1, filename2);
print(filenamePDF2, '-dpdf', '-bestfit');

clear filename2 filenamePDF2


h2 = figure('Name', 'CoM Plot Comparison 1');
for i=4:6
    subplot(1,3,i-3)
    W1{:,1} = data_notperceivedW.(names{i});
    W1{:,2} = data_perceivedW.(names{i});
    violin(W1, 'xlabel', {'Not Perceived'; ...
        'Perceived'}, 'facecolor', [0.6350 0.0780 0.1840; 0 0.4470 0.7410]);    
    if pW(i) < 0.05
        title({names{i},'p = ' num2str(round(pW(i),3)) '*'})
    else
        title({names{i},'p = ' num2str(round(pW(i),3))})
    end
    ylim([0 12]);
    xticklabels({'Not Perceived'; 'Perceived'});
    swarmchart(ones(1,length(data_notperceivedW.(names{i}))), data_notperceivedW.(names{i}), 36, [110/255 98/255 89/255]);
    hold on; 
    swarmchart(2*ones(1, length(data_perceivedW.(names{i}))), data_perceivedW.(names{i}), 36, [110/255 98/255 89/255]);
    clear W1
end
filename2 = 'CoM Plot Comparison 1';
filenamePDF2 = strcat(filename2, '.pdf');
saveas(h2, filename2);
print(filenamePDF2, '-dpdf', '-bestfit');


clear filename2 filenamePDF2


h3 = figure('Name', 'CoM Plot Comparison 2');
for i=7:9
    subplot(1,3,i-6)
    W1{:,1} = data_notperceivedW.(names{i});
    W1{:,2} = data_perceivedW.(names{i});
    violin(W1, 'xlabel', {'Not Perceived'; ...
        'Perceived'}, 'facecolor', [0.6350 0.0780 0.1840; 0 0.4470 0.7410]);    
    if pW(i) < 0.05
        title({names{i},'p = ' num2str(round(pW(i),3)) '*'})
    else
        title({names{i},'p = ' num2str(round(pW(i),3))})
    end
    ylim([0 12]);
    xticklabels({'Not Perceived'; 'Perceived'});
    swarmchart(ones(1,length(data_notperceivedW.(names{i}))), data_notperceivedW.(names{i}), 36, [110/255 98/255 89/255]);
    hold on; 
    swarmchart(2*ones(1, length(data_perceivedW.(names{i}))), data_perceivedW.(names{i}), 36, [110/255 98/255 89/255]);
    clear W1
end

filename2 = 'CoM Plot Comparison 2';
filenamePDF2 = strcat(filename2, '.pdf');
saveas(h3, filename2);
print(filenamePDF2, '-dpdf', '-bestfit');


clear filename2 filenamePDF2

h4 = figure('Name', 'CoM Plot Comparison 3');
for i=10:12
    subplot(1,3,i-9)
    W1{:,1} = data_notperceivedW.(names{i});
    W1{:,2} = data_perceivedW.(names{i});
    violin(W1, 'xlabel', {'Not Perceived'; ...
        'Perceived'}, 'facecolor', [0.6350 0.0780 0.1840; 0 0.4470 0.7410]);    
    if pW(i) < 0.05
        title({names{i},'p = ' num2str(round(pW(i),3)) '*'})
    else
        title({names{i},'p = ' num2str(round(pW(i),3))})
    end
    ylim([0 12]);
    xticklabels({'Not Perceived'; 'Perceived'});
    swarmchart(ones(1,length(data_notperceivedW.(names{i}))), data_notperceivedW.(names{i}), 36, [110/255 98/255 89/255]);
    hold on; 
    swarmchart(2*ones(1, length(data_perceivedW.(names{i}))), data_perceivedW.(names{i}), 36, [110/255 98/255 89/255]);
    clear W1
end

filename2 = 'CoM Plot Comparison 3';
filenamePDF2 = strcat(filename2, '.pdf');
saveas(h4, filename2);
print(filenamePDF2, '-dpdf', '-bestfit');


clear filename2 filenamePDF2
%% Local Sensory Plots 

pL = [0.0004354, 0.0455400, 0.0855000, 1.0000000, 1.0000000, 1.0000000, 1.0000000];
namesL = data_perceivedL.Properties.VariableNames; 
h1 = figure('Name', 'Local Sensory Feedback 1');
axis equal;
for i=1:3
    subplot(1,3,i)
    Y1{:,1} = data_notperceivedL.(namesL{i});
    Y1{:,2} = data_perceivedL.(namesL{i});
    violin(Y1, 'xlabel', {'Not Perceived'; ...
        'Perceived'}, 'facecolor', [0.6350 0.0780 0.1840; 0 0.4470 0.7410]);
    if pL(i) < 0.05
        title({namesL{i},'p = ' num2str(round(pL(i),3)) '*'})
    else
        title({namesL{i},'p = ' num2str(round(pL(i),3))})
    end
    ylim([0 12]);
    xticklabels({'Not Perceived'; 'Perceived'});
    swarmchart(ones(1,length(data_notperceivedL.(namesL{i}))), data_notperceivedL.(namesL{i}), 36, [110/255 98/255 89/255]);
    hold on; 
    swarmchart(2*ones(1, length(data_perceivedL.(namesL{i}))), data_perceivedL.(namesL{i}), 36, [110/255 98/255 89/255]);
    clear Y1
end
filename2 = 'Local Sensory Feedback 1';
filenamePDF2 = strcat(filename2, '.pdf');
saveas(h1, filename2);
print(filenamePDF2, '-dpdf', '-bestfit');


clear filename2 filenamePDF2

h2 = figure('Name', 'Local Sensory Feedback 2');
axis equal;
for i=4:7
    subplot(1,4,i-3)
    Y1{:,1} = data_notperceivedL.(namesL{i});
    Y1{:,2} = data_perceivedL.(namesL{i});
    violin(Y1, 'xlabel', {'Not Perceived'; ...
        'Perceived'}, 'facecolor', [0.6350 0.0780 0.1840; 0 0.4470 0.7410]);
    if pL(i) < 0.05
        title({namesL{i},'p = ' num2str(round(pL(i),3)) '*'})
    else
        title({namesL{i},'p = ' num2str(round(pL(i),3))})
    end
    ylim([0 12]);
    xticklabels({'Not Perceived'; 'Perceived'});
    swarmchart(ones(1,length(data_notperceivedL.(namesL{i}))), data_notperceivedL.(namesL{i}), 36, [110/255 98/255 89/255]);
    hold on; 
    swarmchart(2*ones(1, length(data_perceivedL.(namesL{i}))), data_perceivedL.(namesL{i}), 36, [110/255 98/255 89/255]);
    clear Y1
end
filename2 = 'Local Sensory Feedback 2';
filenamePDF2 = strcat(filename2, '.pdf');
saveas(h2, filename2);
print(filenamePDF2, '-dpdf', '-bestfit');


clear filename2 filenamePDF2



%% generlized mixed effets model
WBAMFront = fitglme(dataTable, ...
    'Perceived ~ 1 + WBAMFront + (1 + WBAMFront|SubjectNum)',...
    'Distribution','Binomial','Link','logit');

WBAMSag = fitglme(dataTable, ...
    'Perceived ~ 1 + WBAMSag + (1 + WBAMSag|SubjectNum)',...
    'Distribution','Binomial','Link','logit');

CoMPosx = fitglme(dataTable, ...
    'Perceived ~ 1 + CoMPosx + (1 + CoMPosx|SubjectNum)',...
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

Knee = fitglme(dataTable2, ...
    'Perceived ~ 1 + Knee + (1+ Knee|SubjectNum)',...
    'Distribution','Binomial','Link','logit');


h1 = figure('Name', 'Odds Ratio');
hold on
line([1 1],[0 10],'linestyle','--','color','k')
temp = WBAMFront.coefCI;
temp2 = WBAMFront.fixedEffects;
line([exp(temp(2,1)) exp(temp(2,2))],[1 1],'linewidth',10,'color',[0.7 0.7 0.7])
plot(exp(temp2(2)),1,'.','MarkerSize',30,'color','k')
temp = WBAMSag.coefCI;
temp2 = WBAMSag.fixedEffects;
line([exp(temp(2,1)) exp(temp(2,2))],[2 2],'linewidth',10,'color',[0.7 0.7 0.7])
plot(exp(temp2(2)),2,'.','MarkerSize',30,'color','k')
temp = CoMPosx.coefCI;
temp2 = CoMPosx.fixedEffects;
line([exp(temp(2,1)) exp(temp(2,2))],[3 3],'linewidth',10,'color',[0.7 0.7 0.7])
plot(exp(temp2(2)),3,'.','MarkerSize',30,'color','k')
temp = CoMPosy.coefCI;
temp2 = CoMPosy.fixedEffects;
line([exp(temp(2,1)) exp(temp(2,2))],[4 4],'linewidth',10,'color',[0.7 0.7 0.7])
plot(exp(temp2(2)),4,'.','MarkerSize',30,'color','k')
temp = CoMVelx.coefCI;
temp2 = CoMVelx.fixedEffects;
line([exp(temp(2,1)) exp(temp(2,2))],[5 5],'linewidth',10,'color',[0.7 0.7 0.7])
plot(exp(temp2(2)),5,'.','MarkerSize',30,'color','k')
temp = CoMVely.coefCI;
temp2 = CoMVely.fixedEffects;
line([exp(temp(2,1)) exp(temp(2,2))],[6 6],'linewidth',10,'color',[0.7 0.7 0.7])
plot(exp(temp2(2)),6,'.','MarkerSize',30,'color','k')
temp = CoMAccy.coefCI;
temp2 = CoMAccy.fixedEffects;
line([exp(temp(2,1)) exp(temp(2,2))],[7 7],'linewidth',10,'color',[0.7 0.7 0.7])
plot(exp(temp2(2)),7,'.','MarkerSize',30,'color','k')
temp = Ankle.coefCI;
temp2 = Ankle.fixedEffects;
line([exp(temp(2,1)) exp(temp(2,2))],[8 8],'linewidth',10,'color',[0.7 0.7 0.7])
plot(exp(temp2(2)),8,'.','MarkerSize',30,'color','k')
temp = Knee.coefCI;
temp2 = Knee.fixedEffects;
line([exp(temp(2,1)) exp(temp(2,2))],[9 9],'linewidth',10,'color',[0.7 0.7 0.7])
plot(exp(temp2(2)),9,'.','MarkerSize',30,'color','k')
set(gca,'YTick',[1 2 3 4 5 6 7 8 9],'YTickLabel',{'WBAMFront','WBAMSag',...
    'CoMPosAP','CoMPosML', 'CoMVelAP', 'CoMVelML', 'CoMAccML', 'Ankle', 'Knee'},'YLim',[0.5 9.5])
title('Odds Ratios')
xlim([0 4])




filename2 = 'Odds Ratio';
filenamePDF2 = strcat(filename2, '.pdf');
saveas(h1, filename2);
print(filenamePDF2, '-dpdf', '-bestfit');



