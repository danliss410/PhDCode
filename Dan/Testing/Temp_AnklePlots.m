%% Messing around plotting for subject 11 
load('G:\Shared drives\NeuroMobLab\Projects\Perception\Processed Data\Dan\OpenSim\YAPercep Outputs\YAPercep11\Data Tables\jointAnglesTable_YAPercep11.mat')
load('G:\Shared drives\NeuroMobLab\Projects\Perception\Processed Data\Dan\OpenSim\YAPercep Outputs\YAPercep11\Data Tables\SaptiotemporalTable_YAPercep11.mat')
load('G:\Shared drives\NeuroMobLab\Projects\Perception\Processed Data\Dan\OpenSim\YAPercep Outputs\YAPercep11\Data Tables\IKTable_YAPercep11.mat')
load('G:\Shared drives\NeuroMobLab\Projects\Perception\Processed Data\Dan\Matlab Analysis\YAPercep11\Data Tables\pertCycleStruc_YAPercep11.mat')
load('G:\Shared drives\NeuroMobLab\Projects\Perception\Processed Data\Dan\Matlab Analysis\YAPercep11\Data Tables\pertTable_YAPercep11.mat')
load('G:\Shared drives\NeuroMobLab\Projects\Perception\Processed Data\Dan\Matlab Analysis\YAPercep11\Data Tables\SepTables_YAPercep11.mat')


%figure; subplot(3,1,1); plot(jointAnglesTable.("Time (s)"){1,1}, jointAnglesTable.("R Ankle Angle (Degrees)"){1,1}); subplot(3,1,2); plot(jointAnglesTable.("Time (s)"){1,1}, jointAnglesTable.("R Knee Angle (D)"){1,1}); subplot(3,1,3); plot(jointAnglesTable.("Time (s)"){1,1}, jointAnglesTable.("R Hip Flexion Angle (D)"){1,1});



I = pertCycleTable.("Left -2 Cycle Frames"){8,1};
A = pertCycleTable.("Left -1 Cycle Frames"){8,1};
B = pertCycleTable.("Left Cycle Frames Onset"){8,1};
C = pertCycleTable.("Left +1 Cycle Frames"){8,1};
D = pertCycleTable.("Left +2 Cycle Frames"){8,1};
J = pertCycleTable.("Left +3 Cycle Frames"){8,1};
K = pertCycleTable.("Left +4 Cycle Frames"){8,1};





% Left leg plot -0.4 with angles 
figure; subplot(4,1,1); plot(IKTable.("Pos Time (s)"){1,1} ,IKTable.("L Calc Smooth Z"){1,1}); 
hold on; plot(IKTable.("Pos Time (s)"){1,1}(find(IKTable.("Pos Time (s)"){1,1} == I{1,1}{1,1}(1)/100):find(IKTable.("Pos Time (s)"){1,1} == I{1,1}{1,1}(5)/100)), IKTable.("L Calc Smooth Z"){1,1}(find(IKTable.("Pos Time (s)"){1,1} == I{1,1}{1,1}(1)/100):find(IKTable.("Pos Time (s)"){1,1} == I{1,1}{1,1}(5)/100)));
plot(IKTable.("Pos Time (s)"){1,1}(find(IKTable.("Pos Time (s)"){1,1} == A{1,1}{1,1}(1)/100):find(IKTable.("Pos Time (s)"){1,1} == A{1,1}{1,1}(5)/100)), IKTable.("L Calc Smooth Z"){1,1}((find(IKTable.("Pos Time (s)"){1,1} == A{1,1}{1,1}(1)/100):find(IKTable.("Pos Time (s)"){1,1} == A{1,1}{1,1}(5)/100))));
plot(IKTable.("Pos Time (s)"){1,1}(find(IKTable.("Pos Time (s)"){1,1} == B{1,1}{1,1}(1)/100):find(IKTable.("Pos Time (s)"){1,1} == B{1,1}{1,1}(5)/100)), IKTable.("L Calc Smooth Z"){1,1}((find(IKTable.("Pos Time (s)"){1,1} == B{1,1}{1,1}(1)/100):find(IKTable.("Pos Time (s)"){1,1} == B{1,1}{1,1}(5)/100))));
plot(IKTable.("Pos Time (s)"){1,1}(find(IKTable.("Pos Time (s)"){1,1} == C{1,1}{1,1}(1)/100):find(IKTable.("Pos Time (s)"){1,1} == C{1,1}{1,1}(5)/100)), IKTable.("L Calc Smooth Z"){1,1}((find(IKTable.("Pos Time (s)"){1,1} == C{1,1}{1,1}(1)/100):find(IKTable.("Pos Time (s)"){1,1} == C{1,1}{1,1}(5)/100))));
plot(IKTable.("Pos Time (s)"){1,1}(find(IKTable.("Pos Time (s)"){1,1} == D{1,1}{1,1}(1)/100):find(IKTable.("Pos Time (s)"){1,1} == D{1,1}{1,1}(5)/100)), IKTable.("L Calc Smooth Z"){1,1}((find(IKTable.("Pos Time (s)"){1,1} == D{1,1}{1,1}(1)/100):find(IKTable.("Pos Time (s)"){1,1} == D{1,1}{1,1}(5)/100))));
plot(IKTable.("Pos Time (s)"){1,1}(find(IKTable.("Pos Time (s)"){1,1} == J{1,1}{1,1}(1)/100):find(IKTable.("Pos Time (s)"){1,1} == J{1,1}{1,1}(5)/100)), IKTable.("L Calc Smooth Z"){1,1}((find(IKTable.("Pos Time (s)"){1,1} == J{1,1}{1,1}(1)/100):find(IKTable.("Pos Time (s)"){1,1} == J{1,1}{1,1}(5)/100))));
plot(IKTable.("Pos Time (s)"){1,1}(find(IKTable.("Pos Time (s)"){1,1} == K{1,1}{1,1}(1)/100):find(IKTable.("Pos Time (s)"){1,1} == K{1,1}{1,1}(5)/100)), IKTable.("L Calc Smooth Z"){1,1}((find(IKTable.("Pos Time (s)"){1,1} == K{1,1}{1,1}(1)/100):find(IKTable.("Pos Time (s)"){1,1} == K{1,1}{1,1}(5)/100))));
legend({'Calc Vel';'-2'; '-1'; 'Onset'; '+1'; '+2'; '+3'; '+4'});

