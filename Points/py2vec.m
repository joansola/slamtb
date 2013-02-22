function [v,Vpy] = py2vec(py)

% PY2VEC  Pitch and yaw to 3D direction vector.
%   V = PY2VEC(PY) returns a unit direction vector V with the pitch and yaw
%   given in input vector PY.
%
%   [V,Vpy] = PY2VEC(...) returns also the Jacobian wrt PY.

%   Copyright 2008-2009 Joan Sola @ LAAS-CNRS.

p = py(1,:);
y = py(2,:);

v = [cos(p).*cos(y)
    cos(p).*sin(y)
    sin(p)];

if size(py,2) ==1 && nargout > 1 % we want jacobians
    Vpy = [...
        [ -sin(p)*cos(y), -cos(p)*sin(y)]
        [ -sin(p)*sin(y),  cos(p)*cos(y)]
        [         cos(p),              0]];

end

return

%% build jacobians

syms p y real
py  = [p;y];
v   = py2vec(py);
Vpy = simple(jacobian(v,py))








