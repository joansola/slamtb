function R = emptyRay()

% EMPTYRAY  Create empty ray structure.
%   R = EMPTYRAY creates an structure with empty fields to
%   represent a ray R for the FIS-SLAM algorithm

R.used    = []; % set if used
R.id      = []; % identifier
R.sig     = []; % Signature patch
R.cPatch  = []; % Current patch
R.wPatch  = []; % Wrapped patch
R.Robi    = []; % Initial frame of the landmark

R.sc      = []; % correlation score
R.sch     = []; % scores history
R.scp     = []; % scores pointer
R.scl     = []; % scores history length
R.scavg   = []; % averaged score
R.scstd   = []; % std dev. of score

R.alpha   = []; % Aspect ratio
R.beta    = []; % Geometric base
R.gamma   = []; % Rebalance factor
R.tau     = []; % Pruning threshold
R.lostTh  = []; % Threshold for lost counter

R.Ng      = []; % Maximum number of terms
R.n       = []; % Current number of points
R.loc     = []; % locations in global Map
R.front   = []; % True for positive depths
R.vis     = []; % True for visible members of ray
R.vis0    = []; % True for visible rays

R.Hr      = []; % Jacobian wrt robot frame
R.Hc      = []; % Jacobian wrt camera frame
R.Hp      = []; % Jacobian wrt point position

R.y       = []; % measured pixel

R.s       = []; % Depths
R.s0      = []; % Weighted mean of depths
R.sr      = []; % estimated depths ratio (current to initial)
R.S       = []; % Depths variances
R.u       = []; % Projection or expectation
R.u0      = []; % Weighted mean of all projections
R.U       = []; % Projection's covariances matrix
R.dU      = []; % Projection's covariance determinant
R.dUmax   = []; % Maximum determinant from above
R.z       = []; % Innovation
R.Z       = []; % Innovation's covariances matrix
R.iZ      = []; % Inverse of innovation's covariance
R.MD      = []; % Mahalanobis distances
R.li      = []; % Likelihoods
R.w       = []; % Weights
R.rho     = []; % Federated coefficients
R.region  = []; % Parallelogram region

R.matched = []; % Ray matched
R.updated = []; % Ray updated
R.lost    = []; % Counter of not-found observations
R.pruned  = []; % flag for deletion from map
