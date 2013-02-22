function [n, N_v] = vecnorm(v)
% VECNORM Vector norm, with Jacobian
%   VECNORM(V) is the same as NORM(V)
%
%   [n, N_v] = VECNORM(V) returns also the Jacobian.

if nargout == 1
    n = sqrt(v'*v);
else
    n = sqrt(v'*v);
    N_v = v'/n;
end

end
%%
function f()

%%
syms v1 v2 real
v = [v1;v2];
[n,N_v] = vecnorm(v);
N_v - jacobian(n,v)

end








