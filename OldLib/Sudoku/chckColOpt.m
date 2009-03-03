function [opt] = chckColOpt(opt,c)

optvec = zeros(2,0);
for r = 1:9
    optvec = [optvec [opt{r,c}
                      r*ones(size(opt{r,c}))] ];
end
for n = 1:9
    idx = find(optvec(1,:) == n);
    if length(idx) == 1
        r = optvec(2,idx);
        opt{r,c} = n;
    end
end
        

