%% Bar plotting script 



h               = figure;
filename        = ['Thresholds' datestr(now, 'mm-dd-yyyy HH-MM')];
filenamePDF     = [filename '.pdf'];
b1              = bar([1,2],[mean(pap1), mean(pap3)]);
b1.FaceColor = [0.90,0.90,0.90];
% ylim([-0.03, 0.18])
hold on
errorbar([mean(pap1), mean(pap3)],[std(pap1), std(pap3)], 'LineStyle', 'none', 'color', 'k')


for i = 1:15
    scatter(1,pap1(i), 300, 'filled', 'ro');
end

for i = 1:12
    scatter(2,pap3(i), 300, 'filled', 'ro');
end


title('Thresholds across 27 subjects')
ylabel('Threshold (m/s)')
set(gca, 'XTickLabel', {'Chapter 2 & 3'; 'Chapter 4'})
% saveas(h, filename);
% print(filenamePDF,'-dpdf', '-bestfit');
% close(h)

%% Plotting OA and trip-like results
h               = figure;
filename        = ['Trip-like Thresholds' datestr(now, 'mm-dd-yyyy HH-MM')];
filenamePDF     = [filename '.pdf'];
b1              = bar([1,2],[mean(trips), mean(OA)]);
b1.FaceColor = [0.90,0.90,0.90];
ylim([0, 0.18])
hold on
errorbar([mean(trips), mean(OA)],[std(trips), std(OA)], 'LineStyle', 'none', 'color', 'k')


for i = 1:12
    scatter(1,trips(i), 300, 'filled', 'ro');
end

for i = 1:2
    scatter(2,OA(i), 300, 'filled', 'ro');
end


title('Trip-like thresholds for YA and OA')
ylabel('Threshold (m/s)')
set(gca, 'XTickLabel', {'YA'; 'OA'})