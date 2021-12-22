%algorithm for detecting dynamic and static interval
function [domainKnowledgeFeature] = detectIntervals(rawDataPerSubject)
%argument of this function is the raw data array generated from
%readFilteredData.m

%set a threshold for 
threshold = 4;
samplingInterval = 20;
dynamicStartConsecutiveCount = 0;
staticStartConsecutiveCount = 0;
dynamicStart = 0;
staticStart = 0;
dynamicSampleCounter = 0;
staticSampleCounter = 0;
rawDynamicIntervalData = cell(5,2);
rawStaticIntervalData = cell(5,2);
m=1;
n=1;
dynamicIntervalsCounter = 0;
staticIntervalsCounter = 0;
%normalize data
%normData = zscore(rawData{1,2}{1,1});

% figure set up
%{
figure;
h = zeros(2,1);
%}

%loop every sample
for f=1:size(rawDataPerSubject)
    
    if rawDataPerSubject(f,1) > threshold
        dynamicStartConsecutiveCount = dynamicStartConsecutiveCount+1;
        if dynamicStartConsecutiveCount > 10 %one sample represents 20s in 50mHz sampling rate, therefore 200 seconds as threshold
            % before change dynamic/static flag, use the first entry of
            % this if statement as a count to interval counter
            if dynamicStart == 0 
                dynamicIntervalsCounter = dynamicIntervalsCounter + 1; % feature 3
            end
            %set dynamic flag
            dynamicStart = 1;
            %disp('dynamic');
            %reset static flag
            staticStart = 0;
            % count # of samples associated with dynamic events - feature 1
            dynamicSampleCounter = dynamicSampleCounter+1;
            %reset consecutive counter
            staticStartConsecutiveCount = 0;
            %store dynamic raw data in a new cell array with the same
            %structure
            rawDynamicIntervalData{1,2}{1,1}(m,1) = rawDataPerSubject(f,1);
            m=m+1;
        end
        % plot
        %h(1) = plot(f*20/60/60,rawData{1,2}{1,1}(f,1),'ro');
    end
    if rawDataPerSubject(f,1) < threshold
        staticStartConsecutiveCount = staticStartConsecutiveCount+1;
        if staticStartConsecutiveCount > 10
            if staticStart == 0 
                staticIntervalsCounter = staticIntervalsCounter + 1; % feature 4
            end
            %set static flag
            staticStart = 1;
            %disp('static');
            %reset dynamic flag
            dynamicStart = 0;
            % count # of samples associated with static events - feature 2
            staticSampleCounter = staticSampleCounter +1;
            %reset consecutive counter
            dynamicStartConsecutiveCount = 0;
            %store static raw data in a new cell array with the same
            %structure
            rawStaticIntervalData{1,2}{1,1}(n,1) = rawDataPerSubject(f,1);
            n=n+1;
        end
        % plot
        %h(2) = plot(f*20/60/60,rawData{1,2}{1,1}(f,1),'b+');
    end
    %hold on;
end

% calculate TOTAL duration of dynamic and static interval in unit of hours 
totalDynamicIntervalDuration = dynamicSampleCounter * samplingInterval / 60 / 60;
totalStaticIntervalDuration = staticSampleCounter * samplingInterval / 60 / 60;

% extract domain knowledge features and generate feature matrix
domainKnowledgeFeature(1,1)= totalDynamicIntervalDuration; % feature 1 - total Dynamic Interval duration
domainKnowledgeFeature(1,2)= totalStaticIntervalDuration; % feature 2 - total static Interval duration
domainKnowledgeFeature(1,3)= dynamicIntervalsCounter; % feature 3 - total # of dynamic intervals
domainKnowledgeFeature(1,4)= staticIntervalsCounter; % feature 4 - total # of static intervals

% display test
%{ 
disp(dynamicSampleCounter);
disp(staticSampleCounter);
disp(totalDynamicInterval);
disp(totalStaticInterval);
disp(dynamicIntervalsCounter);
disp(staticIntervalsCounter);
%}

% figure plotting
%{
hold off;
title('Healthy Person','FontSize',16)
xlabel('time (h)','FontSize',14)
ylabel('acceleration','FontSize',14)
legend(h,'Dynamic Event','Static Event')
%}