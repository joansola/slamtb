function [newId, app, meas, exp, inn] = simDetectFeat(lmkType, lmkIds, raw, pixCov, imSize)

% SIMDETECTFEAT  Detect a new feature in simulated raw data.
%   [ID, M, E, I] = SIMDETECTFEAT(LTYPE, LIDS, RAW, PIXCOV, IMSIZE)
%   explores the raw data RAW and returns, if possible, a detected new
%   feature in structure M. the algorithm searches in RAW.points.app or
%   RAW.segments.app for entries not existing in LIDS, so appearances are
%   confounded with (compared against) landmark identifiers.
%
%   The input parameters are:
%       LTYPE  the landmark type: '???Pnt' or '???Lin'.
%       LIDS   the existing landmark IDs in Lmk().
%       RAW    the raw data, RAW.points or RAW.segments.
%       PIXCOV the pixel covariances matrix.
%       IMSIZE the image size.
%
%   Expectation E and innovation I structureas are also provided for
%   helping the graphics functions further down in the main SLAM algorithm
%   loop. These returned structures mimic the ones in Obs:
%       M.y, M.R -> measurement noise and cov.
%       E.e, E.E -> expectation mean and cov.
%       I.z, I.Z -> innovation mean and cov.
%
%   This function is able to detect both points and lines. 
%       - For points, we have I = E = M. M.y is a pixel, M.R is PIXCOV.
%       - For lines, we have:
%           M.y = [x1;y1;x2;y2] a 2D segment with 2 endpoints
%           M.R = blkdiag(PIXCOV, PIXCOV)
%           (E.e,E.E) = (y,R) in homogeneous coordinates
%           I.z = [0;0]
%           I.Z = PIXCOV.
%
%   See also SIMDETECTPNT, SIMDETECTLIN, PROPAGATEUNCERTAINTY, SEG2HMGLIN.

%   Copyright 2008-2009 Joan Sola @ LAAS-CNRS.

switch lmkType(4:6)

    case 'Pnt'
        [newId, meas, exp, inn] = simDetectPnt(lmkIds, raw, pixCov, imSize);
        app    = newId;

    case 'Lin'
        [newId, meas, exp, inn] = simDetectLin(lmkIds, raw, pixCov);
        app    = newId;
        
    otherwise

        error('??? Unknown landmark type ''%s''.',lmkType)

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

