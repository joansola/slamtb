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
    cam{i}.X(1:3) = 0;
    cam{i} = updateFrame(cam{i});
    if i==1
        cam{i}.r = [];
        cam{i}.oriError = 0;
        cam{i}.or = []; % orientation range inside frame
    else
        % Orientation range in the map
        cam{i}.r = PDIM+(1:CDIM); 
        % orientation quaternion uncertainty in the map
        cam{i}.oriError = 0.01*ones(CDIM,1); 
        cam{i}.or = WDIM+(1:CDIM); % orientation range inside frame
    end
    cam{i}.graphics = [];
    Cam(i)          = cam{i};
end

clear camera cam

% OBSERVATIONS
pixNoise = pixNoise * ones(BDIM,1); 
Obs.y    = zeros(BDIM,1);
Obs.R    = diag(pixNoise.^2);
