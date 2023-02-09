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
    title({names2{i},' p = ' num2str(round(pSlips(i),3))})
    ylim([0 7])
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
    ylim([0 7])
end


%% generlized mixed effets model

% Kept individual models for each of the variables 

Slip_MG_Len = fitglme(dataTable, ...
    'Perceived ~ 1 + FGC_MGL + (1 + FGC_MGL|SubjectNum)',...
    'Distribution','Binomial','Link','logit');

Slip_AT_Len = fitglme(dataTable, ...
    'Perceived ~ 1 + FGC_ATL + (1 + FGC_ATL|SubjectNum)',...
    'Distribution','Binomial','Link','logit');

Slip_MTU_Len = fitglme(dataTable, ...
    'Perceived ~ 1 + FGC_MTL + (1 + FGC_MTL|SubjectNum)',...
    'Distribution','Binomial','Link','logit');

Trip_MG_Len = fitglme(dataTable2, ...
    'Perceived ~ 1 + FGC_MGL + (1 + FGC_MGL|SubjectNum)',...
    'Distribution','Binomial','Link','logit');


Trip_AT_Len = fitglme(dataTable2, ...
    'Perceived ~ 1 + FGC_ATL + (1 + FGC_ATL|SubjectNum)',...
    'Distribution','Binomial','Link','logit');

Trip_MTU_Len = fitglme(dataTable2, ...
    'Perceived ~ 1 + FGC_MTL + (1 + FGC_MTL|SubjectNum)',...
    'Distribution','Binomial','Link','logit');


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

%% Setting up for the 2 way anova 
% Main effects - speed and perceived on MTU # of SDs 
clear 
% Setting the location to where the excel sheet is for stats 
filename = 'C:\Github\Perception-Project\Dan\USPercep Analysis\Analysis\DataFormatForStats_US.xlsx';
% Selecting the full gait cycle averaged effect size for slip-like
% disturbances
sheet = 'FGC_Slips';
% Selecting the full gait cycle averaged effect size for trip-like
% disturbances
sheet2 = 'FGC_Trips';


% create table for Slips
slips = readtable(filename,'Sheet',sheet);

% create table for Trips
trips = readtable(filename, 'Sheet', sheet2);


% creating a matrix for the 2-way anova 
slipsMTU = slips.FGC_MTL; 
slipsMGL = slips.FGC_MGL; 
slipsATL = slips.FGC_ATL; 
% creating group cell arrays which will be speed and perceived 
for i = 1:size(slipsMTU,1)
    if slips.Speeds(i) == -0.02
        speed(i) = 1;
    elseif slips.Speeds(i) == -0.05
        speed(i) = 2; 
    elseif slips.Speeds(i) == -0.10
        speed(i) = 3; 
    elseif slips.Speeds(i) == -0.15
        speed(i) = 4;
    else
    end
end
speed = speed';
perceived = logical(slips.Perceived);

% running 2-way anova
pSMTU = anovan(slipsMTU, {speed, perceived}, 'model', 'interaction', "varnames",{'PertSpeed', 'Perceived'});
pSMGL = anovan(slipsMGL, {speed, perceived}, 'model', 'interaction',  "varnames",{'PertSpeed', 'Perceived'});
pSATL = anovan(slipsATL, {speed, perceived}, 'model', 'interaction',  "varnames",{'PertSpeed', 'Perceived'});
% 


% creating a matrix for the 2-way anova 
tripsMTU = trips.FGC_MTL; 
tripsMGL = trips.FGC_MGL; 
tripsATL = trips.FGC_ATL;  
% creating group cell arrays which will be speed and perceived 
for i = 1:size(tripsMTU,1)
    if trips.Speeds(i) == 0.02
        speed(i) = 1;
    elseif trips.Speeds(i) == 0.05
        speed(i) = 2; 
    elseif trips.Speeds(i) == 0.10
        speed(i) = 3; 
    elseif trips.Speeds(i) == 0.15
        speed(i) = 4;
    elseif trips.Speeds(i) == 0.20
        speed(i) = 5;
    else
    end
end
speed = speed';
perceived = logical(trips.Perceived);

% running 2-way anova
pTMTU = anovan(tripsMTU, {speed, perceived}, 'model', 'interaction', "varnames",{'PertSpeed', 'Perceived'});
pTMGL = anovan(tripsMGL, {speed, perceived}, 'model', 'interaction',  "varnames",{'PertSpeed', 'Perceived'});
pTATL = anovan(tripsATL, {speed, perceived}, 'model', 'interaction',  "varnames",{'PertSpeed', 'Perceived'});

