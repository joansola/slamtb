function rmse = robotRmse(Rob,SimRob)

% ROBOTRMSE Robot's estimation root mean squared error.
%   ROBOTRMSE(ROB,SIMROB) computes the RMSE of the estimated robot ROB wrt
%   ground truth SIMROB. The result is the RMSE corresponding to the 6-DOF
%   robot frame expressed in Euler angles.
%
%   See also RMSE, RMSEANALYSIS, RMSEPLOTS, SLAMTBSLAVE.

%   Copyright 2009 Joan Sola @ LAAS-CNRS.

global Map;

% frame range
s = 1:7;

% ground truth
x = SimRob.frame.x(s);

% estimate - quat
r = Rob(1).frame.r(s);
m = Map.x(r);
P = Map.P(r,r);

% go to Euler
x = qpose2epose(x);
[m,P] = propagateUncertainty(m,P,@qpose2epose);

% estimation error
e      = m - x;
e(4:6) = normAngle(e(4:6));
std    = sqrt(diag(P));
rmse   = [e' std'];



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

