function tock = timeStamp(tick)
%Find time duration since PTB tick (microseconds)

tock = 1000000 .* (GetSecs-tick);

end

