function [Lmk, Frm, Fac] = makeMeasFactor(Lmk, Obs, Frm, Fac)

% MAKEMEASFACTOR Make measurement factor.
%
% [Lmk, Frm, Fac] = MAKEMEASFACTOR(Lmk, Obs, Frm, Fac) creates a new
% measurement factor Fac linking frame Frm to landmark Lmk, using the
% observation informaiton in Obs and the type in Lmk.

% FIXME: This help does not match the API:
% [Lmk, Frm, Fac] = MAKEMEASFACTOR(Lmk, Obs, Frm, Fac, numFrames) creates a
% new measurement factor Fac linking a NFrms number of frames Frm to
% landmark Lmk, using the observation informaiton in Obs and the type in
% Lmk. The variable Frm should be a vector with NFrms elements. The
% landmark will always be the last element (this influenciates the index of
% range and jacobians)

%   Copyright 2015-     Joan Sola @ IRI-UPC-CSIC

nfrms = numel(Frm);

Fac.used = true; % Factor is being used ?
Fac.id = newId('Fac'); % Factor unique ID
Fac.new  = true;  % Mark factor as new (to be cleared by GTSAM functions)

Fac.type = 'measurement'; % {'motion','measurement','absolute'}
Fac.rob = Frm(1).rob;
Fac.sen = Obs.sen;
Fac.lmk = Obs.lmk;
Fac.frames = [Frm.frm];

% Measurement is the straight data
Fac.meas.y = Obs.meas.y;
Fac.meas.R = Obs.meas.R;
Fac.meas.W = Obs.meas.R^-1; % measurement information matrix

% Expectation has zero covariance -- and info in not defined
Fac.exp.e = Fac.meas.y; % expectation
Fac.exp.E = zeros(size(Obs.meas.R)); % expectation cov
%     Fac.exp.W = Fac.meas.W; % expectation information matrix

% Error is zero at this stage, and takes covariance and info from measurement
Fac.err.z     = zeros(size(Fac.meas.y)); % error or innovation (we call it error because we are on graph SLAM)
Fac.err.Z     = Fac.meas.R;              % error cov matrix
Fac.err.W     = Fac.meas.W;              % error information matrix
Fac.err.Wsqrt = chol(Fac.err.W);
Fac.err.size  = numel(Fac.err.z);

% Append factor to Frame's and Lmk's factors lists.
for frm = 1:nfrms
    Frm(frm).factors = [Frm(frm).factors Fac.fac]; 
end
Lmk.factors = [Lmk.factors Fac.fac];

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

