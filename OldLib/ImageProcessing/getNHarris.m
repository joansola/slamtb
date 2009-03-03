function [r,c,s,n] = getNHarris(N,r0,c0,dr,dc,sig,thr,rad)

global Image

[r,c,s] = getHarrisRegion(r0,c0,dr,dc,sig,thr,rad);

[ss,si] = sort(s);

rs = r(si);
cs = c(si);

n = min(N,length(r));

r = rs(1:n);
c = cs(1:n);
s = ss(1:n);

