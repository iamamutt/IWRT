function calibStrct = SetupTobii(setup)

calibStrct = [];

if setup.eyeTracker
    
    % Initialize Tobii
    disp('Initializing Tobii Eye Tracker');
    
    try
        tetio_init();
    catch
        error('Could not initialize eye tracker');
    end
    
    disp('Trying to connect to the tracker using trackerID...');
    
    try
        tetio_connectTracker(setup.tobiiID);
    catch
        error(['Could not connect to eye tracker with that ID. ',...
            'Try to open up the Tobii Eyetracker Browser to see ',...
        'if its connected, or turn Tobii on and off again and wait.']);
    end
    
    % Main calibration parameters
    Calib.screen = setup.screenRect;          % size of screen in [x1 y1 x2 y2] format
    Calib.window = setup.screenNum;           % PTB window pointer
    Calib.automatic = setup.autoCalibrate;    % use automatic points (true) or use mouse (false)
    Calib.bgcolor = [0 0 0];                  % background color used in calibration process [0-255]
    Calib.circlesize = 50;                    % max circle size
    Calib.error = 100;                        % allowable error in number of pixels,  angle2pixels(2.5,60,26.9,1024)
    
    % Automatic calibration parameters
    Calib.points.x = [0.1 0.5 0.5 0.5 0.9];   % X coordinates in [0,1] coordinate system
    Calib.points.y = [0.5 0.1 0.5 0.9 0.5];   % Y coordinates in [0,1] coordinate system
    Calib.points.n = size(Calib.points.x, 2); % Number of calibration points (only change if using subset)
    Calib.linesize = 7;                       % line size
    Calib.linecolor = [255 255 255];          % line color
    
    % Track status window
    disp('Starting TrackStatus');
    PTBTrackStatus(Calib);
    disp('TrackStatus Terminated');
    
    % Start calibration
    disp('Starting Calibration Process');
    [calibStrct, Calib] = ManageCalibration(Calib);
    disp('Calibration Process Stopped');
    
    if isempty(calibStrct)
        continueTask = input('No calibration data obtained. Eye tracking won''t work. Would you like to continue anwyay? ([y]/n):\n','s');
        if strcmpi(continueTask,'n')
            quit
        end
    end
    
    % write calibration data
    calibFile = fopen(setup.calibFileStr, 'w');
    fprintf(calibFile, '%s,%s,%s,%s,%s,%s,%s,%s,%s\n', ...
        'pointn', 'coordx', 'coordy', 'validl', 'validr', ...
        'lex', 'ley', 'rex', 'rey');
    
    for pointN = 1:length(calibStrct)
        ptn = calibStrct(pointN);
        origin_x = ptn.origs(1);
        origin_y = ptn.origs(2);
        
        for pointO = 1:length(ptn.point)
            ptnn = ptn.point(pointO);
            
            vl = ptnn.validity(1);
            vr = ptnn.validity(2);
            
            lex = ptnn.left(1);
            ley = ptnn.left(2);
            
            rex = ptnn.right(1);
            rey = ptnn.right(2);
            
            fprintf(calibFile, '%f,%f,%f,%f,%f,%f,%f,%f,%f\n', ...
                pointN, origin_x, origin_y, vl, vr, lex, ley, rex, rey);
            
        end
    end
    
    fclose(calibFile);
    
end

end

