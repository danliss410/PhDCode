clear all 

%% This section is for standing perturbations 
level = [10 20 30 -10 -20 -30]; % This is in cm/s 
accel = 0.3058; % Acceleration is in % g
pauseVal = [1.5 0.75 0.5 1.5 0.75 0.5]; % time pause value 
nrepeats = 4; % Repeats of the values 


perturbation = [];
for j = 1:length(level)
    perturbation = [perturbation; accel level(j) pauseVal(j)];
end


pBlock1 = perturbation(randperm(length(perturbation)),:);
pBlock2 = perturbation(randperm(length(perturbation)),:);
pBlock3 = perturbation(randperm(length(perturbation)),:);
pBlock4 = perturbation(randperm(length(perturbation)),:);

perturbationParameters = [pBlock1; pBlock2; pBlock3; pBlock4];
filename = ['standingPerturbations_' date];
save(filename, 'perturbationParameters');

%% This section is for sit2stand perturbations 
clear all 
level = [0.1 0.2 0.3 -0.1 -0.2 -0.3 0];
thres = 0.08;
thresN = -0.08; %This is used for when facing the new cameras instead of towards the TV
pauseVal = [1.5 0.75 0.5 1.5 0.75 0.5 0];
accel = 3;

perturbation = [];
perturbationN = [];
for i = 1:length(level)
    perturbation = [perturbation; thres level(i) accel pauseVal(i)];
    perturbationN = [perturbationN; thresN level(i) accel pauseVal(i)];
end

% This is the parameters for facing the TV
pSet1 = perturbation(randperm(length(perturbation)),:);
pSet2 = perturbation(randperm(length(perturbation)),:);
pSet3 = perturbation(randperm(length(perturbation)),:);
pSet4 = perturbation(randperm(length(perturbation)),:);

perturbationParameters = [pSet1; pSet2; pSet3; pSet4;];
filename = ['sitToStandPerturbations_' date];
save(filename, 'perturbationParameters');

clear perturbationParameters
% This is for facing the new cameras 
pSet1 = perturbationN(randperm(length(perturbationN)),:);
pSet2 = perturbationN(randperm(length(perturbationN)),:);
pSet3 = perturbationN(randperm(length(perturbationN)),:);
pSet4 = perturbationN(randperm(length(perturbationN)),:);

perturbationParameters = [pSet1; pSet2; pSet3; pSet4;];
filename = ['sitToStandPerturbationsNeg_' date];
save(filename, 'perturbationParameters');


%% This is the section for walking perturbations 

clear all 

% level = [0.2 0.3 0.4 -0.2 -0.3 -0.4 0];
% level = [0.02 0.05 0.1 0.15 0.2 0.3 0.4 0]; % -0.02 -0.05 -0.1 -0.15 -0.2 -0.3 -0.4 0];
level = [0.02 0.05 0.1 0.15 0.2 0.25 0.3 0];
leg = [0];
accel = [5 5 5 5 5 5 5 0]; % 5 5 5 5 5 5 0];
pauseVal = 0;



perturbation = [];
for k = 1:5
    for i=1:length(leg)
        for j=1:length(level)
            perturbation = [perturbation; leg(i) leg(i) 40 level(j) accel(j) pauseVal];
        end
    end
end

tempValues = perturbation(randperm(length(perturbation)),:);

% perturbationParameters = tempValues(1:19,:);
iLeg = [1 1 40 0.2 5 0];
%%



% pSet1 = perturbation(randperm(length(perturbation)),:);
% pSet2 = perturbation(randperm(length(perturbation)),:);
% pSet3 = perturbation(randperm(length(perturbation)),:);
% pSet4 = perturbation(randperm(length(perturbation)),:);
% 
% perturbationParameters = [pSet1; pSet2; pSet3; pSet4;];
% filename = ['walkingPerturbations_' date];
% save(filename, 'perturbationParameters');

perturbationParameters = pSet(1:9,:);
filename = ['Slow01_' date];
save(filename, 'perturbationParameters');
clear perturbationParameters filename

perturbationParameters = pSet(10:18,:);
filename = ['Slow02_' date];
save(filename, 'perturbationParameters');


clear perturbationParameters filename

perturbationParameters = pSet(19:27,:);
filename = ['Slow03_' date];
save(filename, 'perturbationParameters');


clear perturbationParameters filename


perturbationParameters = pSet(28:36,:);
filename = ['Slow04_' date];
save(filename, 'perturbationParameters');


clear perturbationParameters filename


perturbationParameters = pSet(37:45,:);
filename = ['Slow05_' date];
save(filename, 'perturbationParameters');


clear perturbationParameters filename




