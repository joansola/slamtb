function [pix,sc] = harrisRegion(imId,region,i,mrg,sgm,th,edgerej)

% HARRISREGION  Get the strongest Harris point in image region
%   HARRISREGION(IMID,REG,I,MRG,SGM,TH)  gets N Harris points
%   in the I-th region in REG of the global image Image{IMID},
%   majored by MRG pixels, using HARRIS parameters SGM and TH
%   as in the standard HARRIS function. The number of points to
%   extract is included in the region REG structure as N =
%   REG.numInit(I). 
%
%   HARRISREGION(...,EDGEREJ) allows for specifying the maximum ration
%   between maximum and minimum eigenvalues of the local derivatives
%   matrix. This is useful for edge rejection. The default value is 
%   EDGEREJ = 5.
%
%   [PIX,SC] = (...) returns also the scores of the found points.
%
%   See also HARRIS, NHARRIS, GETIMAGEREGION

% (c) 2005 Joan Sola

if nargout < 7
    edgerej  = 5;
end

im       = getImageRegion(imId,region,i,mrg);
[px,sc]  = harris_strongest(im,sgm,mrg+6,edgerej);
if sc < th
    pix = [];
    sc  = [];
else
    pix0     = region.u0(:,i);
    pix      = px + pix0 - [mrg;mrg];
end
