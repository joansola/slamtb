function D = numDif(f,x0)

d = 1e-8;
dx = zeros(numel(x0),1);
f0 = f(x0);

[m,n]=size(f0);
dims = 1 + any([m,n]>1);
D = zeros(m,n,numel(x0));

for k=1:length(x0)
    dx(k) = d;
    f1 = f(x0 + dx);
    if dims == 1
        D(:,k) = (f1-f0)/d;
    else
        D(:,:,k) = (f1-f0)/d;
    end
    dx(k) = 0;
end

end


