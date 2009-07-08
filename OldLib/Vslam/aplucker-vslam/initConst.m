% INITCONST  Initialize constants

global POSDIM ORIDIM CAMDIM VELDIM STATDIM OBSDIM NOBDIM LMKDIM
global Map Lmk 

% Uncertainties
% initial uncertainties
linVelUnc = 2;  % [m/s]
angVelUnc = .5; % [rad/s]
% Odometry noise variance to distance ratios 
dxNDR      = (0.01)^2; % [  m^2/m]
deNDR      = (0.004)^2; % [rad^2/m]
% inertial perturbations
vPert    = .02; % [m/s^(3/2)]
wPert    = .05; % [rad/s^(3/2)]
% Vision measurements observation noise 
pixNoise = .5;      % [pixels]
% Sigma value
ns = 3;

% Landmark management
maxLine     =  50;   % Maximum number of lines
simultLines =  50;    % Maximum simultaneous line updates
maxInit     =  50;   % Maximum simultaneous initializations

% Image management
imageGrid   = 7;     % Image grid subdivisions per axis

% dimensions
POSDIM  = 3;
ORIDIM  = 4;
CAMDIM  = POSDIM + ORIDIM; % position and orientation
VELDIM  = POSDIM + POSDIM; % linear and angular velocities
STATDIM = CAMDIM + VELDIM; % full camera state
OBSDIM  = 4; % Observations
NOBDIM  = 2; % Non observable part
LMKDIM  = 9; % Anchored Plucker lines 
ANCDIM  = POSDIM + LMKDIM; % Anchored Plucker lines

% Time
dt = 1/30;

% Initialization params
beta  = [0.1;0];
sigmaBeta = [0.5;0.5];
BETA  = diag(sigmaBeta.^2);
Beta  = struct('beta',beta,'BETA',BETA);

