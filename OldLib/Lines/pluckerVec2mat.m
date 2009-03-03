function L = pluckerVec2mat(l)

% PLUCKERVEC2MAT Plucker vector to Plucker matrix conversion.
%   PLUCKERVEC2MAT(L) is the matrix
%       [hat(n) -v
%         v'     0]
%   where n = L(1:3) and v = L(4:6);

n = l(1:3);
v = l(4:6);

L = [hat(n) -v ; v' 0];
