% figure; subplot(4,1,1); plot(0:(-3172+3281), IKTable.("R Calc Smooth Z"){1,1}(3172:3281))
%% Messing around plotting for subject 11 
load('G:\Shared drives\NeuroMobLab\Projects\Perception\Processed Data\Dan\OpenSim\YAPercep Outputs\YAPercep13\Data Tables\jointAnglesTable_YAPercep13.mat')
load('G:\Shared drives\NeuroMobLab\Projects\Perception\Processed Data\Dan\OpenSim\YAPercep Outputs\YAPercep13\Data Tables\SpatiotemporalTable_YAPercep13.mat')
load('G:\Shared drives\NeuroMobLab\Projects\Perception\Processed Data\Dan\OpenSim\YAPercep Outputs\YAPercep13\Data Tables\IKTable_YAPercep13.mat')
load('G:\Shared drives\NeuroMobLab\Projects\Perception\Processed Data\Dan\Matlab Analysis\YAPercep13\Data Tables\pertCycleStruc_YAPercep13.mat')
load('G:\Shared drives\NeuroMobLab\Projects\Perception\Processed Data\Dan\Matlab Analysis\YAPercep13\Data Tables\pertTable_YAPercep13.mat')
load('G:\Shared drives\NeuroMobLab\Projects\Perception\Processed Data\Dan\Matlab Analysis\YAPercep13\Data Tables\SepTables_YAPercep13.mat')




subjects = {'12';'15';};

for iSubject = 1:size(subjects,1)
    strSubject = subjects{iSubject};
    plotIKResultsNJointAngles(strSubject)
%     pertTable = calcPerturbationParameters(strSubject);
%     pertCycleStruc = calcPertCycleNFrames(strSubject);
end
%%
nameFrames = {'Pre5Frames'; 'Pre4Frames'; 'Pre3Frames'; 'Pre2Frames'; 'Pre1Frames'; 'OnsetFrames'; 'Post1Frames'; 'Post2Frames'; 'Post3Frames'; 'Post4Frames'; 'Post5Frames';};
namePercep = {'Percep01'; 'Percep02'; 'Percep03'; 'Percep04'; 'Percep05'; 'Percep06';};
speeds = {'sp1'; 'sp2'; 'sp3'; 'sp4'; 'sp5'; 'sp6'; 'sp7'; 'sp8';}; % Speeds in order as above 0, -0.02, -0.5, -0.1, -0.15, -0.2, -0.3, -0.4
pertSpeed = {'0'; '-0.02'; '-0.05'; '-0.10'; '-0.15'; '-0.2'; '-0.3'; '-0.4';}; % Perturbation speeds for the table
leg = {'L';'R'}; % Leg

pTrials = contains(pertTable.Trial, 'Percep'); % Finding which rows in the table contain the Perception Trials

pTrials = pTrials(pTrials == 1); %Selecting only the indicies that have Perception trials
colors = {'#00876c'; '#4f9971'; '#7bab79'; '#a3bd86'; '#c9ce98'; '#000000' ; '#e8c48b'; '#e5a76f'; '#e2885b'; '#dd6551'; '#d43d51'}; %'#ede0ae'
% C = colororder(colors);



for iLeg = 1:size(leg,1) % Each leg
    for iSpeeds = 1:size(speeds,1) % The 8 different perturbation speeds as described in speeds
