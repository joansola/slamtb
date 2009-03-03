function Pnt = projectHomo(Rob,Cam,Pnt)

global Map %Image WDIM CDIM

% get point
pr = loc2range(Pnt.loc); % point range
p = Map.X(pr); % point

% get robot things
rr = Rob.r; % robot range

% robot and point range
rpr = [rr pr];

% projections
[u,s,Hr,Hc,Hk,Hp] = homoRobCamPhotoPix(Rob.X,Cam.X,Cam.cal,p); % projection, depth, front
f = s>0;

if 0%~f
    Hr = -Hr;
    Hp = -Hp;
end

% get robot, camera and point covariances
P = Map.P(rpr,rpr);

% jacobians
H  = [Hr Hp];  % full robot, camera and point Jacobian

U = H*P*H';    % projection of covariances matrix

% get visible means
isze = Cam.imSize; % Image size in horizontal and vertical notation
mrg  = 10; % 10 pixels margin
inIm = inSquare(u,[0 isze(1) 0 isze(2)],mrg);
% vis  = inIm & f;
vis  = inIm;

% Size of projected ellipse, total uncertainty of expectation
dU = det(U);

% Store all info for later use
Pnt.Hr    = Hr;
Pnt.Hp    = Hp;
Pnt.u     = u;
Pnt.U     = U;
Pnt.dU    = dU;
Pnt.s     = s;
Pnt.front = f;
% Pnt.vis   = 1;
Pnt.vis   = vis;

