
modelFile = '/Users/jla0024/Documents/OpenSim/4.1/Models/Gait2354_Simbody/OutputReference/subject01_scaledOnly.osim';
ikfile = '/Users/jla0024/Documents/OpenSim/4.1/Models/Gait2354_Simbody/OutputReference/subject01_walk1_ik.mot';

startPath = '/Users/jla0024/Documents/OpenSim/4.1/Models/Gait2354_Simbody/OutputReference/';
savePath = '/Users/jla0024/Documents/OpenSim/4.1/Models/Gait2354_Simbody/OutputReference/TestResults2/';

import org.opensim.modeling.*;

% open model
model = Model(modelFile);

% BodyKinematics tool
bkTool = BodyKinematics();
bkTool.setStartTime(0.4);
bkTool.setEndTime(1.6);
model.addAnalysis(bkTool);

% MuscleAnalysisTool
maTool = MuscleAnalysis();
maTool.setStartTime(0.4);
maTool.setEndTime(1.6);
maTool.setComputeMoments(false); %can get muscle moment arms if remove this or set to true
model.addAnalysis(maTool);

% analysis
analysis = AnalyzeTool(model);
analysis.setName('subject01_test');
analysis.setModel(model);
analysis.setInitialTime(0.4);
analysis.setFinalTime(1.6);
analysis.setLowpassCutoffFrequency(6);
analysis.setCoordinatesFileName(ikfile);
analysis.setLoadModelAndInput(true);
analysis.setResultsDir(savePath);
analysis.run();