%         figure; 
        for iTrial = 1:size(pTrials,1) % The perturbation trials, ie Percep01-PercepXX
            temp4 = size(pertCycleStruc.(leg{iLeg}).(speeds{iSpeeds}).(namePercep{iTrial}).Perceived,1); % Getting the amount of perturbations sent at a specific speed per Perception trial
            for iPerts = 1:temp4 
                figure;
                for iCycle = 1:size(nameFrames,1) % -5 cycles before Pert, Onset, and +5 cycles after
                    temp1 = pertCycleStruc.(leg{iLeg}).(speeds{iSpeeds}).(namePercep{iTrial}).(nameFrames{iCycle}){1,iPerts}(1); % first heel strike of gait cycle 
                    temp2 = pertCycleStruc.(leg{iLeg}).(speeds{iSpeeds}).(namePercep{iTrial}).(nameFrames{iCycle}){1,iPerts}(5); % ending heel strike of gait cycle
                    temp3 = temp2 - temp1; % Getting length of gait cycle as elasped frames
                    if isnan(temp1) || isnan(temp2) || isnan(temp3)
        
                    else  
                        if iLeg == 1 % When the leg is left
                            subplot(4,1,1); plot(0:temp3, IKTable.("L Calc Smooth Z"){iTrial,1}(temp1:temp2),'color', colors{iCycle}); title(['YAP13 ' leg{iLeg} ' ' pertSpeed{iSpeeds}]);
                            hold on;
                            subplot(4,1,2); plot(0:temp3, jointAnglesTable.("L Ankle Angle (D)"){iTrial,1}(temp1:temp2),'color', colors{iCycle}); title('Left Ankle Angle');
                            hold on;
                            subplot(4,1,3); plot(0:temp3, jointAnglesTable.("L Knee Angle (D)"){iTrial,1}(temp1:temp2),'color', colors{iCycle}); title('Left Knee Angle');
                            hold on;
                            subplot(4,1,4); plot(0:temp3, jointAnglesTable.("L Hip Flexion Angle (D)"){iTrial,1}(temp1:temp2),'color', colors{iCycle}); title('Left Hip Flexion Angle');
                            hold on;
                            legend(nameFrames);
                        else
                            subplot(4,1,1); plot(0:temp3, IKTable.("R Calc Smooth Z"){iTrial,1}(temp1:temp2),'color', colors{iCycle}); title(['YAP13 ' leg{iLeg} ' ' pertSpeed{iSpeeds}]);
                            hold on;
                            subplot(4,1,2); plot(0:temp3, jointAnglesTable.("R Ankle Angle (Degrees)"){iTrial,1}(temp1:temp2),'color', colors{iCycle}); title('Right Ankle Angle');
                            hold on;
                            subplot(4,1,3); plot(0:temp3, jointAnglesTable.("R Knee Angle (D)"){iTrial,1}(temp1:temp2),'color', colors{iCycle}); title('Right Knee Angle');
                            hold on;
                            subplot(4,1,4); plot(0:temp3, jointAnglesTable.("R Hip Flexion Angle (D)"){iTrial,1}(temp1:temp2),'color', colors{iCycle}); title('Right Hip Flexion Angle');
                            hold on;
                            legend(nameFrames);
                        end
                        clear temp1 temp2 temp 3
                    end
                end
            end
        end
    end
end

               %% RAW DATA FIGURES
    f = 1; % to keep track of figure # per trial for saving purposes
    for j=1:nmus       
        if rem(j,8) == 1
            f1 = figure('units','inches','position',[1 1 8.5 11]);
            if ~visiblePlots
                set(gcf,'Visible', 'off')
            end
            k = 1;
        end
            subplot(8,1,k)
            hold on
            plot(time,rawData.analog.emg(:,j))
            yLimits = get(gca,'YLim');
            ylabel('Volts')
            clear RHStemp LHStemp 
            title([subname, ' ', emgNames{j}])            
            ylimits = get(gca,'YLim');            
            if k==8
             xlabel('Time (s)')
            end         
            
            if rem(j,8) == 0 % save figure
                orient landscape
                if k==8 && j==8
                    print(gcf,'-dpsc','-fillpage',[saveLoc filesep trialName '-rawEMG.ps'])
                else
                    print(gcf,'-dpsc','-append','-fillpage',[saveLoc filesep trialName '-rawEMG.ps'])
                end
                savefig(gcf,[saveLoc filesep trialName filesep trialName '-raw' num2str(f)])
                close(gcf)
                f = f+1;
            end            
            k = k+1;                
    end
%%

