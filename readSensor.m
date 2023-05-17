clear
clc
clf

%Press ctrl+C to exit"

try
% create instance of arduino object
a = arduino('COM33','Nano');

%set-up graph
h = animatedline;
% set axis using get current axis(gca)
ax = gca;
% set x-axis label
xlabel('Time(sec)');
% set x-axis label
ylabel('Voltage(V)');
% set title for graph
title('Potentiometer Voltage Graph');
% set y-axis limit from 0 to 5.2V
ax.YLim = [0 5.2];
% turn on grid
grid on;

% set start time
startTime = datetime('now');

while 1
    % Read current voltage value
    v = readVoltage(a,'A1');   
    % Get current time
    t =  datetime('now') - startTime;
    % Add points to animation
    addpoints(h,datenum(t),v);
    % Update X-axis limit
    ax.XLim = datenum([t-seconds(10) t]);
    datetick('x','keeplimits');
    drawnow limitrate;
end

catch
    %in case of error or arduino gets disconnected
    disp('Failed!');
    clear;
    close;
end

