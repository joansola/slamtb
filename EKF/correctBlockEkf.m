function correctBlockEkf(r,H,Inn)

% CORRECTBLOCKEKF  Correct in block-defined EKF.
%   CORRECTBLIOCKEKF(r,H,INN) performs a correction step to global map Map
%   by using the observation Jacobian H, referring to range r in the map,
%   and innovation INN. 
%
%   INN is a structure containing:
%       .z      the innovation,         z  = y-h(x)
%       .Z      its covariances matrix, Z  = HPH' + R
%       .iZ     the inverse covariance, iZ = Z^-1.

%   Copyright 2008-2009 Joan Sola @ LAAS-CNRS.

global Map

% Kalman gain
K = Map.P(Map.used,r) * H' * Inn.iZ;   % K = PH'Z^-1

% mean and cov. updates
Map.x(Map.used)          = Map.x(Map.used) + K*Inn.z;
Map.P(Map.used,Map.used) = Map.P(Map.used,Map.used) - K*Inn.Z*K';



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

%   SLAMTB is Copyright 2007,2008,2009 
%   by Joan Sola, David Marquez and Jean Marie Codol @ LAAS-CNRS.
%   See on top of this file for its particular copyright.

%   # END GPL LICENSE

