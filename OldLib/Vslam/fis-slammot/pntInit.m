function Pnt = pntInit(...
    Pnt,...
    Rob,...
    Cam,...
    Obs,...
    Dpt,...
    patchSize,...
    lostTh)

% PNTINIT  Point initialization
%   PNT = PNTINIT(RAY,ROB,CAM,OBS,DPT) fills all appropiate
%   fields in structure PNT, resulting from the initialization
%   after an observation OBS from a camera CAM mounted on a robot
%   ROB. The point is initialized at a depth DPT. All other point
%   parameters are taken as default:
%     PATCHSIZE = 15
%     LOSTPNTTH = 5
%
%   RAY = RAYINIT(...,PATCHSIZE,LOSTPNTTH) permits the
%   specification of all above parameters. To choose its default
%   simply give it as [].
%
%   See also EMPTYPNT, LANDMARKINIT, RAYINIT

% (c) 2006 Joan Sola @ LAAS-CNRS

global Image Map WDIM PDIM CDIM BDIM


% set defaults
if nargin < 7
    lostTh = 5;
    if nargin < 6
        patchSize = 15;
        if nargin < 5
            error('Not enough input arguments.')
        end
    end
end

% usage
Pnt.used = true;
Pnt.found = 1;
Pnt.lost = 0;

% some constant matrices
cdim  = [0 CDIM];

% Create lmk and locate in Map
Lmk        = landmarkInit(Rob,Cam,Obs,Dpt);
Pnt.loc    = Lmk.loc; % location of the point

% signature patch
Pnt.sig    = pix2patch(Cam.id,Obs.y,patchSize); % Signature patch
Pnt.wPatch = Pnt.sig;           % Wrapped patch
Pnt.Robi   = Rob; % Robot frame at first landmark detection

% observation and tracking things
Pnt.vis0    = 1;
Pnt.dUmax   = 0;
Pnt.matched = 1;
Pnt.updated = 1;
Pnt.lost    = 0;
Pnt.lostTh  = lostTh;
Pnt.del     = [];

% Camera dependent
for cam = 1:2

    if cam == Cam.id

        Pnt.Prj(cam).front   = 1;  % True for positive depths
        Pnt.Prj(cam).vis     = 1;  % True for visible members of ray
        Pnt.Prj(cam).matched = 1;     % Pnt matched
        Pnt.Prj(cam).updated = 1;     % Pnt updated
        Pnt.Prj(cam).lost    = 0;     % Counter of not-found observations

        Pnt.Prj(cam).y       = Obs.y; % measured pixel

        Pnt.Prj(cam).u       = Obs.y; % Projection or expectation
        Pnt.Prj(cam).U       = Obs.R; % Projection's covariances matrices

        Pnt.Prj(cam).dU      = 0;     % Projection's covariance determinant
        Pnt.Prj(cam).z       = 0;  % Innovation
        Pnt.Prj(cam).Z       = Obs.R; % Innovation's covariances matrix
        Pnt.Prj(cam).iZ      = 0; % Inverse of innovation's covariance
        Pnt.Prj(cam).MD      = 0;  % Mahalanobis distances

        Pnt.Prj(cam).cPatch  = Pnt.sig; % Current patch


    else

        Pnt.Prj(cam).front   = 0;  % True for positive depths
        Pnt.Prj(cam).vis     = 0;  % True for visible members of ray
        Pnt.Prj(cam).matched = 0;     % Pnt matched
        Pnt.Prj(cam).updated = 0;     % Pnt updated
        Pnt.Prj(cam).lost    = 0;     % Counter of not-found observations

    end
end


