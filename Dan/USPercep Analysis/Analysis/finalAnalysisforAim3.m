filename = 'C:\Github\Perception-Project\Dan\USPercep Analysis\Analysis\DataFormatForStats_US2(DJL).xlsx';

% Setting the trip sheet name
Tripsheet = 'MatlabTrips';

% create table for Trips
TripTable = readtable(filename,'Sheet',Tripsheet);

% Creating the perceived and not perceived trip variables for plotting
perceivedTrips = TripTable.Perceived==1;
TripsPerceived = TripTable(perceivedTrips, 1:9);
TripsNotPerceived = TripTable(~perceivedTrips, 1:9);


%% Trip plots 
pTrip = [0.214, 0.01864, 0.0001206, 0.121, 0.00376, 0.0000147, 0.92000, 0.92000, 1.000];
% Order of p values Avg MG, Avg AT, Avg MTU, Peak MG, Peak AT, Peak MTU,
% Time MG, Time AT, Time MTU

names = TripsPerceived.Properties.VariableNames;
h1 = figure('Name', 'Trips Avg Plots');
for i=1:3
    subplot(1,3,i)
    W1{:,1} = TripsNotPerceived.(names{i});
    W1{:,2} = TripsPerceived.(names{i});
    violin(W1, 'xlabel', {'Not Perceived'; ...
        'Perceived'}, 'facecolor', [0.6350 0.0780 0.1840; 0 0.4470 0.7410]);    
    if pTrip(i) < 0.05
        title({names{i},'p = ' num2str(round(pTrip(i),3)) '*'})
    else
        title({names{i},'p = ' num2str(round(pTrip(i),3))})
    end
    ylim([0 8]);
    xticklabels({'Not Perceived'; 'Perceived'});

    swarmchart(ones(1,length(TripsNotPerceived.(names{i}))), TripsNotPerceived.(names{i}), 36, [110/255 98/255 89/255]);
    hold on; 
    swarmchart(2*ones(1, length(TripsPerceived.(names{i}))), TripsPerceived.(names{i}), 36, [110/255 98/255 89/255]);
    clear W1
end


filename2 = 'Trips Avg Plot Comparison';
filenamePDF2 = strcat(filename2, '.pdf');
saveas(h1, filename2);
print(filenamePDF2, '-dpdf', '-bestfit');

clear filename2 filenamePDF2

h2 = figure('Name', 'Trips Peak Plots');
for i=4:6
    subplot(1,3,i-3)
    W1{:,1} = TripsNotPerceived.(names{i});
    W1{:,2} = TripsPerceived.(names{i});
    violin(W1, 'xlabel', {'Not Perceived'; ...
        'Perceived'}, 'facecolor', [0.6350 0.0780 0.1840; 0 0.4470 0.7410]);    
    if pTrip(i) < 0.05
        title({names{i},'p = ' num2str(round(pTrip(i),3)) '*'})
    else
        title({names{i},'p = ' num2str(round(pTrip(i),3))})
    end
    ylim([0 35]);
    xticklabels({'Not Perceived'; 'Perceived'});

    swarmchart(ones(1,length(TripsNotPerceived.(names{i}))), TripsNotPerceived.(names{i}), 36, [110/255 98/255 89/255]);
    hold on; 
    swarmchart(2*ones(1, length(TripsPerceived.(names{i}))), TripsPerceived.(names{i}), 36, [110/255 98/255 89/255]);
    clear W1
end


filename2 = 'Trips Peak Plot Comparison';
filenamePDF2 = strcat(filename2, '.pdf');
saveas(h2, filename2);
print(filenamePDF2, '-dpdf', '-bestfit');

clear filename2 filenamePDF2

names = TripsPerceived.Properties.VariableNames;
h3 = figure('Name', 'Trips Time Plots');
for i=7:9
    subplot(1,3,i-6)
    W1{:,1} = TripsNotPerceived.(names{i});
    W1{:,2} = TripsPerceived.(names{i});
    violin(W1, 'xlabel', {'Not Perceived'; ...
        'Perceived'}, 'facecolor', [0.6350 0.0780 0.1840; 0 0.4470 0.7410]);    
    if pTrip(i) < 0.05
        title({names{i},'p = ' num2str(round(pTrip(i),3)) '*'})
    else
        title({names{i},'p = ' num2str(round(pTrip(i),3))})
    end
    ylim([1 101]);
    xticklabels({'Not Perceived'; 'Perceived'});

    swarmchart(ones(1,length(TripsNotPerceived.(names{i}))), TripsNotPerceived.(names{i}), 36, [110/255 98/255 89/255]);
    hold on; 
    swarmchart(2*ones(1, length(TripsPerceived.(names{i}))), TripsPerceived.(names{i}), 36, [110/255 98/255 89/255]);
    clear W1
end


filename2 = 'Trips Time Plot Comparison';
filenamePDF2 = strcat(filename2, '.pdf');
saveas(h3, filename2);
print(filenamePDF2, '-dpdf', '-bestfit');