% No significant effect shown for perceiving perturbations, but
% significant main effect shown on speed for all variables so just doing a
% compairson for the MTU since the effect there should carry to both the MG
% and tendon changes.

%% Analysis for Excursion Timing with ttests
filename = 'C:\Github\Perception-Project\Dan\USPercep Analysis\Analysis\DataFormatForStats_US2.xlsx';
% sheet = 'SlipsEx';
sheet = 'SlipsTime';
% sheet2 = 'TripsEx';
sheet2 = 'TripsTime';

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


% Performing individual rank sum ttests to compare the peak excursion
% timings for perceived and not perceived slip-like perturbations
for i = 1:size(x,2)
    [p2] = ranksum(x(group==1,i), x(group==0,i));
    pSTiming(i) = p2;
    clear p2
end
pSTiming < 0.05/3
% Performing individual rank sum ttests to compare the peak excursion
% timings for perceived and not perceived trip-like perturbations
for j = 1:size(y,2)
    [p3] = ranksum(y(group2==1,j), y(group2==0,j));
    pTTiming(j) = p3;
    clear p3
end
pTTiming < 0.05/3

% Significant timing effects on the peak excursion timing in AT and MTU for perceived
% perturbations compared to not perceived perturbations. This analysis
% included the prepertubation strides as not perceived perturbations.

% t-test plots 
% Creating labels to loop through the ttest results and show the data 
names = {'tMG','tAT','tMTU',};
% Creating the labels for the top of the plots 
names2 = {'% GC of peak MG Excur'; '% GC of peak AT Excur'; '% GC of peak MTU Excur';};

% Slip-like data plot= significant increase in percevied perturbations vs
% not perceived perturbations for AT and MTU peak excursion timing 
figure;
axis equal;
for i=1:3
    subplot(1,3,i)
    boxplot(dataTable.(names{i}),perceivedSlips,'notch','on','outliersize',5,'ColorGroup',perceivedSlips)
    if pSTiming(i) < 0.0167
        title({[names2{i} ' p = ' num2str(round(pSTiming(i),3)) '**']});
    else
        title([names2{i} ' p = ' num2str(round(pSTiming(i),3))]);
    end
%     ylim([0 7])
end

% Trip-like data plot - significant decrease in perceived perturbations vs not
% perceived perturbations for AT and MTU peak excursion timing
figure;
axis equal;
for i=1:3
    subplot(1,3,i)
    boxplot(dataTable2.(names{i}),perceivedTrips,'notch','on','outliersize',5,'ColorGroup',perceivedTrips)
    if pTTiming(i) < 0.0167
        title({[names2{i} ' p = ' num2str(round(pTTiming(i),3)) '**']});
    else
        title([names2{i} ' p = ' num2str(round(pSTiming(i),3))]);
    end
%     ylim([0 7])
end




%% Analysis for Peak Excursion distance with ttests
filename = 'C:\Github\Perception-Project\Dan\USPercep Analysis\Analysis\DataFormatForStats_US2.xlsx';
sheet = 'SlipsEx';
% sheet = 'SlipsTime';
sheet2 = 'TripsEx';
% sheet2 = 'TripsTime';

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

