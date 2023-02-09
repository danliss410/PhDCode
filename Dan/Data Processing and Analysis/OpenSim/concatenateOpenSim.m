function [BodyAnalysisTable] = concatenateOpenSim(strSubject,numTrials,numTreadmillTrials, SSWS)
% 
% [BodyAnalysisTable] = concatenateOpenSim(strSubject,numTrials,numTreadmillTrials)
% 
% This function will concatenate the OpenSim data for the subtrials into
% tables for each analysis method. The CoM data will be placed into the
% BodyAnalysisTable. 
% 
% INPUTS: strSubject               - a string of the subjects unique identifier for the
%                                   Perception study.
%         numTrials             - number (double) of whole perception trials (Should be 4,
%                                   but may be more or less depending on if recording was messed up)
%         numTreamillTrials     - number (double) of treadmill trials (Should be 2-3,
%                                   but may be more depending on if recording was messed up)
%         SSWS                  - number (double) of the speed the subject
%                                 walked on the treadmill (m/s).
%
% OUPUT: BodyAnalysisTable      - a table that has the processed IK OpenSim data for all trials the subject
%                                 participated in during the experiment.
%                                 The data is concatenated for all subtrials
%                                 in this table includes: time, CoM position (X, Y, Z), CoM velocity(X,Y,Z), right and left Calcaneus velocity (X,Y,Z).
% Commented this table out because this is not useful or needed         
%muscleTable             - a table that has musculotendon length data for all
%                                 trials the subject particpated in during
%                                 the experiment. The data is concatenated
%                                 for all subtrials in this table and
%                                 includes: musculotendon length and
%                                 velocity for:
%                                 Medial Gastroc, lateral grastroc, soleus,
%                                 tibialis anterior (for left and right
%                                 legs).
%
%
% Created: 27 August 2020, DJL
% Modified: (format: date, initials, change made)
%   1 - September 27th 2021 DJL - changed name of IKTable to Body Analysis
%   table and commented out section about muscle table from OpenSim
%   analysis.


%%%%%%%%%%%%%%%% THINGS THAT STILL NEED TO BE ADDED %%%%%%%%%%%%%%%%%%%%%%
% 1 - 

%% Create subject name to load the necessary files for the subject 
% Naming convention for each log file "YAPercep##_" + YesNo or 2AFC or Cog

subjectYesNo = ['YAPercep' strSubject '_YesNo'];

subject2AFC = ['YAPercep' strSubject '_2AFC'];

subjectCog = ['YAPercep' strSubject '_Cog'];

subject1 = ['YAPercep' strSubject];


%% Setting the file location based on which computer is running the code
if ispc
    fileLocation = 'G:\Shared drives\NeuroMobLab\Projects\Perception\Processed Data\Dan\OpenSim\YAPercep Outputs';
elseif ismac %################# Need to add the spots for a mac
%     fileLocation = '/Volumes/GoogleDrive/Shared drives/NeuroMobLab/Experimental Data/Vicon Matlab Processed/Pilot Experiments/WVCTSI_Perception2019/';
else
    fileLocation = input('Please enter the file location:' );
end

startLocation = 'D:\Github\Perception-Project\Dan\Data Processing and Analysis\'; %Location where all the functions and matlab scripts are 

IKLoc = [fileLocation filesep subject1 filesep 'IKResults and Analysis Output' filesep]; % Creating new location based on the subject that is being processed for IK data

cd(IKLoc)


% Create directory of files that need to be loaded for each subject for IK 
IKDir = dir(IKLoc);
IKDir = IKDir(3:end);

% This gives you the indicies of all the open sim data for the position and
% velocity data for IK results. 
for i = 1:size(IKDir,1)
    pos1(i) = contains(IKDir(i).('name'), "_pos_");
	vel1(i) = contains(IKDir(i).('name'), "_vel_");
end

% Creating a directory of just the CoM position Body Kinematics files
IKposDir = IKDir(pos1);

% Creating a directory of the CoM velocity Body Kinematics files
IKvelDir = IKDir(vel1);


% Creating the subject ID for trials 
for iDirLength = 1:length(IKDir)
    subjectID{iDirLength,1} = subject1;
end

% Looping through all the length of the data file to load all the trials
% collected for each subject into a table for position values for CoM 

for iTrials = 1:length(IKposDir)
    pos = importdata(IKposDir(iTrials).name);
    
    if iTrials == 1 % Creating the table for CoM position based calculations
        posTable1 = table(subjectID(iTrials),{IKposDir(iTrials).name}, {pos.data(:,1)}, {pos.data(:,74)},...
            {pos.data(:,75)}, {pos.data(:,76)}, 'VariableNames', {'Subject';'Trial Name';'Time (s)'; 'CoM X'; 'CoM Y';...
            'CoM Z'});
    else % Filling the table with the remaining values
        posTable1.Subject(iTrials) = subjectID(iTrials);
        posTable1.('Trial Name')(iTrials) = {IKposDir(iTrials).name};
        posTable1.('Time (s)')(iTrials) = {pos.data(:,1)};
        posTable1.('CoM X')(iTrials) = {pos.data(:,74)};
        posTable1.('CoM Y')(iTrials) = {pos.data(:,75)};
        posTable1.('CoM Z')(iTrials) = {pos.data(:,76)};
    end
end

% Looping through all the length of the data file to load all the trials
% collected for each subject into a table for velocity values for CoM 

for iTrials = 1:length(IKvelDir)
    vel = importdata(IKvelDir(iTrials).name);

    RCalcX = vel.data(:,26);
    RCalcY = vel.data(:,27);
    RCalcZ = vel.data(:,28);
    smoothRCalc = smooth((-vel.data(:,26)-SSWS),20); % Subtracting the SSWS so we can easily tell when the perturbation occurs from the walking data for the Right foot

    LCalcX = vel.data(:,56);
    LCalcY = vel.data(:,57);
    LCalcZ = vel.data(:,58);
    smoothLCalc = smooth((-vel.data(:,56) - SSWS), 20); % Subtracting the SSWS so we can easily tell when the pertubation occurs on the left foot.

    CoMX = vel.data(:,74);
    CoMY = vel.data(:,75);
    CoMZ = vel.data(:,76);

    t = vel.data(:,1);
    
    if iTrials == 1 % Creating the table 
        velTable1 = table(subjectID(iTrials),{IKvelDir(iTrials).name}, {t}, {CoMX}, {CoMY}, {CoMZ},...
            {RCalcX}, {RCalcY}, {RCalcZ}, {smoothRCalc}, {LCalcX}, {LCalcY}, {LCalcZ}, {smoothLCalc},...
            'VariableNames', {'Subject';'Trial Name';'Time (s)'; 'vCoM X'; 'vCoM Y';'vCoM Z'; 'R Calcaneus X'; 'R Calcaneus Y'; ...
            'R Calcaneus Z'; 'R Calc Smooth'; 'L Calcaneus X'; 'L Calcaneus Y'; 'L Calcaneus Z'; 'L Calc Smooth';});
    else % Filling the table with the remaining values
        velTable1.Subject(iTrials) = subjectID(iTrials);
        velTable1.('Trial Name')(iTrials) = {IKvelDir(iTrials).name};
        velTable1.('Time (s)')(iTrials) = {t};
        velTable1.('vCoM X')(iTrials) = {CoMX};
        velTable1.('vCoM Y')(iTrials) = {CoMY};
        velTable1.('vCoM Z')(iTrials) = {CoMZ};
        velTable1.('R Calcaneus X')(iTrials) = {RCalcX};
        velTable1.('R Calcaneus Y')(iTrials) = {RCalcY};
        velTable1.('R Calcaneus Z')(iTrials) = {RCalcZ};
        velTable1.('R Calc Smooth')(iTrials) = {smoothRCalc};
        velTable1.('L Calcaneus X')(iTrials) = {LCalcX};
        velTable1.('L Calcaneus Y')(iTrials) = {LCalcY};
        velTable1.('L Calcaneus Z')(iTrials) = {LCalcZ};
        velTable1.('L Calc Smooth')(iTrials) = {smoothLCalc};

    end
