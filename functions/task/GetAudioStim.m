function [ stim ] = GetAudioStim( procstrct, audstrct, trial )
%Return audio stimuli for a single trial

% procstrct = procedure; audstrct=audio; trial=1;

audfile = procstrct.audio(trial);

if audfile ~= 0
    
    cond = procstrct.known(trial);
    if cond
        iname = procstrct.knownNames{audfile};
    else
        iname = procstrct.novelNames{audfile};
    end
    
    aud = audstrct.labels.(iname);
    ranAudioVersion = randi([1,  size(aud.wav, 2)], 1, 1);
    
    stim.wav = aud.wav{ranAudioVersion};
    stim.channels = aud.channels{ranAudioVersion};
    stim.rate = aud.rate{ranAudioVersion};
    stim.name = iname;
else
    s = 44100;
    l = randi([25, 67], 1, 1)/100;
    t = 0:1/s:l;
    f = 5000;
    wav = 0.33 .* sin(2 .* pi .* f .* t)';
    % sound(wav, s, 16);
    
    stim.wav = [wav, wav];
    stim.channels = 2;
    stim.rate = s;
    stim.name = 'tone';
end

end

