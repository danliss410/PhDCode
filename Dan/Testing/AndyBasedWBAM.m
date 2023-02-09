%% This is an attempt to use Andy's process to calculate WBAM 
% This section will load the GUI calculated BodyKinematics based on Andy's
% XML file 
% filePath = 'G:\Shared drives\NeuroMobLab\Projects\Perception\Processed
% Data\Dan\OpenSim\YAPercep Outputs\YAPercep05\TestIKandAnalysis\'; This is
% the new data that I ran with the rescaled model
clear 
home

strSubject = '05';
% filePath = 'G:\Shared drives\NeuroMobLab\Projects\Perception\Processed Data\Dan\OpenSim\YAPercep Outputs\YAPercep05\TestIKandAnalysis\';
filePath = ['G:\Shared drives\NeuroMobLab\Projects\Perception\Processed Data\Dan\OpenSim\YAPercep Outputs\YAPercep' strSubject '\Test IKResults and Analysis Output\'];


[BK_P_Table]=Osim.readSTO([filePath 'Treadmill01' '_markers_rotated_ik' '_BodyKinematics_pos_global.sto']);
[BK_V_Table]=Osim.readSTO([filePath 'Treadmill01' '_markers_rotated_ik' '_BodyKinematics_vel_global.sto']);
[BK_A_Table]=Osim.readSTO([filePath 'Treadmill01' '_markers_rotated_ik' '_BodyKinematics_acc_global.sto']);
% 
% %Make table with center of mass position, vel, acc
% [BK_P_Table1]=Osim.readSTO([filePath 'Percep02_1' '_markers_rotated_ik' '_BodyKinematics_pos_global.sto']);
% [BK_V_Table1]=Osim.readSTO([filePath 'Percep02_1' '_markers_rotated_ik' '_BodyKinematics_vel_global.sto']);
% [BK_A_Table1]=Osim.readSTO([filePath 'Percep02_1' '_markers_rotated_ik' '_BodyKinematics_acc_global.sto']);
% 
% 
% [BK_P_Table2]=Osim.readSTO([filePath 'Percep02_2' '_markers_rotated_ik' '_BodyKinematics_pos_global.sto']);
% [BK_V_Table2]=Osim.readSTO([filePath 'Percep02_2' '_markers_rotated_ik' '_BodyKinematics_vel_global.sto']);
% [BK_A_Table2]=Osim.readSTO([filePath 'Percep02_2' '_markers_rotated_ik' '_BodyKinematics_acc_global.sto']);
% 
% 
% [BK_P_Table3]=Osim.readSTO([filePath 'Percep02_3' '_markers_rotated_ik' '_BodyKinematics_pos_global.sto']);
% [BK_V_Table3]=Osim.readSTO([filePath 'Percep02_3' '_markers_rotated_ik' '_BodyKinematics_vel_global.sto']);
% [BK_A_Table3]=Osim.readSTO([filePath 'Percep02_3' '_markers_rotated_ik' '_BodyKinematics_acc_global.sto']);
% 
% 
% [BK_P_Table4]=Osim.readSTO([filePath 'Percep02_4' '_markers_rotated_ik'  '_BodyKinematics_pos_global.sto']);
% [BK_V_Table4]=Osim.readSTO([filePath 'Percep02_4' '_markers_rotated_ik' '_BodyKinematics_vel_global.sto']);
% [BK_A_Table4]=Osim.readSTO([filePath 'Percep02_4' '_markers_rotated_ik' '_BodyKinematics_acc_global.sto']);
% 
% 
% [BK_P_Table5]=Osim.readSTO([filePath 'Percep02_5' '_markers_rotated_ik' '_BodyKinematics_pos_global.sto']);
% [BK_V_Table5]=Osim.readSTO([filePath 'Percep02_5' '_markers_rotated_ik' '_BodyKinematics_vel_global.sto']);
% [BK_A_Table5]=Osim.readSTO([filePath 'Percep02_5' '_markers_rotated_ik' '_BodyKinematics_acc_global.sto']);
% 
% 
% [BK_P_Table6]=Osim.readSTO([filePath 'Percep02_6' '_markers_rotated_ik' '_BodyKinematics_pos_global.sto']);
% [BK_V_Table6]=Osim.readSTO([filePath 'Percep02_6' '_markers_rotated_ik' '_BodyKinematics_vel_global.sto']);
% [BK_A_Table6]=Osim.readSTO([filePath 'Percep02_6' '_markers_rotated_ik' '_BodyKinematics_acc_global.sto']);
% 
% BK_P_Table = [BK_P_Table1; BK_P_Table2(2:end,:); BK_P_Table3(2:end,:); BK_P_Table4(2:end,:); BK_P_Table5(2:end,:); BK_P_Table6(2:end,:);];
% BK_V_Table = [BK_V_Table1; BK_V_Table2(2:end,:); BK_V_Table3(2:end,:); BK_V_Table4(2:end,:); BK_V_Table5(2:end,:); BK_V_Table6(2:end,:);];
% BK_A_Table = [BK_A_Table1; BK_A_Table2(2:end,:); BK_A_Table3(2:end,:); BK_A_Table4(2:end,:); BK_A_Table5(2:end,:); BK_A_Table6(2:end,:);];

clearvars -except BK_P_Table BK_V_Table BK_A_Table strSubject
%% Loading the model file since the XML2struct doesn't work 
import org.opensim.modeling.*

modelPath = 'G:\Shared drives\NeuroMobLab\Projects\Perception\Processed Data\Dan\OpenSim\YAPercep Outputs\YAPercep05\TestScale\';
modelFile = '3DGaitModel2392-scaled-YAPercep05-Cal07.osim';
model = Model([modelPath modelFile]);
references = osimList2MatlabCell(model,'Body');


% Hard Coding the Bodies 
Bodies.Pelvis = references{1};
Bodies.r_Femur = references{2}; 
Bodies.r_Tibia = references{3}; 
Bodies.r_Talus = references{4};
Bodies.r_Calc = references{5};
Bodies.r_Toes = references{6};
Bodies.l_Femur = references{7};
Bodies.l_Tibia = references{8}; 
Bodies.l_Talus = references{9}; 
Bodies.l_Calc = references{10};
Bodies.l_Toes = references{11};
Bodies.Torso = references{12};

%% Placing the data into the same type of cell that Andy did 
% Getting the Mass, Mass center and inertia terms for each body segment
nBodies = size(references,1);
SegData = cell(nBodies,4);
segNames = {'Pelvis'; 'r_Femur'; 'r_Tibia'; 'r_Talus'; 'r_Calc'; 'r_Toes'; ...
    'l_Femur'; 'l_Tibia'; 'l_Talus'; 'l_Calc'; 'l_Toes'; 'Torso';};
for iBodies = 1:nBodies
    SegData{iBodies,1} = char(references{iBodies,1});
    SegData{iBodies,2} = Bodies.(segNames{iBodies}).getMass();
    tempMassCenter = Bodies.(segNames{iBodies}).getMassCenter();
    SegData{iBodies,3} = osimVec3ToArray(tempMassCenter);
    tempInertia1 = Bodies.(segNames{iBodies}).getInertia();
    tempInertia2 = tempInertia1.getMoments();
    tempInertia3 = osimVec3ToArray(tempInertia2);
    SegData{iBodies,4} = [tempInertia3(1) 0 0;
        0 tempInertia3(2) 0; 
        0 0 tempInertia3(3);];
    clear tempMassCenter tempInertia1 tempInertia2
end


%% 
%Generate angular momentum table in same format as BodyKinematics
%Number of columns is BodyKinematics-3 because don't have COM angmom yet

AngMomSize=size(BK_V_Table);
AngMomEmpty=cell(AngMomSize);
AngMom = cell2table(AngMomEmpty,'VariableNames',BK_V_Table.Properties.VariableNames);
AngMom=AngMom(:,1:end-3);
AngMom.Header=BK_V_Table.Header;

COM_Pos=[BK_P_Table.center_of_mass_X,BK_P_Table.center_of_mass_Y,BK_P_Table.center_of_mass_Z];
COM_Vel=[BK_V_Table.center_of_mass_X,BK_V_Table.center_of_mass_Y,BK_V_Table.center_of_mass_Z];

for seg=1:nBodies
    %Calculate translational angular momenta for each segment
    segName=char(SegData{seg,1});
    segMass=SegData{seg,2};
    r_com2seg=[BK_P_Table.([segName '_X'])-COM_Pos(:,1),BK_P_Table.([segName '_Y'])-COM_Pos(:,2),BK_P_Table.([segName '_Z'])-COM_Pos(:,3)];
    v_com2seg=[BK_V_Table.([segName '_X'])-COM_Vel(:,1),BK_V_Table.([segName '_Y'])-COM_Vel(:,2),BK_V_Table.([segName '_Z'])-COM_Vel(:,3)];
    
    T_AM=cross(r_com2seg,segMass.*v_com2seg,2);
    
    
    %Convert inertia tensor which is in local segment coordinates to be expressed in global coordinates
    %Will use orientations (XYZ euler angles) from Body Kinematics to generate
    %rotation matrices that is local frame orientation wrt global coords (Global_R_Local).
    %Then will convert inertia tensor into global coords using Global_R_Local*Local_I*(Global_R_Local)'
    %Then multiply Global_Inertia tensor with angular velocity to get
    %rotational angular momentum
    %All rotational outputs from body kinematics have been selected to be in radians
    segInertia=SegData{seg,4};
    
    R_AM=zeros(size(T_AM));
    
    
    for t_temp=1:size(COM_Pos,1)
        Global_R_Local=eul2rotm([BK_P_Table.([segName '_Ox'])(t_temp),BK_P_Table.([segName '_Oy'])(t_temp),BK_P_Table.([segName '_Oz'])(t_temp)],'XYZ');
        Global_Inertia=Global_R_Local*segInertia*Global_R_Local';
        R_AM(t_temp,:)=(Global_Inertia*[BK_V_Table.([segName '_Ox'])(t_temp);BK_V_Table.([segName '_Oy'])(t_temp);BK_V_Table.([segName '_Oz'])(t_temp)])';
        
    end
    
    %Now put the T_AM and R_AM into AngMom table

    
    AngMom.([segName '_X'])=T_AM(:,1);
    AngMom.([segName '_Y'])=T_AM(:,2);
    AngMom.([segName '_Z'])=T_AM(:,3);
    
    AngMom.([segName '_Ox'])=R_AM(:,1);
    AngMom.([segName '_Oy'])=R_AM(:,2);
    AngMom.([segName '_Oz'])=R_AM(:,3);
    
end


%These are in Opensim coordinates, so X is sagittal plane (+X is left), Y is transverse plane (+Y is up), Z is frontal plane (+Z is forward)

AngMom.TAM_X=sum(AngMom{:, contains(AngMom.Properties.VariableNames, '_X')},2);
AngMom.TAM_Y=sum(AngMom{:, contains(AngMom.Properties.VariableNames, '_Y')},2);
AngMom.TAM_Z=sum(AngMom{:, contains(AngMom.Properties.VariableNames, '_Z')},2);

AngMom.RAM_X=sum(AngMom{:, contains(AngMom.Properties.VariableNames, '_Ox')},2);
AngMom.RAM_Y=sum(AngMom{:, contains(AngMom.Properties.VariableNames, '_Oy')},2);
AngMom.RAM_Z=sum(AngMom{:, contains(AngMom.Properties.VariableNames, '_Oz')},2);

%Put T_AM and R_AM in coordinate frame to facilitate comparison to Liu
%2018, Herr 2008, and Silverman 2011 (Rotate 90 degrees about Z axis, so R points to subject's right (sagittal plane), U points upward (transverse plane), F points forward (frontal plane)
% This is different than our labs R points forwards (frontal plane), U
% points upward (transverse plane), F points to the subject's right
% (sagittal plane)
AngMom.TAM_R=-AngMom.TAM_X;
AngMom.TAM_U=AngMom.TAM_Y;
AngMom.TAM_F=AngMom.TAM_Z;

AngMom.RAM_R=-AngMom.RAM_X;
AngMom.RAM_U=AngMom.RAM_Y;
AngMom.RAM_F=AngMom.RAM_Z;

AngMom.WBAM_R=AngMom.TAM_R+AngMom.RAM_R;
AngMom.WBAM_U=AngMom.TAM_U+AngMom.RAM_U;
AngMom.WBAM_F=AngMom.TAM_F+AngMom.RAM_F;

%% Plotting results 
load(['G:\Shared drives\NeuroMobLab\Projects\Perception\Processed Data\Dan\Matlab Analysis\YAPercep' strSubject '\Data Tables\SepTables_YAPercep' strSubject '.mat']);

figure; 
gcs = gaitEventsTable.Gait_Events_Right{2,1};
for i = 1:length(gcs)
    gcstart = gcs(i,1);
    gcfin = gcs(i,5);
    subplot(3,1,1); plot(AngMom.WBAM_R(gcstart:gcfin)); title('WBAM Frontal');
    hold on;
    subplot(3,1,2); plot(AngMom.WBAM_U(gcstart:gcfin)); title('WBAM Transverse');
    hold on;
    subplot(3,1,3); plot(AngMom.WBAM_F(gcstart:gcfin)); title('WBAM Sagittal');
    hold on;
end

