function Pnt = projectPnt(Rob,Cam,Pnt)
%
% PROJECTPNT  Project Point into image plane
%   PNT = PROJECTPNT(ROB,CAM,PNT) projects the point PNT
%   into the image plane of a camera CAM mounted on a
%   robot ROB, using the global map Map.
%   Output is given by updating the fields of the input
%   structure RAY:
%     PNT.u   is the projection of the mean of the point
%     PNT.U   is the covariances matrix of this projection
%     PNT.dU  is the determinant of this covariance
%
%   See also LANDMARKINIT, PROJECTRAY

global Map %Image WDIM CDIM

% get point
pr = loc2range(Pnt.loc); % point range
p = Map.X(pr); % point

% get robot things
rr = Rob.r; % robot range

% get cam things
cr = Cam.r; % camera range
cor = Cam.or; % camera range in its own frame vector

% robot and point range
rcpr = [rr cr pr];

% projections
[u,s,f] = robCamPhoto(Rob,Cam,p); % projection, depth, front

% get robot, camera and point covariances
P = Map.P(rcpr,rcpr);

% jacobians
[Hr,Hc,Hp] = robCamPhotoJac(Rob,Cam,p);
Hc = Hc(:,cor); % only orientation
H=[Hr Hc Hp];  % full robot, camera and point Jacobian

U = H*P*H';    % projection of covariances matrix

% get visible means
isze = Cam.imSize; % Image size in horizontal and vertical notation
mrg  = 10; % 10 pixels margin
inIm = inSquare(u,[0 isze(1) 0 isze(2)],mrg);
vis  = inIm & f;

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
Pnt.vis   = vis;


% initial and current estimated depths
[ui,si] = robCamPhoto(Pnt.Robi,Cam,p);

% depths ratio
Pnt.sr = s/si;
