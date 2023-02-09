%% Temp EMG Stance Plots 

% Need to plot YAPercep11, YAPercep13, YAPercep15
% Will be plotting all EMGs AUCs during stance

% Need to calculate the average between perceived and not perceived
% perturbations from each level 

%% This section creates plots from -5 cycles before perturbation, Onset, +5 cycles after perturbation
nameFrames = {'Pre5Frames'; 'Pre4Frames'; 'Pre3Frames'; 'Pre2Frames'; 'Pre1Frames'; 'OnsetFrames';};% 'Post1Frames'; 'Post2Frames'; 'Post3Frames'; 'Post4Frames'; 'Post5Frames';}; % -5 cycles before perturbation, Onset, and +5 cycles after perturbation
namePercep = {'Percep01'; 'Percep02'; 'Percep03'; 'Percep04'; 'Percep05'; 'Percep06';}; % name of the potential perception trials for each subject 
speeds = 'sp4'; % Speeds in order as above 0, -0.02, -0.5, -0.1, -0.15, -0.2, -0.3, -0.4
pertSpeed = {'0'; '-0.02'; '-0.05'; '-0.10'; '-0.15'; '-0.2'; '-0.3'; '-0.4';}; % Perturbation speeds for the table
namePert = {'Catch'; 'Neg02'; 'Neg05'; 'Neg10'; 'Neg15'; 'Neg20'; 'Neg30'; 'Neg40';}; %Name of the perts to save the files
leg = 'R'; % Leg
emgid = {'EMG_TA-R';'EMG_LGAS-R';'EMG_VLAT-R';'EMG_RFEM-R';'EMG_BFLH-R';'EMG_ADD-R';'EMG_TFL-R';'EMG_GMED-R';'EMG_TA-L';'EMG_LGAS-L';'EMG_VLAT-L';'EMG_RFEM-L';'EMG_BFLH-L';'EMG_ADD-L';'EMG_TFL-L';'EMG_GMED-L';'EMG_SOL-R';'EMG_PERO-R';'EMG_MGAS-R';'EMG_GMAX-R';'EMG_SOL-L';'EMG_PERO-L';'EMG_MGAS-L';'EMG_GMAX-L';'25';'26';'27';'28';'29';'30';'31';'32'};
B = contains(emgid, '-R'); % Have to do this line because we have extra emg slots 25-32
emgR = emgid(B);
emgRidx = find(B);

pertCount = {'one'; 'two'; 'three'; 'four'; 'five';};
for iEmg = 1:length(emgR) 
    nEmgR2 = strrep(emgR{iEmg}, '-R', '');
    nEmgR = strrep(nEmgR2, 'EMG_', '');
    figure; subplot(8,2,1); b.b1 = bar(tempSub(1:5,3+iEmg), 'FaceColor', 'Flat'); title(['ES ' nEmgR]); 
    subplot(8,2,2); b.b2 = bar(tempSub(6:10,3+iEmg), 'FaceColor', 'Flat');
    subplot(8,2,3); b.b3 = bar(tempSub(11:15,3+iEmg), 'FaceColor', 'Flat'); 
    subplot(8,2,4); b.b4 = bar(tempSub(16:20,3+iEmg), 'FaceColor', 'Flat');
    subplot(8,2,5); b.b5 = bar(tempSub(21:25,3+iEmg), 'FaceColor', 'Flat'); 
    subplot(8,2,6); b.b6 = bar(tempSub(26:30,3+iEmg), 'FaceColor', 'Flat');
    subplot(8,2,7); b.b7 = bar(tempSub(31:35,3+iEmg), 'FaceColor', 'Flat'); 
    subplot(8,2,8); b.b8 = bar(tempSub(36:40,3+iEmg), 'FaceColor', 'Flat');
    subplot(8,2,9); b.b9 = bar(tempSub(41:45,3+iEmg), 'FaceColor', 'Flat'); 
    subplot(8,2,10); b.b10 = bar(tempSub(46:50,3+iEmg), 'FaceColor', 'Flat');
    subplot(8,2,11); b.b11 = bar(tempSub(51:55,3+iEmg), 'FaceColor', 'Flat'); 
    subplot(8,2,12); b.b12 = bar(tempSub(56:60,3+iEmg), 'FaceColor', 'Flat');
    subplot(8,2,13); b.b13 = bar(tempSub(61:65,3+iEmg), 'FaceColor', 'Flat'); 
    subplot(8,2,14); b.b14 = bar(tempSub(66:70,3+iEmg), 'FaceColor', 'Flat');
    subplot(8,2,15); b.b15 = bar(tempSub(71:75,3+iEmg), 'FaceColor', 'Flat'); 
    subplot(8,2,16); b.b16 = bar(tempSub(76:80,3+iEmg), 'FaceColor', 'Flat');
    for iSubject = 1:8
        subidx = {{1,5;6,10},{11,15;16,20}, {21,25; 26,30}, {31,35; 36,40}, {41,45; 46,50}, {51,55; 56,60}, {61,65; 66,70}, {71,75; 76,80}};
        subFig = {{'b1';'b2'}, {'b3'; 'b4'}, {'b5'; 'b6'}, {'b7'; 'b8'}, {'b9'; 'b10'}, {'b11'; 'b12'}, {'b13'; 'b14'}, {'b15'; 'b16'}};
        if iSubject == 1
                pPert = tempSub(subidx{1,iSubject}{1,1}:subidx{1,iSubject}{1,2},3) == 1;
                if sum(pPert) > 1 
                    pTemp = find(pPert == 1);
                    for iPert = 1:length(pTemp)
                         b.(subFig{1,iSubject}{1,1}).CData(pTemp(iPert),:) = [1 0 0];
                    end
                else
                    b.(subFig{1,iSubject}{1,1}).CData(pPert,:) = [1 0 0];
                end
                pPert2 = tempSub(subidx{1,iSubject}{2,1}:subidx{1,iSubject}{2,2},3) == 1;
                if sum(pPert2) > 1 
                    pTemp2 = find(pPert2 == 1);
                    for iPert2 = 1:length(pTemp2)
                        b.(subFig{1,iSubject}{2,1}).CData(pTemp2(iPert2),:) = [1 0 0];
                    end
                else
                    b.(subFig{1,iSubject}{2,1}).CData(pPert,:) = [1 0 0];
                end

                clear pPert pPert2 iPert iPert2
            elseif iSubject == 2
                pPert = tempSub(subidx{1,iSubject}{1,1}:subidx{1,iSubject}{1,2},3) == 1;
                if sum(pPert) > 1 
                    pTemp = find(pPert == 1);
                    for iPert = 1:length(pTemp)
                         b.(subFig{1,iSubject}{1,1}).CData(pTemp(iPert),:) = [1 0 0];
                    end
                else
                    b.(subFig{1,iSubject}{1,1}).CData(pPert,:) = [1 0 0];
                end
                pPert2 = tempSub(subidx{1,iSubject}{2,1}:subidx{1,iSubject}{2,2},3) == 1;
                if sum(pPert2) > 1 
                    pTemp2 = find(pPert2 == 1);
                    for iPert2 = 1:length(pTemp2)
                        b.(subFig{1,iSubject}{2,1}).CData(pTemp2(iPert2),:) = [1 0 0];
                    end
                else
                    b.(subFig{1,iSubject}{2,1}).CData(pPert,:) = [1 0 0];
                end

                clear pPert pPert2 iPert iPert2
            elseif iSubject == 3 
                pPert = tempSub(subidx{1,iSubject}{1,1}:subidx{1,iSubject}{1,2},3) == 1;
                if sum(pPert) > 1 
                    pTemp = find(pPert == 1);
                    for iPert = 1:length(pTemp)
                         b.(subFig{1,iSubject}{1,1}).CData(pTemp(iPert),:) = [1 0 0];
                    end
                else
                    b.(subFig{1,iSubject}{1,1}).CData(pPert,:) = [1 0 0];
                end
                pPert2 = tempSub(subidx{1,iSubject}{2,1}:subidx{1,iSubject}{2,2},3) == 1;
                if sum(pPert2) > 1 
                    pTemp2 = find(pPert2 == 1);
                    for iPert2 = 1:length(pTemp2)
                        b.(subFig{1,iSubject}{2,1}).CData(pTemp2(iPert2),:) = [1 0 0];
                    end
                else
                    b.(subFig{1,iSubject}{2,1}).CData(pPert,:) = [1 0 0];
                end

                clear pPert pPert2 iPert iPert2     
            elseif iSubject == 4 
                pPert = tempSub(subidx{1,iSubject}{1,1}:subidx{1,iSubject}{1,2},3) == 1;
                if sum(pPert) > 1 
                    pTemp = find(pPert == 1);
                    for iPert = 1:length(pTemp)
                         b.(subFig{1,iSubject}{1,1}).CData(pTemp(iPert),:) = [1 0 0];
                    end
                else
                    b.(subFig{1,iSubject}{1,1}).CData(pPert,:) = [1 0 0];
                end
                pPert2 = tempSub(subidx{1,iSubject}{2,1}:subidx{1,iSubject}{2,2},3) == 1;
                if sum(pPert2) > 1 
                    pTemp2 = find(pPert2 == 1);
                    for iPert2 = 1:length(pTemp2)
                        b.(subFig{1,iSubject}{2,1}).CData(pTemp2(iPert2),:) = [1 0 0];
                    end
                else
                    b.(subFig{1,iSubject}{2,1}).CData(pPert,:) = [1 0 0];
                end

                clear pPert pPert2 iPert iPert2
            elseif iSubject == 5 
                pPert = tempSub(subidx{1,iSubject}{1,1}:subidx{1,iSubject}{1,2},3) == 1;
                if sum(pPert) > 1 
                    pTemp = find(pPert == 1);
                    for iPert = 1:length(pTemp)
                         b.(subFig{1,iSubject}{1,1}).CData(pTemp(iPert),:) = [1 0 0];
                    end
                else
                    b.(subFig{1,iSubject}{1,1}).CData(pPert,:) = [1 0 0];
                end
                pPert2 = tempSub(subidx{1,iSubject}{2,1}:subidx{1,iSubject}{2,2},3) == 1;
                if sum(pPert2) > 1 
                    pTemp2 = find(pPert2 == 1);
                    for iPert2 = 1:length(pTemp2)
                        b.(subFig{1,iSubject}{2,1}).CData(pTemp2(iPert2),:) = [1 0 0];
                    end
                else
                    b.(subFig{1,iSubject}{2,1}).CData(pPert,:) = [1 0 0];
                end

                clear pPert pPert2 iPert iPert2
            elseif iSubject == 6 
                pPert = tempSub(subidx{1,iSubject}{1,1}:subidx{1,iSubject}{1,2},3) == 1;
                if sum(pPert) > 1 
                    pTemp = find(pPert == 1);
                    for iPert = 1:length(pTemp)
                         b.(subFig{1,iSubject}{1,1}).CData(pTemp(iPert),:) = [1 0 0];
                    end
                else
                    b.(subFig{1,iSubject}{1,1}).CData(pPert,:) = [1 0 0];
                end
                pPert2 = tempSub(subidx{1,iSubject}{2,1}:subidx{1,iSubject}{2,2},3) == 1;
                if sum(pPert2) > 1 
                    pTemp2 = find(pPert2 == 1);
                    for iPert2 = 1:length(pTemp2)
                        b.(subFig{1,iSubject}{2,1}).CData(pTemp2(iPert2),:) = [1 0 0];
                    end
                else
                    b.(subFig{1,iSubject}{2,1}).CData(pPert,:) = [1 0 0];
                end

                clear pPert pPert2 iPert iPert2
            elseif iSubject == 7 
                pPert = tempSub(subidx{1,iSubject}{1,1}:subidx{1,iSubject}{1,2},3) == 1;
                if sum(pPert) > 1 
                    pTemp = find(pPert == 1);
                    for iPert = 1:length(pTemp)
                         b.(subFig{1,iSubject}{1,1}).CData(pTemp(iPert),:) = [1 0 0];
                    end
                else
                    b.(subFig{1,iSubject}{1,1}).CData(pPert,:) = [1 0 0];
                end
                pPert2 = tempSub(subidx{1,iSubject}{2,1}:subidx{1,iSubject}{2,2},3) == 1;
                if sum(pPert2) > 1 
                    pTemp2 = find(pPert2 == 1);
                    for iPert2 = 1:length(pTemp2)
                        b.(subFig{1,iSubject}{2,1}).CData(pTemp2(iPert2),:) = [1 0 0];
                    end
                else
                    b.(subFig{1,iSubject}{2,1}).CData(pPert,:) = [1 0 0];
                end

                clear pPert pPert2 iPert iPert2
            else
                pPert = tempSub(subidx{1,iSubject}{1,1}:subidx{1,iSubject}{1,2},3) == 1;
                if sum(pPert) > 1 
                    pTemp = find(pPert == 1);
                    for iPert = 1:length(pTemp)
                         b.(subFig{1,iSubject}{1,1}).CData(pTemp(iPert),:) = [1 0 0];
                    end
                else
                    b.(subFig{1,iSubject}{1,1}).CData(pPert,:) = [1 0 0];
                end
                pPert2 = tempSub(subidx{1,iSubject}{2,1}:subidx{1,iSubject}{2,2},3) == 1;
                if sum(pPert2) > 1 
                    pTemp2 = find(pPert2 == 1);
                    for iPert2 = 1:length(pTemp2)
                        b.(subFig{1,iSubject}{2,1}).CData(pTemp2(iPert2),:) = [1 0 0];
                    end
                else
                    b.(subFig{1,iSubject}{2,1}).CData(pPert,:) = [1 0 0];
                end

                clear pPert pPert2 iPert iPert2
        end

    end
