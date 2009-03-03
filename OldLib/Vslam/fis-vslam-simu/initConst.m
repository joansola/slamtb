% INITCONST  Initialize dimensions constants

global WDIM ODIM PDIM CDIM VDIM DDIM BDIM RDIM
global Image Map Lmk

% Uncertainties
% Odometry noise variance to distance ratios 
dxNDR      = (0.01)^2; % [  m^2/m]
deNDR      = (0.01)^2; % [rad^2/m]
% inertial perturbations
vPert    = .05; % [m/s^(3/2)]
wPert    = .05; % [rad/s^(3/2)]
% Vision measurements observation noise 
pixNoise = 2;      % [pixels]

% Landmark management
maxRay     =  20;   % Maximum number of rays
maxPnt     =  20;  % Maximum number of points
simultRay  =  4;    % Maximum simultaneous ray updates
simultPnt  =  8;    % Maximum simultaneous point updates
maxInit    =  1;    % Maximum simultaneous initializations

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
CDIM = WDIM + WDIM; % other vehicle states
VDIM = PDIM + CDIM; % Vehicle with all states
DDIM = 6; % odometry
BDIM = 2; % bearings
RDIM = 1; % ranges

% ray parameters
alpha      = 0.3;   % ray aspect ratio
beta       = 3;   % ray geometric base
gamma      = 0;   % ray balance factor
tau        = 0.001; % ray pruning threshold
sMin       = 1.0;   % minimum distance
sMax       = 50;    % maximum distance
ns         = 3;     % number of sigma bound
% number of ray terms
Ng = 1+ceil(log(((1-alpha)/(1+alpha))*((sMax)/(sMin)))/log(beta)); 

% patch size
patchSize  = 15;  
mrg = round((patchSize)/2)-2; 

% Time 
dt = 1/15; % sample time

