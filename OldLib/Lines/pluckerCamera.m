function K = pluckerCamera(k)

% PLUCKERCAMERA  Build Plucker camera.
%   PLUCKERCAMERA(K) builds a Plucker camera matrix Kp from the intrinsic
%   parameters K so that a line L in P^5 projects into a line l in P^2 with
%   l = Kp*L.

K = [...
    [       k(4),          0,          0,      0,      0,      0]
    [          0,       k(3),          0,      0,      0,      0]
    [ -k(1)*k(4), -k(3)*k(2),  k(3)*k(4),      0,      0,      0]];


