clear
clc
clf
a = arduino('COM4','Uno');
threshold = 2.2;
disp('start')
i = 0;
while 1
        v = readVoltage(a,'A0');
        disp(v)
        if v > threshold  
                i = i + 1;
                disp('toggle')
                disp(i)             
                writeDigitalPin(a,'D9',1);
                pause(0.1)
                writeDigitalPin(a,'D9',0);
                pause(5)
        end        
end