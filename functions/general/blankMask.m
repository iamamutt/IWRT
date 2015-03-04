function [ mask ] = blankMask(rect, color)
%Creates a blank image to use as a mask

if nargin == 1
    color = [0 0 0];
end

mask = zeros(rect(4), rect(3), 3);

for i = 1:3
    mask(:,:,i) = color(i);
end

mask = uint8(mask);

end

