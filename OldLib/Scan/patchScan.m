function ...
    [subPix,mxSc,ptch] = patchScan(imId,ptch,region,pix,globTh,locTh,pixDist)

% PATCHSCAN  Scan patch inside an image region.
%   PATCHSCAN(IMID,PATCH,REGION,PIX0) scans the region REGION
%   of the global image Image{IMID} for a patch PATCH, starting at
%   pixel PIX0, and returns the pixel at which the best match
%   occurred, with sub-pixellic resolution. To allow for patches 
%   that are not defined around an integer pixel, PATCH.bias is 
%   added as a bias to the resulting matched pixel.
%
%   PATCHSCAN(...,GLOBTH) allows to control the correlation score
%   threshold at which the global scan pattern switches to the
%   local scan one. The dafault value is GLOBTH = 0.9.
%
%   PATCHSCAN(...,GLOBTH,LOCTH) allows to control the correlation
%   score threshold below which the local scan pattern stops
%   expanding its [small] region of scan. If so, the resulting
%   pixel will be the one in the maximum of the scanned region,
%   but it may not be the true local maximum. The default value
%   is LOCTH = 0.95.
%
%   [PIX,SC] = PATCHSCAN(...) gives the score at the best match.
%
%   [PIX,SC,PATCH] = PATCHSCAN(...) returns also the patch around
%   the rounded pixel PIX. [The residual after rounding should be
%   used as a future PATCHBIAS if the returned patch were to 
%   be used as a reference for a new scan.]
%
%   See also GLOBALSCAN3, LOCALSCAN3, MAXPARAB2, COV2PAR

% (c) 2005 Joan Sola


switch nargin
    case {1,2,3,4}
        globTh = 0.9;
        locTh  = 0.95;
        pixDist = 2; % pixel spacing for global scan
    case 5
        locTh  = 0.95;
        pixDist = 2; % pixel spacing for global scan
    case 6
        pixDist = 2; % pixel spacing for global scan

end

% integer pixel and residual
pix0   = round(pix); % integer pixel
patchBias = ptch.bias; % residual or bias

% global scan at pixDist pix spacing
[mxPix,mxSc,scIm,scIm0,dir]=globalScan3(...
    imId,...
    ptch,...
    region,...
    pix0,...
    globTh,...
    pixDist    );

% local scan at 1 pix spacing
[mxPix,mxSc,scIm] = localScan3(...
    imId,...
    ptch,...
    mxPix,...
    scIm,...
    scIm0,...
    dir,...
    1,...
    locTh);

% sub-pixel resolution
subPix = mxPix + maxParab2(...
    scIm(2,2),...
    scIm(2,1),...
    scIm(2,3),...
    scIm(1,2),...
    scIm(3,2));

% full real precision pixel
subPix = subPix + patchBias;

% new patch if required at output
if nargout == 3
    % Re-centered max pix (in case subPix + patchBias residual
    % accumulates to more than half a pixel, resulting in a new
    % subPix too far from the integer pixel)
%     mxPix = round(subPix);

    % new patch
    hSze  = size(ptch.I,2);
    vSze  = size(ptch.I,1);
    ptch = pix2patch(imId,subPix,hSze,vSze);

end
