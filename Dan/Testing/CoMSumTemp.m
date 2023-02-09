%% Temp CoM calculations 
strSubject = '15';

subject1 = ['YAPercep' strSubject];
load(['G:\Shared drives\NeuroMobLab\Projects\Perception\Processed Data\Dan\OpenSim\YAPercep Outputs\' subject1 filesep 'Data Tables' filesep 'SegmentsTables_' subject1 '.mat'])

segNames = {'Pelvis'; 'r_Femur'; 'r_Tibia'; 'r_Talus'; 'r_Calc'; 'r_Toes'; ...
    'l_Femur'; 'l_Tibia'; 'l_Talus'; 'l_Calc'; 'l_Toes'; 'Torso';};

%% Loading the model file since the XML2struct doesn't work 
import org.opensim.modeling.*

modelPath = ['G:\Shared drives\NeuroMobLab\Projects\Perception\Processed Data\Dan\OpenSim\YAPercep Outputs\' subject1 '\Scaled Model\'];
temp = dir(modelPath);
modelFile = temp(3).name;
model = Model([modelPath modelFile]);
references = osimList2MatlabCell(model,'Body');
%% Creating the CoM Table 
nBodies = size(references,1); % Getting the number of bodies in the Model

% CoMTabSize = size(posSegmentsTable);
% CoMTabEmpty = cell(CoMTabSize);
% CoMTab = cell2Table(CoMTabEmpty, 'VariableNames', posSegmentsTable.Properties.VariableNames);
% CoMTab = CoMTab(:,1:end-3);
% CoMTab.Trial = posSegmentsTable.Trial;
% 
% 
% trials = posSegmentsTable.Trial; 
% for iTrial = 1:size(trials,1)
%%
tempSegs = posSegmentsTable.Properties.VariableNames;
tempSegs2 = tempSegs(:,1:end-3);
XSeg = contains(tempSegs2, '_X');
YSeg = contains(tempSegs2, '_Y');
ZSeg = contains(tempSegs2, '_Z');
% for seg = 1:nBodies
    CoM.posX = sum(cell2mat(posSegmentsTable{1, XSeg}),2);
    CoM.posY = sum(cell2mat(posSegmentsTable{1, YSeg}),2);
    CoM.pozZ = sum(cell2mat(posSegmentsTable{1, ZSeg}),2);
    
    CoM.velX = sum(cell2mat(velSegmentsTable{1, XSeg}),2);
    CoM.velY = sum(cell2mat(velSegmentsTable{1, YSeg}),2);
    CoM.velZ = sum(cell2mat(velSegmentsTable{1, ZSeg}),2);
    
    CoM.accX = sum(cell2mat(accSegmentsTable{1, XSeg}),2);
    CoM.accY = sum(cell2mat(accSegmentsTable{1, YSeg}),2);
    CoM.accZ = sum(cell2mat(accSegmentsTable{1, ZSeg}),2);

% end
%         