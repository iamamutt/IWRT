function calibStrct = CalibrationStruct(CalibrationPlotArray)
%Convert tobii calibplotarray to struct

NumCalibPoints = length(CalibrationPlotArray)/8;

if (NumCalibPoints == 0 )
    calibStrct = [];
    disp('no calib point found');
    return;
end

j = 1;
for i = 1:NumCalibPoints
    OrignalPoints(i,:) = [CalibrationPlotArray(j) CalibrationPlotArray(j+1)];
    j = j+8;
end
lp = unique(OrignalPoints,'rows');
for i = 1:length(lp)
    calibStrct(i).origs = lp(i,:);
    calibStrct(i).point =[];
end
j = 1;
for i = 1:NumCalibPoints
    for k = 1:length(lp)
        if ((CalibrationPlotArray(j)==calibStrct(k).origs(1)) && (CalibrationPlotArray(j+1)==calibStrct(k).origs(2)))
            n = size(calibStrct(k).point,2);
            calibStrct(k).point(n+1).validity = [CalibrationPlotArray(j+4) CalibrationPlotArray(j+7)];
            calibStrct(k).point(n+1).left= [CalibrationPlotArray(j+2) CalibrationPlotArray(j+3)];
            calibStrct(k).point(n+1).right= [CalibrationPlotArray(j+5) CalibrationPlotArray(j+6)];
        end
    end
    j = j+8;
end

end

