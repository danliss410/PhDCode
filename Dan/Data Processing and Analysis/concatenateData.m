function [analogTable,videoTable,gaitEventsTable] = concatenateData(strSubject,numTrials,numTreadmillTrials)
%
% [analogTable, videoTable, gaitEventsTable, subjectTable] = concatenateData(subject,numTrials,numTreadmillTrials)
%
% This function concatenates all the Vicon processed data from subtrails of each perception trial. 
% It will concatenate analog and video data into one table for all Perception trials of that subject. 
% The output will be saved as 4 separate tables (analog, video, gaitEvents, and subjectTable) to be saved in the subjects analysis folder.   
% IE. This function will combine analog & video data that was broken up
% across Percep01_1 to Percep01_5 making it a single trial again for
% analysis. 
%
% INPUTS: subject               - a string of the subjects unique identifier for the
%                                   Perception study.
%         numTrials             - number (double) of whole perception trials (Should be 4,
%                                   but may be more or less depending on if recording was messed up)
%         numTreamillTrials     - number (double) of treadmill trials (Should be 2-3,
%                                   but may be more depending on if recording was messed up)
%
%
% OUPUT: analogTable            - a table that has analog data for all trials the subject
%                                 participated in during the experiment.
%                                 The data is concatenated for all subtrials
%                                 in this table includes: emg,
%                                 cop, plateforces, electric potential,
%                                 sample rate, time, and all the corresponding
%                                 ids for the analog signals.
%        videoTable             - a table that has video data for all
%                                 trials the subject particpated in during
%                                 the experiment. The data is concatenated
%                                 for all subtrials in this table and
%                                 includes: sample rate, marker data, gait event data, time, 
%                                 joint momements, joint power, joint
%                                 angles, and vicon calculated body
%                                 segments, with all the corresponding ids
%                                 for the video signals. 
%        gaitEventsTable        - a table that contains concatenated data
%                                 for subtrials of the perception
%                                 experiment and the control treadmill
%                                 trials. This table contains gait events
%                                 and gait cycles for both legs: RHS, RTO,
%                                 LHS, LTO, Gait Cycles Right, Gait Cycles
%                                 Left. 
%        subjectTable           - a table that has all the data from the
%                                 video and analog tables concatenated into
%                                 one table for all trials the subject particpated in.
%                                 This table includes: Trial name, sample rate (video & analog), emg,
%                                 cop, plateforces, EP signal, marker data,
%                                 gait event data, time (video & analog),
%                                 joint (angles, moments, powers), vicon
%                                 body segment calculations.
%
%
% Created: 12 August 2020, DJL
% Modified: (format: date, initials, change made)
%   1 - 27 August 2020, DJL, fixed so the analog and video table to
%       concatenate based off of the empty row/column. This works properly as
%       long as there is no missing data from Vicon. 
%   2 - 27 September 2021, DJL, Made it so all the names in the table do
%   not have spaces so that the data could be looked at when clicked on.


%%%%%%%%%%%%%%%% THINGS THAT STILL NEED TO BE ADDED %%%%%%%%%%%%%%%%%%%%%%
% 1 - Figure out how to add different trial types (Cog or 2AFC)
% 4 - Need to figure out a way to adjust for having more than 4 perception
% trials (AKA How do I pick the good ones?)
% 5 - Figure out a better way to do the Joint Columns and Body Segments
% (Example: Subject 13 in Percep03 section 4 only has joint columns on the
% left leg so 4 out of 8 and no body segments so could not concatenate. I
% currently have them stored as cells so all the information is there. The
% columns don't stay the same if they are missing values, so idk if that
% would be a RegExp thing.)


%% Create subject name to load the necessary files for the subject 
% Naming convention for each log file "YAPercep##_" + YesNo or 2AFC or Cog

subjectYesNo = ['YAPercep' strSubject '_YesNo'];

subject2AFC = ['YAPercep' strSubject '_2AFC'];

subjectCog = ['YAPercep' strSubject '_Cog'];

subject1 = ['YAPercep' strSubject];


%% Setting the file location based on which computer is running the code
if ispc
    fileLocation = 'G:\Shared drives\NeuroMobLab\Experimental Data\Vicon Matlab Processed\Pilot Experiments\WVCTSI_Perception2019\';
elseif ismac
    fileLocation = '/Volumes/GoogleDrive/Shared drives/NeuroMobLab/Experimental Data/Vicon Matlab Processed/Pilot Experiments/WVCTSI_Perception2019/';
else
    fileLocation = input('Please enter the file location:' );
end

%%%%%% Change this location to the GitHub when everything is moved %%%%%%%
startLocation = 'G:\My Drive\MATLAB\Perception'; %Location where all the functions and matlab scripts are 

fileLocation = [fileLocation subject1 filesep 'session1']; % Creating new location based on the subject that is being processed 

cd(fileLocation)

% Create directory of files that need to be loaded for each subject
dataDir = dir(fileLocation);
dataDir = dataDir(3:end);

for iDirLength = 1:length(dataDir)
    subjectID{iDirLength,1} = subject1;
end

% Looping through all the length of the data file to load all the trials
% collected for each subject into a table

for iTrials = 1:length(dataDir)
    load(dataDir(iTrials).name)
    
    if iTrials == 1 % Creating the table 
        trialTable1 = table(subjectID(iTrials),{dataDir(iTrials).name}, rawData, 'VariableNames', {'Subject';'Trial Name';'Data';});
    else % Filling the table with the remaining values
        trialTable1.Subject(iTrials) = subjectID(iTrials);
        trialTable1.('Trial Name')(iTrials) = {dataDir(iTrials).name};
        trialTable1.('Data')(iTrials) = rawData;
    end
end

% Getting rid of the calibration trials 
A = contains(trialTable1.("Trial Name"), 'Cal');
B = find(A == 1);

% Creating a new table with only the perception trials and treadmill
% trials 
trialTable = trialTable1(B(length(B))+1:size(trialTable1,1),:);

clear A B
% Preallocated names to pull from later in loops for Treadmill Trials 
nameTreadmill = {'Treadmill01'; 'Treadmill02'; 'Treadmill03'; 'Treadmill04'; 'Treadmill05'; 'Treadmill06'};

% Preallocated names to pull from later in loops for Perception Trials 
namePercep = {'Percep01'; 'Percep02'; 'Percep03'; 'Percep04'; 'Percep05'; 'Percep06'; 'Percep07'; 'Percep08';}; % 



