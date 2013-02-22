function iK = pluckerInvCamera(k)

% PLUCKERINVCAMERA  Inverse Plucker projection matrix

%   Copyright 2008-2009 Joan Sola @ LAAS-CNRS.

iK = [...
    [           1/k(4),                0,              0]
    [                0,           1/k(3),              0]
    [ 1/k(3)*k(1)/k(4), 1/k(4)/k(3)*k(2),    1/k(3)/k(4)]]; 









