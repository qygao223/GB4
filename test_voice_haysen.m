arduino = serial('COM5', 'BaudRate', 9600);
fopen(arduino);

function [outpulse, PWM] = encoderPWM(input)
    if string(input) == "up"
        outpulse = "1";
        PWM = 0.1;
    elseif string(input) == "down"
        outpulse = "0";
        PWM = 0.25;
    else 
        return; % Handle other cases if needed
    end
    
    % Send the outpulse to the Arduino
    fwrite(arduino, outpulse);
    
    disp(PWM);
end

encoderPWM(YMode);
pause(0.1); % Adjust the delay duration as needed

fclose(arduino);
