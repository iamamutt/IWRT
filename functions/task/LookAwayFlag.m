function [outflag, outbuffer] = LookAwayFlag(inflag, inbuffer, gzx, gzy, bsize)
%Fill look away buffer and set flag if conditions are met

if isempty(gzx) || isempty(gzy)
    notlooking = true;
else
    notlooking = gzx == 0 || gzy == 0;
end

outbuffer = [inbuffer, notlooking];

if length(outbuffer) >= bsize
    % adcs only has values of 0-1
    outflag = logical(round(mean(outbuffer)));
    outbuffer = [];
else
    outflag = inflag;
end


end

