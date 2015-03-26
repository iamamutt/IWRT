function TestTobii
clear all
clc

% add tobii functions
funcPath = fileparts(mfilename('fullpath'));
cd(funcPath);
addpath(genpath(funcPath));

trackerID = inputdlg('Enter Tobii Tracker ID:', 'TOBII ID', [1,50], {'TT120-xxx-xxxxxxxx'});

screenNum = inputdlg('Which screen is Tobii?:', 'TOBII ID', [1,50], {'1'});

savePath = inputdlg('Where do you want to save the test files?:', 'Save folder', [1,100], {'C:\TobiiMatlabTest'});
[success, mess, messid] = mkdir(fullfile(savePath{1}));

setup.eyeTracker = true;
setup.tobiiID = trackerID{1};
setup.screenNum = str2num(screenNum{1});
setup.screenRect = Screen('Rect', setup.screenNum);
setup.autoCalibrate = false;
setup.calibFileStr = fullfile(savePath{1}, filesep, 'testtobii_calib.csv');
    

calibStrct = SetupTobii(setup);

% Show dots
windowPtr = tryScreenOpen(setup.screenNum, [0 0 0]);

circleRadius = 50;
circlePoints = [circleRadius * 2, circleRadius * 2, setup.screenRect(3)/2, setup.screenRect(3)-circleRadius * 2, setup.screenRect(3)-circleRadius * 2;
    circleRadius * 2, setup.screenRect(4) - circleRadius * 2, setup.screenRect(4) / 2, circleRadius * 2, setup.screenRect(4) - circleRadius * 2];
circleRects = CenterRectOnPoint([1, 1, circleRadius, circleRadius], circlePoints(1, :)', circlePoints(2, :)');

for r = 1:size(circleRects, 1)
    Screen('FillArc', windowPtr, [255 0 0], circleRects(r,:), 0, 360);
end

% timestamps
flipStart = tetio_localTimeNow();
flipStartRemote = tetio_localToRemoteTime(flipStart);

Screen('Flip', windowPtr);

tetio_startTracking;

pauseTimeInSeconds = 0.01;
durationInSeconds = 1.5*6;

[leftEyeAll, rightEyeAll, timeStampAll] = DataCollect(durationInSeconds, pauseTimeInSeconds);

% example of time conversion
tsall2local = tetio_remoteToLocalTime(int64(timeStampAll(1)));
remoteDiff = double(timeStampAll(1))-flipStartRemote;

Screen('CloseAll');

try
    try
        tetio_stopTracking;
    catch
        disp('...');
    end
    tetio_disconnectTracker;
    tetio_cleanUp;
catch
    disp('...');
end

DisplayData(leftEyeAll, rightEyeAll );

save(fullfile(savePath{1}, filesep, 'testtobii.mat'));
csvwrite(fullfile(savePath{1}, filesep, 'testtobii_l.csv'), leftEyeAll);
csvwrite(fullfile(savePath{1}, filesep, 'testtobii_r.csv'), rightEyeAll);

end