end

clearvars -except fileLocation strSubject numTrials numTreadmillTrials SSWS velTable1 posTable1 startLocation subject1


% %% Loading all the muscle data in from OpenSim processing 
% 
% MALoc = [fileLocation filesep subject1 filesep 'IKResults and Analysis Output' filesep]; % Creating new location based on the subject that is being processed for Muscle Analysis data
% 
% cd(MALoc)
% 
% % Create a directory of all the MA processed files from OpenSim 
% MADir = dir(MALoc);
% MADir = MADir(3:end); % getting rid of the 2 rows of OS identifiers that are not actually files 
% 
% % This gives you the indicies of all the open sim data for the muscle analysis data. 
% for i = 1:size(MADir,1)
%     ma1(i) = contains(MADir(i).('name'), "_Length.");
% end
% 
% 
% % Creating a directory of just the tendon length in Muscle Analysis files
% MAtlDir = MADir(ma1);
% 
% % Creating the subject ID for the length of the table 
% for iDirLength = 1:length(MAtlDir)
%     subjectID{iDirLength,1} = subject1;
% end
% 
% % Looping through all the length of the data file to load all the trials
% % collected for each subject into a table for tendon length for the muscle analysis files. 
% 
% for iTrials = 1:length(MAtlDir)
%     TL = importdata(MAtlDir(iTrials).name); % opening the file
%     
%     t = TL.data(:,1); % time
%     
%     med_gas_r = TL.data(:,33); % Right Medial gastroc 
%     lat_gas_r = TL.data(:,34); % Right Lateral gastroc
%     soleus_r = TL.data(:,35); % Right Soleus
%     tib_ant_r = TL.data(:,39); % Right Tib Ant 
%         
%     med_gas_l = TL.data(:,76); % Left medial gastroc
%     lat_gas_l = TL.data(:,77); % Left lateral gastroc
%     soleus_l = TL.data(:,78); % Left Soleus
%     tib_ant_l = TL.data(:,82); % Left Tibialis Anterior Tendon Length
%     
%     signals = {med_gas_r; lat_gas_r; soleus_r; tib_ant_r; med_gas_l; lat_gas_l; soleus_l; tib_ant_l;}; % Creating a cell array of MTLs to be passed to a derivative function to generate MTVs
%     
%     % Loop through all MTLs to create MTVs using the proc_process_smoothderivative
%     % function
%     for i = 1:size(signals,1)
%         SignalIn = signals{i,1};
%         signal_out = proc_process_smoothderivative(SignalIn,1000,1);
%         MTV{i} = signal_out; 
%         % MT Velocities are in the same order as the signals cell
%         % (1) Med Gastroc R (2) Lat Gastroc R (3) Soleus R (4) Tib Ant R
%         % (5) Med Gastroc L (6) Lat Gastroc L (7) Soleus L (8) Tib Ant L
%     end
%        
%         
%     
%     if iTrials == 1 % Creating the table for tendon length for 4 musculotendons on each leg
%         tendonTable1 = table(subjectID(iTrials),{MAtlDir(iTrials).name}, {t}, {med_gas_r}, {lat_gas_r}, {soleus_r},...
%             {tib_ant_r}, {med_gas_l}, {lat_gas_l}, {soleus_l}, {tib_ant_l}, {MTV{1}}, {MTV{2}}, {MTV{3}}, {MTV{4}},...
%             {MTV{5}}, {MTV{6}}, {MTV{7}}, {MTV{8}}, 'VariableNames',{'Subject';'Trial Name';'Time (s)';...
%             'R Med Gastroc Length'; 'R Lat Gastroc Length';'R Soleus Length';'R Tib Ant Length';...
%             'L Med Gastroc Length'; 'L Lat Gastroc Length'; 'L Soleus Length'; 'L Tib Ant Length'; 'R Med Gastroc Velocity';...
%             'R Lat Gastroc Velocity'; 'R Soleus Velocity';'R Tib Ant Velocity'; 'L Med Gastroc Velocity';...
%             'L Lat Gastroc Velocity'; 'L Soleus Velocity'; 'L Tib Ant Velocity';});
%     else % Filling the table with the remaining values
%         tendonTable1.Subject(iTrials) = subjectID(iTrials);
%         tendonTable1.('Trial Name')(iTrials) = {MAtlDir(iTrials).name};
%         tendonTable1.('Time (s)')(iTrials) = {t};
%         tendonTable1.('R Med Gastroc Length')(iTrials) = {med_gas_r};
%         tendonTable1.('R Lat Gastroc Length')(iTrials) = {lat_gas_r};
%         tendonTable1.('R Soleus Length')(iTrials) = {soleus_r};
%         tendonTable1.('R Tib Ant Length')(iTrials) = {tib_ant_r};
%         tendonTable1.('L Med Gastroc Length')(iTrials) = {med_gas_l};
%         tendonTable1.('L Lat Gastroc Length')(iTrials) = {lat_gas_l};
%         tendonTable1.('L Soleus Length')(iTrials) = {soleus_l};
%         tendonTable1.('L Tib Ant Length')(iTrials) = {tib_ant_l};
%         tendonTable1.('R Med Gastroc Velocity')(iTrials) = {MTV{1}};
%         tendonTable1.('R Lat Gastroc Velocity')(iTrials) = {MTV{2}};
%         tendonTable1.('R Soleus Velocity')(iTrials) = {MTV{3}};
%         tendonTable1.('R Tib Ant Velocity')(iTrials) = {MTV{4}};
%         tendonTable1.('L Med Gastroc Velocity')(iTrials) = {MTV{5}};
%         tendonTable1.('L Lat Gastroc Velocity')(iTrials) = {MTV{6}};
%         tendonTable1.('L Soleus Velocity')(iTrials) = {MTV{7}};
%         tendonTable1.('L Tib Ant Velocity')(iTrials) = {MTV{8}};
%     end
% end
%%
clearvars -except fileLocation strSubject numTrials numTreadmillTrials SSWS velTable1 posTable1 startLocation subject1 tendonTable1

% Preallocated names to pull from later in loops for Treadmill Trials 
nameTreadmill = {'Treadmill01'; 'Treadmill02'; 'Treadmill03'; 'Treadmill04'; 'Treadmill05'; 'Treadmill06'};

% Preallocated names to pull from later in loops for Perception Trials 
namePercep = {'Percep01'; 'Percep02'; 'Percep03'; 'Percep04'; 'Percep05'; 'Percep06'; 'Percep07'; 'Percep08';};


%% Create a BodyAnalysis Table for all the IK data (CoM calcs) concatenated for all the subtrials of each Perception trial 


% This loop finds the indicies of the position table of the subsections of
% each perception trial 
for iSubtrials = 1:size(posTable1.('Trial Name'),1)
    posA(iSubtrials) = contains(posTable1.('Trial Name'){iSubtrials}, 'Percep01');
    posB(iSubtrials) = contains(posTable1.('Trial Name'){iSubtrials}, 'Percep02');
    posC(iSubtrials) = contains(posTable1.('Trial Name'){iSubtrials}, 'Percep03');
    posD(iSubtrials) = contains(posTable1.('Trial Name'){iSubtrials}, 'Percep04');
    posE(iSubtrials) = contains(posTable1.('Trial Name'){iSubtrials}, 'Percep05');
    posF(iSubtrials) = contains(posTable1.('Trial Name'){iSubtrials}, 'Percep06');
    posG(iSubtrials) = contains(posTable1.('Trial Name'){iSubtrials}, 'Percep07');
    posH(iSubtrials) = contains(posTable1.('Trial Name'){iSubtrials}, 'Percep08');
