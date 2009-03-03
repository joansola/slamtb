function ptch = pix2patch(I,pix,hsize,vsize)
%
% PIX2PATCH  Patch extraction
%   PATCH = PIX2PATCH(I,PIX,HSIZE,VSIZE)  extracts from the image I(MxN) the
%   patch of size HSIZExVSIZE centered at pixel PIX. If VSIZE is not
%   specified, a square patch HSIZExHSIZE is considered.
%
%   PATCH = PIX2PATCH(IMID,PIX,HSIZE,VSIZE)  extracts from the global image
%   Image{IMID} the patch of size HSIZExVSIZE centered at pixel PIX. IMID
%   is an integer. If VSIZE is not specified, a square patch HSIZExHSIZE is
%   considered
%
%   PATCH is a structure containing:
%     I    : matrix with all pixels - the patch itself
%     SI   : sum of all patch pixels;
%     SII  : sum of all squared pixels
%     bias : sub-pixellic bias

global Image
    
if isscalar(I)  % ndims(I) == 1
    imId = I;
else
    Image{1} = I;
    imId  = 1;
end

if nargin < 4
    vsize = hsize;
end
h2 = (hsize-1)/2;
v2 = (vsize-1)/2;

pix0 = round(pix);

if inSquare(pix,[1+h2 size(Image{imId},2)-h2 1+v2 size(Image{imId},1)-v2])

    ptch.I    = single(Image{imId}(pix0(2)-v2:pix0(2)+v2,pix0(1)-h2:pix0(1)+h2));
    ptch.SI   = sum(sum(ptch.I));
    ptch.SII  = sum(sum(ptch.I.*ptch.I));
    ptch.bias = pix-pix0;

else
    ptch.I = single(zeros(vsize,hsize));
    [ptch.SI,ptch.SII] = deal(0);
    ptch.bias = [0;0];
end
