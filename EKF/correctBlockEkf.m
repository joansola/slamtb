function correctBlockEkf(r,H,Inn)

% CORRECTBLOCKEKF  Correct in block-defined EKF.
%   CORRECTBLIOCKEKF(r,H,INN) performs a correction step to global map Map
%   by using the observation Jacobian H, referring to range r in the map,
%   and innovation INN. 
%
%   INN is a structure containing:
%       .z      the innovation,         z  = y-h(x)
%       .Z      its covariances matrix, Z  = HPH' + R
%       .iZ     the inverse covariance, iZ = Z^-1.

%   Copyright 2008-2009 Joan Sola @ LAAS-CNRS.

global Map

% Kalman gain
K = Map.P(Map.used,r) * H' * Inn.iZ;   % K = PH'Z^-1

% mean and cov. updates
Map.x(Map.used)          = Map.x(Map.used) + K*Inn.z;
Map.P(Map.used,Map.used) = Map.P(Map.used,Map.used) - K*Inn.Z*K';
