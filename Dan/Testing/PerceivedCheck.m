%% Checking how many subjects said yes to each perturbation level

% subName = {'05'; '07'; '10'; '11'; '12'; '13'; '14'; '15';};
subName = {'02'; '03'; '04'; '05'; '07'; '08'; '09'; '11'; '12'; '13'; '14'; '15';'17';};
for i = 1:length(subName) 
    strSubject = subName{i};
    subjectYesNo = ['YAPercep' strSubject '_YesNo'];
    subjectCog = ['YAPercep' strSubject '_Cog'];

    subject1 = ['YAPercep' strSubject];
    fileLocation = 'G:\Shared drives\NeuroMobLab\Experimental Data\Log Files\Pilot Experiments\PerceptionStudy\';
    data1 = readtable([fileLocation subjectYesNo]);
    data2 = readtable([fileLocation subjectCog]);
    Percep.YesNo.(subject1) = data1(:,[1,2,3,6,9]);
    Percep.Cog.(subject1) = data2(:,[1,2,3,6,9]);
    clear data1 data2
end

%% 
for i = 1:length(subName)
    strSubject = subName{i};
    subject1 = ['YAPercep' strSubject];
    temp2 = Percep.YesNo.(subject1).dV == 0;
    if isempty(temp2) == 1
        temp.YesNo.(subject1) = 0;
    else
        temp.YesNo.(subject1) = sum(Percep.YesNo.(subject1).perceived(temp2));
    end
    temp3 = Percep.Cog.(subject1).dV == 0;    
    if isempty(temp3) == 1
        temp.Cog.(subject1) = 0;
    else
        temp.Cog.(subject1) = sum(Percep.Cog.(subject1).perceived(temp3));
    end
end

%%

for i = 1:length(subName)
    subject = subName{i};
    perceptionThreshold(subject)
end