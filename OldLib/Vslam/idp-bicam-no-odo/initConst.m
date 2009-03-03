% INITCONST  Initialize constants

global WDIM ODIM PDIM VDIM SDIM FDIM BDIM RDIM IDIM
global Image Map Lmk

% Uncertainties
% Odometry noise variance to distance ratios 
dxNDR     = 0.04^2; % [  m^2/m]
deNDR     = 0.04^2; % [rad^2/m]

% Inertial perturbations
vPert     = .1; % [   m/s/s^1/2 ] % std. change in speed in one second
wPert     = .1; % [ rad/s/s^1/2 ] % std. change in ang. speed in one second

% Vision measurements observation noise 
pixNoise  =  1;     % [pixels] % camera precision

% Initial configuration uncertainties
oriNoise  = .7;     % [euler - degrees] initial orientation error
oriNoise  = deg2rad(oriNoise);
posNoise  = .0;     % initial position error
velNoise  = .1;     % initial velocity error in m/s
wanNoise  = 5;      % initial angular velocity noise in deg/s
wanNoise  = deg2rad(wanNoise);

% Active search
ns        = 2;     % number of sigma bound of search ellipses

% Robot initial position
RobotIni  = [0 0 0 1 0 0 0]';

% Landmark management
regions   =  6;    % grid of regions
maxIdp    =  24;   % Maximum number of rays
maxPnt    =  080;  % Maximum number of points
simultIdp =  30;   % Maximum simultaneous ray updates
simultPnt =  20;   % Maximum simultaneous point updates
maxInit   =  8;    % Maximum simultaneous initializations

% On keeping landmarks up to date
foundPntPixTh = 0.87; % score threshold to validate match
foundIdpPixTh = 0.9;  % score threshold to validate match
lostPntTh  = 40;      % point 'lost' counter threshold for deletion - 40
lostIdpTh  = 30;      % ray 'lost' counter threshold for deletion
MDth       = chi2(.05,2);  % Threshold to the Maha distance for lmk deletion

% dimensions
WDIM = 3; % position
ODIM = 4; % orientation
PDIM = WDIM + ODIM; % poses
VDIM = 6; % additional vehicle states (lin and ang velocities)
SDIM = PDIM + VDIM; % Vehicle with extra states.
FDIM = 2*SDIM; % 2 vehicles flote. Landmarks start after this.
BDIM = 2; % bearings
RDIM = 1; % ranges
IDIM = 6; % Inverse depth rays

% IDP ray parameters
sMin       = 2.0;   % minimum distance
Rho.rho    = 1/(2*sMin);   % initial inverse depth
Rho.RHO    = (Rho.rho/2)^2; % variance
LdTh       = .15;

% patch matching
patchSize  = 11;   
mrg        = (patchSize-1)/2; 
pixDist    = 3;

% Time
dt = 1/15; % sample time

