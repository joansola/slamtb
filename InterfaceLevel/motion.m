function Rob = motion(Rob, Tim)
%MOTION Robot motion.
%   ROB = MOTION(ROB, TIM) performs one EKF-prediction motion step to robot
%   Rob in the global map Map, following the motion model in Rob.motion.
%   Both Rob and Map are updated. The time information Tim is used only if
%   the motion model requires it, but it has to be provided because MOTION
%   is a generic method.
%
%   The following motion models are supported:
%       'odometry'   uses function odo3()
%       'constVel'   uses function constVel()
%   Edit this file to add new motion models.
%
%   See also SIMMOTION, CONSTVEL, ODO3, UPDATEFRAME.

%   Copyright 2009 David Marquez @ LAAS-CNRS.

global Map

% Update rob and sen info from map
Rob = map2rob(Rob);

% robot state range
r = Rob.state.r;

switch Rob.motion
    
    % const velocity
    case  {'constVel'}
        
        % motion model of the robot: mean and Jacobians
        [Map.x(r), F_x, F_u] = constVel(Map.x(r),Rob.con.u,Tim.dt);
        
        % update Rob and Map structures - mean only
        Rob = map2rob(Rob);
        
        % 3D odometry:
    case  {'odometry'}
        
        % motion model of the robot: mean and Jacobians
        [Rob.frame, F_x, F_u]   = odo3(Rob.frame,Rob.con.u);
        
        % update Rob and Map structures - mean only
        Map.x(Rob.frame.r) = Rob.frame.x;
        
        % New motion model
    % case {'myModel'} <-- uncomment
        % YOU: enter your model code here.
        
    otherwise
        
        error('??? Unknown motion model ''%s''.',Rob.motion);
end

% Covariances matrix update - this is common to all models
predictBlockEkf(r,F_x,Rob.con.U,F_u);




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

