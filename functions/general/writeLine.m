function writeLine(file, cellData, sep)
%Write a line to a text file using data and file separator

if nargin < 2
    error('need file handle and data to write');
elseif nargin == 2
    sep = ',';
end

n = size(cellData, 2);

for i = 1:n
    if i == n
      fprintf(file, '%s\n', num2str(cellData{i}));  
    else
      fprintf(file, ['%s', sep], num2str(cellData{i}));  
    end
end

end