subplot(4,1,2); plot(jointAnglesTable.("Time (s)"){1,1}, jointAnglesTable.("L Ankle Angle (D)"){1,1});
hold on; plot(jointAnglesTable.("Time (s)"){1,1}(find(jointAnglesTable.("Time (s)"){1,1} == I{1,1}{1,1}(1)/100):find(jointAnglesTable.("Time (s)"){1,1} == I{1,1}{1,1}(5)/100)), jointAnglesTable.("L Ankle Angle (D)"){1,1}((find(jointAnglesTable.("Time (s)"){1,1} == I{1,1}{1,1}(1)/100):find(jointAnglesTable.("Time (s)"){1,1} == I{1,1}{1,1}(5)/100))));
plot(jointAnglesTable.("Time (s)"){1,1}(find(jointAnglesTable.("Time (s)"){1,1} == A{1,1}{1,1}(1)/100):find(jointAnglesTable.("Time (s)"){1,1} == A{1,1}{1,1}(5)/100)), jointAnglesTable.("L Ankle Angle (D)"){1,1}((find(jointAnglesTable.("Time (s)"){1,1} == A{1,1}{1,1}(1)/100):find(jointAnglesTable.("Time (s)"){1,1} == A{1,1}{1,1}(5)/100))));
plot(jointAnglesTable.("Time (s)"){1,1}(find(jointAnglesTable.("Time (s)"){1,1} == B{1,1}{1,1}(1)/100):find(jointAnglesTable.("Time (s)"){1,1} == B{1,1}{1,1}(5)/100)), jointAnglesTable.("L Ankle Angle (D)"){1,1}((find(jointAnglesTable.("Time (s)"){1,1} == B{1,1}{1,1}(1)/100):find(jointAnglesTable.("Time (s)"){1,1} == B{1,1}{1,1}(5)/100))));
plot(jointAnglesTable.("Time (s)"){1,1}(find(jointAnglesTable.("Time (s)"){1,1} == C{1,1}{1,1}(1)/100):find(jointAnglesTable.("Time (s)"){1,1} == C{1,1}{1,1}(5)/100)), jointAnglesTable.("L Ankle Angle (D)"){1,1}((find(jointAnglesTable.("Time (s)"){1,1} == C{1,1}{1,1}(1)/100):find(jointAnglesTable.("Time (s)"){1,1} == C{1,1}{1,1}(5)/100))));
plot(jointAnglesTable.("Time (s)"){1,1}(find(jointAnglesTable.("Time (s)"){1,1} == D{1,1}{1,1}(1)/100):find(jointAnglesTable.("Time (s)"){1,1} == D{1,1}{1,1}(5)/100)), jointAnglesTable.("L Ankle Angle (D)"){1,1}((find(jointAnglesTable.("Time (s)"){1,1} == D{1,1}{1,1}(1)/100):find(jointAnglesTable.("Time (s)"){1,1} == D{1,1}{1,1}(5)/100))));
plot(jointAnglesTable.("Time (s)"){1,1}(find(jointAnglesTable.("Time (s)"){1,1} == J{1,1}{1,1}(1)/100):find(jointAnglesTable.("Time (s)"){1,1} == J{1,1}{1,1}(5)/100)), jointAnglesTable.("L Ankle Angle (D)"){1,1}((find(jointAnglesTable.("Time (s)"){1,1} == J{1,1}{1,1}(1)/100):find(jointAnglesTable.("Time (s)"){1,1} == J{1,1}{1,1}(5)/100))));
plot(jointAnglesTable.("Time (s)"){1,1}(find(jointAnglesTable.("Time (s)"){1,1} == K{1,1}{1,1}(1)/100):find(jointAnglesTable.("Time (s)"){1,1} == K{1,1}{1,1}(5)/100)), jointAnglesTable.("L Ankle Angle (D)"){1,1}((find(jointAnglesTable.("Time (s)"){1,1} == K{1,1}{1,1}(1)/100):find(jointAnglesTable.("Time (s)"){1,1} == K{1,1}{1,1}(5)/100))));
legend({'L Ankle Angle';'-2'; '-1'; 'Onset'; '+1'; '+2'; '+3'; '+4'});

