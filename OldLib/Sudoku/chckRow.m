function opt = chckRow(opt,sure,r)

for c=1:9
    opt(opt==sure(r,c)) = [];
end

