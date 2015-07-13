function [Frm_old, Frm_new, Fac] = makeMotionFactor(Frm_old, Frm_new, Fac, factorRob)

% MAKEMOTIONFACTOR Make motion factor
%   [Frm_old, Frm_new, Fac] = MAKEABSFACTOR(Frm_old, Frm_new, Fac, factorRob) 
%   creates a motion factor Fac from the past frame Frm_old to the current
%   frame Frm_new, using the motion measurement and covariance of the robot
%   factorRob. It updates the pointers of the frames where it is applied.
%
%   See also MAKEABSFACTOR, MAKEMEASFACTOR.

Fac.used = true; % Factor is being used ?
Fac.id = newId; % Factor unique ID

Fac.type = 'motion'; % {'motion','measurement','absolute'}
Fac.rob = factorRob.rob;
Fac.sen = [];
Fac.lmk = [];
Fac.frames = [Frm_old.frm Frm_new.frm];

% Ranges
Fac.state.r1 = Frm_old.state.r;
Fac.state.r2 = Frm_new.state.r;

% Project into manifold, 7DoF --> 6DoF
[e, V_x] = qpose2vpose(factorRob.state.x);
V = V_x * factorRob.state.P * V_x';

% Measurement is the straight data
Fac.meas.y = factorRob.state.x;
Fac.meas.R = factorRob.state.P;
% Fac.meas.W = []; % measurement information matrix

% Expectation has zero covariance -- and info in not defined
Fac.exp.e = Fac.meas.y; % expectation
Fac.exp.E = zeros(size(Fac.meas.R)); % expectation cov
%     Fac.exp.W = Fac.meas.W; % expectation information matrix

% Error is zero at this stage, and takes covariance and info from measurement
Fac.err.z     = zeros(size(e)); % error or innovation (we call it error because we are on graph SLAM)
Fac.err.Z     = V;              % error cov matrix
Fac.err.W     = V^-1;           % error information matrix
Fac.err.Wsqrt = chol(Fac.err.W);

% Jacobians are zero at this stage. Just make size correct.
Fac.err.J1 = zeros(6,factorRob.state.size); % Jac. of error wrt. node 1
Fac.err.J2 = zeros(6,factorRob.state.size); % Jac. of error wrt. node 2

Fac.err.size  = numel(e);

% Append factor to Frames' factors lists.
Frm_old.factors = [Frm_old.factors Fac.fac]; 
Frm_new.factors = [Frm_new.factors Fac.fac]; 



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

