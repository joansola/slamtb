function Lmk = landmarkInnovation(Rob,Cam,Lmk,Obs)

% LANDMARKINNOVATION  Innovation of a landmark observation
%   LMK = LANDMARKINNOVATION(ROB,CAM,LMK,OBS)

global Map

% input data
r   = Rob.r;
pr  = loc2range(Lmk.loc);  % Lm range

% map data
p   = Map.X(pr); % Lm position in map

% Expectation
Lmk.ye = robCamPhoto(Rob,Cam,p);

% Jacobians
[Lmk.Hr,Hc,Lmk.Hp] = robCamPhotoJac(Rob,Cam,p);

% Landmark innovations
[Lmk.z,Lmk.Z,Lmk.iZ] = blockInnovation(r,pr,Lmk.Hr,Lmk.Hp,Obs,Lmk.ye);
