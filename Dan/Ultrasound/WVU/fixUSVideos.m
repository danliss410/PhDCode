function fixUSVideos(trialName)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

% Location of video files 
dlcLocation = 'G:\Shared drives\Perception Project\videos\';


% Fixed data of the MTJ location
% estimatedData = csvread([dlcLocation trialName '.csv'],3,0);
estimatedData = csvread([dlcLocation trialName '.csv'],0,0);
% estimatedData = csvread([dlcLocation trialName 'DLC_resnet50_NML_MTJTrackSep7shuffle5_20000.csv'], 3,0);

% estimatedData(:,2) = smoothdata(estimatedData(:,2), 'sgolay',20); 
% estimatedData(:,3) = smoothdata(estimatedData(:,3), 'sgolay',20);

% Getting original video file 
tempFix = trialName(1,8:end);
videoFile = [dlcLocation tempFix '.avi'];
% videoFile = [dlcLocation trialName '.avi'];
v = VideoReader(videoFile);

% Changing location to dlcUS folder 
cd(dlcLocation)

% Creating video for fixed values 
vOut = VideoWriter([trialName 'DLC_Fix.avi']);
vOut.Quality = 100;
vOut.FrameRate = v.FrameRate; 
open(vOut);

% create figure that is size of video
hf = figure;
set(hf,'position',[150 150 v.Width v.Height])
currAxes = axes;


% loop through all frames (or, change values of i to only go through some
% of the frames)
for i=1:v.numFrames-1
    v.CurrentTime = i/v.FrameRate;
    vidFrame = readFrame(v);
    imshow(vidFrame, 'Parent', currAxes);
    currAxes.Visible = 'off';
    
    
    
    drawpoint('Position',[estimatedData(i,2), estimatedData(i,3)],'markersize',12,'color','b');
    
    
    
    
    f = getframe(currAxes);
    writeVideo(vOut,f);



end
close all
end


