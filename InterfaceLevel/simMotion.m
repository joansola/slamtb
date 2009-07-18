function Rob = simMotion(Rob, Tim)
% SIMMOTION  Simulated robot motion.
%   Rob = SIMMOTION(Rob, Tim) performs one motion step to robot Rob,
%   following the motion model in Rob.motion. The time information Tim is
%   used only if the motion model requires it, but it has to be provided
%   because MOTION is a generic method.
%
%   See also MOTION, CONSTVEL, ODO3, UPDATEFRAME.

%   Copyright 2008-2009 Joan Sola @ LAAS-CNRS.

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

