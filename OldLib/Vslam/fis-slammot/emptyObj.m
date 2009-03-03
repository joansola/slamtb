function Obj = emptyObj(ncam)

% EMPTYOBJ  Create empty object structure.
%   O = EMPTYOBJ(NC) creates an structure with empty fields to
%   represent an object O for the FIS-BICAM-MOT algorithm with NC
%   cameras

global WDIM  PDIM CDIM BDIM

Obj.used    = 0; % Set if used
Obj.id      = []; % Identifier
Obj.sig     = []; % Signature patch
Obj.wPatch  = []; % Wrapped patch
Obj.Robi    = []; % Initial robot pose
Obj.si      = []; % Initial depth of the landmark CHECK

Obj.x       = []; % Mean --position and speed [6x1]
Obj.P       = []; % Covariances matrix [6x6]

Obj.w       = []; % speed perturbation [3x1]
Obj.W       = []; %   "        "       covariances matrix [3x3]

Obj.xW      = []; % Object state in world frame
Obj.PrW     = []; % Object position's covariances in world frame

Obj.vis0    = 0; % True if visible 
Obj.s       = 0; % mean of depths
Obj.dUmax   = 0; % Determinant of expectation's covariance 
Obj.matched = 0; % Object matched
Obj.updated = 0; % Object updated
Obj.lost    = 0; % Counter of not-found observations
Obj.found   = 0; % Counter for found observations
Obj.lostTh  = []; % Threshold for counter above
Obj.del     = 0; % flag for deletion

% For each camera, projection parameters
Obj.Prj(ncam).Hc      = []; % Jacobian wrt camera frame
Obj.Prj(ncam).Ho      = []; % Jacobian wrt obj position

Obj.Prj(ncam).front   = []; % True for positive depth
Obj.Prj(ncam).vis     = []; % True for visible points
Obj.Prj(ncam).matched = []; % Point matched
Obj.Prj(ncam).updated = []; % Point updated
Obj.Prj(ncam).lost    = []; % Counter of not-found observations
Obj.Prj(ncam).found   = []; % Counter for found observations

Obj.Prj(ncam).y       = []; % Measured pixel
Obj.Prj(ncam).s       = []; % Depth
Obj.Prj(ncam).sr      = []; % Depth ratio
Obj.Prj(ncam).S       = []; % Depth variance
Obj.Prj(ncam).u       = []; % Expectation
Obj.Prj(ncam).U       = []; % Expectation's covariances matrix
Obj.Prj(ncam).dU      = []; % Determinant of expectation's covariance 
Obj.Prj(ncam).z       = []; % Innovation
Obj.Prj(ncam).Z       = []; % Innovation's covariances matrix
Obj.Prj(ncam).iZ      = []; % Inverse of innovation's covariance
Obj.Prj(ncam).MD      = []; % Mahalanobis distance

Obj.Prj(ncam).region  = []; % Parallelogram region for scan
Obj.Prj(ncam).cPatch  = []; % current patch
Obj.Prj(ncam).sc      = []; % correlation score

