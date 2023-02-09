function signal_out = proc_process_removespikes(SignalIn,FilterSize,NumStdDev)
% ver. 2 - March 10, 2010 (Jeff Bingham) Switched versioning to mcollapse
% ver. 1 - February 6, 2010 (Jeff Bingham) File created from the previous
%          'NoiseCancellation (Feb 18, 2005)'
% ver. B - Feb 18, 2005 (Hari Trivedi) Changed to function form
% ver. A - November 20, 2004 (Ting Group) Created as NoiseCancellation
%
% signal_out = proc_process_removespikes(SignalIn,FilterSize,NumStdDev)
%
%            Function designed to remove random noise from the
%            acceleration, velocity and force data. It will search for
%            spikes and eliminate them.
%
% #########################################################################
%
%
% SUPPORTING FUNCTIONS:
%
% ARGUMENTS:
%  SignalIn   [m x n] ... The "m" samples for "n" separate traces that
%                         spikes wish to be removed from
%  FilterSize   INT ..... The size of the filter window
%  NumStdDev    INT ..... The number of standard deviations from a windowed
%                         mean that to be considered the threshold for a
%                         spike
%
% OUTPUTS:
%  signal_out [m x n] ... The "m" samples of "n" corrected traces
%
% #########################################################################

% Create variable to hold output signal
signal_out = SignalIn;

% Determines number of samples in SignalIn variable
samples = size(SignalIn,1);

% Begin traversing Signal
half_filter_length = ceil(FilterSize/2);
for c=half_filter_length+1:(samples-half_filter_length)
    
    % create the current block to filter
    block = SignalIn(c-half_filter_length:c+half_filter_length,:);
    
    % find the median and standard deviation of the block
    block_median = nanmedian(block,1);
    block_stdev= nanstd(block,0,1);
    
    % Computes the difference between the current point and the median,
    % and if greater than one standard deviation, determines that the
    % point is a spike, and removes it by replacing the current value
    % with the value of the median
    block_difference = abs(SignalIn(c,:)-block_median) - NumStdDev*block_stdev;
    spike_index = find(block_difference>0);
    if ~isempty(spike_index)
        signal_out(c,spike_index) = block_median(spike_index);
    end
end

% Take care of front and end of trace
block = SignalIn(1:2*half_filter_length,:);
block_mean = nanmedian(block,1);
signal_out(1:half_filter_length,:) = repmat(block_mean,half_filter_length,1);
block = SignalIn(end-2*half_filter_length:end,:);
block_mean = nanmedian(block,1);
signal_out(end-half_filter_length+1:end,:) = repmat(block_mean,half_filter_length,1);