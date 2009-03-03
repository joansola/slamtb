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

global PDIM WDIM ODIM


% Estimated robot
% Rob.X         = zeros(PDIM,1);
% Rob.X(1:WDIM) = [0;0;0];
% Rob.X(4)      = 1;
Rob.X = RobotIni;
clear RobotIni
switch experim
    case 'test14'
        pitch = -atan(.2/7); % initial pitch to correct experiment
    otherwise
        pitch = 0; % initial pitch to correct experiment
end
q     = e2q([0 pitch 0]');
Rob.X(4:7)    = q;
Rob           = updateFrame(Rob);

Rob.r  = 1:PDIM;



% Odometry
Odo.u    = zeros(ODIM,1);



