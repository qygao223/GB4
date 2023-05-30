clear c1;
c1 = arduino('COM5', 'Uno');

data = [1 0 1 0 1 0 1 0];
t = 14; %sampling period

for i = 1:length(data)
    if data(i) == 0
        writeDigitalPin(c1, 'D9', 1);
        pause(0.03);
        writeDigitalPin(c1, 'D9', 0);
        pause(0.01);
        writeDigitalPin(c1, 'D9', 1);
        pause(0.03);
        writeDigitalPin(c1, 'D9', 0);
        pause(t);
    elseif data(i) == 1
        writeDigitalPin(c1, 'D9', 1);
        pause(0.03);
        writeDigitalPin(c1, 'D9', 0);
        pause(0.4);
        writeDigitalPin(c1, 'D9', 1);
        pause(0.03);
        writeDigitalPin(c1, 'D9', 0);
        pause(t);
    else 
        pause(t+0.46);

    end
end

clear c1;