end

if numTrials <= 5 
    posA = find(posA == 1); % Indicies for Percep01 in the posTable
    posB = find(posB == 1); % Indicies for Percep02 in the posTable
    posC = find(posC == 1); % Indicies for Percep03 in the posTable
    posD = find(posD == 1); % Indicies for Percep04 in the posTable
    posE = find(posE == 1);
else % Need to figure out how to adjust for more trials IE if there are bad trials and we recorded up through Percep06 or something 
end

% This loop finds the indicies of the velocity table of the subsections of
% each perception trial 
for iSubtrials = 1:size(velTable1.('Trial Name'),1)
    velA(iSubtrials) = contains(velTable1.('Trial Name'){iSubtrials}, 'Percep01');
    velB(iSubtrials) = contains(velTable1.('Trial Name'){iSubtrials}, 'Percep02');
    velC(iSubtrials) = contains(velTable1.('Trial Name'){iSubtrials}, 'Percep03');
    velD(iSubtrials) = contains(velTable1.('Trial Name'){iSubtrials}, 'Percep04');
    velE(iSubtrials) = contains(velTable1.('Trial Name'){iSubtrials}, 'Percep05');
    velF(iSubtrials) = contains(velTable1.('Trial Name'){iSubtrials}, 'Percep06');
    velG(iSubtrials) = contains(velTable1.('Trial Name'){iSubtrials}, 'Percep07');
    velH(iSubtrials) = contains(velTable1.('Trial Name'){iSubtrials}, 'Percep08');
end

if numTrials <= 5 
    velA = find(velA == 1); % Indicies for Percep01 in the velTable
    velB = find(velB == 1); % Indicies for Percep02 in the velTable
    velC = find(velC == 1); % Indicies for Percep03 in the velTable
    velD = find(velD == 1); % Indicies for Percep04 in the velTable
    velE = find(velE == 1); 
else % Need to figure out how to adjust for more trials IE if there are bad trials and we recorded up through Percep06 or something 
end

% Combining all the subtrials of position CoM to one matrix 
temp1 = {posA; posB; posC; posD; posE};

% Combining all the indicies of the velocity CoM to one matrix
temp2 = {velA; velB; velC; velD; velE};

for iNumTrials = 1:numTrials
%     Creating empty matricies for preallocating space for later in the
%     loop
    IK.('CoM_X').(namePercep{iNumTrials}) = []; 
    IK.("CoM_Y").(namePercep{iNumTrials}) = []; 
    IK.("CoM_Z").(namePercep{iNumTrials}) = []; 
    IK.("vCoM_X").(namePercep{iNumTrials}) = []; 
    IK.("vCoM_Y").(namePercep{iNumTrials}) = []; 
    IK.("vCoM_Z").(namePercep{iNumTrials}) = []; 
    IK.('R_Calcaneus_X').(namePercep{iNumTrials}) = []; 
    IK.('R_Calcaneus_Y').(namePercep{iNumTrials}) = [];
    IK.('R_Calcaneus_Z').(namePercep{iNumTrials}) = [];
    IK.('R_Calc_Smooth').(namePercep{iNumTrials}) = [];
    IK.('L_Calcaneus_X').(namePercep{iNumTrials}) = [];
    IK.('L_Calcaneus_Y').(namePercep{iNumTrials}) = [];
    IK.('L_Calcaneus_Z').(namePercep{iNumTrials}) = [];
    IK.('L_Calc_Smooth').(namePercep{iNumTrials}) = [];
    IK.('posTime').(namePercep{iNumTrials}) = [];
    IK.('velTime').(namePercep{iNumTrials}) = [];
    for iSectPercep = 1:size(temp1{iNumTrials},2) % Concatenate all the position CoM calculations for the subtrials of the Perception trials
        if iSectPercep > 1 
            IK.("CoM_X").(namePercep{iNumTrials}) = [IK.("CoM_X").(namePercep{iNumTrials}); posTable1.('CoM X'){temp1{iNumTrials}(iSectPercep)}(2:end)]; 
            IK.("CoM_Y").(namePercep{iNumTrials}) = [IK.("CoM_Y").(namePercep{iNumTrials}); posTable1.('CoM Y'){temp1{iNumTrials}(iSectPercep)}(2:end)]; 
            IK.("CoM_Z").(namePercep{iNumTrials}) = [IK.("CoM_Z").(namePercep{iNumTrials}); posTable1.('CoM Z'){temp1{iNumTrials}(iSectPercep)}(2:end)]; 
            IK.('posTime').(namePercep{iNumTrials}) = [IK.('posTime').(namePercep{iNumTrials}); IK.('posTime').(namePercep{iNumTrials})(end)+ posTable1.("Time (s)"){temp1{iNumTrials}(iSectPercep)}(2:end)];
        else
            IK.("CoM_X").(namePercep{iNumTrials}) = [posTable1.('CoM X'){temp1{iNumTrials}(iSectPercep)};]; 
            IK.("CoM_Y").(namePercep{iNumTrials}) = [posTable1.('CoM Y'){temp1{iNumTrials}(iSectPercep)};]; 
            IK.("CoM_Z").(namePercep{iNumTrials}) = [posTable1.('CoM Z'){temp1{iNumTrials}(iSectPercep)}]; 
            IK.('posTime').(namePercep{iNumTrials}) = [posTable1.("Time (s)"){temp1{iNumTrials}(iSectPercep)}];        
        end     
    end
    
    for iSectPercep = 1:size(temp2{iNumTrials},2) % Concatenate all the velocity CoM calculations for the subtrials of the Perception trials
        if iSectPercep > 1 
            IK.("vCoM_X").(namePercep{iNumTrials}) = [IK.("vCoM_X").(namePercep{iNumTrials}); velTable1.('vCoM X'){temp2{iNumTrials}(iSectPercep)}(2:end)]; 
            IK.("vCoM_Y").(namePercep{iNumTrials}) = [IK.("vCoM_Y").(namePercep{iNumTrials}); velTable1.('vCoM Y'){temp2{iNumTrials}(iSectPercep)}(2:end)]; 
            IK.("vCoM_Z").(namePercep{iNumTrials}) = [IK.("vCoM_Z").(namePercep{iNumTrials}); velTable1.('vCoM Z'){temp2{iNumTrials}(iSectPercep)}(2:end)]; 
            IK.('R_Calcaneus_X').(namePercep{iNumTrials}) = [IK.('R_Calcaneus_X').(namePercep{iNumTrials}); velTable1.('R Calcaneus X'){temp2{iNumTrials}(iSectPercep)}(2:end)]; 
            IK.('R_Calcaneus_Y').(namePercep{iNumTrials}) = [IK.('R_Calcaneus_Y').(namePercep{iNumTrials}); velTable1.("R Calcaneus Y"){temp2{iNumTrials}(iSectPercep)}(2:end)];
            IK.('R_Calcaneus_Z').(namePercep{iNumTrials}) = [IK.('R_Calcaneus_Z').(namePercep{iNumTrials}); velTable1.("R Calcaneus Z"){temp2{iNumTrials}(iSectPercep)}(2:end)];
            IK.('R_Calc_Smooth').(namePercep{iNumTrials}) = [IK.('R_Calc_Smooth').(namePercep{iNumTrials}); velTable1.("R Calc Smooth"){temp2{iNumTrials}(iSectPercep)}(2:end)];
            IK.('L_Calcaneus_X').(namePercep{iNumTrials}) = [IK.('L_Calcaneus_X').(namePercep{iNumTrials}); velTable1.("L Calcaneus X"){temp2{iNumTrials}(iSectPercep)}(2:end)];
            IK.('L_Calcaneus_Y').(namePercep{iNumTrials}) = [IK.('L_Calcaneus_Y').(namePercep{iNumTrials}); velTable1.("L Calcaneus Y"){temp2{iNumTrials}(iSectPercep)}(2:end)];
            IK.('L_Calcaneus_Z').(namePercep{iNumTrials}) = [IK.('L_Calcaneus_Z').(namePercep{iNumTrials}); velTable1.("L Calcaneus Z"){temp2{iNumTrials}(iSectPercep)}(2:end)];
            IK.('L_Calc_Smooth').(namePercep{iNumTrials}) = [IK.('L_Calc_Smooth').(namePercep{iNumTrials}); velTable1.("L Calc Smooth"){temp2{iNumTrials}(iSectPercep)}(2:end)];
            IK.('velTime').(namePercep{iNumTrials}) = [IK.('velTime').(namePercep{iNumTrials}); IK.('velTime').(namePercep{iNumTrials})(end)+ velTable1.("Time (s)"){temp1{iNumTrials}(iSectPercep)}(2:end)];
        else
            IK.("vCoM_X").(namePercep{iNumTrials}) = [velTable1.('vCoM X'){temp2{iNumTrials}(iSectPercep)};]; 
            IK.("vCoM_Y").(namePercep{iNumTrials}) = [velTable1.('vCoM Y'){temp2{iNumTrials}(iSectPercep)};]; 
            IK.("vCoM_Z").(namePercep{iNumTrials}) = [velTable1.('vCoM Z'){temp2{iNumTrials}(iSectPercep)}];
            IK.('R_Calcaneus_X').(namePercep{iNumTrials}) = [velTable1.('R Calcaneus X'){temp2{iNumTrials}(iSectPercep)}]; 
            IK.('R_Calcaneus_Y').(namePercep{iNumTrials}) = [velTable1.("R Calcaneus Y"){temp2{iNumTrials}(iSectPercep)}];
            IK.('R_Calcaneus_Z').(namePercep{iNumTrials}) = [velTable1.("R Calcaneus Z"){temp2{iNumTrials}(iSectPercep)}];
            IK.('R_Calc_Smooth').(namePercep{iNumTrials}) = [velTable1.("R Calc Smooth"){temp2{iNumTrials}(iSectPercep)}];
            IK.('L_Calcaneus_X').(namePercep{iNumTrials}) = [velTable1.("L Calcaneus X"){temp2{iNumTrials}(iSectPercep)}];
            IK.('L_Calcaneus_Y').(namePercep{iNumTrials}) = [velTable1.("L Calcaneus Y"){temp2{iNumTrials}(iSectPercep)}];
            IK.('L_Calcaneus_Z').(namePercep{iNumTrials}) = [velTable1.("L Calcaneus Z"){temp2{iNumTrials}(iSectPercep)}];
            IK.('L_Calc_Smooth').(namePercep{iNumTrials}) = [velTable1.("L Calc Smooth"){temp2{iNumTrials}(iSectPercep)}];
            IK.('velTime').(namePercep{iNumTrials}) = [velTable1.("Time (s)"){temp2{iNumTrials}(iSectPercep)}];        
        end     
    end
    
