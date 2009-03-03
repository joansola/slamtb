% INITMAP  Initialize map
%   Script with no arguments
%   Initialize an EKF map with a single robot at origin.

global Map WDIM CDIM VDIM 

% Map state
Map.N         = Lmk.maxPnt + 2*Lmk.maxIdp; % max nbr of landmarks
Map.M         = loc2state(Map.N)+WDIM-1;    % maximum map size
Map.X         = zeros(Map.M,1);
Map.X(Rob.r)  = Rob.X;
Map.P         = zeros(Map.M); % All is nominal (P=0) ...

cr = Cam(2).r; % ...except second camera frame orientation
or = Cam(2).or;
Map.X(cr) = Cam(2).X(or);
camErr = Cam(2).oriError;
Map.P(cr,cr) = camErr;

% Map usage
Map.n    = 0;         % current nbr of lmks
Map.m    = loc2state(1)-1;      % current map size
Map.free = (1:Map.N)'; % free locations for lmks.
Map.used = zeros(size(Map.free)); % used locations.
