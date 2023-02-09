function  effectsizeUSTab = effectSizeUS(subID, trials, domLeg, speeds, perceived)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

%% This section loads the data that has Gait cycles and MTJ calculations
% Loading the GaitEventsTable for all trials
load(['G:\Shared drives\Perception Project\Ultrasound\OpenSim\YAUSPercep' ...
    subID '\Tables\gaitEventsTable_YAUSPercep' subID '.mat']);

% Loading the MTJTable for all trials 
load(['G:\Shared drives\Perception Project\Ultrasound\OpenSim\YAUSPercep' ...
    subID '\Tables\MTJTable_YAUSPercep' subID '.mat']);

%% Long section with mutliple parts will comment as you go down 

for iTrial = 1:length(trials) % This should always be 20 (10 positive perturbations, 10 negative perturbations)
    % Getting the musculotendon length, muscle length, tendon length, atime, and usTime 
    tempMTL = MTJTable.("MT_len_(mm)"){iTrial}; 
    tempMGL = MTJTable.("MG_len_(mm)"){iTrial};
    tempATL = MTJTable.("AT_len_(mm)"){iTrial};
    atime = MTJTable.("Analog_Time_(s)"){iTrial};
    usTime = MTJTable.("US_Time_(s)"){iTrial};

    strTrial = [num2str(trials(iTrial)) '.mat']; 

    names = GETableFull.Trial; 
    idxTrial = contains(names, strTrial);
    
    % Getting the correct gait cycle table and perturbed cycle based on the
    % subjects dominant leg 
    if domLeg == 'R'
        GER = GETableFull.GETable_Right{idxTrial}; % Table with RHS based gait events
        pc = GETableFull.Pert_Cycle(idxTrial); % perturbed cycle
        % Getting the cycles before the perturbation. Subject 1 only has 4
        % cycles before some of their perturbations so adjusted their
        % comparison
        if pc >=6
            % Getting the 5 gait cycles before the perturbation 
            cbp = GER.RHS(pc-5:pc+1);
        else
            cbp = GER.RHS(pc-4:pc+1); % This is for subject 1
        end
        % upsampling the 5 gait cycles preceding the perturbation to be in analog
        % time and in 1000 hz collection rate 
        cbp = cbp.*10;
        % This loop finds the closest index of the HS in regards to the usTime
        for iRHS = 1:length(cbp)
            [minValue(iRHS),closestIndex] = min(abs(atime(cbp(iRHS))-usTime));
            usInd(iRHS) = closestIndex; 
        % Figure out if you should upsample the ultrasound data to be 1000 Hz
        % but for right now there is ~ 5ms error using the ultrasound frame
        % rate
        end
    else
        GEL = GETableFull.GETable_Left{idxTrial}; % Table with LHS based gait events
        pc = GETableFull.Pert_Cycle(idxTrial); % perturbed cycle
        % Getting the cycles before the perturbation
        cbp = GEL.LHS(pc-5:pc+1); % This is for the left legged subject 7
        % upsampling the 5 gait cycles preceding the perturbation to be in analog
        % time and in 1000 hz collection rate 
        cbp = cbp.*10;
        for iLHS = 1:length(cbp)
            [minValue(iLHS),closestIndex] = min(abs(atime(cbp(iLHS))-usTime));
            usInd(iLHS) = closestIndex; 
        % Figure out if you should upsample the ultrasound data to be 1000 Hz
        % but for right now there is ~ 5ms error using the ultrasound frame
        % rate
        end
    end

    % Making the data for the gait cycles be in % of gait cycle instead of
    % a random number of frames
    for i = 1:length(cbp)-1
        FMGL = griddedInterpolant(usTime(usInd(i):usInd(i+1)),tempMGL(usInd(i):usInd(i+1)), 'linear', 'spline');
        FATL = griddedInterpolant(usTime(usInd(i):usInd(i+1)),tempATL(usInd(i):usInd(i+1)), 'linear', 'spline');
        FMTL = griddedInterpolant(atime(cbp(i):cbp(i+1)),tempMTL(cbp(i):cbp(i+1)), 'linear', 'spline');
        % Change in time for atime as a percentage 
        dt2 = (atime(cbp(i+1))- atime(cbp(i)))/100;
        % Time matrix to interpolate or extrapolate for MTU length 
        idx2 = atime(cbp(i)):dt2:atime(cbp(i+1));
        % Change in time as a percentage
        dt = (usTime(usInd(i+1))-usTime(usInd(i)))/100;
        % Time matrix to interpolate or extrapolate 
        idx = usTime(usInd(i)):dt:usTime(usInd(i+1)); 
        
        % Creating a new matrix that is for the 5 gait cycles preperturbation
        % and the perturbed cycle for the MG length, AT length, MT length for %
        % of gait cycle
        MGL(:,i) = FMGL(idx);
        % AT length as % of gait cycle 
        ATL(:,i) = FATL(idx);
        % MT length as % of gait cycle 
        MTL(:,i) = FMTL(idx2);   
    end
