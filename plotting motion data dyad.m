% combine multiple plots

%set up parent panel
f = figure;
p=uipanel('Parent', f, 'BorderType','none');
p.Title = 'Motion Data from a Dyad'
p.TitlePosition = 'centertop';
p.FontSize = 12;
p.FontWeight = 'bold';

%draw sub plot
plot1 = subplot(1,2,1,'Parent',p)
plot(0:24/length(rawData{1,2}{1,1}):23.999, normData1)
title('Heahlth Control','FontSize',16)
xlabel(plot1,'time (h)','FontSize',14)
ylabel(plot1,'acceleration','FontSize',14)

plot2 = subplot(1,2,2,'Parent',p)
plot(0:24/length(rawData{1,2}{2,1}):23.999, normData2)
 title('Patient with AD','FontSize',16)
xlabel(plot2,'time (h)','FontSize',14)
ylabel(plot2,'acceleration','FontSize',14)
