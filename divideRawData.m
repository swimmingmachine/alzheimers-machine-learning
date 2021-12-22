% Domain knowledge feature extraction - dem@care data - Dec 2017, Chao Bian
%function divideRawData(rawData)

% load 24h raw data
%load('rawData.mat')
% init 4 cell arrays containing data from 4 sections
mid2morningRawData = cell(5,2);
morningRawData = cell(5,2);
afternoonRawData = cell(5,2);
afternoon2midRawData = cell(5,2);

for x=1:size(rawData,1)
    for y=1:size(rawData{x,2},1)
        if ~isempty(rawData{x,2}{y,1})
            % create index array for dividing 24h data into 4 sections (pre-midnight, post-midnight, morning, afternoon)
            % divide the size of 24h raw data by 24 to get hourly data index
            hourlySize = floor(size(rawData{x,2}{y,1},1)/24);
            % determine section start/end index
            midnightStartIndex = hourlySize * 2 + 1;
            morningStartIndex = midnightStartIndex + hourlySize * 6;
            afternoonStartIndex = morningStartIndex + hourlySize * 6;
            eveningStartIndex = afternoonStartIndex + hourlySize * 6;
            %sectionIndex = [midnightStartIndex, morningStartIndex, afternoonStartIndex, eveningStartIndex];

            % copy unchanged fields in raw dataset to sub datasets
            mid2morningRawData(x,1) = rawData(x,1);
            mid2morningRawData{x,2}(y,2:3) = rawData{x,2}(y,2:3);
            morningRawData(x,1) = rawData(x,1);
            morningRawData{x,2}(y,2:3) = rawData{x,2}(y,2:3);
            afternoonRawData(x,1) = rawData(x,1);
            afternoonRawData{x,2}(y,2:3) = rawData{x,2}(y,2:3);
            afternoon2midRawData(x,1) = rawData(x,1);
            afternoon2midRawData{x,2}(y,2:3) = rawData{x,2}(y,2:3);

            % divide rawData and store data in corresponding section
            mid2morningRawData{x,2}(y,1) = {rawData{x,2}{y,1}(midnightStartIndex:morningStartIndex-1,1)};
            morningRawData{x,2}(y,1) = {rawData{x,2}{y,1}(morningStartIndex:afternoonStartIndex-1,1)};
            afternoonRawData{x,2}(y,1) = {rawData{x,2}{y,1}(afternoonStartIndex:eveningStartIndex-1,1)};
            afternoon2midRawData{x,2}(y,1) = {[rawData{x,2}{y,1}(eveningStartIndex:size(rawData{x,2}{y,1},1),1);rawData{x,2}{y,1}(1:morningStartIndex-1,1)]};

            %extract features test
            %{
            detectIntervals(mid2morningRawData); 
            detectIntervals(morningRawData);
            detectIntervals(afternoonRawData);
            detectIntervals(afternoon2midRawData);
            %}
        end
    end
end

