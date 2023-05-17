%run("D:\matlab_file\SpeechRecognizer\commandRecognition.m");
clear c1;
c1 = arduino('COM18', 'Uno');

while true
    input= YMode;
    [bit1, time1] = ookmodulation(input);
    [bit2, time2] = encoderPWM(input);
    controlspray(time1);
end


function [key, spary_time] = ookmodulation(input)
    if string(input) == "up"
        key = "1010";
        % input pulse is the binary expression of spary_time*100(factor changed according to tests)
        spary_time = bin2dec(key)*0.01;
    elseif string(input) == "down"
        key = "11001";
        spary_time = bin2dec(key)*0.01;
    else 
    end
    
end

function [outpulse, PWM] = encoderPWM(input)
    if string(input) == "up"
        outpulse = "1";
        PWM = 0.1;
    elseif string(input) == "down"
        outpulse = "0";
        PWM = 0.25;
    else 
    end
end

function controlspray(time)
    writeDigitalPin(c1, 'D9', 1);
    pause(0.1);
    writeDigitalPin(c1, 'D9', 0);
    pause(time);
    writeDigitalPin(c1, 'D9', 1);
    pause(0.1);
    writeDigitalPin(c1, 'D9', 0);
end

