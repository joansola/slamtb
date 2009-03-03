function P = emptyPnt(ncam)

% EMPTYPNT  Create empty landmark structure.
%   P = EMPTYPNT(NC) creates an structure with empty fields to
%   represent a point P for the FIS-BICAM algorithm with NC
%   cameras

P.used    = 0; % Set if used
P.id      = []; % Identifier
P.sig     = []; % Signature patch
P.Robi    = []; % Initial frame of the landmark
P.Cami    = [];   % Initial camera
P.ui      = [];   % Initial detected pixel

P.loc     = []; % location in global Map
P.vis0    = 0; % True for visible points
P.s       = 0; % mean of depths
P.dUmax   = 0; % Determinant of expectation's covariance 
P.matched = 0; % Point matched
P.updated = 0; % Point updated
P.lost    = 0; % Counter of not-found observations
P.lostTh  = []; % Threshold for counter above
P.del     = 0; % flag for deletion from map

% For each camera, projection parameters
P.Prj(ncam).Hr      = []; % Jacobian wrt robot frame
P.Prj(ncam).Hc      = []; % Jacobian wrt camera frame
P.Prj(ncam).Hp      = []; % Jacobian wrt point position

P.Prj(ncam).front   = []; % True for positive depth
P.Prj(ncam).vis     = []; % True for visible points
P.Prj(ncam).matched = []; % Point matched
P.Prj(ncam).updated = []; % Point updated
P.Prj(ncam).lost    = []; % Counter of not-found observations

P.Prj(ncam).y       = []; % Measured pixel
P.Prj(ncam).s       = []; % Depth
P.Prj(ncam).sr      = []; % Depth ratio
P.Prj(ncam).S       = []; % Depth variance
P.Prj(ncam).d       = []; % Distance
P.Prj(ncam).dr      = []; % distances ratio
P.Prj(ncam).u       = []; % Expectation
P.Prj(ncam).U       = []; % Expectation's covariances matrix
P.Prj(ncam).dU      = []; % Determinant of expectation's covariance 
P.Prj(ncam).z       = []; % Innovation
P.Prj(ncam).Z       = []; % Innovation's covariances matrix
P.Prj(ncam).iZ      = []; % Inverse of innovation's covariance
P.Prj(ncam).MD      = []; % Mahalanobis distance

P.Prj(ncam).region  = []; % Parallelogram region for scan
P.Prj(ncam).cPatch  = []; % current patch
P.Prj(ncam).wPatch  = [];   % Warped patch
P.Prj(ncam).sc      = []; % correlation score
P.Prj(ncam).UOui    = [];    % Jacobian wrt initial pixel

