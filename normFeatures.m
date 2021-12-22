%Features based on magnitude of accelerometer - Jan 2017
function [feature]= normFeatures(aNorm,label,SAMPLE_FREQ)%,winSize)

%feature=zeros(1,19); %Number of features

%Mean Features
feature(1,1)=mean(aNorm);
%Max Features
feature(1,2) = max(aNorm);
%Min Features
feature(1,3) = min(aNorm);
%Std Deviation Features
feature(1,4)=std(aNorm);
%IQR features
IQR=quantile(aNorm,[0.25 0.75]);
feature(1,5)=IQR(2)-IQR(1);

%Frequency features
h=spectrum.welch('Hamming',length(aNorm)); 
Hpsd=psd(h,aNorm,'Fs',SAMPLE_FREQ,'ConfLevel',0.95);
feature(1,6)=Hpsd.avgpower;%/winSize;%Total Avg Power
%spectral entropy [0 10] band
%Advancing from Offline to Online Activity Recognition with Wearable Sensors
nHpsd=Hpsd.Data/sum(Hpsd.Data);%Normalize
SE=0;
for x=1:length(Hpsd.Frequencies)
    SE = nHpsd(x)*log(nHpsd(x)) + SE;
end
feature(1,7)=-SE/log(x-1);

%FFT
m = length(aNorm);     % Window length
n = pow2(nextpow2(m));  % Transform length
%n=4320000;
y = fft(aNorm,n);           % DFT
%y=y(1:4321,1);
%f = (0:n-1)*(SAMPLE_FREQ/n);     % Frequency range
power = sqrt(y.*conj(y));   % Power of the DFT
feature(1,8)=power(1);
power(1)=[];%remove dc component
% % power=power/winSize;%Normalize
% %feature(1,6)=power(1);
% z=fftshift(y);
% P2 = abs(z/n);
% P1 = P2(1:n/2+1);
% P1(2:end-1) = 2*P1(2:end-1);
% f = SAMPLE_FREQ*(0:(n/2))/n;
% %plot(f,P1)
% F=f(2:end);
% blockIndex=1:length(F)/25:length(F);
% for i=1:length(blockIndex)-1
%     starti=blockIndex(i);
%     endi=blockIndex(i+1)-1;
%     freq=P1(starti:endi);
%     feature(1,6+i)=norm(freq)/length(F)/25;
% end

% freq=1:1:SAMPLE_FREQ/2;
% total_power=bandpower(aNorm,SAMPLE_FREQ,[1 25]);
% for i=1:length(freq)-1
%     feature(1,6+i)=bandpower(aNorm,SAMPLE_FREQ,[freq(1,i) freq(1,i+1)])/total_power;
% end

%Activity Recognition from User-Annotated Acceleration Data
feature(1,9)=norm(power)/n;
FFTE=0;
for x=1:length(power)
    FFTE = FFTE + power(x)*log(power(x));
end
feature(1,10)= -FFTE;
%feature(1,9:4320+8)=power;
%Correlation between ax,ay and az
% feature(1,29)= corr(ax,ay);
% feature(1,30)= corr(ay,az);
% feature(1,31)= corr(ax,az);
if label == 2
    label = 1;
end
feature(1,11)=label;%Add class label 0/1
% fprintf('New-features\n');
