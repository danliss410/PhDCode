
subjects = {'02';'03';'04';'05';'07';'08';'09';'11';'12';'13';'14';'15';'17';};
for i = 1:13
    subject = subjects{i};
    fileLocation = 'G:\Shared drives\NeuroMobLab\Experimental Data\Log Files\Pilot Experiments\PerceptionStudy\';
    subjectYesNo = ['YAPercep' subject '_YesNo'];
    subjectCog   = ['YAPercep' subject '_Cog'];
    subject1     = ['YAPercep' subject];
    name = {};

    data1.(subjectYesNo)= readtable([fileLocation subjectYesNo]);
    data.(subjectYesNo) = data1.(subjectYesNo)(:,[1,2,3,6,9]);
    name                = (subjectYesNo);
    data3.(subjectCog)  = readtable([fileLocation subjectCog]);
    data2.(subjectCog)   = data3.(subjectCog)(:,[1,2,3,6,9]);
    name                = {name; subjectCog}; 
end

for i = 1:13
    S = fieldnames(data);
    S2 = fieldnames(data2);
    left1                                        = strncmp('L', data.(S{i}).LegIn,1);
    right1                                       = strncmp('R', data.(S{i}).LegIn,1);

    dv_r1                                        = data.(S{i}).dV(right1);
    dv_l1                                        = data.(S{i}).dV(left1);
    
    left2                                        = strncmp('L', data2.(S2{i}).LegIn,1);
    right2                                       = strncmp('R', data2.(S2{i}).LegIn,1);

    dv_r2                                        = data2.(S2{i}).dV(right2);
    dv_l2                                        = data2.(S2{i}).dV(left2);

    vel                                         = unique(data.(S{i}).dV);
    neg_v                                       = flip(vel(vel<=0));
    percepR1                                 = data.(S{i}).perceived(right1);
    percepL1                                 = data.(S{i}).perceived(left1);
    percepR2                                 = data2.(S2{i}).perceived(right2);
    percepL2                                 = data2.(S2{i}).perceived(left2);

    for iVel                                = 1:length(neg_v)
        temp.(S{i}){:,iVel}    = percepR1(dv_r1 == neg_v(iVel));
        temp2.(S{i}){:,iVel}   = percepL1(dv_l1 == neg_v(iVel));
        perNegR.(S{i})(iVel) = sum(temp.(S{i}){:,iVel});
        perNegL.(S{i})(iVel) = sum(temp2.(S{i}){:,iVel});
        
        temp3.(S2{i}){:,iVel}    = percepR2(dv_r2 == neg_v(iVel));
        temp4.(S2{i}){:,iVel}   = percepL2(dv_l2 == neg_v(iVel));
        perNegR2.(S2{i})(iVel) = sum(temp3.(S2{i}){:,iVel});
        perNegL2.(S2{i})(iVel) = sum(temp4.(S2{i}){:,iVel});
    end
    tempLNorm(i,:) = perNegL.(S{i});
    tempRNorm(i,:) = perNegR.(S{i});
    tempLCog(i,:) = perNegL2.(S2{i});
    tempRCog(i,:) = perNegR2.(S2{i});
end

new = tempLNorm+tempRNorm;
new2 = tempLCog+tempRCog;

