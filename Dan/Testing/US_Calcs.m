%% Dan Breakdown of US data 

RHS = GE.USPert11.RHS;
GCindex_us = GE.USPert11.GCindex;
data = MTJ.USPert11(:,2);
data2 = MTJ.USPert11(:,3);




%% This will plot the difference between timesteps 
temp3 = nan(9,200);
temp4 = nan(9,200);
for i=1:(length(RHS)-1)
% plot(hist(GCindex_us(i):GCindex_us(i+1)));
% hold on; 
    for j = 1:(GCindex_us(i+1)-GCindex_us(i))
        if j == 1
            temp = GCindex_us(i);
            temp3(i,j) = data(temp);
            temp4(i,j) = data2(temp);
        else
            temp2 = temp + j;
            temp3(i,j) = data(temp2);
            temp4(i,j) = data2(temp2);
        end
        
    end
end

%% Histogram plot of data 

figure; hist3([data data2], 'CdataMode', 'auto');
colorbar;

data3 = diff(data); 
data4 = diff(data2); 

figure; hist3([data3 data4], 'CdataMode', 'auto');
colorbar;
