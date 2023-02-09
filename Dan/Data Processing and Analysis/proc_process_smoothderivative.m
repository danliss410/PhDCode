function signal_out = proc_process_smoothderivative(SignalIn,SampleRate,DerivativeOrder)
% ver. 2 - March 10, 2010 (Jeff Bingham) Switched versioning to mcollapse
% ver. 1 - February 7, 2010 (Jeff Bingham) File created 
%
% signal_out =
%        proc_process_smoothderivative(SignalIn,SampleRate,DerivativeOrder)
%
%            Function to calculate derivative of a signal using a smoothing
%            Savitsky-Golay filter.  Can also be used to smooth data if
%            DerivativeOrder = 0.
%
% #########################################################################
%
%
% SUPPORTING FUNCTIONS:
%                       proc_process_removespikes
%                       proc_process_smoothderivative
%
% ARGUMENTS:
%  SignalIn    [m x n] ... The "m" samples for "n" traces that you want the
%                          derivative for
%  SampleRate      INT ... The rate of samples per second the data was
%                          collected at
%  DerivativeOrder INT ... The order of derivative you wish computed
%
% OUTPUTS:
%  signal_out   [m x 6] ... The "m" samples of the platform data having:
%                           [LVDTx LVDTy Veloc_X Veloc_Y Accel_X AccelY]
%
% #########################################################################

%%% First calculate Savitsky-Golay filter coefficients
filter_order = 3;
filter_size = floor(SampleRate/5);

if filter_size<=filter_order %Force filter size larger than polynomial fit
    filter_size = filter_order+1;
end
half_filter_size = floor(filter_size/2);

A=zeros(2*half_filter_size+1,filter_order+1); % Force filter size to be odd
for q=-half_filter_size:half_filter_size
   for r=0:filter_order
      A(q+half_filter_size+1,r+1)=q^r; % Populate matrix to solve for filter
   end
end

derivative_vector = zeros(filter_order+1,1);
derivative_vector(DerivativeOrder+1) = (-1)^DerivativeOrder;

filter_coefs=A*((A'*A)\derivative_vector); % These are the B coefs, A coefs = 1

% Pad the front and back of the trace with mirrored samples
signal_front = flipud(SignalIn(1:3*half_filter_size,:));
signal_back = flipud(SignalIn(end-3*half_filter_size:end,:));
signal_padded = [signal_front;SignalIn;signal_back];

% Filter the trace
signal_out = filter(filter_coefs,1,signal_padded,[],1);

% Remove buffered samples and phase shift
signal_out(end-2*half_filter_size:end,:) = [];
signal_out(1:4*half_filter_size,:) = [];