function [p0,P0l] = lineOrigin(L)

n = L(1:3);
v = L(4:6);

if nargout == 1

    f = cross(v,n);
    g = dot(v,v);

    p0 = f/g;

else % Jac
    % numerator
    [f,Fv,Fn] = crossJ(v,n);
    % denominator
    g  = dot(v,v);
    Gv = 2*v';

    % 3D point
    p0 = f/g;

    % Jacobians wrt n and v
    P0n = Fn/g;
    P0v = (Fv*g - f*Gv)/g^2;

    % full Jacobian
    P0l = [P0n P0v];
end

return

%%

syms nx ny nz vx vy vz real
L = [nx;ny;nz;vx;vy;vz];
[p0,P0l] = lineOrigin(L);

P0l
jacobian(p0,L)

simplify(P0l-jacobian(p0,L))