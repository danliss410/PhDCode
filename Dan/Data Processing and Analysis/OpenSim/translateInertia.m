function [inertiaTensor] = translateInertia(strSubject)
% Translating the inertia tensor from being about the mass center to be
% about the body coordinate origin. 
% INPUTS: strSubject               - a string of the subjects unique identifier for the
%                                   Perception study.
%
% OUPUT: inertiaTensor     -  Example of tensor shown below. This tensor is
%                         correctly translated to be about the body coordinate origin instead of
%                         being about the mass center as the inertia values are in the OpenSim
%                         Model. 
%                            [Ixx Ixy Ixz
%                             Iyx Iyy Iyz
%                             Izx Izy Izz]
%
%
% Created: 14 December 2021, DJL
% Modified: (format: date, initials, change made)
%   1 - 
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

temp = importdata('G:\Shared drives\NeuroMobLab\Projects\Perception\Processed Data\Dan\OpenSim\YAPercep Outputs\MassAndInertia\massAndInertia.xlsx');
temp2 = importdata('G:\Shared drives\NeuroMobLab\Projects\Perception\Processed Data\Dan\OpenSim\YAPercep Outputs\MassAndInertia\massCenter.xlsx');
%% Creating mass and inertia matrices 

% Grabbing the masses from the excel sheet loaded in. These masses are for
% each segment of the OpenSim model used for calculations. The order of the
% segments are as follows: Torso, Pelvis, Femur_r, Tibia_r, Talus_r, Calcn_r, Toes_r, Femur_l,
% Tibia_l, Talus_l, Calcn_l, Toes_l
m = temp.data.(subject1)(:,1);

% Creating the inertia matrix 
tempI = zeros(3,3,12);
for iSeg = 1:size(m,1)
    tempI(1,1,iSeg) = temp.data.(subject1)(iSeg,2);
    tempI(2,2,iSeg) = temp.data.(subject1)(iSeg,3);
    tempI(3,3,iSeg) = temp.data.(subject1)(iSeg,4);
    
    tempMC(1,1,iSeg) = temp2.data.(subject1)(iSeg,2);
    tempMC(1,2,iSeg) = temp2.data.(subject1)(iSeg,3);
    tempMC(1,3,iSeg) = temp2.data.(subject1)(iSeg,4);
end

% This loop is translating the inertia values that are about the mass
% center for each segment to be about the body frame using the mass centers
% coordinates that are located in body frame. 
transI = zeros(3,3,12);
for iSeg = 1:size(m,1)
    % Ixx
    transI(1,1,iSeg) = tempI(1,1,iSeg) + m(iSeg)*(tempMC(1,2,iSeg)^2 + tempMC(1,3,iSeg)^2);
    % Ixy
    transI(1,2,iSeg) = tempI(1,2,iSeg) + m(iSeg)*tempMC(1,1,iSeg)*tempMC(1,2,iSeg);
    % Ixz
    transI(1,3,iSeg) = tempI(1,3,iSeg) + m(iSeg)*tempMC(1,1,iSeg)*tempMC(1,3,iSeg);
    % Iyx
    transI(2,1,iSeg) = tempI(2,1,iSeg) + m(iSeg)*tempMC(1,1,iSeg)*tempMC(1,2,iSeg);
    % Iyy 
    transI(2,2,iSeg) = tempI(2,2,iSeg) + m(iSeg)*(tempMC(1,1,iSeg)^2 +tempMC(1,3,iSeg)^2);
    % Iyz
    transI(2,3,iSeg) = tempI(2,3,iSeg) + m(iSeg)*(tempMC(1,2,iSeg))*tempMC(1,3,iSeg);
    % Izx
    transI(3,1,iSeg) = tempI(3,1,iSeg) + m(iSeg)*tempMC(1,1,iSeg)*tempMC(1,3,iSeg);
    % Izy
    transI(3,2,iSeg) = tempI(3,2,iSeg) + m(iSeg)*tempMC(1,2,iSeg)*tempMC(1,3,iSeg);
    % Izz
    transI(3,3,iSeg) = tempI(3,3,iSeg) + m(iSeg)*(tempMC(1,1,iSeg)^2 + tempMC(1,2,iSeg)^2);
end

inertiaTensor = transI;

%%
% Setting the location to save the inertia tensor for each subject 
if ispc
    tabLoc = ['G:\Shared drives\NeuroMobLab\Projects\Perception\Processed Data\Dan\OpenSim\YAPercep Outputs\' subject1 filesep 'Data Tables' filesep];
elseif ismac
    tabLoc = [''];
else
    tabLoc = input('Please enter the location where the tables should be saved.' ,'s');
end


% Saving the inertia matrix for each subject. 
save([tabLoc 'inertiaTensor_' subject1], 'inertiaTensor', '-v7.3');

disp(['Inertia Tensor saved for ' subject1]);

end

