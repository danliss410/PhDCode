%% Plotting to figure out what is wrong with some subjects 
segNames = {'pelvis'; 'femur_r'; 'tibia_r'; 'talus_r'; 'calcn_r'; 'toes_r'; ...
    'femur_l'; 'tibia_l'; 'talus_l'; 'calcn_l'; 'toes_l'; 'torso';};
nBodies = size(segNames,1);

for iTrials = 2%:7 
    
    for iSegs = 1:nBodies
        
        figure; 
        subplot(3,1,1); plot(AngMom.([segNames{iSegs} '_X']){iTrials});
        title([segNames{iSegs} ' ' AngMom.Trial{iTrials}]);
        subplot(3,1,2); plot(AngMom.([segNames{iSegs} '_Y']){iTrials});
        subplot(3,1,3); plot(AngMom.([segNames{iSegs} '_Z']){iTrials});
    end
end
        