clear filename2 filenamePDF2



%%
clear 
home 
filename = 'C:\Github\Perception-Project\Dan\USPercep Analysis\Analysis\DataFormatForStats_US2(DJL).xlsx';

% Setting the trip sheet name
Slipsheet = 'MatlabSlips';

% create table for Trips
SlipTable = readtable(filename,'Sheet',Slipsheet);

% Creating the perceived and not perceived trip variables for plotting
perceivedSlips = SlipTable.Perceived==1;
SlipsPerceived = SlipTable(perceivedSlips, 1:9);
SlipsNotPerceived = SlipTable(~perceivedSlips, 1:9);




%% Slip plots 
pSlip = [0.514, 0.324, 0.514, 0.885, 0.885, 0.885, 0.846, 1.0, 1.0];
% Order of p values Avg MG, Avg AT, Avg MTU, Peak MG, Peak AT, Peak MTU,
% Time MG, Time AT, Time MTU

names = SlipsPerceived.Properties.VariableNames;
h1 = figure('Name', 'Slips Avg Plots');
for i=1:3
    subplot(1,3,i)
    W1{:,1} = SlipsNotPerceived.(names{i});
    W1{:,2} = SlipsPerceived.(names{i});
    violin(W1, 'xlabel', {'Not Perceived'; ...
        'Perceived'}, 'facecolor', [0.6350 0.0780 0.1840; 0 0.4470 0.7410]);    
    if pSlip(i) < 0.05
        title({names{i},'p = ' num2str(round(pSlip(i),3)) '*'})
    else
        title({names{i},'p = ' num2str(round(pSlip(i),3))})
    end
    ylim([0 8]);
    xticklabels({'Not Perceived'; 'Perceived'});

    swarmchart(ones(1,length(SlipsNotPerceived.(names{i}))), SlipsNotPerceived.(names{i}), 36, [110/255 98/255 89/255]);
    hold on; 
    swarmchart(2*ones(1, length(SlipsPerceived.(names{i}))), SlipsPerceived.(names{i}), 36, [110/255 98/255 89/255]);
    clear W1
end


filename2 = 'Slips Avg Plot Comparison';
filenamePDF2 = strcat(filename2, '.pdf');
saveas(h1, filename2);
print(filenamePDF2, '-dpdf', '-bestfit');

clear filename2 filenamePDF2

h2 = figure('Name', 'Slips Peak Plots');
for i=4:6
    subplot(1,3,i-3)
    W1{:,1} = SlipsNotPerceived.(names{i});
    W1{:,2} = SlipsPerceived.(names{i});
    violin(W1, 'xlabel', {'Not Perceived'; ...
        'Perceived'}, 'facecolor', [0.6350 0.0780 0.1840; 0 0.4470 0.7410]);    
    if pSlip(i) < 0.05
        title({names{i},'p = ' num2str(round(pSlip(i),3)) '*'})
    else
        title({names{i},'p = ' num2str(round(pSlip(i),3))})
    end
    ylim([0 35]);
    xticklabels({'Not Perceived'; 'Perceived'});

    swarmchart(ones(1,length(SlipsNotPerceived.(names{i}))), SlipsNotPerceived.(names{i}), 36, [110/255 98/255 89/255]);
    hold on; 
    swarmchart(2*ones(1, length(SlipsPerceived.(names{i}))), SlipsPerceived.(names{i}), 36, [110/255 98/255 89/255]);
    clear W1
end


filename2 = 'Slips Peak Plot Comparison';
filenamePDF2 = strcat(filename2, '.pdf');
saveas(h2, filename2);
print(filenamePDF2, '-dpdf', '-bestfit');

clear filename2 filenamePDF2

h3 = figure('Name', 'Slips Time Plots');
for i=7:9
    subplot(1,3,i-6)
    W1{:,1} = SlipsNotPerceived.(names{i});
    W1{:,2} = SlipsPerceived.(names{i});
    violin(W1, 'xlabel', {'Not Perceived'; ...
        'Perceived'}, 'facecolor', [0.6350 0.0780 0.1840; 0 0.4470 0.7410]);    
    if pSlip(i) < 0.05
        title({names{i},'p = ' num2str(round(pSlip(i),3)) '*'})
    else
        title({names{i},'p = ' num2str(round(pSlip(i),3))})
    end
    ylim([1 101]);
    xticklabels({'Not Perceived'; 'Perceived'});

    swarmchart(ones(1,length(SlipsNotPerceived.(names{i}))), SlipsNotPerceived.(names{i}), 36, [110/255 98/255 89/255]);
    hold on; 
    swarmchart(2*ones(1, length(SlipsPerceived.(names{i}))), SlipsPerceived.(names{i}), 36, [110/255 98/255 89/255]);
    clear W1
end


filename2 = 'Slips Time Plot Comparison';
filenamePDF2 = strcat(filename2, '.pdf');
saveas(h3, filename2);
print(filenamePDF2, '-dpdf', '-bestfit');

clear filename2 filenamePDF2




