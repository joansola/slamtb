function [newId, meas, exp, inn] = simDetectLin(lmkIds, raw, pixCov)

% SIMDETECTLIN  Detect 2D segment in simulated raw data.

%   Copyright 2008-2009 Joan Sola @ LAAS-CNRS.

apps  = raw.segments.app;

[newIds,newIdsIdx] = setdiff(apps,lmkIds);

if ~isempty(newIds)
    newId    = newIds(1);
    newIdx   = newIdsIdx(1);

    % best new point coordinates and covariance
    y = raw.segments.coord(:,newIdx);
    R = blkdiag(pixCov,pixCov);

    meas.y = y;
    meas.R = R;
    [exp.e,exp.E] = propagateUncertainty(y,R,@seg2hmgLin);
    inn.z  = [0;0];
    inn.Z  = R;


else

    newId  = [];
    meas.y = [];
    meas.R = [];
    exp.e  = [];
    exp.E  = [];
    inn.z  = [];
    inn.Z  = [];

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

