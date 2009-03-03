function Lmk = partialInit(Rob,Cam,Obs,NonObs,Lmk,invPartialObs)

% R, C are structures with frame and map range
% C has addition field with intrinsic parameters k
% OBS is structure with mean and covariance
% NONOBS is structure with mean and covariance
% LMK is structure with range, id, etc

global Map

% ranges
m   = Map.m; % map nbr of states
r   = Rob.r; % robot range

Lmk.loc = getLoc; % get smallest location
pr = loc2range(Lmk.loc); % landmark range
mr = [1:pr(1)-1 pr(end)+1:m]; % not-landmark range

% relevant sub-maps
Prr = Map.P(r,r);  % robot co-variance
Prm = Map.P(r,mr); % robot cross-variance

% Jacobians
[p,Gr,Gc,Gk,Gw,Gt] = invPartialObs(Rob.X,Cam.X,Cam.cal,Obs.y,NonObs.t);

% initialized landmark sub-maps
Ppp = Gr*Prr*Gr' + Gw*Obs.R*Gw' + Gt*NonObs.T*Gt';
Ppm = Gr*Prm;

% Output
Map.X(pr)    = p;
Map.P(pr,mr) = Ppm;
Map.P(mr,pr) = Ppm';
Map.P(pr,pr) = Ppp;

occupateMap(Lmk.loc);