end

            
            
            
%% This section will plot percent change 
%% This section creates plots from -5 cycles before perturbation, Onset, +5 cycles after perturbation
nameFrames = {'Pre5Frames'; 'Pre4Frames'; 'Pre3Frames'; 'Pre2Frames'; 'Pre1Frames'; 'OnsetFrames';};% 'Post1Frames'; 'Post2Frames'; 'Post3Frames'; 'Post4Frames'; 'Post5Frames';}; % -5 cycles before perturbation, Onset, and +5 cycles after perturbation
namePercep = {'Percep01'; 'Percep02'; 'Percep03'; 'Percep04'; 'Percep05'; 'Percep06';}; % name of the potential perception trials for each subject 
speeds = 'sp4'; % Speeds in order as above 0, -0.02, -0.5, -0.1, -0.15, -0.2, -0.3, -0.4
pertSpeed = {'0'; '-0.02'; '-0.05'; '-0.10'; '-0.15'; '-0.2'; '-0.3'; '-0.4';}; % Perturbation speeds for the table
namePert = {'Catch'; 'Neg02'; 'Neg05'; 'Neg10'; 'Neg15'; 'Neg20'; 'Neg30'; 'Neg40';}; %Name of the perts to save the files
leg = 'R'; % Leg
emgid = {'EMG_TA-R';'EMG_LGAS-R';'EMG_VLAT-R';'EMG_RFEM-R';'EMG_BFLH-R';'EMG_ADD-R';'EMG_TFL-R';'EMG_GMED-R';'EMG_TA-L';'EMG_LGAS-L';'EMG_VLAT-L';'EMG_RFEM-L';'EMG_BFLH-L';'EMG_ADD-L';'EMG_TFL-L';'EMG_GMED-L';'EMG_SOL-R';'EMG_PERO-R';'EMG_MGAS-R';'EMG_GMAX-R';'EMG_SOL-L';'EMG_PERO-L';'EMG_MGAS-L';'EMG_GMAX-L';'25';'26';'27';'28';'29';'30';'31';'32'};
B = contains(emgid, '-R'); % Have to do this line because we have extra emg slots 25-32
emgR = emgid(B);
emgRidx = find(B);

