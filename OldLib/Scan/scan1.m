function [subPix,mxSc,ptchOut] = scan1(ptchIn,region,m,locTh)

global Image

xa = region.xa;
ya = region.ya;
Xm = region.Xm;
XM = region.XM;
Ym = region.Ym;
YM = region.YM;
mx = region.mx;
my = region.my;

% bounding box in integer pixels
[scIm,scIm0] = par2scIm(Xm,XM,Ym,YM,1);





subPix = 0;
mxSc = 0;
ptchOut = 0;
