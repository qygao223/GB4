clear
clc
clf
a = arduino('COM19','Uno');
% PWM
rise_flag = false;
%OOK
start=tic;
get_result = false;
%change the words to change the plot title and saved file name, change
%every time you adjust distance and concentration.
title_words = 'Sensor Voltage - PWM test 15-20s series';

h = animatedline;
ax = gca;
xlabel('Time(sec)');
ylabel('Voltage(V)');
title(title_words);
ax.YLim = [0 5];
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
    detectionPWM(v)

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

function [key, result]=detectionPWM(input)
    global rise_flag;
    global start_time;
    % before rise detected
    if ~rise_flag && input > 1
        start_time = tic;
        disp(toc(start_time))
        rise_flag = true;
    % after rise detected, find if up or down
    elseif input > 1 && rise_flag
        now_time=tic;
        if toc(now_time)-toc(start_time) ==2 %within rise time period
            if input > 2.7
                % Set HIGH output
                result="up";
                key = "1010";
                % Replace with your code to output a HIGH signal to the Arduino
            elseif input > 1 && input <= 2
                % Set LOW output
                result="down";
                key = "1100";
                % Replace with your code to output a LOW signal to the Arduino
            end
            fprintf([key, result, toc(now_time)]);
        % enough time for spary to recover, ready for next detection
        elseif toc(now_time)-toc(start_time) >20 %fall time
            rise_flag=false;
            start_time=0;
        end
    else
        t=0;
    end
end

function result=detectionook(input)
    global get_result
    now=tic;
    interval=toc(now)-toc(start);
    if mod(floor(interval) /20)>0
        if mod(floor(interval)/5) ==0 && get_result == false
            if input > 1
                result="up";
            else
                result="down";
            end
            get_result = true;
            fprintf(result) 
        end
    else
        get_result = false;
    end
end

function controlDrone(c1,bit)
    if strcmp(bit,'1010')
        writeDigitalPin(c1, 'D10', 1);
    elseif strcmp(bit,'1100')
        writeDigitalPin(c1, 'D10', 0);
    end
end
