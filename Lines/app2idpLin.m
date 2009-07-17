function idl = app2idpLin(p0,p1,p2)

% APP2IDL Anchor and points to inverse depth line conversion.
%   APP2IDL(P0,P1,P2) converts the line passing by the points P1 and P2
%   into the inverse-depth line anchored at point P0. the inverse depth
%   line is coded as
%
%       [P0;M1;R1;M2;R2]
%
%   where
%       P0 is the anchor point
%       Mi are the pitch and yaw director angles of the ray P0-Pi
%       Ri is the inverse of the distance from P0 to Pi

%   (c) 2009 Joan Sola @ LAAS-CNRS.

% the director rays vectors
v1 = p1-p0;
v2 = p2-p0;

%The director rays angles
m1 = vec2py(v1);
m2 = vec2py(v2);

% The inverse of the distances
r1 = 1/norm(v1);
r2 = 1/norm(v2);

% the inverse-depth line
idl = [p0;m1;r1;m2;r2];
