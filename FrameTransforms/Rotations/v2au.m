function [a,u,Av,Uv] = v2au(v)

%V2AU Rotation vector to rotation axis and angle conversion.
%   [ALPHA,U] = R2AU(V) converts the rotation vector V into its
%   equivalent axis unity vector U and the rotated angle ALPHA
%
%   [ALPHA,U,Av,Uv] = V2AU(...) returns the Jacobians of ALPHA and U wrt V.
%
% Note: it used to be r2av but confusion with possible R2av led to name change

v = v(:);
a = sqrt(dot(v,v));

s = whos('a');

if (strcmp(s.class,'sym')) || (a>eps)
    u = v/a;
    if nargout > 2
        Av = u';
        Uv = [...
            [ 1/a-u(1)^2/a,  -u(1)/a*u(2), -u(1)/a*u(3) ]
            [ -u(1)/a*u(2),  1/a-u(2)^2/a, -u(2)/a*u(3) ]
            [ -u(1)/a*u(3),  -u(2)/a*u(3), 1/a-u(3)^2/a ]];
    end

else
    a  = 0;
    u  = [0;0;0];
    if nargout > 2
        warning('TODO: revise Jacobian')
        Av = [0 0 0];
        Uv = zeros(3);
    end
end

return

%% jac
syms u v w real
rv = [u;v;w];
[a,u,Av,Au] = v2au(rv)

Av - jacobian(a,rv)
Au - jacobian(u,rv)










