function thresholdTable2 = perceptionThreshold2(subject)

clearvars -except subject

%% Setting the file location based on which computer is running the code

if ispc
    fileLocation = 'G:\Shared drives\NeuroMobLab\Experimental Data\Log Files\Pilot Experiments\PerceptionStudy\';
    
elseif ismac
    fileLocation                                = '/Volumes/GoogleDrive/Shared drives/NeuroMobLab/Experimental Data/Log Files/Pilot Experiments/PerceptionStudy/';
else
    fileLocation                                = input('Please enter the file location:' );
end

startLocation                                   = 'D:\Github\Perception-Project\Dan\Data Processing and Analysis';

cd(fileLocation)


%% Set-up options for the psychometric curve fit
% need to download the pyschometric toolbox: https://github.com/wichmann-lab/psignifit/wiki

options                                         = struct;
% options.sigmoidName = 'norm';
options.sigmoidName                             = 'logistic';
options.threshPC                                = 0.5;


%% Create subject name to load the log file for the subject 
% Naming convention for each log file "YAPercep##_" + YesNo or 2AFC or Cog

subjectYesNo                                    = ['YAPercep' subject '_YesNo'];

subject2AFC                                     = ['YAPercep' subject '_2AFC'];

subjectCog                                      = ['YAPercep' subject '_Cog'];

subject1                                        = ['YAPercep' subject];


% Check to see which files exist for the subject

rtYesNo                                         = exist([subjectYesNo '.txt'], 'file');

rt2AFC                                          = exist([subject2AFC '.txt'], 'file');

rtCog                                           = exist([subjectCog '.txt'], 'file');


% Load the YesNo log file that exist for the subject
name = {};


if rtYesNo                                      == 2
    data1.(subjectYesNo)                        = readtable([fileLocation subjectYesNo]);
    data.(subjectYesNo)                         = data1.(subjectYesNo)(:,[1,2,3,6,9]);
    name                                        = (subjectYesNo);
end


% Load the 2AFC log file if it exists for the subject 

if rt2AFC                                       == 2
    data1.(subject2AFC)                         = readtable([fileLocation subject2AFC]);
    data.(subject2AFC)                          = data1.(subject2AFC)(:,[1,2,3,6,9]);
    name                                        = {name; subject2AFC};
else
    disp([subject2AFC ' does not exist'])
end


% Load the Cognitive log file if it exists for the subject 

if rtCog                                        == 2
    data1.(subjectCog)                          = readtable([fileLocation subjectCog]);
    data.(subjectCog)                           = data1.(subjectCog)(:,[1,2,3,6,9]);
    name                                        = {name; subjectCog}; 
else
    disp([subjectCog ' does not exist'])
end


for iSubject                                    = 1:length(name)
    left                                        = strncmp('L', data.(name{iSubject}).LegIn,1);
    right                                       = strncmp('R', data.(name{iSubject}).LegIn,1);
    
    dv_r                                        = data.(name{iSubject}).dV(right);
    dv_l                                        = data.(name{iSubject}).dV(left);
    
    vel                                         = unique(data.(name{iSubject}).dV);
    pos_v                                       = vel(vel>0);
    neg_v                                       = flip(vel(vel<0));
    if contains(name{iSubject}, '2AFC')         ~= 1
        percepR                                 = data.(name{iSubject}).perceived(right);
        percepL                                 = data.(name{iSubject}).perceived(left);
        options.expType                         = 'YesNo';
    else
        percepR                                 = data.(name{iSubject}).Left_1(right);
        percepL                                 = data.(name{iSubject}).Left_1(left);
        options.expType                         = '2AFC';
    end
    if length(pos_v) == 1
        pos_v = [];
    end
    
    if isempty(pos_v)                           == 1 %No positive perturbation data collected 
        
        % Finding the indicies of the perception experiemnt where the each leg
        % was perturbed in the negative direction
        for iVel                                = 1:length(neg_v)
            perNegR{:,iVel}                     = percepR(dv_r == neg_v(iVel));
            perNegL{:,iVel}                     = percepL(dv_l == neg_v(iVel));
        end
    
         % Calculating the amount correct and total for each negative velocity
        for iVel                                = 1:length(neg_v)
            perNTrueR{iVel}                     = sum(perNegR{:,iVel});
            perNTotR{iVel}                      = length(perNegR{:,iVel});
        
            perNTrueL{iVel}                     = sum(perNegL{:,iVel});
            perNTotL{iVel}                      = length(perNegL{:,iVel});
        end
        
        % Fixing the Threshold Values for 2AFC
        if contains(name{iSubject}, '2AFC')     == 1
            for iVel                            = 1:length(neg_v)
                perNTrueR{iVel}                 = 5 - sum(perNegR{:,iVel});
            end
        end
        
        % Fixing the catch trials so it's out of 10 instead of 5 