%% Create a Video Table for all the video data concatenated for all the subtrials of each Perception trial 


% This loop finds the indicies of the trial table of the subsections of
% each perception trial 
for iSubtrials = 1:size(trialTable.('Trial Name'),1)
    A(iSubtrials) = contains(trialTable.('Trial Name'){iSubtrials}, 'Percep01');
    B(iSubtrials) = contains(trialTable.('Trial Name'){iSubtrials}, 'Percep02');
    C(iSubtrials) = contains(trialTable.('Trial Name'){iSubtrials}, 'Percep03');
    D(iSubtrials) = contains(trialTable.('Trial Name'){iSubtrials}, 'Percep04');
    E(iSubtrials) = contains(trialTable.('Trial Name'){iSubtrials}, 'Percep05');
    F(iSubtrials) = contains(trialTable.('Trial Name'){iSubtrials}, 'Percep06');
    G(iSubtrials) = contains(trialTable.('Trial Name'){iSubtrials}, 'Percep07');
    H(iSubtrials) = contains(trialTable.('Trial Name'){iSubtrials}, 'Percep08');
end

if numTrials <= 5 
    A = find(A == 1); % Indicies for Percep01 in the trialTable
    B = find(B == 1); % Indicies for Percep02 in the trialTable
    C = find(C == 1); % Indicies for Percep03 in the trialTable
    D = find(D == 1); % Indicies for Percep04 in the trialTable
    E = find(E == 1); % Indicies for Percep05 in the trialTable
else % Need to figure out how to adjust for more trials IE if there are bad trials and we recorded up through Percep06 or something 
end

% Combining all the subtrials to one matrix 
temp = {A; B; C; D; E};
% Creating Row Matrices for the concatenation in 100 Hz increments of the
% trials 
rows = [0; 5000; 10000; 15000; 20000; 25000; 30000; 35000; 40000; 45000; 50000; 55000;];
for inumTrials = 1:numTrials
    video.markers.(namePercep{inumTrials}) = []; 
    video.jointMoments.(namePercep{inumTrials}) = {}; 
    video.jointPowers.(namePercep{inumTrials}) = {}; 
    video.jointAngles.(namePercep{inumTrials}) = {}; 
    video.bodySegments.(namePercep{inumTrials}) = {}; 
    video.RHS.(namePercep{inumTrials}) = []; 
    video.RTO.(namePercep{inumTrials}) = []; 
    video.LTO.(namePercep{inumTrials}) = []; 
    video.LHS.(namePercep{inumTrials}) = []; 
    video.time.(namePercep{inumTrials}) = [];  
    for iSectPercep1 = 1:size(temp{inumTrials},2) % Concatonate all the gait events, marker data, joint moments, joint power, joint angles, and body segment calculations for the subtrials of Percep01
        if iSectPercep1 > 1 
            row = rows(iSectPercep1);
