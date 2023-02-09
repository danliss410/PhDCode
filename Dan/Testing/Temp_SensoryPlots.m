for iLeg = 1:size(leg,1) % Each leg
    for iSpeeds = 1:size(speeds,1) % The 8 different perturbation speeds as described in speeds
        for iTrial = 1:size(pTrials,1) % The perturbation trials, ie Percep01-PercepXX
            temp4 = size(pertCycleStruc.(leg{iLeg}).(speeds{iSpeeds}).(namePercep{iTrial}).Perceived,1); % Getting the amount of perturbations sent at a specific speed per Perception trial
            for iPerts = 1:temp4 % -5 cycles before Pert, Onset, and +5 cycles after
                h2 = figure('Name', ['Sensory ' subject1 ' ' leg{iLeg} ' ' namePert{iSpeeds} ' ' namePercep{iTrial} ' ' num2str(iPerts)], 'NumberTitle', 'off');
                filename2 = ['Sesnsory_' subject1 '_' leg{iLeg} '_' namePert{iSpeeds} '_' namePercep{iTrial} '_' num2str(iPerts)];
                filenamePDF2 = strcat(filename2, '.pdf');
                for iCycle = 1:size(nameFrames,1)
                    temp1 = pertCycleStruc.(leg{iLeg}).(speeds{iSpeeds}).(namePercep{iTrial}).(nameFrames{iCycle}){1,iPerts}(1); % first heel strike of gait cycle 
                    temp2 = pertCycleStruc.(leg{iLeg}).(speeds{iSpeeds}).(namePercep{iTrial}).(nameFrames{iCycle}){1,iPerts}(5); % ending heel strike of gait cycle
                    temp4 = pertCycleStruc.(leg{iLeg}).(speeds{iSpeeds}).(namePercep{iTrial}).(nameFrames{iCycle}){1,iPerts}(4); % Toe off for the leg of the first heel strike of the gait cycle 
                    temp3 = temp2 - temp1; % Getting length of gait cycle as elasped frames
                    
                    temp5 = temp1 * 10; 
                    temp6 = temp4 * 10;
                    temp7 = temp6-temp5;
                    if isnan(temp1) || isnan(temp2) || isnan(temp3)
        
                    else  
                        if iLeg == 1 % When the leg is left
                            perceived = pertCycleStruc.(leg{iLeg}).(speeds{iSpeeds}).(namePercep{iTrial}).Perceived(iPerts);
                            if perceived == 1
                                namePerceived = 'Perceived';
                            else
                                namePerceived = 'Not Perceived';
                            end
                            subplot(5,2,[1 2]); plot((0:temp3)/temp3, IKTable.("L Calc Smooth Z"){iTrial,1}(temp1:temp2),'color', colors{iCycle}); title(['YAP' strSubject ' ' leg{iLeg} ' ' pertSpeed{iSpeeds} ' ' namePerceived]); % Plotting the cycle for Left Calc Velocity - SSWS
                            hold on;
                            subplot(5,2,3); plot((0:temp3)/temp3, jointAnglesTable.("L Ankle Angle (D)"){iTrial,1}(temp1:temp2),'color', colors{iCycle}); title('Left Ankle Angle'); % Plotting the cycle for the Left ankle angle 
                            hold on;
                            subplot(5,2,5); plot((0:temp3)/temp3, jointAnglesTable.("L Knee Angle (D)"){iTrial,1}(temp1:temp2),'color', colors{iCycle}); title('Left Knee Angle'); %Plotting the cycle for the left knee angle 
                            hold on;
                            subplot(5,2,7); plot((0:temp3)/temp3, jointAnglesTable.("L Hip Flexion Angle (D)"){iTrial,1}(temp1:temp2),'color', colors{iCycle}); title('Left Hip Flexion Angle'); % Plotting the cycle for the left hip flexion angle
                            hold on;
                            legend(nameFrames);
                            subplot(5,2,4); plot((0:temp3)/temp3, headCalcStruc.(namePercep{iTrial}).headAngle(temp1:temp2,1), 'color', colors{iCycle}); title('Head Angle (degree)'); %Plotting the cycle for the head angle deviation 
                            hold on; 
                            subplot(5,2,6); plot((0:temp3)/temp3, headCalcStruc.(namePercep{iTrial}).headAngle(temp1:temp2,1), 'color', colors{iCycle}); title('Head Angular Velocity (degree/s)'); % Plotting the cycle for head angular velocity deviation
                            hold on; 
                            subplot(5,2,8); plot((0:temp7)/temp7, analogTable.COP{iTrial,1}(temp5:temp6,1), 'color', colors{iCycle}); title('X CoP'); % Plotting the X direction CoP for the cycle
                            hold on;
                            subplot(5,2,10); plot((0:temp7)/temp7, analogTable.COP{iTrial,1}(temp5:temp6,2), 'color', colors{iCycle}); title('Y CoP'); % Plotting the Y direction CoP for the cycle
                            hold on;
                        else
                        perceived = pertCycleStruc.(leg{iLeg}).(speeds{iSpeeds}).(namePercep{iTrial}).Perceived(iPerts);
                            if perceived == 1
                                namePerceived = 'Perceived';
                            else
                                namePerceived = 'Not Perceived';
                            end
                            subplot(4,1,1); plot((0:temp3)/temp3, IKTable.("R Calc Smooth Z"){iTrial,1}(temp1:temp2),'color', colors{iCycle}); title(['YAP' strSubject ' ' leg{iLeg} ' ' pertSpeed{iSpeeds} ' ' namePerceived]); % Plotting the cycle for Right Calc Velocity - SSWS
                            hold on;
                            subplot(4,1,2); plot((0:temp3)/temp3, jointAnglesTable.("R Ankle Angle (Degrees)"){iTrial,1}(temp1:temp2),'color', colors{iCycle}); title('Right Ankle Angle'); % Plotting the cycle for the right ankle angle 
                            hold on;
                            subplot(4,1,3); plot((0:temp3)/temp3, jointAnglesTable.("R Knee Angle (D)"){iTrial,1}(temp1:temp2),'color', colors{iCycle}); title('Right Knee Angle'); % Plotting the cycle for the right knee angle
                            hold on;
                            subplot(4,1,4); plot((0:temp3)/temp3, jointAnglesTable.("R Hip Flexion Angle (D)"){iTrial,1}(temp1:temp2),'color', colors{iCycle}); title('Right Hip Flexion Angle'); % Plotting the cycle for the right hip flexion angle
                            hold on;
                            legend(nameFrames);
                            subplot(5,2,4); plot((0:temp3)/temp3, headCalcStruc.(namePercep{iTrial}).headAngle(temp1:temp2,1), 'color', colors{iCycle}); title('Head Angle (degree)'); %Plotting the cycle for the head angle deviation 
                            hold on; 
                            subplot(5,2,6); plot((0:temp3)/temp3, headCalcStruc.(namePercep{iTrial}).headAngle(temp1:temp2,1), 'color', colors{iCycle}); title('Head Angular Velocity (degree/s)'); % Plotting the cycle for head angular velocity deviation
                            hold on; 
                            subplot(5,2,8); plot((0:temp7)/temp7, analogTable.COP{iTrial,1}(temp5:temp6,4), 'color', colors{iCycle}); title('X CoP'); % Plotting the X direction CoP for the cycle
                            hold on;
                            subplot(5,2,10); plot((0:temp7)/temp7, analogTable.COP{iTrial,1}(temp5:temp6,5), 'color', colors{iCycle}); title('Y CoP'); % Plotting the Y direction CoP for the cycle
                            hold on;
                        end
                        clear temp1 temp2 temp 3 perceived namePerceived
                    end
                end
                saveas(h2, filename2);
                print(filenamePDF2, '-dpdf', '-bestfit');
                close(h2)
            end
        end
    end
end