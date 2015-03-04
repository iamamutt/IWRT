function wrt(useSetupFile, debug)
%Infant Word Recognition Task
%
% ARGS:
%  setupFile : logical: [true], false
%   - use the program defaults (false) or set options in the TASKCONFIG.m
%     file (true)
%
%  debug : logical: true, [false]
%   - run debug session with limited trials and no data
%     collection, no eye-tracker.
%
% Different versions of audio files may be added if appending _x.wav

switch nargin
    case 0
        useSetupFile = true;
        debug = false;
    case 1
        debug = false;
end

clc;
input('Resize MATLAB window and make any adjustments now. Press Enter to continue', 's');

% cd 'D:\Dropbox\ExperimentPrograms\InfantWordRecognitionTask\matlab'; debug=true; useSetupFile=false;
% cd 'E:\WordRecognitionTask'; useSetupFile=true; debug=false; rootpath = fullfile(pwd)

%% SETUP PARAMETERS -------------------------------------------------------

% change directory to main function location
rootpath = fileparts(mfilename('fullpath'));
cd(rootpath);

% path to subfunctions
funcpath = fullfile(pwd, 'functions');
addpath(genpath(funcpath));

% images
imgpathNovel = fullfile(pwd, 'media', 'images', 'novel');
imgpathKnown = fullfile(pwd, 'media', 'images', 'known');
imgpathAttend = fullfile(pwd, 'media', 'images', 'attend');

% audio
audpathLabels = fullfile(pwd, 'media', 'audio', 'labels');
audpathFixation = fullfile(pwd, 'media', 'audio', 'fixation');
audpathAttend = fullfile(pwd, 'media', 'audio', 'attend');

% see TASKCONFIG.m file for changing some of the setup parameters
setup = AddSetupParameters(useSetupFile, debug, rootpath);

% import images and image info
images.novel = ImageStruct(imgpathNovel, setup);
images.known = ImageStruct(imgpathKnown, setup);
images.attend = ImageStruct(imgpathAttend, setup);

% import audio files
audio.labels = AudioStruct(audpathLabels);
audio.fix = AudioStruct(audpathFixation);
audio.attend = AudioStruct(audpathAttend);

% trial structure
procedure = Procedure(setup.nRepeated, ...
    fieldnames(images.known), ...
    fieldnames(images.novel));

%% BEGIN PROGRAM ----------------------------------------------------------

% calibrate if using eye tracker
SetupTobii(setup);

% run data collection routine
RunProgram(setup, procedure, images, audio);

end
