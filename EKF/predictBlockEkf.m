function predictBlockEkf(r,F_r,U,F_u)

% PREDICTBLOCKEKF  Covariance predict in block-defined EKF.
%   PREDICTBLIOCKEKF(r,F_r,U,F_u) performs a covariance prediction step to
%   global map Map by using the prediction Jacobian F_r, referring to range
%   r in the map, and perturbation covariances matrix U and Jacobian F_u.

global Map

m = Map.used;

Map.P(r,m) = F_r * Map.P(r,m);
Map.P(m,r) = Map.P(m,r) * F_r';
Map.P(r,r) = Map.P(r,r) + F_u * U * F_u';
