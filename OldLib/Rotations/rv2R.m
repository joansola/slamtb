function R = rv2R(r)

% WARNING: Function being deprecated. Use v2R() instead.
%
% RV2R Rotation vector to rotation matrix conversion
%   RV2R(RV) computes the rotation matrix corresponding to the
%   rotation vector RV. Uses rodrigues formula

warning('Function being deprecated. Use v2R() instead.')

R = v2R(r);

