clear
clc
clf
a = arduino('COM19','Uno');
global rise_flag;
rise_flag = false;
%change the words to change the plot title and saved file name, change
%every time you adjust distance and concentration.
title_words = 'Sensor Voltage - PWM test 15-20s series';

h = animatedline;
ax = gca;
xlabel('Time(sec)');
ylabel('Voltage(V)');
title(title_words);
ax.YLim = [0 3];
grid on;
startTime = datetime('now');
time = 0.0;

%change the run time so you can see the whole impulse response
run_time = 120.0;

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
    detection(v)

end

%Combines the time and sensor values into a matrix that is saved as a file
%onto your computer. Also saves an image of the plot. You must also change
%the numbers in the matrix name here if you change conditions like distance
%and concentration, as well as the title_words at the start.
matrix100_30 = [t_array;sensor_data];
save(title_words, 'matrix100_30')
plot(t_array,sensor_data)
ylim([0 3])
f = gcf;
title_file = append(title_words,'.png');
exportgraphics(f,title_file,'Resolution',300)


function result=detection(input)
    interval = 20;
    global rise_flag;
    if ~rise_flag && input > 0.75
        t = tic;
        disp(toc(t))
        rise_flag = true;
    elseif input > 0.75 && rise_flag
        if mod(floor(toc(t)),interval) == 0
            if input > 1.33
                % Set HIGH output
                result="up";
                % Replace with your code to output a HIGH signal to the Arduino
                fprintf([result, floor(toc(t))]);
            elseif input > 0.75 && input <= 1.1
                % Set LOW output
                result="down";
                % Replace with your code to output a LOW signal to the Arduino
                fprintf([result, floor(toc(t))]);
            end
        end
    else
        t=0;
    end
end



function pulsemodulation(input)
% Set the duration and time intervals
duration = 60; % Duration in seconds
interval = 20; % Interval in seconds

% Create a timer
t = tic;

while toc(t) <= duration
    % Check the time intervals
    if mod(floor(toc(t)),interval) == 0
        % First interval (0-20 sec): Input > 1.33, HIGH output
        input = readVoltage(a,'A0');% Replace with your code to read the input value
        
        if input > 1.33
            % Set HIGH output
            % Replace with your code to output a HIGH signal to the Arduino
            fprintf('Time: %.2f sec, Input: %.2f, Output: HIGH\n', toc(t), input);
        end
        
    elseif mod(floor(toc(t)/interval), 3) == 1
        % Second interval (20-40 sec): 0.75 < Input <= 1.33, LOW output
        input = readVoltage(a,'A0');% Replace with your code to read the input value
        
        if input > 0.75 && input <= 1.33
            % Set LOW output
            % Replace with your code to output a LOW signal to the Arduino
            fprintf('Time: %.2f sec, Input: %.2f, Output: LOW\n', toc(t), input);
        end
        
    else
        % Third interval (40-60 sec): Input <= 0.75, Ignore
        input = readVoltage(a,'A0');% Replace with your code to read the input value
        
        if input <= 0.75
            fprintf('Time: %.2f sec, Input: %.2f, Ignored\n', toc(t), input);
        end
    end
    
    % Add a small delay between iterations if needed
    % pause(0.01);
end
end