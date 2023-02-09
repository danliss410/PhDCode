function OAperceptionThresholdUS(subject, leg)
% perceptionThresholdUS(subject, leg)
% This function will calculate the locomotor disturbance perception
% threshold for the Ultrasound experiments. This will make plots for each
% subject for all perturbation levels for the dominant leg. 
%   This function will take the subject ID # and what their preferred leg
%   to kick a ball with. This function will use the psignifit toolbox to
%   fit the % of perceived responses to each of the 15 dV levels to create
%   a locomotor disturbance perception threshold for each subject. The dVs
%   are the following mangnitudes 0, 0.02, 0.05, 0.1, 0.15, 0.2, 0.3, 0.4.
%   There are 90 perturbations (75 are used for the threshold)
%   that happened on subjects YAUSPercep04 and on. There are 150
%   perturbations that happened on subjects YAUSPercep01-YAUSPercep03. The
%   thresholds will only be on their dominant leg so 75 perturbation
%   responses will be used to fit the curves. 

% INPUTS: subject               - a string of the subjects unique identifier for the
%                                   Perception study.
%
%         leg                   - a string of the subject's preferred leg
%                                 to kick a ball with. (Listed on the experimental data sheet)
%
%
% OUPUT:  There are no direct outputs for this file. There will be plots
% that are saved for each subject of their preferred leg's threshold for
% both slips and trips (decelerations and acceleration perturbations). 
% 
% 
% 
% 
% 
%
% Created: 9 June 2022, DJL 
% Modified: (format: date, initials, change made)
%   1 -  

% Things that need to be added 
%   1 - 


%% Setting the file location based on which computer is running the code

if ispc
    fileLocation = 'G:\Shared drives\NeuroMobLab\Experimental Data\Log Files\Pilot Experiments\USPerception2022\';
    
elseif ismac
    % Enter location 
else
    fileLocation = input('Please enter the file location:' );
end

startLocation = 'D:\Github\Perception-Project\Dan\USPercep Analysis\';

cd(fileLocation)


%% Set-up options for the psychometric curve fit
% need to download the pyschometric toolbox: https://github.com/wichmann-lab/psignifit/wiki

options = struct;

options.sigmoidName = 'logistic';

options.threshPC = 0.5;

%% Create subject name to load the log file for the subject 
% Naming convention for each log file "YAPercep##_" + US or YesNo
% This is dependent on running a double experiment to see if there is an
% effect of using the ultrasound on a subject's perception threshold

subjectUS = ['OAUSPercep' subject '_US'];

subjectYesNo = ['OAUSPercep' subject '_YesNo'];

subject1 = ['OAUSPercep' subject];


% Check to see which files exist for the subject

rtUS = exist([subjectUS '.txt'], 'file');

rtYesNo = exist([subjectYesNo '.txt'], 'file');


% Load the US log file that exist for the subject
name = {};


if rtUS == 2
    data1.(subjectUS) = readtable([fileLocation subjectUS]);
    data.(subjectUS) = data1.(subjectUS)(:,[1,2,3,6,9]);
    name = {subjectUS};
end


% Load the YesNo log file if it exists for the subject 

if rtYesNo == 2
    data1.(subjectYesNo) = readtable([fileLocation subjectYesNo]);
    data.(subjectYesNo) = data1.(subjectYesNo)(:,[1,2,3,6,9]);
    name = {subjectUS; subjectYesNo};
else
    disp([subjectYesNo ' does not exist'])
end



