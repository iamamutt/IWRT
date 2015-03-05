function wavfile = RandomFixationAudio(audio)

anames = fieldnames(audio.fix);
wavfile = audio.fix.(anames{randi([1, size(anames, 1)],1,1)}).wav;
wavfile = wavfile{1}';

if size(wavfile, 1) == 1
    wavfile = vertcat(wavfile, wavfile);
end

end