subplot(4,1,3); plot(jointAnglesTable.("Time (s)"){1,1}, jointAnglesTable.("L Knee Angle (D)"){1,1});
hold on; plot(jointAnglesTable.("Time (s)"){1,1}(find(jointAnglesTable.("Time (s)"){1,1} == I{1,1}{1,1}(1)/100):find(jointAnglesTable.("Time (s)"){1,1} == I{1,1}{1,1}(5)/100)), jointAnglesTable.("L Knee Angle (D)"){1,1}((find(jointAnglesTable.("Time (s)"){1,1} == I{1,1}{1,1}(1)/100):find(jointAnglesTable.("Time (s)"){1,1} == I{1,1}{1,1}(5)/100))));
plot(jointAnglesTable.("Time (s)"){1,1}(find(jointAnglesTable.("Time (s)"){1,1} == A{1,1}{1,1}(1)/100):find(jointAnglesTable.("Time (s)"){1,1} == A{1,1}{1,1}(5)/100)), jointAnglesTable.("L Knee Angle (D)"){1,1}((find(jointAnglesTable.("Time (s)"){1,1} == A{1,1}{1,1}(1)/100):find(jointAnglesTable.("Time (s)"){1,1} == A{1,1}{1,1}(5)/100))));
plot(jointAnglesTable.("Time (s)"){1,1}(find(jointAnglesTable.("Time (s)"){1,1} == B{1,1}{1,1}(1)/100):find(jointAnglesTable.("Time (s)"){1,1} == B{1,1}{1,1}(5)/100)), jointAnglesTable.("L Knee Angle (D)"){1,1}((find(jointAnglesTable.("Time (s)"){1,1} == B{1,1}{1,1}(1)/100):find(jointAnglesTable.("Time (s)"){1,1} == B{1,1}{1,1}(5)/100))));
plot(jointAnglesTable.("Time (s)"){1,1}(find(jointAnglesTable.("Time (s)"){1,1} == C{1,1}{1,1}(1)/100):find(jointAnglesTable.("Time (s)"){1,1} == C{1,1}{1,1}(5)/100)), jointAnglesTable.("L Knee Angle (D)"){1,1}((find(jointAnglesTable.("Time (s)"){1,1} == C{1,1}{1,1}(1)/100):find(jointAnglesTable.("Time (s)"){1,1} == C{1,1}{1,1}(5)/100))));
plot(jointAnglesTable.("Time (s)"){1,1}(find(jointAnglesTable.("Time (s)"){1,1} == D{1,1}{1,1}(1)/100):find(jointAnglesTable.("Time (s)"){1,1} == D{1,1}{1,1}(5)/100)), jointAnglesTable.("L Knee Angle (D)"){1,1}((find(jointAnglesTable.("Time (s)"){1,1} == D{1,1}{1,1}(1)/100):find(jointAnglesTable.("Time (s)"){1,1} == D{1,1}{1,1}(5)/100))));
plot(jointAnglesTable.("Time (s)"){1,1}(find(jointAnglesTable.("Time (s)"){1,1} == J{1,1}{1,1}(1)/100):find(jointAnglesTable.("Time (s)"){1,1} == J{1,1}{1,1}(5)/100)), jointAnglesTable.("L Knee Angle (D)"){1,1}((find(jointAnglesTable.("Time (s)"){1,1} == J{1,1}{1,1}(1)/100):find(jointAnglesTable.("Time (s)"){1,1} == J{1,1}{1,1}(5)/100))));
plot(jointAnglesTable.("Time (s)"){1,1}(find(jointAnglesTable.("Time (s)"){1,1} == K{1,1}{1,1}(1)/100):find(jointAnglesTable.("Time (s)"){1,1} == K{1,1}{1,1}(5)/100)), jointAnglesTable.("L Knee Angle (D)"){1,1}((find(jointAnglesTable.("Time (s)"){1,1} == K{1,1}{1,1}(1)/100):find(jointAnglesTable.("Time (s)"){1,1} == K{1,1}{1,1}(5)/100))));
legend({'L Knee Angle';'-2'; '-1'; 'Onset'; '+1'; '+2'; '+3'; '+4'});

