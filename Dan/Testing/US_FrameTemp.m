% Calc the resultant 

PertNames = fieldnames(MTJ);

for i = 1:3 
    R.(PertNames{i}) = sqrt(MTJ.(PertNames{i})(:,2).^2 + MTJ.(PertNames{i})(:,3).^2);
end


%% Testing different Filtering Methods 

%sgolay method -Savitzky-Golay filter, which smooths according to a quadratic polynomial that is fitted over each window of A. 
% This method can be more effective than other methods when the data varies rapidly.
data.sgol = estimatedData; 
[data.sgol(:,2), window.sgolX] = smoothdata(data.sgol(:,2), 'sgolay'); 
[data.sgol(:,3), window.sgolY] = smoothdata(data.sgol(:,3), 'sgolay');
data.sgol(:,2) = data.sgol(:,2)*40/804;
data.sgol(:,3) = data.sgol(:,3)*40/804;
R.sgol = sqrt(data.sgol(:,2).^2 + data.sgol(:,3).^2);

%moving average filter 
data.mMean = estimatedData;
[data.mMean(:,2), window.mMeanX] = smoothdata(data.mMean(:,2), 'movmean');
[data.mMean(:,3), window.mMeanY] = smoothdata(data.mMean(:,3), 'movmean');
data.mMean(:,2) = data.mMean(:,2)*40/804;
data.mMean(:,3) = data.mMean(:,3)*40/804;
R.mMean = sqrt(data.mMean(:,2).^2 + data.mMean(:,3).^2);

%moving median filter 
data.mMed = estimatedData;
[data.mMed(:,2), window.mMedX] = smoothdata(data.mMed(:,2), 'movmedian');
[data.mMed(:,3), window.mMedY] = smoothdata(data.mMed(:,3), 'movmedian');
data.mMed(:,2) = data.mMed(:,2)*40/804;
data.mMed(:,3) = data.mMed(:,3)*40/804;
R.mMed = sqrt(data.mMed(:,2).^2 + data.mMed(:,3).^2);


%Gaussian filter 
data.gau = estimatedData;
[data.gau(:,2), window.gauX] = smoothdata(data.gau(:,2), 'gaussian');
[data.gau(:,3), window.gauY] = smoothdata(data.gau(:,3), 'gaussian');
data.gau(:,2) = data.gau(:,2)*40/804;
data.gau(:,3) = data.gau(:,3)*40/804;
R.gau = sqrt(data.gau(:,2).^2 + data.gau(:,3).^2);


%Linear Regression filter 
data.low = estimatedData;
[data.low(:,2), window.lowX] = smoothdata(data.low(:,2), 'lowess');
[data.low(:,3), window.lowY] = smoothdata(data.low(:,3), 'lowess');
data.low(:,2) = data.low(:,2)*40/804;
data.low(:,3) = data.low(:,3)*40/804;
R.low = sqrt(data.low(:,2).^2 + data.low(:,3).^2);


%Quadratic Regression filter 
data.lo = estimatedData;
[data.lo(:,2), window.loX] = smoothdata(data.lo(:,2), 'loess');
[data.lo(:,3), window.loY] = smoothdata(data.lo(:,3), 'loess');
data.lo(:,2) = data.lo(:,2)*40/804;
data.lo(:,3) = data.lo(:,3)*40/804;
R.lo = sqrt(data.lo(:,2).^2 + data.lo(:,3).^2);


%Robust Linear Regression filter 
data.rlow = estimatedData;
[data.rlow(:,2), window.rlowX] = smoothdata(data.rlow(:,2), 'rlowess');
[data.rlow(:,3), window.rlowY] = smoothdata(data.rlow(:,3), 'rlowess');
data.rlow(:,2) = data.rlow(:,2)*40/804;
data.rlow(:,3) = data.rlow(:,3)*40/804;
R.rlow = sqrt(data.rlow(:,2).^2 + data.rlow(:,3).^2);

%Robust Quadratic Regression filter 
data.rlo = estimatedData;
[data.rlo(:,2), window.rloX] = smoothdata(data.rlo(:,2), 'rloess');
[data.rlo(:,3), window.rloY] = smoothdata(data.rlo(:,3), 'rloess');
data.rlo(:,2) = data.rlo(:,2)*40/804;
data.rlo(:,3) = data.rlo(:,3)*40/804;
R.rlo = sqrt(data.rlo(:,2).^2 + data.rlo(:,3).^2);

%% Data smooth 
data.orig = estimatedData;
data.orig(:,2) = data.orig(:,2)*40/804;
data.orig(:,3) = data.orig(:,3)*40/804;
R.orig = sqrt(data.orig(:,2).^2 + data.orig(:,3).^2);

data.smooth = estimatedData2; 
R.smooth = sqrt(data.smooth(:,2).^2 + data.smooth(:,3).^2);


%% Plotting different Methods 


figure('units','inches','position',[1 1 3 2])
hold on    
for i=1:(length(RHS)-1)
    if i < perturbedCycle
        plot(R.orig(GCindex_us(i):GCindex_us(i+1)),'r'); %'color',[0.75 0.75 0.75])
        plot(R.smooth(GCindex_us(i):GCindex_us(i+1)),'b');%'color',[0.5 0.5 0.5])
        plot(R.sgol(GCindex_us(i):GCindex_us(i+1)),'k');%'color',[0.25 0.25 0.25])
    elseif i==perturbedCycle
        plot(R.orig(GCindex_us(i):GCindex_us(i+1)),'r')   
        plot(R.smooth(GCindex_us(i):GCindex_us(i+1)),'b')
        plot(R.sgol(GCindex_us(i):GCindex_us(i+1)),'k')
    else
%         plot(data.orig(GCindex_us(i):GCindex_us(i+1),2),'color','g')
%         plot(data.sgol(GCindex_us(i):GCindex_us(i+1),2),'color','b')
    end
    legend({'Original'; 'Smooth fcn'; 'Sgol Filter';})
end
xlabel('% Gait Cycle','fontsize',16)
ylabel('Change in Location (mm)','fontsize',16)
    
    %% 

for i = 1:3 
    Err1.(PertNames{i}) = diff(R.(PertNames{i}));
    for j = 2:936
        Err2.(PertNames{i})(j-1) = R.(PertNames{i})(j+2) - R.(PertNames{i})(j);
    end
end


for i = 1:3 
    figure; 
    plot(Err1.(PertNames{i}), 'k'); 
    hold on; 
    title(['1 Frame Error for -0.1 m/s Pert ' PertNames{i}]);
    ylabel('mm');
    xlabel('Frames');
    for j = 1:length(GE.(PertNames{i}).GCindex)-1
        xline(GE.(PertNames{i}).GCindex(j), 'r');
    end
end



for i = 1:3 
    figure; 
    plot(Err2.(PertNames{i}), 'k'); 
    hold on; 
    title(['2 Frame Error for -0.1 m/s Pert ' PertNames{i}]);
    ylabel('mm');
    xlabel('Frames');
    for j = 1:length(GE.(PertNames{i}).GCindex)
        xline(GE.(PertNames{i}).GCindex(j), 'r');
    end
end