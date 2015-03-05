function [calibStrct, Calib] = ManageCalibration(Calib)
%Manage calibration workflow for infants

calibStrct = [];
close All

while true
    if Calib.automatic
        assert(Calib.points.n >= 2 && length(Calib.points.x)==length(Calib.points.y), ...
            'Not enough calibration points or lengths of points don''t match');
    else
        Calib.points.x = [];
        Calib.points.y = [];
        Calib.points.n = 0;
    end
    
    try
        % new calibration
        if Calib.automatic
            nPoints = Calib.points.n;
            pointOrder = randperm(nPoints);
            [calibStrct, Calib] = AutoCalibrate(Calib, pointOrder, false, []);
        else
            [calibStrct, Calib, nPoints] = ManualCalibrate(Calib);
            pointOrder = 1:nPoints;
            Calib.points.n = nPoints;
        end

        % show calibration validity
        PlotCalibrationPoints(calibStrct, Calib, pointOrder);
        
        while true
            
            % stop calibration if all good
            acceptCalib = input('Accept calibration? ([y]/n):\n','s');
            if isempty(acceptCalib) || strcmpi(acceptCalib(1),'y')
                tetio_stopCalib;
                close All;
                return;
            end
            
            % ask to redo or add more points if not all good
            if Calib.automatic
                acceptCalib = input('Redo all points (a) or just some of the points (b)? ([a]/b):\n','s');
            else
                acceptCalib = input('Redo all points (a) or add more points (b)? ([a]/b):\n','s');
            end
            
            % start back up from top or start redo process
            if isempty(acceptCalib) || strcmpi(acceptCalib(1),'a')
                tetio_stopCalib;
                close All;
                break;
            else
                
                if Calib.automatic
                    acceptCalib = input('Please enter (space separated) the point numbers that you wish to recalibrate e.g. 1 3 4:\n', 's');
                    recalibpts = str2num(acceptCalib);
                    if isempty(recalibpts)
                        break
                    end
                    close All;
                    [calibStrct, Calib] = AutoCalibrate(Calib, pointOrder, true, recalibpts);

                else
                    close All;
                    [calibStrct, Calib, nPoints] = ManualCalibrate(Calib, nPoints, true);
                    pointOrder = 1:nPoints;
                    Calib.points.n = nPoints;
                end
                
                PlotCalibrationPoints(calibStrct, Calib, pointOrder);
                
            end
        end
    catch
        Screen('CloseAll');
        tetio_stopCalib;
        acceptCalib = input('Error: Not enough calibration data. Do you want to try again([y]/n):\n','s');
        if isempty(acceptCalib) || strcmpi(acceptCalib(1),'y')
            continue;
        else
            return;
        end
    end
    
end

end