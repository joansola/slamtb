function Pnt = projectPnt(Rob,Cam,Pnt,R,warpMet)
%
% PROJECTPNT  Project Point into image plane
%   PNT = PROJECTPNT(ROB,CAM,PNT,R) projects the point PNT into
%   the image plane of a camera CAM mounted on a robot ROB, using
%   the global map Map and the observation's noise covariances
%   matrix R.
%   Output is given by updating the fields of the input structure
%   RAY. Use 'type PROJECTPNT.M' for details on the fields being
%   updated.
%
%   See also LANDMARKINIT, PROJECTRAY

global Map Image WDIM CDIM

cam = Cam.id;

% get point
pr = loc2range(Pnt.loc); % point range
p = Map.X(pr); % point

% get robot things
rr = Rob.r; % robot range

% robot and point range
rpr = [rr pr];

% projections
[u,s,f] = robCamPhoto(Rob,Cam,p); % projection, depth, front

% get visible means
isze = Cam.imSize; % Image size in horizontal and vertical notation
mrg  = size(Pnt.sig.I,1); % patch size pixels margin
inIm = inSquare(u,[0 isze(1) 0 isze(2)],3*mrg);
vis  = inIm & f;

% save
Pnt.Prj(cam).u     = u;
Pnt.Prj(cam).s     = s;
Pnt.Prj(cam).front = f;
Pnt.Prj(cam).vis   = vis;


if vis

    % get robot, camera and point covariances
    P = Map.P(rpr,rpr);

    % jacobians
    [Hr,Hc,Hp] = robCamPhotoJac(Rob,Cam,p);
    % Hc         = Hc(:,cor); % only orientation
    H          = [Hr Hp];  % full robot, camera and point Jacobian

    U = H*P*H';    % projection of covariances matrix

    % Size of projected ellipse, total uncertainty of expectation
    dU = det(U);

    % Store all info for later use
    Pnt.Prj(cam).Hr    = Hr;
    Pnt.Prj(cam).Hc    = Hc;
    Pnt.Prj(cam).Hp    = Hp;
    Pnt.Prj(cam).U     = U;
    Pnt.Prj(cam).Z     = U+R;
    Pnt.Prj(cam).dU    = dU;

    % Warping details
    switch warpMet
        case 1
            % initial and current estimated depths
            pC = toFrame(Pnt.Cami,toFrame(Pnt.Robi,p));
            si = pC(3);
            Pnt.Prj(cam).sr = s/si;    % depths ratio

        case 2
            % distances ratio
            xCi = fromFrame(Pnt.Robi,Pnt.Cami.t); % initial cam. position
            di  = norm(p-xCi);          % initial distance
            xC  = fromFrame(Rob,Cam.t); % current capera position
            d   = norm(p-xC);           % current distance

            Pnt.Prj(cam).d  = d;        % distance
            Pnt.Prj(cam).dr = d/di;    % distances ratio

        case 3
            % Get patch transformation
            Cami = composeRobCam(Pnt.Robi,Pnt.Cami);
            Camo = composeRobCam(Rob,Cam);
            pC = toFrame(Cami,p);
            si = pC(3);
            [uo,UOci,UOco,UOui] = transCamPhoto(Cami,Camo,Pnt.ui,si);
            Pnt.Prj(cam).UOui = UOui;
    end

end
