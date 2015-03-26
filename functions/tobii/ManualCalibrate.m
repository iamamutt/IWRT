function [calibStruct, Calib, pointCount] = ManualCalibrate(Calib, pointCount, addPoints)

if nargin == 1
    pointCount = 0;
    addPoints = false;
end

Calib.pointer = tryScreenOpen(Calib.window, Calib.bgcolor);

%%
rootpath = fileparts(mfilename('fullpath'));

% load audio
[wav, srate] = audioread(fullfile(rootpath, 'calib.wav'));

if size(wav, 2) == 1
    wav = horzcat(wav, wav);
end

audioPtr = PsychPortAudio('Open', [], 1, 1, srate, 2, [], [], [], 8);

% load image
[calibImg, ~, alpha] = imread(fullfile(rootpath, 'calib.png'));

if isempty(alpha)
    alpha = uint8(ones(size(calibImg, 1), size(calibImg, 2)) .* 255);
end

alphaScale = double(alpha) ./ 255;

% background color
for j = 1:3
    imlayer = double(calibImg(:,:,j));
    imlayer = imlayer .* alphaScale;
    bglayer = (1-alphaScale) .* Calib.bgcolor(j);
    calibImg(:,:,j) = uint8(floor(imlayer + bglayer));
end

%%
clc;

rect = Calib.screen;
pressedSpace = false;

if ~addPoints
    tetio_startCalib;
end

disp('Press SPACE to stop calibration');
HideCursor;
PsychPortAudio('FillBuffer', audioPtr, wav');
PsychPortAudio('Start', audioPtr, 0, 0, 1);
while true
    
    [pressedSpace, clickedScreen, x, y] = fixationImage(calibImg, Calib.pointer,true,Calib.stimsize);
    
    if any(clickedScreen);
        if x >= 0 && x <= rect(3) && y >= 0 && y <= rect(4);
            xNorm = x / rect(3);
            yNorm = y / rect(4);
            tetio_addCalibPoint(xNorm,yNorm);
            pointCount = pointCount+1;
            Calib.points.x(pointCount) = xNorm;
            Calib.points.y(pointCount) = yNorm;
            fprintf('%s%d%s%d%s%d%s\n', 'Added point ', pointCount,' at [', x, ', ', y, ']');
        end
        
    end
    
    if checkTermination(KbName('SPACE')) || pressedSpace
        break
    end
    
    clickedScreen = false;
    
end
PsychPortAudio('Stop', audioPtr);
PsychPortAudio('Close', audioPtr);
ShowCursor;
KbReleaseWait;
tetio_computeCalib;
calibPlotData = tetio_getCalibPlotData;
calibStruct = CalibrationStruct(calibPlotData);
Screen('Close', Calib.pointer);

end

