function winPtr = tryScreenOpen(winNum, bgColor)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

PTBfail = true;
failCounter = 0;

while PTBfail
    try
        winPtr = Screen('OpenWindow', winNum, bgColor);
        PTBfail = false;
        failCounter = failCounter + 1;
    catch
        Screen('CloseAll');
        clc
        if failCounter == 5
            tryPTBagain = input('Opening next screen failed too many times! Try again? ([y]/n)\n','s');
            if isempty(tryPTBagain) || strcmpi(tryPTBagain(1),'y')
                failCounter = 3;
                continue;
            else
                error('Quitting. Try to restart MATLAB');
            end
        else
            continue
        end
    end
end


end

