function [trials, audio] = TrialShuffle(nImgs, nRepeated)
%Shuffle trials

% nImgs = 4; nRepeated = 2

% get all unique combinations
combosAll = nchoosek(1:nImgs, 2);
trials = [[], []];
audio = [];

% go through each and choose nRepeated
for i = 1:nImgs
    iIdx = combosAll(:, 1)' == i | combosAll(:, 2)' == i;
    iCombos = combosAll(iIdx, :);
    chooseThese = Shuffle(1:size(iCombos, 1));
    iCombos = iCombos(chooseThese(1:nRepeated), :);
    trials = [trials; iCombos];
    audio = [audio, repmat(i, [1, nRepeated])];
end

trials = [trials; combosAll];
audio = [audio, zeros([1, size(combosAll, 1)])];

% shuffle vertical orientation of trials
trialShuffledIdx = Shuffle(1:size(trials, 1));
trials = trials(trialShuffledIdx, :);

% shuffle horizontal orientation of trials
for i = 1:size(trials, 1)
    trials(i, :) = Shuffle(trials(i, :));
end

% use same shuffled idx for audio vec
audio = audio(trialShuffledIdx);

end

