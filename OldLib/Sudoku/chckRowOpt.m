function [opt] = chckRowOpt(opt,r)

optvec = zeros(2,0);
for c = 1:9
    optvec = [optvec [opt{r,c}
                      c*ones(size(opt{r,c}))] ];
end
for n = 1:9
    idx = find(optvec(1,:) == n);
    if length(idx) == 1
        c = optvec(2,idx);
        opt{r,c} = n;
    end
end
        

