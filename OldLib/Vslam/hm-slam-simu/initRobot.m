% INITROBOT  Initialize robot
%   This is a script - it takes no arguments
%   It initializes a robot in the following way:
%     Rob is the estimated robot
%       r: range in the map state vector
%     Odo is the odometry containing
%       u: odometry data
%       U: odometry covariances matrix
%    Odo noise is proportional to translation via DNRs:
%       position:    dxDNR    m/sqrt(m)
%       orientation: deDNR  rad/sqrt(m)
%
%   See also INITCAM

global PDIM CDIM VDIM WDIM


% Estimated robot
Rob.X         = zeros(PDIM,1);
Rob.X(1:WDIM) = [100-10;100-8;100];
Rob.X(4)      = 1;
roll  = 0;
pitch = 0; % initial pitch to correct experiment
yaw   = 0;
Rob.X(4:7)    = e2q([roll pitch yaw]');
Rob           = updateFrame(Rob);

Rob.V  = zeros(CDIM,1); % linear and angular velocities
Rob.V(1) = 0;

Rob.r  = 1:PDIM; % range for robot pose in Map
Rob.rv = 1:VDIM; % range for robot states in Map

% Trajectory log
Rob.traj = zeros(3,Nframes);

% Simulated robot
RobSim   = Rob; % start the same


% Perturbations
Pert.Q = diag(dt*[vPert*[1 1 1] wPert*[1 1 1]].^2);


