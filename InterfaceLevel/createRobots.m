function Rob = createRobots(Robot)

% CREATEROBOTS Create robots structure array.
%   Rob = CREATEROBOTS(Robot) creates the Rob() structure array to be used
%   as SLAM data. The input Robot{}  is a cell array of structures as
%   specified by the user in userData.m. There must be one Robot{} per each
%   robot considered in the simulation. See userData.m for details.

%   Copyright 2008-2009 Joan Sola @ LAAS-CNRS.

for rob = 1:numel(Robot)
    
    Ri = Robot{rob}; % input robot structure
    
    % identification
    Ro.rob     = rob;
    Ro.id      = Ri.id;
    Ro.name    = Ri.name;
    Ro.type    = Ri.type;
    Ro.motion  = Ri.motion;
    
    Ro.sensors = [];
    
    % Robot frame in quaternion form
    ep = [Ri.position;deg2rad(Ri.orientationDegrees)];
    EP = diag([Ri.positionStd;deg2rad(Ri.orientationStd)].^2);
    [qp,QP] = propagateUncertainty(ep,EP,@epose2qpose); % frame and cov. in quaternion

    % control and rest of the state
    switch Ri.motion
        
        case {'constVel'}
            % control
            Ro.con.u    = [Ri.dv;deg2rad(Ri.dwDegrees)];
            Ro.con.uStd = [Ri.dvStd;deg2rad(Ri.dwStd)];
            Ro.con.U    = diag(Ro.con.uStd.^2);
            Ro.com.W    = 1/Ro.con.U;  % Information matrix
            
            % velocity states
            v = [Ri.velocity;deg2rad(Ri.angularVelDegrees)];
            V = diag([Ri.velStd;deg2rad(Ri.angVelStd)].^2);
            
            % state
            Ro.state.x    = [qp;v]; % state
            Ro.state.P    = blkdiag(QP,V);
            Ro.state.dx   = zeros(12,1);
            
        case {'odometry'}
            % control
            Ro.con.u    = [Ri.dx;deg2rad(Ri.daDegrees)];
            Ro.con.uStd = [Ri.dxStd;deg2rad(Ri.daStd)];
            Ro.con.U    = diag(Ro.con.uStd.^2);
            Ro.com.W    = Ro.con.U^-1;  % Information matrix
            
            % state
            Ro.state.x    = qp; % state
            Ro.state.P    = EP;
            Ro.state.dx   = zeros(6,1);
                        
        otherwise
            error('Unknown motion model ''%s'' for robot %d.',Robot{rob}.motion,Robot{rob}.id);
    end
    
    Ro.state.r  = []; % Points  Map.x  into  state.dx
    Ro.state.size = numel(Ro.state.x);   % state size
    Ro.state.dsize = numel(Ro.state.dx);

    Ro.frame.r = [];
    Ro.frame.x = qp;
    Ro.frame.P = QP;
    Ro.frame = updateFrame(Ro.frame);
    
    Rob(rob) = Ro; % output robot structure
    
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

%   SLAMTB is Copyright:
%   Copyright (c) 2008-2010, Joan Sola @ LAAS-CNRS,
%   Copyright (c) 2010-2013, Joan Sola,
%   Copyright (c) 2014-2015, Joan Sola @ IRI-UPC-CSIC,
%   SLAMTB is Copyright 2009 
%   by Joan Sola, Teresa Vidal-Calleja, David Marquez and Jean Marie Codol
%   @ LAAS-CNRS.
%   See on top of this file for its particular copyright.

%   # END GPL LICENSE

