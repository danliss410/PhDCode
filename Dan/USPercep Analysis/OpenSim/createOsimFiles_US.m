function createOsimFiles_US(forceRepresentation, markerFile, grfFile, fileLocation, filename, subjectName)
%
% PROCBATCH_TINGLAB_OSIMINPUTFILES(forceRepresentation, markerFile, grfFile)
%
% This function is used from a Vicon processing pipeline to create marker
% and ground reaction force files that are needed by OpenSim. 
%
% Inputs:  forceRepresentation: 0 - forces wrt to forceplate origin
%                               1 - forces wrt to center of pressure
%          markerFile: 0 or 1 logical, where 1 will create the marker
%                      output file
%          grfFile: 0 or logical, where 1 will create the grf output file
%          fileLocation: folder for c3d files
%          filename: trial c3d filename
%
% Outputs: This file does not have any outputs to Matlab, but does save a
%          TRC file of the marker data and a MOT data of the grf data. 

% Created: 1/28/2020 (JLA)
% Modified:
%           - JLA, 2/16/2020: copied TingLab version and modified to be
%           compatible for treadmill in KesarLab
%           - DJL, 10/2/2022: updated to change for ultrasound dataset

% NEED TO ADD IN A PLACE FOR THE STATIC CALIBRATION ROTATION

%% Connect to Opensim and Vicon 

% Load OpenSim libs
import org.opensim.modeling.*
% 
% % connect to Vicon and get filename, etc
% vicon = ViconNexus();
% subjectName = char(vicon.GetSubjectNames());
% [fileLocation,filename] = vicon.GetTrialName();

% [filename,fileLocation,FilterIndex] = ...
%     uigetfile('*.c3d','Pick the C3D file to convert');

% Get the path to a C3D file
c3dpath = fullfile(fileLocation,[filename]);

