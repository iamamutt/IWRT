function [imgTextures, audBuffers] = LoadAttentionGetters(win, aud, imgs, wavs)


imgnames = fieldnames(imgs.attend);
audnames = fieldnames(wavs.attend);

imgTextures = [];
audBuffers = [];

for i = 1:length(imgnames)
    imgTextures = [imgTextures, Screen('MakeTexture', win, imgs.attend.(imgnames{i}).rgb)];
end

for i = 1:length(audnames)
    audBuffers = [audBuffers, PsychPortAudio('CreateBuffer', aud, wavs.attend.(audnames{i}).wav{1}')];
end

end

