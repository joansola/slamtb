function opt = initOpt(sure)

% INITOPT  Initialize all options

opt{9,9}=[]; % preallocation

for r = 1:9
    for c = 1:9
        if sure(r,c) ~= 0
            opt{r,c}  = sure(r,c);
        else
            opt{r,c}  = 1:9;
        end
    end
end