pertCount = {'one'; 'two'; 'three'; 'four'; 'five';};
for iEmg = 1:length(emgR) 
    nEmgR2 = strrep(emgR{iEmg}, '-R', '');
    nEmgR = strrep(nEmgR2, 'EMG_', '');
    figure; subplot(8,2,1); b.b1 = bar(tempSub3(1:5,3+iEmg), 'FaceColor', 'Flat'); title(['PC ' nEmgR]); 
    subplot(8,2,2); b.b2 = bar(tempSub3(6:10,3+iEmg), 'FaceColor', 'Flat');
    subplot(8,2,3); b.b3 = bar(tempSub3(11:15,3+iEmg), 'FaceColor', 'Flat'); 
    subplot(8,2,4); b.b4 = bar(tempSub3(16:20,3+iEmg), 'FaceColor', 'Flat');
    subplot(8,2,5); b.b5 = bar(tempSub3(21:25,3+iEmg), 'FaceColor', 'Flat'); 
    subplot(8,2,6); b.b6 = bar(tempSub3(26:30,3+iEmg), 'FaceColor', 'Flat');
    subplot(8,2,7); b.b7 = bar(tempSub3(31:35,3+iEmg), 'FaceColor', 'Flat'); 
    subplot(8,2,8); b.b8 = bar(tempSub3(36:40,3+iEmg), 'FaceColor', 'Flat');
    subplot(8,2,9); b.b9 = bar(tempSub3(41:45,3+iEmg), 'FaceColor', 'Flat'); 
    subplot(8,2,10); b.b10 = bar(tempSub3(46:50,3+iEmg), 'FaceColor', 'Flat');
    subplot(8,2,11); b.b11 = bar(tempSub3(51:55,3+iEmg), 'FaceColor', 'Flat'); 
    subplot(8,2,12); b.b12 = bar(tempSub3(56:60,3+iEmg), 'FaceColor', 'Flat');
    subplot(8,2,13); b.b13 = bar(tempSub3(61:65,3+iEmg), 'FaceColor', 'Flat'); 
    subplot(8,2,14); b.b14 = bar(tempSub3(66:70,3+iEmg), 'FaceColor', 'Flat');
    subplot(8,2,15); b.b15 = bar(tempSub3(71:75,3+iEmg), 'FaceColor', 'Flat'); 
    subplot(8,2,16); b.b16 = bar(tempSub3(76:80,3+iEmg), 'FaceColor', 'Flat');
    for iSubject = 1:8
        subidx = {{1,5;6,10},{11,15;16,20}, {21,25; 26,30}, {31,35; 36,40}, {41,45; 46,50}, {51,55; 56,60}, {61,65; 66,70}, {71,75; 76,80}};
        subFig = {{'b1';'b2'}, {'b3'; 'b4'}, {'b5'; 'b6'}, {'b7'; 'b8'}, {'b9'; 'b10'}, {'b11'; 'b12'}, {'b13'; 'b14'}, {'b15'; 'b16'}};
        if iSubject == 1
                pPert = tempSub(subidx{1,iSubject}{1,1}:subidx{1,iSubject}{1,2},3) == 1;
                if sum(pPert) > 1 
                    pTemp = find(pPert == 1);
                    for iPert = 1:length(pTemp)
                         b.(subFig{1,iSubject}{1,1}).CData(pTemp(iPert),:) = [1 0 0];
                    end
                else
                    b.(subFig{1,iSubject}{1,1}).CData(pPert,:) = [1 0 0];
                end
                pPert2 = tempSub(subidx{1,iSubject}{2,1}:subidx{1,iSubject}{2,2},3) == 1;
                if sum(pPert2) > 1 
                    pTemp2 = find(pPert2 == 1);
                    for iPert2 = 1:length(pTemp2)
                        b.(subFig{1,iSubject}{2,1}).CData(pTemp2(iPert2),:) = [1 0 0];
                    end
                else
                    b.(subFig{1,iSubject}{2,1}).CData(pPert,:) = [1 0 0];
                end

                clear pPert pPert2 iPert iPert2
            elseif iSubject == 2
                pPert = tempSub(subidx{1,iSubject}{1,1}:subidx{1,iSubject}{1,2},3) == 1;
                if sum(pPert) > 1 
                    pTemp = find(pPert == 1);
                    for iPert = 1:length(pTemp)
                         b.(subFig{1,iSubject}{1,1}).CData(pTemp(iPert),:) = [1 0 0];
                    end
                else
                    b.(subFig{1,iSubject}{1,1}).CData(pPert,:) = [1 0 0];
                end
                pPert2 = tempSub(subidx{1,iSubject}{2,1}:subidx{1,iSubject}{2,2},3) == 1;
                if sum(pPert2) > 1 
                    pTemp2 = find(pPert2 == 1);
                    for iPert2 = 1:length(pTemp2)
                        b.(subFig{1,iSubject}{2,1}).CData(pTemp2(iPert2),:) = [1 0 0];
                    end
                else
                    b.(subFig{1,iSubject}{2,1}).CData(pPert,:) = [1 0 0];
                end

                clear pPert pPert2 iPert iPert2
            elseif iSubject == 3 
                pPert = tempSub(subidx{1,iSubject}{1,1}:subidx{1,iSubject}{1,2},3) == 1;
                if sum(pPert) > 1 
                    pTemp = find(pPert == 1);
                    for iPert = 1:length(pTemp)
                         b.(subFig{1,iSubject}{1,1}).CData(pTemp(iPert),:) = [1 0 0];
                    end
                else
                    b.(subFig{1,iSubject}{1,1}).CData(pPert,:) = [1 0 0];
                end
                pPert2 = tempSub(subidx{1,iSubject}{2,1}:subidx{1,iSubject}{2,2},3) == 1;
                if sum(pPert2) > 1 
                    pTemp2 = find(pPert2 == 1);
                    for iPert2 = 1:length(pTemp2)
                        b.(subFig{1,iSubject}{2,1}).CData(pTemp2(iPert2),:) = [1 0 0];
                    end
                else
                    b.(subFig{1,iSubject}{2,1}).CData(pPert,:) = [1 0 0];
                end

                clear pPert pPert2 iPert iPert2     
            elseif iSubject == 4 
                pPert = tempSub(subidx{1,iSubject}{1,1}:subidx{1,iSubject}{1,2},3) == 1;
                if sum(pPert) > 1 
                    pTemp = find(pPert == 1);
                    for iPert = 1:length(pTemp)
                         b.(subFig{1,iSubject}{1,1}).CData(pTemp(iPert),:) = [1 0 0];
                    end
                else
                    b.(subFig{1,iSubject}{1,1}).CData(pPert,:) = [1 0 0];
                end
                pPert2 = tempSub(subidx{1,iSubject}{2,1}:subidx{1,iSubject}{2,2},3) == 1;
                if sum(pPert2) > 1 
                    pTemp2 = find(pPert2 == 1);
                    for iPert2 = 1:length(pTemp2)
                        b.(subFig{1,iSubject}{2,1}).CData(pTemp2(iPert2),:) = [1 0 0];
                    end
                else
                    b.(subFig{1,iSubject}{2,1}).CData(pPert,:) = [1 0 0];
                end

                clear pPert pPert2 iPert iPert2
            elseif iSubject == 5 
                pPert = tempSub(subidx{1,iSubject}{1,1}:subidx{1,iSubject}{1,2},3) == 1;
                if sum(pPert) > 1 
                    pTemp = find(pPert == 1);
                    for iPert = 1:length(pTemp)
                         b.(subFig{1,iSubject}{1,1}).CData(pTemp(iPert),:) = [1 0 0];
                    end
                else
                    b.(subFig{1,iSubject}{1,1}).CData(pPert,:) = [1 0 0];
                end
                pPert2 = tempSub(subidx{1,iSubject}{2,1}:subidx{1,iSubject}{2,2},3) == 1;
                if sum(pPert2) > 1 
                    pTemp2 = find(pPert2 == 1);
                    for iPert2 = 1:length(pTemp2)
                        b.(subFig{1,iSubject}{2,1}).CData(pTemp2(iPert2),:) = [1 0 0];
                    end
                else
                    b.(subFig{1,iSubject}{2,1}).CData(pPert,:) = [1 0 0];
                end

                clear pPert pPert2 iPert iPert2
            elseif iSubject == 6 
                pPert = tempSub(subidx{1,iSubject}{1,1}:subidx{1,iSubject}{1,2},3) == 1;
                if sum(pPert) > 1 
                    pTemp = find(pPert == 1);
                    for iPert = 1:length(pTemp)
                         b.(subFig{1,iSubject}{1,1}).CData(pTemp(iPert),:) = [1 0 0];
                    end
                else
                    b.(subFig{1,iSubject}{1,1}).CData(pPert,:) = [1 0 0];
                end
                pPert2 = tempSub(subidx{1,iSubject}{2,1}:subidx{1,iSubject}{2,2},3) == 1;
                if sum(pPert2) > 1 
                    pTemp2 = find(pPert2 == 1);
                    for iPert2 = 1:length(pTemp2)
                        b.(subFig{1,iSubject}{2,1}).CData(pTemp2(iPert2),:) = [1 0 0];
                    end
                else
                    b.(subFig{1,iSubject}{2,1}).CData(pPert,:) = [1 0 0];
                end

                clear pPert pPert2 iPert iPert2
            elseif iSubject == 7 
                pPert = tempSub(subidx{1,iSubject}{1,1}:subidx{1,iSubject}{1,2},3) == 1;
                if sum(pPert) > 1 
                    pTemp = find(pPert == 1);
                    for iPert = 1:length(pTemp)
                         b.(subFig{1,iSubject}{1,1}).CData(pTemp(iPert),:) = [1 0 0];
                    end
                else
                    b.(subFig{1,iSubject}{1,1}).CData(pPert,:) = [1 0 0];
                end
                pPert2 = tempSub(subidx{1,iSubject}{2,1}:subidx{1,iSubject}{2,2},3) == 1;
                if sum(pPert2) > 1 
                    pTemp2 = find(pPert2 == 1);
                    for iPert2 = 1:length(pTemp2)
                        b.(subFig{1,iSubject}{2,1}).CData(pTemp2(iPert2),:) = [1 0 0];
                    end
                else
                    b.(subFig{1,iSubject}{2,1}).CData(pPert,:) = [1 0 0];
                end

                clear pPert pPert2 iPert iPert2
            else
                pPert = tempSub(subidx{1,iSubject}{1,1}:subidx{1,iSubject}{1,2},3) == 1;
                if sum(pPert) > 1 
                    pTemp = find(pPert == 1);
                    for iPert = 1:length(pTemp)
                         b.(subFig{1,iSubject}{1,1}).CData(pTemp(iPert),:) = [1 0 0];
                    end
                else
                    b.(subFig{1,iSubject}{1,1}).CData(pPert,:) = [1 0 0];
                end
                pPert2 = tempSub(subidx{1,iSubject}{2,1}:subidx{1,iSubject}{2,2},3) == 1;
                if sum(pPert2) > 1 
                    pTemp2 = find(pPert2 == 1);
                    for iPert2 = 1:length(pTemp2)
                        b.(subFig{1,iSubject}{2,1}).CData(pTemp2(iPert2),:) = [1 0 0];
                    end
                else
                    b.(subFig{1,iSubject}{2,1}).CData(pPert,:) = [1 0 0];
                end

                clear pPert pPert2 iPert iPert2
        end

    end
end
%%  This section checked the 0.4 perturbation for subject 15 
clear AUCSecs AUCSecs2 AUCSecs3
% speeds2 = {{'sp3'; 'sp4'}, {'sp2'; 'sp3'}, {'sp4'; 'sp5'}, {'sp3'; 'sp4'}, {'sp3'; 'sp4'}, {'sp4'; 'sp5'}, {'sp4'; 'sp5'}, {'sp2'; 'sp3'}};
subName = {'05'; '07'; '10'; '11'; '12'; '13'; '14'; '15';};
emgid = {'EMG_TA-R';'EMG_LGAS-R';'EMG_VLAT-R';'EMG_RFEM-R';'EMG_BFLH-R';'EMG_ADD-R';'EMG_TFL-R';'EMG_GMED-R';'EMG_TA-L';'EMG_LGAS-L';'EMG_VLAT-L';'EMG_RFEM-L';'EMG_BFLH-L';'EMG_ADD-L';'EMG_TFL-L';'EMG_GMED-L';'EMG_SOL-R';'EMG_PERO-R';'EMG_MGAS-R';'EMG_GMAX-R';'EMG_SOL-L';'EMG_PERO-L';'EMG_MGAS-L';'EMG_GMAX-L';'25';'26';'27';'28';'29';'30';'31';'32'};
% Finding the indices of the left and right emgs from emgid to be used to
% plot the muscles in the loop below
B = contains(emgid, '-R'); % Have to do this line because we have extra emg slots 25-32
emgR = emgid(B);
emgRidx = find(B);

