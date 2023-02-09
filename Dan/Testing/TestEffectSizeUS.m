%  Test script for the effect size function 
% close all
clear 
home 

subID = ['04']; 
domLeg = 'R';

iTrial = 8;


% Loading the GaitEventsTable for all trials
load(['G:\Shared drives\Perception Project\Ultrasound\OpenSim\YAUSPercep' ...
    subID '\Tables\gaitEventsTable_YAUSPercep' subID '.mat']);

% Loading the MTJTable for all trials 
load(['G:\Shared drives\Perception Project\Ultrasound\OpenSim\YAUSPercep' ...
    subID '\Tables\MTJTable_YAUSPercep' subID '.mat']);

% Getting the correct gait cycle table and perturbed cycle based on the
% subjects dominant leg 
if domLeg == 'R'
    GER = GETableFull.GETable_Right{iTrial}; 
    pc = GETableFull.Pert_Cycle(iTrial); 
else
    GEL = GETableFull.GETable_Left{iTrial};
    pc = GETableFull.Pert_Cycle(iTrial); 
end


if pc >=6
    % Getting the 5 gait cycles before the perturbation 
    cbp = GER.RHS(pc-5:pc+1);
else
    cbp = GER.RHS(pc-4:pc+1);
end
% upsampling the 5 gait cycles preceding the perturbation to be in analog
% time and in 1000 hz collection rate 
cbp = cbp.*10;

% Getting the musculotendon length, muscle length, tendon length, 
tempMTL = MTJTable.("MT_len_(mm)"){iTrial}; 
tempMGL = MTJTable.("MG_len_(mm)"){iTrial};
tempATL = MTJTable.("AT_len_(mm)"){iTrial};
atime = MTJTable.("Analog_Time_(s)"){iTrial};
usTime = MTJTable.("US_Time_(s)"){iTrial};



for iRHS = 1:length(cbp)
    [minValue(iRHS),closestIndex] = min(abs(atime(cbp(iRHS))-usTime));
    usInd(iRHS) = closestIndex; 
    % Figure out if you should upsample the ultrasound data to be 1000 Hz
    % but for right now there is ~ 5ms error using the ultrasound frame
    % rate
end



figure; hold on; 
for i = 1:6
    MGLgc{:,i} =  smoothdata(tempMGL(usInd(i):usInd(i+1)), 'movmedian', 10);
    ATLgc{:,i} =  smoothdata(tempATL(usInd(i):usInd(i+1)), 'movmedian', 10);
    usTemp = usInd(i+1) - usInd(i);
    if i < 6 
        subplot(2,1,1); plot((0:usTemp)/usTemp,MGLgc{:,i}, 'b');
        hold on;
        subplot(2,1,2); plot((0:usTemp)/usTemp,ATLgc{:,i}, 'b');
        hold on;
    else 
        subplot(2,1,1); plot((0:usTemp)/usTemp,MGLgc{:,i}, 'r'); 
        title('Muscle Length Change'); xlabel('% of Gait Cycle'); ylabel('MG Length (mm)')
        subplot(2,1,2); plot((0:usTemp)/usTemp,ATLgc{:,i}, 'r');
        title('Tendon Length Change'); xlabel('% of Gait Cycle'); ylabel('AT Length (mm)')

    end
end

for i = 1:6
    FMGL = griddedInterpolant(usTime(usInd(i):usInd(i+1)),tempMGL(usInd(i):usInd(i+1)), 'linear', 'spline');
    
    dt = (usTime(usInd(i+1))-usTime(usInd(i)))/100;
    idMGL = usTime(usInd(i)):dt:usTime(usInd(i+1)); 
    nMGL(:,i) = FMGL(idMGL);

    FATL = griddedInterpolant(usTime(usIn))
end

for i = 1:size(nMGL,1)
    d(i) = computeCohen_d(nMGL(i,6),nMGL(:,1:5));
end

% tempIdx = usIndTemp(2)-usIndTemp(1);
% nMGL2 = resample(tempMGL(usIndTemp(1):usIndTemp(2)), 101, tempIdx);
% figure; subplot(2,1,1);plot((0:100),nMGL); 
% title('Interpolated MG Length'); xlabel('% of Gait Cycle');
% ylabel('MG length (mm)');
% subplot(2,1,2);plot((0:tempIdx)/tempIdx, MGLgc{:,1});
% title('Just pulling frames'); xlabel('% of Gait Cycle');
% ylabel('MG length (mm)');
