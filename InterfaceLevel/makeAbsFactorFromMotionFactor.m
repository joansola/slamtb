function [Frm, Fac] = makeAbsFactorFromMotionFactor(Frm, Fac)

Fac.type = 'absolute'; 
Fac.frames = Frm.frm;

% Ranges
Fac.state.r1 = Frm.state.r;
Fac.state.r2 = [];

% Measurement is the straight data
Fac.meas.y = Frm.state.x;
% TODO use real covariance of the robot state
sigma = 1e-6; % 1mm error 
Fac.meas.R = sigma*eye(numel(Fac.meas.y));
Fac.meas.W = Fac.meas.R ^ (-1);

% Expectation has zero covariance -- and info is not defined
Fac.exp.e = Frm.state.x; % expectation is the state

Fac.err.size  = numel(Fac.err.z);




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

