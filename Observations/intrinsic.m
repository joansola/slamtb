function K = intrinsic(k)

% INTRINSIC Build intrinsic matrix

%   Copyright 2008-2009 Joan Sola @ LAAS-CNRS.

[u0,v0,au,av] = split(k);

K = [au 0 u0
     0 av v0
     0 0 1];










