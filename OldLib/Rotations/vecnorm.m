function [n,Nv] = vecnorm(v)

% VECNORM Euclidean norm of a vector, with Jacobians
%   N = VECNORM(V) is the norm-2 of V, equivalent to NORM(V) with V
%   a vector.
%
%   [N,Nv] = (...) returns the Jacobian wrt the input vector V.

n = sqrt(dot(v,v));

if nargout > 1

    if n > 1e-20
        Nv = v'/n;
    else
        Nv = normvec(ones(size(v')));
    end

end

return

%%
syms v1 v2 v3 v4 real
v=[v1;v2;v3;v4];

[n,Nv] = vecnorm(v);

simplify(Nv - jacobian(n,v))

%%
v = normvec([1;2;3;4]);
v1 = (1e-20+1e-21)*v;
v2 = (1e-20-1e-21)*v;
[n1,Nv1] = vecnorm(v1);
[n2,Nv2] = vecnorm(v2);
Nv1
Nv2
