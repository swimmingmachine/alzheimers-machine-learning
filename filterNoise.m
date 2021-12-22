%Perform filtering of noise
function [data]=filterNoise(Ndata)
fprintf('\n--> Filtering');
%Butterworth Filter
[z, p, k]=butter(1,0.005,'low');
[sos,g] = zp2sos(z,p,k);
h = dfilt.df2tsos(sos,g);
data = filter(h, Ndata);%smooth but ignore the label - Only consider the calibrated data
%fprintf('filter\n');