% Putting the data slip-like data into an array for t tests (MG, AT, MTU
% peak excursion dist)
x = table2array(dataTable(:,2:4));
% Pulling the trip-like data into an array for t tests (MG, AT, MTU 
% % peak excursion dist
y = table2array(dataTable2(:,2:4));
% Grabbing the perceived values for the trip-like data
group2 = dataTable2.Perceived;
% Grabbing the perceived values for slip-like data
group = dataTable.Perceived;


% Performing a rank sum ttest to compare the peak excursion dist between perceived and
% not perceived perturbations for slip-like MG, AT, and MTU
for i = 1:size(x,2)
    [p2] = ranksum(x(group==1,i), x(group==0,i));
    pSExcur(i) = p2;
    clear p2
end
pSExcur < 0.05/3
% Performing individual rank sum ttests to compare the peak excursion
% dist for perceived and not perceived trip-like perturbations
for j = 1:size(y,2)
    [p3] = ranksum(y(group2==1,j), y(group2==0,j));
    pTExcur(j) = p3;
    clear p3
end
pTExcur < 0.05/3



% t-test plots 
% Creating labels to loop through the ttest results and show the data 
names = {'ExMG','ExAT','ExMTU',};
% Creating the labels for the top of the plots 
names2 = {'Peak MG Excur (mm)'; 'Peak AT Excur (mm)'; 'Peak MTU Excur (mm)';};

% Slip-like data plot - No significant excursion distance changes 
figure;
axis equal;
for i=1:3
    subplot(1,3,i)
    boxplot(dataTable.(names{i}),perceivedSlips,'notch','on','outliersize',5,'ColorGroup',perceivedSlips)
    if pSExcur(i) < 0.0167
        title({[names2{i} ' p = ' num2str(round(pSExcur(i),3)) '**']});
    else
        title([names2{i} ' p = ' num2str(round(pSExcur(i),3))]);
    end
%     ylim([0 7])
end

% Trip-like data plot - No significant excursion distance changes 
figure;
axis equal;
for i=1:3
    subplot(1,3,i)
    boxplot(dataTable2.(names{i}),perceivedTrips,'notch','on','outliersize',5,'ColorGroup',perceivedTrips)
    if pTExcur(i) < 0.0167
        title({[names2{i} ' p = ' num2str(round(pTExcur(i),3)) '**']});
    else
        title([names2{i} ' p = ' num2str(round(pTExcur(i),3))]);
    end
%     ylim([0 7])
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Other Analyses that are needed but
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% included. 
%% Analysis for Excursion Timing 
filename = 'C:\Github\Perception-Project\Dan\USPercep Analysis\Analysis\DataFormatForStats_US2.xlsx';
% sheet = 'SlipsEx';
sheet = 'SlipsTime';
% sheet2 = 'TripsEx';
sheet2 = 'TripsTime';

% create table for Slips
dataTable = readtable(filename,'Sheet',sheet);

% create table for Trips
dataTable2 = readtable(filename, 'Sheet', sheet2);

% Making a table of labels for MG, AT, MTU excursions
% I believe this is for the repeated measures
labels = table([1 2 3]', 'VariableNames', {'Excursions'});

% Creating the table for the rm model
slipsTab = dataTable(:,[2:5]);
% Creating the table for the rm model
tripsTab = dataTable2(:,[2:5]);
%% Running a repeated measure anova for comparison 
% Measurements 3 excursions: MG, AT, MTU, 
% Predicting Speeds 
% Had to create a repeated measure model? 
% This is for slips 
rmsTime = fitrm(slipsTab, 'tMG-tMTU ~ Speeds', 'WithinDesign',labels);
% Running repeated measure anova on my data for slips 
slipsTime = ranova(rmsTime);

% Measurements 3 excursions: MG, AT, MTU, 
% Predicting Speeds 
% Had to create a repeated measure model? 
rmtTime = fitrm(tripsTab, 'tMG-tMTU ~ Speeds', 'WithinDesign',labels);
% Running repeated measure anova on my data for slips 
tripsTime = ranova(rmtTime);



% I think this means there was a significant interaction effect for speed
% for slips but not for trips with the peak excursion timing during the
% gait cycle. 

%% Analysis for peak Excursion Distance in mm 
filename = 'C:\Github\Perception-Project\Dan\USPercep Analysis\Analysis\DataFormatForStats_US2.xlsx';
sheet = 'SlipsEx';
% sheet = 'SlipsTime';
sheet2 = 'TripsEx';
% sheet2 = 'TripsTime';

% create table for Slips
dataTable = readtable(filename,'Sheet',sheet);

% create table for Trips
dataTable2 = readtable(filename, 'Sheet', sheet2);

% Making a table of labels for MG, AT, MTU excursions
% I believe this is for the repeated measures
labels = table([1 2 3]', 'VariableNames', {'Excursions'});

% Creating the table for the rm model
slipsTab = dataTable(:,[2:5]);
% Creating the table for the rm model
tripsTab = dataTable2(:,[2:5]);

%% Running a repeated measure anova for Excursion Distance
% Measurements 3 excursions: MG, AT, MTU, 
% Predicting Speeds 
% Had to create a repeated measure model? 
% This is for slips 
rmsEx = fitrm(slipsTab, 'ExMG-ExMTU ~ Speeds', 'WithinDesign',labels);
% Running repeated measure anova on my data for slips 
slipsEx = ranova(rmsEx);

% Measurements 3 excursions: MG, AT, MTU, 
% Predicting Speeds 
% Had to create a repeated measure model? 
rmtEx = fitrm(tripsTab, 'ExMG-ExMTU ~ Speeds', 'WithinDesign',labels);
% Running repeated measure anova on my data for slips 
tripsEx = ranova(rmtEx);


% I think this means there was a significant interaction effect for speed
% for peak trip excursion but not for slips. 