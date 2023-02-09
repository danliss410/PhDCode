function normalizedData = normalizeC(someData,newLength)
%someData is a nxk chunk of activation coefficients for a single
%trial/task, n is nSyn, k is time length of C
if nargin == 1
    newLength = 100;
    warning('no normalize length specified - using default value of 100')
end
for n = 1:size(someData,1)
    normalizedData(n,:) = interp1(1:size(someData,2), someData(n,:), linspace(1,size(someData,2),newLength));
end

