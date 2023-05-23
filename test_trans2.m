clear c1;
c1 = arduino('COM5', 'Uno');

writeDigitalPin(c1, 'D9', 1);
pause(0.03);
writeDigitalPin(c1, 'D9', 0);
pause(0.2);
writeDigitalPin(c1, 'D9', 1);
pause(0.03);
writeDigitalPin(c1, 'D9', 0);
pause(20);

writeDigitalPin(c1, 'D9', 1);
pause(0.03);
writeDigitalPin(c1, 'D9', 0);
pause(0.01);
writeDigitalPin(c1, 'D9', 1);
pause(0.03);
writeDigitalPin(c1, 'D9', 0);
pause(20);

writeDigitalPin(c1, 'D9', 1);
pause(0.03);
writeDigitalPin(c1, 'D9', 0);
pause(0.2);
writeDigitalPin(c1, 'D9', 1);
pause(0.03);
writeDigitalPin(c1, 'D9', 0);
pause(20);

writeDigitalPin(c1, 'D9', 1);
pause(0.03);
writeDigitalPin(c1, 'D9', 0);
pause(0.01);
writeDigitalPin(c1, 'D9', 1);
pause(0.03);
writeDigitalPin(c1, 'D9', 0);
pause(20);


clear c1;