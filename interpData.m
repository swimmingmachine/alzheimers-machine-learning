function iData = interpData(data)
% extract date time column 
dt=[];

% dataset to be interpolated
for p=1:length(data)
    %dt2=[dt2,datetime(data(p,1),'ConvertFrom','posixtime','Format','HH:mm:ss')];
    dt=[dt,datetime(data(p,1),'ConvertFrom','posixtime')];
end

% calculate xq
startDt = datetime(data(1,1),'ConvertFrom','posixtime');
startDt = datetime(startDt.Year,startDt.Month,startDt.Day,22,00,00);

endDt = datetime(data(length(data),1),'ConvertFrom','posixtime');
endDt = datetime(endDt.Year,endDt.Month,endDt.Day,21,59,59);
%xq contains the query points - datetime
xq = linspace(startDt, endDt, length(data)-1); 
%interpolation
iData = interp1(dt, data(:,2), xq,'spline');

iData(isnan(iData))=[];
iData = iData.';

