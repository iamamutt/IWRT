function [ audioOut ] = AudioStruct(audiopath)
%Import audio from paths as struct

audioPaths = listFiles(audiopath, 'wav');

for i = 1:length(audioPaths)
    [~, audname, ~] = fileparts(audioPaths{i});
    fsplit = strsplit(audname,'_');
    afile = fsplit{1};
    avers = fsplit{2};
    [wav, srate] = audioread(audioPaths{i});
    if size(wav, 2) < 2
        wav = horzcat(wav, wav);
    end
    audioOut.(afile).wav{str2double(avers)} = wav;
    audioOut.(afile).channels{str2double(avers)} = size(wav, 2);
    audioOut.(afile).rate{str2double(avers)} = srate;
end

end
