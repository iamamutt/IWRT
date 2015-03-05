function px = angle2pixels(angle, dista, lena, lenb)
%Convert visual angle to pixels based on distance and screen size
%  screen size may be either width, height, or diagonal (lena)
%  must also provide pixels of same size (lenb)

px = round(lenb .* (angle2len(angle, dista, true) / lena));

end

