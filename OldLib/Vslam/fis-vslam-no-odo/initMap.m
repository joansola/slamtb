% INITMAP  Initialize map
%   Script with no arguments
%   Initialize an EKF map with a single robot at origin.

global Map WDIM CDIM VDIM 

% Map state
Ng            = numTerms(alpha,beta,sMin,sMax);
Map.N         = Lmk.maxPnt + Ng*Lmk.maxRay; % max nbr of landmarks
Map.M         = loc2state(Map.N)+WDIM-1;    % maximum map size
Map.X         = zeros(Map.M,1);
Map.X(1:VDIM) = [Rob.X;Rob.V]; % pose and velocities
Map.P         = zeros(Map.M); % All is nominal...
vr = VDIM+1:VDIM+CDIM;
Map.P(vr,vr)  = diag([2*[1 1 1] .2*[1 1 1]]);

if length(Cam) ~= 1
    cr = Cam(2).r; % ...except second camera frame orientation
    camErr = Cam(2).oriError;
    Map.P(cr,cr) = diag(camErr.^2);
end

% Map usage
Map.n    = 0;         % current nbr of lmks
Map.m    = VDIM;      % current map size
Map.free = (1:Map.N)'; % free locations for lmks.
Map.used = zeros(size(Map.free)); % used locations.
