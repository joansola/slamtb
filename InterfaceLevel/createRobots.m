function Rob = createRobots(Robot)

% CREATEROBOTS Create robots structure array.
%   Rob = CREATEROBOTS(Robot) creates the Rob() structure array to be used
%   as SLAM data. The input Robot{}  is a cell array of structures as
%   specified by the user in userData.m. There must be one Robot{} per each
%   robot considered in the simulation. See userData.m for details.

%   (c) 2009 Joan Sola @ LAAS-CNRS

for rob = 1:numel(Robot)

    Ri = Robot{rob}; % input robot structure

    % identification
    Ro.rob     = rob;
    Ro.id      = Ri.id;
    Ro.name    = Ri.name;
    Ro.type    = Ri.type;
    Ro.motion  = Ri.motion;

    % control
    switch Ri.motion

        case {'constVel'}

            Ro.con.u    = [Ri.dv;deg2rad(Ri.dwDegrees)];
            Ro.con.uStd = [Ri.dvStd;deg2rad(Ri.dwStd)];
            Ro.con.U    = diag(Ro.con.uStd.^2);
            Ro.vel.x    = [Ri.velocity;deg2rad(Ri.angularVelDegrees)];
            Ro.vel.P    = diag([Ri.velStd;deg2rad(Ri.angVelStd)].^2);

        case {'odometry'}

            Ro.con.u    = [Ri.dx;deg2rad(Ri.daDegrees)];
            Ro.con.uStd = [Ri.dxStd;deg2rad(Ri.daStd)];
            Ro.con.U    = diag(Ro.con.uStd.^2);
            Ro.vel.x    = [];
            Ro.vel.P    = [];

        otherwise
            error('Unknown motion model %s from robot %d.',Robot.motion,Robot.id);
    end

    Ro.sensors = [];

    % Robot frame
    ep = [Ri.position;deg2rad(Ri.orientationDegrees)];
    EP = diag([Ri.positionStd;deg2rad(Ri.orientationStd)].^2);

    [qp,QP] = propagateUncertainty(ep,EP,@epose2qpose); % frame and cov. in quaternion

    Ro.frame.x  = qp;
    Ro.frame.P  = QP;
    Ro.frame    = updateFrame(Ro.frame);
    Ro.frame.r  = [];

    Ro.vel.r = [];

    % state
    Ro.state.x    = [Ro.frame.x;Ro.vel.x]; % state
    Ro.state.P    = blkdiag(Ro.frame.P,Ro.vel.P);
    Ro.state.size = numel(Ro.state.x);   % state size

    Ro.state.r  = [];

    Rob(rob) = Ro; % output robot structure

end

