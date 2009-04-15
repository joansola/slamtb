function Rob = motion(Rob, Tim)
% MOTION  Simulated robot motion.
%   Rob = MOTION(Rob, Tim) performs one motion step to robot Rob, following
%   the motion model in Rob.motion. The time information Tim is used only
%   if the motion model requires it, but it has to be provided because
%   MOTION is a generic method.
%
%   See also SIMMOTION, CONSTVEL, ODO3, UPDATEFRAME.

global Map
% motion model of the  robot:
switch Rob.motion
    
    % const velocity
    case  {'constVel'}
        
        r = Rob.state.r;
        
        [Map.x(r), F_x, F_u] = constVel(Map.x(r),Rob.con.u,Tim.dt);
        Rob.frame.x = Map.x(r(1:7));
        Rob.vel.x   = Map.x(r(8:13));
        Rob.frame   = updateFrame(Rob.frame);
        
        % other motion type:
    case  {'odometry'}
        
        r = Rob.state.r;
        [Rob.frame, F_x, F_u]   = odo3(Rob.frame,Rob.con.u);
        Map.x(r(1:7)) = Rob.frame.x;
        
    otherwise
       
        error('??? Unknown motion model ''%s''.',Rob.motion);
end

m = Map.used;

Map.P(r,m) = F_x * Map.P(r,m);
Map.P(m,r) = Map.P(m,r) * F_x';
Map.P(r,r) = Map.P(r,r) + F_u * Rob.con.U * F_u';