subplot(4,1,4); plot(jointAnglesTable.("Time (s)"){1,1}, jointAnglesTable.("L Hip Flexion Angle (D)"){1,1});
hold on; plot(jointAnglesTable.("Time (s)"){1,1}(find(jointAnglesTable.("Time (s)"){1,1} == I{1,1}{1,1}(1)/100):find(jointAnglesTable.("Time (s)"){1,1} == I{1,1}{1,1}(5)/100)), jointAnglesTable.("L Hip Flexion Angle (D)"){1,1}((find(jointAnglesTable.("Time (s)"){1,1} == I{1,1}{1,1}(1)/100):find(jointAnglesTable.("Time (s)"){1,1} == I{1,1}{1,1}(5)/100))));
plot(jointAnglesTable.("Time (s)"){1,1}(find(jointAnglesTable.("Time (s)"){1,1} == A{1,1}{1,1}(1)/100):find(jointAnglesTable.("Time (s)"){1,1} == A{1,1}{1,1}(5)/100)), jointAnglesTable.("L Hip Flexion Angle (D)"){1,1}((find(jointAnglesTable.("Time (s)"){1,1} == A{1,1}{1,1}(1)/100):find(jointAnglesTable.("Time (s)"){1,1} == A{1,1}{1,1}(5)/100))));
plot(jointAnglesTable.("Time (s)"){1,1}(find(jointAnglesTable.("Time (s)"){1,1} == B{1,1}{1,1}(1)/100):find(jointAnglesTable.("Time (s)"){1,1} == B{1,1}{1,1}(5)/100)), jointAnglesTable.("L Hip Flexion Angle (D)"){1,1}((find(jointAnglesTable.("Time (s)"){1,1} == B{1,1}{1,1}(1)/100):find(jointAnglesTable.("Time (s)"){1,1} == B{1,1}{1,1}(5)/100))));
plot(jointAnglesTable.("Time (s)"){1,1}(find(jointAnglesTable.("Time (s)"){1,1} == C{1,1}{1,1}(1)/100):find(jointAnglesTable.("Time (s)"){1,1} == C{1,1}{1,1}(5)/100)), jointAnglesTable.("L Hip Flexion Angle (D)"){1,1}((find(jointAnglesTable.("Time (s)"){1,1} == C{1,1}{1,1}(1)/100):find(jointAnglesTable.("Time (s)"){1,1} == C{1,1}{1,1}(5)/100))));
plot(jointAnglesTable.("Time (s)"){1,1}(find(jointAnglesTable.("Time (s)"){1,1} == D{1,1}{1,1}(1)/100):find(jointAnglesTable.("Time (s)"){1,1} == D{1,1}{1,1}(5)/100)), jointAnglesTable.("L Hip Flexion Angle (D)"){1,1}((find(jointAnglesTable.("Time (s)"){1,1} == D{1,1}{1,1}(1)/100):find(jointAnglesTable.("Time (s)"){1,1} == D{1,1}{1,1}(5)/100))));
plot(jointAnglesTable.("Time (s)"){1,1}(find(jointAnglesTable.("Time (s)"){1,1} == J{1,1}{1,1}(1)/100):find(jointAnglesTable.("Time (s)"){1,1} == J{1,1}{1,1}(5)/100)), jointAnglesTable.("L Hip Flexion Angle (D)"){1,1}((find(jointAnglesTable.("Time (s)"){1,1} == J{1,1}{1,1}(1)/100):find(jointAnglesTable.("Time (s)"){1,1} == J{1,1}{1,1}(5)/100))));
plot(jointAnglesTable.("Time (s)"){1,1}(find(jointAnglesTable.("Time (s)"){1,1} == K{1,1}{1,1}(1)/100):find(jointAnglesTable.("Time (s)"){1,1} == K{1,1}{1,1}(5)/100)), jointAnglesTable.("L Hip Flexion Angle (D)"){1,1}((find(jointAnglesTable.("Time (s)"){1,1} == K{1,1}{1,1}(1)/100):find(jointAnglesTable.("Time (s)"){1,1} == K{1,1}{1,1}(5)/100))));
legend({'L Hip Flexion Angle';'-2'; '-1'; 'Onset'; '+1'; '+2'; '+3'; '+4'});

%%
L = pertCycleTable.("Right -2 Cycle Frames"){4,1};
E = pertCycleTable.("Right -1 Cycle Frames"){4,1};
F = pertCycleTable.("Right Cycle Frames Onset"){4,1};
G = pertCycleTable.("Right +1 Cycle Frames"){4,1};
H = pertCycleTable.("Right +2 Cycle Frames"){4,1};
M = pertCycleTable.("Right +3 Cycle Frames"){4,1};
N = pertCycleTable.("Right +4 Cycle Frames"){4,1};

