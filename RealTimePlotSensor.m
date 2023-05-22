clear
clc
clf
a = arduino('COM4','Uno');

title_words = 'Real-Time Plot';

h = animatedline;
ax = gca;
xlabel('Time(sec)');
ylabel('Voltage(V)');
title(title_words);
ax.YLim = [0 5.2];
grid on;
startTime = datetime('now');
time = 0.0;

t_array = []; 
sensor_data = [];

while 1
    v = readVoltage(a,'A0'); 
    t =  datetime('now') - startTime;
    addpoints(h,datenum(t),v);
    ax.XLim = datenum([t-seconds(15) t]);
    datetick('x','keeplimits');
    drawnow limitrate;
    t_array(end+1) = seconds(t);
    time = seconds(t);
    sensor_data(end+1) = v;

end

