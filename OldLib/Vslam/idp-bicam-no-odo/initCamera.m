% INITCAMERA  Initialize a camera
%   This is a script - it takes no arguments
%   Initialize a camera in the following way:
%     Cam is a structure containing
%       C: camera pose wrt robot
%       cal: calibration parameters
%       nfv: normalized field of view (number of focal lengths from center)
%       dlim: observable depth limits

% Cam = struct(...
%     'X',[],...
%     't',[],'it',[],...
%     'q',[],'iq',[],...
%     'R',[],'Rt',[],...
%     'Pi',[],'Pc',[],...
%     'r',[],...
%     'cal',[],...
%     'dist',[],'undist',[],...
%     'imSize',[],...
%     'graphics',[]);

% CAMERA FRAMES
for i=1:length(camera)
    cam{i} = camera(i);
    cam{i} = updateFrame(cam{i});
    cam{i}.id = i; % identifier
    cam{i}.graphics = [];
    Cam(i)          = cam{i};
end

clear camera cam


% OBSERVATIONS (both cameras equal)
pixNoise = pixNoise * ones(BDIM,1); 
Obs.y    = zeros(BDIM,1);
Obs.R    = diag(pixNoise.^2);