temp0 = find(round(jointAnglesTable.("Time (s)"){1,1},2) == L{1,1}{1,1}(1)/100);
temp1 = find(round(jointAnglesTable.("Time (s)"){1,1},2) == L{1,1}{1,1}(5)/100);
temp2 = find(round(jointAnglesTable.("Time (s)"){1,1},2) == E{1,1}{1,1}(1)/100);
temp3 = find(round(jointAnglesTable.("Time (s)"){1,1},2) == E{1,1}{1,1}(5)/100);
temp4 = find(round(jointAnglesTable.("Time (s)"){1,1},2) == F{1,1}{1,1}(1)/100);
temp5 = find(round(jointAnglesTable.("Time (s)"){1,1},2) == F{1,1}{1,1}(5)/100);
temp6 = find(round(jointAnglesTable.("Time (s)"){1,1},2) == G{1,1}{1,1}(1)/100);
temp7 = find(round(jointAnglesTable.("Time (s)"){1,1},2) == G{1,1}{1,1}(5)/100);
temp8 = find(round(jointAnglesTable.("Time (s)"){1,1},2) == H{1,1}{1,1}(1)/100);
temp9 = find(round(jointAnglesTable.("Time (s)"){1,1},2) == H{1,1}{1,1}(5)/100);
temp10 = find(round(jointAnglesTable.("Time (s)"){1,1},2) == M{1,1}{1,1}(1)/100);
temp11 = find(round(jointAnglesTable.("Time (s)"){1,1},2) == M{1,1}{1,1}(5)/100);
temp12 = find(round(jointAnglesTable.("Time (s)"){1,1},2) == N{1,1}{1,1}(1)/100);
temp13 = find(round(jointAnglesTable.("Time (s)"){1,1},2) == N{1,1}{1,1}(5)/100);

temp14 = find(round(IKTable.("Pos Time (s)"){1,1},2) == L{1,1}{1,1}(1)/100);
temp15 = find(round(IKTable.("Pos Time (s)"){1,1},2) == L{1,1}{1,1}(5)/100);
temp16 = find(round(IKTable.("Pos Time (s)"){1,1},2) == E{1,1}{1,1}(1)/100);
temp17 = find(round(IKTable.("Pos Time (s)"){1,1},2) == E{1,1}{1,1}(5)/100);
temp18 = find(round(IKTable.("Pos Time (s)"){1,1},2) == F{1,1}{1,1}(1)/100);
temp19 = find(round(IKTable.("Pos Time (s)"){1,1},2) == F{1,1}{1,1}(5)/100);
temp20 = find(round(IKTable.("Pos Time (s)"){1,1},2) == G{1,1}{1,1}(1)/100);
temp21 = find(round(IKTable.("Pos Time (s)"){1,1},2) == G{1,1}{1,1}(5)/100);
temp22 = find(round(IKTable.("Pos Time (s)"){1,1},2) == H{1,1}{1,1}(1)/100);
temp23 = find(round(IKTable.("Pos Time (s)"){1,1},2) == H{1,1}{1,1}(5)/100);
temp24 = find(round(IKTable.("Pos Time (s)"){1,1},2) == M{1,1}{1,1}(1)/100);
temp25 = find(round(IKTable.("Pos Time (s)"){1,1},2) == M{1,1}{1,1}(5)/100);
temp26 = find(round(IKTable.("Pos Time (s)"){1,1},2) == N{1,1}{1,1}(1)/100);
temp27 = find(round(IKTable.("Pos Time (s)"){1,1},2) == N{1,1}{1,1}(5)/100);



% Right leg plot -0.1
figure; subplot(4,1,1); plot(IKTable.("Pos Time (s)"){1,1} ,IKTable.("R Calc Smooth Z"){1,1}); 
hold on; plot(IKTable.("Pos Time (s)"){1,1}(temp14:temp15), IKTable.("R Calc Smooth Z"){1,1}(temp14:temp15),'r');
plot(IKTable.("Pos Time (s)"){1,1}(temp16:temp17), IKTable.("R Calc Smooth Z"){1,1}(temp16:temp17),'y');
plot(IKTable.("Pos Time (s)"){1,1}(temp18:temp19), IKTable.("R Calc Smooth Z"){1,1}(temp18:temp19), 'k');
plot(IKTable.("Pos Time (s)"){1,1}(temp20:temp21), IKTable.("R Calc Smooth Z"){1,1}(temp20:temp21),'c');
plot(IKTable.("Pos Time (s)"){1,1}(temp22:temp23), IKTable.("R Calc Smooth Z"){1,1}(temp22:temp23),'m');
plot(IKTable.("Pos Time (s)"){1,1}(temp24:temp25), IKTable.("R Calc Smooth Z"){1,1}(temp24:temp25),'g');
plot(IKTable.("Pos Time (s)"){1,1}(temp26:temp27), IKTable.("R Calc Smooth Z"){1,1}(temp26:temp27),'r--');
legend({'R Calc Vel';'-2'; '-1'; 'Onset'; '+1'; '+2'; '+3'; '+4'});

