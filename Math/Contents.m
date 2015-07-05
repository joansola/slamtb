% Some mathematical functions.
%   This folder adds Jacobian support to existing Matlab functions, and
%   other functionnalities.
%
% Unit conversions
%   deg2rad              - Degrees to radians conversion.
%   rad2deg              - Radians to degrees conversion.
%
% Jacobian extensions to algebraic functions
%   crossJ               - Cross product with Jacobians output
%   dotJ                 - Dot product with Jacobian return
%   hat                  - Hat operator.
%   normAngle            - Normalize angle to (-pi .. pi] values.
%   normquat             - Normalize quaternion to unit length
%   normvec              - Normalize vector.
%   vecnorm              - Vector norm, with Jacobian
%   normalizevectors     - Script to test Gaussian vector normalization.
%
% Functions on Gaussian data
%   gauss                - Gaussian distribution value
%   mahalanobis          - Mahalanobis distance
%   propagateUncertainty - Non-linear propagation of Gaussian uncertainty.
%   nees                 - Normalized Estimation Error Squared.
%   chi2                 - Chi square distribution
%   robotNees            - Robot's normalized estimation error squared.
%   robotRmse            - Robot's estimation root mean squared error.
%
% Other function and test scripts
%   f21                  - F21, 2-input , 1-output MIMO function for linearity test purposes.
%   fun                  - 
%   linIdx               - 
%   linMat               - Linearity measure based on the quadratic Jacobian error.
%   linTest              - CNTRL + ENTER to execute (if you have cell mode activated)
%   linVec               - Linearity measure based on the propagation error vector.
%   symmetrize           - Make a matrix symmetric.
