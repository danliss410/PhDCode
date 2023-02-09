%% This is a quick and dirty for the ankle angle 

IKDir = dir('G:\Shared drives\NeuroMobLab\Projects\Perception\Processed Data\Dan\OpenSim\YAPercep Outputs\YAPercep11\IKResults and Analysis Output\');

IKDir = IKDir(3:end);

for i = 1:length(IKDir)
    IKR(i) = contains(IKDir(i).name, '.mot');
end

IKDir2 = IKDir(IKR);

temp1 = importdata(IKDir2(1).name);
temp2 = importdata(IKDir2(2).name);
temp3 = importdata(IKDir2(3).name);
temp4 = importdata(IKDir2(4).name);

ankle.percep1.L = [temp1.data(:,19);temp2.data(2:end,19);temp3.data(2:end,19);temp4.data(2:end,19)];
ankle.percep1.R = [temp1.data(:,12);temp2.data(2:end,12);temp3.data(2:end,12);temp4.data(2:end,12)];

temp5 = importdata(IKDir2(5).name);
temp6 = importdata(IKDir2(6).name);
temp7 = importdata(IKDir2(7).name);
temp8 = importdata(IKDir2(8).name);
temp9 = importdata(IKDir2(9).name);


ankle.percep2.L = [temp5.data(:,19);temp6.data(2:end,19);temp7.data(2:end,19);temp8.data(2:end,19);temp9.data(2:end,19)];
ankle.percep2.R = [temp5.data(:,12);temp6.data(2:end,12);temp7.data(2:end,12);temp8.data(2:end,12);temp9.data(2:end,12)];

temp10 = importdata(IKDir2(10).name);
temp11 = importdata(IKDir2(11).name);
temp12 = importdata(IKDir2(12).name);
temp13 = importdata(IKDir2(13).name);


ankle.percep3.L = [temp10.data(:,19);temp11.data(2:end,19);temp12.data(2:end,19);temp13.data(2:end,19)];
ankle.percep3.R = [temp10.data(:,12);temp11.data(2:end,12);temp12.data(2:end,12);temp13.data(2:end,12)];


temp14 = importdata(IKDir2(14).name);
temp15 = importdata(IKDir2(15).name);
temp16 = importdata(IKDir2(16).name);
temp17 = importdata(IKDir2(17).name);

ankle.percep4.L = [temp14.data(:,19);temp15.data(2:end,19);temp16.data(2:end,19);temp17.data(2:end,19)];
ankle.percep4.R = [temp14.data(:,12);temp15.data(2:end,12);temp16.data(2:end,12);temp17.data(2:end,12)];

A = pertCycleTable.("Left -1 Cycle Frames"){3,1};
B = pertCycleTable.("Left Cycle Frames Onset"){3,1};
C = pertCycleTable.("Left +1 Cycle Frames"){3,1};
D = pertCycleTable.("Left +2 Cycle Frames"){3,1};


E = pertCycleTable.("Right -1 Cycle Frames"){8,1};
F = pertCycleTable.("Right Cycle Frames Onset"){8,1};
G = pertCycleTable.("Right +1 Cycle Frames"){8,1};
H = pertCycleTable.("Right +2 Cycle Frames"){8,1};


figure; subplot(2,1,1); plot(IKTable.("L Calc Smooth Z"){1,1}); 
hold on; plot(1568:1677, IKTable.("L Calc Smooth Z"){1,1}(1568:1677));
plot(1677:1788, IKTable.("L Calc Smooth Z"){1,1}(1677:1788));
plot(1788:1898, IKTable.("L Calc Smooth Z"){1,1}(1788:1898));
plot(1898:2004, IKTable.("L Calc Smooth Z"){1,1}(1898:2004));
legend;
subplot(2,1,2); plot(ankle.percep1.L(A{1,1}{1,1}(1):A{1,1}{1,1}(5)), 'r');
hold on; plot(ankle.percep1.L(B{1,1}{1,1}(1):B{1,1}{1,1}(5)), 'y');
plot(ankle.percep1.L(C{1,1}{1,1}(1):C{1,1}{1,1}(5)), 'm');
plot(ankle.percep1.L(D{1,1}{1,1}(1):D{1,1}{1,1}(5)), 'g');


figure; subplot(2,1,1); plot(IKTable.("R Calc Smooth Z"){1,1}); 
hold on; plot(E{1,1}{1,2}(1):E{1,1}{1,2}(5), IKTable.("R Calc Smooth Z"){1,1}(E{1,1}{1,2}(1):E{1,1}{1,2}(5)));
plot(F{1,1}{1,2}(1):F{1,1}{1,2}(5), IKTable.("R Calc Smooth Z"){1,1}(F{1,1}{1,2}(1):F{1,1}{1,2}(5)));
plot(G{1,1}{1,2}(1):G{1,1}{1,2}(5), IKTable.("R Calc Smooth Z"){1,1}(G{1,1}{1,2}(1):G{1,1}{1,2}(5)));
plot(H{1,1}{1,2}(1):H{1,1}{1,2}(5), IKTable.("R Calc Smooth Z"){1,1}(H{1,1}{1,2}(1):H{1,1}{1,2}(5)));
legend;
subplot(2,1,2); plot(ankle.percep1.R(E{1,1}{1,1}(1):E{1,1}{1,1}(5)), 'r');
hold on; plot(ankle.percep1.R(F{1,1}{1,1}(1):F{1,1}{1,1}(5)), 'y');
plot(ankle.percep1.R(G{1,1}{1,1}(1):G{1,1}{1,1}(5)), 'm');
plot(ankle.percep1.R(H{1,1}{1,1}(1):H{1,1}{1,1}(5)), 'g');


