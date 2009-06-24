function [F,F_r,F_u] = odo3(F,u)

% ODO3 3D Odometry evolution.
%   F = ODO3(F,U) performs one step on the pose F of a vehicle, given
%   odometry increments U=[DX;DV] in robot frame.
%   - F is a frame structure (see FRAME).
%   - Position increment DX is given in robot frame F.
%   - Orientation increment DV is given as a Rotation Vector in robot frame F.
%
%   [F,F_r,F_u] = ODO3(F,U) gives the full Jacobians wrt state and odometry
%   inputs.
%
%   See also FRAME, V2Q, QPROD, QUATERNION.

%   (c) 2009 Joan Sola @ LAAS-CNRS.

dv = u(4:6);
dx = u(1:3);

if nargout == 1

    x = fromFrame(F,dx); % Position update

    q  = F.x(4:end);
    q2 = qProd(q,v2q(dv)); % quaternion update

    F.x = [x;q2]; % frame update


else  % Jacobians

    [x,X_r,X_dx] = fromFrame(F,dx); % Position update and jacobians

    q               = F.x(4:end);
    [dq,DQ_dv]      = v2q(dv);
    [q2,Q2_q,Q2_dq] = qProd(q,dq); % quaternion update
    Q2_dv           = Q2_dq*DQ_dv;

    F.x = [x;q2]; % frame update

    F_r  = [X_r;zeros(4,3) Q2_q];
    F_u  = [X_dx zeros(3,3);zeros(4,3) Q2_dv];
end

F = updateFrame(F);

return

%% Jacobians

syms x y z a b c d real
syms dx dy dz dp dq dr real
Fi.x=[x;y;z;a;b;c;d];
Dx = [dx;dy;dz];
Dv = [dp;dq;dr];
u  = [Dx;Dv];

Fi = updateFrame(Fi);

[F,F_r,F_u] = odo3(Fi,u);

F_rs = jacobian(F.x,Fi.x);
F_us = jacobian(F.x,[Dx;Dv]);

simplify(F_r-F_rs)
simplify(F_u-F_us)
