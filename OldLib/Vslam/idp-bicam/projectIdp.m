function Idp = projectIdp(Rob,Cam,Idp,R)
%
% PROJECTIDP  Project inverse depth point into image plane
%   IDP = PROJECTIDP(ROB,CAM,IDP,R) projects the idp IDP into
%   the image plane of a camera CAM mounted on a robot ROB, using
%   the global map Map and the observation's noise covariances
%   matrix R.
%
%   Output is given by updating the fields of the input structure
%   IDP. Use 'type PROJECTIDP.M' for details on the fields being
%   updated.
%
%   See also LANDMARKINIT, PROJECTPNT

global Map Image WDIM CDIM

cam = Cam.id;

% get idp
ir = loc2range(Idp.loc); % idp range
idp = Map.X(ir); % idp

% get robot things
rr = Rob.r; % robot range

% get cam things
cr = Cam.r; % camera range
cor = Cam.or; % camera range in its own frame vector

% robot and idp range
rcir = [rr cr ir];

% projections
[u,Hr,Hc,Hi] = idpRobCamPhoto(Rob,Cam,idp,1); % projection with depth
s = u(3); % depth
u = u(1:2);

% get robot, camera and idp covariances
P = Map.P(rcir,rcir);

% jacobians
Hc  = Hc(:,cor); % only orientation
H   = [Hr Hc Hi];  % full robot, camera and idp Jacobian

U = H*P*H';    % projection of covariances matrix

% get visible means
isze = Cam.imSize; % Image size in horizontal and vertical notation
mrg  = size(Idp.sig.I,1); % patch size pixels margin
inIm = inSquare(u,[0 isze(1) 0 isze(2)],mrg);
f    = (s>0);
vis  = inIm & f;

% Size of projected ellipse, total uncertainty of expectation
dU = det(U);

% Store all info for later use
Idp.Prj(cam).Hr    = Hr;
Idp.Prj(cam).Hc    = Hc;
Idp.Prj(cam).Hi    = Hi;
Idp.Prj(cam).u     = u;
Idp.Prj(cam).U     = U;
Idp.Prj(cam).Z     = U+R;
Idp.Prj(cam).dU    = dU;
Idp.Prj(cam).s     = s;
Idp.Prj(cam).front = f;
Idp.Prj(cam).vis   = vis;


% initial and current estimated depths
ui = idpRobCamPhoto(Idp.Robi,Cam,idp,1);
si = ui(3);

% depths ratio
Idp.Prj(cam).sr = s/si;
