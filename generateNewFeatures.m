%Features based on x,y,z and magnitude of accelerometer and gyroscope
function [feature]= generateNewFeatures(aNorm,SAMPLE_FREQ)

feature=zeros(1,19); %Number of features

%Mean Features
feature(1,1)=mean(aNorm);

%Max Features
feature(1,2) = max(aNorm);

%Min Features
feature(1,3) = min(aNorm);

%Std Deviation Features
feature(1,16)=std(aNorm);

%IQR features
IQR=quantile(aNorm,[0.25 0.75]);
feature(1,21)=IQR(2)-IQR(1);


%Frequency features
h=spectrum.welch('Hamming',length(aNorm)); 
Hpsd=psd(h,aNorm,'Fs',SAMPLE_FREQ,'ConfLevel',0.95);
feature(1,24)=Hpsd.avgpower;%/winSize;%Total Avg Power
%spectral entropy [0 10] band
%Advancing from Offline to Online Activity Recognition with Wearable Sensors
nHpsd=Hpsd.Data/sum(Hpsd.Data);%Normalize
SE=0;
for x=1:length(Hpsd.Frequencies)
    SE = nHpsd(x)*log(nHpsd(x)) + SE;
end
feature(1,25)=-SE/log(x-1);

%FFT
m = length(aNorm);     % Window length
n = pow2(nextpow2(m));  % Transform length
y = fft(aNorm,n);           % DFT
%f = (0:n-1)*(SAMPLE_FREQ/n);     % Frequency range
power = y.*conj(y)/n;   % Power of the DFT
%power=power/winSize;%Normalize
feature(1,26)=power(1);
%Activity Recognition from User-Annotated Acceleration Data
power(1)=[];%remove dc component
feature(1,27)=norm(power);
FFTE=0;
for x=1:length(power)
    FFTE = FFTE + power(x)*log(power(x));
end
feature(1,28)= -FFTE;

%Correlation between ax,ay and az
feature(1,29)= corr(ax,ay);
feature(1,30)= corr(ay,az);
feature(1,31)= corr(ax,az);
% fprintf('New-features\n');
