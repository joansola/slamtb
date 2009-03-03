function Idp = idpInit(id,Idp,Rob,Cam,Obs,Rho,patchSize,lostTh)

% IDPINIT  Idp fields filler.
%   IDP = IDPINIT(IDP,ROB,CAM,OBS,RHO,PATCHSIZE,LOSTIDPTH) fills all
%   appropiate fields in structure IDP, resulting from the inverse depth
%   initialization after an observation OBS from a camera CAM mounted on a
%   robot ROB. The ray is defined with a nominal inverse depth RHO. The descriptor
%   is a patch of size PATCHSIZExPATCHSIZE. A counter limit of match fails
%   for tracking purposes can be defined with LOSTIDPTH. Default ray
%   parameters are supported:
%       RHO.rho   = 1  - nominal ID
%       RHO.RHO   = 1  - ID variance
%       PATCHSIZE = 15
%       LOSTIDPTH = 5
%
%   Use IDPINIT to initialize the IDP into the Map.
%
%   See also INPINIT, LANDMARKINIT

global Image Map WDIM PDIM CDIM BDIM IDIM


% set defaults
if nargin < 8
    lostTh = 5;
    if nargin < 7
        patchSize = 15;
        if nargin < 6
            Rho.rho = 1;
            Rho.RHO = 1;
            if nargin < 5
                error('Not enough input arguments.')
            end
        end
    end
end

% some constants
zB  = zeros(BDIM,1);
zBB = zeros(BDIM,BDIM);

% usage
Idp.id   = id;
Idp.used = true;

% some constant matrices
% cdim  = [0 CDIM];

% signature patch
Idp.sig    = pix2patch(Cam.id,Obs.y,patchSize); % Signature patch
Idp.Robi   = Rob; % Robot frame at first landmark detection
Idp.Cami   = Cam; % Camera pose
Idp.ui     = Obs.y;

Idp.rho = Rho.rho;
Idp.RHO = Rho.RHO;
Idp.s   = 1/Rho.rho;

% observation and tracking things
Idp.vis0    = 1;
Idp.dUmax   = 0;
Idp.matched = 1;
Idp.updated = 1;
Idp.lost    = 0;
Idp.lostTh  = lostTh;

% Camera dependent
for cam = 1:2

    if cam == Cam.id % the camera we initialize from

        % depths things
        Idp.Prj(cam).Hr      = zeros(BDIM,PDIM); % Jacobian wrt robot frame
        Idp.Prj(cam).Hc      = zeros(BDIM,CDIM); % Jacobian wrt camera frame
        Idp.Prj(cam).Hi      = zeros(BDIM,IDIM); % Jacobian wrt idp

        Idp.Prj(cam).front   = 1;     % True for positive depths
        Idp.Prj(cam).vis     = 1;     % True for visible members of ray
        Idp.Prj(cam).matched = 1;     % Idp matched
        Idp.Prj(cam).updated = 1;     % Idp updated
        Idp.Prj(cam).lost    = 0;     % Counter of not-found observations

        Idp.Prj(cam).y       = Obs.y; % measured pixel
        Idp.Prj(cam).s       = 1/Rho.rho;  % Depth
        Idp.Prj(cam).sr      = 1;     % estimated depths ratio (current to initial)
        Idp.Prj(cam).rho     = Rho.rho; % inverse depth
        Idp.Prj(cam).RHO     = Rho.RHO; % ID variance

        Idp1                 = idpMapInit(Rob,Cam,Obs,Rho);
        Idp.loc              = Idp1.loc; % location of the point
        Idp.Prj(cam).u       = Obs.y; % Projection or expectation
        Idp.Prj(cam).U       = Obs.R; % Projection's covariances matrices
        Idp.Prj(cam).Z       = Obs.R; % Innovation's covariances matrix

        Idp.Prj(cam).dU      = 0;  % Projection's covariance determinant
        Idp.Prj(cam).z       = zB;  % Innovation
        Idp.Prj(cam).iZ      = zBB; % Inverse of innovation's covariance
        Idp.Prj(cam).MD      = 0;  % Mahalanobis distances
        Idp.Prj(cam).li      = 0;  % Likelihoods

        Idp.Prj(cam).region  = [];    % Parallelogram region for patch scan
        Idp.Prj(cam).cPatch  = Idp.sig; % Current patch
        Idp.Prj(cam).wPatch  = Idp.sig;           % Wrapped patch
        Idp.Prj(cam).sc      = 1;       % score


    else % the other camera

        Idp.Prj(cam).Hr      = zeros(BDIM,PDIM); % Jacobian wrt robot frame
        Idp.Prj(cam).Hc      = zeros(BDIM,CDIM); % Jacobian wrt camera frame
        Idp.Prj(cam).Hp      = zeros(BDIM,WDIM); % Jacobian wrt point position

        Idp.Prj(cam).front   = 0;  % True for positive depths
        Idp.Prj(cam).vis     = 0;  % True for visible members of ray
        Idp.Prj(cam).matched = 0;     % Idp matched
        Idp.Prj(cam).updated = 0;     % Idp updated
        Idp.Prj(cam).lost    = 0;     % Counter of not-found observations

        Idp.Prj(cam).y       = zeros(BDIM,1); % measured pixel
        Idp.Prj(cam).s       = 0;  % Depths
        Idp.Prj(cam).sr      = 1;     % estimated depths ratio (current to initial)
        Idp.Prj(cam).rho     = 0;     % inverse depth
        Idp.Prj(cam).RHO     = 0;     % ID variance
        Idp.Prj(cam).u       = zB;    % Projection or expectation
        Idp.Prj(cam).U       = zBB;   % Projection's covariances matrices
        Idp.Prj(cam).dU      = 0;    % Projection's covariance determinant
        Idp.Prj(cam).z       = zB;    % Innovation
        Idp.Prj(cam).Z       = zBB;   % Innovation's covariances matrix
        Idp.Prj(cam).iZ      = zBB;   % Inverse of innovation's covariance
        Idp.Prj(cam).MD      = 0;    % Mahalanobis distances
        Idp.Prj(cam).li      = 0;    % Likelihoods

        Idp.Prj(cam).region  = [];    % Parallelogram region for patch scan
        Idp.Prj(cam).cPatch  = [];    % Current  detected patch
        Idp.Prj(cam).wPatch  = Idp.sig;    % Wrapped patch
        Idp.Prj(cam).sc      = -1;    % correlation score

    end
end


