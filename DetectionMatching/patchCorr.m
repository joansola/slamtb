function sc = patchCorr(imId,pix,ptch,method)

% PATCHCORR  Correlation score of a patch in an image
%   PATCHCORR(IMID,PIX,PATCH,METHOD) computes the correlation score
%   between PATCH and the corresponding patch centered at pixel
%   PIX in the _global_ image Image{IMID}, using METHOD.
%
%   PATCH is a structure containing:
%     I:   Matrix with pixellic values of the patch
%     SI:  Sum of all pixellic values
%     SII: Sum of all squared pixellic values
%
%   METHOD is one of the following strings 'zncc', 'ssd', 'census'
%
%   See also ZNCC, SSD, CENSUS

%   (c) 2005 Joan Sola

% patch size
pSze = size(ptch.I);

% pixel centered image patch
iPatch = pix2patch(imId,pix,pSze(2),pSze(1));

if nargin<4
    method = 'zncc';
end

switch lower(method)
    case 'zncc'
        sc = zncc(...
            ptch.I,iPatch.I,...
            ptch.SI,ptch.SII,...
            iPatch.SI,iPatch.SII);
    case 'ssd'
        sc = ssd(ptch,iPatch);
    case 'census'
        sc = census(ptch,iPatch);
    otherwise
        error('Unknown correlation method.')
end










