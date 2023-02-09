%% OpenSim Processing
% This script is a batch processing to convert C3D files to trc and mot
% files used for processing in OpenSim. This function feeds the force
% representation, asks if you want to create a trc and mot, the file
% location, and filename into createOSIMInputFilesVicon_NeuroMobLab_DJL which
% will output the trc and mot files for each trial name. 
clear 
home
subjects = {'09'; '10';};
for iSub = 1:length(subjects)
    % Setting up the trc and mot function
    forceRepresentation = 0; % 1 wrt to COP. Use 0 for wrt to force plates
    markerFile = 1; % Create marker trc file
    grfFile = 1; % Create force file (mot)
%     subjectName = '09';
    subjectName = subjects{iSub};
    session = '1';
    fileLocation = ['G:\Shared drives\Perception Project\Ultrasound\OpenSim\YAUSPercep' subjectName '\c3dFiles\'];
    
    % Creating a loop to write trcs and mots for each subject 
    fileLocationNames = ['G:\Shared drives\Perception Project\Ultrasound\OpenSim\YAUSPercep' subjectName '\c3dFiles\' ];
    cd(fileLocationNames)
    A = dir; 
    temp = struct2cell(A);
    
    tempNames = temp(1,:);
    tempfilenames = tempNames(3:end);
    
    for iName = 1:size(tempfilenames,2)
        tempF = strrep(tempfilenames(iName), '.mat', '.c3d');
        filenames{iName} = tempF;
    end
    %%
    
    for iFilename = 1:length(filenames)
        filename = char(filenames{iFilename});
        createOsimFiles_US(forceRepresentation, markerFile, grfFile, fileLocation, filename, subjectName);
        disp(filename)
    end 

end
disp('Finished Processing')
beep
