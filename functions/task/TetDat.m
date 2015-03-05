function [lefteye, righteye, gazetimestamp, tettimestamp, ptbstamp, gx, gy, n] = TetDat(ptbstart, tetstart)

% tetStartstamp
tetts = TobiiTimeStamp(tetstart, tetio_localToRemoteTime(tetio_localTimeNow()));

% get ptb timestamp
ptbts = timeStamp(ptbstart);

% get tracking data from tetio
[lefteye, righteye, tettime] = tetio_readGazeData;

% check if no data collected at all
n = size(lefteye, 1);

if n ~= 0
    % check if looking
    [gx, gy] = GazeLocation(lefteye, righteye);
    
    % remote track duration
    gazetimestamp = TobiiTimeStamp(tetstart, tettime);
    tettimestamp = repmat(tetts, [n, 1]);
    ptbstamp = repmat(ptbts, [n, 1]);
else
    tettimestamp = [];
    gazetimestamp = [];
    ptbstamp = [];
    gx = [];
    gy = [];
end

end

