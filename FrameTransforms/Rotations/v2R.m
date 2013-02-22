function R = v2R(v)
% V2R Rotation vector to rotation matrix conversion
%   V2R(V) computes the rotation matrix corresponding to the
%   rotation vector V. Uses rodrigues formula.

[a,u] = v2au(v); % u is always a column vector, regardless of the charactrer of v.

% intermediate results
ca  = cos(a);
sau = sin(a)*u;

% R = cos(a)*eye(3) + sin(a)*hat(u) + (1-cos(a))*u*u'; A shortcut is:
R = diag([ca;ca;ca]) + hat(sau) + ((1-ca)*u)*u';










