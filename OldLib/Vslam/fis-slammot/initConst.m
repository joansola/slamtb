% INITCONST  Initialize dimensions constants

global WDIM ODIM PDIM CDIM VDIM DDIM BDIM RDIM
global Image Map Lmk

% Uncertainties
% Odometry noise variance to distance ratios :
dxNDR      = (0.02)^2; % [  m^2/m]
deNDR      = (0.02)^2; % [rad^2/m]
% Vision measurements observation noise :
pixNoise   =  1;     % [pixels]
% Right-hand camera orientation noise :
camNoise   =  1;     % [euler - degrees]
camNoise   = deg2rad(camNoise);
camEuDeg   = [.65;4.86;.29]; % Cam 2 Euler angles in degrees

% Robot initial position
RobotIni = [0 0 0 1 0 0 0]'; % R = W(0){FLU}

% Landmark management
regions    =  6;    % grid of regions
maxRay     =  05;   % Maximum number of rays
maxPnt     =  040;  % Maximum number of points
simultRay  =  7;    % Maximum simultaneous ray updates
simultPnt  =  15;   % Maximum simultaneous point updates
maxInit    =  2;    % Maximum simultaneous initializations

% Objects management
objRegions = 2*regions;
maxObj     = 20;     % Max number of moving objects
simultObj  = 40;    % Max simult. obj. updates
lostObjTh  = 2;     % Threshold for lost objects
Ts         = .2;    % Time step
velUnc     = [.5,.5,.05]; % Initial object speed uncertainty
velNoise   = [.2,.2,.05]; % Speed perturbation noise
Vel.v      = [0;.5;0];
Vel.P      = diag(velUnc.^2); 
Pert.w     = [0;0;0];
Pert.W     = diag(velNoise.^2);

% On keeping landmarks up to date
foundPixTh = 0.90; % score threshold to validate match
foundObjTh = 0.80; % score to validate found object
scLength   = 4;    % scores history length
lostPntTh  = 10;    % point 'lost' counter threshold for deletion
lostRayTh  = 5;    % ray 'lost' counter threshold for deletion
MDth       = chi2(.01,2);  % Threshold to the Maha distance for lmk deletion

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

% features
hMet       = 'noble';
hSgm       = 3; % harris sigma
hTh        = 2000; % harris threshold. harris: 5e6; novel: 1500
hRd        = 2; % harris radius
patchSize  = 15;   
mrg = (patchSize-3)/2;

