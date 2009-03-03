% INITMAP  Initialize map
%   Script with no arguments
%   Initialize an EKF map with a single robot at origin.

global Map CDIM VDIM 

% Map state
Map.N         = Lmk.maxPnt; % max nbr of landmarks
Map.M         = loc2state(Map.N)+HDIM-1;    % maximum map size
Map.X         = zeros(Map.M,1);
Map.X(1:PDIM) = Rob.X; % robot pose
Map.P         = zeros(Map.M); % All is nominal...
% vr = PDIM+1:PDIM+CDIM;
% Map.X(PDIM+1:PDIM+CDIM) = Rob.V; % pose and velocities
% Map.P(vr,vr)  = diag([2*[1 1 1] .2*[1 1 1]]);

% Map usage
Map.n    = 0;         % current nbr of lmks
Map.m    = VDIM;      % current map size
Map.free = (1:Map.N)'; % free locations for lmks.
Map.used = zeros(size(Map.free)); % used locations.
