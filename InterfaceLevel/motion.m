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

%   (c) 2009 David Marquez @ LAAS-CNRS.

global Map

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
m = Map.used;

Map.P(r,m) = F_x * Map.P(r,m);
Map.P(m,r) = Map.P(m,r) * F_x';
Map.P(r,r) = Map.P(r,r) + F_u * Rob.con.U * F_u';
