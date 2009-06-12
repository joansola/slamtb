% INITCAMERA  Initialize cameras
%   This is a script - it takes no arguments
%   Initialize a camera in the following way:
%       Cam is a structure containing at least
%       .X: camera pose wrt robot
%       .cal: calibration parameters
%       and as optional fields
%       .V: a 6-vector of velocities in case of constant velocity models
%       .imSize: a 2-vector with H and V image sizes, in pixels.
%       .dist: a vector of radial distortion parameters.
%       .undist: a vector of distortion correction parameters.
%       .graphics: a graphics object for plotting. See CAMGRAPHICS.
%       .r: The range of pose indices in a SLAM map or filter.
%       .sr: The range of all indices in a SLAM map or filter.
%       .pixNoise: pixel noise.

global CAMDIM STATDIM


% intrinsic and image size
k      = [320 240 360 360];
imSize = [640 480];
dist   = [];
undist = [];
r      = 1:CAMDIM;
sr     = 1:STATDIM;

% Observations
Obs.rawy = zeros(OBSDIM,1);
Obs.rawR = diag(pixNoise^2 * ones(OBSDIM,1));

% make structure
Cam = struct(...
    'id',1,...
    'X',camPos,...
    'V',camVel,...
    'traj',zeros(3,fmax-fmin+1),...
    'r',r,...
    'sr',sr,...
    'cal',k,...
    'dist',dist,...
    'undist',undist,...
    'imSize',imSize,...
    'graphics',camGraphics(0.5),...
    'pixNoise',pixNoise);

% update frame matrices
Cam = updateFrame(Cam);

% Simulated camera
SimuCam = Cam;
