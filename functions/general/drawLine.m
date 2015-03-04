function linecord = drawLine(startCoords,endCoords, win, color, width)
%DRAWLINE implements the line equation. To calculate the movement path from
%point to point.


if nargin == 2
    win = 0;
    color = [255, 0, 0];
    width = 5;
elseif nargin ==3
    color = [255, 0, 0];
    width = 5;
end

scrRect = Screen('Rect', win);

minStep = min([scrRect(3) / 100,  scrRect(4) / 100]);
xSteps = linspace(startCoords(1), endCoords(1), minStep);
ySteps = linspace(startCoords(2), endCoords(2), minStep);

velocity = linspace(60/1000, 16.67/1000, ceil(length(xSteps)/2));
velocity = [velocity, velocity(end:-1:1)];

for i = 2:length(xSteps)
    Screen('DrawLine', win, color, xSteps(1), ySteps(1), xSteps(i), ySteps(i), width);
    Screen('Flip', win);
    WaitSecs(velocity(i));
end

end
