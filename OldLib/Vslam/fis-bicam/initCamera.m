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
    if i==1
        cam{i}.r = [];
        cam{i}.oriError = 0;
        cam{i}.or = []; % orientation range inside frame
    else
        % Orientation range in the map
        cam{i}.r = PDIM+[1:CDIM]; 
        
        % orientation quaternion uncertainty in the map
        Erc = camNoise^2*diag([1 1 1]'); % euler noise camera frame
        Rcs = flu2rdf();       % Camera to sensor rotation matrix
        Rrs = cam{i}.R;        % Robot to sensor rotation matrix
        Rrc = Rrs*Rcs';        % Robot to camera rotation matrix
        JeQ  = e2qrdfJac(R2e(Rrc));
        Qrs = JeQ*Erc*JeQ';        % Quaternion noise robot frame
        cam{i}.oriError = Qrs; 
%         cam{i}.oriError = camNoise*ones(CDIM,1); 
        cam{i}.or = WDIM+[1:CDIM]; % orientation range inside frame
    end
    cam{i}.graphics = [];
    Cam(i)          = cam{i};
end

clear camera cam

% Enter angular extrinsic errors
% q = Cam(2).X(4:7); 
% q = q + 0.5*w2omega(deg2rad([1;1;1]))*q;
% Cam(2).X(4:7) = q/(q'*q);
% Cam(2) = updateFrame(Cam(2));


% OBSERVATIONS
pixNoise = pixNoise * ones(BDIM,1); 
Obs.y    = zeros(BDIM,1);
Obs.R    = diag(pixNoise.^2);
