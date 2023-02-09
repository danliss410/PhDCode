
%% Overall Perception Processing Script

%% Calculate the threshold for each subject


% newSubject                  = input('\n Do you need to calculate thresholds for a new subject? 1 for yes & 0 for no: ');
subject = {'04';'05';'06';'07';'08';'09';'10';'11';'12';'13';'14';'15'};
% while newSubject            == 1
for iSubject = 1:length(subject)
%     subject                 = input('\n Please put the number of subject: ', 's');
    thresholdTable          = perceptionThreshold(subject{iSubject}); % theresholdTable = perceptionThreshold(subject);
    
%     newSubject              = input('\n Do you have any additional subjects? 1 for yes & 0 for no: ');
    disp(subject)
end

%% Calculate the spatiotemporal parameters from marker data 
% 
% newSubject                  = input('\n Do you need to calculate spatiotemporal parameters for a new subject? 1 for yes & 0 for no: ');
% 
% while newSubject            == 1
%     subject                 = input('\n Please put the number of the subject: ', 's');
%     spatioTemporalTable     = spatioTemporalParameters(subject);
%     
%     newSubject              = input('\n Do you have any additional subjects? 1 for yes & 0 for no: ');
% end
