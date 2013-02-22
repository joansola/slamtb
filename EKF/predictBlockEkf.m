function predictBlockEkf(r,F_r,U,F_u)

% PREDICTBLOCKEKF  Covariance predict in block-defined EKF.
%   PREDICTBLIOCKEKF(r,F_r,U,F_u) performs a covariance prediction step to
%   global map Map by using the prediction Jacobian F_r, referring to range
%   r in the map, and perturbation covariances matrix U and Jacobian F_u.

%   Copyright 2008-2009 Joan Sola @ LAAS-CNRS.

global Map

m = Map.used; % caution: the range 'm' includes the range 'r'

Map.P(r,m) = F_r * Map.P(r,m);
Map.P(m,r) = Map.P(m,r) * F_r';
Map.P(r,r) = Map.P(r,r) + F_u * U * F_u';









