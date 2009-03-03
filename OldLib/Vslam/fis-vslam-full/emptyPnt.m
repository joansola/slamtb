function P = emptyPnt()

% EMPTYPNT  Create empty landmark structure.
%   P = EMPTYPNT creates an structure with empty fields to
%   represent a point P for the FIS-SLAM algorithm

P.used    = []; % Set if used
P.id      = []; % Identifier
P.sig     = []; % Signature patch
P.cPatch  = []; % current patch
P.wPatch  = []; % Wrapped patch
P.Robi    = []; % Initial frame of the landmark

P.sc      = []; % correlation score
P.sch     = []; % scores history
P.scp     = []; % scores pointer
P.scl     = []; % scores history length
P.scavg   = []; % averaged score
P.scstd   = []; % std dev. of score

P.loc     = []; % location in global Map
P.front   = []; % True for positive depth
P.vis     = []; % True for visible points

P.Hr      = []; % Jacobian wrt robot frame
P.Hc      = []; % Jacobian wrt camera frame
P.Hp      = []; % Jacobian wrt point position

P.y       = []; % Measured pixel

P.s       = []; % Depth
P.sr      = []; % Depth ratio (current to initial)
P.S       = []; % Depth variance
P.u       = []; % Expectation
P.U       = []; % Expectation's covariances matrix
P.dU      = []; % Determinant of expectation's covariance 
P.z       = []; % Innovation
P.Z       = []; % Innovation's covariances matrix
P.iZ      = []; % Inverse of innovation's covariance
P.MD      = []; % Mahalanobis distance
P.region  = []; % Parallelogram region for scan

P.matched = []; % Point matched
P.updated = []; % Point updated
P.lost    = []; % Counter of not-found observations
P.lostTh  = []; % Threshold for counter above
P.del     = []; % flag for deletion from map
