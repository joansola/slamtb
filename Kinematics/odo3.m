function [Rob,Xr,Q2q,Xdx,Q2dv] = odo3(Rob,dx,dv)

% ODO3 3D Odometry evolution
%   R = ODO3(R,DX,DV) performs one step on the pose R of a vehicle, given
%   odometry increments DX and DV in robot frame.
%   - Orientation in R is given in quaternion.
%   - Orientation increment DV is given in Rotation Vector angles.
%   - R is a structure containing at least
%       X = [T;Q] : frame
%       R : rotation matrix
%
%   R = ODO3(R,U) accepts U=[dx;dv] as odometry input
%
%   [R,Xr,Qq,Xdx,Qdv] = ODO3(R,dx,dv) computes all the non-zero Jacobians
%   of ODO3.
%
%   [R,Fr,Fu] = ODO3(R,dx,dv) gives the full Jacobians wrt state and
%   odometry inputs.
%
%   See also V2Q, QPROD.

if nargin == 2
    dv = dx(4:6);
    dx = dx(1:3);
end

if nargout == 1

    x = fromFrame(Rob,dx); % Position update

    q  = Rob.x(4:end);
    q2 = qProd(q,v2q(dv)); % quaternion update

    Rob.x = [x;q2]; % frame update


else  % Jacobians

    [x,Xr,Xdx] = fromFrame(Rob,dx); % Position update and jacobians

    q             = Rob.x(4:end);
    [dq,DQdv]     = v2q(dv);
    [q2,Q2q,Q2dq] = qProd(q,dq); % quaternion update
    Q2dv          = Q2dq*DQdv;

    Rob.x = [x;q2]; % frame update

    if nargout <= 3 % build full Jacobians
        Fr  = [Xr;zeros(4,3) Q2q];
        Fu  = [Xdx zeros(3,3);zeros(4,3) Q2dv];

        Xr  = Fr; % assign to output (names conflict)
        Q2q = Fu;
    end
end

Rob = updateFrame(Rob);

return

%% Jac
syms x y z a b c d real
syms dx dy dz dp dq dr real
Rob.x=[x;y;z;a;b;c;d];
Dx = [dx;dy;dz];
Dv = [dp;dq;dr];

Rob = updateFrame(Rob);

[R,Rr,Ru] = odo3(Rob,Dx,Dv);

Rrs = jacobian(R.x,Rob.x);
Rus = jacobian(R.x,[Dx;Dv]);

simplify(Rr-Rrs)
simplify(Ru-Rus)