speeds2 = {'sp8'};
for iSub = 8
    subject1 = ['YAPercep' subName{iSub}];
    for iSpeeds2 = 1
        for iEmgR = 1:12
            nEmgR = strrep(emgR{iEmgR}, '-R', '');
            for iCycles = 1:6 % Perturbation Cycles 
                for j = 2:61
                    for k = 1:5
                        if iSpeeds2 == 1 
                            AUC.(subject1).(speeds2{iSpeeds2}).(nEmgR)(iCycles,j,k) = AUCStance2.(subject1).(speeds2{iSpeeds2}).cumtrap.(nEmgR){1,iCycles}(j,k)-AUCStance2.(subject1).(speeds2{iSpeeds2}).cumtrap.(nEmgR){1,iCycles}(j-1,k);
                        else
                            AUC.(subject1).(speeds2{iSpeeds2}).(nEmgR)(iCycles,j,k) = AUCStance2.(subject1).(speeds2{iSpeeds2}).cumtrap.(nEmgR){1,iCycles}(j,k)-AUCStance.(subject1).(speeds2{iSpeeds2}).cumtrap.(nEmgR){1,iCycles}(j-1,k);
                        end
                    end
                end
            end
        end
    end
end

for iSub = 8
    subject1 = ['YAPercep' subName{iSub}];
    for iSpeeds2 = 1
        for iEmgR = 1:12
            nEmgR = strrep(emgR{iEmgR}, '-R', '');
            for k = 1:5
                AUC2.(subject1).(speeds2{iSpeeds2}).(nEmgR)(:,k) = mean(AUC.(subject1).(speeds2{iSpeeds2}).(nEmgR)(1:5,:,k),1);
            end
        end
    end
end

for iSub = 8
    subject1 = ['YAPercep' subName{iSub}];
    for iSpeeds2 = 1
        for iEmgR = 1:12
            nEmgR = strrep(emgR{iEmgR}, '-R', '');
            AUC3.(subject1).(speeds2{iSpeeds2}).(nEmgR) = reshape(AUC.(subject1).(speeds2{iSpeeds2}).(nEmgR)(6,:,1:5), [61 5]);
        % temp6 = reshape(temp2(6,:,1:5), [61 5]);
        end
    end
end
            

cd('G:\Shared drives\NeuroMobLab\Projects\Perception\Processed Data\Dan\Results\Temp EMG Plots')
for iSubject = 8
    subject1 = ['YAPercep' subName{iSubject}]; 
    for iEmgR = 1:12
        nEmgR = strrep(emgR{iEmgR}, '-R', '');
        nEmgR2 = strrep(nEmgR, 'EMG_', '');
        for iSpeeds2 = 1
            if iSpeeds2 == 1
                h = figure('Name', [subject1 ' ' nEmgR2 ' '], 'NumberTitle', 'off');
                filename = [subject1 ' ' nEmgR2 ' '];
                filenamePDF = strcat(filename, '.pdf');
            end
            for iPerts = 1:5

                if iSpeeds2 == 1
                    subplot(5,2,2*iPerts-1)
                    b1 = bar(AUC3.(subject1).(speeds2{iSpeeds2}).(nEmgR)(:,iPerts)-AUC2.(subject1).(speeds2{iSpeeds2}).(nEmgR)(:,iPerts), 'FaceColor', 'Flat');
                    ylim([-0.75 0.75])
                else
                    subplot(5,2,2*iPerts)
                    b2 = bar(AUC3.(subject1).(speeds2{iSpeeds2}).(nEmgR)(:,iPerts)-AUC2.(subject1).(speeds2{iSpeeds2}).(nEmgR)(:,iPerts), 'FaceColor', 'Flat');
                    ylim([-0.75 0.75])
                end
                perceived = AUCStance2.(subject1).(speeds2{iSpeeds2}).Perceived(iPerts);
                if perceived == 1
                    title([subject1 ' ' nEmgR ' ' ('sp8') ' onset - avg Pre Perceived']);
                else
                    title([subject1 ' ' nEmgR ' ' ('sp8') ' onset - avg Pre Not Perceived']);
                end
            end
            

        end
        saveas(h, filename);
        print(filenamePDF, '-dpdf', '-bestfit');
        close(h)
    end
end
            
            
%%             
            
            
            
            
%%  Checking some AUCS 
clear AUCSecs AUCSecs2 AUCSecs3
speeds2 = {{'sp3'; 'sp4'}, {'sp2'; 'sp3'}, {'sp4'; 'sp5'}, {'sp3'; 'sp4'}, {'sp3'; 'sp4'}, {'sp4'; 'sp5'}, {'sp4'; 'sp5'}, {'sp2'; 'sp3'}};
subName = {'05'; '07'; '10'; '11'; '12'; '13'; '14'; '15';};
emgid = {'EMG_TA-R';'EMG_LGAS-R';'EMG_VLAT-R';'EMG_RFEM-R';'EMG_BFLH-R';'EMG_ADD-R';'EMG_TFL-R';'EMG_GMED-R';'EMG_TA-L';'EMG_LGAS-L';'EMG_VLAT-L';'EMG_RFEM-L';'EMG_BFLH-L';'EMG_ADD-L';'EMG_TFL-L';'EMG_GMED-L';'EMG_SOL-R';'EMG_PERO-R';'EMG_MGAS-R';'EMG_GMAX-R';'EMG_SOL-L';'EMG_PERO-L';'EMG_MGAS-L';'EMG_GMAX-L';'25';'26';'27';'28';'29';'30';'31';'32'};
% Finding the indices of the left and right emgs from emgid to be used to
% plot the muscles in the loop below
B = contains(emgid, '-R'); % Have to do this line because we have extra emg slots 25-32
emgR = emgid(B);
emgRidx = find(B);


for iSub = 1:8
    subject1 = ['YAPercep' subName{iSub}];
    for iSpeeds2 = 1:2
        for iEmgR = 1:12
            nEmgR = strrep(emgR{iEmgR}, '-R', '');
            for iCycles = 1:6 % Perturbation Cycles 
                for j = 2:61
                    for k = 1:5
                        if iSpeeds2 == 1 
                            AUCSecs.(subject1).(speeds2{iSub}{iSpeeds2}).(nEmgR)(iCycles,j,k) = AUCStance.(subject1).(speeds2{iSub}{iSpeeds2}).cumtrap.(nEmgR){1,iCycles}(j,k)-AUCStance.(subject1).(speeds2{iSub}{iSpeeds2}).cumtrap.(nEmgR){1,iCycles}(j-1,k);
                        else
                            AUCSecs.(subject1).(speeds2{iSub}{iSpeeds2}).(nEmgR)(iCycles,j,k) = AUCStance.(subject1).(speeds2{iSub}{iSpeeds2}).cumtrap.(nEmgR){1,iCycles}(j,k)-AUCStance.(subject1).(speeds2{iSub}{iSpeeds2}).cumtrap.(nEmgR){1,iCycles}(j-1,k);
                        end
                    end
                end
            end
        end
    end
end

for iSub = 1:8
    subject1 = ['YAPercep' subName{iSub}];
    for iSpeeds2 = 1:2
        for iEmgR = 1:12
            nEmgR = strrep(emgR{iEmgR}, '-R', '');
            for k = 1:5
                AUCSecs2.(subject1).(speeds2{iSub}{iSpeeds2}).(nEmgR)(:,k) = mean(AUCSecs.(subject1).(speeds2{iSub}{iSpeeds2}).(nEmgR)(1:5,:,k),1);
            end
        end
    end
end

for iSub = 1:8
    subject1 = ['YAPercep' subName{iSub}];
    for iSpeeds2 = 1:2
        for iEmgR = 1:12
            nEmgR = strrep(emgR{iEmgR}, '-R', '');
            AUCSecs3.(subject1).(speeds2{iSub}{iSpeeds2}).(nEmgR) = reshape(AUCSecs.(subject1).(speeds2{iSub}{iSpeeds2}).(nEmgR)(6,:,1:5), [61 5]);
        % temp6 = reshape(temp2(6,:,1:5), [61 5]);
        end
    end
end

