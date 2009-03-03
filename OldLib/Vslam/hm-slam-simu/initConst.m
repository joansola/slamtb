% INITCONST  Initialize dimensions constants

global WDIM ODIM PDIM CDIM VDIM DDIM BDIM RDIM HDIM
global Image Map Lmk

% Uncertainties
% Odometry noise variance to distance ratios 
dxNDR      = (0.01)^2; % [  m^2/m]
deNDR      = (0.001)^2; % [rad^2/m]
% inertial perturbations
vPert    = .05; % [m/s^(3/2)]
wPert    = .05; % [rad/s^(3/2)]
% Vision measurements observation noise 
pixNoise = 2;      % [pixels]

% Landmark management
maxPnt     =  50;  % Maximum number of points
simultPnt  =  10;    % Maximum simultaneous point updates
maxInit    =  5;    % Maximum simultaneous initializations

% On keeping landmarks up to date
foundPixTh = 0.95;   % score threshold to validate match
scLength   = 4;     % scores history length
lostPntTh  = 15;    % point 'lost' counter threshold for deletion
lostRayTh  = 7;     % ray 'lost' counter threshold for deletion
MDth       = chi2(.01,2);  % Threshold to the Maha distance for lmk deletion

% dimensions
WDIM = 3; % world
ODIM = 4; % orientation
PDIM = WDIM + ODIM; % poses
CDIM = 0; % other vehicle states
VDIM = PDIM + CDIM; % Vehicle with all states
HDIM = 4; % homogeneous points
DDIM = 6; % odometry
BDIM = 2; % bearings
RDIM = 1; % ranges

% ray parameters
rho        = .0001;  % inverse depth init value
sMin       = 1.0;   % minimum distance
Rho.t      = rho;
Rho.T      = (1/2/sMin)^2;
ns         = 2;     % number of sigma bound
% number of ray terms

% patch size
patchSize  = 15;  
mrg = round((patchSize)/2)-2; 

% Time 
dt = 1/15; % sample time

