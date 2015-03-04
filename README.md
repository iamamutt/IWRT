# IWRT

Preferential Looking Paradigm, Infant Word Recognition Task.

This task is to be used with MATLAB using the Psychtoolbox. The version used was the following:

```
3.0.12 - Flavor: beta - Corresponds to SVN Revision 5797
For more info visit:
https://github.com/Psychtoolbox-3/Psychtoolbox-3
```

The task can be ran with or without the Tobii eyetracker. The eyetracker corresponding to the current tested version of the program is the T120 model, but also works with the X version of that model. Basically, any model that will work the Tobii SDK.

You must also download and install the Tobii SDK and add that to your MATLAB path to be able to use the Tobii functions. The version of the SDK used here was `3.0.83`, and tested on both OSX and Windows.

## Usage

```
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
```

To show a quick run through of the task, set the debug argument to `true`.

Example: `wrt(true, true`)

Parameters of the task may be changed in the file `TASKCONFIG.m`


