function files = listFiles(fullpath, ext, traverse)
% lists files within a specified path
% defaults to finding all file types

switch nargin
    case 0
        fullpath = pwd;
        ext = '*';
        traverse = false;
    case 1
        ext = '*';
        traverse = false;
    case 2
        traverse = false;
    case 3
    otherwise
        error('too many args');
end


if traverse
    pathCell = textscan(genpath(fullpath), '%s', 'delimiter', pathsep);
    paths = pathCell{1};
else
    paths = {fullpath};
end


files = {};

for p = 1:length(paths)
   fileStruct = dir(paths{p});
   fileStruct = fileStruct(~cellfun(@(x) x, {fileStruct(:).isdir}));
   if ~isempty(fileStruct)
       for q = 1:length(fileStruct)
           files = [files; fullfile(paths(p), fileStruct(q).name)];
       end
   end
end


if ~strcmp(ext, '*') && ~isempty(files)
    useTheseCells = false(1, length(files));
    for i = 1:length(files)
        [~, ~, fext] = fileparts(files{i});
        useTheseCells(i) = strcmpi(['.', ext], fext);
    end
    files = files(useTheseCells);
end

end