end


for iNumTrials = 1:numTrials % Creating a IK table for each subject with all CoM data for each perception trial
   if iNumTrials == 1
        BodyAnalysisTable = table(namePercep(iNumTrials),{IK.posTime.(namePercep{iNumTrials})}, {IK.('CoM_X').(namePercep{iNumTrials})}, {IK.('CoM_Y').(namePercep{iNumTrials})},...
            {IK.('CoM_Z').(namePercep{iNumTrials})}, {IK.('velTime').(namePercep{iNumTrials})}, {IK.('vCoM_X').(namePercep{iNumTrials})},...
            {IK.('vCoM_Y').(namePercep{iNumTrials})},{IK.('vCoM_Z').(namePercep{iNumTrials})}, {IK.('R_Calcaneus_X').(namePercep{iNumTrials})},...
            {IK.('R_Calcaneus_Y').(namePercep{iNumTrials})}, {IK.('R_Calcaneus_Z').(namePercep{iNumTrials})}, {IK.('R_Calc_Smooth').(namePercep{iNumTrials})},...
            {IK.('L_Calcaneus_X').(namePercep{iNumTrials})},{IK.('L_Calcaneus_Y').(namePercep{iNumTrials})}, {IK.('L_Calcaneus_Z').(namePercep{iNumTrials})},...
            {IK.('L_Calc_Smooth').(namePercep{iNumTrials})}, 'VariableNames', {'Trial';'Pos_Time_(s)'; 'CoM_X'; 'CoM_Y'; 'CoM_Z'; 'Vel_Time_(s)'; 'vCoM_X';...
            'vCoM_Y'; 'vCoM_Z'; 'R_Calcaneus_X'; 'R_Calcaneus_Y'; 'R_Calcaneus_Z'; 'R_Calc_Smooth'; 'L_Calcaneus_X'; 'L_Calcaneus_Y'; 'L_Calcaneus_Z';...
            'L_Calc_Smooth';});
    else
        BodyAnalysisTable.Trial(iNumTrials) = namePercep(iNumTrials);
        BodyAnalysisTable.('Pos_Time_(s)')(iNumTrials) = {IK.posTime.(namePercep{iNumTrials})};
        BodyAnalysisTable.('CoM_X')(iNumTrials) = {IK.('CoM_X').(namePercep{iNumTrials})};
        BodyAnalysisTable.('CoM_Y')(iNumTrials) = {IK.('CoM_Y').(namePercep{iNumTrials})};
        BodyAnalysisTable.('CoM_Z')(iNumTrials) = {IK.('CoM_Z').(namePercep{iNumTrials})};
        BodyAnalysisTable.('Vel_Time_(s)')(iNumTrials) = {IK.('velTime').(namePercep{iNumTrials})};
        BodyAnalysisTable.('vCoM_X')(iNumTrials) = {IK.('vCoM_X').(namePercep{iNumTrials})};
        BodyAnalysisTable.('vCoM_Y')(iNumTrials) = {IK.('vCoM_Y').(namePercep{iNumTrials})};
        BodyAnalysisTable.('vCoM_Z')(iNumTrials) = {IK.('vCoM_Z').(namePercep{iNumTrials})};
        BodyAnalysisTable.('R_Calcaneus_X')(iNumTrials) = {IK.('R_Calcaneus_X').(namePercep{iNumTrials})};
        BodyAnalysisTable.('R_Calcaneus_Y')(iNumTrials) = {IK.('R_Calcaneus_Y').(namePercep{iNumTrials})};
        BodyAnalysisTable.('R_Calcaneus_Z')(iNumTrials) = {IK.('R_Calcaneus_Z').(namePercep{iNumTrials})};
        BodyAnalysisTable.('R_Calc_Smooth')(iNumTrials) = {IK.('R_Calc_Smooth').(namePercep{iNumTrials})};
        BodyAnalysisTable.('L_Calcaneus_X')(iNumTrials) = {IK.('L_Calcaneus_X').(namePercep{iNumTrials})};
        BodyAnalysisTable.('L_Calcaneus_Y')(iNumTrials) = {IK.('L_Calcaneus_Y').(namePercep{iNumTrials})};
        BodyAnalysisTable.('L_Calcaneus_Z')(iNumTrials) = {IK.('L_Calcaneus_Z').(namePercep{iNumTrials})};
        BodyAnalysisTable.('L_Calc_Smooth')(iNumTrials) = {IK.('L_Calc_Smooth').(namePercep{iNumTrials})};
   end   
end

