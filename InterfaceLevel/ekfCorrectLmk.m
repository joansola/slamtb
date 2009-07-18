function [Rob,Sen,Lmk,Obs] = ekfCorrectLmk(Rob,Sen,Lmk,Obs)

%  EKFCORRECTLMK  Correct landmarks.
%    [ROB,SEN,LMK,OBS] = EKFCORRECTLMK(ROB,SEN,LMK,OBS) returns the
%    measurement update of robot and sensor based on EKF correction of
%    subsisting maps. For each map, first we recuperate the previously
%    stored Jacobians and the covariances matrix of the innovation, and
%    then apply the correction equations to get the updated maps
%       ROB:  the robot
%       SEN:  the sensor
%       LMK:  the set of landmarks
%       OBS:  the observation structure for the sensor SEN
%
%    See also CORRECTKNOWNLMKS, PROJECTLMK.

%   Copyright 2009 David Marquez @ LAAS-CNRS.

% get landmark range
lr = Lmk.state.r ;        % lmk range in Map

% Rob-Sen-Lmk range and Jacobian of innovation wrt active states.
if Sen.frameInMap
    rslr  = [Rob.frame.r ; Sen.frame.r ; lr]; % range of robot, sensor, and landmark
    Z_rsl = [Obs.Jac.Z_r Obs.Jac.Z_s Obs.Jac.Z_l];
    
else
    rslr  = [Rob.frame.r ; lr]; % range of robot and landmark
    Z_rsl = [Obs.Jac.Z_r Obs.Jac.Z_l];
end

% correct map. See that Jac wrt innovation is changed sign.
correctBlockEkf(rslr,-Z_rsl,Obs.inn);

% % Rob and Sen synchronized with Map
% Rob = map2rob(Rob);
% Sen = map2sen(Sen);




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

