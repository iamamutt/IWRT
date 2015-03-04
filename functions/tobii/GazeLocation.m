function [x, y] = GazeLocation(lefteye, righteye)
%Find point of gaze

%Will use points up until last readData
lx = lefteye(:,7);
ly = lefteye(:,8);
rx = righteye(:,7);
ry = righteye(:,8);

lx = lx(lx > 0 & lx < 1);
ly = ly(ly > 0 & ly < 1);
rx = rx(rx > 0 & rx < 1);
ry = ry(ry > 0 & ry < 1);

if ~isempty(lx) && ~isempty(rx)
    lx = mean(lx);
    rx = mean(rx);
    x = mean([lx rx]);
else
    x = 0;
end

if ~isempty(ly) && ~isempty(ry)
    ly = mean(ly);
    ry = mean(ry);
    y = mean([ly ry]);
else
    y = 0;
end


end

