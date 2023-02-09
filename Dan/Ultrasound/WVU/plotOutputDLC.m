clear all
totalTime = 12; % s
totalFrames  = 938;
frameRate = totalFrames / totalTime;
timeVec = 1/frameRate:1/frameRate:totalTime;

% perturbationInfo = readtable('D:\Ultrasound\hunter\perturbationInfo.csv');
perturbationInfo = readtable('G:\Shared drives\NeuroMobLab\Experimental Data\Ultrasound\TriggerTesting\Hunter_45perts\ConvertedAndAnalyzedTrials\perturbationInfo.csv');


viconLocation = 'G:\Shared drives\NeuroMobLab\Experimental Data\Vicon Matlab Processed\Testing\TriggerTesting\Hunter\Session1\';
% dlcLocation = 'D:\Ultrasound\hunter\';
dlcLocation = 'G:\Shared drives\NeuroMobLab\Experimental Data\Ultrasound\TriggerTesting\Hunter_45perts\ConvertedAndAnalyzedTrials\';


trials = find(perturbationInfo.dV == 0);


for jTrial=1:length(trials)
    
    % get trial name and then load files
    if trials(jTrial) < 10
        trialName = ['USPert0' num2str(trials(jTrial))];
    else
        trialName = ['USPert' num2str(trials(jTrial))];
    end
    perturbedCycle = perturbationInfo.perturbedGC(trials(jTrial));
    trialName
    % load vicon data to get gait events
    load([viconLocation trialName]);
    RHS = rawData.video.GaitEvents.RHStime;
    RTO = rawData.video.GaitEvents.RTOtime;
    if RTO(1) < RHS(1), RTO(1) = []; end
    % load CSV of DLC output
    estimatedData = csvread([dlcLocation trialName 'DLC_mobnet_100_Production2Dec18shuffle1_18000.csv'],3,0);
%     estimatedData3 = csvread([dlcLocation trialName '.csv'],3,0);
    % run modifiedMedianFilter on this data, call this out
    out = modifiedMedianFilter(estimatedData,7, 0.5)*40/804;
    % smooth the original estimated data
    estimatedData2 = estimatedData;
    estimatedData2(:,2) = smoothdata(estimatedData(:,2), 'sgolay',20)*40/804; 
    estimatedData2(:,3) = smoothdata(estimatedData(:,3), 'sgolay',20)*40/804;
%     estimatedData2(:,2) = smoothdata(estimatedData2(:,2)) % 40 mm for every 804 pixels based on the settings used in echowave
%     estimatedData2(:,3) = smooth(estimatedData2(:,3))*40/804; % 40 mm for every 804 pixels based on the settings used in echowave
    
%     estimatedData3 = estimatedData;
%     estimatedData3(:,2) = smoothdata(estimatedData3(:,2), 'sgolay',10)*40/804; 
%     estimatedData3(:,3) = smoothdata(estimatedData3(:,3), 'sgolay',10)*40/804;
%     % Original Estimation of the windowX was 20 and Y was 10 
%     
%     estimatedData3(:,2) = estimatedData3(:,2)*40/804;
%     estimatedData3(:,3) = estimatedData3(:,3)*40/804;
    
%     MTJ.(trialName) = estimatedData2;
%     GE.(trialName).RHS = RHS; 
%     GE.(trialName).RTO = RTO;
%     
    
%     MTJ2.(trialName) = estimatedData3;
%     % plot as a function of time
%     figure('units','inches','position',[1 1 6 3])
%     plot(timeVec, sqrt(out(:,2).^2+out(:,3).^2))
%     hold on
%     plot(timeVec, out(:,2))
%     plot(timeVec, out(:,3))
%     set(gca,'fontsize',16)
%     ylimits = get(gca,'YLim');
%     for i=1:length(RHS)
%         line([RHS(i) RHS(i)],ylimits,'color','k','linestyle','--')
%     end
%     xlabel('Time (s)','fontsize',20)
%     ylabel('Pixel Location','fontsize',20)
%     legend('resultant','x','y')
%     legend('orientation','horizontal')
    
    % plot as a function of gait cycle with perturbation IDd
    for i=1:length(RHS)
        [~,GCindex_us(i)] = min(abs(timeVec - RHS(i)));
    end
    figure('units','inches','position',[1 1 3 2])
    hold on
    % out = estimatedData;
    for i=1:(length(RHS)-1)
        if i < perturbedCycle
            plot(out(GCindex_us(i):GCindex_us(i+1),2),'color',[0.7 0.7 0.7])
        elseif i>perturbedCycle
            plot(out(GCindex_us(i):GCindex_us(i+1),2),'color','g')
        else
            plot(out(GCindex_us(i):GCindex_us(i+1),2),'r')
        end
    end
    title([trialName]);
    xlabel('% Gait Cycle','fontsize',16)
    ylabel('Change in Location (mm)','fontsize',16)
    % set(gca,'XTick',[0 24 48 72 96],'XTickLabel',{'0','25','50','100'},'XLim',[0 96])
    
    % plot as a function of gait cycle with perturbation IDd, but using smoothed version of original estimatedData
    for i=1:length(RHS)
        [~,GCindex_us(i)] = min(abs(timeVec - RHS(i)));
%         [~,RTO_us(i)] = min(abs(timeVec - RTO(i)));
    end
    figure('units','inches','position',[1 1 5 4])
    hold on    
    r = sqrt(estimatedData2(:,2).^2 + estimatedData2(:,3).^2);
    for i=1:(length(RHS)-1)
        if i < perturbedCycle
            plot(r(GCindex_us(i):GCindex_us(i+1)),'color',[0.7 0.7 0.7])
        elseif i==perturbedCycle
            plot(r(GCindex_us(i):GCindex_us(i+1)),'r')            
        else
            plot(r(GCindex_us(i):GCindex_us(i+1)),'color',[0.7 0.7 0.7])
        end
%         line([RTO_us(i)-GCindex_us(i), RTO_us(i)-GCindex_us(i)], [500,800])
    end
    title([trialName]);
    xlabel('% Gait Cycle','fontsize',16)
    ylabel('Change in Location (mm)','fontsize',16)
    set(gca,'XTick',[0 24 48 72 96],'XTickLabel',{'0','25','50','75','100'},'XLim',[0 96], 'YLim', [26 42])
    
    GE.(trialName).GCindex = GCindex_us;
    
end
