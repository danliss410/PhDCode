%% Setting up the file to run ttests and odds ratio to see if any variable aided in perceiving the disturbances
filename = 'C:\Github\Perception-Project\Dan\USPercep Analysis\Analysis\DataFormatForStats_US.xlsx';
% sheet = 'Whole Avg ES Late Stance'; % Whole Avg ES Full GC
sheet = 'FGC_Slips';
% sheet2 = 'Local Avg ES Late Stance'; % Local Avg ES Full GC
sheet2 = 'FGC_Trips';


% create table for Slips
dataTable = readtable(filename,'Sheet',sheet);

% create table for Trips
dataTable2 = readtable(filename, 'Sheet', sheet2);

% number of percieved perturbations per subject
for i=1:11
    numPerceived(i) = sum(dataTable.Perceived(dataTable.SubjectNum==i));
    numPerceived2(i) = sum(dataTable2.Perceived(dataTable2.SubjectNum==i));
end
% Grabbing the perceived and not perceived slip-like disturbance data
perceivedSlips = dataTable.Perceived==1;
data_perceivedSlips = dataTable(perceivedSlips,2:4);
data_notperceivedSlips = dataTable(~perceivedSlips,2:4);
% Grabbing the perceived and not perceived trip-like disturbance data
perceivedTrips = dataTable2.Perceived==1;
data_perceivedTrips = dataTable2(perceivedTrips,2:4);
data_notperceivedTrips = dataTable2(~perceivedTrips,2:4);

%% Doing the SSWS to Perception threshold analysis
Temp = [0.95, 1, 1, 1, 0.95, 1.05, 0.95, 1.05, 1.1, 1, 1.1]; 
TSlips = [0.06, 0.13, 0.06, 0.11, 0.10, 0.10, 0.03, 0.03, 0.08, 0.06, 0.05];
TTrips = [0.07, 0.09, 0.06, 0.10, 0.09, 0.09, 0.05, 0.05, 0.16, 0.08, 0.04];

[rSlip, pSlip] = corr(Temp', TSlips')
[rTrip, pTrip] = corr(Temp', TTrips')

% No correlation between the SSWS and the slip- or trip-like locomotor
% disturbance threshold across subjects. 


