function [spacePressed, btnsPressed, mX, mY] = fixationCircle(win, useMouse, maxDiameter, xPoint, yPoint)
%Attention getter: makes an animated circle
% win = Screen('OpenWindow', 1);
% useMouse = true;
% maxDiameter = 100
% xPoint = 500
% yPoint = 500

if nargin < 2
    error('Need screen ID and useMouse arg for attentionGetter');
elseif nargin == 2;
    maxDiameter = 100;
    scrRect = Screen('Rect', win);
    xPoint = (scrRect(1)+1 + scrRect(3)) / 2;
    yPoint = (scrRect(2)+1 + scrRect(4)) / 2;
elseif nargin == 3;
    scrRect = Screen('Rect', win);
    xPoint = (scrRect(1)+1 + scrRect(3)) / 2;
    yPoint = (scrRect(2)+1 + scrRect(4)) / 2;
end

% smallest the point will go
minDiameter = 5;

% animation speed
sizeSteps = 45;

% grow circles
stepDiameters = linspace(maxDiameter, minDiameter, sizeSteps);
revStepDiameters = stepDiameters(end:-1:1);

% change colors
circleColors = [round(linspace(0, 255, sizeSteps))', ...
    round(linspace(255, 0, sizeSteps))',  ...
    round(linspace(0, 127, sizeSteps))'];

% init loop parameters
loopCounter = 1;
btnsPressed = false;
spacePressed = false;

mX = [];
mY = [];

while true
    
    % use arg coordinates or mouse coordinates for circle
    if ~useMouse
        xy1 = CenterRectOnPoint(...
            [0 0 stepDiameters(loopCounter) stepDiameters(loopCounter)],...
            xPoint, yPoint);
        
        xy2 = CenterRectOnPoint(...
            [0 0 revStepDiameters(loopCounter) revStepDiameters(loopCounter)],...
            xPoint, yPoint);
        
    else
        [mX, mY, btnsPressed] = GetMouse(win);
 
        xy1 = CenterRectOnPoint(...
            [0 0 stepDiameters(loopCounter) stepDiameters(loopCounter)],...
            mX, mY);
        
        xy2 = CenterRectOnPoint(...
            [0 0 revStepDiameters(loopCounter) revStepDiameters(loopCounter)],...
            mX, mY);
    end
    
    % check for button click exit
    if any(btnsPressed)
        break
    end
    
    % draw circle
    Screen('FrameArc', win, circleColors(loopCounter, :), xy1, 0, 360, 10, 10);
    Screen('FrameArc', win, circleColors(loopCounter, :), xy2, 0, 360, 10, 10);
    Screen('Flip', win);
    WaitSecs(0.02);
    
    % reset/increment loop counter
    if loopCounter >= sizeSteps
        loopCounter = 1;
    else
        loopCounter = loopCounter + 1;
    end
    
    % check for space exit
    if checkTermination(KbName('SPACE'))
        spacePressed = true;
        break
    end
end

KbReleaseWait;

end