subplot(4,1,2); plot(jointAnglesTable.("Time (s)"){1,1}, jointAnglesTable.("R Ankle Angle (Degrees)"){1,1});
hold on; plot(jointAnglesTable.("Time (s)"){1,1}(temp0:temp1), jointAnglesTable.("R Ankle Angle (Degrees)"){1,1}(temp0:temp1),'r');
plot(jointAnglesTable.("Time (s)"){1,1}(temp2:temp3), jointAnglesTable.("R Ankle Angle (Degrees)"){1,1}(temp2:temp3), 'y');
plot(jointAnglesTable.("Time (s)"){1,1}(temp4:temp5), jointAnglesTable.("R Ankle Angle (Degrees)"){1,1}(temp4:temp5),'k');
plot(jointAnglesTable.("Time (s)"){1,1}(temp6:temp7), jointAnglesTable.("R Ankle Angle (Degrees)"){1,1}(temp6:temp7),'c');
plot(jointAnglesTable.("Time (s)"){1,1}(temp8:temp9), jointAnglesTable.("R Ankle Angle (Degrees)"){1,1}(temp8:temp9),'m');
plot(jointAnglesTable.("Time (s)"){1,1}(temp10:temp11), jointAnglesTable.("R Ankle Angle (Degrees)"){1,1}(temp10:temp11),'g');
plot(jointAnglesTable.("Time (s)"){1,1}(temp12:temp13), jointAnglesTable.("R Ankle Angle (Degrees)"){1,1}(temp12:temp13),'r--');
legend({'R Ankle Angle';'-2'; '-1'; 'Onset'; '+1'; '+2'; '+3'; '+4'});

subplot(4,1,3); plot(jointAnglesTable.("Time (s)"){1,1}, jointAnglesTable.("R Knee Angle (D)"){1,1});
hold on; plot(jointAnglesTable.("Time (s)"){1,1}(temp0:temp1), jointAnglesTable.("R Knee Angle (D)"){1,1}(temp0:temp1),'r');
plot(jointAnglesTable.("Time (s)"){1,1}(temp2:temp3), jointAnglesTable.("R Knee Angle (D)"){1,1}(temp2:temp3), 'y');
plot(jointAnglesTable.("Time (s)"){1,1}(temp4:temp5), jointAnglesTable.("R Knee Angle (D)"){1,1}(temp4:temp5),'k');
plot(jointAnglesTable.("Time (s)"){1,1}(temp6:temp7), jointAnglesTable.("R Knee Angle (D)"){1,1}(temp6:temp7),'c');
plot(jointAnglesTable.("Time (s)"){1,1}(temp8:temp9), jointAnglesTable.("R Knee Angle (D)"){1,1}(temp8:temp9),'m');
plot(jointAnglesTable.("Time (s)"){1,1}(temp10:temp11), jointAnglesTable.("R Knee Angle (D)"){1,1}(temp10:temp11),'g');
plot(jointAnglesTable.("Time (s)"){1,1}(temp12:temp13), jointAnglesTable.("R Knee Angle (D)"){1,1}(temp12:temp13),'r--');
legend({'R Knee Angle';'-2'; '-1'; 'Onset'; '+1'; '+2'; '+3'; '+4'});

subplot(4,1,4); plot(jointAnglesTable.("Time (s)"){1,1}, jointAnglesTable.("R Hip Flexion Angle (D)"){1,1});
hold on; plot(jointAnglesTable.("Time (s)"){1,1}(temp0:temp1), jointAnglesTable.("R Hip Flexion Angle (D)"){1,1}(temp0:temp1),'r');
plot(jointAnglesTable.("Time (s)"){1,1}(temp2:temp3), jointAnglesTable.("R Hip Flexion Angle (D)"){1,1}(temp2:temp3), 'y');
plot(jointAnglesTable.("Time (s)"){1,1}(temp4:temp5), jointAnglesTable.("R Hip Flexion Angle (D)"){1,1}(temp4:temp5),'k');
plot(jointAnglesTable.("Time (s)"){1,1}(temp6:temp7), jointAnglesTable.("R Hip Flexion Angle (D)"){1,1}(temp6:temp7),'c');
plot(jointAnglesTable.("Time (s)"){1,1}(temp8:temp9), jointAnglesTable.("R Hip Flexion Angle (D)"){1,1}(temp8:temp9),'m');
plot(jointAnglesTable.("Time (s)"){1,1}(temp10:temp11), jointAnglesTable.("R Hip Flexion Angle (D)"){1,1}(temp10:temp11),'g');
plot(jointAnglesTable.("Time (s)"){1,1}(temp12:temp13), jointAnglesTable.("R Hip Flexion Angle (D)"){1,1}(temp12:temp13),'r--');
legend({'R Hip Flexion Angle';'-2'; '-1'; 'Onset'; '+1'; '+2'; '+3'; '+4'});



