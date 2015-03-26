function [screenId, screenWidth, screenHeight, escKeys] = setupPTB(fontsize)
%General function to setup defaults in psychtoolbox

if nargin == 0
    fontsize = 16;
end

% skip sync tests
Screen('Preference', 'SkipSyncTests', 1);

% black screen
Screen('Preference', 'VisualDebugLevel', 3);

% suppress startup info
Screen('Preference', 'Verbosity', 2);

% font size
Screen('Preference', 'DefaultFontSize', fontsize);

% key names for all OS
KbName('UnifyKeyNames');

% Check key code with this
% WaitSecs(2); [~, ~, z] = KbCheck; {find(z), KbName(z)}

escKeys = KbName('ESCAPE');

% choose PTB screen window
screenId = max(Screen('Screens'));                                    

% determine window size
[screenWidth, screenHeight] = Screen('WindowSize', screenId);

% Screen('BlendFunction', screenId, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);

InitializePsychSound;

end