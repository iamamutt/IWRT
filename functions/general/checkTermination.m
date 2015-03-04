function terminate = checkTermination(keys)

if nargin == 0
    keys = KbName('ESCAPE');
end

btnPressed = false;
btnCodes = [];
terminate = false;

[btnPressed, ~, btnCodes] = KbCheck;

if btnPressed
    
    btns = find(btnCodes);
    
    if length(keys) ~= length(btns)
        terminate = false;
    else
        
        keyCodeFound = all(sort(keys) == sort(btns));
        
        if keyCodeFound
            terminate = true;
        end
        
    end
    
end

end