%     % Smoothing the data for some minor jumps and such 
    MGL = smoothdata(MGL, 'movmean', 10);
    ATL = smoothdata(ATL, 'movmean', 10);
    MTL = smoothdata(MTL, 'movmean', 10);
    ls = size(MGL,2); % Getting this for the indices 
    % Calculating the effect size for the MG length, AT length, and MT length
    % for each % of the gait cycle 
    for iGaitCycle = 1:size(MGL,1)
        [dMGL(iGaitCycle), meanDiffMGL(iGaitCycle), sMGL(iGaitCycle)] = computeCohen_d(MGL(iGaitCycle,ls), MGL(iGaitCycle,1:ls-1));
        [dATL(iGaitCycle), meanDiffATL(iGaitCycle), sATL(iGaitCycle)] = computeCohen_d(ATL(iGaitCycle,ls), ATL(iGaitCycle,1:ls-1));
        [dMTL(iGaitCycle), meanDiffMTL(iGaitCycle), sMTL(iGaitCycle)] = computeCohen_d(MTL(iGaitCycle,ls), MTL(iGaitCycle,1:ls-1));
    end
    if iTrial == 1 
        effectsizeUSTab = table(MTJTable.Trial(1) , {dMGL}, {dATL}, {dMTL}, {meanDiffMGL}, {meanDiffATL}, ...
            {meanDiffMTL}, {sMGL}, {sATL}, {sMTL}, 'VariableNames',{'Trial'; ...
            'esMGL'; 'esATL'; 'esMTL'; 'Numer_MGL'; 'Numer_ATL'; 'Numer_MTL'; ...
            'SD_MGL'; 'SD_ATL'; 'SD_MTL'});
        lengthUSTab = table(GETableFull.Trial(1), {MGL}, {ATL}, {MTL}, 'VariableNames', {'Trial';...
            'MG_Length'; 'AT_Length'; 'MTU_Length'});
    else
        effectsizeUSTab.Trial{iTrial} = MTJTable.Trial(iTrial); % Trial name 
        effectsizeUSTab.esMGL{iTrial} = dMGL; % Effect size MGL 
        effectsizeUSTab.esATL{iTrial} = dATL; % Effect size ATL 
        effectsizeUSTab.esMTL{iTrial} = dMTL; % Effect size MTL
        effectsizeUSTab.Numer_MGL{iTrial} = meanDiffMGL; 
        effectsizeUSTab.Numer_ATL{iTrial} = meanDiffATL;
        effectsizeUSTab.Numer_MTL{iTrial} = meanDiffMTL; 
        effectsizeUSTab.SD_MGL{iTrial} = sMGL; 
        effectsizeUSTab.SD_ATL{iTrial} = sATL; 
        effectsizeUSTab.SD_MTL{iTrial} = sMTL; 

        lengthUSTab.Trial{iTrial} = MTJTable.Trial(iTrial); % Trial name 
        lengthUSTab.MG_Length{iTrial} = MGL; % MG length in terms of % gc 
        lengthUSTab.AT_Length{iTrial} = ATL; % AT length in terms of % gc
        lengthUSTab.MTU_Length{iTrial} = MTL; % MTU length in terms of % gc
    end
    clearvars -except effectsizeUSTab iTrial GETableFull MTJTable subID domLeg speeds perceived lengthUSTab trials
end

% Adding the speed labels to the table for the trials 
% 1 - negative below threshold
% 2 - negative above threshold
% 3 - positive below threshold 
% 4 - positive above threshold
effectsizeUSTab.Speeds = speeds';
% Adding the perceived labels to the table for the trials 
effectsizeUSTab.Perceived = perceived';
%% Save the table to the subjects folder 
% Changing the directory to save the gaitevents table in the subjects
% folder
saveLoc = ['G:\Shared drives\Perception Project\Ultrasound\OpenSim\YAUSPercep' subID '\Tables\'];
% Creating the subject1 name
subject1 = ['YAUSPercep' subID];

% Saving the effectsize table in the subject folder 
save([saveLoc 'effectsizeUSTable_' subject1], 'effectsizeUSTab', '-v7.3');

% Saving the length table for % gait cycle in the subject folder 
save([saveLoc 'lenMTUTable_' subject1], 'lengthUSTab', '-v7.3');

end