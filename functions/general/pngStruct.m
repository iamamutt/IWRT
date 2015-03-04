function imgs = pngStruct(filenames, codes, bgcolor, resizeimg, rescale)
% filenames is a list of full path image strings
% codes is a variable name to give each image when calling the struct (must be a
% cell)

if nargin == 1
    nFiles = length(filenames);
    codes = cell(1, nFiles);
    for n = 1:nFiles
        codes{n} = ['im' num2str(n)];
    end
    bgcolor = [0 0 0];
    resizeimg = 0;
    rescale = ones([1, length(filenames)]);
elseif nargin == 2
    bgcolor = [0 0 0];
    resizeimg = 0;
    rescale = ones([1, length(filenames)]);
elseif nargin == 3
    resizeimg = 0;
    rescale = ones([1, length(filenames)]);
end

for i = 1:length(filenames)
    [im, ~, alpha] = imread(filenames{i}, 'png');
    
    if isempty(alpha)
        alpha = uint8(ones(size(im, 1), size(im, 2)) .* 255);
    end
    
    alphaScale = double(alpha) ./ 255;
    
    % background color
    for j = 1:3
        imlayer = double(im(:,:,j));
        imlayer = imlayer .* alphaScale;
        bglayer = (1-alphaScale) .* bgcolor(j);
        im(:,:,j) = uint8(floor(imlayer + bglayer));
    end
    
    rgba = im;
    rgba(:, :, 4) = alpha;
    
    if resizeimg
        im = imresize(im, rescale(i));
        rgba = imresize(rgba, rescale(i));
    end
    
    imgs.(codes{i}).rgb = im;
    imgs.(codes{i}).rgba = rgba;
    imgs.(codes{i}).h = size(im, 1);
    imgs.(codes{i}).w = size(im, 2);
    imgs.(codes{i}).d = xy2vec(size(im, 1), size(im, 2));
    imgs.(codes{i}).rect = [0 0 size(im, 2) size(im, 1)];
    imgs.(codes{i}).midx = size(im, 2) / 2;
    imgs.(codes{i}).midy = size(im, 1) / 2;
    
end


end