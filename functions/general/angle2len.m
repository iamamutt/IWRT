function len = angle2len(angle, distance, degrees)

if nargin < 3
    disp('Assuming angle is in degrees and not radians')
    degrees = 1;
end

if degrees
    angle = angle .* (pi / 180);
end

len = tan(angle/2) .* 2 .* distance;

end