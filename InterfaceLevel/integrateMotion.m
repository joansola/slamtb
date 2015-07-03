function Rob = integrateMotion(Rob, Tim)

%INTEGRATEMOTION Integrate Robot motion, with covariance.
%   ROB = INTEGRATEMOTION(ROB, TIM) performs one prediction motion step to
%   the state and covariance of robot Rob, following the motion model in
%   Rob.motion. Structure Rob is updated. The time information Tim is used
%   only if the motion model requires it, but it has to be provided because
%   MOTION is a generic method.
%
%   The following motion models are supported:
%       'odometry'   uses function odo3()
%       'constVel'   uses function constVel()
%   Edit this file to add new motion models.
%
%   See also MOTION, SIMMOTION, CONSTVEL, ODO3, UPDATEFRAME.

%   Copyright 2015 Joan Sola @ IRI-CSIC-UPC.

switch Rob.motion
    
    case  {'constVel'} % constant velocity
        
        % motion model of the robot: mean and Jacobians
        [Rob.state.x, ~, F_u] = constVel(Rob.state.x,Rob.con.u,Tim.dt);
        
        
    case  {'odometry'}  % 3D odometry
        
        % motion model of the robot: mean and Jacobians
        [Rob.frame, ~, F_u]   = odo3(Rob.frame,Rob.con.u);
        Rob.state.x(1:7) = Rob.frame.x;
        
    otherwise
        
        error('??? Unknown motion model ''%s''.',Rob.motion);
end

% Covariances matrix update
Rob.state.P = Rob.state.P + F_u * Rob.con.U * F_u';
Rob.state.P = symmetrize(Rob.state.P);



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