% colors = {'#00876c'; '#4f9971'; '#7bab79'; '#a3bd86'; '#c9ce98'; '#ede0ae'; '#e8c48b'; '#e5a76f'; '#e2885b'; '#dd6551'; '#d43d51'};
% C = colororder(colors);
% figure;
% for iPerts = 1:size(nameFrames,1)
%     temp1 = pertCycleStruc.R.sp5.Percep03.(nameFrames{iPerts}){1,1}(1);
%     temp2 = pertCycleStruc.R.sp5.Percep03.(nameFrames{iPerts}){1,1}(5);
%     temp3 = temp2 - temp1;    
%     if isnan(temp1) || isnan(temp2) || isnan(temp3)
%         
%     else  
%         if iPerts < 6
%             subplot(4,1,1); plot(0:temp3, IKTable.("R Calc Smooth Z"){3,1}(temp1:temp2));
%             hold on;
%             subplot(4,1,2); plot(0:temp3, jointAnglesTable.("R Ankle Angle (Degrees)"){3,1}(temp1:temp2));
%             hold on;
%             subplot(4,1,3); plot(0:temp3, jointAnglesTable.("R Knee Angle (D)"){3,1}(temp1:temp2));
%             hold on;
%             subplot(4,1,4); plot(0:temp3, jointAnglesTable.("R Hip Flexion Angle (D)"){3,1}(temp1:temp2));
%             hold on;
%         elseif iPerts == 6
%             subplot(4,1,1); plot(0:temp3, IKTable.("R Calc Smooth Z"){3,1}(temp1:temp2));
%             subplot(4,1,2); plot(0:temp3, jointAnglesTable.("R Ankle Angle (Degrees)"){3,1}(temp1:temp2));
%             subplot(4,1,3); plot(0:temp3, jointAnglesTable.("R Knee Angle (D)"){3,1}(temp1:temp2));
%             subplot(4,1,4); plot(0:temp3, jointAnglesTable.("R Hip Flexion Angle (D)"){3,1}(temp1:temp2));
% 
%         else
%             subplot(4,1,1); plot(0:temp3, IKTable.("R Calc Smooth Z"){3,1}(temp1:temp2));
%             subplot(4,1,2); plot(0:temp3, jointAnglesTable.("R Ankle Angle (Degrees)"){3,1}(temp1:temp2));
%             subplot(4,1,3); plot(0:temp3, jointAnglesTable.("R Knee Angle (D)"){3,1}(temp1:temp2));
%             subplot(4,1,4); plot(0:temp3, jointAnglesTable.("R Hip Flexion Angle (D)"){3,1}(temp1:temp2));
%         end
%     end
%     clear temp1 temp2 temp 3
% end
% 
% 
% % figure;
% for iPerts = 1:size(nameFrames,1)
%     temp1 = pertCycleStruc.R.sp5.Percep03.(nameFrames{iPerts}){1,1}(1);
%     temp2 = pertCycleStruc.R.sp5.Percep03.(nameFrames{iPerts}){1,1}(5);
%     temp3 = temp2 - temp1;
%     if isnan(temp1) || isnan(temp2) || isnan(temp3)
%         
%     else  
%         if iPerts < 6
%             subplot(4,1,1); plot(0:temp3, IKTable.("R Calc Smooth Z"){3,1}(temp1:temp2), 'b');
%             hold on;
%             subplot(4,1,2); plot(0:temp3, jointAnglesTable.("R Ankle Angle (Degrees)"){3,1}(temp1:temp2), 'b');
%             hold on;
%             subplot(4,1,3); plot(0:temp3, jointAnglesTable.("R Knee Angle (D)"){3,1}(temp1:temp2), 'b');
%             hold on;
%             subplot(4,1,4); plot(0:temp3, jointAnglesTable.("R Hip Flexion Angle (D)"){3,1}(temp1:temp2), 'b');
%             hold on;
%         elseif iPerts == 6
%             subplot(4,1,1); plot(0:temp3, IKTable.("R Calc Smooth Z"){3,1}(temp1:temp2), 'k');
%             subplot(4,1,2); plot(0:temp3, jointAnglesTable.("R Ankle Angle (Degrees)"){3,1}(temp1:temp2), 'k');
%             subplot(4,1,3); plot(0:temp3, jointAnglesTable.("R Knee Angle (D)"){3,1}(temp1:temp2), 'k');
%             subplot(4,1,4); plot(0:temp3, jointAnglesTable.("R Hip Flexion Angle (D)"){3,1}(temp1:temp2), 'k');
% 
%         else
%             subplot(4,1,1); plot(0:temp3, IKTable.("R Calc Smooth Z"){3,1}(temp1:temp2), 'r');
%             subplot(4,1,2); plot(0:temp3, jointAnglesTable.("R Ankle Angle (Degrees)"){3,1}(temp1:temp2), 'r');
%             subplot(4,1,3); plot(0:temp3, jointAnglesTable.("R Knee Angle (D)"){3,1}(temp1:temp2), 'r');
%             subplot(4,1,4); plot(0:temp3, jointAnglesTable.("R Hip Flexion Angle (D)"){3,1}(temp1:temp2), 'r');
%         end
%     end
%     clear temp1 temp2 temp 3
% end
% 
% % figure;
% for iPerts = 1:size(nameFrames,1)
%     temp1 = pertCycleStruc.R.sp5.Percep03.(nameFrames{iPerts}){1,2}(1);
%     temp2 = pertCycleStruc.R.sp5.Percep03.(nameFrames{iPerts}){1,2}(5);
%     temp3 = temp2 - temp1;
%     if isnan(temp1) || isnan(temp2) || isnan(temp3)
%         
%     else  
%         if iPerts < 6
%             subplot(4,1,1); plot(0:temp3, IKTable.("R Calc Smooth Z"){3,1}(temp1:temp2), 'b');
%             hold on;
%             subplot(4,1,2); plot(0:temp3, jointAnglesTable.("R Ankle Angle (Degrees)"){3,1}(temp1:temp2), 'b');
%             hold on;
%             subplot(4,1,3); plot(0:temp3, jointAnglesTable.("R Knee Angle (D)"){3,1}(temp1:temp2), 'b');
%             hold on;
%             subplot(4,1,4); plot(0:temp3, jointAnglesTable.("R Hip Flexion Angle (D)"){3,1}(temp1:temp2), 'b');
%             hold on;
%         elseif iPerts == 6
%             subplot(4,1,1); plot(0:temp3, IKTable.("R Calc Smooth Z"){3,1}(temp1:temp2), 'k');
%             subplot(4,1,2); plot(0:temp3, jointAnglesTable.("R Ankle Angle (Degrees)"){3,1}(temp1:temp2), 'k');
%             subplot(4,1,3); plot(0:temp3, jointAnglesTable.("R Knee Angle (D)"){3,1}(temp1:temp2), 'k');
%             subplot(4,1,4); plot(0:temp3, jointAnglesTable.("R Hip Flexion Angle (D)"){3,1}(temp1:temp2), 'k');
% 
%         else
%             subplot(4,1,1); plot(0:temp3, IKTable.("R Calc Smooth Z"){3,1}(temp1:temp2), 'r');
%             subplot(4,1,2); plot(0:temp3, jointAnglesTable.("R Ankle Angle (Degrees)"){3,1}(temp1:temp2), 'r');
%             subplot(4,1,3); plot(0:temp3, jointAnglesTable.("R Knee Angle (D)"){3,1}(temp1:temp2), 'r');
%             subplot(4,1,4); plot(0:temp3, jointAnglesTable.("R Hip Flexion Angle (D)"){3,1}(temp1:temp2), 'r');
%         end
%     end
%     clear temp1 temp2 temp 3
% end
% 
% 
% % figure;
% for iPerts = 1:size(nameFrames,1)
%     temp1 = pertCycleStruc.R.sp5.Percep04.(nameFrames{iPerts}){1,1}(1);
%     temp2 = pertCycleStruc.R.sp5.Percep04.(nameFrames{iPerts}){1,1}(5);
%     temp3 = temp2 - temp1;
%     if isnan(temp1) || isnan(temp2) || isnan(temp3)
%         
%     else    
%         if iPerts < 6
%             subplot(4,1,1); plot(0:temp3, IKTable.("R Calc Smooth Z"){4,1}(temp1:temp2), 'b');
%             hold on;
%             subplot(4,1,2); plot(0:temp3, jointAnglesTable.("R Ankle Angle (Degrees)"){4,1}(temp1:temp2), 'b');
%             hold on;
%             subplot(4,1,3); plot(0:temp3, jointAnglesTable.("R Knee Angle (D)"){4,1}(temp1:temp2), 'b');
%             hold on;
%             subplot(4,1,4); plot(0:temp3, jointAnglesTable.("R Hip Flexion Angle (D)"){4,1}(temp1:temp2), 'b');
%             hold on;
%         elseif iPerts == 6
%             subplot(4,1,1); plot(0:temp3, IKTable.("R Calc Smooth Z"){4,1}(temp1:temp2), 'k');
%             subplot(4,1,2); plot(0:temp3, jointAnglesTable.("R Ankle Angle (Degrees)"){4,1}(temp1:temp2), 'k');
%             subplot(4,1,3); plot(0:temp3, jointAnglesTable.("R Knee Angle (D)"){4,1}(temp1:temp2), 'k');
%             subplot(4,1,4); plot(0:temp3, jointAnglesTable.("R Hip Flexion Angle (D)"){4,1}(temp1:temp2), 'k');
% 
%         else
%             subplot(4,1,1); plot(0:temp3, IKTable.("R Calc Smooth Z"){4,1}(temp1:temp2), 'r');
%             subplot(4,1,2); plot(0:temp3, jointAnglesTable.("R Ankle Angle (Degrees)"){4,1}(temp1:temp2), 'r');
%             subplot(4,1,3); plot(0:temp3, jointAnglesTable.("R Knee Angle (D)"){4,1}(temp1:temp2), 'r');
%             subplot(4,1,4); plot(0:temp3, jointAnglesTable.("R Hip Flexion Angle (D)"){4,1}(temp1:temp2), 'r');
%         end
%     end
%     clear temp1 temp2 temp 3
% end
% 
% % figure;
% for iPerts = 1:size(nameFrames,1)
%     temp1 = pertCycleStruc.R.sp5.Percep04.(nameFrames{iPerts}){1,2}(1);
%     temp2 = pertCycleStruc.R.sp5.Percep04.(nameFrames{iPerts}){1,2}(5);
%     temp3 = temp2 - temp1;
%     if isnan(temp1) || isnan(temp2) || isnan(temp3)
%         
%     else    
%         if iPerts < 6
%             subplot(4,1,1); plot(0:temp3, IKTable.("R Calc Smooth Z"){4,1}(temp1:temp2), 'b');
%             hold on;
%             subplot(4,1,2); plot(0:temp3, jointAnglesTable.("R Ankle Angle (Degrees)"){4,1}(temp1:temp2), 'b');
%             hold on;
%             subplot(4,1,3); plot(0:temp3, jointAnglesTable.("R Knee Angle (D)"){4,1}(temp1:temp2), 'b');
%             hold on;
%             subplot(4,1,4); plot(0:temp3, jointAnglesTable.("R Hip Flexion Angle (D)"){4,1}(temp1:temp2), 'b');
%             hold on;
%         elseif iPerts == 6
%             subplot(4,1,1); plot(0:temp3, IKTable.("R Calc Smooth Z"){4,1}(temp1:temp2), 'k');
%             subplot(4,1,2); plot(0:temp3, jointAnglesTable.("R Ankle Angle (Degrees)"){4,1}(temp1:temp2), 'k');
%             subplot(4,1,3); plot(0:temp3, jointAnglesTable.("R Knee Angle (D)"){4,1}(temp1:temp2), 'k');
%             subplot(4,1,4); plot(0:temp3, jointAnglesTable.("R Hip Flexion Angle (D)"){4,1}(temp1:temp2), 'k');
% 
%         else
%             subplot(4,1,1); plot(0:temp3, IKTable.("R Calc Smooth Z"){4,1}(temp1:temp2), 'r');
%             subplot(4,1,2); plot(0:temp3, jointAnglesTable.("R Ankle Angle (Degrees)"){4,1}(temp1:temp2), 'r');
%             subplot(4,1,3); plot(0:temp3, jointAnglesTable.("R Knee Angle (D)"){4,1}(temp1:temp2), 'r');
%             subplot(4,1,4); plot(0:temp3, jointAnglesTable.("R Hip Flexion Angle (D)"){4,1}(temp1:temp2), 'r');
%         end
%     end
%     clear temp1 temp2 temp 3
% end