%%%%% This is a short temporary script to run the rest of my plotting
%%%%% results for subjects 


%% Make Matrixes of the infomation to feed to the loop 

subjects = {'05'; '07'; '10'; '11'; '12'; '13'; '14'; '15';};
domLeg = {'R'};

for i = 1:length(subjects)
    strSubject = subjects{i};
    [pEmgStruct,npEmgStruct]  =  proc_EMG_Perception(strSubject);
    disp('Finished EMG Processing')
    checkNplotEMG(strSubject, domLeg);
    disp(['Made plots for YAPercep' strSubject])
end

beep 