%             [row, col] =
%             find(video.markers.(namePercep{inumTrials})(:,:,1) == 0, 1,
%             'first'); %I tried this method to look for the first gap in
%             data and this did not work for all subjects so just hard
%             coded it. Maybe someone in the future can come up with
%             something better. 
            video.RHS.(namePercep{inumTrials}) = [video.RHS.(namePercep{inumTrials}), trialTable.Data(temp{inumTrials}(iSectPercep1),1).video.GaitEvents.RHSframe];
            video.RTO.(namePercep{inumTrials}) = [video.RTO.(namePercep{inumTrials}), trialTable.Data(temp{inumTrials}(iSectPercep1),1).video.GaitEvents.RTOframe];
            video.LTO.(namePercep{inumTrials}) = [video.LTO.(namePercep{inumTrials}), trialTable.Data(temp{inumTrials}(iSectPercep1),1).video.GaitEvents.LTOframe];
            video.LHS.(namePercep{inumTrials}) = [video.LHS.(namePercep{inumTrials}), trialTable.Data(temp{inumTrials}(iSectPercep1),1).video.GaitEvents.LHSframe];
            video.markers.(namePercep{inumTrials})(row:end,:,:) = [trialTable.Data(temp{inumTrials}(iSectPercep1),1).video.markers(row:end,:,:)];
            try
                video.jointMoments.(namePercep{inumTrials}){1,1}(:,row:end,:) = trialTable.Data(temp{inumTrials}(iSectPercep1),1).video.jointMoments(:,row:end,:);
                video.jointPowers.(namePercep{inumTrials}){1,1}(:,row:end,:) = trialTable.Data(temp{inumTrials}(iSectPercep1),1).video.jointPowers(:,row:end,:);
                video.jointAngles.(namePercep{inumTrials}){1,1}(:,row:end,:) = trialTable.Data(temp{inumTrials}(iSectPercep1),1).video.jointAngles(:,row:end,:);
                video.bodySegments.(namePercep{inumTrials}){1,1}{iSectPercep1} = {trialTable.Data(temp{inumTrials}(iSectPercep1),1).video.bodySegments};
            catch
                if inumTrials == 5
                    video.jointMoments.(namePercep{inumTrials}){1,1}(:,row:end,:) = NaN([4 , size(trialTable.Data(temp{inumTrials}(iSectPercep1),1).video.jointMoments(:,row:end,:), [2,3])]);
                    video.jointPowers.(namePercep{inumTrials}){1,1}(:,row:end,:) = NaN([3, size(trialTable.Data(temp{inumTrials}(iSectPercep1),1).video.jointPowers(:,row:end,:), [2,3])]);
                    video.jointAngles.(namePercep{inumTrials}){1,1}(:,row:end,:) = NaN([7, size(trialTable.Data(temp{inumTrials}(iSectPercep1),1).video.jointAngles(:,row:end,:), [2,3])]);
                    video.bodySegments.(namePercep{inumTrials}){1,1}{iSectPercep1} = NaN([1,9]);
                else
                    video.jointMoments.(namePercep{inumTrials}){1,1}(:,row:end,:) = NaN([8 , size(trialTable.Data(temp{inumTrials}(iSectPercep1),1).video.jointMoments(:,row:end,:), [2,3])]);
                    video.jointPowers.(namePercep{inumTrials}){1,1}(:,row:end,:) = NaN([6, size(trialTable.Data(temp{inumTrials}(iSectPercep1),1).video.jointPowers(:,row:end,:), [2,3])]);
                    video.jointAngles.(namePercep{inumTrials}){1,1}(:,row:end,:) = NaN([12, size(trialTable.Data(temp{inumTrials}(iSectPercep1),1).video.jointAngles(:,row:end,:), [2,3])]);
                    video.bodySegments.(namePercep{inumTrials}){1,1}{iSectPercep1} = NaN([1,9]);
                end
            end  
            video.time.(namePercep{inumTrials})(row:end) = [trialTable.Data(temp{inumTrials}(iSectPercep1),1).video.time(row:end)];
            video.samplerate.(namePercep{inumTrials}){iSectPercep1} = [trialTable.Data(temp{inumTrials}(iSectPercep1),1).video.samplerate];
            video.markersid.(namePercep{inumTrials}){iSectPercep1} = {trialTable.Data(temp{inumTrials}(iSectPercep1),1).video.markersid};
            video.jointAngleNames.(namePercep{inumTrials}){iSectPercep1} = {trialTable.Data(temp{inumTrials}(iSectPercep1),1).video.jointAngleNames};
            video.jointMomentNames.(namePercep{inumTrials}){iSectPercep1} = {trialTable.Data(temp{inumTrials}(iSectPercep1),1).video.jointMomentNames};
            video.jointPowerNames.(namePercep{inumTrials}){iSectPercep1} = {trialTable.Data(temp{inumTrials}(iSectPercep1),1).video.jointPowerNames};
            video.bodySegmentNames.(namePercep{inumTrials}){iSectPercep1} = {trialTable.Data(temp{inumTrials}(iSectPercep1),1).video.bodySegmentNames};
            try
                video.jointColumns.(namePercep{inumTrials}){iSectPercep1} = {trialTable.Data(temp{inumTrials}(iSectPercep1),1).video.jointColumns};
                video.bodySegmentColumns.(namePercep{inumTrials}){iSectPercep1} = {trialTable.Data(temp{inumTrials}(iSectPercep1),1).video.bodySegmentColumns}; 
            catch
                video.jointColumns.(namePercep{inumTrials}){iSectPercep1} = {NaN};
                video.bodySegmentColumns.(namePercep{inumTrials}){iSectPercep1} = {NaN}; 
            end
        else
            video.RHS.(namePercep{inumTrials}) = [video.RHS.(namePercep{inumTrials}), trialTable.Data(temp{inumTrials}(iSectPercep1),1).video.GaitEvents.RHSframe];
            video.RTO.(namePercep{inumTrials}) = [video.RTO.(namePercep{inumTrials}), trialTable.Data(temp{inumTrials}(iSectPercep1),1).video.GaitEvents.RTOframe];
            video.LTO.(namePercep{inumTrials}) = [video.LTO.(namePercep{inumTrials}), trialTable.Data(temp{inumTrials}(iSectPercep1),1).video.GaitEvents.LTOframe];
            video.LHS.(namePercep{inumTrials}) = [video.LHS.(namePercep{inumTrials}), trialTable.Data(temp{inumTrials}(iSectPercep1),1).video.GaitEvents.LHSframe];
            video.markers.(namePercep{inumTrials}) = [video.markers.(namePercep{inumTrials}), trialTable.Data(temp{inumTrials}(iSectPercep1),1).video.markers];
            video.jointMoments.(namePercep{inumTrials}) = {trialTable.Data(temp{inumTrials}(iSectPercep1),1).video.jointMoments};
            video.jointPowers.(namePercep{inumTrials}) = {trialTable.Data(temp{inumTrials}(iSectPercep1),1).video.jointPowers};
            video.jointAngles.(namePercep{inumTrials}) = {trialTable.Data(temp{inumTrials}(iSectPercep1),1).video.jointAngles};
            video.bodySegments.(namePercep{inumTrials}){iSectPercep1} = trialTable.Data(temp{inumTrials}(iSectPercep1),1).video.bodySegments;
            video.time.(namePercep{inumTrials}) = [trialTable.Data(temp{inumTrials}(iSectPercep1),1).video.time];
            video.samplerate.(namePercep{inumTrials}){iSectPercep1} = [trialTable.Data(temp{inumTrials}(iSectPercep1),1).video.samplerate];
            video.markersid.(namePercep{inumTrials}){iSectPercep1} = {trialTable.Data(temp{inumTrials}(iSectPercep1),1).video.markersid};
            video.jointAngleNames.(namePercep{inumTrials}){iSectPercep1} = {trialTable.Data(temp{inumTrials}(iSectPercep1),1).video.jointAngleNames};
            video.jointMomentNames.(namePercep{inumTrials}){iSectPercep1} = {trialTable.Data(temp{inumTrials}(iSectPercep1),1).video.jointMomentNames};
            video.jointPowerNames.(namePercep{inumTrials}){iSectPercep1} = {trialTable.Data(temp{inumTrials}(iSectPercep1),1).video.jointPowerNames};
            video.bodySegmentNames.(namePercep{inumTrials}){iSectPercep1} = {trialTable.Data(temp{inumTrials}(iSectPercep1),1).video.bodySegmentNames};
            try
            video.jointColumns.(namePercep{inumTrials}){iSectPercep1} = {trialTable.Data(temp{inumTrials}(iSectPercep1),1).video.jointColumns};
            video.bodySegmentColumns.(namePercep{inumTrials}){iSectPercep1} = {trialTable.Data(temp{inumTrials}(iSectPercep1),1).video.bodySegmentColumns}; 
            catch
            end
        end     
    end
end


