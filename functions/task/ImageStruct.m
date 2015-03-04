function imStruct = ImageStruct(imgpath, setup)


% get image info
imgFileNames = listFiles(imgpath, 'png', true);

imgStructNames = cell([1, length(imgFileNames)]);

for i = 1:length(imgFileNames)
    [~, imname, imext] = fileparts(imgFileNames{i});
    imgStructNames{i} = imname;
end

% read in imStruct before scaling
imagesUnscaled = pngStruct(imgFileNames, imgStructNames);

% new image sizes based on visual angle
imFields = fieldnames(imagesUnscaled);
imresize = ones([1, length(imFields)]);

for i = 1:length(imFields)
    imresize(i) = setup.imgPixels / imagesUnscaled.(imFields{i}).d;
end

% new image struct given new size
imStruct = pngStruct(imgFileNames, ...
    imgStructNames, ...
    setup.bgColor, ...
    true, imresize);

end

