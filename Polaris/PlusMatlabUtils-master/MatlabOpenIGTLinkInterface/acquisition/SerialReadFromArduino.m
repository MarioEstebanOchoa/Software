clear
close all
clc
s=serial('COM6','BaudRate',9600);
fopen(s);



%% Acquire and display live data
figure
h = animatedline;
ax = gca;
ax.YGrid = 'on';
ax.YLim = [0 100];

stop = false;
startTime = datetime('now');
for i=1:5000
    % Read current voltage value
    Volts = fscanf(s,'%f') 
    % Calculate temperature from voltage (based on data sheet)
    % Get current time
    %t =  datetime('now') - startTime;
    % Add points to animation
    %if i>50
    %    addpoints(h,datenum(t),Volts)
    %end
    % Update axes
    %ax.XLim = datenum([t-seconds(15) t]);
    %datetick('x','keeplimits')
    %drawnow
    % Check stop condition
    %stop = readDigitalPin(a,'D12');
    %flushinput(s)
end

fclose(s);
delete(s);