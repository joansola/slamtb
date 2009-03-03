% INITCONST  Initialize dimensions constants

global WDIM ODIM PDIM CDIM VDIM DDIM BDIM RDIM
global Image Map Lmk

% Uncertainties
% Odometry noise variance to distance ratios 
dxNDR      = (0.02)^2; % [  m^2/m]
deNDR      = (0.02)^2; % [rad^2/m]
% Vision measurements observation noise 
pixNoise   =  1;      % [pixels]
camNoise   =  1;     % [euler - degrees]
camNoise   = deg2rad(camNoise);
% camNoise   = 0;    % [quaternion]

% Robot initial position
RobotIni = [0 0 0 1 0 0 0]';

% Landmark management
regions     = 7;    % grid of regions
maxRay     =  15;   % Maximum number of rays
maxPnt     =  080;  % Maximum number of points
simultRay  =  7;    % Maximum simultaneous ray updates
simultPnt  =  10;   % Maximum simultaneous point updates
maxInit    =  1;    % Maximum simultaneous initializations

% On keeping landmarks up to date
foundPixTh = 0.90; % score threshold to validate match
scLength   = 4;    % scores history length
lostPntTh  = 15;    % point 'lost' counter threshold for deletion
lostRayTh  = 8;    % ray 'lost' counter threshold for deletion
MDth       = chi2(.05,2);  % Threshold to the Maha distance for lmk deletion

% dimensions
WDIM = 3; % world
ODIM = 4; % orientation
CDIM = 4; % 2nd camera auto-calibration (orientation quaternion)
PDIM = WDIM + ODIM; % poses and camera
VDIM = PDIM + CDIM; % Vehicle with sensors. Landmarks start after this.
DDIM = 6; % odometry
BDIM = 2; % bearings
RDIM = 1; % ranges


% ray parameters
alpha      = 0.3;   % ray aspect ratio
beta       = 3.0;   % ray geometric base
gamma      = 0.05;  % ray balance factor
tau        = 0.01;  % ray pruning threshold
sMin       = 1.0;   % minimum distance
sMax       = 15;    % maximum distance
ns         = 3;     % number of sigma bound

% patch size
patchSize  = 15;   
mrg = (patchSize-3)/2; 

% Calibration values (in degrees)
offlineCalib = [0.61 4.74 0.51]';
selfCalib    = [0.60 4.87 0.33]'; % Values in solaTRO07.pdf
selfCalib2   = [0.71 4.86 0.33]'; % Values from end of run


