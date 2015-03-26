function winPtr = tryScreenOpen(winNum, bgColor)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

PTBfail = true;
failCounter = 0;

while PTBfail
    try
        winPtr = Screen('OpenWindow', winNum, bgColor);
        PTBfail = false;
    catch
        PTBfail = true;
        Screen('CloseAll');
        clc
        failCounter = failCounter + 1;
        disp(['failed ', num2str(failCounter), ' time(s)...']);
        if failCounter == 6
            tryPTBagain = input('Opening next screen failed too many times! Try again? ([y]/n)\n','s');
            if isempty(tryPTBagain) || strcmpi(tryPTBagain(1),'y')
                failCounter = 3;
                continue;
            else
                error('Quitting. Try to restart MATLAB or PC');
            end
        else
            continue
        end
    end
end


end

