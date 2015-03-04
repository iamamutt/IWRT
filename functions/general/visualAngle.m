function degrees = visualAngle(len, distance)

rads = 2 .* atan(len / (2 .* distance));
degrees = rads .* (180 / pi);

end