%% Adding the treadmill trials to the IK table 

% This loop finds the indicies of the position CoM table of the subsections of
% each perception trial 
for iTreadtrials = 1:size(posTable1.('Trial Name'),1)
    A(iTreadtrials) = contains(posTable1.('Trial Name'){iTreadtrials}, 'Treadmill');
end

if numTreadmillTrials <= 4 
    Tread1 = find(A == 1); % Indicies for Treadmill trials in the trialTable
else                                                                    % Need to figure out how to adjust for more trials IE if there are bad trials and we recorded up through Percep06 or something 
end

% This loop finds the indicies of the position CoM table of the subsections of
% each perception trial 
for iTreadtrials = 1:size(velTable1.('Trial Name'),1)
    B(iTreadtrials) = contains(velTable1.('Trial Name'){iTreadtrials}, 'Treadmill');
end

if numTreadmillTrials <= 4 
    Tread2 = find(B == 1); % Indicies for Treadmill trials in the trialTable
else                                                                    % Need to figure out how to adjust for more trials IE if there are bad trials and we recorded up through Percep06 or something 
end

for iTread1 = 1:size(Tread1,2) % Concatenate all the position CoM calculations for the Treadmill trials
    IK.("CoM_X").(nameTreadmill{iTread1}) = [posTable1.('CoM X'){Tread1(iTread1)};]; 
    IK.("CoM_Y").(nameTreadmill{iTread1}) = [posTable1.('CoM Y'){Tread1(iTread1)};]; 
    IK.("CoM_Z").(nameTreadmill{iTread1}) = [posTable1.('CoM Z'){Tread1(iTread1)}]; 
    IK.('posTime').(nameTreadmill{iTread1}) = [posTable1.("Time (s)"){Tread1(iTread1)}]; 
end

for iTread2 = 1:size(Tread2,2) % Concatenate all the velocity CoM Calculations for the Treadmill Trials 
    IK.("vCoM_X").(nameTreadmill{iTread2}) = [velTable1.('vCoM X'){Tread2(iTread2)}]; 
    IK.("vCoM_Y").(nameTreadmill{iTread2}) = [velTable1.('vCoM Y'){Tread2(iTread2)}]; 
    IK.("vCoM_Z").(nameTreadmill{iTread2}) = [velTable1.('vCoM Z'){Tread2(iTread2)}]; 
    IK.('R_Calcaneus_X').(nameTreadmill{iTread2}) = [velTable1.('R Calcaneus X'){Tread2(iTread2)}]; 
    IK.('R_Calcaneus_Y').(nameTreadmill{iTread2}) = [velTable1.("R Calcaneus Y"){Tread2(iTread2)}];
    IK.('R_Calcaneus_Z').(nameTreadmill{iTread2}) = [velTable1.("R Calcaneus Z"){Tread2(iTread2)}];
    IK.('R_Calc_Smooth').(nameTreadmill{iTread2}) = [velTable1.("R Calc Smooth"){Tread2(iTread2)}];
    IK.('L_Calcaneus_X').(nameTreadmill{iTread2}) = [velTable1.("L Calcaneus X"){Tread2(iTread2)}];
    IK.('L_Calcaneus_Y').(nameTreadmill{iTread2}) = [velTable1.("L Calcaneus Y"){Tread2(iTread2)}];
    IK.('L_Calcaneus_Z').(nameTreadmill{iTread2}) = [velTable1.("L Calcaneus Z"){Tread2(iTread2)}];
    IK.('L_Calc_Smooth').(nameTreadmill{iTread2}) = [velTable1.("L Calc Smooth"){Tread2(iTread2)}];
    IK.('velTime').(nameTreadmill{iTread2}) = [velTable1.("Time (s)"){Tread2(iTread2)}];
end
  

for iNumTrials = 1:numTreadmillTrials % Creating a IK table for each subject with all CoM data for each treadmill trial
    tempRow = size(BodyAnalysisTable,1) + 1;
    BodyAnalysisTable.Trial(tempRow) = nameTreadmill(iNumTrials);
    BodyAnalysisTable.('Pos_Time_(s)')(tempRow) = {IK.posTime.(nameTreadmill{iNumTrials})};
    BodyAnalysisTable.('CoM_X')(tempRow) = {IK.('CoM_X').(nameTreadmill{iNumTrials})};
    BodyAnalysisTable.('CoM_Y')(tempRow) = {IK.('CoM_Y').(nameTreadmill{iNumTrials})};
    BodyAnalysisTable.('CoM_Z')(tempRow) = {IK.('CoM_Z').(nameTreadmill{iNumTrials})};
    BodyAnalysisTable.('Vel_Time_(s)')(tempRow) = {IK.('velTime').(nameTreadmill{iNumTrials})};
    BodyAnalysisTable.('vCoM_X')(tempRow) = {IK.('vCoM_X').(nameTreadmill{iNumTrials})};
    BodyAnalysisTable.('vCoM_Y')(tempRow) = {IK.('vCoM_Y').(nameTreadmill{iNumTrials})};
    BodyAnalysisTable.('vCoM_Z')(tempRow) = {IK.('vCoM_Z').(nameTreadmill{iNumTrials})};
    BodyAnalysisTable.('R_Calcaneus_X')(tempRow) = {IK.('R_Calcaneus_X').(nameTreadmill{iNumTrials})};
    BodyAnalysisTable.('R_Calcaneus_Y')(tempRow) = {IK.('R_Calcaneus_Y').(nameTreadmill{iNumTrials})};
    BodyAnalysisTable.('R_Calcaneus_Z')(tempRow) = {IK.('R_Calcaneus_Z').(nameTreadmill{iNumTrials})};
    BodyAnalysisTable.('R_Calc_Smooth')(tempRow) = {IK.('R_Calc_Smooth').(nameTreadmill{iNumTrials})};
    BodyAnalysisTable.('L_Calcaneus_X')(tempRow) = {IK.('L_Calcaneus_X').(nameTreadmill{iNumTrials})};
    BodyAnalysisTable.('L_Calcaneus_Y')(tempRow) = {IK.('L_Calcaneus_Y').(nameTreadmill{iNumTrials})};
    BodyAnalysisTable.('L_Calcaneus_Z')(tempRow) = {IK.('L_Calcaneus_Z').(nameTreadmill{iNumTrials})};
    BodyAnalysisTable.('L_Calc_Smooth')(tempRow) = {IK.('L_Calc_Smooth').(nameTreadmill{iNumTrials})};
end