%% Splitting the GC into 4 phases to be compared and calculating the max difference (abs)
for iSub = 1:8
    subject1 = ['YAPercep' subName{iSub}];
    for iSpeeds2 = 1:2
        for iEmgR = 1:12
            nEmgR = strrep(emgR{iEmgR}, '-R', '');
            AUCSecs4.(subject1).(speeds2{iSub}{iSpeeds2}).(nEmgR).onset.stance1 = sum(AUCSecs3.(subject1).(speeds2{iSub}{iSpeeds2}).(nEmgR)(2:16,:));
            AUCSecs4.(subject1).(speeds2{iSub}{iSpeeds2}).(nEmgR).onset.stance2 = sum(AUCSecs3.(subject1).(speeds2{iSub}{iSpeeds2}).(nEmgR)(17:31,:));
            AUCSecs4.(subject1).(speeds2{iSub}{iSpeeds2}).(nEmgR).onset.stance3 = sum(AUCSecs3.(subject1).(speeds2{iSub}{iSpeeds2}).(nEmgR)(32:46,:));
            AUCSecs4.(subject1).(speeds2{iSub}{iSpeeds2}).(nEmgR).onset.stance4 = sum(AUCSecs3.(subject1).(speeds2{iSub}{iSpeeds2}).(nEmgR)(47:61,:));
            AUCSecs4.(subject1).(speeds2{iSub}{iSpeeds2}).(nEmgR).pre.stance1 = sum(AUCSecs2.(subject1).(speeds2{iSub}{iSpeeds2}).(nEmgR)(2:16,:));
            AUCSecs4.(subject1).(speeds2{iSub}{iSpeeds2}).(nEmgR).pre.stance2 = sum(AUCSecs2.(subject1).(speeds2{iSub}{iSpeeds2}).(nEmgR)(17:31,:));
            AUCSecs4.(subject1).(speeds2{iSub}{iSpeeds2}).(nEmgR).pre.stance3 = sum(AUCSecs2.(subject1).(speeds2{iSub}{iSpeeds2}).(nEmgR)(32:46,:));
            AUCSecs4.(subject1).(speeds2{iSub}{iSpeeds2}).(nEmgR).pre.stance4 = sum(AUCSecs2.(subject1).(speeds2{iSub}{iSpeeds2}).(nEmgR)(47:61,:));
            AUCSecs4.(subject1).(speeds2{iSub}{iSpeeds2}).(nEmgR).o2p.stance1 = AUCSecs4.(subject1).(speeds2{iSub}{iSpeeds2}).(nEmgR).onset.stance1 - AUCSecs4.(subject1).(speeds2{iSub}{iSpeeds2}).(nEmgR).pre.stance1;
            AUCSecs4.(subject1).(speeds2{iSub}{iSpeeds2}).(nEmgR).o2p.stance2 = AUCSecs4.(subject1).(speeds2{iSub}{iSpeeds2}).(nEmgR).onset.stance2 - AUCSecs4.(subject1).(speeds2{iSub}{iSpeeds2}).(nEmgR).pre.stance2;
            AUCSecs4.(subject1).(speeds2{iSub}{iSpeeds2}).(nEmgR).o2p.stance3 = AUCSecs4.(subject1).(speeds2{iSub}{iSpeeds2}).(nEmgR).onset.stance3 - AUCSecs4.(subject1).(speeds2{iSub}{iSpeeds2}).(nEmgR).pre.stance3;
            AUCSecs4.(subject1).(speeds2{iSub}{iSpeeds2}).(nEmgR).o2p.stance4 = AUCSecs4.(subject1).(speeds2{iSub}{iSpeeds2}).(nEmgR).onset.stance4 - AUCSecs4.(subject1).(speeds2{iSub}{iSpeeds2}).(nEmgR).pre.stance4;
            AUCSecs4.(subject1).(speeds2{iSub}{iSpeeds2}).(nEmgR).max = max(abs(AUCSecs3.(subject1).(speeds2{iSub}{iSpeeds2}).(nEmgR)-AUCSecs2.(subject1).(speeds2{iSub}{iSpeeds2}).(nEmgR)));
            AUCSecs4.(subject1).(speeds2{iSub}{iSpeeds2}).(nEmgR).stance = sum((AUCSecs3.(subject1).(speeds2{iSub}{iSpeeds2}).(nEmgR)-AUCSecs2.(subject1).(speeds2{iSub}{iSpeeds2}).(nEmgR)),1);
            % temp6 = reshape(temp2(6,:,1:5), [61 5]);
        end
    end
end

%%
% Creating a variable for stats 
tempSub4 = nan(80,51);
counter = 1;
for iSubjects = 1:8
    subject1 = ['YAPercep' subName{iSubjects}];
    for iSpeeds = 1:2
        for iPerts = 1:5 
            tempSub4(counter,1) = iSubjects; % Subject ID 
            tempSub4(counter,2) = iSpeeds; % Speed Level
            tempSub4(counter,3) = AUCStance.(subject1).(speeds2{iSubjects}{iSpeeds}).Perceived(iPerts); % Perceived or not
            tempSub4(counter,4) = AUCSecs4.(subject1).(speeds2{iSubjects}{iSpeeds2}).EMG_TA.o2p.stance1(iPerts); %  for TA over stance 
            tempSub4(counter,5) = AUCSecs4.(subject1).(speeds2{iSubjects}{iSpeeds2}).EMG_TA.o2p.stance2(iPerts); %  for TA over stance 
            tempSub4(counter,6) = AUCSecs4.(subject1).(speeds2{iSubjects}{iSpeeds2}).EMG_TA.o2p.stance3(iPerts); %  for TA over stance 
            tempSub4(counter,7) = AUCSecs4.(subject1).(speeds2{iSubjects}{iSpeeds2}).EMG_TA.o2p.stance4(iPerts); %  for TA over stance 
            tempSub4(counter,8) = AUCSecs4.(subject1).(speeds2{iSubjects}{iSpeeds2}).EMG_LGAS.o2p.stance1(iPerts); % ES for EMG_LGAS over stance 
            tempSub4(counter,9) = AUCSecs4.(subject1).(speeds2{iSubjects}{iSpeeds2}).EMG_LGAS.o2p.stance2(iPerts);
            tempSub4(counter,10) = AUCSecs4.(subject1).(speeds2{iSubjects}{iSpeeds2}).EMG_LGAS.o2p.stance3(iPerts);
            tempSub4(counter,11) = AUCSecs4.(subject1).(speeds2{iSubjects}{iSpeeds2}).EMG_LGAS.o2p.stance4(iPerts);
            tempSub4(counter,12) = AUCSecs4.(subject1).(speeds2{iSubjects}{iSpeeds2}).EMG_VLAT.o2p.stance1(iPerts); % ES for EMG_VLAT over stance
            tempSub4(counter,13) = AUCSecs4.(subject1).(speeds2{iSubjects}{iSpeeds2}).EMG_VLAT.o2p.stance2(iPerts);
            tempSub4(counter,14) = AUCSecs4.(subject1).(speeds2{iSubjects}{iSpeeds2}).EMG_VLAT.o2p.stance3(iPerts);
            tempSub4(counter,15) = AUCSecs4.(subject1).(speeds2{iSubjects}{iSpeeds2}).EMG_VLAT.o2p.stance4(iPerts);
            tempSub4(counter,16) = AUCSecs4.(subject1).(speeds2{iSubjects}{iSpeeds2}).EMG_RFEM.o2p.stance1(iPerts); % ES for EMG_RFEM over stance 
            tempSub4(counter,17) = AUCSecs4.(subject1).(speeds2{iSubjects}{iSpeeds2}).EMG_RFEM.o2p.stance2(iPerts);
            tempSub4(counter,18) = AUCSecs4.(subject1).(speeds2{iSubjects}{iSpeeds2}).EMG_RFEM.o2p.stance3(iPerts);
            tempSub4(counter,19) = AUCSecs4.(subject1).(speeds2{iSubjects}{iSpeeds2}).EMG_RFEM.o2p.stance4(iPerts);
            tempSub4(counter,20) = AUCSecs4.(subject1).(speeds2{iSubjects}{iSpeeds2}).EMG_BFLH.o2p.stance1(iPerts); % ES for EMG_BFLH over stance
            tempSub4(counter,21) = AUCSecs4.(subject1).(speeds2{iSubjects}{iSpeeds2}).EMG_BFLH.o2p.stance2(iPerts);
            tempSub4(counter,22) = AUCSecs4.(subject1).(speeds2{iSubjects}{iSpeeds2}).EMG_BFLH.o2p.stance3(iPerts);
            tempSub4(counter,23) = AUCSecs4.(subject1).(speeds2{iSubjects}{iSpeeds2}).EMG_BFLH.o2p.stance4(iPerts);
            tempSub4(counter,24) = AUCSecs4.(subject1).(speeds2{iSubjects}{iSpeeds2}).EMG_ADD.o2p.stance1(iPerts); % ES for EMG_ADD over stance 
            tempSub4(counter,25) = AUCSecs4.(subject1).(speeds2{iSubjects}{iSpeeds2}).EMG_ADD.o2p.stance2(iPerts);
            tempSub4(counter,26) = AUCSecs4.(subject1).(speeds2{iSubjects}{iSpeeds2}).EMG_ADD.o2p.stance3(iPerts);
            tempSub4(counter,27) = AUCSecs4.(subject1).(speeds2{iSubjects}{iSpeeds2}).EMG_ADD.o2p.stance4(iPerts);
            tempSub4(counter,28) = AUCSecs4.(subject1).(speeds2{iSubjects}{iSpeeds2}).EMG_TFL.o2p.stance1(iPerts); % ES for EMG_TFL over stance 
            tempSub4(counter,29) = AUCSecs4.(subject1).(speeds2{iSubjects}{iSpeeds2}).EMG_TFL.o2p.stance2(iPerts);
            tempSub4(counter,30) = AUCSecs4.(subject1).(speeds2{iSubjects}{iSpeeds2}).EMG_TFL.o2p.stance3(iPerts);
            tempSub4(counter,31) = AUCSecs4.(subject1).(speeds2{iSubjects}{iSpeeds2}).EMG_TFL.o2p.stance4(iPerts);
            tempSub4(counter,32) = AUCSecs4.(subject1).(speeds2{iSubjects}{iSpeeds2}).EMG_GMED.o2p.stance1(iPerts); % ES for EMG_GMED over stance 
            tempSub4(counter,33) = AUCSecs4.(subject1).(speeds2{iSubjects}{iSpeeds2}).EMG_GMED.o2p.stance2(iPerts);
            tempSub4(counter,34) = AUCSecs4.(subject1).(speeds2{iSubjects}{iSpeeds2}).EMG_GMED.o2p.stance3(iPerts);
            tempSub4(counter,35) = AUCSecs4.(subject1).(speeds2{iSubjects}{iSpeeds2}).EMG_GMED.o2p.stance4(iPerts);
            tempSub4(counter,36) = AUCSecs4.(subject1).(speeds2{iSubjects}{iSpeeds2}).EMG_SOL.o2p.stance1(iPerts); % ES for EMG_SOL over stance 
            tempSub4(counter,37) = AUCSecs4.(subject1).(speeds2{iSubjects}{iSpeeds2}).EMG_SOL.o2p.stance2(iPerts);
            tempSub4(counter,38) = AUCSecs4.(subject1).(speeds2{iSubjects}{iSpeeds2}).EMG_SOL.o2p.stance3(iPerts);
            tempSub4(counter,39) = AUCSecs4.(subject1).(speeds2{iSubjects}{iSpeeds2}).EMG_SOL.o2p.stance4(iPerts);
            tempSub4(counter,40) = AUCSecs4.(subject1).(speeds2{iSubjects}{iSpeeds2}).EMG_PERO.o2p.stance1(iPerts); % ES for EMG_PERO over stance
            tempSub4(counter,41) = AUCSecs4.(subject1).(speeds2{iSubjects}{iSpeeds2}).EMG_PERO.o2p.stance2(iPerts);
            tempSub4(counter,42) = AUCSecs4.(subject1).(speeds2{iSubjects}{iSpeeds2}).EMG_PERO.o2p.stance3(iPerts);
            tempSub4(counter,43) = AUCSecs4.(subject1).(speeds2{iSubjects}{iSpeeds2}).EMG_PERO.o2p.stance4(iPerts);
            tempSub4(counter,44) = AUCSecs4.(subject1).(speeds2{iSubjects}{iSpeeds2}).EMG_MGAS.o2p.stance1(iPerts); % ES for EMG_MGAS over stance
            tempSub4(counter,45) = AUCSecs4.(subject1).(speeds2{iSubjects}{iSpeeds2}).EMG_MGAS.o2p.stance2(iPerts);
            tempSub4(counter,46) = AUCSecs4.(subject1).(speeds2{iSubjects}{iSpeeds2}).EMG_MGAS.o2p.stance3(iPerts);
            tempSub4(counter,47) = AUCSecs4.(subject1).(speeds2{iSubjects}{iSpeeds2}).EMG_MGAS.o2p.stance4(iPerts);
            tempSub4(counter,48) = AUCSecs4.(subject1).(speeds2{iSubjects}{iSpeeds2}).EMG_GMAX.o2p.stance1(iPerts); % ES for EMG_GMAX over stance 
            tempSub4(counter,49) = AUCSecs4.(subject1).(speeds2{iSubjects}{iSpeeds2}).EMG_GMAX.o2p.stance2(iPerts);
            tempSub4(counter,50) = AUCSecs4.(subject1).(speeds2{iSubjects}{iSpeeds2}).EMG_GMAX.o2p.stance3(iPerts);
            tempSub4(counter,51) = AUCSecs4.(subject1).(speeds2{iSubjects}{iSpeeds2}).EMG_GMAX.o2p.stance4(iPerts);
            counter = counter + 1;
        end
    end
