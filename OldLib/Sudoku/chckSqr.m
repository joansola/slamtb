function opt = chckSqr(opt,sure,rr,cc)

ri = 1+3*floor((rr-1)/3);
ci = 1+3*floor((cc-1)/3);

for r=ri:ri+2
    for c = ci:ci+2
        opt(opt==sure(r,c)) = [];
    end
end
