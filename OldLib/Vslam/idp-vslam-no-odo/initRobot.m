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
Rob.X(1:WDIM) = [-2;3;0]; % AIC
% Rob.X(1:WDIM) = [0;0;0]; % LAAS
Rob.X(4)      = 1;
switch experim
    case 'test14'
        pitch = -atan(.2/7); % initial pitch to correct experiment
    otherwise
        pitch = 0; % initial pitch to correct experiment
end
Rob.X(4:7)    = e2q([0 pitch 0]');
Rob           = updateFrame(Rob);

Rob.V  = zeros(CDIM,1); % linear and angular velocities
Rob.V(1) = 0.1;

Rob.r  = 1:PDIM; % range for robot pose in Map
Rob.rv = 1:VDIM; % range for robot states in Map

% Trajectory log
Rob.traj = zeros(3,Nframes);




% Perturbations
Pert.Q = diag(dt*[vPert*[1 1 1] wPert*[1 1 1]].^2);


