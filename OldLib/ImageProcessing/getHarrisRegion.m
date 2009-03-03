function [r,c,s] = getHarrisRegion(r0,c0,dr,dc,sig,thr,rad);

global Image

im1 = Image(r0:r0+dr,c0:c0+dc);

[cim,r,c,s] = harris(im1,sig,thr,rad);

% valid corners only at more than 2*sigma from border
rv = (r>2*sig)&(r<dr-2*sig); % valid rows
cv = (c>2*sig)&(c<dc-2*sig); % valid columns
iv = rv&cv; % valid corner indices

r = r(iv);
c = c(iv);
s = s(iv);

r = r + r0;
c = c + c0;


