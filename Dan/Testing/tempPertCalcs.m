%% This is a file that will find the magnitude of the perturbations over the stance phase 

% speeds = {'sp1'; 'sp2'; 'sp3'; 'sp4'; 'sp5'; 'sp6'; 'sp7'; 'sp8'};
% 
% for iTrials = 1:size(pertTable.("Trial"),1)
%     for iSpeeds = 1:8
%         if isempty(tempTab.("Left Cycle Frames Onset"){iSpeeds,1}{iTrials})
%             disp('This speed is not in this trial')
%             calc.(speeds{iSpeeds}).L{iTrials} = [];
%         else
%             for iRepeats = 1:length(tempTab.("Left Cycle Frames Onset"){iSpeeds,1}{iTrials})
%                 calc.(speeds{iSpeeds}).L{iTrials}{iRepeats} = -IKTable.("L Calcaneus Z"){iTrials,1}(tempTab.("Left Cycle Frames Onset"){iSpeeds,1}{iTrials}{1,iRepeats}(1):tempTab.("Left Cycle Frames Onset"){iSpeeds,1}{iTrials}{1,iRepeats}(3))-1;
%             end
%         end
%     end
% end
% 
% for iTrials = 1:size(pertTable.("Trial"),1)
%     for iSpeeds = 1:8
%         if isempty(tempTab.("Right Cycle Frames Onset"){iSpeeds,1}{iTrials})
%             disp('This speed is not in this trial')
%             calc.(speeds{iSpeeds}).R{iTrials} = [];
%         else
%             for iRepeats = 1:length(tempTab.("Right Cycle Frames Onset"){iSpeeds,1}{iTrials})
%                 calc.(speeds{iSpeeds}).R{iTrials}{iRepeats} = -IKTable.("R Calcaneus Z"){iTrials,1}(tempTab.("Right Cycle Frames Onset"){iSpeeds,1}{iTrials}{1,iRepeats}(1):tempTab.("Right Cycle Frames Onset"){iSpeeds,1}{iTrials}{1,iRepeats}(3))-1;
%             end
%         end
%     end
% end

%%
% B = -IKTable.("L Calcaneus Z"){1,1} - 1;
% 
% figure; plot(B)
% hold on;
% for i = 1:length(pertTable.("Left Gait Cycle Num"){1,1})
%     temp = pertTable.("Left Gait Cycle Num"){1,1}(i);
%     temp2 = gaitEventsTable.("Gait Events Left"){1,1}(temp,:);
%     plot(temp2(1):temp2(3), B(temp2(1):temp2(3)),'r')
% end
% legend
% title('YAPercep11 Left Calc Velocity AP with labeled perturbations')
% xlabel('Frames')
% ylabel('Velocity of Calc (m/s)')
% 



