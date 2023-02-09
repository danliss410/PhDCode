function dynamicStabilityTable = calcDynamicStability(strSubject, legLength)
% dynamicStabilityTable = calcDynamicStability(strSubject, legLength)
% This function will calculate WBAM and MoS. This function will then save
% all these values to a table for the entire length of each trial the subject participated in
% the experiment. All the values produced and used in these equations are
% SI units. WBAM is calculated from Popovic and Herr 2008 and MoS is
% calculated from Hof et al 2008. 
% 
% INPUTS: strSubject               - a string of the subjects unique identifier for the
%                                   Perception study.
%         legLength                - number (double) of the subjects
%                                   average leg length in mm. 
%
% OUPUT: dynamicStabilityTable     - a table that contains whole body
%                                angular momentum (WBAM) for all 3 planes
%                                of motion, Margin of Stability (MoS or b)
%                                in the anterior-posterior direction and
%                                mediolateral direction, Center of Mass
%                                (CoM) position, velocity, and
%                                acceleration. All values in the table are
%                                standard SI units. The coordinate system
%                                used is from OpenSim calculations. MoS in
%                                the AP used the toe marker as umax and in
%                                ML used the ankle maker as umax. 
%
%
% Created: 11 November 2021, DJL
% Modified: (format: date, initials, change made)
%   1 - 23 December 2021, DJL - Changing WBAM to the method used by Georgia
%   Tech and UNC. The original script is from WBAMandCOM_ABL_edits.m. There
%   are some toolboxes needed: 
%   -Robotic System Toolbox or another that has the eul2torm fcn
%   -MoCapTools (from https://github.com/JonathanCamargo/MoCapTools)
%   These toolboxes allow you to edit the .sto files more easily and
%   create rotation matricies from the toolbox instead of by hand. 
% 
% 
% 
% 
% 


%%%%%%%%%%%%%%%% THINGS THAT STILL NEED TO BE ADDED %%%%%%%%%%%%%%%%%%%%%%
% 1 - 


%% Create subject name to load the necessary files for the subject 
% Naming convention for each log file "YAPercep##_" + YesNo or 2AFC or Cog


subject1 = ['YAPercep' strSubject];


%% Loading the remaining tables for the subject 
% This section will load muscleTable, analogTable, gaitEventsTable,
% IKTable, pertTable, and videoTable(This will not be used)

load(['G:\Shared drives\NeuroMobLab\Projects\Perception\Processed Data\Dan\OpenSim\YAPercep Outputs\' subject1 filesep 'Data Tables' filesep 'SegmentsTables_' subject1 '.mat'])
load(['G:\Shared drives\NeuroMobLab\Projects\Perception\Processed Data\Dan\Matlab Analysis\' subject1 '\Data Tables\SepTables_' subject1 '.mat'])


%% Loading the model file since the XML2struct doesn't work 
import org.opensim.modeling.*

modelPath = ['G:\Shared drives\NeuroMobLab\Projects\Perception\Processed Data\Dan\OpenSim\YAPercep Outputs\' subject1 '\Scaled Model\'];
temp = dir(modelPath);
modelFile = temp(3).name;
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


%% This section of code is from UNC & Georgia Tech 
%Generate angular momentum table in same format as BodyKinematics
%Number of columns is BodyKinematics-3 because don't have COM angmom yet

AngMomSize=size(posSegmentsTable);
AngMomEmpty=cell(AngMomSize);
AngMom = cell2table(AngMomEmpty,'VariableNames',posSegmentsTable.Properties.VariableNames);
AngMom=AngMom(:,1:end-3);
AngMom.Trial= posSegmentsTable.Trial;

% Getting the Segment names to do a summation for CoM calculations 
tempSegs = posSegmentsTable.Properties.VariableNames;
tempSegs2 = tempSegs(:,1:end-3);
XSeg = contains(tempSegs2, '_X');
YSeg = contains(tempSegs2, '_Y');
ZSeg = contains(tempSegs2, '_Z');

% Creating the places to pull from the bodysegments tables for summing
% segments
tSegX = tempSegs2(XSeg);
tSegY = tempSegs2(YSeg);
tSegZ = tempSegs2(ZSeg);

% Getting the number of trials to be used for the loop 
trials = posSegmentsTable.Trial;
for iTrial = 1:size(trials,1)

    COM_Pos=[posSegmentsTable.center_of_mass_X{iTrial},posSegmentsTable.center_of_mass_Y{iTrial},posSegmentsTable.center_of_mass_Z{iTrial}];
    COM_Vel=[velSegmentsTable.center_of_mass_X{iTrial},velSegmentsTable.center_of_mass_Y{iTrial},velSegmentsTable.center_of_mass_Z{iTrial}];
    
    for seg=1:nBodies
        %Calculate translational angular momenta for each segment
        segName=char(SegData{seg,1});
        segMass=SegData{seg,2};
        r_com2seg=[posSegmentsTable.([segName '_X']){iTrial}-COM_Pos(:,1),posSegmentsTable.([segName '_Y']){iTrial}-COM_Pos(:,2),posSegmentsTable.([segName '_Z']){iTrial}-COM_Pos(:,3)];
        v_com2seg=[velSegmentsTable.([segName '_X']){iTrial}-COM_Vel(:,1),velSegmentsTable.([segName '_Y']){iTrial}-COM_Vel(:,2),velSegmentsTable.([segName '_Z']){iTrial}-COM_Vel(:,3)];
        
        
        
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
            Global_R_Local=eul2rotm([posSegmentsTable.([segName '_Ox']){iTrial}(t_temp),posSegmentsTable.([segName '_Oy']){iTrial}(t_temp),posSegmentsTable.([segName '_Oz']){iTrial}(t_temp)],'XYZ');
            Global_Inertia=Global_R_Local*segInertia*Global_R_Local';
            R_AM(t_temp,:)=(Global_Inertia*[velSegmentsTable.([segName '_Ox']){iTrial}(t_temp);velSegmentsTable.([segName '_Oy']){iTrial}(t_temp);velSegmentsTable.([segName '_Oz']){iTrial}(t_temp)])';

        end

        %Now put the T_AM and R_AM into AngMom table


        AngMom.([segName '_X']){iTrial}=T_AM(:,1);
        AngMom.([segName '_Y']){iTrial}=T_AM(:,2);
        AngMom.([segName '_Z']){iTrial}=T_AM(:,3);

        AngMom.([segName '_Ox']){iTrial}=R_AM(:,1);
        AngMom.([segName '_Oy']){iTrial}=R_AM(:,2);
        AngMom.([segName '_Oz']){iTrial}=R_AM(:,3);

        
        
        % Calculate the CoM via the summation of segments method 
        % Segment location is in reference to ground 
        % Multiply the segment mass by position, velocity, acceleration, in
        % ref to the ground then divide by the total mass of the
        % subject/model
        sCoMPos(seg,:,1) = segMass * posSegmentsTable.(tSegX{seg}){iTrial};
        sCoMPos(seg,:,2) = segMass * posSegmentsTable.(tSegY{seg}){iTrial};
        sCoMPos(seg,:,3) = segMass * posSegmentsTable.(tSegZ{seg}){iTrial};

        sCoMVel(seg,:,1) = segMass * velSegmentsTable.(tSegX{seg}){iTrial};
        sCoMVel(seg,:,2) = segMass * velSegmentsTable.(tSegY{seg}){iTrial};
        sCoMVel(seg,:,3) = segMass * velSegmentsTable.(tSegZ{seg}){iTrial};


        sCoMAcc(seg,:,1) = segMass * accSegmentsTable.(tSegX{seg}){iTrial};
        sCoMAcc(seg,:,2) = segMass * accSegmentsTable.(tSegY{seg}){iTrial};
        sCoMAcc(seg,:,3) = segMass * accSegmentsTable.(tSegZ{seg}){iTrial}; 
    end


    %These are in Opensim coordinates, so X is sagittal plane (+X is left), Y is transverse plane (+Y is up), Z is frontal plane (+Z is forward)

    AngMom.TAM_X{iTrial}=sum(cell2mat(AngMom{iTrial, contains(AngMom.Properties.VariableNames, '_X')}),2);
    AngMom.TAM_Y{iTrial}=sum(cell2mat(AngMom{iTrial, contains(AngMom.Properties.VariableNames, '_Y')}),2);
    AngMom.TAM_Z{iTrial}=sum(cell2mat(AngMom{iTrial, contains(AngMom.Properties.VariableNames, '_Z')}),2);

    AngMom.RAM_X{iTrial}=sum(cell2mat(AngMom{iTrial, contains(AngMom.Properties.VariableNames, '_Ox')}),2);
    AngMom.RAM_Y{iTrial}=sum(cell2mat(AngMom{iTrial, contains(AngMom.Properties.VariableNames, '_Oy')}),2);
    AngMom.RAM_Z{iTrial}=sum(cell2mat(AngMom{iTrial, contains(AngMom.Properties.VariableNames, '_Oz')}),2);

    %Put T_AM and R_AM in coordinate frame to facilitate comparison to Liu
    %2018, Herr 2008, and Silverman 2011 (Rotate 90 degrees about Z axis, so R points to subject's right (sagittal plane), U points upward (transverse plane), F points forward (frontal plane)
    % This is different than our labs R points forwards (frontal plane), U
    % points upward (transverse plane), F points to the subject's right
    % (sagittal plane)
    % Frontal plane was negative to the Herr and Popovic results so changed
    % sign to compare. Removed the negatives at TAM_R and RAM_R
    AngMom.TAM_R{iTrial}=AngMom.TAM_X{iTrial};
    AngMom.TAM_U{iTrial}=AngMom.TAM_Y{iTrial};
    AngMom.TAM_F{iTrial}=AngMom.TAM_Z{iTrial};

    AngMom.RAM_R{iTrial}=AngMom.RAM_X{iTrial};
    AngMom.RAM_U{iTrial}=AngMom.RAM_Y{iTrial};
    AngMom.RAM_F{iTrial}=AngMom.RAM_Z{iTrial};

    AngMom.WBAM_R{iTrial}=AngMom.TAM_R{iTrial}+AngMom.RAM_R{iTrial};
    AngMom.WBAM_U{iTrial}=AngMom.TAM_U{iTrial}+AngMom.RAM_U{iTrial};
    AngMom.WBAM_F{iTrial}=AngMom.TAM_F{iTrial}+AngMom.RAM_F{iTrial};
    
    % Summing CoM instead of using the OpenSim Calculations 
    % This is wrong what needs to be done is to 
    % This is CoM of the segment which we have up above in SegDat col 3
    % com = Bodies.{SegName}.get_mass_center()

    CoM_sPos{iTrial} = squeeze(sum(sCoMPos,1))/sum(cell2mat(SegData(:,2)));
    CoM_sVel{iTrial} = squeeze(sum(sCoMVel,1))/sum(cell2mat(SegData(:,2)));
    CoM_sAcc{iTrial} = proc_process_smoothderivative(CoM_sPos{iTrial}, 100, 2)*100;
    
    
    % Making WBAM to be placed in the dynamic stability table 
    % This is different than our labs R points forwards (frontal plane), U
    % points upward (transverse plane), F points to the subject's right
    % (sagittal plane)
    %################ Need to double check signs ########################
    
    WBAM.(trials{iTrial})(:,1) = AngMom.WBAM_R{iTrial}; 
    WBAM.(trials{iTrial})(:,2) = AngMom.WBAM_U{iTrial};
    WBAM.(trials{iTrial})(:,3) = AngMom.WBAM_F{iTrial};
    clear COM_Pos COM_Vel sCoMPos sCoMVel sCoMAcc
    
    fprintf(['WBAM Calculated for ' trials{iTrial} ' for ' subject1 ' \n'])
        
end




%% MoS Calculations 

% X-CoM = pos + vel/ sqrt(g/l)
% l is leg length 
% g is gravity 
% MoS = | umax - (xCoM)|
% umax should be the toe marker in AP 
% Leg length grab and average the values between both legs for the given
% subject (is an input) 
l = legLength/1000; % Converting leg length from mm to m
g = 9.8; % m/s2 for gravity 
% The 3rd subsection of YAPercep14's data has no perturbations so it was
% not processed for IK and Analysis so just changing the size of the data
% to match 
if strSubject == '14'
    videoTable.("Marker_Data"){1,1} = videoTable.("Marker_Data"){1,1}(1:10000,:,:);
end


% Toe marker for umax in AP 
for iTrial = 1:size(trials,1)
    % Toe marker right side values 
    umaxAP_R.(trials{iTrial}) = videoTable.("Marker_Data"){iTrial,1}(:,31,1);
    % Toe marker left side values 
    umaxAP_L.(trials{iTrial}) = videoTable.("Marker_Data"){iTrial,1}(:,23,1);
    % Ankle marker right side values 
    % These values might need to change the column chosen 
    umaxML_R.(trials{iTrial}) = videoTable.("Marker_Data"){iTrial,1}(:,29,2);
    % Ankle marker left side values 
    umaxML_L.(trials{iTrial}) = videoTable.("Marker_Data"){iTrial,1}(:,21,2);
    
    COM_Pos=[posSegmentsTable.center_of_mass_X{iTrial},posSegmentsTable.center_of_mass_Y{iTrial},posSegmentsTable.center_of_mass_Z{iTrial}];
    COM_Vel=[velSegmentsTable.center_of_mass_X{iTrial},velSegmentsTable.center_of_mass_Y{iTrial},velSegmentsTable.center_of_mass_Z{iTrial}];
    
    
    % Calculating AP MoS for Right side 
    bAP_R.(trials{iTrial}) = abs(umaxAP_R.(trials{iTrial}) ./1000 - (COM_Pos(:,1) + (COM_Vel(:,1)/sqrt(g/l))));
    % Calculating AP MoS for the left side
    bAP_L.(trials{iTrial}) = abs(umaxAP_L.(trials{iTrial}) ./1000 - (COM_Pos(:,1) + (COM_Vel(:,1)/sqrt(g/l))));
    
    % Calculating ML MoS for the Right side 
    % Might have to change the column being called can't figure out if Y
    % from open sim is ML or vertical
    bML_R.(trials{iTrial}) = abs(umaxML_R.(trials{iTrial}) ./1000 - (COM_Pos(:,3) + (COM_Vel(:,3)/sqrt(g/l))));
    % Calculating ML MoS for the left side 
    bML_L.(trials{iTrial}) = abs(umaxML_L.(trials{iTrial}) ./1000 - (COM_Pos(:,3) + (COM_Vel(:,3)/sqrt(g/l))));
    clear COM_Pos COM_Vel
    
end
fprintf(['MoS Calculated for ' subject1 ' \n'])

%% Placing all the values into the final table 

for iTrial = 1:size(trials,1)
    COM_Pos=[posSegmentsTable.center_of_mass_X{iTrial},posSegmentsTable.center_of_mass_Y{iTrial},posSegmentsTable.center_of_mass_Z{iTrial}];
    COM_Vel=[velSegmentsTable.center_of_mass_X{iTrial},velSegmentsTable.center_of_mass_Y{iTrial},velSegmentsTable.center_of_mass_Z{iTrial}];
    COM_Acc=[accSegmentsTable.center_of_mass_X{iTrial},accSegmentsTable.center_of_mass_Y{iTrial},accSegmentsTable.center_of_mass_Z{iTrial}];
    
    
    if iTrial == 1
        dynamicStabilityTable = table(trials(iTrial), {WBAM.(trials{iTrial})}, {bAP_R.(trials{iTrial})}, {bAP_L.(trials{iTrial})},...
            {bML_R.(trials{iTrial})}, {bML_L.(trials{iTrial})}, {COM_Pos}, {COM_Vel}, {COM_Acc},{CoM_sPos{iTrial}}, {CoM_sVel{iTrial}}, {CoM_sAcc{iTrial}}, ...
            'VariableNames', {'Trial'; 'WBAM'; 'APMoS_R'; 'APMoS_L'; 'MLMoS_R';...
            'MLMoS_L'; 'CoM_Pos'; 'CoM_Vel'; 'CoM_Acc'; 'Sum_CoM_Pos';...
            'Sum_CoM_Vel'; 'Sum_CoM_Acc';});
    else 
        dynamicStabilityTable.('Trial')(iTrial) = trials(iTrial); 
        dynamicStabilityTable.('WBAM')(iTrial) = {WBAM.(trials{iTrial})};
        dynamicStabilityTable.('APMoS_R')(iTrial) = {bAP_R.(trials{iTrial})};
        dynamicStabilityTable.('APMoS_L')(iTrial) = {bAP_L.(trials{iTrial})};
        dynamicStabilityTable.('MLMoS_R')(iTrial) = {bML_R.(trials{iTrial})};
        dynamicStabilityTable.('MLMoS_L')(iTrial) = {bML_L.(trials{iTrial})};
        dynamicStabilityTable.('CoM_Pos')(iTrial) = {COM_Pos};
        dynamicStabilityTable.('CoM_Vel')(iTrial) = {COM_Vel};
        dynamicStabilityTable.('CoM_Acc')(iTrial) = {COM_Acc};
        dynamicStabilityTable.('Sum_CoM_Pos')(iTrial) = {CoM_sPos{iTrial}};
        dynamicStabilityTable.('Sum_CoM_Vel')(iTrial) = {CoM_sVel{iTrial}};
        dynamicStabilityTable.('Sum_CoM_Acc')(iTrial) = {CoM_sAcc{iTrial}};
    end

end

%% Saving the dynamic stability table in the subject opensim datatable section 
% Setting the location to the subjects' data folder 
if ispc
    subLoc = ['G:\Shared drives\NeuroMobLab\Projects\Perception\Processed Data\Dan\OpenSim\YAPercep Outputs\' subject1];
elseif ismac %%%% Need to add the part for a mac 
    subLoc = [''];
else
    subLoc = input('Please enter the location where the tables should be saved.' ,'s');
end


% Checking to see if a data table folder exists for each subject. If it
% does not exist this will create a folder in the correct location. 
if exist([subLoc 'Data Tables'], 'dir') ~= 7
    mkdir(subLoc, 'Data Tables');
end

% Setting the location to save the data tables for each subject 
if ispc
    tabLoc = ['G:\Shared drives\NeuroMobLab\Projects\Perception\Processed Data\Dan\OpenSim\YAPercep Outputs\' subject1 filesep 'Data Tables' filesep];
elseif ismac
    tabLoc = [''];
else
    tabLoc = input('Please enter the location where the tables should be saved.' ,'s');
end

% dynamicStabilityTableFix = dynamicStabilityTable; 
% Saving the position, velocity, acceleration, and angular accelerations table to be saved for each subject. 
save([tabLoc 'dynamicStabilityTable_' subject1], 'dynamicStabilityTable', '-v7.3');
% Saving a separate WBAM table that has all the calculations for all the
% segments and the translational portion and angular portion of WBAM
save([tabLoc 'WBAMFullTable_' subject1], 'AngMom', '-v7.3');

fprintf(['Tables saved for ' subject1 ' \n']);

end

