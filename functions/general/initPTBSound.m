function ptbAudioPointer = initPTBSound(samprate)
%Initialize PTB audio

if nargin == 0
    samprate = 44100;
end

InitializePsychSound; clc;
try
    % Try with the frequency we wanted:
    ptbAudioPointer = PsychPortAudio('Open', [], 1, 2, samprate, 2, [], [], [], 8);
catch
    % Failed. Retry with default frequency as suggested by device:
    fprintf('\nCould not open device at wanted playback frequency of %i Hz. Will retry with device default frequency.\n', 44100);
    fprintf('Sound may sound a bit out of tune, ...\n\n');
    psychlasterror('reset');
    ptbAudioPointer = PsychPortAudio('Open', [], [], 1, [], 2);
end

end

