function [calibStruct, Calib] = AutoCalibrate(Calib,pointOrder,recalibrate,recalibrationPoints)

Calib.pointer = tryScreenOpen(Calib.window, Calib.bgcolor);

rootpath = fileparts(mfilename('fullpath'));
[wav, srate] = audioread(fullfile(rootpath, 'calib.wav'));

if size(wav, 2) == 1
    wav = horzcat(wav, wav);
end

audioPtr = PsychPortAudio('Open', [], 1, 1, srate, 2, [], [], [], 8);

if (recalibrate==0)
    tetio_startCalib;
    calibrateThesePoints = true([1, length(pointOrder)]);
else
    calibrateThesePoints = false([1, length(pointOrder)]);
    for i = 1:length(recalibrationPoints)
        calibrateThesePoints(recalibrationPoints(i) == pointOrder) = true;
    end
end

WaitSecs(1);

clc
disp('Press space bar exactly when participant looks at dot');

pointCounter = 0;
HideCursor;
PsychPortAudio('FillBuffer', audioPtr, wav');
PsychPortAudio('Start', audioPtr, 0, 0, 1);
for i = 1:length(pointOrder);
    
    if calibrateThesePoints(i)
        
        pointCounter = pointCounter + 1;
        
        if recalibrate
            tetio_removeCalibPoint(Calib.points.x(pointOrder(i)), Calib.points.y(pointOrder(i)));
        end
        
        x = Calib.points.x(pointOrder(i));
        y = Calib.points.y(pointOrder(i));
        
        xPixels = floor(Calib.screen(3) .* x);
        yPixels = floor(Calib.screen(4) .* y);
        
        xNorm = xPixels / Calib.screen(3);
        yNorm = yPixels / Calib.screen(4);
        
        fixationCircle(Calib.pointer, false, Calib.circlesize, xPixels, yPixels);
        tetio_addCalibPoint(xNorm,yNorm);
        
        Calib.points.x(pointOrder(i)) = xNorm;
        Calib.points.y(pointOrder(i)) = yNorm;
        
        % draw line to next point
        if pointCounter ~= sum(calibrateThesePoints)
            nextLineIters = find(calibrateThesePoints);
            nextIter = nextLineIters(nextLineIters > i);
            xNext = Calib.points.x(pointOrder(nextIter(1)));
            yNext = Calib.points.y(pointOrder(nextIter(1)));
            
            xPixelsNext = floor(Calib.screen(3) .* xNext);
            yPixelsNext = floor(Calib.screen(4) .* yNext);
            
            drawLine([xPixels, yPixels],[xPixelsNext, yPixelsNext], ...
                Calib.pointer, Calib.linecolor, Calib.linesize);
        end
        
        WaitSecs(0.3);
        
    end
end
PsychPortAudio('Stop', audioPtr);
PsychPortAudio('Close', audioPtr);
ShowCursor;
tetio_computeCalib;
calibPlotData = tetio_getCalibPlotData;
calibStruct = CalibrationStruct(calibPlotData);
Screen('Close', Calib.pointer);

end



