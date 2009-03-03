function opt = chckIsoOpt(opt)

% CHKISOOPT  Check for isolated options


% Detect rows and cols isolated options
for i=1:9
    opt = chckRowOpt(opt,i);
    opt = chckColOpt(opt,i);
end

% Detect squares isolated options
for sr=1:3
    for sc=1:3
        opt = chckSqrOpt(opt,sr,sc);
    end
end


