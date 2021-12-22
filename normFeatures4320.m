%Features based on magnitude of accelerometer - Jan 2017
function [feature]= normFeatures4320(aNorm,label)%,SAMPLE_FREQ,winSize)

%FFT
%m = length(aNorm);     % Window length
%n = pow2(nextpow2(m));  % Transform length
n=4320000;
y = fft(aNorm,n);           % DFT
power = sqrt(y.*conj(y));
energy = sum(power);
%y=y(1:4321,1);
%f = (0:n-1)*(SAMPLE_FREQ/n);     % Frequency range
power = power/energy;   % Power of the DFT
power(1)=[];%remove dc component
feature=power(1:4320,1)';
if label == 2
    label = 1;
end
feature(1,end+1)=label;%Add class label 0/1
% fprintf('New-features\n');
