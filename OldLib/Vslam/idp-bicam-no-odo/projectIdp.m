function Idp = projectIdp(Rob,Cam,Idp,R,warpMet)
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

% robot and idp range
rir = [rr ir];

% projections
[u,Hr,Hc,Hi] = idpRobCamPhoto(Rob,Cam,idp,1); % projection with depth
s = u(3); % depth
u = u(1:2);

% get visible means
isze = Cam.imSize; % Image size in horizontal and vertical notation
mrg  = size(Idp.sig.I,1); % patch size pixels margin
inIm = inSquare(u,[0 isze(1) 0 isze(2)],3*mrg);
f    = (s>0);
vis  = inIm && f;

Idp.Prj(cam).u     = u;
Idp.Prj(cam).s     = s;
Idp.Prj(cam).front = f;
Idp.Prj(cam).vis   = vis;

if vis

    % jacobians
    H = [Hr Hi];  % full robot and idp Jacobian

    % get robot and idp covariances
    P = Map.P(rir,rir);

    % expectation's cov. matrix
    U = H*P*H';

    % Size of projected ellipse, total uncertainty of expectation
    dU = det(U);

    % Store all info for later use
    Idp.Prj(cam).Hr    = Hr;
    Idp.Prj(cam).Hc    = Hc;
    Idp.Prj(cam).Hi    = Hi;
    Idp.Prj(cam).U     = U;
    Idp.Prj(cam).Z     = U+R;
    Idp.Prj(cam).dU    = dU;

    switch warpMet
        case 1
            % initial and current estimated depths
            p  = idp2p(idp);
            pC = toFrame(Idp.Cami,toFrame(Idp.Robi,p));
            si = pC(3);
            Idp.Prj(cam).sr = s/si;    % depths ratio

        case 2
            % distances ratio
            rho = idp(6);               % IDP's inverse distance
            p   = idp2p(idp);           % 3d point
            xC  = fromFrame(Rob,Cam.t); % current capera position
            d   = norm(p-xC);           % current distance

            Idp.Prj(cam).d  = d;        % distance
            Idp.Prj(cam).dr = d*rho;    % distances ratio

        case 3
            % Get patch transformation
            Cami = composeRobCam(Idp.Robi,Idp.Cami);
            Camo = composeRobCam(Rob,Cam);
            p    = idp2p(idp);
            pC   = toFrame(Cami,p);
            si   = pC(3);
            
            [uo,UOci,UOco,UOui] = transCamPhoto(Cami,Camo,Idp.ui,si);
            Idp.Prj(cam).UOui   = UOui;
    end

end

return

%% tests

C1 = Cam(1);
C2 = Cam(2);

C1.X = [0;0;0;1;0;0;0];
C1.cal = [100;100;100;100];
C1=updateFrame(C1);

C2.X = [0;0;2;e2q(deg2rad([0;0;20]))];
C2.cal = [100;100;100;100];
C2=updateFrame(C2);

ui = [100;100];
si = 10;
[uo,UOci,UOco,UOui] = transCamPhoto(C1,C2,ui,si);


I=Lmk.Idp(1).sig.I;

% UOui = [1.5 .5;0 1.5];

J=imresize2(I,UOui);
figure(6);
subplot(1,2,1),image(I);colormap(gray(255));axis image
subplot(1,2,2),image(J);colormap(gray(255));axis image

UOui

[U,D,V]=svd(UOui)

a=rad2deg(atan(U(1,1)/U(2,1)))




