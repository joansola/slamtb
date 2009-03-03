function Idp = emptyIdp(ncam,Ng)

% EMPTYIDP  Create empty Idp structure.
%   Idp = EMPTYIDP(NC) creates an structure with empty fields to
%   represent a idp Idp for the FIS-BICAM algorithm with NC cameras

global WDIM  PDIM CDIM BDIM

if nargin < 2
    Ng = 0;
end

z1Ng  = zeros(1,Ng);
zNg1  = zeros(Ng,1);
zWNg  = zeros(WDIM,Ng);
zNgW  = zeros(Ng,WDIM);
zBNg  = zeros(BDIM,Ng);
zNgB  = zeros(Ng,BDIM);
zBBNg = zeros(BDIM,BDIM,Ng);


Idp.id      = [];   % identifier
Idp.used    = 0;    % set if used
Idp.Ng      = Ng;   % Maximum number of points
Idp.n       = Ng;   % Current number of points
Idp.loc     = [];   % locations in global Map

Idp.sig     = [];   % Signature patch
Idp.wPatch  = [];   % Warped patch
Idp.Robi    = [];   % Initial frame of the landmark

Idp.alpha   = [];   % Aspect ratio
Idp.beta    = [];   % Geometric base
Idp.gamma   = [];   % Rebalance factor
Idp.tau     = [];   % Pruning threshold

Idp.w       = z1Ng; % Weights
% Idp.rho     = z1Ng; % Federated coefficients

% Idp.s       = z1Ng; % Depth
% Idp.sr      = 1;    % Depth ratio from origin
% Idp.front   = z1Ng; % True for positive depths
Idp.vis0    = 0;    % True for visible idp
Idp.dUmax   = 0;    % Projection's covariance determinant
Idp.matched = 0;    % Idp matched
Idp.updated = 0;    % Idp updated
Idp.lost    = 0;    % Counter of not-found observations
Idp.lostTh  = [];   % Threshold for lost counter
Idp.pruned  = 0;    % flag for deletion from map

% For each camera, observation parameters
for nc=1:ncam
    if nc > 1 cdim = CDIM;else cdim = 0; end
    Idp.Prj(nc).Hr      = zeros(BDIM,PDIM,Ng); % Jacobian wrt robot frame
    Idp.Prj(nc).Hc      = zeros(BDIM,cdim,Ng); % Jacobian wrt camera frame
    Idp.Prj(nc).Hp      = zeros(BDIM,WDIM,Ng); % Jacobian wrt point position

    Idp.Prj(nc).front   = z1Ng;  % True for positive depths
    Idp.Prj(nc).vis     = z1Ng;  % True for visible members of idp
    Idp.Prj(nc).vis0    = 0;     % True for visible idps
    Idp.Prj(nc).matched = 0;     % Idp matched
    Idp.Prj(nc).updated = 0;     % Idp updated
    Idp.Prj(nc).lost    = 0;     % Counter of not-found observations

    Idp.Prj(nc).y       = zeros(BDIM,1); % measured pixel
    Idp.Prj(nc).s       = z1Ng;  % Depths
    Idp.Prj(nc).s0      = 0;     % Weighted mean of depths
    Idp.Prj(nc).sr      = 1;     % estimated depths ratio (current to initial)
    Idp.Prj(nc).S       = z1Ng;  % Depths variances
    Idp.Prj(nc).u       = zBNg;  % Projection or expectation
    Idp.Prj(nc).u0      = zeros(BDIM,1); % Weighted mean of all projections
    Idp.Prj(nc).U       = zBBNg; % Projection's covariances matrices
    Idp.Prj(nc).dU      = z1Ng;  % Projection's covariance determinant
    Idp.Prj(nc).dUmax   = 0;     % Maximum determinant from above
    Idp.Prj(nc).z       = zeros(BDIM,1); % Innovation
    Idp.Prj(nc).Z       = zBBNg; % Innovation's covariances matrix
    Idp.Prj(nc).iZ      = zBBNg; % Inverse of innovation's covariance
    Idp.Prj(nc).MD      = z1Ng;  % Mahalanobis distances
    Idp.Prj(nc).li      = z1Ng;  % Likelihoods

    Idp.Prj(nc).region  = [];    % Parallelogram region for patch scan
    Idp.Prj(nc).cPatch  = [];    % Current  detected patch
    Idp.Prj(nc).sc      = -1;    % correlation score
end