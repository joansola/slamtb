function Rob = simMotion(Rob, Tim)
% SIMMOTION  Simulated robot motion.
%   Rob = SIMMOTION(Rob, Tim) performs one motion step to robot Rob,
%   following the motion model in Rob.motion. The time information Tim is
%   used only if the motion model requires it, but it has to be provided
%   because MOTION is a generic method.
%
%   See also MOTION, CONSTVEL, ODO3, UPDATEFRAME.


% motion model of the  robot:
switch Rob.motion

    % const velocity
    case  {'constVel'}
        
        Rob.state.x = constVel(Rob.state.x,Rob.con.u,Tim.dt);
        Rob.frame.x = Rob.state.x(1:7);
        Rob.vel.x   = Rob.state.x(8:13);
        Rob.frame   = updateFrame(Rob.frame);
        Rob.frame.q = normvec(Rob.frame.q);

        % other motion type:
    case  {'odometry'}
        Rob.frame   = odo3(Rob.frame,Rob.con.u);
        Rob.frame.q = normvec(Rob.frame.q);

    otherwise
        error('??? Unknown motion model ''%s''.',Rob.motion);
        
end



