%% Temp solution of getting all the repeats of perturbations for each subject used for DRP and ASB 

subjects = {'05';'07' ;'08';'09';'10';'11';'12';'13';'14';'15';};

% This loop is loading all the subject log files and storing them in a
% structure.
for iSub = 1:length(subjects)
    strSubject = subjects{iSub};
    
    subjectYesNo = ['YAPercep' strSubject '_YesNo'];

    subject1 = ['YAPercep' strSubject];

    fileLocation = 'G:\Shared drives\NeuroMobLab\Experimental Data\Log Files\Pilot Experiments\PerceptionStudy\';
    data1 = readtable([fileLocation subjectYesNo]);
    Percep.(subject1) = data1(:,[1,2,3,6,9]); % Grabbing specific columns from table: Trial number, Perturbation number, Leg, dV, perceived 

    clear data1 fileLocation
end

% Finding what perturbations for all subjects are for the right leg
for iSub = 1:length(subjects) 
    strSubject = subjects{iSub};
    
    subject1 = ['YAPercep' strSubject];
    
    for iTrials = 1:length(Percep.(subject1).LegIn)
        RLeg.(subject1)(iTrials) = Percep.(subject1).LegIn{iTrials} == 'R';
    end
end
        


speeds = {'sp1'; 'sp2'; 'sp3'; 'sp4'; 'sp5'; 'sp6'; 'sp7'; 'sp8';}; % Speeds in order as above 0, -0.02, -0.5, -0.1, -0.15, -0.2, -0.3, -0.4

     
for iSub = 1:length(subjects) 
    strSubject = subjects{iSub};
    
    subject1 = ['YAPercep' strSubject];
        
    RLogSpeed.sp1.(subject1) = Percep.(subject1).dV(RLeg.(subject1)) == 0;
    RLogSpeed.sp2.(subject1) = Percep.(subject1).dV(RLeg.(subject1)) == -0.02;
    RLogSpeed.sp3.(subject1) = Percep.(subject1).dV(RLeg.(subject1)) == -0.05;
    RLogSpeed.sp4.(subject1) = Percep.(subject1).dV(RLeg.(subject1)) == -0.10;
    RLogSpeed.sp5.(subject1) = Percep.(subject1).dV(RLeg.(subject1)) == -0.15;
    RLogSpeed.sp6.(subject1) = Percep.(subject1).dV(RLeg.(subject1)) == -0.20;
    RLogSpeed.sp7.(subject1) = Percep.(subject1).dV(RLeg.(subject1)) == -0.30;
    RLogSpeed.sp8.(subject1) = Percep.(subject1).dV(RLeg.(subject1)) == -0.40;
    
    
    tempPercep.(subject1) = Percep.(subject1).perceived(RLeg.(subject1)); 
end



total = 0;
for iSpeeds = 1:length(speeds) 
    for iSub = 1:length(subjects)
        strSubject = subjects{iSub};
    
        subject1 = ['YAPercep' strSubject];
        
        RPercep.(speeds{iSpeeds}).(subject1) = sum(tempPercep.(subject1)(RLogSpeed.(speeds{iSpeeds}).(subject1)));
        total = total + sum(tempPercep.(subject1)(RLogSpeed.(speeds{iSpeeds}).(subject1)));
    end
    RPercep.(speeds{iSpeeds}).total = total; 
    RPercep.(speeds{iSpeeds}).percent = total/50*100;
    total = 0;
end
        

% total = 0;
% for iSpeeds = 1:length(speeds)
%     subject1 = 'YAPercep09';
%     
%     total = sum(RLogSpeed.(speeds{iSpeeds}).(subject1));
%     
%     tempSum.(speeds{iSpeeds}) = total;
% end

        
        
        
        
        