temp0 = find(round(jointAnglesTable.("Time (s)"){1,1},2) == L{1,1}{1,2}(1)/100);
temp1 = find(round(jointAnglesTable.("Time (s)"){1,1},2) == L{1,1}{1,2}(5)/100);
temp2 = find(round(jointAnglesTable.("Time (s)"){1,1},2) == E{1,1}{1,2}(1)/100);
temp3 = find(round(jointAnglesTable.("Time (s)"){1,1},2) == E{1,1}{1,2}(5)/100);
temp4 = find(round(jointAnglesTable.("Time (s)"){1,1},2) == F{1,1}{1,2}(1)/100);
temp5 = find(round(jointAnglesTable.("Time (s)"){1,1},2) == F{1,1}{1,2}(5)/100);
temp6 = find(round(jointAnglesTable.("Time (s)"){1,1},2) == G{1,1}{1,2}(1)/100);
temp7 = find(round(jointAnglesTable.("Time (s)"){1,1},2) == G{1,1}{1,2}(5)/100);
temp8 = find(round(jointAnglesTable.("Time (s)"){1,1},2) == H{1,1}{1,2}(1)/100);
temp9 = find(round(jointAnglesTable.("Time (s)"){1,1},2) == H{1,1}{1,2}(5)/100);
temp10 = find(round(jointAnglesTable.("Time (s)"){1,1},2) == M{1,1}{1,2}(1)/100);
temp11 = find(round(jointAnglesTable.("Time (s)"){1,1},2) == M{1,1}{1,2}(5)/100);
temp12 = find(round(jointAnglesTable.("Time (s)"){1,1},2) == N{1,1}{1,2}(1)/100);
temp13 = find(round(jointAnglesTable.("Time (s)"){1,1},2) == N{1,1}{1,2}(5)/100);

temp14 = find(round(IKTable.("Pos Time (s)"){1,1},2) == L{1,1}{1,2}(1)/100);
temp15 = find(round(IKTable.("Pos Time (s)"){1,1},2) == L{1,1}{1,2}(5)/100);
temp16 = find(round(IKTable.("Pos Time (s)"){1,1},2) == E{1,1}{1,2}(1)/100);
temp17 = find(round(IKTable.("Pos Time (s)"){1,1},2) == E{1,1}{1,2}(5)/100);
temp18 = find(round(IKTable.("Pos Time (s)"){1,1},2) == F{1,1}{1,2}(1)/100);
temp19 = find(round(IKTable.("Pos Time (s)"){1,1},2) == F{1,1}{1,2}(5)/100);
temp20 = find(round(IKTable.("Pos Time (s)"){1,1},2) == G{1,1}{1,2}(1)/100);
temp21 = find(round(IKTable.("Pos Time (s)"){1,1},2) == G{1,1}{1,2}(5)/100);
temp22 = find(round(IKTable.("Pos Time (s)"){1,1},2) == H{1,1}{1,2}(1)/100);
temp23 = find(round(IKTable.("Pos Time (s)"){1,1},2) == H{1,1}{1,2}(5)/100);
temp24 = find(round(IKTable.("Pos Time (s)"){1,1},2) == M{1,1}{1,2}(1)/100);
temp25 = find(round(IKTable.("Pos Time (s)"){1,1},2) == M{1,1}{1,2}(5)/100);
temp26 = find(round(IKTable.("Pos Time (s)"){1,1},2) == N{1,1}{1,2}(1)/100);
temp27 = find(round(IKTable.("Pos Time (s)"){1,1},2) == N{1,1}{1,2}(5)/100);


subplot(4,1,1); %subplot(4,1,1); plot(IKTable.("Pos Time (s)"){1,1} ,IKTable.("R Calc Smooth Z"){1,1}); 
hold on; plot(IKTable.("Pos Time (s)"){1,1}(temp14:temp15), IKTable.("R Calc Smooth Z"){1,1}(temp14:temp15),'r');
plot(IKTable.("Pos Time (s)"){1,1}(temp16:temp17), IKTable.("R Calc Smooth Z"){1,1}(temp16:temp17),'y');
plot(IKTable.("Pos Time (s)"){1,1}(temp18:temp19), IKTable.("R Calc Smooth Z"){1,1}(temp18:temp19), 'k');
plot(IKTable.("Pos Time (s)"){1,1}(temp20:temp21), IKTable.("R Calc Smooth Z"){1,1}(temp20:temp21),'c');
plot(IKTable.("Pos Time (s)"){1,1}(temp22:temp23), IKTable.("R Calc Smooth Z"){1,1}(temp22:temp23),'m');
plot(IKTable.("Pos Time (s)"){1,1}(temp24:temp25), IKTable.("R Calc Smooth Z"){1,1}(temp24:temp25),'g');
plot(IKTable.("Pos Time (s)"){1,1}(temp26:temp27), IKTable.("R Calc Smooth Z"){1,1}(temp26:temp27),'r--');
legend({'R Calc Vel';'-2'; '-1'; 'Onset'; '+1'; '+2'; '+3'; '+4'});

