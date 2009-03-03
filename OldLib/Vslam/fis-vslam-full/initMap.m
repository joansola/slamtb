% INITMAP  Initialize map
%   Script with no arguments
%   Initialize an EKF map with a single robot at origin.

global Map WDIM CDIM VDIM 

% Map state
sMed          = sMin; % limit depth between stereo and mono TODO
Ng            = numTerms(alpha,beta,sMed,sMax);
Map.N         = Lmk.maxPnt + Ng*Lmk.maxRay; % max nbr of landmarks
Map.M         = loc2state(Map.N)+WDIM-1;    % maximum map size
Map.X         = zeros(Map.M,1);
Map.X(1:PDIM) = Rob.X;
Map.P         = zeros(Map.M); % All is nominal...

if length(Cam) ~= 1
    cr = Cam(2).r; % ...except second camera frame orientation
    camErr = Cam(2).oriError;
    Map.P(cr,cr) = diag(camErr.^2);
end

% Map usage
Map.n    = 0;         % current nbr of lmks
Map.m    = PDIM;      % current map size
Map.free = (1:Map.N)'; % free locations for lmks.
Map.used = zeros(size(Map.free)); % used locations.
