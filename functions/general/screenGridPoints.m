function [ x, y, xmat, ymat ] = screenGridPoints(screenWidth, screenHeight, nx, ny)
%Return coordinates for evenly distributed points along the screen

% screenWidth = 1920; screenHeight=1680; nx=5; ny=3;


x = linspace(1, screenWidth, nx);
y = linspace(1, screenHeight, ny);

xmat = zeros([length(y), length(x)]);
ymat = zeros([length(y), length(x)]);

for n = 1:length(x)
    for m = 1:length(y)
        xmat(m,n) = x(n);
        ymat(m,n) = y(m);
    end
end

end

