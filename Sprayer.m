c1 = arduino();
clear c1;
c1 = arduino('COM5', 'Uno');
for i = 1:5
writeDigitalPin(c1, 'D9', 1);
pause(1);
writeDigitalPin(c1, 'D9', 0);
pause(1);
end
clear c1;