subjects = {'01'; '02'; '03'; '04'; '05'; '06';'07';'08';'09';'10';'11';'12';'13';'14';'15'; '16'; '17'; '18';};

for iSub = 1:length(subjects)
    subject = subjects{iSub};
    perceptionThreshold(subject);
end

load('G:\Shared drives\NeuroMobLab\Projects\Perception\Processed Data\Dan\Matlab Analysis\Thresholds\FullThresholdTable2.mat')

A = contains(thresholdTableFull_2DJL.Properties.RowNames, 'YesNo');
tempTab = thresholdTableFull_2DJL(A,:);
tempTab2 = tempTab([2,3,4,5,8,9,11,12,13,14,15,17],:);
tempTab2.Speed = [1.25000000000000;1.15000000000000;1.20000000000000;1.15000000000000;1.15000000000000;1.05000000000000;1;0.950000000000000;1.25000000000000;1;1.20000000000000;1.30000000000000];
tempTab2.DomThres = tempTab2.("Neg Right");
tempTab2.DomThres(2) = tempTab2.("Neg Left")(2);
tempTab2.NonDomThres = tempTab2.("Neg Left");
tempTab2.NonDomThres(2) = tempTab2.("Neg Right")(2);
tempTab2.PercentThres = temp2;
tempTab2.NDPercentThres = tempTab2.NonDomThres./tempTab2.Speed;
TabYesNoShort2 = tempTab2; 

C = contains(thresholdTableFull_2DJL.Properties.RowNames, 'Cog');
tempTab = thresholdTableFull_2DJL(C,:);
tempTab2 = tempTab([1,2,3,4,6,7,8,9,10,11,12,13],:);
tempTab2.Speed = [1.25000000000000;1.15000000000000;1.20000000000000;1.15000000000000;1.15000000000000;1.05000000000000;1;0.950000000000000;1.25000000000000;1;1.20000000000000;1.30000000000000];
tempTab2.DomThres = tempTab2.("Neg Right");
tempTab2.DomThres(2) = tempTab2.("Neg Left")(2);
tempTab2.NonDomThres = tempTab2.("Neg Left");
tempTab2.NonDomThres(2) = tempTab2.("Neg Right")(2);
tempTab2.PercentThres = tempTab2.DomThres./tempTab2.Speed;
tempTab2.NDPercentThres = tempTab2.NonDomThres./tempTab2.Speed;
TabCog2 = tempTab2; 

save('Results2.mat', 'TabYesNoShort2', 'TabCog2');

%% Calculating correlation coefficents and p values for DTC and Cog-Norm Thres 
% Copy values over from DTC_calcs excel sheet 
temp3 = [0.699404762000000,8.06981072200000,0.0131804200000000;2.43156149400000,-19.5741276900000,-0.00798659200000000;17.4747023800000,-2.67986995400000,0.0104681940000000;0.253164557000000,-55.8110122300000,0;2.58333333300000,-13.1536479800000,-0.0617420330000000;3.29967852100000,-44.6440579000000,-0.0212745850000000;-6.13553113600000,10.7465743800000,-0.0199453930000000;0.850914205000000,-20.1263684200000,0.0254903390000000;-4.75555555600000,-15.2878773400000,0.0239577650000000;-3.79846938800000,13.9842944800000,-0.0385221820000000;-12.3130034500000,-25.4861731700000,-0.0118474290000000];
% Column 1 is accuracy, column 2 is rate column 3 is Thres Cog-Norm
[r,p] = corr(temp3(:,1),temp3(:,3));
[r2,p2] = corr(temp3(:,2),temp3(:,3));


%% Calculating the JND 

diff(:,1) = tempTab{:,1} - unnamed(:,1);
diff(:,2) = tempTab{:,2} - unnamed(:,2);
diff(:,3) = tempTab{:,3} - unnamed(:,3);
diff(:,4) = tempTab{:,4} - unnamed(:,4);


%% Recalculating thresholds for subjects 

subjects2 = {'02'; '03'; '04'; '05'; '08'; '09'; '11'; '12'; '13'; '14'; '15'; '17'};

for iSub = 1:length(subjects2)
    subject2 = subjects2{iSub};
    thresholdTable2 = perceptionThreshold2(subject2);
    if iSub == 1
        tempTab = thresholdTable2;
    else 
        tempTab = [tempTab; thresholdTable2];
    end
end