end

%% 
tempSub5 = nan(80,15);
counter = 1;
for iSubjects = 1:8
    subject1 = ['YAPercep' subName{iSubjects}];
    for iSpeeds = 1:2
        for iPerts = 1:5 
            tempSub5(counter,1) = iSubjects; % Subject ID 
            tempSub5(counter,2) = iSpeeds; % Speed Level
            tempSub5(counter,3) = AUCStance.(subject1).(speeds2{iSubjects}{iSpeeds}).Perceived(iPerts); % Perceived or not
            tempSub5(counter,4) = AUCSecs4.(subject1).(speeds2{iSubjects}{iSpeeds2}).EMG_TA.max(iPerts); % ES for TA over stance 
            tempSub5(counter,5) = AUCSecs4.(subject1).(speeds2{iSubjects}{iSpeeds}).EMG_LGAS.max(iPerts); % ES for EMG_LGAS over stance 
            tempSub5(counter,6) = AUCSecs4.(subject1).(speeds2{iSubjects}{iSpeeds}).EMG_VLAT.max(iPerts); % ES for EMG_VLAT over stance 
            tempSub5(counter,7) = AUCSecs4.(subject1).(speeds2{iSubjects}{iSpeeds}).EMG_RFEM.max(iPerts); % ES for EMG_RFEM over stance 
            tempSub5(counter,8) = AUCSecs4.(subject1).(speeds2{iSubjects}{iSpeeds}).EMG_BFLH.max(iPerts); % ES for EMG_BFLH over stance 
            tempSub5(counter,9) = AUCSecs4.(subject1).(speeds2{iSubjects}{iSpeeds}).EMG_ADD.max(iPerts); % ES for EMG_ADD over stance 
            tempSub5(counter,10) = AUCSecs4.(subject1).(speeds2{iSubjects}{iSpeeds}).EMG_TFL.max(iPerts); % ES for EMG_TFL over stance 
            tempSub5(counter,11) = AUCSecs4.(subject1).(speeds2{iSubjects}{iSpeeds}).EMG_GMED.max(iPerts); % ES for EMG_GMED over stance 
            tempSub5(counter,12) = AUCSecs4.(subject1).(speeds2{iSubjects}{iSpeeds}).EMG_SOL.max(iPerts); % ES for EMG_SOL over stance 
            tempSub5(counter,13) = AUCSecs4.(subject1).(speeds2{iSubjects}{iSpeeds}).EMG_PERO.max(iPerts); % ES for EMG_PERO over stance 
            tempSub5(counter,14) = AUCSecs4.(subject1).(speeds2{iSubjects}{iSpeeds}).EMG_MGAS.max(iPerts); % ES for EMG_MGAS over stance 
            tempSub5(counter,15) = AUCSecs4.(subject1).(speeds2{iSubjects}{iSpeeds}).EMG_GMAX.max(iPerts); % ES for EMG_GMAX over stance 
            counter = counter + 1;
        end
    end
end

%%
tempSub6 = nan(80,15);
counter = 1;
for iSubjects = 1:8
    subject1 = ['YAPercep' subName{iSubjects}];
    for iSpeeds = 1:2
        for iPerts = 1:5 
            tempSub6(counter,1) = iSubjects; % Subject ID 
            tempSub6(counter,2) = iSpeeds; % Speed Level
            tempSub6(counter,3) = AUCStance.(subject1).(speeds2{iSubjects}{iSpeeds}).Perceived(iPerts); % Perceived or not
            tempSub6(counter,4) = AUCSecs4.(subject1).(speeds2{iSubjects}{iSpeeds2}).EMG_TA.stance(iPerts); % ES for TA over stance 
            tempSub6(counter,5) = AUCSecs4.(subject1).(speeds2{iSubjects}{iSpeeds}).EMG_LGAS.stance(iPerts); % ES for EMG_LGAS over stance 
            tempSub6(counter,6) = AUCSecs4.(subject1).(speeds2{iSubjects}{iSpeeds}).EMG_VLAT.stance(iPerts); % ES for EMG_VLAT over stance 
            tempSub6(counter,7) = AUCSecs4.(subject1).(speeds2{iSubjects}{iSpeeds}).EMG_RFEM.stance(iPerts); % ES for EMG_RFEM over stance 
            tempSub6(counter,8) = AUCSecs4.(subject1).(speeds2{iSubjects}{iSpeeds}).EMG_BFLH.stance(iPerts); % ES for EMG_BFLH over stance 
            tempSub6(counter,9) = AUCSecs4.(subject1).(speeds2{iSubjects}{iSpeeds}).EMG_ADD.stance(iPerts); % ES for EMG_ADD over stance 
            tempSub6(counter,10) = AUCSecs4.(subject1).(speeds2{iSubjects}{iSpeeds}).EMG_TFL.stance(iPerts); % ES for EMG_TFL over stance 
            tempSub6(counter,11) = AUCSecs4.(subject1).(speeds2{iSubjects}{iSpeeds}).EMG_GMED.stance(iPerts); % ES for EMG_GMED over stance 
            tempSub6(counter,12) = AUCSecs4.(subject1).(speeds2{iSubjects}{iSpeeds}).EMG_SOL.stance(iPerts); % ES for EMG_SOL over stance 
            tempSub6(counter,13) = AUCSecs4.(subject1).(speeds2{iSubjects}{iSpeeds}).EMG_PERO.stance(iPerts); % ES for EMG_PERO over stance 
            tempSub6(counter,14) = AUCSecs4.(subject1).(speeds2{iSubjects}{iSpeeds}).EMG_MGAS.stance(iPerts); % ES for EMG_MGAS over stance 
            tempSub6(counter,15) = AUCSecs4.(subject1).(speeds2{iSubjects}{iSpeeds}).EMG_GMAX.stance(iPerts); % ES for EMG_GMAX over stance 
            counter = counter + 1;
        end
    end
end
%%
cd('G:\Shared drives\NeuroMobLab\Projects\Perception\Processed Data\Dan\Results\Temp EMG Plots\Phase_Stance')
for iSub = 1:8
    subject1 = ['YAPercep' subName{iSub}]; 
    for iEmgR = 1:12
        nEmgR = strrep(emgR{iEmgR}, '-R', '');
        nEmgR2 = strrep(nEmgR, 'EMG_', '');
        for iSpeeds2 = 1:2
            if iSpeeds2 == 1
                h = figure('Name', [subject1 ' ' nEmgR2 ' ' 'Phase Stance'], 'NumberTitle', 'off');
                filename = [subject1 ' ' nEmgR2 ' ' 'Phase Stance'];
                filenamePDF = strcat(filename, '.pdf');
            end
            for iPerts = 1:5

                if iSpeeds2 == 1
                    subplot(5,2,2*iPerts-1)
                    b1 = bar([AUCSecs4.(subject1).(speeds2{iSub}{iSpeeds2}).(nEmgR).o2p.stance1(iPerts), AUCSecs4.(subject1).(speeds2{iSub}{iSpeeds2}).(nEmgR).o2p.stance2(iPerts), AUCSecs4.(subject1).(speeds2{iSub}{iSpeeds2}).(nEmgR).o2p.stance3(iPerts), AUCSecs4.(subject1).(speeds2{iSub}{iSpeeds2}).(nEmgR).o2p.stance4(iPerts)], 'FaceColor', 'Flat');
                    
