function dur = TobiiTimeStamp(tick, tock)
%Find time duration since tobii tick (remote time)

if nargin == 0
    tick = tetio_localToRemoteTime(tetio_localTimeNow());
    tock = tetio_localToRemoteTime(tetio_localTimeNow());
end

dur = uint64(tock) - uint64(tick);

end

