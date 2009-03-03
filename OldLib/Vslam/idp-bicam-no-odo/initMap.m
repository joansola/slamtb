% INITMAP  Initialize map
%   Script with no arguments
%   Initialize an EKF map with a single robot at origin.

global Map WDIM FDIM

% Map state
Map.N         = Lmk.maxPnt + 2*Lmk.maxIdp; % max nbr of landmarks
Map.M         = loc2state(Map.N)+WDIM-1;    % maximum map size
Map.X         = zeros(Map.M,1);
fr = 1:FDIM;
Map.X(fr)     = [Rob(1).X;Rob(1).V;Rob(2).X;Rob(2).V];
Map.P         = zeros(Map.M); % All is nominal (P=0) ...

% Rob(2) initial uncertainty into Map.P
% rr2 = Rob(2).r;
% vr2 = Rob(2).vr;
vr1 = Rob(1).vr;
sr1 = Rob(1).sr;
sr2 = Rob(2).sr;

% pose and velocity uncertainty in the map
Pr = posNoise^2*diag([1 1 1]); % position noise
er = [0;0;0];
Er1 = oriNoise^2*diag([1 0 1]); % euler noise - master has no pitch noise
Er2 = oriNoise^2*diag([1 2 1]); % euler noise - slave gets double noise
[qr,QRer] = e2q(er);  % go to quaternion
Qr1 = QRer*Er1*QRer';   % get cov. quaternion
Qr2 = QRer*Er2*QRer';   % get cov. quaternion
Vr = velNoise^2*diag([1 1 1]);
Wr = wanNoise^2*diag([1 1 1]);

Map.P(sr1,sr1) = blkdiag(Pr,Qr1,Vr,Wr);
Map.P(sr2,sr2) = blkdiag(Pr,Qr2,Vr,Wr);

% Map.P(vr1,vr1) = blkdiag(Vr,Wr);

% Map usage
Map.n    = 0;         % current nbr of lmks
Map.m    = loc2state(1)-1;      % current map size
Map.free = (1:Map.N)'; % free locations for lmks.
Map.used = zeros(size(Map.free)); % used locations.
