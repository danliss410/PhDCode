% Modified Median Filter
% Callum Funk
% Last Edit: 11/30/2020, 1258
%
% Replaces low confidence predictions from DLC with median of surrounding
% predictions. Median filter window size dynamically adjusts to maintain
% symmetry at edges of predictions.
%
% PARAMS:
%
%   REQUIRED:
%    estimatedData - the table from readtable("[PATH TO PREDICTIONS CSV]")
%    
%   OPTIONAL:
%    medFiltBinSize - the window size for the filter (default 7)
%    pCutoff - the confidence threshold (default 0.98)

function out = modifiedMedianFilter(estimatedData, medFiltBinSize, pCutoff)
    
    if ~exist('medFiltBinSize', 'var')
                medFiltBinSize = 7;
    end
    if ~exist('pCutoff', 'var')
                pCutoff = 0.98;
    end
    
    for i = 1:size(estimatedData(:,:),1)
        if estimatedData(i, 4) < pCutoff
            if (i*2 - 1) < medFiltBinSize || ((size(estimatedData(:,:),1) - i + 1)*2 - 1) < medFiltBinSize
                binSize = min(i*2-1, ((size(estimatedData(:,:),1) - i + 1)*2 - 1));
            else
                binSize = medFiltBinSize;
            end

            if binSize == 1
                continue
            end

            subset = estimatedData(i-(binSize-1)/2:i+(binSize-1)/2,2);
            estimatedData(i,2) = median(subset);
            subset = estimatedData(i-(binSize-1)/2:i+(binSize-1)/2,3);
            estimatedData(i,3) = median(subset);
        end
    end

    out = estimatedData;
end