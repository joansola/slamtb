function [Frm, Fac] = makeAbsFactor(Frm, Fac, Rob)

% MAKEABSFACTOR Make absolute factor
%   [Frm, Fac] = MAKEABSFACTOR(Frm, Fac, Rob) creates an absolute factor
%   Fac from the current pose and covariance of the robot Rob. It updates
%   the pointers of the frame Frm where it is applied.
%
%   See also MAKEMOTIONFACTOR, MAKEMEASFACTOR.


Fac.used   = true;  % Factor is being used ?
Fac.id     = newId; % Factor unique ID

Fac.type   = 'absolute'; % {'motion','measurement','absolute'}
Fac.rob    = Rob.rob;
Fac.sen    = [];    % sen index
Fac.lmk    = [];    % lmk index
Fac.frames = Frm.frm;

% Ranges
Fac.state.r1 = Frm.state.r;
Fac.state.r2 = [];

% Go to minimal space, 7DoF --> 6DoF
[e, V_x] = qpose2vpose(Rob.state.x);
V        = V_x * Rob.state.P * V_x';

% Measurement is the straight data
Fac.meas.y    = Rob.state.x;
Fac.meas.R    = Rob.state.P;
% Fac.meas.W = [];  % measurement information matrix

% Expectation has zero covariance -- and info is not defined
Fac.exp.e     = Fac.meas.y;                 % expectation
Fac.exp.E     = zeros(size(Fac.meas.R));    % expectation cov
%     Fac.exp.W = Fac.meas.W; % expectation information matrix

% Error is zero at this stage, and takes covariance and info from measurement
Fac.err.z     = zeros(size(e)); % error or innovation (we call it error because we are on graph SLAM)
Fac.err.Z     = V;              % error cov matrix
Fac.err.W     = V^-1;           % error information matrix
Fac.err.Wsqrt = chol(Fac.err.W);

% Jacobians are zero at this stage. Just make size correct.
Fac.err.J1    = zeros(6,Rob.state.size); % Jac. of error wrt. node 1

Fac.err.size  = numel(e);

% Append factor to Frame's factors list.
Frm.factors   = [Frm.factors Fac.fac]; 




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

