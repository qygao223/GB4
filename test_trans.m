clear c1;
c1 = arduino('COM5', 'Uno');

writeDigitalPin(c1, 'D9', 1);
pause(0.03);
writeDigitalPin(c1, 'D9', 0);
pause(0.01);
writeDigitalPin(c1, 'D9', 1);
pause(0.03);
writeDigitalPin(c1, 'D9', 0);
pause(0.03);

clear c1;

clear c1;
c1 = arduino('COM5', 'Uno');

controlDrone(c1,'1010')
pause(1);

controlDrone(c1,'1100')
pause(1.5);

function controlDrone(c1,bit)
    if strcmp(bit,'1010')
        writeDigitalPin(c1, 'D10', 1);
    elseif strcmp(bit,'1100')
        writeDigitalPin(c1, 'D10', 0);
    end
end