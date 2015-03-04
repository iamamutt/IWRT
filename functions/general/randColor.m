function [ rgb ] = randColor(n)
%Random rgb values

if nargin == 0
    n = 1;
end

rgb = randi([1 255],n,3);

end

