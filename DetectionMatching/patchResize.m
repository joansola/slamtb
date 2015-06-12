function rpatch = patchResize(opatch,r)

% PATCHRESIZE  Patch resize.
%   PATCHRESIZE(PATCH,R)  resizes the image of PATCH.I by a
%   factor R and crops the result to size(PATCH.I). Works only
%   for square patch images. See PIX2PATCH for information about
%   the structure PATCH.
%
%   See also PIX2PATCH, PATCHSCAN

% (c) 2006 Joan Sola @ LAAS-CNRS

I    = single(opatch.I);

% J = single(imresize2(I,r));
J = imresize2(I,r);

rpatch.I    = J;
rpatch.SI   = sum(sum(J));
rpatch.SII  = sum(sum(J.*J));
rpatch.bias = opatch.bias;



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

