function Idp = emptyIdp(ncam)

% EMPTYIDP  Create empty Idp structure.
%   Idp = EMPTYIDP(NC) creates an structure with empty fields to
%   represent a idp Idp for the FIS-BICAM algorithm with NC cameras

global PDIM CDIM BDIM IDIM

zB  = zeros(BDIM,1);
zBB = zeros(BDIM,BDIM);


Idp.id      = [];   % identifier
Idp.used    = 0;    % set if used
Idp.loc     = [];   % locations in global Map

Idp.sig     = [];   % Signature patch
Idp.Robi    = [];   % Initial frame of the landmark
Idp.Cami    = [];   % Initial camera
Idp.ui      = [];   % Initial detected pixel

Idp.rho     = [];
Idp.RHO     = [];

Idp.s       = 0; % Depth
Idp.sr      = 1; % Depth ratio from origin
Idp.vis0    = 0;
Idp.dUmax   = 0;
Idp.front   = 0; % True for positive depths
Idp.matched = 0;    % Idp matched
Idp.updated = 0;    % Idp updated
Idp.lost    = 0;    % Counter of not-found observations
Idp.lostTh  = [];   % Threshold for lost counter

% For each camera, observation parameters
for nc=1:ncam
    if nc > 1 
        cdim = CDIM;
    else
        cdim = 0;
    end
    
    Idp.Prj(nc).Hr      = zeros(BDIM,PDIM); % Jacobian wrt robot frame
    Idp.Prj(nc).Hc      = zeros(BDIM,cdim); % Jacobian wrt camera frame
    Idp.Prj(nc).Hi      = zeros(BDIM,IDIM); % Jacobian wrt idp

    Idp.Prj(nc).front   = 0;  % True for positive depths
    Idp.Prj(nc).vis     = 0;  % True for visible members of idp
    Idp.Prj(nc).matched = 0;     % Idp matched
    Idp.Prj(nc).updated = 0;     % Idp updated
    Idp.Prj(nc).lost    = 0;     % Counter of not-found observations

    Idp.Prj(nc).y       = zeros(BDIM,1); % measured pixel
    Idp.Prj(nc).s       = 0;   % Depth
    Idp.Prj(nc).sr      = 1;   % estimated depths ratio (current to initial)
    Idp.Prj(nc).d       = 0;   % Distance
    Idp.Prj(nc).dr      = 1;   % estimated distances ratio (current to initial)
    Idp.Prj(nc).rho     = 0;   % idp mean
    Idp.Prj(nc).RHO     = 0;   % idp variance
    Idp.Prj(nc).u       = zB;  % Projection or expectation
    Idp.Prj(nc).U       = zBB; % Projection's covariances matrices
    Idp.Prj(nc).dU      = 0;  % Projection's covariance determinant
    Idp.Prj(nc).z       = zB; % Innovation
    Idp.Prj(nc).Z       = zBB; % Innovation's covariances matrix
    Idp.Prj(nc).iZ      = zBB; % Inverse of innovation's covariance
    Idp.Prj(nc).MD      = 0;  % Mahalanobis distances
    Idp.Prj(nc).li      = 0;  % Likelihoods

    Idp.Prj(nc).region  = [];    % Parallelogram region for patch scan
    Idp.Prj(nc).cPatch  = [];    % Current  detected patch
    Idp.Prj(nc).wPatch  = [];   % Warped patch
    Idp.Prj(nc).sc      = -1;    % correlation score
    Idp.Prj(nc).UOui    = [];    % Jacobian wrt initial pixel
end