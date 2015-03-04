function setup = TASKSETUP

%% CHANGE PARAMETERS HERE ------------------------------------------------------

% turn off/on eye tracking functions
%  values: true, false
setup.eyeTracker = true;

% if using the eye tracker, use the Eye Tracker Browser application
% to find the Tobii tracker id.
%  values: string
setup.tobiiID = 'TT120-205-85200523';

% Use automatic or manual calibration (if using eyetracker)
%  values: true, false
setup.autoCalibrate = false;

% which screen to use to display stimuli
%  values: integer
setup.screenNum = 1;

% width of the display being viewed in centimeters
%  values: double
setup.displayWidth = 33.7;

% height of the display being viewed in centimeters
%  values: double
setup.displayHeight = 26.9;

% distance from the screen to the participant's eyes in centimeters
%  values: double
setup.subjectDistance = 60;

% total number of repeated trials (target audio image)
%  values: integer
setup.nRepeated = 2;

% min time duration (seconds) before audio starts
%  values: double
setup.timeLimitPre = 1.0;

% max time duration (seconds) after audio starts
%  values: double
setup.timeLimitPost = 3.0;

% time (seconds) to display one flash of the attention getter screen
%  values: double
setup.attentionGetterTime = 0.75;

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

end

