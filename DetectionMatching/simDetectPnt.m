function [Id, meas, exp, inn] = simDetectPnt(lmkIds, raw, pixCov, imSize)

%SIMDETECTPNT Detect 2D point in simulated Raw data.
%   [Y,R,NEWID] = SIMDETECTPNT(LMKIDS,RAW,PIXCOV) return the coordinates Y,
%   the covariance R and the new id NEWID of the new point, based on the
%   simulation data.
%
%   See also INITNEWLMK, SIMDETECTLIN.

%   Copyright 2009 David Marquez @ LAAS-CNRS.

apps  = raw.points.app;

[newIds,newIdsIdx] = setdiff(apps,lmkIds);

visPnts = inSquare(...
    raw.points.coord(:,newIdsIdx),   ...
    [0 imSize(1) 0 imSize(2)], ...
    imSize(1)/25);

newIds(~visPnts)    = [];
newIdsIdx(~visPnts) = [];

if ~isempty(newIds)
    i     = randi(numel(newIds));
    Id    = newIds(i);
    Idx   = newIdsIdx(i);

    % best new point coordinates and covariance
    meas.y = raw.points.coord(:,Idx);
    meas.R = pixCov;
    exp.e  = meas.y;
    exp.E  = meas.R;
    inn.z  = [0;0];
    inn.Z  = meas.R;

else

    Id  = [];
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

