function key = ookmodulation(input)
    if string(input) == "up"
        key = "1010";
    elseif string(input) == "down"
        key = "1100";    
    else
        key = "0000";     
    end    
end

function key = encoderPWM(input)
    if string(input) == "up"
        key = "1";
    elseif string(input) == "down"
        key = "0";
    else 
    end
end

function controlspray(bit)
    if strcmp(bit,'1010')
        writeDigitalPin(c1, 'D9', 1);
        pause(0.1);
        writeDigitalPin(c1, 'D9', 0);
        pause(0.1);
        writeDigitalPin(c1, 'D9', 1);
        pause(0.1);
        writeDigitalPin(c1, 'D9', 0);
    elseif strcmp(bit,'1100')
        writeDigitalPin(c1, 'D9', 1);
        pause(0.1);
        writeDigitalPin(c1, 'D9', 0);
        pause(0.25);
        writeDigitalPin(c1, 'D9', 1);
        pause(0.1);
        writeDigitalPin(c1, 'D9', 0);
    end
end