subplot(4,1,2); %plot(jointAnglesTable.("Time (s)"){1,1}, jointAnglesTable.("R Ankle Angle (Degrees)"){1,1});
hold on; plot(jointAnglesTable.("Time (s)"){1,1}(temp0:temp1), jointAnglesTable.("R Ankle Angle (Degrees)"){1,1}(temp0:temp1),'r');
plot(jointAnglesTable.("Time (s)"){1,1}(temp2:temp3), jointAnglesTable.("R Ankle Angle (Degrees)"){1,1}(temp2:temp3), 'y');
plot(jointAnglesTable.("Time (s)"){1,1}(temp4:temp5), jointAnglesTable.("R Ankle Angle (Degrees)"){1,1}(temp4:temp5),'k');
plot(jointAnglesTable.("Time (s)"){1,1}(temp6:temp7), jointAnglesTable.("R Ankle Angle (Degrees)"){1,1}(temp6:temp7),'c');
plot(jointAnglesTable.("Time (s)"){1,1}(temp8:temp9), jointAnglesTable.("R Ankle Angle (Degrees)"){1,1}(temp8:temp9),'m');
plot(jointAnglesTable.("Time (s)"){1,1}(temp10:temp11), jointAnglesTable.("R Ankle Angle (Degrees)"){1,1}(temp10:temp11),'g');
plot(jointAnglesTable.("Time (s)"){1,1}(temp12:temp13), jointAnglesTable.("R Ankle Angle (Degrees)"){1,1}(temp12:temp13),'r--');
legend({'R Ankle Angle';'-2'; '-1'; 'Onset'; '+1'; '+2'; '+3'; '+4'});

subplot(4,1,3); %plot(jointAnglesTable.("Time (s)"){1,1}, jointAnglesTable.("R Knee Angle (D)"){1,1});
hold on; plot(jointAnglesTable.("Time (s)"){1,1}(temp0:temp1), jointAnglesTable.("R Knee Angle (D)"){1,1}(temp0:temp1),'r');
plot(jointAnglesTable.("Time (s)"){1,1}(temp2:temp3), jointAnglesTable.("R Knee Angle (D)"){1,1}(temp2:temp3), 'y');
plot(jointAnglesTable.("Time (s)"){1,1}(temp4:temp5), jointAnglesTable.("R Knee Angle (D)"){1,1}(temp4:temp5),'k');
plot(jointAnglesTable.("Time (s)"){1,1}(temp6:temp7), jointAnglesTable.("R Knee Angle (D)"){1,1}(temp6:temp7),'c');
plot(jointAnglesTable.("Time (s)"){1,1}(temp8:temp9), jointAnglesTable.("R Knee Angle (D)"){1,1}(temp8:temp9),'m');
plot(jointAnglesTable.("Time (s)"){1,1}(temp10:temp11), jointAnglesTable.("R Knee Angle (D)"){1,1}(temp10:temp11),'g');
plot(jointAnglesTable.("Time (s)"){1,1}(temp12:temp13), jointAnglesTable.("R Knee Angle (D)"){1,1}(temp12:temp13),'r--');
legend({'R Knee Angle';'-2'; '-1'; 'Onset'; '+1'; '+2'; '+3'; '+4'});

subplot(4,1,4); %plot(jointAnglesTable.("Time (s)"){1,1}, jointAnglesTable.("R Hip Flexion Angle (D)"){1,1});
hold on; plot(jointAnglesTable.("Time (s)"){1,1}(temp0:temp1), jointAnglesTable.("R Hip Flexion Angle (D)"){1,1}(temp0:temp1),'r');
plot(jointAnglesTable.("Time (s)"){1,1}(temp2:temp3), jointAnglesTable.("R Hip Flexion Angle (D)"){1,1}(temp2:temp3), 'y');
plot(jointAnglesTable.("Time (s)"){1,1}(temp4:temp5), jointAnglesTable.("R Hip Flexion Angle (D)"){1,1}(temp4:temp5),'k');
plot(jointAnglesTable.("Time (s)"){1,1}(temp6:temp7), jointAnglesTable.("R Hip Flexion Angle (D)"){1,1}(temp6:temp7),'c');
plot(jointAnglesTable.("Time (s)"){1,1}(temp8:temp9), jointAnglesTable.("R Hip Flexion Angle (D)"){1,1}(temp8:temp9),'m');
plot(jointAnglesTable.("Time (s)"){1,1}(temp10:temp11), jointAnglesTable.("R Hip Flexion Angle (D)"){1,1}(temp10:temp11),'g');
plot(jointAnglesTable.("Time (s)"){1,1}(temp12:temp13), jointAnglesTable.("R Hip Flexion Angle (D)"){1,1}(temp12:temp13),'r--');
legend({'R Hip Flexion Angle';'-2'; '-1'; 'Onset'; '+1'; '+2'; '+3'; '+4'});
