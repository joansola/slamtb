function [opt] = chckSqrOpt(opt,sr,sc)

optvec = zeros(3,0);

for r = 3*sr-2:3*sr;
    for c = 3*sc-2:3*sc
        optvec = [optvec [opt{r,c}
                          r*ones(size(opt{r,c}))
                          c*ones(size(opt{r,c}))] ];
    end
end

for n = 1:9
    idx = find(optvec(1,:) == n);
    if length(idx) == 1
        r = optvec(2,idx);
        c = optvec(3,idx);
        opt{r,c} = n;
    end
end
        