for iNumTrials = 1:numTrials % Creating a video table for each subject with all video/marker data for each perception trial
   if iNumTrials == 1
        videoTable = table(namePercep(iNumTrials),{video.samplerate.(namePercep{iNumTrials})}, {video.markers.(namePercep{iNumTrials})}, {video.markersid.(namePercep{iNumTrials})}, {video.jointAngles.(namePercep{iNumTrials})}, {video.jointAngleNames.(namePercep{iNumTrials})},...
            {video.jointMoments.(namePercep{iNumTrials})},{video.jointMomentNames.(namePercep{iNumTrials})}, {video.jointPowers.(namePercep{iNumTrials})}, {video.jointPowerNames.(namePercep{iNumTrials})}, {video.bodySegments.(namePercep{iNumTrials})}, {video.bodySegmentNames.(namePercep{iNumTrials})},...
            {video.RHS.(namePercep{iNumTrials})},{video.RTO.(namePercep{iNumTrials})}, {video.LTO.(namePercep{iNumTrials})}, {video.LHS.(namePercep{iNumTrials})}, {video.time.(namePercep{iNumTrials})}, ...
            {video.jointColumns.(namePercep{iNumTrials})}, {video.bodySegmentColumns.(namePercep{iNumTrials})}, 'VariableNames', {'Trial';'Sample_Rate_(Hz)'; 'Marker_Data'; 'MarkerID'; 'Joint_Angles'; 'Joint_Angles_ID'; 'Joint_Moments'; 'Joint_Moments_ID'; 'Joint_Powers'; 'Joint_Powers_ID'; ...
            'Vicon_Body_Segments'; 'Vicon_Body_Segments_ID'; 'RHS';'RTO';'LTO';'LHS'; 'time_(s)'; 'Joint_Column_Axis'; 'Body_Segment_Columns';});
    else
        videoTable.Trial(iNumTrials) = namePercep(iNumTrials);
        videoTable.('Sample_Rate_(Hz)')(iNumTrials) = {video.samplerate.(namePercep{iNumTrials})};
        videoTable.('Marker_Data')(iNumTrials) = {video.markers.(namePercep{iNumTrials})};
        videoTable.('MarkerID')(iNumTrials) = {video.markersid.(namePercep{iNumTrials})};
        videoTable.('Joint_Angles')(iNumTrials) = {video.jointAngles.(namePercep{iNumTrials})};
        videoTable.('Joint_Angles_ID')(iNumTrials) = {video.jointAngleNames.(namePercep{iNumTrials})};
        videoTable.('Joint_Moments')(iNumTrials) = {video.jointMoments.(namePercep{iNumTrials})};
        videoTable.('Joint_Moments_ID')(iNumTrials) = {video.jointMomentNames.(namePercep{iNumTrials})};
        videoTable.('Joint_Powers')(iNumTrials) = {video.jointPowers.(namePercep{iNumTrials})};
        videoTable.('Joint_Powers_ID')(iNumTrials) = {video.jointPowerNames.(namePercep{iNumTrials})};
        videoTable.('Vicon_Body_Segments')(iNumTrials) = {video.bodySegments.(namePercep{iNumTrials})};
        videoTable.('Vicon_Body_Segments_ID')(iNumTrials) = {video.bodySegmentNames.(namePercep{iNumTrials})};
        videoTable.RHS(iNumTrials) = {video.RHS.(namePercep{iNumTrials})};
        videoTable.RTO(iNumTrials) = {video.RTO.(namePercep{iNumTrials})};
        videoTable.LTO(iNumTrials) = {video.LTO.(namePercep{iNumTrials})};
        videoTable.LHS(iNumTrials) = {video.LHS.(namePercep{iNumTrials})};
        videoTable.('time_(s)')(iNumTrials) = {video.time.(namePercep{iNumTrials})};
        videoTable.('Joint_Column_Axis')(iNumTrials) = {video.jointColumns.(namePercep{iNumTrials})};
        videoTable.('Body_Segment_Columns')(iNumTrials) = {video.bodySegmentColumns.(namePercep{iNumTrials})};
   end   
end

%% Adding the treadmill trials to the video table 

% This loop finds the indicies of the trial table of the subsections of
% each perception trial 
for iTreadtrials = 1:size(trialTable.('Trial Name'),1)
    A(iTreadtrials) = contains(trialTable.('Trial Name'){iTreadtrials}, 'Treadmill');
end

if numTreadmillTrials <= 4 
    Tread1 = find(A == 1); % Indicies for Treadmill trials in the trialTable
else                                                                    % Need to figure out how to adjust for more trials IE if there are bad trials and we recorded up through Percep06 or something 
end


