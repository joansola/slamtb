function R = emptyRay(ncam,Ng)

% EMPTYRAY  Create empty ray structure.
%   R = EMPTYRAY(NC) creates an structure with empty fields to
%   represent a ray R for the FIS-BICAM algorithm with NC cameras
%
%   R = EMPTYRAY(...,NG) accepts the maximum number of terms of
%   the ray to be specified in NG. This initializes all relevant
%   variables at the right size. The default is NG = 0

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


R.id      = [];   % identifier
R.used    = 0;    % set if used
R.Ng      = Ng;   % Maximum number of points
R.n       = Ng;   % Current number of points
R.loc     = [];   % locations in global Map

R.sig     = [];   % Signature patch
R.wPatch  = [];   % Warped patch
R.Robi    = [];   % Initial frame of the landmark

R.alpha   = [];   % Aspect ratio
R.beta    = [];   % Geometric base
R.gamma   = [];   % Rebalance factor
R.tau     = [];   % Pruning threshold

R.w       = z1Ng; % Weights
% R.rho     = z1Ng; % Federated coefficients

% R.s       = z1Ng; % Depth
% R.sr      = 1;    % Depth ratio from origin
% R.front   = z1Ng; % True for positive depths
R.vis0    = 0;    % True for visible ray
R.dUmax   = 0;    % Projection's covariance determinant
R.matched = 0;    % Ray matched
R.updated = 0;    % Ray updated
R.lost    = 0;    % Counter of not-found observations
R.found   = 0;    % Counter for found observations
R.lostTh  = [];   % Threshold for lost counter
R.pruned  = 0;    % flag for deletion from map

% For each camera, observation parameters
for nc=1:ncam
   if nc > 1 cdim = CDIM;else cdim = 0; end
   R.Prj(nc).Hr      = zeros(BDIM,PDIM,Ng); % Jacobian wrt robot frame
   R.Prj(nc).Hc      = zeros(BDIM,cdim,Ng); % Jacobian wrt camera frame
   R.Prj(nc).Hp      = zeros(BDIM,WDIM,Ng); % Jacobian wrt point position

   R.Prj(nc).front   = z1Ng;  % True for positive depths
   R.Prj(nc).vis     = z1Ng;  % True for visible members of ray
   R.Prj(nc).vis0    = 0;     % True for visible rays
   R.Prj(nc).matched = 0;     % Ray matched
   R.Prj(nc).updated = 0;     % Ray updated
   R.Prj(nc).lost    = 0;     % Counter of not-found observations
   R.Prj(ncam).found   = []; % Counter for found observations

   R.Prj(nc).y       = zeros(BDIM,1); % measured pixel
   R.Prj(nc).s       = z1Ng;  % Depths
   R.Prj(nc).s0      = 0;     % Weighted mean of depths
   R.Prj(nc).sr      = 1;     % estimated depths ratio (current to initial)
   R.Prj(nc).S       = z1Ng;  % Depths variances
   R.Prj(nc).u       = zBNg;  % Projection or expectation
   R.Prj(nc).u0      = zeros(BDIM,1); % Weighted mean of all projections
   R.Prj(nc).U       = zBBNg; % Projection's covariances matrices
   R.Prj(nc).dU      = z1Ng;  % Projection's covariance determinant
   R.Prj(nc).dUmax   = 0;     % Maximum determinant from above
   R.Prj(nc).z       = zeros(BDIM,1); % Innovation
   R.Prj(nc).Z       = zBBNg; % Innovation's covariances matrix
   R.Prj(nc).iZ      = zBBNg; % Inverse of innovation's covariance
   R.Prj(nc).MD      = z1Ng;  % Mahalanobis distances
   R.Prj(nc).li      = z1Ng;  % Likelihoods

   R.Prj(nc).region  = [];    % Parallelogram region for patch scan
   R.Prj(nc).cPatch  = [];    % Current  detected patch
   R.Prj(nc).sc      = -1;    % correlation score
end