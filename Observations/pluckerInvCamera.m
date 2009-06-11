function iK = pluckerInvCamera(k)

% PLUCKERINVCAMERA  Inverse Plucker projection matrix

iK = [...
    [           1/k(4),                0,              0]
    [                0,           1/k(3),              0]
    [ 1/k(3)*k(1)/k(4), 1/k(4)/k(3)*k(2),    1/k(3)/k(4)]]; 
