function [ procStruct ] = Procedure(nRepeated, knownNames, novelNames)
%Procedure layout

nKnownImages = length(knownNames);
nNovelImages = length(novelNames);

[knownCombos, audioOnOffKnown] = TrialShuffle(nKnownImages, nRepeated);
[novelCombos, audioOnOffNovel] = TrialShuffle(nNovelImages, nRepeated);

isKnownTrial = [true([size(knownCombos, 1), 1]); false([size(novelCombos, 1), 1])];

procStruct.knownNames = knownNames;
procStruct.novelNames = novelNames;
procStruct.known = isKnownTrial;
procStruct.left = [knownCombos(:,1); novelCombos(:,1)];
procStruct.right = [knownCombos(:,2); novelCombos(:,2)];
procStruct.audio = [audioOnOffKnown'; audioOnOffNovel'];

end

