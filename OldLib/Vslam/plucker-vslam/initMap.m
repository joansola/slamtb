% INITMAP  Initializa sLAM map

global CAMDIM VELDIM STATDIM LMKDIM
global Map

Map.M         = STATDIM + LMKDIM*Lmk.maxLine; % max nbr of states
Map.X         = zeros(Map.M,1);
Map.P         = zeros(Map.M); 

% Initial pose, velocity and uncertainties
Map.X(1:STATDIM) = [Cam.X;Cam.V]; % pose and velocities
vr = CAMDIM+1:CAMDIM+VELDIM;
Map.P(vr,vr)  = diag([linVelUnc^2*[1 1 1] angVelUnc^2*[1 1 1]]);

% Map usage
Map.useType = 'range';  % use 'loc' or nothing for systems where just the location of landmarks is given.
Map.m    = STATDIM;      % current map size
Map.free = (1:Map.M); % free map locations for lmks.
Map.free(1:STATDIM) = 0; % Camera states are not free
Map.used = zeros(size(Map.free)); % used locations.
Map.used(1:STATDIM) = (1:STATDIM);
