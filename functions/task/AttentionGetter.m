function AttentionGetter(windowPtr, audioPointer, aTextures, aBuffers, t)

i = randi([1, 2], 1, 1);

soundStatus = PsychPortAudio('GetStatus', audioPointer);
if soundStatus.Active == 0
    PsychPortAudio('FillBuffer', audioPointer, aBuffers(i));
    PsychPortAudio('Start', audioPointer, 1, 0, 1);
end

Screen('DrawTexture', windowPtr, aTextures(i));
Screen('Flip', windowPtr);
WaitSecs(t);

end

