
clc 
clear

% load('/Volumes/GoogleDrive/Shared drives/Senior Design 2019 - Wearable Sensor/05 - Brainstorming Documentation/PilotData2018/Data/Copy of TiedPre.mat')
% [file,path] = uigetfile('*.mat', 'Pick a .MAT trial file');
% load([path file]) 
load('G:\Shared drives\NeuroMobLab\Experimental Data\Vicon Matlab Processed\Pilot Experiments\WVCTSI_Perception2019\YAPercep13\Session1\Percep01_1.mat');


RHS = rawData.video.GaitEvents.RHStime;
RTO = rawData.video.GaitEvents.RTOtime;
LTO = rawData.video.GaitEvents.LTOtime;
LHS = rawData.video.GaitEvents.LHStime;

GaitEvents = nan(length(LHS),4);

GaitEvents(1,1) = LHS(1);

i=1;
while i<length(LHS)
    try
        % find and store first LTO > most recent RHS
        temp = find(RTO>GaitEvents(i,1));
        GaitEvents(i,2) = RTO(temp(1));
        % find and store first LHS > most recent LTO
        temp = find(RHS>GaitEvents(i,2));
        GaitEvents(i,3) = RHS(temp(1));
        % find and store first RTO > most recent LHS
        temp = find(LTO>GaitEvents(i,3));
        GaitEvents(i,4) = LTO(temp(1));
        % find and store first RHS > most recent RHS
        temp = find(LHS>GaitEvents(i,4));
        i=i+1;
        if ~isempty(temp)
            GaitEvents(i,1) = LHS(temp(1));
        else
            break
        end
    catch
        break
    end
end

figure
hold on
plot(GaitEvents)
legend('LHS','RTO','RHS','LTO')

peaks = find(rawData.analog.other>1.5); 
peaktime = atime(peaks); 
peaktime2 = ceil (peaktime);
peaktime3 = unique (peaktime2);
% Find First Heel Strike 
G1=[];
G2=[];
G3=[];
G4=[];
for i = 1:length(peaktime3) 
    G1(i)= find (LHS > peaktime3(i),1,'first');
end 
A = LHS(G1);
for i = 1:length(peaktime3) 
    G2(i)= find (RTO > A(i),1,'first');
end
B = RTO(G2);
for i = 1:length(peaktime3)
    G3(i)= find (RHS > B(i),1,'first');
end 
C = RHS(G3);
for i = 1:length(peaktime3) 
    G4(i)= find (LTO > C(i),1,'first');
end 
D = LTO(G4); 
G=[A ; B ; C ; D];
sz= size(G); 

% Pos = importdata('/Users/zmarie5/Documents/OSIMPercep/Outputs/YAPercep13/3DGaitModel2392-scaled_YAPercep13_Percep01_1_BodyKinematics_pos_global.sto');
Pos = importdata('G:\Shared drives\NeuroMobLab\Experimental Data\Vicon Processed\Pilot Experiments\WVCTSI_Perception2019\YAPercep13\Session1\Outputs\3DGaitModel2392-scaled_YAPercep13_Percep01_1_BodyKinematics_pos_global.sto');


posTime= Pos.data(:,1);
posX= Pos.data(:,74);
posY= Pos.data(:,75);
posZ= Pos.data(:,76);
times = []; 
events = [GaitEvents(:,1) ;GaitEvents(:,2) ;GaitEvents(:,3) ;GaitEvents(:,4)];
for i = 1:length(GaitEvents)
    if ~isnan(GaitEvents(i,1))  
        T.LHS(i) = find(round(posTime,2) == round(GaitEvents(i,1),2))
%         T.RTO(i) = find(round(posTime,2) == round(GaitEvents(i,2),2))
%         T.RHS(i) = find(round(posTime,2) == round(GaitEvents(i,3),2))
%         T.LTO(i) = find(round(posTime,2) == round(GaitEvents(i,4),2))
    else
    end
end 
posT=[]
posT(1,1) = find (posTime == G(1,1))
posT(2,1) = find (posTime == G(2,1))
posT(3,1) = find (posTime == G(3,1))
posT(4,1) = find (posTime == G(4,1))

posX(posT)

