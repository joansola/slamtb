function [pix,sc] = NharrisRegion(imId,region,i,mrg,sgm,th,rd,method)

% HNARRISREGION  Get N Harris points in image region
%   NHARRISREGION(IMID,REG,I,MRG,SGM,TH,RD,MET)  gets N Harris points
%   in the I-th region in REG of the global image Image{IMID},
%   majored by MRG pixels, using HARRIS parameters SGM, TH and RD
%   as in the standard HARRIS function. The number of points to
%   extract is included in the region REG structure as N =
%   REG.numInit(I). Uses MET method for cornerness measure.
%
%   [PIX,SC] = (...) returns also the scores of the found points.
%
%   See also HARRIS, NHARRIS, GETIMAGEREGION

% (c) 2005 Joan Sola

% m        = (sgm+3)/2;
% m        = 7;
N        = region.numInit(i);
im       = getImageRegion(imId,region,i,mrg);
[pix,sc] = Nharris(im,N,mrg,sgm,th,rd,method);
pix0     = region.u0(:,i);
pix      = pix + repmat(pix0 - [mrg;mrg],1,size(pix,2));
