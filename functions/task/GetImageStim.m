function [ stim ] = GetImageStim(procstrct, imgstrct, trial, lx, rx, cy, scrx, scry)
%Return image data, audio data, and rect positions

% imgstrct=images; procstrct=procedure; trial=1;

imNumLeft = procstrct.left(trial);
imNumRight = procstrct.right(trial);
knownStim = procstrct.known(trial);

if knownStim
    lName = procstrct.knownNames{imNumLeft};
    rName = procstrct.knownNames{imNumRight};
    imgLeft = imgstrct.known.(lName);
    imgRight = imgstrct.known.(rName);
else
    lName = procstrct.novelNames{imNumLeft};
    rName = procstrct.novelNames{imNumRight};
    imgLeft = imgstrct.novel.(lName);
    imgRight = imgstrct.novel.(rName);
end

flipIm = logical(randi([0,1], 1, 2));

if flipIm(1)
    stim.imgL = flipimg(imgLeft.rgb);
else
    stim.imgL = imgLeft.rgb;
end

if flipIm(2)
    stim.imgR = flipimg(imgRight.rgb);
else
    stim.imgR = imgRight.rgb;
end

stim.rectL = CenterRectOnPoint(imgLeft.rect, lx, cy);
stim.rectR = CenterRectOnPoint(imgRight.rect, rx, cy);

stim.normL = [stim.rectL(1) / scrx, stim.rectL(2) / scry, stim.rectL(3) / scrx, stim.rectL(4) / scry];
stim.normR = [stim.rectR(1) / scrx, stim.rectR(2) / scry, stim.rectR(3) / scrx, stim.rectR(4) / scry];

stim.nameL = lName;
stim.nameR = rName;

stim.known = knownStim;

end