% %% Create a Muscle Table for all the muscle activity data (Musculo tendon length and velocity) concatenated for all the subtrials of each Perception trial 
% 
% 
% % This loop finds the indicies of the position table of the subsections of
% % each perception trial 
% for iSubtrials = 1:size(tendonTable1.('Trial Name'),1)
%     tenA(iSubtrials) = contains(tendonTable1.('Trial Name'){iSubtrials}, 'Percep01');
%     tenB(iSubtrials) = contains(tendonTable1.('Trial Name'){iSubtrials}, 'Percep02');
%     tenC(iSubtrials) = contains(tendonTable1.('Trial Name'){iSubtrials}, 'Percep03');
%     tenD(iSubtrials) = contains(tendonTable1.('Trial Name'){iSubtrials}, 'Percep04');
%     tenE(iSubtrials) = contains(tendonTable1.('Trial Name'){iSubtrials}, 'Percep05');
%     tenF(iSubtrials) = contains(tendonTable1.('Trial Name'){iSubtrials}, 'Percep06');
%     tenG(iSubtrials) = contains(tendonTable1.('Trial Name'){iSubtrials}, 'Percep07');
%     tenH(iSubtrials) = contains(tendonTable1.('Trial Name'){iSubtrials}, 'Percep08');
% end
% 
% if numTrials <= 5 
%     tenA = find(tenA == 1); % Indicies for Percep01 in the posTable
%     tenB = find(tenB == 1); % Indicies for Percep02 in the posTable
%     tenC = find(tenC == 1); % Indicies for Percep03 in the posTable
%     tenD = find(tenD == 1); % Indicies for Percep04 in the posTable
%     tenE = find(tenE == 1);
% else % Need to figure out how to adjust for more trials IE if there are bad trials and we recorded up through Percep06 or something 
% end
% 
% % Combining all the indicies of the muscle activity subtrials to one matrix
% temp3 = {tenA; tenB; tenC; tenD; tenE};
% 
% for iNumTrials = 1:numTrials
% %     Creating empty matricies for preallocating space for later in the
% %     loop
%     MA.('R_Med_Gastroc_Length').(namePercep{iNumTrials}) = []; 
%     MA.("R_Lat_Gastroc_Length").(namePercep{iNumTrials}) = []; 
%     MA.("R_Soleus_Length").(namePercep{iNumTrials}) = []; 
%     MA.("R_Tib_Ant_Length").(namePercep{iNumTrials}) = []; 
%     MA.("L_Med_Gastroc_Length").(namePercep{iNumTrials}) = []; 
%     MA.("L_Lat_Gastroc_Length").(namePercep{iNumTrials}) = []; 
%     MA.('L_Soleus_Length').(namePercep{iNumTrials}) = []; 
%     MA.('L_Tib_Ant_Length').(namePercep{iNumTrials}) = [];
%     MA.('R_Med_Gastroc_Velocity').(namePercep{iNumTrials}) = [];
%     MA.('R_Lat_Gastroc_Velocity').(namePercep{iNumTrials}) = [];
%     MA.('R_Soleus_Velocity').(namePercep{iNumTrials}) = [];
%     MA.('R_Tib_Ant_Velocity').(namePercep{iNumTrials}) = [];
%     MA.('L_Med_Gastroc_Velocity').(namePercep{iNumTrials}) = [];
%     MA.('L_Lat_Gastroc_Velocity').(namePercep{iNumTrials}) = [];
%     MA.('L_Soleus_Velocity').(namePercep{iNumTrials}) = [];
%     MA.('L_Tib_Ant_Velocity').(namePercep{iNumTrials}) = [];
%     MA.('time').(namePercep{iNumTrials}) = [];
%     for iSectPercep = 1:size(temp3{iNumTrials},2) % Concatenate all the muscle tendon length and velocity calculations for the subtrials of the Perception trials
%         if iSectPercep > 1 
%             MA.('R_Med_Gastroc_Length').(namePercep{iNumTrials}) = [MA.('R_Med_Gastroc_Length').(namePercep{iNumTrials}); tendonTable1.('R Med Gastroc Length'){temp3{iNumTrials}(iSectPercep)}(2:end)]; 
%             MA.("R_Lat_Gastroc_Length").(namePercep{iNumTrials}) = [MA.("R_Lat_Gastroc_Length").(namePercep{iNumTrials}); tendonTable1.("R Lat Gastroc Length"){temp3{iNumTrials}(iSectPercep)}(2:end)]; 
%             MA.("R_Soleus_Length").(namePercep{iNumTrials}) = [MA.("R_Soleus_Length").(namePercep{iNumTrials}); tendonTable1.("R Soleus Length"){temp3{iNumTrials}(iSectPercep)}(2:end)]; 
%             MA.("R_Tib_Ant_Length").(namePercep{iNumTrials}) = [MA.("R_Tib_Ant_Length").(namePercep{iNumTrials}); tendonTable1.("R Tib Ant Length"){temp3{iNumTrials}(iSectPercep)}(2:end)]; 
%             MA.("L_Med_Gastroc_Length").(namePercep{iNumTrials}) = [MA.("L_Med_Gastroc_Length").(namePercep{iNumTrials}); tendonTable1.("L Med Gastroc Length"){temp3{iNumTrials}(iSectPercep)}(2:end)]; 
%             MA.("L_Lat_Gastroc_Length").(namePercep{iNumTrials}) = [MA.("L_Lat_Gastroc_Length").(namePercep{iNumTrials}); tendonTable1.("L Lat Gastroc Length"){temp3{iNumTrials}(iSectPercep)}(2:end)]; 
%             MA.('L_Soleus_Length').(namePercep{iNumTrials}) = [MA.('L_Soleus_Length').(namePercep{iNumTrials}); tendonTable1.('L Soleus Length'){temp3{iNumTrials}(iSectPercep)}(2:end)]; 
%             MA.('L_Tib_Ant_Length').(namePercep{iNumTrials}) = [MA.('L_Tib_Ant_Length').(namePercep{iNumTrials}); tendonTable1.('L Tib Ant Length'){temp3{iNumTrials}(iSectPercep)}(2:end)]; 
%             MA.('R_Med_Gastroc_Velocity').(namePercep{iNumTrials}) = [MA.('R_Med_Gastroc_Velocity').(namePercep{iNumTrials}); tendonTable1.("R Soleus Velocity"){temp3{iNumTrials}(iSectPercep)}(2:end)]; 
%             MA.("R_Lat_Gastroc_Velocity").(namePercep{iNumTrials}) = [MA.("R_Lat_Gastroc_Velocity").(namePercep{iNumTrials}); tendonTable1.("R Lat Gastroc Velocity"){temp3{iNumTrials}(iSectPercep)}(2:end)]; 
%             MA.("R_Soleus_Velocity").(namePercep{iNumTrials}) = [MA.("R_Soleus_Velocity").(namePercep{iNumTrials}); tendonTable1.("R Soleus Velocity"){temp3{iNumTrials}(iSectPercep)}(2:end)]; 
%             MA.("R_Tib_Ant_Velocity").(namePercep{iNumTrials}) = [MA.("R_Tib_Ant_Velocity").(namePercep{iNumTrials}); tendonTable1.('R Tib Ant Velocity'){temp3{iNumTrials}(iSectPercep)}(2:end)]; 
%             MA.("L_Med_Gastroc_Velocity").(namePercep{iNumTrials}) = [MA.("L_Med_Gastroc_Velocity").(namePercep{iNumTrials}); tendonTable1.("L Med Gastroc Velocity"){temp3{iNumTrials}(iSectPercep)}(2:end)]; 
%             MA.("L_Lat_Gastroc_Velocity").(namePercep{iNumTrials}) = [MA.("L_Lat_Gastroc_Velocity").(namePercep{iNumTrials}); tendonTable1.("L Lat Gastroc Velocity"){temp3{iNumTrials}(iSectPercep)}(2:end)]; 
%             MA.('L_Soleus_Velocity').(namePercep{iNumTrials}) = [MA.('L_Soleus_Velocity').(namePercep{iNumTrials}); tendonTable1.('L Soleus Velocity'){temp3{iNumTrials}(iSectPercep)}(2:end)]; 
%             MA.('L_Tib_Ant_Velocity').(namePercep{iNumTrials}) = [MA.('L_Tib_Ant_Velocity').(namePercep{iNumTrials}); tendonTable1.("L Tib Ant Velocity"){temp3{iNumTrials}(iSectPercep)}(2:end)]; 
%             MA.('time').(namePercep{iNumTrials}) = [MA.('time').(namePercep{iNumTrials}); MA.('time').(namePercep{iNumTrials})(end) + tendonTable1.("Time (s)"){temp3{iNumTrials}(iSectPercep)}(2:end)];        
%         else
%             MA.('R_Med_Gastroc_Length').(namePercep{iNumTrials}) = [tendonTable1.('R Med Gastroc Length'){temp3{iNumTrials}(iSectPercep)};]; 
%             MA.("R_Lat_Gastroc_Length").(namePercep{iNumTrials}) = [tendonTable1.("R Lat Gastroc Length"){temp3{iNumTrials}(iSectPercep)};]; 
%             MA.("R_Soleus_Length").(namePercep{iNumTrials}) = [tendonTable1.("R Soleus Length"){temp3{iNumTrials}(iSectPercep)}]; 
%             MA.("R_Tib_Ant_Length").(namePercep{iNumTrials}) = [tendonTable1.("R Tib Ant Length"){temp3{iNumTrials}(iSectPercep)};]; 
%             MA.("L_Med_Gastroc_Length").(namePercep{iNumTrials}) = [tendonTable1.("L Med Gastroc Length"){temp3{iNumTrials}(iSectPercep)};]; 
%             MA.("L_Lat_Gastroc_Length").(namePercep{iNumTrials}) = [tendonTable1.("L Lat Gastroc Length"){temp3{iNumTrials}(iSectPercep)}]; 
%             MA.('L_Soleus_Length').(namePercep{iNumTrials}) = [tendonTable1.('L Soleus Length'){temp3{iNumTrials}(iSectPercep)};]; 
%             MA.('L_Tib_Ant_Length').(namePercep{iNumTrials}) = [tendonTable1.('L Tib Ant Length'){temp3{iNumTrials}(iSectPercep)};]; 
%             MA.('R_Med_Gastroc_Velocity').(namePercep{iNumTrials}) = [tendonTable1.("R Soleus Velocity"){temp3{iNumTrials}(iSectPercep)}]; 
%             MA.("R_Lat_Gastroc_Velocity").(namePercep{iNumTrials}) = [tendonTable1.("R Lat Gastroc Velocity"){temp3{iNumTrials}(iSectPercep)};]; 
%             MA.("R_Soleus_Velocity").(namePercep{iNumTrials}) = [tendonTable1.("R Soleus Velocity"){temp3{iNumTrials}(iSectPercep)}]; 
%             MA.("R_Tib_Ant_Velocity").(namePercep{iNumTrials}) = [tendonTable1.('R Med Gastroc Velocity'){temp3{iNumTrials}(iSectPercep)};]; 
%             MA.("L_Med_Gastroc_Velocity").(namePercep{iNumTrials}) = [tendonTable1.("R Lat Gastroc Velocity"){temp3{iNumTrials}(iSectPercep)};]; 
%             MA.("L_Lat_Gastroc_Velocity").(namePercep{iNumTrials}) = [tendonTable1.("R Soleus Velocity"){temp3{iNumTrials}(iSectPercep)}]; 
%             MA.('L_Soleus_Velocity').(namePercep{iNumTrials}) = [tendonTable1.('R Med Gastroc Velocity'){temp3{iNumTrials}(iSectPercep)};]; 
%             MA.('L_Tib_Ant_Velocity').(namePercep{iNumTrials}) = [tendonTable1.("R Lat Gastroc Velocity"){temp3{iNumTrials}(iSectPercep)};]; 
%             MA.('time').(namePercep{iNumTrials}) = [tendonTable1.("Time (s)"){temp3{iNumTrials}(iSectPercep)}];        
%         end     
%     end 
%     
% 
% end
% 
% for iNumTrials = 1:numTrials % Creating a muscle activity table for each subject with all MTL and MTV for each perception trial
%      if iNumTrials == 1 % Creating the table for concatenated tendon length and velocity data for 4 muscles on each leg
%         muscleTable = table(namePercep(iNumTrials), {MA.('time').(namePercep{iNumTrials})}, {MA.('R_Med_Gastroc_Length').(namePercep{iNumTrials})}, {MA.("R_Lat_Gastroc_Length").(namePercep{iNumTrials})}, {MA.("R_Soleus_Length").(namePercep{iNumTrials})},...
%             {MA.("R_Tib_Ant_Length").(namePercep{iNumTrials})}, {MA.("L_Med_Gastroc_Length").(namePercep{iNumTrials})}, {MA.("L_Lat_Gastroc_Length").(namePercep{iNumTrials})},...
%             {MA.('L_Soleus_Length').(namePercep{iNumTrials})}, {MA.('L_Tib_Ant_Length').(namePercep{iNumTrials})}, {MA.('R_Med_Gastroc_Velocity').(namePercep{iNumTrials})},...
%             {MA.("R_Lat_Gastroc_Velocity").(namePercep{iNumTrials})}, {MA.("R_Soleus_Velocity").(namePercep{iNumTrials})}, {MA.("R_Tib_Ant_Velocity").(namePercep{iNumTrials})},...
%             {MA.("L_Med_Gastroc_Velocity").(namePercep{iNumTrials})}, {MA.("L_Lat_Gastroc_Velocity").(namePercep{iNumTrials})},...
%             {MA.('L_Soleus_Velocity').(namePercep{iNumTrials})}, {MA.('L_Tib_Ant_Velocity').(namePercep{iNumTrials})},...
%             'VariableNames',{'Trial';'Time (s)';...
%             'R Med Gastroc Length'; 'R Lat Gastroc Length';'R Soleus Length';'R Tib Ant Length';...
%             'L Med Gastroc Length'; 'L Lat Gastroc Length'; 'L Soleus Length'; 'L Tib Ant Length'; 'R Med Gastroc Velocity';...
%             'R Lat Gastroc Velocity'; 'R Soleus Velocity';'R Tib Ant Velocity'; 'L Med Gastroc Velocity';...
%             'L Lat Gastroc Velocity'; 'L Soleus Velocity'; 'L Tib Ant Velocity';});
%     else % Filling the table with the remaining values
%         muscleTable.Trial(iNumTrials) = namePercep(iNumTrials);
%         muscleTable.('Time (s)')(iNumTrials) = {MA.('time').(namePercep{iNumTrials})};
%         muscleTable.('R Med Gastroc Length')(iNumTrials) = {MA.('R_Med_Gastroc_Length').(namePercep{iNumTrials})};
%         muscleTable.('R Lat Gastroc Length')(iNumTrials) = {MA.("R_Lat_Gastroc_Length").(namePercep{iNumTrials})};
%         muscleTable.('R Soleus Length')(iNumTrials) = {MA.("R_Soleus_Length").(namePercep{iNumTrials})};
%         muscleTable.('R Tib Ant Length')(iNumTrials) = {MA.("R_Tib_Ant_Length").(namePercep{iNumTrials})};
%         muscleTable.('L Med Gastroc Length')(iNumTrials) = {MA.("L_Med_Gastroc_Length").(namePercep{iNumTrials})};
%         muscleTable.('L Lat Gastroc Length')(iNumTrials) = {MA.("L_Lat_Gastroc_Length").(namePercep{iNumTrials})};
%         muscleTable.('L Soleus Length')(iNumTrials) = {MA.('L_Soleus_Length').(namePercep{iNumTrials})};
%         muscleTable.('L Tib Ant Length')(iNumTrials) = {MA.('L_Tib_Ant_Length').(namePercep{iNumTrials})};
%         muscleTable.('R Med Gastroc Velocity')(iNumTrials) = {MA.('R_Med_Gastroc_Velocity').(namePercep{iNumTrials})};
%         muscleTable.('R Lat Gastroc Velocity')(iNumTrials) = {MA.("R_Lat_Gastroc_Velocity").(namePercep{iNumTrials})};
%         muscleTable.('R Soleus Velocity')(iNumTrials) = {MA.("R_Soleus_Velocity").(namePercep{iNumTrials})};
%         muscleTable.('R Tib Ant Velocity')(iNumTrials) = {MA.("R_Tib_Ant_Velocity").(namePercep{iNumTrials})};
%         muscleTable.('L Med Gastroc Velocity')(iNumTrials) = {MA.("L_Med_Gastroc_Velocity").(namePercep{iNumTrials})};
%         muscleTable.('L Lat Gastroc Velocity')(iNumTrials) = {MA.("L_Lat_Gastroc_Velocity").(namePercep{iNumTrials})};
%         muscleTable.('L Soleus Velocity')(iNumTrials) = {MA.('L_Soleus_Velocity').(namePercep{iNumTrials})};
%         muscleTable.('L Tib Ant Velocity')(iNumTrials) = {MA.('L_Tib_Ant_Velocity').(namePercep{iNumTrials})};
%     end
% end

