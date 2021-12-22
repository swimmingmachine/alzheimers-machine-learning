%Generate dyads data from raw sensor readings Jan 2017, S. S. Khan
path='N:\DemCare\German-Data';
all_files = dir(path);
all_dir = all_files([all_files(:).isdir]);
all_dir=all_dir(~ismember({all_dir.name},{'.','..'}));

%go into each directory and only take those into analysis who have two
%subjects
index=[];
for i=1:numel(all_dir);
    fname=all_dir(i).name;
    folder=strcat(path,'\',fname);
    folder=dir(folder);
    folder=folder(~ismember({folder.name},{'.','..'}));
    if (numel(folder)~=2)%if the pair is not present
        index=[index i];
    end
end
all_dir(index)=[]; %remove non-pair directories from analysis
num_dir = numel(all_dir);

SAMPLE_FREQ=50;
startTime=22;
endTime=startTime-1; %24 hour time window to capture data from
dem_data=cell(num_dir,1);
for i=1:num_dir %for each dyad
    fprintf('Directory %d\n',i);
    fname=all_dir(i).name;
    fpath=strcat(path,'\',fname);
    folder=dir(fpath);
    folder=folder(~ismember({folder.name},{'.','..'}));
    for j=1:numel(folder) %for each folder with data
        dpath=strcat(fpath,'\',folder(j).name);
        if(numel(strfind(dpath,'D0'))==1)
            label=0;
        else
            label=1;
        end
        raw=load(dpath);
        hours=raw(:,end);%values of all hours present in the recordings
        x1=zeros(length(hours)-1,1);
        %Find the index when hours change
        for k=1:length(hours)-1
            x1(k,1)=hours(k+1,1)-hours(k,1);
            x1(k,2)=hours(k,1);
            x1(k,3)=hours(k+1,1);
        end
        x=find(x1(:,1));
        temp=zeros(length(x),1);
        for k=1:length(x)
            temp(k,1)=x(k,1);
            temp(k,2)=x1(x(k,1),2);
            temp(k,3)=x1(x(k,1),3);
        end
        location=find(ismember(temp(:,2),endTime));%location of end time
        if (length(location)>=2) %if the whole cyclic period of recording is present
            startL=temp(location(1,1),1)+1;        
            endL=temp(location(2,1),1);% donot record if more than one 24h cycles are present
            data=raw(startL:endL,3:6);
            norms = sqrt(sum(data(:,1:3).^2,2));
            norms = [norms data(:,end)]; %add time label to norm
            dem_data{i,1}{j,1}=data;
            dem_data{i,2}{j,1}=norms;
            %normsN = filterNoise(norms);
            %dem_feat{i,1}(j,:)=normFeatures(norms,label,SAMPLE_FREQ);
        end
    end
end
%Only choose data from subjects with full cycle from 2200h to 2100h
demData=cell(1,1);
j=1;
for i=1:length(dem_feat)
    if(size(dem_feat{i,1},1)==2)
        demData{j,1}=dem_feat{i,1};
        j=j+1;
    end
end
save('demData.mat',demData);
%data1=load('N:\DemCare\German-Data\X001\GFD0-raw.dat');