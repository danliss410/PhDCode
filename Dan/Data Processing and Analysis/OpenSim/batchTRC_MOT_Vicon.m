%% OpenSim Processing
% This script is a batch processing to convert C3D files to trc and mot
% files used for processing in OpenSim. This function feeds the force
% representation, asks if you want to create a trc and mot, the file
% location, and filename into createOSIMInputFilesVicon_NeuroMobLab_DJL which
% will output the trc and mot files for each trial name. 
clear 
home

% Setting up the trc and mot function
forceRepresentation = 0; % 1 wrt to COP. Use 0 for wrt to force plates
markerFile = 1; % Create marker trc file
grfFile = 1; % Create force file (mot)
fileLocation = 'G:\Shared drives\NeuroMobLab\Experimental Data\Vicon Processed\Pilot Experiments\WVCTSI_Perception2019\YAPercep09\Session1\';
subjectName = '09';
% Creating a loop to write trcs and mots for each subject 

filenames = {...'Cal01.c3d' ;};  
     'Treadmill01.c3d';... 'Treadmill02.c3d';... 'Treadmill03.c3d';...
    'Percep01_1.c3d'; 'Percep01_2.c3d'; 'Percep01_3.c3d'; 'Percep01_4.c3d'; 'Percep01_5.c3d';...'Percep01_6.c3d';...
    'Percep02_1.c3d'; 'Percep02_2.c3d'; 'Percep02_3.c3d'; 'Percep02_4.c3d';... 'Percep02_5.c3d';... 'Percep02_6.c3d'; 'Percep02_7.c3d'; 'Percep02_8.c3d';...
     'Percep03_1.c3d'; 'Percep03_2.c3d'; 'Percep03_3.c3d'; 'Percep03_4.c3d';... 'Percep03_5.c3d';... 'Percep03_6.c3d'; 'Percep03_7.c3d'; 'Percep03_8.c3d';... 'Percep03_9.c3d';}; 
    'Percep04_1.c3d'; 'Percep04_2.c3d'; 'Percep04_3.c3d'; 'Percep04_4.c3d';};... 'Percep04_5.c3d';};... 'Percep04_6.c3d'; 'Percep04_7.c3d'; ...
%     'Percep05_1.c3d'; 'Percep05_2.c3d'; 'Percep05_3.c3d'; 'Percep05_4.c3d'; 'Percep05_5.c3d'; 'Percep05_6.c3d'; 'Percep05_7.c3d';};

for iFilename = 1:length(filenames)
    filename = char(filenames{iFilename});
    createOSIMInputFilesVICON_NeuroMobLab_DJL(forceRepresentation, markerFile, grfFile, fileLocation, filename, subjectName);
    disp(filename)
end 

disp('Finished Processing')
beep
