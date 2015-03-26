function [spacePressed, btnsPressed, mX, mY] = fixationImage(img, win, useMouse, imgWidth, xPoint, yPoint)


if nargin < 3
    error('Need screen ID and useMouse arg for attentionGetter');
elseif nargin == 3;
    imgWidth = 100;
    scrRect = Screen('Rect', win);
    xPoint = (scrRect(1)+1 + scrRect(3)) / 2;
    yPoint = (scrRect(2)+1 + scrRect(4)) / 2;
elseif nargin == 4;
    scrRect = Screen('Rect', win);
    xPoint = (scrRect(1)+1 + scrRect(3)) / 2;
    yPoint = (scrRect(2)+1 + scrRect(4)) / 2;
end

% win = Screen('OpenWindow', 1);

% smallest the point will go
minSize = 0.1;

% animation speed
sizeSteps = 45;

% resize image to max width
newSize = imgWidth / size(img, 2);
img = imresize(img, newSize);

% grow image
stepDiametersW = linspace(size(img, 2), round(minSize .* size(img, 2)), sizeSteps);
stepDiametersH = linspace(size(img, 1), round(minSize .* size(img, 1)), sizeSteps);

% init loop parameters
loopCounter = 1;
btnsPressed = false;
spacePressed = false;

mX = [];
mY = [];

imgTexture = Screen('MakeTexture', win, img);

while true
    
    % use arg coordinates or mouse coordinates for circle
    if ~useMouse
        xy = CenterRectOnPoint(...
            [0 0 stepDiametersW(loopCounter) stepDiametersH(loopCounter)],...
            xPoint, yPoint);
    else
        [mX, mY, btnsPressed] = GetMouse(win);
 
        xy = CenterRectOnPoint(...
            [0 0 stepDiametersW(loopCounter) stepDiametersH(loopCounter)],...
            mX, mY);
    end
    
    % check for button click exit
    if any(btnsPressed)
        break
    end
    
    % draw img
    Screen('DrawTexture', win, imgTexture, [], xy);
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




