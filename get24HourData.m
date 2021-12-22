function data = get24HourData(data)
% this function is used to extract 24 hour of data from raw data files
% based on timestamps
% data = load('C:\Users\BianC\OneDrive - University of Toronto\DemCare\German Data\Filtered\Filtered\F1\X001GFD0.dat');
startPosition = 0;
endPosition = 0;
startDay = 0;
h = 0;
for i=1:length(data)
    % get hour and previous hour value
    preH = h;
    h = datetime(data(i,1),'ConvertFrom','posixtime').Hour;
    % find the first 22 o'clock as start point
    if h == 22 && h > preH
        % record start sample position and assign start day to startDay var
        if startPosition == 0 && startDay == 0
            d = datetime(data(i,1),'ConvertFrom','posixtime').Day;
            startPosition = i;
            startDay = d;
            % from start sample position, do loop until reaching next day
            for j=i:length(data)
                m = datetime(data(j,1),'ConvertFrom','posixtime').Day;
                if m == startDay + 1
                    i = j;
                    break
                end
            end
        % use updated var i to find end day and end position    
        elseif startPosition ~= 0 && startDay ~= 0 && endPosition == 0
            endDay = datetime(data(i,1),'ConvertFrom','posixtime').Day;
            if endDay == startDay + 1 || endDay == 1
                endPosition = i-1;
                break
            end
        end
    end
end

% get 24h data out of an average of 50h data based on start and end
% position found previously
if endPosition == 0
    endPosition = length(data);
    data = data(startPosition:endPosition,1:2);
else
    data = data(startPosition:endPosition,1:2);
end
