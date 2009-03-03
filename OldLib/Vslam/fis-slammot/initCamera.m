% INITCAMERA  Initialize a camera
%   This is a script - it takes no arguments
%   Initialize a camera in the following way:
%     Cam is a structure containing among others
%       X: camera pose wrt robot
%       cal: calibration parameters


% CAMERA FRAMES
for i=1:length(camera)
   cam{i} = camera(i);
   cam{i} = updateFrame(cam{i});
   cam{i}.id = i; % identifier
   if i==1
      cam{i}.r = [];
      cam{i}.or = []; % orientation range inside frame
      cam{i}.oriError = 0;
   else
      % Orientation range in the map
      cam{i}.r = PDIM+[1:CDIM];
      cam{i}.or = WDIM+[1:CDIM]; % orientation range inside frame

      if selfCalib
         % orientation quaternion uncertainty in the map
         Erc = camNoise^2*diag([1 1 1]'); % euler noise camera frame
         Rcs = flu2rdf();       % Camera to sensor rotation matrix
         Rrs = cam{i}.R;        % Robot to sensor rotation matrix
         Rrc = Rrs*Rcs';        % Robot to camera rotation matrix
         JeQ  = e2qrdfJac(R2e(Rrc));
         Qrs = JeQ*Erc*JeQ';        % Quaternion noise robot frame
         cam{i}.oriError = Qrs;
      else
         % certain quaternion
         erc = deg2rad(camEuDeg); % previously calibrated euler
         Rrc = e2R(erc);
         Rcs = flu2rdf();       % Camera to sensor rotation matrix
         Rrs = Rrc*Rcs;
         qrs = R2q(Rrs);
         cam{i}.X(cam{i}.or) = qrs; % previously calibrated quatern
         cam{i} = updateFrame(cam{i});
         cam{i}.oriError = zeros(4); % zero uncertainty
      end
   end
   cam{i}.graphics = [];
   Cam(i)          = cam{i};
end

clear camera cam



% OBSERVATIONS
pixNoise = pixNoise * ones(BDIM,1);
for i=1:2
   Obs(i).y    = zeros(BDIM,1);
   Obs(i).R    = diag(pixNoise.^2);
end

