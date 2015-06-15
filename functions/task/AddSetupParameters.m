function setup = AddSetupParameters(useSetupFile, debug, rootpath)

rng('shuffle');

if ~useSetupFile
    
    % turn off/on eye tracking functions
    %  values: true, false
    setup.eyeTracker = false;
    
    % if using the eye tracker, use the Eye Tracker Browser application
    % to find the Tobii tracker id.
    %  values: string
    setup.tobiiID = 'TT120-xxx-xxxxxxxx';
    
    % Use automatic or manual calibration (if using eyetracker)
    %  values: true, false
    setup.autoCalibrate = true;
    
    % which screen to use to display stimulus
    %  values: integer
    setup.screenNum = 1;
    
    % width of the display being viewed in centimeters
    %  values: double
    setup.displayWidth = 33.7;
    
    % height of the display been viewed in centimeters
    %  values: double
    setup.displayHeight = 26.9;
    
    % distance from the screen to the participant's eyes in centimeters
    %  values: double
    setup.subjectDistance = 60;
    
    % total number of blocks of trials
    %  values: integer
    setup.nRepeated = 2;
    
    % min time duration (seconds) before audio starts
    %  values: double
    setup.timeLimitPre = 1.0;
    
    % max time duration (seconds) after audio starts
    %  values: double
    setup.timeLimitPost = 3.0;
    
    % time (seconds) before quitting trial if child is looking away
    %  values: double
    setup.lookAwayTime = 1;
    
    % how many flips of the screen to wait before assessing looking away
    %  values: integer
    setup.lookAwayBufferSize = 30;
    
    % size of each item on the screen in terms of visual angle
    %  values: double
    setup.sizeOfImageInDiagDegrees = 10;
    
    % size of fixation circle diameter (degrees)
    %  values: double
    setup.sizeOfFixationInDiagDegrees = 2.5;
    
    % Number of pixels to adjust the distance between l/r images
    %  values: integer, negative or positive
    setup.sepAdj = 100;
    
    % background color of the screen, defaults to RGB gray
    %  values: 1x3 matrix of RGB values
    setup.bgColor = [127, 127, 127];
    
    % color of brief mask right after fixation circle
    %  values: RGB
    setup.maskColor = [0 0 0];
    
    % record screenshots for each trial
    %  values: true, false
    setup.screenshot = true;
    
elseif useSetupFile
    setup = TASKSETUP;
else
    error('wrong value for defaults argument');
    
end

if debug
    setup.debug = true;
    setup.eyeTracker = false;
    setup.screenshot = false;
    setup.nRepeated = 1;
    setup.timeLimitPre = 0.1;
    setup.timeLimitPost = 0.1;
    subId = 'debug';
    subName = 'debug';
    subAge = 0;
    fileStr = 'debug';
    
else
    [subId, subName, subAge, fileStr] = subjectBox('Infant_WRT');
    setup.debug = false;
    
end

% send to struct
setup.subID = subId;
setup.subName = subName;
setup.subAge = subAge;
setup.fileStr = fileStr;
setup.date = datestr(now);

% screen info
[screenId, screenWidth, screenHeight, escKeys] = setupPTB;

[scrHorz, scrVert] = screenGridPoints(screenWidth, screenHeight, 5, 3);

% send to struct
setup.maxScreens = screenId;
setup.escKeys = escKeys;
setup.screenWidth = screenWidth;
setup.screenHeight = screenHeight;
setup.screenLeft = scrHorz(2);
setup.screenRight = scrHorz(4);
setup.screenCenterX = scrHorz(3);
setup.screenCenterY = scrVert(2);
setup.screenRect = [0 0 screenWidth screenHeight];
setup.screenDiag = xy2vec(screenWidth, screenHeight);

% display diagonal in pixels
setup.displayDiag = xy2vec(setup.displayWidth, setup.displayHeight);

% display visual angles
setup.dispHorzVisualAngle = visualAngle(setup.displayWidth, setup.subjectDistance);
setup.dispVertVisualAngle = visualAngle(setup.displayHeight, setup.subjectDistance);
setup.dispDiagVisualAngle = visualAngle(setup.displayDiag, setup.subjectDistance);

% image and fixation size in pixels given visual angle (all diagonal)
setup.imgPixels = angle2pixels(setup.sizeOfImageInDiagDegrees, setup.subjectDistance, setup.displayDiag, setup.screenDiag);
setup.fixationDiameter = angle2pixels(setup.sizeOfFixationInDiagDegrees, setup.subjectDistance, setup.displayDiag, setup.screenDiag);

% directory info
setup.outdir = fullfile(rootpath, 'data', ['SUB_' subId]);

if exist(setup.outdir, 'dir') == 7 && ~strcmp(subId, 'debug');
    resp = questdlg('The entered subject number has already been used. Do you want to overwrite data?',...
        'Warning!', 'yes', 'no', 'no');
    
    switch resp
        case 'yes'
            warning('Overwriting subject data');
            try
                rmdir(setup.outdir, 's');
            catch
                error('Try exiting data files and data directory before removal of old data');
            end
        case 'no'
            error('Please use a different subject number or append a letter.')
    end
    
end

if exist(setup.outdir, 'dir') == 7 && strcmp(subId, 'debug');
    rmdir(setup.outdir, 's');
end

[success, mess, messid] = mkdir(setup.outdir);

setup.dataFileStr = fullfile(setup.outdir, [fileStr, '_data.csv']);

% make tobii calibration file and tracking data directory
if setup.eyeTracker
    setup.calibFileStr = fullfile(setup.outdir, [fileStr, '_calibration.csv']);
    [success, mess, messid] = mkdir(fullfile(setup.outdir, 'tracking'));
    setup.tobiiFileStr = fullfile(setup.outdir, 'tracking', [fileStr, '_']);
else
    setup.calibFileStr = 'NA';
    setup.tobiiFileStr = 'NA';
end

% make screen shot directory
if setup.screenshot
    [success, mess, messid] = mkdir(fullfile(setup.outdir, 'screenshots'));
    setup.screenshotFileStr = fullfile(setup.outdir, 'screenshots', [fileStr, '_']);
else
    setup.screenshotFileStr = 'NA';
end

% print experiment setup info
subjectFileStr = fullfile(setup.outdir, [fileStr, '_info.txt']);
subFile = fopen(subjectFileStr, 'w');

% collect setup parameters to be printed to file
infoNames = fieldnames(setup);
infoData = cellfun(@(x) num2str(x), struct2cell(setup), 'UniformOutput', false);

fprintf(subFile, 'Date: %s', setup.date); % datestr(now, 'dd-mm-yy_HH-MM')
for i = 1:length(infoData)
    fprintf(subFile, '\n%s : %s', infoNames{i}, infoData{i});
end

fclose(subFile);


end

