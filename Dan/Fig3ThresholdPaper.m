% Results for Figure 3 of Threshold Paper 

A_DTC = [0.699404762000000;2.43156149400000;17.4747023800000;2.19007434200000;0.253164557000000;2.58333333300000;3.29967852100000;-6.13553113600000;0.850914205000000;-4.75555555600000;-3.79846938800000];
R_DTC = [8.06981072200000;-19.5741276900000;-2.67986995400000;-12.2076051400000;-55.8110122300000;-13.1536479800000;-44.6440579000000;10.7465743800000;-20.1263684200000;-15.2878773400000;13.9842944800000];
avgA = mean(A_DTC);
avgR = mean(R_DTC);

sdA = std(A_DTC);
sdR = std(R_DTC);

Diff = [-0.00170638800000000;0.00798659200000000;-0.0104845520000000;-0.000762878000000000;0;0.0635125240000000;0.0212745850000000;0.0199253840000000;-0.0254000000000000;-0.0239234430000000;0.0385253840000000];

[rhoA, pA] = corr(A_DTC, Diff);
[rhoR, pR] = corr(R_DTC, Diff);


filename = 'DTC Figure 3';
filenamePDF = [filename '.pdf'];
h = figure; subplot(1,2,1); p1 = bar(1, avgA); hold on;
p2 = bar(2,avgR);
set(p1, 'FaceColor', '#005EB8')
set(p2, 'FaceColor', '#ED8B00')
hold on; errorbar([avgA; avgR],[sdA;sdR], 'LineStyle', 'none', 'color', 'k');
% Subject 1 
scatter(1, A_DTC(1), 100, 'filled', 'ko');
scatter(2, R_DTC(1), 100, 'filled', 'ko')

% Subject 2 
scatter(1, A_DTC(2), 100, 'filled', 'kd');
scatter(2, R_DTC(2), 100, 'filled', 'kd')

% Subject 3 
scatter(1, A_DTC(3), 100, 'k*');
scatter(2, R_DTC(3), 100, 'k*')

% Subject 4
scatter(1, A_DTC(4), 100, 'filled', 'ks');
scatter(2, R_DTC(4), 100, 'filled', 'ks');

% Subject 5 
scatter(1, A_DTC(5), 100, [162 170 173]./255, 'filled', 'o');
scatter(2, R_DTC(5), 100, [162 170 173]./255, 'filled', 'o')

% Subject 6 
scatter(1, A_DTC(6), 100, [162 170 173]./255, 'filled', 'd');
scatter(2, R_DTC(6), 100, [162 170 173]./255, 'filled', 'd')

% Subject 7 
scatter(1, A_DTC(7), 100, [162 170 173]./255, '*');
scatter(2, R_DTC(7), 100, [162 170 173]./255, '*')

% Subject 8
scatter(1, A_DTC(8), 100, [162 170 173]./255, 'filled', 's');
scatter(2, R_DTC(8), 100, [162 170 173]./255, 'filled', 's');

% Subject 9 
scatter(1, A_DTC(9), 100, [150 144 131]./255, 'filled', 'o');
scatter(2, R_DTC(9), 100, [150 144 131]./255, 'filled', 'o')

% Subject 10 
scatter(1, A_DTC(10), 100, [150 144 131]./255, 'filled', 'd');
scatter(2, R_DTC(10), 100, [150 144 131]./255, 'filled', 'd')

% Subject 11 
scatter(1, A_DTC(11), 100, [150 144 131]./255, '*');
scatter(2, R_DTC(11), 100, [150 144 131]./255, '*')


% for i = 1:11 
%     if i < 4
%         scatter(1, A_DTC(i), 100,'filled', 'ko');
%         scatter(2, R_DTC(i), 100,'filled', 'ko');
%     elseif i
% end
set(gca, 'XTick', [1,2]);
set(gca, 'XTickLabel',{'Accuracy';'Rate'});
ylabel('Dual Task Cost');
subplot(1,2,2); scatter(Diff,A_DTC,100,  [0, 94, 184]./255, 'filled'); hold on; scatter(Diff,R_DTC,100,  [237, 129, 0]./255, 'filled'); xline(0); yline(0);
xlabel('Difference in Threshold (Cog - Norm)'); ylabel('DTC'); legend( {'Accuarcy'; 'Rate'}, 'Location', 'SouthEast');
xlim([-0.04, 0.08]);

saveas(h, filename);
print(filenamePDF, '-dpdf', '-bestfit');