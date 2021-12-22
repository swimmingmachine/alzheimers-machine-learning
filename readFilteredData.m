% Read filtered dem@care data May 2017, C. Bian

% Set root path
path='C:\Users\BianC\OneDrive - University of Toronto\DemCare\German Data\Filtered\Filtered';

% Get folders containing feature data only e.g. F1, F2,..., F5 ONLY
all_files = dir(path);
all_dir = all_files([all_files(:).isdir]);
all_dir = all_dir(~ismember({all_dir.name},{'.','..','src'}));

% Initiate feature data cell array to contain extracted feature data
rawData = cell(5,2);
dyadsInfo = cell(76,2);
% Loop through each folder (F1 - F5) and read feature data from each file
for n=1:numel(all_dir)
    fname=all_dir(n).name;
    folder=strcat(path,'\',fname);
    cd(folder);
    files = dir('*X*.dat');
    subjs = cell([78,3]);
    subjsWithTime = cell([78,3]);
    % Set up reference dataset for data interpolation later
%     refData = load(files(1).name);
%     refData = get24HourData(refData);
%     xqDt=[];
%     for q=1:length(refData)
%         xqDt=[xqDt,datetime(refData(q,1),'ConvertFrom','posixtime','Format','HH:mm:ss')];
%     end
    % 1. Loop through each file representing a subject
    % 2. Load 2nd column of each file as a temporary cell array
    % 3. Store this cell array and the corresponding dementia status (0 or
    % 1) into subjs cell array containing all subjects of this feature (e.g. F1)
    for i=1:length(files)
        data = load(files(i).name);
        if ~isempty(data)
            % extract 24 hour of data from all data(50 hours)
            data = get24HourData(data);
            % interpolate 24 hour data as reference to the first subject
            iData = interpData(data);
            % use the first column (raw value) of the 24h data, second
            % column is date
            subjs(i,1:3)={iData(:,1),files(i).name(8),files(i).name};
            %subjsWithTime(i,1:3)={iData(:,1:2),files(i).name(8),files(i).name};
            %subjs(i,1:3)={data(:,2),files(i).name(8),files(i).name};
            dyadsInfo(i,1:2)={files(i).name(8),files(i).name};
        end
    end
    % Write feature number and all subjects data associated with this
    % feature to featureData array
    rawData(n,1:2) = {n,subjs};
    %rawData(n,1:2) = {n,subjsWithTime};
end

save('rawData.mat','rawData');