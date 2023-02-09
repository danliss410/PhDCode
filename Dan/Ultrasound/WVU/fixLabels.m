function [fixedData] = fixLabels(trialName,estimatedData, badFrames)
%
%
% This function can be used to replace "bad" data from the DLC labelling.
% Only use for those "bad" data where there is a big jump in position. One
% way to find this is to plot the diff(estimatedData(:,2)) and peaks will
% be places that the x-position of the labeled MTJ jumps quite a bit to a
% really obvious non-MTJ position
%
%
% Prior to running this code, you need to load the data from a DLC outout
% (this is what the estimatedData input is) and you need to identify frames
% of bad data. If you have more than one location of bad data, you can do
% this as e.g., badFrames = [10:15, 22:25; 134:146]


% makeVideo = 1; 

% load video file with  
videoLoc = ['G:\Shared drives\Perception Project\videos\'];
videoFile = [videoLoc trialName '.avi'];
% videoFile = ['D:\Ultrasound\hunter\' trialName '.avi'];
v = VideoReader(videoFile);

% set fixedData to the intput estimatedData
fixedData = estimatedData;
% fixedData = estimatedData;

% cd(videoLoc)
% if makeVideo
%     vOut = VideoWriter([trialName 'DLC_Fix.avi']);
%     open(vOut);
% end

% create figure that is size of video
hf = figure;
set(hf,'position',[150 150 v.Width v.Height])
currAxes = axes;

% loop through  bad frames, and plot the video image with a circle overlaid
% at the estimated location
for i=1:length(badFrames)
    tbF = badFrames(i);
    v.CurrentTime = tbF/v.FrameRate;
     vidFrame = readFrame(v);
    imshow(vidFrame, 'Parent', currAxes);
    currAxes.Visible = 'off';
    title(['frame ' num2str(tbF) '; Number of Frames Lefts to label ' num2str(length(badFrames)-i)])
    
    % color of dot to be drawn based on the estimated quality at the
    % current frame
%     if estimatedData(i,4) >= 0.95
%         mColor = 'g';
%     elseif  estimatedData(i,4) >= 0.90
%         mColor = 'y';
%     elseif estimatedData(i,4) >=0.8
%         mColor = [1 0.5 0];
%     else
%         mColor = 'r';
%     end
    % draw a circular region of interest (roi) at the current x,y location
    roi = drawpoint('Position',[estimatedData(i,2), estimatedData(i,3)],'markersize',12,'color','r');
%     pause;
     % don't go to the next part of the code until something on the keyboard has been pressed. use this "time" to move the circle on the figure if needed
    % take the current position of the circle and set it as x,y. this
    % allows you to move the circle and it will store the new position
    fixedData(i,2) = roi.Position(1);
    fixedData(i,3) = roi.Position(2);
    
%     if makeVideo
%         f = getframe(currAxes);
%         writeVideo(vOut,f);
%     end
end
end

