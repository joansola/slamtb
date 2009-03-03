function nf = noiseFactor(v,k)

if nargin < 2
    k = [0.2 0.8];
end

nf = k(1);

for i = 2:length(k)
    nf = nf + k(i).*v.^(i-1);
end

nf = sqrt(nf);

return

%%

v = 0:.1:2;
vf1 = noiseFactor(v);
vf2 = noiseFactor(v,[.1 2 -.5]);

figure(99);
plot(v,vf1,v,vf2)
grid