% Creating empty matricies/cells to be filled based off type and naming
% convention from Vicon matlab processing script and data structure (file:
% proc_batch##) Get this from the GitHub###########################
video.markers.('Treadmill01') = []; video.jointMoments.('Treadmill01') = []; video.jointPowers.('Treadmill01') = []; video.jointAngles.('Treadmill01') = []; video.bodySegments.('Treadmill01') = {}; video.RHS.('Treadmill01') = []; video.RTO.('Treadmill01') = []; video.LTO.('Treadmill01') = []; video.LHS.('Treadmill01') = []; video.time.('Treadmill01') = [];
video.markers.('Treadmill02') = []; video.jointMoments.('Treadmill02') = []; video.jointPowers.('Treadmill02') = []; video.jointAngles.('Treadmill02') = []; video.bodySegments.('Treadmill02') = {}; video.RHS.('Treadmill02') = []; video.RTO.('Treadmill02') = []; video.LTO.('Treadmill02') = []; video.LHS.('Treadmill02') = []; video.time.('Treadmill02') = [];
video.markers.('Treadmill03') = []; video.jointMoments.('Treadmill03') = []; video.jointPowers.('Treadmill03') = []; video.jointAngles.('Treadmill03') = []; video.bodySegments.('Treadmill03') = {}; video.RHS.('Treadmill03') = []; video.RTO.('Treadmill03') = []; video.LTO.('Treadmill03') = []; video.LHS.('Treadmill03') = []; video.time.('Treadmill03') = [];
video.markers.('Treadmill04') = []; video.jointMoments.('Treadmill04') = []; video.jointPowers.('Treadmill04') = []; video.jointAngles.('Treadmill04') = []; video.bodySegments.('Treadmill04') = {}; video.RHS.('Treadmill04') = []; video.RTO.('Treadmill04') = []; video.LTO.('Treadmill04') = []; video.LHS.('Treadmill04') = []; video.time.('Treadmill04') = [];


% Concatonate all the gait events, marker data, joint moments, joint power, joint angles, and body segment calculations for the treadmill control trials
for iTread1 = 1:size(Tread1,2) 
    video.RHS.(nameTreadmill{iTread1}) = [video.RHS.(nameTreadmill{iTread1}), trialTable.Data(Tread1(iTread1),1).video.GaitEvents.RHSframe];
    video.RTO.(nameTreadmill{iTread1}) = [video.RTO.(nameTreadmill{iTread1}), trialTable.Data(Tread1(iTread1),1).video.GaitEvents.RTOframe];
    video.LTO.(nameTreadmill{iTread1}) = [video.LTO.(nameTreadmill{iTread1}), trialTable.Data(Tread1(iTread1),1).video.GaitEvents.LTOframe];
    video.LHS.(nameTreadmill{iTread1}) = [video.LHS.(nameTreadmill{iTread1}), trialTable.Data(Tread1(iTread1),1).video.GaitEvents.LHSframe];
    video.markers.(nameTreadmill{iTread1}) = [video.markers.(nameTreadmill{iTread1}), trialTable.Data(Tread1(iTread1),1).video.markers];
    video.jointMoments.(nameTreadmill{iTread1}) = [video.jointMoments.(nameTreadmill{iTread1}), trialTable.Data(Tread1(iTread1),1).video.jointMoments];
    video.jointPowers.(nameTreadmill{iTread1}) = [video.jointPowers.(nameTreadmill{iTread1}), trialTable.Data(Tread1(iTread1),1).video.jointPowers];
    video.jointAngles.(nameTreadmill{iTread1}) = [video.jointAngles.(nameTreadmill{iTread1}), trialTable.Data(Tread1(iTread1),1).video.jointAngles];
    video.bodySegments.(nameTreadmill{iTread1}){iTread1} = [trialTable.Data(Tread1(iTread1),1).video.bodySegments];
    video.time.(nameTreadmill{iTread1}) = [trialTable.Data(Tread1(iTread1),1).video.time];
    video.samplerate.(nameTreadmill{iTread1}){iTread1} = [trialTable.Data(Tread1(iTread1),1).video.samplerate];
    video.markersid.(nameTreadmill{iTread1}){iTread1} = {trialTable.Data(Tread1(iTread1),1).video.markersid};
    video.jointAngleNames.(nameTreadmill{iTread1}){iTread1} = {trialTable.Data(Tread1(iTread1),1).video.jointAngleNames};
    video.jointMomentNames.(nameTreadmill{iTread1}){iTread1} = {trialTable.Data(Tread1(iTread1),1).video.jointMomentNames};
    video.jointPowerNames.(nameTreadmill{iTread1}){iTread1} = {trialTable.Data(Tread1(iTread1),1).video.jointPowerNames};
    video.bodySegmentNames.(nameTreadmill{iTread1}){iTread1} = {trialTable.Data(Tread1(iTread1),1).video.bodySegmentNames};
    try
    video.jointColumns.(nameTreadmill{iTread1}){iTread1} = {trialTable.Data(Tread1(iTread1),1).video.jointColumns};
    video.bodySegmentColumns.(nameTreadmill{iTread1}){iTread1} = {trialTable.Data(Tread1(iTread1),1).video.bodySegmentColumns};  
    catch
    end    
end

% Updating the existing video table with the treadmill data for each subject
for iNumTrials = 1:numTreadmillTrials  
        tempRow = size(videoTable,1) + 1;
        videoTable.Trial(tempRow) = nameTreadmill(iNumTrials);
        videoTable.('Sample_Rate_(Hz)')(tempRow) = {video.samplerate.(nameTreadmill{iNumTrials})};
        videoTable.('Marker_Data')(tempRow) = {video.markers.(nameTreadmill{iNumTrials})};
        videoTable.('MarkerID')(tempRow) = {video.markersid.(nameTreadmill{iNumTrials})};
        videoTable.('Joint_Angles')(tempRow) = {video.jointAngles.(nameTreadmill{iNumTrials})};
        videoTable.('Joint_Angles_ID')(tempRow) = {video.jointAngleNames.(nameTreadmill{iNumTrials})};
        videoTable.('Joint_Moments')(tempRow) = {video.jointMoments.(nameTreadmill{iNumTrials})};
        videoTable.('Joint_Moments_ID')(tempRow) = {video.jointMomentNames.(nameTreadmill{iNumTrials})};
        videoTable.('Joint_Powers')(tempRow) = {video.jointPowers.(nameTreadmill{iNumTrials})};
        videoTable.('Joint_Powers_ID')(tempRow) = {video.jointPowerNames.(nameTreadmill{iNumTrials})};
        videoTable.('Vicon_Body_Segments')(tempRow) = {video.bodySegments.(nameTreadmill{iNumTrials})};
        videoTable.('Vicon_Body_Segments_ID')(tempRow) = {video.bodySegmentNames.(nameTreadmill{iNumTrials})};
        videoTable.RHS(tempRow) = {video.RHS.(nameTreadmill{iNumTrials})};
        videoTable.RTO(tempRow) = {video.RTO.(nameTreadmill{iNumTrials})};
        videoTable.LTO(tempRow) = {video.LTO.(nameTreadmill{iNumTrials})};
        videoTable.LHS(tempRow) = {video.LHS.(nameTreadmill{iNumTrials})};
        videoTable.('time_(s)')(tempRow) = {video.time.(nameTreadmill{iNumTrials})};
        videoTable.('Joint_Column_Axis')(tempRow) = {video.jointColumns.(nameTreadmill{iNumTrials})};
        videoTable.('Body_Segment_Columns')(tempRow) = {video.bodySegmentColumns.(nameTreadmill{iNumTrials})};
end


%% Create a gaitEvents Table with all the concatenated information from all the subtrials


for iNumTrials = 1:numTrials % Creating gait event cycles for left and right legs for each perception trial
    GaitEvents_Right = createGaitEventsMatrix(video.RHS.(namePercep{iNumTrials}), video.RTO.(namePercep{iNumTrials}), video.LHS.(namePercep{iNumTrials}), video.LTO.(namePercep{iNumTrials}));
    GaitEvents_Left = createGaitEventsMatrix(video.LHS.(namePercep{iNumTrials}), video.LTO.(namePercep{iNumTrials}), video.RHS.(namePercep{iNumTrials}), video.RTO.(namePercep{iNumTrials}));
    GaitEvents.(namePercep{iNumTrials}).Right = GaitEvents_Right;
    GaitEvents.(namePercep{iNumTrials}).Left = GaitEvents_Left;
end 

for iNumTrials = 1:numTreadmillTrials % Creating gait event cycles for the left and right legs for each perception trial
    GaitEvents_Right = createGaitEventsMatrix(video.RHS.(nameTreadmill{iNumTrials}), video.RTO.(nameTreadmill{iNumTrials}), video.LHS.(nameTreadmill{iNumTrials}), video.LTO.(nameTreadmill{iNumTrials}));
    GaitEvents_Left = createGaitEventsMatrix(video.LHS.(nameTreadmill{iNumTrials}), video.LTO.(nameTreadmill{iNumTrials}), video.RHS.(nameTreadmill{iNumTrials}), video.RTO.(nameTreadmill{iNumTrials}));
    GaitEvents.(nameTreadmill{iNumTrials}).Right = GaitEvents_Right;
    GaitEvents.(nameTreadmill{iNumTrials}).Left = GaitEvents_Left;
end



for iNumTrials = 1:numTrials % Creating a gait events table for each subject with all the gait cycles and information for each perception trial
   if iNumTrials == 1
        gaitEventsTable = table(namePercep(iNumTrials),{video.RHS.(namePercep{iNumTrials})}, {video.RTO.(namePercep{iNumTrials})}, {video.LTO.(namePercep{iNumTrials})}, {video.LHS.(namePercep{iNumTrials})}, {GaitEvents.(namePercep{iNumTrials}).Right}, {GaitEvents.(namePercep{iNumTrials}).Left}, 'VariableNames', {'Trial';'RHS';'RTO';'LTO';'LHS';'Gait_Events_Right';'Gait_Events_Left';});
    else
        gaitEventsTable.Trial(iNumTrials) = namePercep(iNumTrials);
        gaitEventsTable.RHS(iNumTrials) = {video.RHS.(namePercep{iNumTrials})};
        gaitEventsTable.RTO(iNumTrials) = {video.RTO.(namePercep{iNumTrials})};
        gaitEventsTable.LTO(iNumTrials) = {video.LTO.(namePercep{iNumTrials})};
        gaitEventsTable.LHS(iNumTrials) = {video.LHS.(namePercep{iNumTrials})};
        gaitEventsTable.('Gait_Events_Right')(iNumTrials) = {GaitEvents.(namePercep{iNumTrials}).Right};
        gaitEventsTable.('Gait_Events_Left')(iNumTrials) = {GaitEvents.(namePercep{iNumTrials}).Left};
   end   
end


for iNumTrials = 1:numTreadmillTrials % Updating the gait events table for each subject with all the gait cycles and other gait event related information for the treadmill control trials.
    tempRow = size(gaitEventsTable,1) + 1;
    gaitEventsTable.Trial(tempRow) = nameTreadmill(iNumTrials);
    gaitEventsTable.RHS(tempRow) = {video.RHS.(nameTreadmill{iNumTrials})};
    gaitEventsTable.RTO(tempRow) = {video.RTO.(nameTreadmill{iNumTrials})};
    gaitEventsTable.LTO(tempRow) = {video.LTO.(nameTreadmill{iNumTrials})};
    gaitEventsTable.LHS(tempRow) = {video.LHS.(nameTreadmill{iNumTrials})};
    gaitEventsTable.('Gait_Events_Right')(tempRow) = {GaitEvents.(nameTreadmill{iNumTrials}).Right};
    gaitEventsTable.('Gait_Events_Left')(tempRow) = {GaitEvents.(nameTreadmill{iNumTrials}).Left};

end

clearvars -except subject1 fileLocation gaitEventsTable numTrials numTreadmillTrials namePercep nameTreadmill startLocation subjectYesNo subjectCog subject2AFC videoTable trialTable


%% Create an Analog Table for all the analog data concatenated for all the subtrials of each Perception trial 

% This loop finds the indicies of the trial table of the subsections of
% each perception trial 
for iSubtrials = 1:size(trialTable.('Trial Name'),1)
    A(iSubtrials) = contains(trialTable.('Trial Name'){iSubtrials}, 'Percep01');
    B(iSubtrials) = contains(trialTable.('Trial Name'){iSubtrials}, 'Percep02');
    C(iSubtrials) = contains(trialTable.('Trial Name'){iSubtrials}, 'Percep03');
    D(iSubtrials) = contains(trialTable.('Trial Name'){iSubtrials}, 'Percep04');
    E(iSubtrials) = contains(trialTable.('Trial Name'){iSubtrials}, 'Percep05');
    F(iSubtrials) = contains(trialTable.('Trial Name'){iSubtrials}, 'Percep06');
    G(iSubtrials) = contains(trialTable.('Trial Name'){iSubtrials}, 'Percep07');
    H(iSubtrials) = contains(trialTable.('Trial Name'){iSubtrials}, 'Percep08');
end

if numTrials <= 5 
    A = find(A == 1); % Indicies for Percep01 in the trialTable
    B = find(B == 1); % Indicies for Percep02 in the trialTable
    C = find(C == 1); % Indicies for Percep03 in the trialTable
    D = find(D == 1); % Indicies for Percep04 in the trialTable
    E = find(E == 1);
else  % Need to figure out how to adjust for more trials IE if there are bad trials and we recorded up through Percep06 or something 
end

% Creating empty matricies/cells to be filled based off type and naming
% convention from Vicon matlab processing script and data structure (file:
% proc_batch##) Get this from the GitHub###########################
analog.plateforces.('Percep01') = []; analog.emg.('Percep01') = []; analog.cop.('Percep01') = []; analog.other.('Percep01') =[];
analog.plateforces.('Percep02') = []; analog.emg.('Percep02') = []; analog.cop.('Percep02') = []; analog.other.('Percep02') =[];
analog.plateforces.('Percep03') = []; analog.emg.('Percep03') = []; analog.cop.('Percep03') = []; analog.other.('Percep03') =[];
analog.plateforces.('Percep04') = []; analog.emg.('Percep04') = []; analog.cop.('Percep04') = []; analog.other.('Percep04') =[];
analog.plateforces.('Percep05') = []; analog.emg.('Percep05') = []; analog.cop.('Percep05') = []; analog.other.('Percep05') =[];
% Concatonate all the plateforces, cop, emg, and electric potential signals for the subtrials of Percep01
temp = {A;B;C;D;E};
% Creating indices to place the data in 1000 Hz increments for the
% subtrials 
rows = [0; 50000; 100000; 150000; 200000; 250000; 300000; 350000; 400000; 450000; 500000; 550000; 600000; 650000;];

for inumTrials = 1:5
    for iSectPercep1 = 1:size(temp{inumTrials},2) 
        if iSectPercep1 > 1
%             Again I tried the same method for the video data down here
%             and it did not work so I hardcoded values of rows to choose.
%             This finds the first nonzero row so that the data can be
%             concatenated. 
%             clear tempRow1 tempRow2 row
%             tempRow1 = nonzeros(analog.plateforces.(namePercep{inumTrials})(:,1));
%             tempRow2 = find(analog.plateforces.(namePercep{inumTrials}) == tempRow1(end),1,'first'); % Need to come up with a better method for this (Maybe find all values and pick the end value?)
%             row = tempRow2+1;
%             tempRow3(iSectPercep1) = row;
%             If there are multiple values in the plateforces that are the
%             same this part ensures it picks the further value so that it
%             adds to the end of the data.
%             if row < tempRow3(iSectPercep1-1)
%                 tempRow2 = find(analog.plateforces.(namePercep{inumTrials}) == tempRow1(end),1,'last');
%                 row = tempRow2 + 1;
%                 tempRow3 = row;
%             end
%             [row2, col] = find(analog.plateforces.(namePercep{inumTrials}) == 0, 1, 'first');
            row = rows(iSectPercep1);
            analog.plateforces.(namePercep{inumTrials})(row:end,:) = [trialTable.Data(temp{inumTrials}(iSectPercep1),1).analog.plateforces(row:end,:)];
            analog.cop.(namePercep{inumTrials})(row:end,:) = [trialTable.Data(temp{inumTrials}(iSectPercep1),1).analog.cop(row:end,:)];
            analog.emg.(namePercep{inumTrials})(row:end,:) = [trialTable.Data(temp{inumTrials}(iSectPercep1),1).analog.emg(row:end,:)];
            analog.other.(namePercep{inumTrials})(row:end) = [trialTable.Data(temp{inumTrials}(iSectPercep1),1).analog.other(row:end)];
            analog.time.(namePercep{inumTrials})(row:end) = [trialTable.Data(temp{inumTrials}(iSectPercep1),1).analog.time(row:end)];
            analog.plateforcesid.(namePercep{inumTrials}){iSectPercep1} = {trialTable.Data(temp{inumTrials}(iSectPercep1),1).analog.plateforcesid};
            analog.samplerate.(namePercep{inumTrials}){iSectPercep1} = {trialTable.Data(temp{inumTrials}(iSectPercep1),1).analog.samplerate};
            analog.copid.(namePercep{inumTrials}){iSectPercep1} = {trialTable.Data(temp{inumTrials}(iSectPercep1),1).analog.copid};
            analog.emgid.(namePercep{inumTrials}){iSectPercep1} = {trialTable.Data(temp{inumTrials}(iSectPercep1),1).analog.emgid};
            analog.otherID.(namePercep{inumTrials}){iSectPercep1} = {trialTable.Data(temp{inumTrials}(iSectPercep1),1).analog.otherID};
        else
            analog.plateforces.(namePercep{inumTrials}) = [trialTable.Data(temp{inumTrials}(iSectPercep1),1).analog.plateforces];
            analog.cop.(namePercep{inumTrials})= [trialTable.Data(temp{inumTrials}(iSectPercep1),1).analog.cop];
            analog.emg.(namePercep{inumTrials}) = [trialTable.Data(temp{inumTrials}(iSectPercep1),1).analog.emg];
            analog.other.(namePercep{inumTrials}) = [trialTable.Data(temp{inumTrials}(iSectPercep1),1).analog.other];
            analog.time.(namePercep{inumTrials}) = [trialTable.Data(temp{inumTrials}(iSectPercep1),1).analog.time];
            analog.plateforcesid.(namePercep{inumTrials}){iSectPercep1} = {trialTable.Data(temp{inumTrials}(iSectPercep1),1).analog.plateforcesid};
            analog.samplerate.(namePercep{inumTrials}){iSectPercep1} = {trialTable.Data(temp{inumTrials}(iSectPercep1),1).analog.samplerate};
            analog.copid.(namePercep{inumTrials}){iSectPercep1} = {trialTable.Data(temp{inumTrials}(iSectPercep1),1).analog.copid};
            analog.emgid.(namePercep{inumTrials}){iSectPercep1} = {trialTable.Data(temp{inumTrials}(iSectPercep1),1).analog.emgid};
            analog.otherID.(namePercep{inumTrials}){iSectPercep1} = {trialTable.Data(temp{inumTrials}(iSectPercep1),1).analog.otherID};
        end
    end
end



for iNumTrials = 1:numTrials % Creating a analog table for each subject with all emg/analog data for each perception trial
   if iNumTrials == 1
        analogTable = table(namePercep(iNumTrials),{analog.samplerate.(namePercep{iNumTrials})}, {analog.plateforces.(namePercep{iNumTrials})}, ... 
            {analog.plateforcesid.(namePercep{iNumTrials})}, {analog.cop.(namePercep{iNumTrials})}, {analog.copid.(namePercep{iNumTrials})},...
            {analog.emg.(namePercep{iNumTrials})},{analog.emgid.(namePercep{iNumTrials})}, {analog.time.(namePercep{iNumTrials})},...
            {analog.other.(namePercep{iNumTrials})}, {analog.otherID.(namePercep{iNumTrials})}, ...
            'VariableNames', {'Trial';'Sample_Rate_(Hz)'; 'Plate_Forces'; 'Plate_Forces_ID'; 'COP'; 'COP_ID'; 'EMG'; 'EMG_ID'; 'Time_(s)'; 'EP_Signal'; 'EP_Signal_ID'});
    else
        analogTable.Trial(iNumTrials) = namePercep(iNumTrials);
        analogTable.('Sample_Rate_(Hz)')(iNumTrials) = {analog.samplerate.(namePercep{iNumTrials})};
        analogTable.('Plate_Forces')(iNumTrials) = {analog.plateforces.(namePercep{iNumTrials})};
        analogTable.('Plate_Forces_ID')(iNumTrials) = {analog.plateforcesid.(namePercep{iNumTrials})};
        analogTable.('COP')(iNumTrials) = {analog.cop.(namePercep{iNumTrials})};
        analogTable.('COP_ID')(iNumTrials) = {analog.copid.(namePercep{iNumTrials})};
        analogTable.('EMG')(iNumTrials) = {analog.emg.(namePercep{iNumTrials})};
        analogTable.('EMG_ID')(iNumTrials) = {analog.emgid.(namePercep{iNumTrials})};
        analogTable.('Time_(s)')(iNumTrials) = {analog.time.(namePercep{iNumTrials})};
        analogTable.('EP_Signal')(iNumTrials) = {analog.other.(namePercep{iNumTrials})};
        analogTable.('EP_Signal_ID')(iNumTrials) = {analog.otherID.(namePercep{iNumTrials})};
   end   
end

%% Adding the treadmill trials to the analog table 

% This loop finds the indicies of the trial table of the subsections of
% each perception trial 
for iTreadtrials = 1:size(trialTable.('Trial Name'),1)
    A(iTreadtrials) = contains(trialTable.('Trial Name'){iTreadtrials}, 'Treadmill');
end

if numTreadmillTrials <= 4 
    Tread1 = find(A == 1); % Indicies for Treadmill trials in the trialTable
else                                                                    % Need to figure out how to adjust for more trials IE if there are bad trials and we recorded up through Percep06 or something 
end

% Creating empty matricies/cells to be filled based off type and naming
% convention from Vicon matlab processing script and data structure (file:
% proc_batch##) Get this from the GitHub###########################
analog.plateforces.('Treadmill01') = []; analog.emg.('Treadmill01') = []; analog.cop.('Treadmill01') = []; analog.other.('Treadmill01') =[];
analog.plateforces.('Treadmill02') = []; analog.emg.('Treadmill02') = []; analog.cop.('Treadmill02') = []; analog.other.('Treadmill02') =[];
analog.plateforces.('Treadmill03') = []; analog.emg.('Treadmill03') = []; analog.cop.('Treadmill03') = []; analog.other.('Treadmill03') =[];
analog.plateforces.('Treadmill04') = []; analog.emg.('Treadmill04') = []; analog.cop.('Treadmill04') = []; analog.other.('Treadmill04') =[];

% Concatonate all the plateforces, cop, emg, and electric potential signals
% for all treadmill trials 
for iTread1 = 1:size(Tread1,2) 
    analog.plateforces.(nameTreadmill{iTread1}) = [analog.plateforces.(nameTreadmill{iTread1}), trialTable.Data(Tread1(iTread1),1).analog.plateforces];
    analog.cop.(nameTreadmill{iTread1}) = [analog.cop.(nameTreadmill{iTread1}), trialTable.Data(Tread1(iTread1),1).analog.cop];
    analog.emg.(nameTreadmill{iTread1}) = [analog.emg.(nameTreadmill{iTread1}), trialTable.Data(Tread1(iTread1),1).analog.emg];
    analog.other.(nameTreadmill{iTread1}) = [analog.other.(nameTreadmill{iTread1}), trialTable.Data(Tread1(iTread1),1).analog.other];
    analog.time.(nameTreadmill{iTread1}) = [trialTable.Data(Tread1(iTread1),1).analog.time];
    analog.plateforcesid.(nameTreadmill{iTread1}) = {trialTable.Data(Tread1(iTread1),1).analog.plateforcesid};
    analog.samplerate.(nameTreadmill{iTread1}) = {trialTable.Data(Tread1(iTread1),1).analog.samplerate};
    analog.copid.(nameTreadmill{iTread1})  = {trialTable.Data(Tread1(iTread1),1).analog.copid};
    analog.emgid.(nameTreadmill{iTread1})  = {trialTable.Data(Tread1(iTread1),1).analog.emgid};
    analog.otherID.(nameTreadmill{iTread1}) = {trialTable.Data(Tread1(iTread1),1).analog.otherID};
end

% Adding to the existing analog table for each subject with all emg/analog data for each treadmill trial
for iNumTrials = 1:numTreadmillTrials
        tempRow = size(analogTable,1) + 1;
        analogTable.Trial(tempRow) = nameTreadmill(iNumTrials);
        analogTable.('Sample_Rate_(Hz)')(tempRow) = {analog.samplerate.(nameTreadmill{iNumTrials})};
        analogTable.('Plate_Forces')(tempRow) = {analog.plateforces.(nameTreadmill{iNumTrials})};
        analogTable.('Plate_Forces_ID')(tempRow) = {analog.plateforcesid.(nameTreadmill{iNumTrials})};
        analogTable.('COP')(tempRow) = {analog.cop.(nameTreadmill{iNumTrials})};
        analogTable.('COP_ID')(tempRow) = {analog.copid.(nameTreadmill{iNumTrials})};
        analogTable.('EMG')(tempRow) = {analog.emg.(nameTreadmill{iNumTrials})};
        analogTable.('EMG_ID')(tempRow) = {analog.emgid.(nameTreadmill{iNumTrials})};
        analogTable.('Time_(s)')(tempRow) = {analog.time.(nameTreadmill{iNumTrials})};
        analogTable.('EP_Signal')(tempRow) = {analog.other.(nameTreadmill{iNumTrials})};
        analogTable.('EP_Signal_ID')(tempRow) = {analog.otherID.(nameTreadmill{iNumTrials})};
end

clearvars -except subject1 fileLocation gaitEventsTable numTrials numTreadmillTrials namePercep nameTreadmill startLocation subjectYesNo subjectCog subject2AFC videoTable trialTable analogTable

%% Creating a subject table that will have all analog and video data stored in this per subject 

% Combining the video and analog tables using the trial names 
% subjectTable = join(videoTable, analogTable, 'Keys', 'Trial');


%% Saving the data tables in the individual subjects folder 

% Setting the location to the subjects' data folder 
if ispc
    subLoc = ['G:\Shared drives\NeuroMobLab\Projects\Perception\Processed Data\Dan\Matlab Analysis\' subject1];
elseif ismac
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
    tabLoc = ['G:\Shared drives\NeuroMobLab\Projects\Perception\Processed Data\Dan\Matlab Analysis\' subject1 filesep 'Data Tables' filesep];
elseif ismac
    tabLoc = [''];
else
    tabLoc = input('Please enter the location where the tables should be saved.' ,'s');
end

% Saving the videoTable, analogTable, and gaitEventsTable to be loaded at
% the same time 
save([tabLoc 'SepTables_' subject1], 'videoTable', 'analogTable', 'gaitEventsTable', '-v7.3');

% Saving the entire subject table to be loaded by itself when called upon
% save([tabLoc 'FullTable_' subject1], 'subjectTable', '-v7.3');

disp(['Tables saved for ' subject1]);
end


