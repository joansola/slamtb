function [newId, app, meas, exp, inn] = simDetectFeat(lmkType, lmkIds, raw, pixCov, imSize)

% SIMDETECTFEAT  Detect a new feature in simulated raw data.
%   [ID, M, E, I] = SIMDETECTFEAT(LTYPE, LIDS, RAW, PIXCOV, IMSIZE)
%   explores the raw data RAW and returns, if possible, a detected new
%   feature in structure M. the algorithm searches in RAW.points.app or
%   RAW.segments.app for entries not existing in LIDS, so appearances are
%   confounded with (compared against) landmark identifiers.
%
%   The imput parameters are:
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