%% 
% 
% 
% 
% for iTrials = 1:4
%     YAPercep12.L{iTrials} = -IKTable.("L Calcaneus Z"){iTrials,1} - 0.95;
%     YAPercep12.R{iTrials} = -IKTable.("R Calcaneus Z"){iTrials,1} - 0.95;
%     for iPerts = 1:length(pertTable.("Left Gait Cycle Num"){iTrials})
%         temp = pertTable.("Left Gait Cycle Num"){iTrials,1}(iPerts)+1;
%         temp2 = gaitEventsTable.("Gait Events Left"){iTrials,1}(temp,:);
%         YAPercep12.LGCF{iTrials}{iPerts} = [temp2(1)+10,temp2(4)-23];
%         YAPercep12.Lm{iTrials}{iPerts} = mean(YAPercep12.L{iTrials}(YAPercep12.LGCF{iTrials}{iPerts}(1):YAPercep12.LGCF{iTrials}{iPerts}(2)));
%     end
%     
%     for iPerts2 = 1:length(pertTable.("Right Gait Cycle Num"){iTrials})
%         temp3 = pertTable.("Right Gait Cycle Num"){iTrials,1}(iPerts2)+1;
%         temp4 = gaitEventsTable.("Gait Events Right"){iTrials,1}(temp3,:);
%         YAPercep12.RGCF{iTrials}{iPerts2} = [temp4(1)+10, temp4(4)-23];
%         YAPercep12.Rm{iTrials}{iPerts2} = mean(YAPercep12.R{iTrials}(YAPercep12.RGCF{iTrials}{iPerts2}(1):YAPercep12.RGCF{iTrials}{iPerts2}(2)));
%     end
%    figure; plot(YAPercep12.L{iTrials});
%    hold on; 
%    title(['YAPercep12 Left ' {iTrials}]);
%    for iPlot = 1:length(pertTable.("Left Gait Cycle Num"){iTrials,1})
%        plot(YAPercep12.LGCF{iTrials}{iPlot}(1):YAPercep12.LGCF{iTrials}{iPlot}(2), YAPercep12.L{iTrials}(YAPercep12.LGCF{iTrials}{iPlot}(1):YAPercep12.LGCF{iTrials}{iPlot}(2)), 'r')
%    end
%    
%    
%    figure; plot(YAPercep12.R{iTrials});
%    hold on;
%    title(['YAPercep12 Right ' {iTrials}]);
%    for iPlot = 1:length(pertTable.("Right Gait Cycle Num"){iTrials,1})
%        plot(YAPercep12.RGCF{iTrials}{iPlot}(1):YAPercep12.RGCF{iTrials}{iPlot}(2), YAPercep12.R{iTrials}(YAPercep12.RGCF{iTrials}{iPlot}(1):YAPercep12.RGCF{iTrials}{iPlot}(2)), 'r')
%    end
% end
% 
% 
% 
% 
% 
% 
% %% Creating speed variables to find the perturbation repeats 
% 
% for iTrials = 1:4
%     LeftSpeed.sp1{iTrials} = pertTable.("Left Pert Speed"){iTrials} == 0;
%     LeftSpeed.sp2{iTrials} = pertTable.("Left Pert Speed"){iTrials} == -0.02;
%     LeftSpeed.sp3{iTrials} = pertTable.("Left Pert Speed"){iTrials} == -0.05;
%     LeftSpeed.sp4{iTrials} = pertTable.("Left Pert Speed"){iTrials} == -0.10;
%     LeftSpeed.sp5{iTrials} = pertTable.("Left Pert Speed"){iTrials} == -0.15;
%     LeftSpeed.sp6{iTrials} = pertTable.("Left Pert Speed"){iTrials} == -0.20;
%     LeftSpeed.sp7{iTrials} = pertTable.("Left Pert Speed"){iTrials} == -0.30;
%     LeftSpeed.sp8{iTrials} = pertTable.("Left Pert Speed"){iTrials} == -0.40;
%     
%     RightSpeed.sp1{iTrials} = pertTable.("Right Pert Speed"){iTrials} == 0;
%     RightSpeed.sp2{iTrials} = pertTable.("Right Pert Speed"){iTrials} == -0.02;
%     RightSpeed.sp3{iTrials} = pertTable.("Right Pert Speed"){iTrials} == -0.05;
%     RightSpeed.sp4{iTrials} = pertTable.("Right Pert Speed"){iTrials} == -0.10;
%     RightSpeed.sp5{iTrials} = pertTable.("Right Pert Speed"){iTrials} == -0.15;
%     RightSpeed.sp6{iTrials} = pertTable.("Right Pert Speed"){iTrials} == -0.20;
%     RightSpeed.sp7{iTrials} = pertTable.("Right Pert Speed"){iTrials} == -0.30;
%     RightSpeed.sp8{iTrials} = pertTable.("Right Pert Speed"){iTrials} == -0.40;
% end
% 