%                     ylim([-0.75 0.75])
                else
                    subplot(5,2,2*iPerts)
                    b2 = bar([AUCSecs4.(subject1).(speeds2{iSub}{iSpeeds2}).(nEmgR).o2p.stance1(iPerts), AUCSecs4.(subject1).(speeds2{iSub}{iSpeeds2}).(nEmgR).o2p.stance2(iPerts), AUCSecs4.(subject1).(speeds2{iSub}{iSpeeds2}).(nEmgR).o2p.stance3(iPerts), AUCSecs4.(subject1).(speeds2{iSub}{iSpeeds2}).(nEmgR).o2p.stance4(iPerts)], 'FaceColor', 'Flat');
%                     ylim([-0.75 0.75])
                end
                perceived = AUCStance.(subject1).(speeds2{iSub}{iSpeeds2}).Perceived(iPerts);
                if perceived == 1
                    title([subject1 ' ' nEmgR ' ' (speeds2{iSub}{iSpeeds2}) ' onset - avg Pre Perceived']);
                else
                    title([subject1 ' ' nEmgR ' ' (speeds2{iSub}{iSpeeds2}) ' onset - avg Pre Not Perceived']);
                end
                xticklabels({'0-15%'; '15-30%'; '30-45%'; '45-60%'});
            end
            

        end
        saveas(h, filename);
        print(filenamePDF, '-dpdf', '-bestfit');
        close(h)
    end
end

%%
cd('G:\Shared drives\NeuroMobLab\Projects\Perception\Processed Data\Dan\Results\Temp EMG Plots\Max')
for iSub = 1:8
    subject1 = ['YAPercep' subName{iSub}]; 
    for iEmgR = 1:12
        nEmgR = strrep(emgR{iEmgR}, '-R', '');
        nEmgR2 = strrep(nEmgR, 'EMG_', '');
        for iSpeeds2 = 1:2
            if iSpeeds2 == 1
                h = figure('Name', [subject1 ' ' nEmgR2 ' ' 'Max'], 'NumberTitle', 'off');
                filename = [subject1 ' ' nEmgR2 ' ' 'Max'];
                filenamePDF = strcat(filename, '.pdf');
            end
%             for iPerts = 1:5

                if iSpeeds2 == 1
                    subplot(2,1,1)
                    b1 = bar(AUCSecs4.(subject1).(speeds2{iSub}{iSpeeds2}).(nEmgR).max, 'FaceColor', 'Flat');
                    
%                     ylim([-0.75 0.75])
                else
                    subplot(2,1,2)
                    b2 = bar(AUCSecs4.(subject1).(speeds2{iSub}{iSpeeds2}).(nEmgR).max, 'FaceColor', 'Flat');
%                     ylim([-0.75 0.75])
                end
                perceived = AUCStance.(subject1).(speeds2{iSub}{iSpeeds2}).Perceived;
                if perceived == 1
                    title([subject1 ' ' nEmgR ' ' (speeds2{iSub}{iSpeeds2}) ' onset - avg Pre']);
                else
                    title([subject1 ' ' nEmgR ' ' (speeds2{iSub}{iSpeeds2}) ' onset - avg Pre']);
                end
%             end
                xticklabels(perceived);

        end
        saveas(h, filename);
        print(filenamePDF, '-dpdf', '-bestfit');
        close(h)
    end
end
%% Calculating 20-30% of the GC 

for iSub = 1:8
    subject1 = ['YAPercep' subName{iSub}];
    for iSpeeds2 = 1:2
        for iEmgR = 1:12
            nEmgR = strrep(emgR{iEmgR}, '-R', '');
            AUCSecs4.(subject1).(speeds2{iSub}{iSpeeds2}).(nEmgR) = sum(AUCSecs3.(subject1).(speeds2{iSub}{iSpeeds2}).(nEmgR)(20:30,:),1);
            AUCSecs5.(subject1).(speeds2{iSub}{iSpeeds2}).(nEmgR) = sum(AUCSecs2.(subject1).(speeds2{iSub}{iSpeeds2}).(nEmgR)(20:30,:),1);
        % temp6 = reshape(temp2(6,:,1:5), [61 5]);
        end
    end
end
%% Plotting bar plots for 20-30% of the gaitcycle
cd('G:\Shared drives\NeuroMobLab\Projects\Perception\Processed Data\Dan\Results\Temp EMG Plots\20GC')
for iSubject = 1:8
    subject1 = ['YAPercep' subName{iSubject}]; 
    for iEmgR = 1:12
        nEmgR = strrep(emgR{iEmgR}, '-R', '');
        nEmgR2 = strrep(nEmgR, 'EMG_', '');
        for iSpeeds2 = 1:2
            if iSpeeds2 == 1
                h = figure('Name', [subject1 ' ' nEmgR2 ' ' '20-30% GC'], 'NumberTitle', 'off');
                filename = [subject1 ' ' nEmgR2 ' ' '20-30% GC'];
                filenamePDF = strcat(filename, '.pdf');
            end
            for iPerts = 1:5

                if iSpeeds2 == 1
                    subplot(5,2,2*iPerts-1)
                    b1 = bar(AUCSecs4.(subject1).(speeds2{iSubject}{iSpeeds2}).(nEmgR)(iPerts)-AUCSecs5.(subject1).(speeds2{iSubject}{iSpeeds2}).(nEmgR)(iPerts), 'FaceColor', 'Flat');
                    ylim([-0.75 0.75])
                else
                    subplot(5,2,2*iPerts)
                    b2 = bar(AUCSecs4.(subject1).(speeds2{iSubject}{iSpeeds2}).(nEmgR)(iPerts)-AUCSecs5.(subject1).(speeds2{iSubject}{iSpeeds2}).(nEmgR)(iPerts), 'FaceColor', 'Flat');
                    ylim([-0.75 0.75])
                end
                perceived = AUCStance.(subject1).(speeds2{iSubject}{iSpeeds2}).Perceived(iPerts);
                if perceived == 1
                    title([subject1 ' ' nEmgR ' ' (speeds2{iSubject}{iSpeeds2}) ' onset - avg Pre Perceived']);
                else
                    title([subject1 ' ' nEmgR ' ' (speeds2{iSubject}{iSpeeds2}) ' onset - avg Pre Not Perceived']);
                end
            end
            

        end
        saveas(h, filename);
        print(filenamePDF, '-dpdf', '-bestfit');
        close(h)
    end
end
%%
cd('G:\Shared drives\NeuroMobLab\Projects\Perception\Processed Data\Dan\Results\Temp EMG Plots')
load('G:\Shared drives\NeuroMobLab\Projects\Perception\Processed Data\Dan\Results\Emg Sub Structure\Stance.mat');
load('G:\Shared drives\NeuroMobLab\Projects\Perception\Processed Data\Dan\Results\Temp EMG Plots\Stance_cumTrap.mat');
for iSubject = 1:8
    subject1 = ['YAPercep' subName{iSubject}]; 
    for iEmgR = 1:12
        nEmgR = strrep(emgR{iEmgR}, '-R', '');
        nEmgR2 = strrep(nEmgR, 'EMG_', '');
        for iSpeeds2 = 1:2
            if iSpeeds2 == 1
                h = figure('Name', [subject1 ' ' nEmgR2 ' '], 'NumberTitle', 'off');
                filename = [subject1 ' ' nEmgR2 ' '];
                filenamePDF = strcat(filename, '.pdf');
            end
            for iPerts = 1:5

                if iSpeeds2 == 1
                    subplot(5,2,2*iPerts-1)
                    b1 = bar(AUCSecs3.(subject1).(speeds2{iSubject}{iSpeeds2}).(nEmgR)(:,iPerts)-AUCSecs2.(subject1).(speeds2{iSubject}{iSpeeds2}).(nEmgR)(:,iPerts), 'FaceColor', 'Flat');
                    ylim([-0.75 0.75])
                else
                    subplot(5,2,2*iPerts)
                    b2 = bar(AUCSecs3.(subject1).(speeds2{iSubject}{iSpeeds2}).(nEmgR)(:,iPerts)-AUCSecs2.(subject1).(speeds2{iSubject}{iSpeeds2}).(nEmgR)(:,iPerts), 'FaceColor', 'Flat');
                    ylim([-0.75 0.75])
                end
                perceived = AUCStance.(subject1).(speeds2{iSubject}{iSpeeds2}).Perceived(iPerts);
                if perceived == 1
                    title([subject1 ' ' nEmgR ' ' (speeds2{iSubject}{iSpeeds2}) ' onset - avg Pre Perceived']);
                else
                    title([subject1 ' ' nEmgR ' ' (speeds2{iSubject}{iSpeeds2}) ' onset - avg Pre Not Perceived']);
                end
            end
            

        end
        saveas(h, filename);
        print(filenamePDF, '-dpdf', '-bestfit');
        close(h)
    end
end

%% Plotting from 30-60% of the gait cycle for each perturbation since that is when the signal would technically be back from the cortex 

