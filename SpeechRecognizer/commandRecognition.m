%This code detects commands ["UP" OR "DOWN"] using streaming audio from microphone. 
clear c1;
c1 = arduino('COM18', 'Uno');
load('commandNet.mat') %loads the pretrained network
fs = 16e3;
classificationRate = 20;
adr = audioDeviceReader('SampleRate',fs,'SamplesPerFrame',floor(fs/classificationRate));

audioBuffer = dsp.AsyncBuffer(fs);

labels = trainedNet.Layers(end).Classes;
YBuffer(1:classificationRate/2) = categorical("background");

probBuffer = zeros([numel(labels),classificationRate/2]);

countThreshold = ceil(classificationRate*0.2);
probThreshold = 0.7;

h = figure('Units','normalized','Position',[0.2 0.1 0.6 0.8]);

timeLimit = inf; %you may change the time limit

tic
ymd = [];
out = 0;
r = 0;
pulse="0000";
i=0;
k=0;
while ishandle(h) && toc < timeLimit

    % Extract audio samples from the audio device and add the samples to
    % the buffer.
    x = adr();
    write(audioBuffer,x);
    y = read(audioBuffer,fs,fs-adr.SamplesPerFrame);

    spec = helperExtractAuditoryFeatures(y,fs);
    
    % Classify the current spectrogram, save the label to the label buffer,
    % and save the predicted probabilities to the probability buffer.
    [YPredicted,probs] = classify(trainedNet,spec,'ExecutionEnvironment','cpu');
    YBuffer = [YBuffer(2:end),YPredicted];
    probBuffer = [probBuffer(:,2:end),probs(:)];


    % Plot the current waveform and spectrogram.
    subplot(2,1,1)
    plot(y)
    axis tight
    ylim([-1,1])

    subplot(2,1,2)
    pcolor(spec')
    caxis([-4 2.6445])
    shading flat

    % Now do the actual command detection by performing a very simple
    % thresholding operation. Declare a detection and display it in the
    % figure title if all of the following hold: 1) The most common label
    % is not background. 2) At least countThreshold of the latest frame
    % labels agree. 3) The maximum probability of the predicted label is at
    % least probThreshold. Otherwise, do not declare a detection.
    [YMode,count] = mode(YBuffer);

    maxProb = max(probBuffer(labels == YMode,:));
    subplot(2,1,1)

    if YMode == "background" || count < countThreshold || maxProb < probThreshold
        title("",'FontSize',20)
        if strcmp(pulse,'1010') % detect up
            %if i > 0
                %disp("up before, spray nothing")
            %else
                %OOKcontrolspray(c1)
                %disp("up, spray")
            %end
            i = i+1;
            pause(0.2);
            pulse = "0000"; % reset state, avoid repeated commands
            k=0;
        elseif strcmp(pulse,'1100') %detect down
            %if k > 0
             %   disp("down before, spray nothing")
            %else
             %   OOKcontrolspray(c1) % or PWMcontrolspray
              %  disp("down, spray")
            %end
            k=k+1;
            pause(0.2);
            pulse = "0000";
            i=0;
        else
        end        
    else
        disp(string(YMode))
        title(string(YMode),'FontSize',20)
        pulse = encoder(YMode);
    end
    drawnow
end
clear c1;

function key = encoder(input)
    if string(input) == "up"
        key = "1010";
    elseif string(input) == "down"
        key = "1100";    
    else
        key = "0000";     
    end    
end

function key = encoder_notuse(input)
    if string(input) == "up"
        key = "1";
    elseif string(input) == "down"
        key = "0";
    else 
    end
end

function PWMcontrolspray(c1,bit)
    if strcmp(bit,'1010') % detect up
        writeDigitalPin(c1, 'D9', 1);
        pause(0.03);
        writeDigitalPin(c1, 'D9', 0);
        pause(0.8);
        writeDigitalPin(c1, 'D9', 1);
        pause(0.03);
        writeDigitalPin(c1, 'D9', 0);
    elseif strcmp(bit,'1100') % detect down
        writeDigitalPin(c1, 'D9', 1);
        pause(0.03);
        writeDigitalPin(c1, 'D9', 0);
        pause(0.1);
        writeDigitalPin(c1, 'D9', 1);
        pause(0.03);
        writeDigitalPin(c1, 'D9', 0);
    end
end

function OOKcontrolspray(c1)
% need synchronise, need recognition output every symbol time period
    writeDigitalPin(c1, 'D9', 1);
    pause(0.03);
    writeDigitalPin(c1, 'D9', 0);
    pause(0.8); % detect change of state
    writeDigitalPin(c1, 'D9', 1);
    pause(0.03);
    writeDigitalPin(c1, 'D9', 0);    
end