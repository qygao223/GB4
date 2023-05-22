clear
clc
clf
a = arduino('COM4','Uno');

%change the words to change the plot title and saved file name, change
%every time you adjust distance and concentration.
title_words = 'Sensor Voltage - 100%, 30cm';

h = animatedline;
ax = gca;
xlabel('Time(sec)');
ylabel('Voltage(V)');
title(title_words);
ax.YLim = [0 5.2];
grid on;
startTime = datetime('now');
time = 0.0;

%change the run time so you can see the whole impulse response
run_time = 60.0;

% the following two arrays get saved as a matlab matrix file to your
% computer every time you run the program
t_array = [];
sensor_data = [];

while time < run_time
    v = readVoltage(a,'A0'); 
    t =  datetime('now') - startTime;
    addpoints(h,datenum(t),v);
    ax.XLim = datenum([t-seconds(run_time) t]);
    datetick('x','keeplimits');
    drawnow limitrate;
    t_array(end+1) = seconds(t);
    time = seconds(t);
    sensor_data(end+1) = v;

end

%Combines the time and sensor values into a matrix that is saved as a file
%onto your computer. Also saves an image of the plot. You must also change
%the numbers in the matrix name here if you change conditions like distance
%and concentration, as well as the title_words at the start.
matrix100_30 = [t_array;sensor_data];
save(title_words, 'matrix100_30')
plot(t_array,sensor_data)
ylim([0 5])
f = gcf;
title_file = append(title_words,'.png');
exportgraphics(f,title_file,'Resolution',300)