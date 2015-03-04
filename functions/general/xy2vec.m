function vec = xy2vec(x1, y1, x2, y2)

if nargin == 2
    xd = x1;
    yd = y1;
else
    xd = x2-x1;
    yd = y2-y1;
end

vec = sqrt((xd).^2 + (yd).^2);

end