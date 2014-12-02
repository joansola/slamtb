function ptch = pix2patch(I,pix,hsize,vsize)
%
% PIX2PATCH  Patch extraction
%   PATCH = PIX2PATCH(I,PIX,HSIZE,VSIZE)  extracts from the image I(MxN) the
%   patch of size HSIZExVSIZE centered at pixel PIX. If VSIZE is not
%   specified, a square patch HSIZExHSIZE is considered.
%
%   PATCH = PIX2PATCH(IMID,PIX,HSIZE,VSIZE)  extracts from the global image
%   Img{IMID} the patch of size HSIZExVSIZE centered at pixel PIX. IMID
%   is an integer. If VSIZE is not specified, a square patch HSIZExHSIZE is
%   considered
%
%   PATCH is a structure containing:
%     I    : matrix with all pixels - the patch itself
%     SI   : sum of all patch pixels;
%     SII  : sum of all squared pixels

global Img
    
if isscalar(I)  % ndims(I) == 1
    imId = I;
else
    Img{1} = I;
    imId  = 1;
end

if nargin < 4
    vsize = hsize;
end

% minimum necessary margins from central pixel to image edges
h2 = (hsize-1)/2;
v2 = (vsize-1)/2;

pix0 = round(pix); % in case the given pixel is not integer

if inSquare(pix,[1+h2 size(Img{imId},2)-h2 1+v2 size(Img{imId},1)-v2])

    ptch.I    = single(Img{imId}(pix0(2)-v2:pix0(2)+v2,pix0(1)-h2:pix0(1)+h2));
    ptch.SI   = sum(sum(ptch.I));
    ptch.SII  = sum(sum(ptch.I.*ptch.I));

else % pixel is too close to the edge: return blank patch

    ptch.I = single(zeros(vsize,hsize));
    [ptch.SI,ptch.SII] = deal(0);
    ptch.bias = [0;0];

end
% ========== End of function - Start GPL license ==========


%   # START GPL LICENSE

%---------------------------------------------------------------------
%
%   This file is part of SLAMTB, a SLAM toolbox for Matlab.
%
%   SLAMTB is free software: you can redistribute it and/or modify
%   it under the terms of the GNU General Public License as published by
%   the Free Software Foundation, either version 3 of the License, or
%   (at your option) any later version.
%
%   SLAMTB is distributed in the hope that it will be useful,
%   but WITHOUT ANY WARRANTY; without even the implied warranty of
%   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%   GNU General Public License for more details.
%
%   You should have received a copy of the GNU General Public License
%   along with SLAMTB.  If not, see <http://www.gnu.org/licenses/>.
%
%---------------------------------------------------------------------

%   SLAMTB is Copyright:
%   Copyright (c) 2008-2010, Joan Sola @ LAAS-CNRS,
%   Copyright (c) 2010-2013, Joan Sola,
%   Copyright (c) 2014-    , Joan Sola @ IRI-UPC-CSIC,
%   SLAMTB is Copyright 2009 
%   by Joan Sola, Teresa Vidal-Calleja, David Marquez and Jean Marie Codol
%   @ LAAS-CNRS.
%   See on top of this file for its particular copyright.

%   # END GPL LICENSE