% 1st calucalting it from 30-60%
for iSub = 1:8
    subject1 = ['YAPercep' subName{iSub}];
    for iSpeeds2 = 1:2
        for iEmgR = 1:12
            nEmgR = strrep(emgR{iEmgR}, '-R', '');
            AUCSecs4.(subject1).(speeds2{iSub}{iSpeeds2}).(nEmgR) = sum(AUCSecs3.(subject1).(speeds2{iSub}{iSpeeds2}).(nEmgR)(30:60,:),1);
            AUCSecs5.(subject1).(speeds2{iSub}{iSpeeds2}).(nEmgR) = sum(AUCSecs2.(subject1).(speeds2{iSub}{iSpeeds2}).(nEmgR)(30:60,:),1);
        % temp6 = reshape(temp2(6,:,1:5), [61 5]);
        end
    end
end

for iSubject = 1:8
    subject1 = ['YAPercep' subName{iSubject}]; 
    for iEmgR = 1:12
        nEmgR = strrep(emgR{iEmgR}, '-R', '');
        nEmgR2 = strrep(nEmgR, 'EMG_', '');
        for iSpeeds2 = 1:2
            if iSpeeds2 == 1
                h = figure('Name', [subject1 ' ' nEmgR2 ' '], 'NumberTitle', 'off');
                filename = [subject1 ' ' nEmgR2 ' '];
                filenamePDF = strcat(filename, '.pdf');
            end
%             for iPerts = 1:5

                if iSpeeds2 == 1
                    subplot(2,1,1)
                    b1 = bar(AUCSecs4.(subject1).(speeds2{iSubject}{iSpeeds2}).(nEmgR)-AUCSecs5.(subject1).(speeds2{iSubject}{iSpeeds2}).(nEmgR), 'FaceColor', 'Flat');
%                     ylim([-2 2])
                else
                    subplot(2,1,2)
                    b2 = bar(AUCSecs4.(subject1).(speeds2{iSubject}{iSpeeds2}).(nEmgR)-AUCSecs5.(subject1).(speeds2{iSubject}{iSpeeds2}).(nEmgR), 'FaceColor', 'Flat');
%                     ylim([-2 2])
                end
                perceived = AUCStance.(subject1).(speeds2{iSubject}{iSpeeds2}).Perceived;
                xticklabels(perceived);
                title([subject1 ' ' nEmgR ' ' (speeds2{iSubject}{iSpeeds2}) ' onset - avg Pre 30to60% GC']);
%                 if perceived == 1
%                     title([subject1 ' ' nEmgR ' ' (speeds2{iSubject}{iSpeeds2}) ' onset - avg Pre Perceived']);
%                 else
%                     title([subject1 ' ' nEmgR ' ' (speeds2{iSubject}{iSpeeds2}) ' onset - avg Pre Not Perceived']);
%                 end
%             end
            

        end
        saveas(h, filename);
        print(filenamePDF, '-dpdf', '-bestfit');
        close(h)
    end
end


%%


% figure;
% for i = 1:2
%     for k = 1:5
%         if i == 1
%             subplot(6,2,k);
%             bar(temp(i,:,k)-temp2(:,k));
%             ylim([0,20])
%         elseif i == 2 
%             subplot(6,2,k+5);
%             bar(temp(i,:,k)-temp2(:,k));
%             ylim([0,20])
%         elseif i == 3 
%             subplot(6,5,k+10);
%             bar(temp(i,:,k)-temp2(:,k));
%             ylim([0,20])
%         elseif i == 4 
%             subplot(6,5,k+15);
%             bar(temp(i,:,k)-temp2(:,k));
%             ylim([0,20])
%         elseif i == 5 
%             subplot(6,5,k+20);
%             bar(temp(i,:,k));
%             ylim([0,20])
%         else 
%             subplot(6,5,k+25);
%             bar(temp(i,:,k)-temp2(:,k));
%             ylim([0,20])
%         end
%     end
% end


%% 

% Plots for the TA 
figure; subplot(8,2,1); bar(tempSub(1:5,4)); title('ES TA'); subplot(8,2,2); bar(tempSub(6:10,4));
subplot(8,2,3); bar(tempSub(11:15,4)); subplot(8,2,4); bar(tempSub(16:20,4));
subplot(8,2,5); bar(tempSub(21:25,4)); subplot(8,2,6); bar(tempSub(26:30,4));
subplot(8,2,7); bar(tempSub(31:35,4)); subplot(8,2,8); bar(tempSub(6:10,4));
subplot(8,2,9); bar(tempSub(41:45,4)); subplot(8,2,10); bar(tempSub(46:50,4));
subplot(8,2,11); bar(tempSub(51:55,4)); subplot(8,2,12); bar(tempSub(56:60,4));
subplot(8,2,13); bar(tempSub(61:65,4)); subplot(8,2,14); bar(tempSub(66:70,4));
subplot(8,2,15); bar(tempSub(71:75,4)); subplot(8,2,16); bar(tempSub(76:80,4));

% Plots for the LGAS
figure; subplot(3,2,1); bar(tempSub(1:5,5)); subplot(3,2,2); bar(tempSub(6:10,5));
subplot(3,2,3); bar(tempSub(11:15,5)); subplot(3,2,4); bar(tempSub(16:20,5));
subplot(3,2,5); bar(tempSub(21:25,5)); subplot(3,2,6); bar(tempSub(26:30,5));
% Plots for the SOL
figure; subplot(3,2,1); bar(tempSub(1:5,12)); subplot(3,2,2); bar(tempSub(6:10,12));
subplot(3,2,3); bar(tempSub(11:15,12)); subplot(3,2,4); bar(tempSub(16:20,12));
subplot(3,2,5); bar(tempSub(21:25,12)); subplot(3,2,6); bar(tempSub(26:30,12));

% Plots for the MGAS
figure; subplot(3,2,1); bar(tempSub(1:5,14)); subplot(3,2,2); bar(tempSub(6:10,14));
subplot(3,2,3); bar(tempSub(11:15,14)); subplot(3,2,4); bar(tempSub(16:20,14));
subplot(3,2,5); bar(tempSub(21:25,14)); subplot(3,2,6); bar(tempSub(26:30,14));

% Plots for the GMAX
figure; subplot(3,2,1); bar(tempSub(1:5,15)); subplot(3,2,2); bar(tempSub(6:10,15));
subplot(3,2,3); bar(tempSub(11:15,15)); subplot(3,2,4); bar(tempSub(16:20,15));
subplot(3,2,5); bar(tempSub(21:25,15)); subplot(3,2,6); bar(tempSub(26:30,15));

% Plots for the GMED
figure; subplot(3,2,1); bar(tempSub(1:5,11)); subplot(3,2,2); bar(tempSub(6:10,11));
subplot(3,2,3); bar(tempSub(11:15,11)); subplot(3,2,4); bar(tempSub(16:20,11));
subplot(3,2,5); bar(tempSub(21:25,11)); subplot(3,2,6); bar(tempSub(26:30,11));



%% Percent change 
% Plots for the TA 
figure; subplot(3,2,1); bar(tempSub3(1:5,4)); subplot(3,2,2); bar(tempSub3(6:10,4)); title('TA')
subplot(3,2,3); bar(tempSub3(11:15,4)); subplot(3,2,4); bar(tempSub3(16:20,4));
subplot(3,2,5); bar(tempSub3(21:25,4)); subplot(3,2,6); bar(tempSub3(26:30,4));
% Plots for the LGAS
figure; subplot(3,2,1); bar(tempSub3(1:5,5)); subplot(3,2,2); bar(tempSub3(6:10,5)); title('LGAS')
subplot(3,2,3); bar(tempSub3(11:15,5)); subplot(3,2,4); bar(tempSub3(16:20,5));
subplot(3,2,5); bar(tempSub3(21:25,5)); subplot(3,2,6); bar(tempSub3(26:30,5));
% Plots for the SOL
figure; subplot(3,2,1); bar(tempSub3(1:5,12)); subplot(3,2,2); bar(tempSub3(6:10,12)); title('SOL')
subplot(3,2,3); bar(tempSub3(11:15,12)); subplot(3,2,4); bar(tempSub3(16:20,12));
subplot(3,2,5); bar(tempSub3(21:25,12)); subplot(3,2,6); bar(tempSub3(26:30,12));

% Plots for the MGAS
figure; subplot(3,2,1); bar(tempSub3(1:5,14)); subplot(3,2,2); bar(tempSub3(6:10,14)); title('MGAS')
subplot(3,2,3); bar(tempSub3(11:15,14)); subplot(3,2,4); bar(tempSub3(16:20,14));
subplot(3,2,5); bar(tempSub3(21:25,14)); subplot(3,2,6); bar(tempSub3(26:30,14));

% Plots for the GMAX
figure; subplot(3,2,1); bar(tempSub3(1:5,15)); subplot(3,2,2); bar(tempSub3(6:10,15)); title('GMAX')
subplot(3,2,3); bar(tempSub3(11:15,15)); subplot(3,2,4); bar(tempSub3(16:20,15));
subplot(3,2,5); bar(tempSub3(21:25,15)); subplot(3,2,6); bar(tempSub3(26:30,15));

% Plots for the GMED
figure; subplot(3,2,1); bar(tempSub3(1:5,11)); subplot(3,2,2); bar(tempSub3(6:10,11)); title('GMED')
subplot(3,2,3); bar(tempSub3(11:15,11)); subplot(3,2,4); bar(tempSub3(16:20,11));
subplot(3,2,5); bar(tempSub3(21:25,11)); subplot(3,2,6); bar(tempSub3(26:30,11));


