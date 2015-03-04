function [calibErrL, calibErrR, avgErr] = ComputeCalibError(calibStrct, x, y)
%Calibration accuracy for each point

calibErrL = [];
calibErrR = [];

for i = 1:length(calibStrct)
    ptn = calibStrct(i);
    ox = ptn.origs(1);
    oy = ptn.origs(2);
    calibPtl = [];
    calibPtr = [];
    for j = 1:length(ptn.point)
        ptnn = ptn.point(j);
        
        vl = ptnn.validity(1);
        vr = ptnn.validity(2);
        
        lex = ptnn.left(1);
        ley = ptnn.left(2);
        
        rex = ptnn.right(1);
        rey = ptnn.right(2);
        
        if vl == 1
            lerr = xy2vec(ox*x,oy*y,lex*x,ley*y);
            calibPtl = [calibPtl, lerr];
        end
        
        if vr == 1
            rerr = xy2vec(ox*x,oy*y,rex*x,rey*y);
            calibPtr = [calibPtr, rerr];
        end
    end
    
    if ~isempty(calibPtl)
        calibErrL = [calibErrL, mean(calibPtl)];
    end
    
    if ~isempty(calibPtr)
        calibErrR = [calibErrR, mean(calibPtr)];
    end
end

if ~isempty(calibErrR) && ~isempty(calibErrL)
    avgErr = [mean(calibErrL), mean(calibErrR)];
else
    avgErr = [-1, -1];
end

end

