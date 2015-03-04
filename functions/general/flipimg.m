function fimg = flipimg(img, horz)
%Flips an image vertically or horizontally

if nargin == 1
    horz = true;
end

fimg = uint8(zeros(size(img)));

if horz
    for i = 1:size(img, 3)
        fimg(:,:,i) = img(:,end:-1:1,i);
    end
else
    for i = 1:size(img, 3)
        fimg(:,:,i) = img(end:-1:1,:,i);
    end
end


end

