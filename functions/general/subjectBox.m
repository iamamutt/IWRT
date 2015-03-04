function [id, name, age, filestr] = subjectBox(filetext, ext)
% creates a subject info input box 

if nargin == 0
    filetext = 'MATLAB_Task';
    ext = '';
elseif nargin == 1
    ext = '';
end

%Get subject information
promptBox = {'Child ID:', 'Child Name', 'Birth Month (ex. 1)', 'Birth Day (ex. 13)', 'Birth Year (ex. 2013)'};
defAnswers = {'000', 'firstname', '1', '13', '2013'};
answerInput = inputdlg(promptBox, 'Info Box', 1, defAnswers, 'on');
[id, name, month, day, year] = answerInput{:};

%datestr(floor(now)) will show you the date y from a number
filestr = [filetext, '_', id, '_', name, ext];

%convert strings to numbers
month = str2double(month);
day = str2double(day);
year = str2double(year);

daysOld = datenum(date) - datenum([year, month, day, 0, 0, 0]);

age = 12 .* (daysOld / 365.242);

end