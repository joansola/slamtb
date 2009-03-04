function Rob = createRobots(Robot)

% CREATEROBOTS Create robots structure

%   (c) 2009 Joan Sola @ LAAS-CNRS

for rob = 1:numel(Robot)

    Ri = Robot{rob}; % input robot structure

    % identification
    Ro.id      = Ri.id;
    Ro.name    = Ri.name;
    Ro.type    = Ri.type;
    Ro.motion  = Ri.motion;

    Ro.sensors = Ri.sensors;

    % Robot frame
    ep = [Ri.position;deg2rad(Ri.orientationDegrees)];
    EP = diag([Ri.positionStd;deg2rad(Ri.orientationStd)].^2);

    [qp,QP] = propagateUncertainty(ep,EP,@epose2qpose); % frame and cov. in quaternion

    Ro.frame.x  = qp;
    Ro.frame.P  = QP;
    Ro.frame    = updateFrame(Ro.frame);
    Ro.frame.r  = [];

    % Robot velocity
    if ~isempty(Ri.velocity)
        v = [Ri.velocity;deg2rad(Ri.angularVelDegrees)];
        V = diag([Ri.velStd;deg2rad(Ri.angVelStd)].^2);
        Ro.vel.x = v;
        Ro.vel.P = V;
    else
        Ro.vel.x = [];
        Ro.vel.P = [];
    end
    Ro.vel.r = [];

    % state
    Ro.state.x    = [Ro.frame.x;Ro.vel.x]; % state
    Ro.state.P    = blkdiag(Ro.frame.P,Ro.vel.P);
    Ro.state.size = numel(Ro.state.x);   % state size

    Ro.state.r  = [];
    
    Ro.graphics = thickVehicle(0.8);
    
    Rob(rob) = Ro; % output robot structure

end

