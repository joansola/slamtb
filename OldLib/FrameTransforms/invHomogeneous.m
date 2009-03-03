function iH = invHomogeneous(f)

% INVHOMOGENEOUS Inverse homogeneous motion matrix from vector frame

t = f(1:3);
q = f(4:7);

R = q2R(q);

iH = [R' -R'*t; 0 0 0 1];