%% Adding the treadmill trials to the IK table 

% This loop finds the indicies of the position CoM table of the subsections of
% each perception trial 
% for iTreadtrials = 1:size(tendonTable1.('Trial Name'),1)
%     Atread(iTreadtrials) = contains(tendonTable1.('Trial Name'){iTreadtrials}, 'Treadmill');
% end
% 
% if numTreadmillTrials <= 4 
%     Tread3 = find(Atread == 1); % Indicies for Treadmill trials in the trialTable
% else                                                                    % Need to figure out how to adjust for more trials IE if there are bad trials and we recorded up through Percep06 or something 
% end
% 
% 
% for iTread3 = 1:size(Tread3,2) % Concatenate all the muscle analysis Calculations for the Treadmill Trials 
%     MA.('R_Med_Gastroc_Length').(nameTreadmill{iTread3}) = [tendonTable1.('R Med Gastroc Length'){Tread3(iTread3)};]; 
%     MA.("R_Lat_Gastroc_Length").(nameTreadmill{iTread3}) = [tendonTable1.("R Lat Gastroc Length"){Tread3(iTread3)};]; 
%     MA.("R_Soleus_Length").(nameTreadmill{iTread3}) = [tendonTable1.("R Soleus Length"){Tread3(iTread3)}]; 
%     MA.("R_Tib_Ant_Length").(nameTreadmill{iTread3}) = [tendonTable1.("R Tib Ant Length"){Tread3(iTread3)};]; 
%     MA.("L_Med_Gastroc_Length").(nameTreadmill{iTread3}) = [tendonTable1.("L Med Gastroc Length"){Tread3(iTread3)};]; 
%     MA.("L_Lat_Gastroc_Length").(nameTreadmill{iTread3}) = [tendonTable1.("L Lat Gastroc Length"){Tread3(iTread3)}]; 
%     MA.('L_Soleus_Length').(nameTreadmill{iTread3}) = [tendonTable1.('L Soleus Length'){Tread3(iTread3)};]; 
%     MA.('L_Tib_Ant_Length').(nameTreadmill{iTread3}) = [tendonTable1.('L Tib Ant Length'){Tread3(iTread3)};]; 
%     MA.('R_Med_Gastroc_Velocity').(nameTreadmill{iTread3}) = [tendonTable1.("R Soleus Velocity"){Tread3(iTread3)}]; 
%     MA.("R_Lat_Gastroc_Velocity").(nameTreadmill{iTread3}) = [tendonTable1.("R Lat Gastroc Velocity"){Tread3(iTread3)};]; 
%     MA.("R_Soleus_Velocity").(nameTreadmill{iTread3}) = [tendonTable1.("R Soleus Velocity"){Tread3(iTread3)}]; 
%     MA.("R_Tib_Ant_Velocity").(nameTreadmill{iTread3}) = [tendonTable1.('R Med Gastroc Velocity'){Tread3(iTread3)}]; 
%     MA.("L_Med_Gastroc_Velocity").(nameTreadmill{iTread3}) = [tendonTable1.("R Lat Gastroc Velocity"){Tread3(iTread3)};]; 
%     MA.("L_Lat_Gastroc_Velocity").(nameTreadmill{iTread3}) = [tendonTable1.("R Soleus Velocity"){Tread3(iTread3)}]; 
%     MA.('L_Soleus_Velocity').(nameTreadmill{iTread3}) = [tendonTable1.('R Med Gastroc Velocity'){Tread3(iTread3)};]; 
%     MA.('L_Tib_Ant_Velocity').(nameTreadmill{iTread3}) = [tendonTable1.("R Lat Gastroc Velocity"){Tread3(iTread3)};]; 
%     MA.('time').(nameTreadmill{iTread3}) = [tendonTable1.("Time (s)"){Tread3(iTread3)}];   
% end
%   
% 
% for iNumTrials = 1:numTreadmillTrials % Creating a muscle table for each subject with all muscle analysis data for each treadmill trial
%     tempRow = size(muscleTable,1) + 1;
%     muscleTable.Trial(tempRow) = nameTreadmill(iNumTrials);
%     muscleTable.('Time (s)')(tempRow) = {MA.('time').(nameTreadmill{iNumTrials})};
%     muscleTable.('R Med Gastroc Length')(tempRow) = {MA.('R_Med_Gastroc_Length').(nameTreadmill{iNumTrials})};
%     muscleTable.('R Lat Gastroc Length')(tempRow) = {MA.("R_Lat_Gastroc_Length").(nameTreadmill{iNumTrials})};
%     muscleTable.('R Soleus Length')(tempRow) = {MA.("R_Soleus_Length").(nameTreadmill{iNumTrials})};
%     muscleTable.('R Tib Ant Length')(tempRow) = {MA.("R_Tib_Ant_Length").(nameTreadmill{iNumTrials})};
%     muscleTable.('L Med Gastroc Length')(tempRow) = {MA.("L_Med_Gastroc_Length").(nameTreadmill{iNumTrials})};
%     muscleTable.('L Lat Gastroc Length')(tempRow) = {MA.("L_Lat_Gastroc_Length").(nameTreadmill{iNumTrials})};
%     muscleTable.('L Soleus Length')(tempRow) = {MA.('L_Soleus_Length').(nameTreadmill{iNumTrials})};
%     muscleTable.('L Tib Ant Length')(tempRow) = {MA.('L_Tib_Ant_Length').(nameTreadmill{iNumTrials})};
%     muscleTable.('R Med Gastroc Velocity')(tempRow) = {MA.('R_Med_Gastroc_Velocity').(nameTreadmill{iNumTrials})};
%     muscleTable.('R Lat Gastroc Velocity')(tempRow) = {MA.("R_Lat_Gastroc_Velocity").(nameTreadmill{iNumTrials})};
%     muscleTable.('R Soleus Velocity')(tempRow) = {MA.("R_Soleus_Velocity").(nameTreadmill{iNumTrials})};
%     muscleTable.('R Tib Ant Velocity')(tempRow) = {MA.("R_Tib_Ant_Velocity").(nameTreadmill{iNumTrials})};
%     muscleTable.('L Med Gastroc Velocity')(tempRow) = {MA.("L_Med_Gastroc_Velocity").(nameTreadmill{iNumTrials})};
%     muscleTable.('L Lat Gastroc Velocity')(tempRow) = {MA.("L_Lat_Gastroc_Velocity").(nameTreadmill{iNumTrials})};
%     muscleTable.('L Soleus Velocity')(tempRow) = {MA.('L_Soleus_Velocity').(nameTreadmill{iNumTrials})};
%     muscleTable.('L Tib Ant Velocity')(tempRow) = {MA.('L_Tib_Ant_Velocity').(nameTreadmill{iNumTrials})};
% end


%% Saving the data tables in the individual subjects folder 

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

% Saving the inverse kinematics table to be saved for each subject
save([tabLoc 'BodyAnalysisTable_' subject1], 'BodyAnalysisTable', '-v7.3');

% Saving the muscle analysis table to be saved for each subject. 
% save([tabLoc 'MuscleTable_' subject1], 'muscleTable', '-v7.3');

disp(['Tables saved for ' subject1]);
end