%% Running Rank sum tests
% Putting the data slip-like data into an array for t tests (MG, AT, MTU
% # of SDs)
x = table2array(dataTable(:,2:4));
% Pulling the trip-like data into an array for t tests (MG, AT, MTU # of
% SDs)
y = table2array(dataTable2(:,2:4));
% Grabbing the perceived values for the trip-like data
group2 = dataTable2.Perceived;
% Grabbing the perceived values for slip-like data
group = dataTable.Perceived;


% Performing a rank sum ttest to compare the # of SDs between perceived and
% not perceived perturbations for slip-like MG, AT, and MTU
for i = 1:size(x,2)
    [p2, W2Table, W2stats] = ranksum(x(group==1,i), x(group==0,i));
    pSlips(i) = p2;
    avgSlipsP(i) = mean(x(group==1,i));
    avgSlipsNP(i) = mean(x(group==0,i));
    clear p2
end
% Performing individual rank sum ttests to compare the # of SDs between
% perceived and not perceived perturbations for trip-like MG,AT, and MTU
for j = 1:size(y,2)
    [p3, W2Table, W2stats] = ranksum(y(group2==1,j), y(group2==0,j));
    pTrips(j) = p3;
    avgTripsP(j) = mean(y(group2==1,j));
    avgTripsNP(j) = mean(y(group2==0,j));
    clear p3
end

% Significant difference shown for perceived vs not perceived perturbations
% in a higher MTU length change for trip-like disturbances

%% t-test plots 
% Creating labels to loop through the ttest results and show the data 
names = {'FGC_MGL','FGC_ATL','FGC_MTL',};
% Creating the labels for the top of the plots 
names2 = {'ES MG Len'; 'ES AT Len'; 'ES MTU Len';};

% Slip-like data plot - No significant differences were observed for slow
% down perturbations between perceived and not perceived perturbations 

figure;
axis equal;
for i=1:3
    subplot(1,3,i)
    boxplot(dataTable.(names{i}),perceivedSlips,'notch','on','outliersize',5,'ColorGroup',perceivedSlips)
    title([names2{i},' p = ' num2str(round(pSlips(i),3))])
    ylim([0 8])
end

% Trip-like data plot - Significant increase in MTU length deviation observed for speed up
% perturbations that were perceived vs not perceived. AT length deviation
% was close to being significantly increased for perceived vs not perceived
% but failed comparison by 0.002. 
figure;
axis equal;
for i=1:3
    subplot(1,3,i)
    boxplot(dataTable2.(names{i}),perceivedTrips,'notch','on','outliersize',5,'ColorGroup',perceivedTrips)
    if pTrips(i) < 0.0167
        title({[names2{i} ' p = ' num2str(round(pTrips(i),3)) '**']});
    else
        title([names2{i} ' p = ' num2str(round(pTrips(i),3))]);
    end
    ylim([0 8])
end


%% generlized mixed effets model

% Kept individual models for each of the variables 

Slip_MG_Len = fitglme(dataTable, ...
    'Perceived ~ 1 + FGC_MGL + (1 + FGC_MGL|SubjectNum)',...
    'Distribution','Binomial','Link','logit')

Slip_AT_Len = fitglme(dataTable, ...
    'Perceived ~ 1 + FGC_ATL + (1 + FGC_ATL|SubjectNum)',...
    'Distribution','Binomial','Link','logit')

Slip_MTU_Len = fitglme(dataTable, ...
    'Perceived ~ 1 + FGC_MTL + (1 + FGC_MTL|SubjectNum)',...
    'Distribution','Binomial','Link','logit')

Trip_MG_Len = fitglme(dataTable2, ...
    'Perceived ~ 1 + FGC_MGL + (1 + FGC_MGL|SubjectNum)',...
    'Distribution','Binomial','Link','logit')


Trip_AT_Len = fitglme(dataTable2, ...
    'Perceived ~ 1 + FGC_ATL + (1 + FGC_ATL|SubjectNum)',...
    'Distribution','Binomial','Link','logit')

Trip_MTU_Len = fitglme(dataTable2, ...
    'Perceived ~ 1 + FGC_MTL + (1 + FGC_MTL|SubjectNum)',...
    'Distribution','Binomial','Link','logit')


% Odds ratio plot
figure
hold on
line([1 1],[0 9],'linestyle','--','color','k')
temp = Slip_MG_Len.coefCI;
temp2 = Slip_MG_Len.fixedEffects;
line([exp(temp(2,1)) exp(temp(2,2))],[1 1],'linewidth',10,'color',[0.7 0.7 0.7])
plot(exp(temp2(2)),1,'.','MarkerSize',30,'color','k')
temp = Slip_AT_Len.coefCI;
temp2 = Slip_AT_Len.fixedEffects;
line([exp(temp(2,1)) exp(temp(2,2))],[2 2],'linewidth',10,'color',[0.7 0.7 0.7])
plot(exp(temp2(2)),2,'.','MarkerSize',30,'color','k')
temp = Slip_MTU_Len.coefCI;
temp2 = Slip_MTU_Len.fixedEffects;
line([exp(temp(2,1)) exp(temp(2,2))],[3 3],'linewidth',10,'color',[0.7 0.7 0.7])
plot(exp(temp2(2)),3,'.','MarkerSize',30,'color','k')
temp = Trip_MG_Len.coefCI;
temp2 = Trip_MG_Len.fixedEffects;
line([exp(temp(2,1)) exp(temp(2,2))],[4 4],'linewidth',10,'color',[0.7 0.7 0.7])
plot(exp(temp2(2)),4,'.','MarkerSize',30,'color','k')
temp = Trip_AT_Len.coefCI;
temp2 = Trip_AT_Len.fixedEffects;
line([exp(temp(2,1)) exp(temp(2,2))],[5 5],'linewidth',10,'color',[0.7 0.7 0.7])
plot(exp(temp2(2)),5,'.','MarkerSize',30,'color','k')
temp = Trip_MTU_Len.coefCI;
temp2 = Trip_MTU_Len.fixedEffects;
line([exp(temp(2,1)) exp(temp(2,2))],[6 6],'linewidth',10,'color',[0.7 0.7 0.7])
plot(exp(temp2(2)),6,'.','MarkerSize',30,'color','k')
set(gca,'YTick',[1 2 3 4 5 6],'YTickLabel',{'Slip MG ES', 'Slip AT ES', 'Slip MTU ES', 'Trip MG ES', 'Trip AT ES', 'Trip MTU ES'},'YLim',[0.5 6.5])
title('Odds Ratios')
xlim([0 3.5])

% Odds ratio - Shown effect for MTU length in perceived trips. ~ 2 meaning
% that for 1 SD in MTU length a sub is 2x as likely to perceive the trip 
%%
clear 
%% Running peak effect size ttests and timing ttests 
% Setting up the file to run ttests and odds ratio to see if any variable aided in perceiving the disturbances
filename = 'C:\Github\Perception-Project\Dan\USPercep Analysis\Analysis\DataFormatForStats_US.xlsx';
% sheet = 'Whole Avg ES Late Stance'; % Whole Avg ES Full GC
sheet = 'PeakESSlips';
% sheet2 = 'Local Avg ES Late Stance'; % Local Avg ES Full GC
sheet2 = 'PeakESTrips';


% create table for Slips
dataTable = readtable(filename,'Sheet',sheet);

% create table for Trips
dataTable2 = readtable(filename, 'Sheet', sheet2);

% number of percieved perturbations per subject
for i=1:11
    numPerceived(i) = sum(dataTable.Perceived(dataTable.SubjectNum==i));
    numPerceived2(i) = sum(dataTable2.Perceived(dataTable2.SubjectNum==i));
end
% Grabbing the perceived and not perceived slip-like disturbance data
perceivedSlips = dataTable.Perceived==1;
data_perceivedSlips = dataTable(perceivedSlips,2:4);
data_notperceivedSlips = dataTable(~perceivedSlips,2:4);
% Grabbing the perceived and not perceived trip-like disturbance data
perceivedTrips = dataTable2.Perceived==1;
data_perceivedTrips = dataTable2(perceivedTrips,2:4);
data_notperceivedTrips = dataTable2(~perceivedTrips,2:4);

%% Running Rank sum tests for peak effect size 
% Putting the data slip-like data into an array for t tests (MG, AT, MTU
% # of SDs)
x = table2array(dataTable(:,2:4));
% Pulling the trip-like data into an array for t tests (MG, AT, MTU # of
% SDs)
y = table2array(dataTable2(:,2:4));
% Grabbing the perceived values for the trip-like data
group2 = dataTable2.Perceived;
% Grabbing the perceived values for slip-like data
group = dataTable.Perceived;


% Performing a rank sum ttest to compare the # of SDs between perceived and
% not perceived perturbations for slip-like MG, AT, and MTU
for i = 1:size(x,2)
    [p2, W2Table, W2stats] = ranksum(x(group==1,i), x(group==0,i));
    pSlipsPK(i) = p2;
    avgSlipsP(i) = mean(x(group==1,i));
    avgSlipsNP(i) = mean(x(group==0,i));
    clear p2
end
% Performing individual rank sum ttests to compare the # of SDs between
% perceived and not perceived perturbations for trip-like MG,AT, and MTU
for j = 1:size(y,2)
    [p3, W2Table, W2stats] = ranksum(y(group2==1,j), y(group2==0,j));
    pTripsPK(j) = p3;
    avgTripsP(j) = mean(y(group2==1,j));
    avgTripsNP(j) = mean(y(group2==0,j));
    clear p3
end


%% t-test plots 
% Creating labels to loop through the ttest results and show the data 
names = {'pk_MGL','pk_ATL','pk_MTU',};
% Creating the labels for the top of the plots 
names2 = {'Peak ES MG'; 'Peak ES AT'; 'Peak ES MTU';};

% Slip-like data plot - No significant differences were observed for slow
% down perturbations between perceived and not perceived perturbations 
figure;
axis equal;
for i=1:3
    subplot(1,3,i)
    boxplot(dataTable.(names{i}),perceivedSlips,'notch','on','outliersize',7,'ColorGroup',perceivedSlips)
    title([names2{i},' p = ' num2str(round(pSlipsPK(i),3))])
    ylim([0 50])
end

% Trip-like data plot - Significant increase in MTU length deviation observed for speed up
% perturbations that were perceived vs not perceived. AT length deviation
% was close to being significantly increased for perceived vs not perceived
% but failed comparison by 0.002. 
figure;
axis equal;
for i=1:3
    subplot(1,3,i)
    boxplot(dataTable2.(names{i}),perceivedTrips,'notch','on','outliersize',7,'ColorGroup',perceivedTrips)
    if pTripsPK(i) < 0.0167
        title({[names2{i} ' p = ' num2str(round(pTripsPK(i),3)) '**']});
    else
        title([names2{i} ' p = ' num2str(round(pTripsPK(i),3))]);
    end
    ylim([0 50])
end

%% Running rank sum tests for peak effect size timing 
% Putting the data slip-like data into an array for t tests (MG, AT, MTU
% # of SDs)
x = table2array(dataTable(:,5:7));
% Pulling the trip-like data into an array for t tests (MG, AT, MTU # of
% SDs)
y = table2array(dataTable2(:,5:7));
% Grabbing the perceived values for the trip-like data
group2 = dataTable2.Perceived;
% Grabbing the perceived values for slip-like data
group = dataTable.Perceived;


% Performing a rank sum ttest to compare the # of SDs between perceived and
% not perceived perturbations for slip-like MG, AT, and MTU
for i = 1:size(x,2)
    [p2, W2Table, W2stats] = ranksum(x(group==1,i), x(group==0,i));
    pSlipsT(i) = p2;
    avgSlipsP(i) = mean(x(group==1,i));
    avgSlipsNP(i) = mean(x(group==0,i));
    clear p2
end
% Performing individual rank sum ttests to compare the # of SDs between
% perceived and not perceived perturbations for trip-like MG,AT, and MTU
for j = 1:size(y,2)
    [p3, W2Table, W2stats] = ranksum(y(group2==1,j), y(group2==0,j));
    pTripsT(j) = p3;
    avgTripsP(j) = mean(y(group2==1,j));
    avgTripsNP(j) = mean(y(group2==0,j));
    clear p3
end


%% t-test plots 
% Creating labels to loop through the ttest results and show the data 
names = {'t_MGL','t_ATL','t_MTU',};
% Creating the labels for the top of the plots 
names2 = {'Timing MG'; 'Timing AT'; 'Timing MTU';};

% Slip-like data plot - No significant differences were observed for slow
% down perturbations between perceived and not perceived perturbations 
figure;
axis equal;
for i=1:3
    subplot(1,3,i)
    boxplot(dataTable.(names{i}),perceivedSlips,'notch','on','outliersize',7,'ColorGroup',perceivedSlips)
    title([names2{i},' p = ' num2str(round(pSlipsT(i),3))])
    ylim([0 110])
end

% Trip-like data plot - Significant increase in MTU length deviation observed for speed up
% perturbations that were perceived vs not perceived. AT length deviation
% was close to being significantly increased for perceived vs not perceived
% but failed comparison by 0.002. 
figure;
axis equal;
for i=1:3
    subplot(1,3,i)
    boxplot(dataTable2.(names{i}),perceivedTrips,'notch','on','outliersize',7,'ColorGroup',perceivedTrips)
    if pTripsT(i) < 0.0167
        title({[names2{i} ' p = ' num2str(round(pTripsT(i),3)) '**']});
    else
        title([names2{i} ' p = ' num2str(round(pTripsT(i),3))]);
    end
    ylim([0 110])
end

%% Running paired ttests for 


USslips = [0.1140316087, 0.09607739677, 0.09634721492, 0.03492158615, 0.0751035275, 0.05848567121];
UStrips = [0.09568028097, 0.08764655537, 0.08764655537, 0.05473286255, 0.1555525471, 0.0751035275];
YNslips = [0.1252328431, 0.06268280803, 0.09607739677, 0.05473286255, 0.0751035275, 0.06294405281];
YNtrips = [0.1252328431, 0.06298697199, 0.07592535555, 0.06298697199, 0.1140316087, 0.05473286255];


[~, pUSTrip] = ttest(UStrips, YNtrips);
[~, pUSSlip] = ttest(USslips, YNslips);


