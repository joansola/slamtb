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
%   Copyright (c) 2014-2015, Joan Sola @ IRI-UPC-CSIC,
%   SLAMTB is Copyright 2009 
%   by Joan Sola, Teresa Vidal-Calleja, David Marquez and Jean Marie Codol
%   @ LAAS-CNRS.
%   See on top of this file for its particular copyright.

%   # END GPL LICENSE

