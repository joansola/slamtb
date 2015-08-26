function [Lmk, Fac] = makeInvDepPriorFactor(Lmk, Obs, Fac, Opt)

% MAKEMEASFACTOR Make measurement factor.
%   [Lmk, Frm, Fac] = MAKEMEASFACTOR(Lmk, Obs, Frm, Fac) creates a new
%   measurement factor Fac linking frame Frm to landmark Lmk, using the
%   observation informaiton in Obs.

%   Copyright 2015-     Joan Sola @ IRI-UPC-CSIC

Fac.used = true; % Factor is being used ?
Fac.id = newId('Fac'); % Factor unique ID
Fac.new  = true;  % Mark factor as new (to be cleared by GTSAM functions)

Fac.type = 'absolute'; % {'motion','measurement','absolute'}
Fac.rob = [];
Fac.sen = Obs.sen; % EP-WARNING: Does it make sense to store the sensor into this factor?
Fac.lmk = Obs.lmk;
Fac.frames = [];

% Ranges
Fac.state.r1 = Lmk.state.r(3); % prior only on the inverse depth
Fac.state.r2 = [];

% Measurement is the straight data
Fac.meas.y = Opt.init.idpPnt.nonObsMean;
Fac.meas.R = Opt.init.idpPnt.nonObsStd^2;
Fac.meas.W = Fac.meas.R^-1; % measurement information matrix

% Expectation has zero covariance -- and info in not defined
Fac.exp.e = Fac.meas.y; % expectation
Fac.exp.E = zeros(size(Fac.meas.R)); % expectation cov
%     Fac.exp.W = Fac.meas.W; % expectation information matrix

% Error is zero at this stage, and takes covariance and info from measurement
Fac.err.z     = zeros(size(Fac.exp.e)); % error or innovation (we call it error because we are on graph SLAM)
Fac.err.Z     = Fac.meas.R;              % error cov matrix
Fac.err.W     = Fac.meas.W;              % error information matrix
Fac.err.Wsqrt = chol(Fac.err.W);

% Jacobians are zero at this stage. Just make size correct.
Fac.err.J1 = 0; % Jac. of error wrt. lmk inverse depth

Fac.err.size  = numel(Fac.err.z);

% Append factor to Frame's and Lmk's factors lists.
Lmk.factors = [Lmk.factors Fac.fac];



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

