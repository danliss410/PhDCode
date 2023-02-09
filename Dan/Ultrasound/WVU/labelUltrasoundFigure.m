clear all

% load video file
dlcLocation = 'G:\Shared drives\Perception Project\videos\';
% dlcLocation = 'G:\Shared drives\NeuroMobLab\Experimental Data\Ultrasound\TriggerTesting\Hunter_45perts\ConvertedAndAnalyzedTrials\';
videoFile = [dlcLocation 'YAUSPercep09_YNPercep46.avi'];
v = VideoReader(videoFile);

% load data from DLC
% estimatedData = csvread('D:\Ultrasound\hunter\USPert22DLC_mobnet_100_Production2Dec18shuffle1_18000.csv',3,0);
estimatedData = csvread([dlcLocation 'YAUSPercep09_YNPercep46DLC_resnet50_NML_MTJTrackSep7shuffle5_20000.csv'],3,0);


% flag for if you want to make a video (1 = yes)
makeVideo = 1;

%%

x = estimatedData(:,2);
y = estimatedData(:,3);

cd(dlcLocation)
if makeVideo
    vOut = VideoWriter('YAUSPercep09_YNPercep46_DLC_Fix.avi');
    open(vOut);
end


% create figure that is size of video
hf = figure;
set(hf,'position',[150 150 v.Width v.Height])
currAxes = axes;

% loop through all frames (or, change values of i to only go through some
% of the frames)
for i=1:v.numFrames
    v.CurrentTime = i/v.FrameRate;
    vidFrame = readFrame(v);
    imshow(vidFrame, 'Parent', currAxes);
    currAxes.Visible = 'off';
    title(['frame ' num2str(i) '; q = ' num2str(round(estimatedData(i,4),3))])
    
    % color of dot to be drawn based on the estimated quality at the
    % current frame
    if estimatedData(i,4) >= 0.95
        mColor = 'g';
    elseif  estimatedData(i,4) >= 0.90
        mColor = 'y';
    elseif estimatedData(i,4) >=0.8
        mColor = [1 0.5 0];
    else
        mColor = 'r';
    end
    % draw a circular region of interest (roi) at the current x,y location
    roi = drawpoint('Position',[estimatedData(i,2), estimatedData(i,3)],'markersize',7,'color',mColor);
%     pause % don't go to the next part of the code until something on the keyboard has been pressed. use this "time" to move the circle on the figure if needed
    % take the current position of the circle and set it as x,y. this
    % allows you to move the circle and it will store the new position
    x(i) = roi.Position(1);
    y(i) = roi.Position(2);   
    
    if makeVideo
        f = getframe(currAxes);
        writeVideo(vOut,f);
    end
end

if makeVideo
    close(vOut);
end