%         tempVar = perNTrueR{1,1}; %saving the amount of catch trials said for right legs in a temp var
%         tempVar2 = perNTotR{1,1}; % saving the total amount of catch trials for the right leg
%         perNTrueR{1,1} = perNTrueR{1,1} + perNTrueL{1,1}; % Making the catch trials for the right leg out of 10 instead of 5 
%         perNTrueL{1,1} = tempVar + perNTrueL{1,1}; % Making the catch trials for the left leg out of 10 instead of 5
%         perNTotR{1,1} = tempVar2 + perNTotL{1,1}; % Changing the total out of 10 
%         perNTotL{1,1} = tempVar2 + perNTotL{1,1}; % Changing the total out of 10
        
        % Formatting the velocities, % correct, and total trials for the curve
        % fitting 
        percepNegR(:,:)                         = [-neg_v'; perNTrueR{:}; perNTotR{:};]';
        percepNegL(:,:)                         = [-neg_v'; perNTrueL{:}; perNTotL{:};]';
    
    
        % Run psignifit to curve fit the perception threshold for both legs
        % both directions
        temp3                                   = psignifit(percepNegR(:,:),options);
        temp4                                   = psignifit(percepNegL(:,:),options);
    
        % Stroe the perception Threshold into a variable that will be put in a
        % table for each subject
        posPTR                                  = NaN;
        posPTL                                  = NaN;
        negPTR                                  = temp3.Fit(1);
        negPTL                                  = temp4.Fit(1);
    
        % Create tables for Negative values and Positive to match so the
        % table can be concatinated at the end of the function
        tableNeg(iSubject,:)                     = table(posPTR,posPTL,negPTR,negPTL, 'VariableNames',{'Pos Right', 'Pos Left', 'Neg Right', 'Neg Left'}, 'RowNames', {name{iSubject}});
        tablePos                                 = table({'No Data'},{'No Data'},{'No Data'},{'No Data'}, 'VariableNames',{'Pos Right', 'Pos Left', 'Neg Right', 'Neg Left'}, 'RowNames', {name{iSubject}});
    else    
        % Finding the indicies of the perception experiment where each leg was
        % perturbed in the positive direction
        for iVel                                = 1:length(pos_v)
            perPosR{:,iVel}                     = percepR(dv_r == pos_v(iVel));
            perPosL{:,iVel}                     = percepL(dv_l == pos_v(iVel));
        end
        
        % Finding the indicies of the perception experiemnt where the each leg
        % was perturbed in the negative direction
        for iVel                                = 1:length(neg_v)
            perNegR{:,iVel}                     = percepR(dv_r == neg_v(iVel));
            perNegL{:,iVel}                     = percepL(dv_l == neg_v(iVel));
        end
        
        % Calculating the amount correct and total for each positive velocity
        for iVel                                = 1:length(pos_v)
            perPTrueR{iVel}                     = sum(perPosR{:,iVel});
            perPTotR{iVel}                      = length(perPosR{:,iVel});
            
            perPTrueL{iVel}                     = sum(perPosL{:,iVel});
            perPTotL{iVel}                      = length(perPosL{:,iVel});
        end
        
        % Calculating the amount correct and total for each negative velocity
        for iVel                                = 1:length(neg_v)
            perNTrueR{iVel}                     = sum(perNegR{:,iVel});
            perNTotR{iVel}                      = length(perNegR{:,iVel});
            
            perNTrueL{iVel}                     = sum(perNegL{:,iVel});
            perNTotL{iVel}                      = length(perNegL{:,iVel});
        end
        
        % Fixing the Threshold Values for 2AFC
        if contains(name{iSubject}, '2AFC')     == 1
            for iVel                            = 1:length(neg_v)
                perNTrueR{iVel}                 = 5 - sum(perNegR{:,iVel});
                perPTrueR{iVel}                 = 5 - sum(perPosR{:,iVel});
            end
        end
        
        % Formatting the velocities, % correct, and total trials for the curve
        % fitting 
        percepPosR(:,:)                         = [pos_v'; perPTrueR{:}; perPTotR{:};]';
        percepPosL(:,:)                         = [pos_v'; perPTrueL{:}; perPTotL{:};]';
        percepNegR(:,:)                         = [-neg_v'; perNTrueR{:}; perNTotR{:};]';
        percepNegL(:,:)                         = [-neg_v'; perNTrueL{:}; perNTotL{:};]';
        
        
        % Run psignifit to curve fit the perception threshold for both legs
        % both directions
        temp1                                   = psignifit(percepPosR(:,:),options);
        temp2                                   = psignifit(percepPosL(:,:),options);
        temp3                                   = psignifit(percepNegR(:,:),options);
        temp4                                   = psignifit(percepNegL(:,:),options);
        
        % Stroe the perception Threshold into a variable that will be put in a
        % table for each subject
        posPTR                                  = temp1.Fit(1);
        posPTL                                  = temp2.Fit(1);
        negPTR                                  = temp3.Fit(1);
        negPTL                                  = temp4.Fit(1);
        
        tableYesNo(iSubject,:)                  = table(posPTR,posPTL,negPTR,negPTL, 'VariableNames',{'Pos Right', 'Pos Left', 'Neg Right', 'Neg Left'}, 'RowNames', {name{iSubject}});
        
        
        
        % Change the location back to where the log files are saved
        cd(fileLocation)
    end
end

% This if else statement creates a table for the instances when there is no
% positive or negative velocities in one of the trail collections. If there
% is both positive and negative perturbations it saves the table generated
% in the loop as the threshold table with 2 rows for each subject. 
if contains(subject, {'01';'02';'03'}) == 1 && isempty(pos_v) == 1 || isempty(neg_v) == 1
    tableYesNo(2,:)                             = tableNeg(2,:);
    tableYesNo.Properties.RowNames{2,1}         = subjectCog;
    thresholdTable2                              = tableYesNo;
elseif rtCog                                    == 2
    tableNeg.Properties.RowNames{2}             = name{iSubject};
    thresholdTable2                              = tableNeg;
elseif rt2AFC == 2 && isempty(pos_v) == 1
    tableNeg.Properties.RowNames{2}             = name{iSubject};
    thresholdTable2                              = tableNeg;
else
    tableYesNo.Properties.RowNames{2}           = name{iSubject};
    tableYesNo.Row{2}                           = subject2AFC;
    thresholdTable2                              = tableYesNo;
end

