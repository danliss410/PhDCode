%% Creating Bar plots for Perception Thresholds 

clear; clc;

load('G:\Shared drives\NeuroMobLab\LabMemberFolders\Dan\Perception Study\YAPercep Data Plots\Thresholds\Results')

cd('G:\Shared drives\NeuroMobLab\LabMemberFolders\Dan\Conferences\2020\ASB 2020\ASB Plots')


h               = figure;
filename        = ['YesNoFull ' datestr(now, 'mm-dd-yyyy HH-MM')];
filenamePDF     = [filename '.pdf'];
b1              = bar(resultsTable.Average(7));
b1.FaceColor = [0.90,0.90,0.90];
hold on
errorbar(resultsTable.Average(7), resultsTable.Std(7), 'LineStyle', 'none', 'color', 'k')
% plot(1, resultsTable.Median(7), 'rx')

for i = 1:15  
    if i ~= 3
        scatter(1, TabYesNo.('DomThres')(i), 100,'filled', 'o');
    else
        scatter(1, TabYesNo.('DomThres')(i), 100,'filled', 'go');
    end
end

title('Average Perception Threshold to Small Velocity Disturbances')
ylabel('Threshold (m/s)')
xlabel('Stuff')
set(gca, 'XTickLabel', 'Dominant Leg')
legend
saveas(h, filename);
print(filenamePDF,'-dpdf', '-bestfit');
close(h)

cd('G:\My Drive\MATLAB\Perception\Processing')

%% Plotting Comparison for Normal YesNo vs Cognitive 

% cd('G:\Shared drives\NeuroMobLab\LabMemberFolders\Dan\Conferences\2020\ASB 2020\ASB Plots')
% 
% 
% h               = figure;
% filename        = ['YesNo vs Cog ' datestr(now, 'mm-dd-yyyy HH-MM')];
% filenamePDF     = [filename '.pdf'];
% b1              = bar([resultsTable.Average(8), resultsTable.Average(9)]);
% hold on
% errorbar([resultsTable.Average(8), resultsTable.Average(9)], [resultsTable.Std(8), resultsTable.Std(9)], 'LineStyle', 'none', 'color', 'k')
% % plot(1, resultsTable.Median(8), 'ro')
% % plot(2, resultsTable.Median(9), 'ro')
% 
% for i = 1:8
%     if i ~= 2
%         plot([1,2], [TabYesNoShort.('DomThres')(i) TabCog.('DomThres')(i)], 'k')
%         plot(1, TabYesNoShort.('DomThres')(i), 'x')
%         plot(2, TabCog.('DomThres')(i), 'x')
%     else
%         plot([1,2], [TabYesNoShort.('DomThres')(i) TabCog.('DomThres')(i)], 'g')
%         plot(1, TabYesNoShort.('DomThres')(i), 'gx')
%         plot(2, TabCog.('DomThres')(i), 'gx')        
%     end
% end
% 
% title('Cognitive Influence for Perception Task')
% ylabel('Threshold (m/s)')
% set(gca, 'XTickLabel', {'YesNo'; 'Cognitive'})
% legend
% saveas(h, filename);
% print(filenamePDF,'-dpdf', '-bestfit');
% close(h)
% 
% cd('G:\My Drive\MATLAB\Perception\Processing')


%% Plotting Difference of cognitive task - normal task 

cd('G:\Shared drives\NeuroMobLab\LabMemberFolders\Dan\Conferences\2020\ASB 2020\ASB Plots')


h               = figure;
filename        = ['Threshold Differences' datestr(now, 'mm-dd-yyyy HH-MM')];
filenamePDF     = [filename '.pdf'];
b1              = bar(resultsTable.Average(11));
b1.FaceColor = [0.90,0.90,0.90];
ylim([-0.03, 0.18])
hold on
errorbar(resultsTable.Average(11),resultsTable.Std(11), 'LineStyle', 'none', 'color', 'k')
% plot(1, resultsTable.Median(11), 'ro')


for i = 1:12
    if i ~= 2
        scatter(1, TabCog.('Difference')(i), 600,'filled', 'o');
    else
        scatter(1, TabCog.('Difference')(i), 600,'filled', 'go');        
    end
end

title('Cognitive Task - Normal Task Thresholds')
ylabel('Threshold (m/s)')
set(gca, 'XTickLabel', 'Difference between Thresholds')
legend
saveas(h, filename);
print(filenamePDF,'-dpdf', '-bestfit');
close(h)

cd('G:\My Drive\MATLAB\Perception\Processing')

%% Plotting figure for Threshold Paper 

h               = figure;
filename        = ['ASB Results Subjects ' datestr(now, 'mm-dd-yyyy HH-MM')];
filenamePDF     = [filename '.pdf'];
% Dom Leg, Non Dom Leg, Dom Leg Cog, Non Dom Leg Cog  12 subjects
% b1              = bar([resultsTable.Average(8),resultsTable.Average(9), resultsTable.Average(13),resultsTable.Average(14)]);
b1              = bar([resultsTable.Average(8)]);%,resultsTable.Average(9)]);

b1.FaceColor    = [0.90,0.90,0.90];
hold on
% errorbar([resultsTable.Average(8), resultsTable.Average(9), resultsTable.Average(13), resultsTable.Average(14)], [resultsTable.Std(8), resultsTable.Std(9), resultsTable.Std(13), resultsTable.Std(14)], 'LineStyle', 'none', 'color', 'k')
% errorbar([resultsTable.Average(8), resultsTable.Average(9)], [resultsTable.Std(8), resultsTable.Std(9)], 'LineStyle', 'none', 'color', 'k')
errorbar([resultsTable.Average(8)], [resultsTable.Std(8)], 'LineStyle', 'none', 'color', 'k')
% plot(1, resultsTable.Median(7), 'rx')

for i = 1:12  
%     if i ~= 2
        scatter(1, TabYesNoShort.('DomThres')(i), 100,'filled', 'ko');
%         plot([1,2], [TabYesNoShort.('DomThres')(i), TabCog.('DomThres')(i)], 'k')
%         plot([3,4], [TabYesNoShort.('NonDomThres')(i), TabCog.('NonDomThres')(i)], 'k')
%         scatter(2, TabYesNoShort.('NonDomThres')(i), 100, 'filled', 'o');
%         scatter(3, TabCog.('DomThres')(i), 100, 'filled', 'o');
%         scatter(4, TabCog.('NonDomThres')(i), 100, 'filled', 'o');
%     else
%         plot([1,2], [TabYesNoShort.('DomThres')(i), TabCog.('DomThres')(i)], 'g')
%         plot([3,4], [TabYesNoShort.('NonDomThres')(i), TabCog.('NonDomThres')(i)], 'g')
%         scatter(1, TabYesNoShort.('DomThres')(i), 100,'filled', 'go');
%         scatter(2, TabYesNoShort.('NonDomThres')(i), 100, 'filled', 'go');
%         scatter(3, TabCog.('DomThres')(i), 100, 'filled', 'go');
%         scatter(4, TabCog.('NonDomThres')(i), 100, 'filled', 'go');
%     end
end

title('Average Perception Threshold to Small Velocity Disturbances')
ylabel('Threshold (m/s)')
set(gca, 'XTickLabel', {'Dominant Leg'; 'Domiant Leg';})% 'Non-Dominant Leg'; 'Non-Dominant Leg'})
legend
saveas(h, filename);
print(filenamePDF,'-dpdf', '-bestfit');
close(h)