%% 
for iSub = 1:size(name,1)
    if leg == 'R'
        % Getting which perturbations are on the right leg
        right = strncmp('R', data.(name{iSub}).LegIn, 1);

        % Getting all the dV speeds for the right leg perturbations 
        dv_r = data.(name{iSub}).dV(right);

        % Getting the unique speeds from the log file
        vel = unique(data.(name{iSub}).dV);

        % Grouping the positive velocity values 
        pos_v = vel(vel>0);

        % Setting a zero speed for the catch trials 
        cTrials = vel(vel==0);

        % Getting all the perceived values from the table and putting in a
        % matrix 
        percepR = data.(name{iSub}).perceived(right);

        % Getting the indexes for the catch trials 
        catchPercep = percepR(dv_r == cTrials);

        % Setting the last option flag of psignifit to start the fit at 0%
        % and set the threshold at 50% 
        options.expType = 'YesNo';

        % Finding the indicies of the perception experiment where the right
        % leg was perturbed in the both directions.
        for iVel = 1:length(pos_v)
            % Getting positive perturbation indicies 
            perPosR{:,iVel} = percepR(dv_r == pos_v(iVel));
            % Calculating the amount of correct positive perturbations
            perPTrueR{iVel} = sum(perPosR{:,iVel});
            % Calculating the total number of perturbations for each
            % positive velocity
            perPTotalR{iVel} = length(perPosR{:,iVel});
        end

        % Formatting the velocities, % correct, and total trials for the
        % logistical curve to produce the perception thresholds 
        percepPosR(:,:) = [pos_v'; perPTrueR{:}; perPTotalR{:};]';
        catchTrials = sum(catchPercep);

        % Run psignifit to curve fit the perception threshold for the right
        % leg for both directions 
        temp1 = psignifit(percepPosR(:,:),options);

        % Store the perception threshold into a variable that will be put
        % in a table for each subject 
        posDomLeg = temp1.Fit(1);

        % Create tables for Negative values and Positive to match so the
        % table can be concatinated at the end of the function
        tablePercep(iSub,:) = table(posDomLeg,catchTrials,...
            'VariableNames',{'Pos Dom Leg', 'Catch Trials Guessed',},...
            'RowNames', {name{iSub}});
        if iSub == 2
            tablePercep.Properties.RowNames{2} = name{iSub};
        end
        
        try 
            mkdir('G:\Shared drives\NeuroMobLab\Projects\Perception\Ultrasound\Thresholds\', subject1)
        catch
            fprintf('Directory already exists')
        end
        % Change the location to the subject folder to store the
        % psychrometric curves 
        cd(['G:\Shared drives\NeuroMobLab\Projects\Perception\Ultrasound\Thresholds\' subject1])
        
        
        % Plotting the psychrometric curves for only positive velocity
        % perturbation trials
        plotNames = {[name{iSub} ' Pos Dom Leg ']};
        plotData = {percepPosR};
        for iPlot = 1
            h = figure; 
            filename = [plotNames{iPlot}  datestr(now, 'mm-dd-yyyy')];
            filenamePDF = strcat(filename, '.pdf'); 
            results = psignifit(plotData{iPlot},options);
            results.Fit; % order: threshold, width, lambda, gamma, eta
            results.conf_Intervals; % 5x2x3 array. lower and upper bounds for 95% CI, 90% CI, and 68% CI
            [hlineRp,hdataRp] = plotPsych(results);
            title(plotNames{iPlot})
            saveas(h, filename);
            print(filenamePDF,'-dpdf', '-bestfit');
            close(h) 
        end

    else
        % Getting which perturbations are on the Left leg
        left = strncmp('L', data.(name{iSub}).LegIn, 1);

        % Getting all the dV speeds for the left leg perturbations 
        dv_l = data.(name{iSub}).dV(left);

        % Getting the unique speeds from the log file
        vel = unique(data.(name{iSub}).dV);

        % Grouping the positive velocity values 
        pos_v = vel(vel>0);

        % Setting a zero speed for the catch trials 
        cTrials = vel(vel==0);

        % Getting all the perceived values from the table and putting in a
        % matrix 
        percepL = data.(name{iSub}).perceived(left);

        % Getting the indexes for the catch trials 
        catchPercep = percepL(dv_l == cTrials);

        % Setting the last option flag of psignifit to start the fit at 0%
        % and set the threshold at 50% 
        options.expType = 'YesNo';

        % Finding the indicies of the perception experiment where the left
        % leg was perturbed in the both directions.
        for iVel = 1:length(pos_v)
            % Getting positive perturbation indicies 
            perPosL{:,iVel} = percepL(dv_l == pos_v(iVel));
            % Calculating the amount of correct positive perturbations
            perPTrueL{iVel} = sum(perPosL{:,iVel});
            % Calculating the total number of perturbations for each
            % positive velocity
            perPTotalL{iVel} = length(perPosL{:,iVel});
        end

        % Formatting the velocities, % correct, and total trials for the
        % logistical curve to produce the perception thresholds 
        percepPosL(:,:) = [pos_v'; perPTrueL{:}; perPTotalL{:};]';
        catchTrials = sum(catchPercep);

        % Run psignifit to curve fit the perception threshold for the left
        % leg for both directions 
        temp1 = psignifit(percepPosL(:,:),options);

        % Store the perception threshold into a variable that will be put
        % in a table for each subject 
        posDomLeg = temp1.Fit(1);

        % Create tables for Negative values and Positive to match so the
        % table can be concatinated at the end of the function
        tablePercep(iSub,:) = table(posDomLeg,catchTrials,...
            'VariableNames',{'Pos Dom Leg', 'Catch Trials Guessed',},...
            'RowNames', {name{iSub}});
        if iSub == 2
            tablePercep.Properties.RowNames{2} = name{iSub};
        end
        
        try 
            mkdir('G:\Shared drives\NeuroMobLab\Projects\Perception\Ultrasound\Thresholds\', subject1)
        catch
            fprintf('Directory already exists')
        end
        % Change the location to the subject folder to store the
        % psychrometric curves 
        cd(['G:\Shared drives\NeuroMobLab\Projects\Perception\Ultrasound\Thresholds\' subject1])
        
        
        % Plotting the psychrometric curves for only negative velocity
        % perturbation trials
        plotNames = {[name{iSub} ' Pos Dom Leg '];};
        plotData = {percepPosL};
        for iPlot = 1
            h = figure; 
            filename = [plotNames{iPlot}  datestr(now, 'mm-dd-yyyy')];
            filenamePDF = strcat(filename, '.pdf'); 
            results = psignifit(plotData{iPlot},options);
            results.Fit; % order: threshold, width, lambda, gamma, eta
            results.conf_Intervals; % 5x2x3 array. lower and upper bounds for 95% CI, 90% CI, and 68% CI
            [hlineRp,hdataRp] = plotPsych(results);
            title(plotNames{iPlot})
            saveas(h, filename);
            print(filenamePDF,'-dpdf', '-bestfit');
            close(h) 
        end



    end





end

% Changing the location to save the subjects threshold in a different
% folder from the plots 
cd('G:\Shared drives\NeuroMobLab\Projects\Perception\Ultrasound\Thresholds\ThresholdTables')
% Save the table of thresholds 
save(subject1, 'tablePercep')

% 
disp([subject1 ' done making threshold plots and table for thresholds!'])

end

