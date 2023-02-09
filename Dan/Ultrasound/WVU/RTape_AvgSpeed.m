function [rbelt, lbelt] = RTape_AvgSpeed(tempX, tempY, dataR, dataL) 
% This function takes position data in the X and Y direction from Vicon for
% the unlabeled markers, separates the data into right and left belt,
% calculates the velocity at each frame and plots it, and plots lines at
% the frames for the beginning and end of the perturbation.
%
%
% INPUTS: tempX               - doubles matrix with X position for each marker for every frame
%         tempY               - doubles matrix with Y position for each marker for every frame
%         dataR               - frame for each right heel strike
%         dataL               - frame for each left heel strike
%
% OUPUTS: r_belt              - velocity at each frame for the right belt
%         l_belt              - velocity at each frame for the left belt
%
%
%
%
%
%
% Created: 30 September, 2022
% Modified: (format: date, initials, change made)
%   1 - 
% Things that need to be added 
%   1 - 

%% Get the number of unlabeled markers from the tempX total columns and number of frames from the tempX total rows

guc = length(tempX(1,:));
% Number of frames recorded.
t = length(tempX);

%% Removes positions from Y values (tempY) that are outside bounds of the treadmill

tempY = thresh(tempY, 'Greater', 0, 1200); % removes above upper bound of treadmill

tempY = thresh(tempY, 'Less', 0, 1); % removes below lower bound of treadmill

%% Separates the tempY values into right and left belt by thresholding any values greater than or less than bounds

rightY = thresh(tempY, 'Greater', 0, 200); % creates matrix with only right belt values (must be below 200 mm)

leftY = thresh(tempY, 'Less', 0, 1000); % creates matrix with only left belt values (must be above 1000 mm)

%% for loop counts the number of unlabeled markers tracked on right and left belt

iR = 1; % counter for number of unlabeled markers on the right
iL = 1; % counter for number of unlabeled markers on the left

for j = 1:guc
    if tempY(:,j) == rightY(:,j) % if col from thresholded rightY == col from not separated tempY
        iR = iR + 1;
        if rightY(:,j) == 0 % sometimes an entire marker gets threshed out, so this stops counter from increasing
            iR = iR - 1;
        end
    elseif tempY(:,j) == leftY(:,j) % if col from thresholded leftY == col from not separated tempY
        iL = iL + 1;
        if leftY(:,j) == 0 % same logic as above
            iL = iL - 1;
        end
    end
end

%% % Thresholds for X values (tempX) that exist outside the bounds of the treadmill

tempX = thresh(tempX, "Greater", 0, 1750); % removes above upper bound of treadmill (1850 mm)

tempX = thresh(tempX, "Less", 0, 250); % removes below lower bound of treadmill (150 mm)
% treadmill is actually 0-2000 mm but wanted to eliminate overlapping of
% data

%% Separates the tempX values into right and left belt by 
% X value variables for the markers on the right and left treadmills (cannot use
% threshold function to simplify this because the right and left side both
% utilize the same X values)
rightX = NaN(t,iR);

leftX = NaN(t,iL);

r_comp = tempY == rightY; % logical matrix comparing the tempY elements that are the same as the rightY elements

l_comp = tempY == leftY; % logical matrix comparing the tempY elements that are the same as the leftY elements
% Counters for the number of columns in the rightX and leftX matrices
% (or number of unlabeled markers detected on either side)
rd = 1; % counter for rightX that indicates what column the X position values will be added to
ld = 1; % counter for leftX that indicates what column the X position values will be added to

for i = 1:guc
    if all(r_comp(:,i)) == 1 % if all of the values in col i of r_comp are 1, then col i of tempX should be added to rightX
        rightX(:,rd) = tempX(:,i);
        rd = rd + 1;
    end
    if all(l_comp(:,i)) == 1 % if all of the values in col i of l_comp are 1, then col i of tempX should be added to leftX
        leftX(:,ld) = tempX(:,i);
        ld = ld + 1;
    end
end

%%  Derivatives for the right and left X values

r_der = diff(rightX, 1, 1);

l_der = diff(leftX, 1, 1);

%% Thresholding velocities that are outside the bounds of what can be achieved

r_der = thresh(r_der, "Greater", NaN, -0.1)/10; % sets anything greater than -0.1 to NaN to get rid of unreasonable values (NaN because the smoothing function doesn't include these)

r_der = thresh(r_der, "Less", NaN, -10); % same as above, except anything less than -100

r_der(r_der == 0) = NaN; % sets all values of 0 for right velocity to NaN so the smoothing function doesn't get skewed

r_der = proc_process_smoothderivative(r_der, 100, 0); % smoothing the noise on the right derivative

l_der = thresh(l_der, "Greater", NaN, -0.1)/10; % same as r_der

l_der = thresh(l_der, "Less", NaN, -10); % same as r_der

l_der(l_der == 0) = NaN; % sets all values of 0 for left velocity to NaN so the smoothing function doesn't get skewed

l_der = proc_process_smoothderivative(l_der, 100, 0); % smoothing the noise on the left derivative

%% Finding the average velocity at each frame

rbelt = mean(r_der, 2, 'omitnan');

lbelt = mean(l_der, 2, 'omitnan');