%% Get all the subjects values in 1 place and average and std 
% 
% for iTrials = 1:4
%     LeftPerts.sp1{iTrials} = [YAPercep11.Lm{iTrials}(nLS.sp1{iTrials});YAPercep12.Lm{iTrials}(nLS.sp1{iTrials});YAPercep13.Lm{iTrials}(nLS.sp1{iTrials});YAPercep15.Lm{iTrials}(LeftSpeed.sp1{iTrials});];
%     LeftPerts.sp2{iTrials} = [YAPercep11.Lm{iTrials}(nLS.sp2{iTrials});YAPercep12.Lm{iTrials}(nLS.sp2{iTrials});YAPercep13.Lm{iTrials}(nLS.sp2{iTrials});YAPercep15.Lm{iTrials}(LeftSpeed.sp2{iTrials});];
%     LeftPerts.sp3{iTrials} = {YAPercep11.Lm{iTrials}(nLS.sp3{iTrials});YAPercep12.Lm{iTrials}(nLS.sp3{iTrials});YAPercep13.Lm{iTrials}(nLS.sp3{iTrials});YAPercep15.Lm{iTrials}(LeftSpeed.sp3{iTrials});};
%     LeftPerts.sp4{iTrials} = {YAPercep11.Lm{iTrials}(nLS.sp4{iTrials});YAPercep12.Lm{iTrials}(nLS.sp4{iTrials});YAPercep13.Lm{iTrials}(nLS.sp4{iTrials});YAPercep15.Lm{iTrials}(LeftSpeed.sp4{iTrials});};
%     LeftPerts.sp5{iTrials} = {YAPercep11.Lm{iTrials}(nLS.sp5{iTrials});YAPercep12.Lm{iTrials}(nLS.sp5{iTrials});YAPercep13.Lm{iTrials}(nLS.sp5{iTrials});YAPercep15.Lm{iTrials}(LeftSpeed.sp5{iTrials});};
%     LeftPerts.sp6{iTrials} = {YAPercep11.Lm{iTrials}(nLS.sp6{iTrials});YAPercep12.Lm{iTrials}(nLS.sp6{iTrials});YAPercep13.Lm{iTrials}(nLS.sp6{iTrials});YAPercep15.Lm{iTrials}(LeftSpeed.sp6{iTrials});};
%     LeftPerts.sp7{iTrials} = {YAPercep11.Lm{iTrials}(nLS.sp7{iTrials});YAPercep12.Lm{iTrials}(nLS.sp7{iTrials});YAPercep13.Lm{iTrials}(nLS.sp7{iTrials});YAPercep15.Lm{iTrials}(LeftSpeed.sp7{iTrials});};
%     LeftPerts.sp8{iTrials} = {YAPercep11.Lm{iTrials}(nLS.sp8{iTrials});YAPercep12.Lm{iTrials}(nLS.sp8{iTrials});YAPercep13.Lm{iTrials}(nLS.sp8{iTrials});YAPercep15.Lm{iTrials}(LeftSpeed.sp8{iTrials});};
%     
% 
%     RightPerts.sp1{iTrials} = {YAPercep11.Rm{iTrials}(nRS.sp1{iTrials});YAPercep12.Rm{iTrials}(nRS.sp1{iTrials});YAPercep13.Rm{iTrials}(nRS.sp1{iTrials});YAPercep15.Rm{iTrials}(RightSpeed.sp1{iTrials});};
%     RightPerts.sp2{iTrials} = {YAPercep11.Rm{iTrials}(nRS.sp2{iTrials});YAPercep12.Rm{iTrials}(nRS.sp2{iTrials});YAPercep13.Rm{iTrials}(nRS.sp2{iTrials});YAPercep15.Rm{iTrials}(RightSpeed.sp2{iTrials});};
%     RightPerts.sp3{iTrials} = {YAPercep11.Rm{iTrials}(nRS.sp3{iTrials});YAPercep12.Rm{iTrials}(nRS.sp3{iTrials});YAPercep13.Rm{iTrials}(nRS.sp3{iTrials});YAPercep15.Rm{iTrials}(RightSpeed.sp3{iTrials});};
%     RightPerts.sp4{iTrials} = {YAPercep11.Rm{iTrials}(nRS.sp4{iTrials});YAPercep12.Rm{iTrials}(nRS.sp4{iTrials});YAPercep13.Rm{iTrials}(nRS.sp4{iTrials});YAPercep15.Rm{iTrials}(RightSpeed.sp4{iTrials});};
%     RightPerts.sp5{iTrials} = {YAPercep11.Rm{iTrials}(nRS.sp5{iTrials});YAPercep12.Rm{iTrials}(nRS.sp5{iTrials});YAPercep13.Rm{iTrials}(nRS.sp5{iTrials});YAPercep15.Rm{iTrials}(RightSpeed.sp5{iTrials});};
%     RightPerts.sp6{iTrials} = {YAPercep11.Rm{iTrials}(nRS.sp6{iTrials});YAPercep12.Rm{iTrials}(nRS.sp6{iTrials});YAPercep13.Rm{iTrials}(nRS.sp6{iTrials});YAPercep15.Rm{iTrials}(RightSpeed.sp6{iTrials});};
%     RightPerts.sp7{iTrials} = {YAPercep11.Rm{iTrials}(nRS.sp7{iTrials});YAPercep12.Rm{iTrials}(nRS.sp7{iTrials});YAPercep13.Rm{iTrials}(nRS.sp7{iTrials});YAPercep15.Rm{iTrials}(RightSpeed.sp7{iTrials});};
%     RightPerts.sp8{iTrials} = {YAPercep11.Rm{iTrials}(nRS.sp8{iTrials});YAPercep12.Rm{iTrials}(nRS.sp8{iTrials});YAPercep13.Rm{iTrials}(nRS.sp8{iTrials});YAPercep15.Rm{iTrials}(RightSpeed.sp8{iTrials});};
% 
% end
% 
% 
% speeds = {'sp1'; 'sp2'; 'sp3'; 'sp4'; 'sp5'; 'sp6'; 'sp7'; 'sp8';};
% 
% for iTrials = 1:4
%     for iSpeeds = 1:8
%         temp.(speeds{iSpeeds}){iTrials} = cellfun(@isempty, LeftPerts.(speeds{iSpeeds}){iTrials});
%         LeftPerts.(speeds{iSpeeds}){iTrials} = LeftPerts.(speeds{iSpeeds}){iTrials}(temp.(speeds{iSpeeds}){iTrials}==0);
%         temp2.(speeds{iSpeeds}){iTrials} = cellfun(@isempty, RightPerts.(speeds{iSpeeds}){iTrials});
%         RightPerts.(speeds{iSpeeds}){iTrials} = RightPerts.(speeds{iSpeeds}){iTrials}(temp2.(speeds{iSpeeds}){iTrials}==0);        
%     end
% end
% 
% clear temp3 temp4
% for iSpeeds = 1:8
%     temp3 = cellfun(@isempty, LeftPerts.(speeds{iSpeeds}));
%     LeftPerts.(speeds{iSpeeds}) = LeftPerts.(speeds{iSpeeds}){temp3 == 0};
%     temp4 = cellfun(@isempty, RightPerts.(speeds{iSpeeds}));
%     RightPerts.(speeds{iSpeeds}) = RightPerts.(speeds{iSpeeds}){temp4 == 0};
% end
        


count = 1;
while count < 20
    for iTrials = 1:4
        for iSpeeds = 1:8
            if isempty(LeftPerts.(speeds{iSpeeds}){iTrials})
                disp('This is empty')
            else
                for iPerts = 1:length(LeftPerts.(speeds{iSpeeds}){iTrials})
                    for iQuan = 1:length(LeftPerts.(speeds{iSpeeds}){iTrials}{iPerts})
                        LeftPertsA.(speeds{iSpeeds})(count) = [LeftPertsA.(speeds{iSpeeds});LeftPerts.(speeds{iSpeeds}){iTrials}{iPerts}(iQuan)];   
                    end
                end
            end
        end
    end
    count = count +1;
end
        
        
        
        
        



