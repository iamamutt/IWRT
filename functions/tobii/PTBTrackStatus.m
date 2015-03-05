function PTBTrackStatus(Calib)
%Psychtoobox version of track status

    function tbcs = trackBox
        tbcs.x = round(((mean([GazeData.left_eye_tcs.x, GazeData.right_eye_tcs.x]) - 0.5) .* -2) .* 100);
        tbcs.y = round(((mean([GazeData.left_eye_tcs.y, GazeData.right_eye_tcs.y]) - 0.5) .* -2) .* 100);
        tbcs.z = round(((mean([GazeData.left_eye_tcs.z, GazeData.right_eye_tcs.z]) - 0.5) .* -2) .* 100);
    end

    function eyeRects = getRects
        xl = max([1, (1-GazeData.left_eye_tcs.x) .* rect(3)]);
        xr = max([1, (1-GazeData.right_eye_tcs.x) .* rect(3)]);
        yl = max([1, GazeData.left_eye_tcs.y .* rect(4)]);
        yr = max([1, GazeData.right_eye_tcs.y .* rect(4)]);

        zl = max([5, (1-GazeData.left_eye_tcs.z) * 100]);
        zr = max([5, (1-GazeData.right_eye_tcs.z) * 100]);
        
        eyeRects.left = CenterRectOnPoint([0 0 zl zl], xl, yl);
        eyeRects.right = CenterRectOnPoint([0 0 zr zr], xr, yr);
    end

Calib.pointer = tryScreenOpen(Calib.window, Calib.bgcolor);

try
    tetio_stopTracking;
catch
    disp('...');
end

tetio_startTracking;

rect = Calib.screen;

centerCircle = CenterRectOnPoint([0 0 50 50], rect(3)/2, rect(4)/2);

disp('Position participant until center circle flashes green.');
disp('Hold space bar to exit track status.');

while true
    
    if checkTermination(KbName('SPACE'))
        break
    end
    
    [lefteye, righteye, ~, ~] = tetio_readGazeData;
    
    % no data found at all
    if isempty(lefteye) 
        continue;
    % data packet, use last row
    else
        GazeData = ParseGazeData(lefteye(end, :), righteye(end, :)); 
    end
    
    % both good
    if GazeData.left_validity==0 && GazeData.right_validity==0
        leftColor = [0 255 0];
        rightColor = [0 255 0];
    % not sure which eye is found
    elseif GazeData.left_validity == 2 && GazeData.right_validity == 2
        leftColor = [255 255 0];
        rightColor = [255 255 0];
    % right eye found
    elseif GazeData.left_validity >= 3 && GazeData.right_validity <= 1
        leftColor = [255 255 0];
        rightColor = [255 255 0];
    % left eye found
    elseif GazeData.left_validity <= 1 && GazeData.right_validity >= 3
        leftColor = [255 255 0];
        rightColor = [255 255 0];
    % no eyes found
    elseif GazeData.left_validity == 4 && GazeData.right_validity == 4
        leftColor = [255 0 0];
        rightColor = [255 0 0];
    % NA
    else
        leftColor = [0 0 0];
        rightColor = [0 0 0];
    end
    
    tbcs = trackBox;
    eyeRects = getRects;
   
    Screen('DrawText', Calib.pointer, ['x: ' num2str(tbcs.x)], 2, 20, [255 0 0]);
    Screen('DrawText', Calib.pointer, ['y: ' num2str(tbcs.y)], 2, 40, [0 255 0]);
    Screen('DrawText', Calib.pointer, ['z: ' num2str(tbcs.z)], 2, 60, [0 0 255]);
    
    Screen('FillArc', Calib.pointer, leftColor, eyeRects.left, 1, 360);
    Screen('FillArc', Calib.pointer, rightColor, eyeRects.right, 1, 360);
    
    if abs(tbcs.x) < 25 && abs(tbcs.y) < 25 && abs(tbcs.z) < 25
        Screen('FillArc', Calib.pointer, [0 255 0], centerCircle, 1, 360);
    else
        Screen('FrameArc', Calib.pointer, [255 255 255], centerCircle, 1, 360);  
    end
    
    Screen('Flip', Calib.pointer);
    WaitSecs(1/20);
    
end

KbReleaseWait;
Screen('Close', Calib.pointer);
tetio_stopTracking;

end