% Create file location to save output files if it does not yet exist
% replaceString = 'OSIM Files'; 
% new_path_name = regexprep(fileLocation,'TM_ViconDataBase',replaceString);
% new_path_name = [new_path_name 'MarkerAndGRFDataFiles' filesep];
folderLoc = ['G:\Shared drives\Perception Project\Ultrasound\OpenSim\YAUSPercep' subjectName '\MarkerAndGRFDataFiles\'];

if ~exist(folderLoc, 'dir')
  mkdir(folderLoc)
end

% Construct an opensimC3D object with input c3d path (Constructor takes 
% full path to c3d file and an integer for forceplate representation (1 = COP)).
try 
    c3d = osimC3D(c3dpath,forceRepresentation);
catch ME
    keyboard
end

% Get Start and end time
t0 = c3d.getStartTime();
tn = c3d.getEndTime();

% Rotate the data
% c3d.rotateData('z',-90)
c3d.rotateData('x',-90)
% This is only needed if the static calibration is facing the new cameras
% and not the TV wall
% if strcmp(subjectName, '14') || strcmp(subjectName, '18')
% c3d.rotateData('y',180)
% end
% if contains(filename, 'Cal')
%     c3d.rotateData('y', 180);
% end
% Getting Rid of the .c3d portion of the filename 
filename = regexprep(filename, '.c3d', '');

%% make GRF file
if grfFile
    
    %------------------------------%
    %--------- VICON STUFF---------%
    %------------------------------%
    
%     % get platform motion
%     platformOut = [];
%     platformNames = [];
%     
%     try
%         platid = vicon.GetDeviceIDFromName('Platform Movement');
%         [~, ~, rate, platOutputIDs] = vicon.GetDeviceDetails(platid);
%         
%         for i=1:length(platOutputIDs)
%             temp = vicon.GetDeviceOutputDetails(platid,i);
%             [~, ~, ~, ~, channelNames,tempid] = vicon.GetDeviceOutputDetails(platid,i);
%             
%             if ~isempty(tempid)
%                 for j=1:length(tempid)
%                     platformOut = [platformOut; vicon.GetDeviceChannel(platid,platOutputIDs(i),tempid(j))];
%                     platformNames = [platformNames; strcat(temp, '_',channelNames(j))];
%                 end
%             end
%             
%         end
%         
%         rawPlateMotion = platformOut';
%         platemotionid = platformNames;
%         
%     catch
%         
%         disp('Warning: No platform data exits')
%         
%     end
%     
%     % filter platform motion (using what Ting lab uses in proc batch)
%     
%     % low-pass filter signals at 30 Hz
%     freqCutoff = 30;
%     nyquist_frequency = rate / 2;
%     [filt_low_B, filt_low_A] = butter(3, freqCutoff/nyquist_frequency,'low');
%     plateMotion = filtfilt(filt_low_B, filt_low_A, rawPlateMotion);
%     
%     % correct from Vicon to OSIM coordinate system
%     % Vicon          OSIM
%     % y             x
%     % |             |
%     % |_ _ x        |_ _ z
%     %
%     plateDisplacement = [plateMotion(:,4), zeros(size(plateMotion(:,1))), plateMotion(:,3)];
%     % remove offset and convert from mm to m
%     offset = mean(plateDisplacement(1:ceil(rate/4),:),1);
%     plateDisplacement = (plateDisplacement-repmat(offset,size(plateDisplacement,1),1))/1000;
    
    %--------------------------------%
    %--------- OPENSIM STUFF---------%
    %--------------------------------%
    
    % Get the force data rate
    rForces = c3d.getRate_force();
    
    % Convert COP (mm to m) and Moments (Nmm to Nm)
    c3d.convertMillimeters2Meters();
    
    % get opensim table
    forceTable = c3d.getTable_forces();
    % get as matlab structure
    forceStruct = osimTableToStruct(forceTable);
    
%     % add platform motion to cop in forceStruct
%     forceStruct.p1 = forceStruct.p1 + plateDisplacement;
%     forceStruct.p2 = forceStruct.p2 + plateDisplacement;
    
    % Write GRF data to file
    if forceRepresentation == 1
%         outputpath = [new_path_name filename '_forces_rotated_wrtCOP.mot'];
        outputpath = [folderLoc filename '_forces_rotated_wrtCOP.mot'];
    else
%         outputpath = [new_path_name filename '_forces_rotated_wrtOrigin.mot'];
        outputpath = [folderLoc filename '_forces_rotated_wrtOrigin.mot'];
    end
    % get fp rate
   rate = 1000; % analog sample rate for our lab HDC 02/2020  
    %filter with butterworth 4th order, low-pass at 50Hz
    freqCutoff = 50;
    nyquist_frequency = rate / 2;
    [filt_low_B, filt_low_A] = butter(4, freqCutoff/nyquist_frequency,'low');
%     plateMotion = filtfilt(filt_low_B, filt_low_A, rawPlateMotion);
    
    
    
    fieldNamesList = fieldnames(forceStruct);
    for i=1:length(fieldNamesList)
        temp = isnan(forceStruct.(fieldNamesList{i}));
        % replace NaNs with zeros
        forceStruct.(fieldNamesList{i})(temp) = 0;        
    end
    
    % filter data
    forceStruct.f1=filtfilt(filt_low_B, filt_low_A, forceStruct.f1);
    forceStruct.m1=filtfilt(filt_low_B, filt_low_A, forceStruct.m1);
    forceStruct.p1=filtfilt(filt_low_B, filt_low_A, forceStruct.p1);
    forceStruct.f2=filtfilt(filt_low_B, filt_low_A, forceStruct.f2);
    forceStruct.m2=filtfilt(filt_low_B, filt_low_A, forceStruct.m2);
    forceStruct.p2=filtfilt(filt_low_B, filt_low_A, forceStruct.p2);
    
    
    
    % create osim table from our updated structure that includes platform
    % translation
    forces = osimTableFromStruct(forceStruct);
    c3d.writeMOT(outputpath, forces);
    
end


%% make marker file
if markerFile
    
    %--------------------------------%
    %--------- OPENSIM STUFF---------%
    %--------------------------------%
    
    % Get the marker data rate
    rMarkers = c3d.getRate_marker();   
    
    % get opensim table
    markerTable = c3d.getTable_markers();
    % get as matlab structure
    markerStruct = osimTableToStruct(markerTable);
    
    % add SACR to marker table
    markerStruct.SACR = (markerStruct.RPSI + markerStruct.LPSI)./2;
    newMarkerTable = osimTableFromStruct(markerStruct);
    newMarkerTable.addTableMetaDataString('DataRate',num2str(rMarkers)); 
    % Get units of marker data
    originalUnits = markerTable.getTableMetaDataString('Units');
    newMarkerTable.addTableMetaDataString('Units',originalUnits);
    
    % Write marker data to trc file.
%     c3d.writeTRC([new_path_name filename '_XTRAPELV_markers_rotated.trc'],newMarkerTable);
    c3d.writeTRC([folderLoc filename '_markers_rotated_wrtOrigin.trc'],newMarkerTable);
    
end